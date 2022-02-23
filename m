Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063954C1F7C
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbiBWXQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiBWXQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:16:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D8858E54;
        Wed, 23 Feb 2022 15:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F6EB82249;
        Wed, 23 Feb 2022 23:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA67C340E7;
        Wed, 23 Feb 2022 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658171;
        bh=dKUEp8Ja5zuNdUtklDNOmkRUIMIrk0tU73atuFZaF1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZYN4igKqV7hfvfXieNsnoEnfNnyOiaPzX5FHj5YExv/OqHhuVQ1pJdApX/wV/eLM
         Ps+w12Su2eSEWxTt0pVq8o34Yc7zylU4GZvsj+vL4CiJYxEiUeUXG57/ZS86+tHrzJ
         wvod45GXJZyAj6CwQTdFqQ71m/SnJTvuHiw3XVHiZV8RXOgKnV7vEp02s2ThNBFCpy
         p6TMyWu7+jWIi0y/UHwFA92zpUaY9PRazUlBSq3vc7NueUHSEjAueCtP/knNIq+LaW
         cYK6e6uFDz1qHUEueYgRiv6nfR5qvZMXgpUlqjbWxAuTRltYERxcmAtlJfyTiqqAyk
         SemuTINnMhS3w==
Date:   Wed, 23 Feb 2022 15:16:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io, dwmw@amazon.co.uk,
        acatan@amazon.com, graf@amazon.com, colmmacc@amazon.com,
        sblbir@amazon.com, raduweis@amazon.com, jannh@google.com,
        gregkh@linuxfoundation.org, tytso@mit.edu
Subject: Re: [PATCH RFC v1 1/2] random: add mechanism for VM forks to
 reinitialize crng
Message-ID: <YhbAOW/KbFW1CFkQ@sol.localdomain>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <20220223131231.403386-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223131231.403386-2-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 02:12:30PM +0100, Jason A. Donenfeld wrote:
> When a VM forks, we must immediately mix in additional information to
> the stream of random output so that two forks or a rollback don't
> produce the same stream of random numbers, which could have catastrophic
> cryptographic consequences. This commit adds a simple API, add_vmfork_
> randomness(), for that.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Jann Horn <jannh@google.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c  | 58 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/random.h |  1 +
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 536237a0f073..29d6ce484d15 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -344,6 +344,46 @@ static void crng_reseed(void)
>  	}
>  }
>  
> +/*
> + * This mixes unique_vm_id directly into the base_crng key as soon as
> + * possible, similarly to crng_pre_init_inject(), even if the crng is
> + * already running, in order to immediately branch streams from prior
> + * VM instances.
> + */
> +static void crng_vm_fork_inject(const void *unique_vm_id, size_t len)
> +{
> +	unsigned long flags, next_gen;
> +	struct blake2s_state hash;
> +
> +	/*
> +	 * Unlike crng_reseed(), we take the lock as early as possible,
> +	 * since we don't want the RNG to be used until it's updated.
> +	 */
> +	spin_lock_irqsave(&base_crng.lock, flags);
> +
> +	/*
> +	 * Also update the generation, while locked, as early as
> +	 * possible. This will mean unlocked reads of the generation
> +	 * will cause a reseeding of per-cpu crngs, and those will
> +	 * spin on the base_crng lock waiting for the rest of this
> +	 * operation to complete, which achieves the goal of blocking
> +	 * the production of new output until this is done.
> +	 */
> +	next_gen = base_crng.generation + 1;
> +	if (next_gen == ULONG_MAX)
> +		++next_gen;
> +	WRITE_ONCE(base_crng.generation, next_gen);
> +	WRITE_ONCE(base_crng.birth, jiffies);
> +
> +	/* This is the same formulation used by crng_pre_init_inject(). */
> +	blake2s_init(&hash, sizeof(base_crng.key));
> +	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
> +	blake2s_update(&hash, unique_vm_id, len);
> +	blake2s_final(&hash, base_crng.key);
> +
> +	spin_unlock_irqrestore(&base_crng.lock, flags);
> +}
[...]
> +/*
> + * Handle a new unique VM ID, which is unique, not secret, so we
> + * don't credit it, but we do mix it into the entropy pool and
> + * inject it into the crng.
> + */
> +void add_vmfork_randomness(const void *unique_vm_id, size_t size)
> +{
> +	add_device_randomness(unique_vm_id, size);
> +	crng_vm_fork_inject(unique_vm_id, size);
> +}
> +EXPORT_SYMBOL_GPL(add_vmfork_randomness);

I think we should be removing cases where the base_crng key is changed directly
besides extraction from the input_pool, not adding new ones.  Why not implement
this as add_device_randomness() followed by crng_reseed(force=true), where the
'force' argument forces a reseed to occur even if the entropy_count is too low?

- Eric

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C84C2120
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 02:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiBXBhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 20:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiBXBhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 20:37:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4FCB1D;
        Wed, 23 Feb 2022 17:36:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28B560FBE;
        Thu, 24 Feb 2022 01:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42EFC340E7;
        Thu, 24 Feb 2022 01:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645666063;
        bh=GaCSlaHuoL4PTPpbJsCAbmTac306bb0289J4Jyt/cCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uTcgqSuvreJcrt+GI6FBVbHvqWaCYHfJMDVKh298DN/yG74ijBRZPbgCEPe1SSnv/
         OWNZlqtpLMmtebO+jSPT2tI79bq0YuNY7TCpcI7JVvUMWiHVkyw4QJyvs554PKS8Y9
         yeoFqkpu8MIeywz1nC153jIcoBKg6MXsMzAJ7xfWz40z9BIrTiWEfyXzLNkkTmH71d
         VxV/se8WZF+3WlgLYOMUMoHBb8hqKl+jGYfrM0Apzfdb6Xs36lYJNKbnGn2Y0EWJ5g
         SkQ2b3jZVI8c5Be1KZMj0x+5uwbjyWJc1KApfl5lz867/+dPA75kgtSOxLR7uH/Cu6
         b7PtrA5RYslfw==
Date:   Wed, 23 Feb 2022 17:27:41 -0800
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
Message-ID: <YhbfDQ2ernjrRNRX@sol.localdomain>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <20220223131231.403386-2-Jason@zx2c4.com>
 <YhbAOW/KbFW1CFkQ@sol.localdomain>
 <CAHmME9oa_wE8_n8e5b=iM5v-s5dgyibm4vXMhwzc8zGd6VWZMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oa_wE8_n8e5b=iM5v-s5dgyibm4vXMhwzc8zGd6VWZMQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 01:54:54AM +0100, Jason A. Donenfeld wrote:
> On 2/24/22, Eric Biggers <ebiggers@kernel.org> wrote:
> > I think we should be removing cases where the base_crng key is changed
> > directly
> > besides extraction from the input_pool, not adding new ones.  Why not
> > implement
> > this as add_device_randomness() followed by crng_reseed(force=true), where
> > the
> > 'force' argument forces a reseed to occur even if the entropy_count is too
> > low?
> 
> Because that induces a "premature next" condition which can let that
> entropy, potentially newly acquired by a storm of IRQs at power-on, be
> bruteforced by unprivileged userspace. I actually had it exactly the
> way you describe at first, but decided that this here is the lesser of
> evils and doesn't really complicate things the way an intentional
> premature next would. The only thing we care about here is branching
> the crng stream, and so this does explicitly that, without having to
> interfere with how we collect entropy. Of course we *also* add it as
> non-credited "device randomness" so that it's part of the next
> reseeding, whenever that might occur.

Can you make sure to properly explain this in the code?

- Eric

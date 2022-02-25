Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB81E4C43A4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbiBYL2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239446AbiBYL11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:27:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1751AC29D;
        Fri, 25 Feb 2022 03:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF361B82F1B;
        Fri, 25 Feb 2022 11:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AB8C340FB;
        Fri, 25 Feb 2022 11:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645788375;
        bh=wzU3M2wR8N6ReWJ/Q5n9T+IQ6J/c41uNq6io2nvM+hE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oXJXqMtMjHQKw8ya3RKVksHPcEVUS9mYthZaQwg4YsV+ZHvA9y+xb6lIq58470mRa
         pbKfYgAY8dI0bCTjJnzSFQZq6UGCdliRokkwVRh0CgG9uAtP/l0UfMs9PBsy71HfMT
         d/q+zNzA9kPlO0XrR2xDlQAgpu4ojK/in5mkEndmcaS55zvSXqLF7lZt1F8e9GrI+Y
         5tdhG/z3NxB+Dh6zONoL1ZGA6WKb6LCeiKBamkV+dxGOk05rFoXBuGQ/DctOBGuzlg
         MetCIK4BYAXPnFb6C7WG0Pd5FmRGv7enYoF+6nqdzeeUo5Ok4DuLHteGdNX1J2Q2p6
         XmriU0DJCVOuA==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2d641c31776so29597127b3.12;
        Fri, 25 Feb 2022 03:26:15 -0800 (PST)
X-Gm-Message-State: AOAM533bEnjLjds0lvuCEjx6GFVw5T0w/eZbNMbcaPPXqGhKPXswF7qO
        vmNYz7CtWUIdL0lXXRC/uCVdE2kyS50VYEHMFuE=
X-Google-Smtp-Source: ABdhPJwIQZC9GDI5dYoHZxDvQWsfz96l2SZn3EH3J8+1jUaINvs7quVPjznmaJ/ej9wycL9PBKnx7quCWRYwgWRAJEQ=
X-Received: by 2002:a81:7d04:0:b0:2d0:d0e2:126f with SMTP id
 y4-20020a817d04000000b002d0d0e2126fmr6861642ywc.485.1645788374561; Fri, 25
 Feb 2022 03:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-2-Jason@zx2c4.com>
In-Reply-To: <20220224133906.751587-2-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 12:26:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGuh62A8=43NjSMLRkux_TCFULXtw5a1C5w=gy9A8dO6w@mail.gmail.com>
Message-ID: <CAMj1kXGuh62A8=43NjSMLRkux_TCFULXtw5a1C5w=gy9A8dO6w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] random: add mechanism for VM forks to reinitialize crng
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, dwmw@amazon.co.uk,
        Alexander Graf <graf@amazon.com>, colmmacc@amazon.com,
        raduweis@amazon.com, berrange@redhat.com,
        Laszlo Ersek <lersek@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, ben@skyportsystems.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Feb 2022 at 14:39, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> When a VM forks, we must immediately mix in additional information to
> the stream of random output so that two forks or a rollback don't
> produce the same stream of random numbers, which could have catastrophic
> cryptographic consequences. This commit adds a simple API, add_vmfork_
> randomness(), for that, by force reseeding the crng.
>
> This has the added benefit of also draining the entropy pool and setting
> its timer back, so that any old entropy that was there prior -- which
> could have already been used by a different fork, or generally gone
> stale -- does not contribute to the accounting of the next 256 bits.
>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Jann Horn <jannh@google.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/char/random.c  | 50 +++++++++++++++++++++++++++++-------------
>  include/linux/random.h |  1 +
>  2 files changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 9fb06fc298d3..e8b84791cefe 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -289,14 +289,14 @@ static DEFINE_PER_CPU(struct crng, crngs) = {
>  };
>
>  /* Used by crng_reseed() to extract a new seed from the input pool. */
> -static bool drain_entropy(void *buf, size_t nbytes);
> +static bool drain_entropy(void *buf, size_t nbytes, bool force);
>
>  /*
>   * This extracts a new crng key from the input pool, but only if there is a
> - * sufficient amount of entropy available, in order to mitigate bruteforcing
> - * of newly added bits.
> + * sufficient amount of entropy available or force is true, in order to
> + * mitigate bruteforcing of newly added bits.
>   */
> -static void crng_reseed(void)
> +static void crng_reseed(bool force)
>  {
>         unsigned long flags;
>         unsigned long next_gen;
> @@ -304,7 +304,7 @@ static void crng_reseed(void)
>         bool finalize_init = false;
>
>         /* Only reseed if we can, to prevent brute forcing a small amount of new bits. */
> -       if (!drain_entropy(key, sizeof(key)))
> +       if (!drain_entropy(key, sizeof(key), force))
>                 return;
>
>         /*
> @@ -406,7 +406,7 @@ static void crng_make_state(u32 chacha_state[CHACHA_STATE_WORDS],
>          * in turn bumps the generation counter that we check below.
>          */
>         if (unlikely(time_after(jiffies, READ_ONCE(base_crng.birth) + CRNG_RESEED_INTERVAL)))
> -               crng_reseed();
> +               crng_reseed(false);
>
>         local_lock_irqsave(&crngs.lock, flags);
>         crng = raw_cpu_ptr(&crngs);
> @@ -771,10 +771,10 @@ EXPORT_SYMBOL(get_random_bytes_arch);
>   *
>   * Finally, extract entropy via these two, with the latter one
>   * setting the entropy count to zero and extracting only if there
> - * is POOL_MIN_BITS entropy credited prior:
> + * is POOL_MIN_BITS entropy credited prior or force is true:
>   *
>   *     static void extract_entropy(void *buf, size_t nbytes)
> - *     static bool drain_entropy(void *buf, size_t nbytes)
> + *     static bool drain_entropy(void *buf, size_t nbytes, bool force)
>   *
>   **********************************************************************/
>
> @@ -832,7 +832,7 @@ static void credit_entropy_bits(size_t nbits)
>         } while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
>
>         if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
> -               crng_reseed();
> +               crng_reseed(false);
>  }
>
>  /*
> @@ -882,16 +882,16 @@ static void extract_entropy(void *buf, size_t nbytes)
>  }
>
>  /*
> - * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
> - * set the entropy count to zero (but don't actually touch any data). Only then
> - * can we extract a new key with extract_entropy().
> + * First we make sure we have POOL_MIN_BITS of entropy in the pool unless force
> + * is true, and then we set the entropy count to zero (but don't actually touch
> + * any data). Only then can we extract a new key with extract_entropy().
>   */
> -static bool drain_entropy(void *buf, size_t nbytes)
> +static bool drain_entropy(void *buf, size_t nbytes, bool force)
>  {
>         unsigned int entropy_count;
>         do {
>                 entropy_count = READ_ONCE(input_pool.entropy_count);
> -               if (entropy_count < POOL_MIN_BITS)
> +               if (!force && entropy_count < POOL_MIN_BITS)
>                         return false;
>         } while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
>         extract_entropy(buf, nbytes);
> @@ -915,6 +915,7 @@ static bool drain_entropy(void *buf, size_t nbytes)
>   *     void add_hwgenerator_randomness(const void *buffer, size_t count,
>   *                                     size_t entropy);
>   *     void add_bootloader_randomness(const void *buf, size_t size);
> + *     void add_vmfork_randomness(const void *unique_vm_id, size_t size);
>   *     void add_interrupt_randomness(int irq);
>   *
>   * add_device_randomness() adds data to the input pool that
> @@ -946,6 +947,10 @@ static bool drain_entropy(void *buf, size_t nbytes)
>   * add_device_randomness(), depending on whether or not the configuration
>   * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
>   *
> + * add_vmfork_randomness() adds a unique (but not necessarily secret) ID
> + * representing the current instance of a VM to the pool, without crediting,
> + * and then force-reseeds the crng so that it takes effect immediately.
> + *
>   * add_interrupt_randomness() uses the interrupt timing as random
>   * inputs to the entropy pool. Using the cycle counters and the irq source
>   * as inputs, it feeds the input pool roughly once a second or after 64
> @@ -1175,6 +1180,21 @@ void add_bootloader_randomness(const void *buf, size_t size)
>  }
>  EXPORT_SYMBOL_GPL(add_bootloader_randomness);
>
> +/*
> + * Handle a new unique VM ID, which is unique, not secret, so we
> + * don't credit it, but we do immediately force a reseed after so
> + * that it's used by the crng posthaste.
> + */
> +void add_vmfork_randomness(const void *unique_vm_id, size_t size)
> +{
> +       add_device_randomness(unique_vm_id, size);
> +       if (crng_ready()) {
> +               crng_reseed(true);
> +               pr_notice("crng reseeded due to virtual machine fork\n");
> +       }
> +}
> +EXPORT_SYMBOL_GPL(add_vmfork_randomness);
> +
>  struct fast_pool {
>         union {
>                 u32 pool32[4];
> @@ -1564,7 +1584,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
>                         return -EPERM;
>                 if (crng_init < 2)
>                         return -ENODATA;
> -               crng_reseed();
> +               crng_reseed(false);
>                 return 0;
>         default:
>                 return -EINVAL;
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 6148b8d1ccf3..51b8ed797732 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -34,6 +34,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
>  extern void add_interrupt_randomness(int irq) __latent_entropy;
>  extern void add_hwgenerator_randomness(const void *buffer, size_t count,
>                                        size_t entropy);
> +extern void add_vmfork_randomness(const void *unique_vm_id, size_t size);
>
>  extern void get_random_bytes(void *buf, size_t nbytes);
>  extern int wait_for_random_bytes(void);
> --
> 2.35.1
>

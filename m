Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB279B748
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbjIKUuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbjIKTGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 15:06:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9F0B1B6
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 12:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694459131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yukk2f6oqMsdHKjhoJE1WmcLNdeEJDKH4QDEs4EiGPg=;
        b=RukaH4huovX9rJuSekdg9NGrBo+B9J1vA3GQdCY4NSnwR3QZaiIF+RIKot/ccaAoPnWH+C
        4sHdVB8BgWSgLvk77K+j7pRNpPNjJ9WLaeXbpWyxj8VTtYjvCTGdZ+eTqKhA8hZ4F5UIeG
        qcwTxwxgKDMThm8TTVgPX3EmfxHPbJE=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-dp65qhMjMSq0L-sjQH7wJQ-1; Mon, 11 Sep 2023 15:05:30 -0400
X-MC-Unique: dp65qhMjMSq0L-sjQH7wJQ-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6c0f3675070so799063a34.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 12:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694459130; x=1695063930;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yukk2f6oqMsdHKjhoJE1WmcLNdeEJDKH4QDEs4EiGPg=;
        b=duyB5eaEviVhHJzgXNni/4Ms9UrCi+tH5M6u+FM74IVuiHxD4HXwgFhruxxv85XvVh
         IL5k8HDnQtWhMEIHQlbvTSa59sfNVTbpBqMgWKmm6gIUfqYmnD8ia1q5SBGzuC5mFKPr
         Xqld5UJFSqtIirTTab5qTDgl+55Av8VyHDz10dD8cwUkxuJtzBE0UMbddKzvBZ6T8xfR
         mqxq+itS42fofgKX/idNc3bPT8ncjveUU8QYmVRg2u37ljDcPWklh1d2MhgMBNVYq798
         QBTgElDrn82rrfwd2Is8UrDmGoYquTOr5B7IqZZ7gPdXwMxCcUtysTDo6flBKehsfvDd
         O+qw==
X-Gm-Message-State: AOJu0YxMVRoIBHPBo7mkkbUd4FVPYGIZNtk5YOmpyQ0vTfsegPWhAKXA
        vw13GX7ZShoyQ8hLJEFbBYZIs130DyfrqFUR3xfhVIwasYDYDV0nQ73SKvcCnbqRezVilSqXLQf
        bKOYQOqxkk3Wh
X-Received: by 2002:a9d:4e90:0:b0:6c0:abdd:a875 with SMTP id v16-20020a9d4e90000000b006c0abdda875mr11713391otk.18.1694459129879;
        Mon, 11 Sep 2023 12:05:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGStsqh389BzmE57cp5mD7HYmxQywTAlI0LrMmQ6OTXG7DZOO3hPQDzK0WcE6xAB/YEW7bphA==
X-Received: by 2002:a9d:4e90:0:b0:6c0:abdd:a875 with SMTP id v16-20020a9d4e90000000b006c0abdda875mr11713377otk.18.1694459129611;
        Mon, 11 Sep 2023 12:05:29 -0700 (PDT)
Received: from ?IPv6:2804:1b3:a803:c91:da45:7fbc:86c3:920a? ([2804:1b3:a803:c91:da45:7fbc:86c3:920a])
        by smtp.gmail.com with ESMTPSA id l17-20020a05683016d100b006b95392cf09sm3318989otr.33.2023.09.11.12.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 12:05:28 -0700 (PDT)
Message-ID: <5c082cb1fd306cb75abbcaa80229d791260f8756.camel@redhat.com>
Subject: Re: [PATCH V11 01/17] asm-generic: ticket-lock: Reuse
 arch_spinlock_t of qspinlock
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     guoren@kernel.org, paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, ajones@ventanamicro.com,
        jszhang@kernel.org, wefu@redhat.com, wuwei2016@iscas.ac.cn
Cc:     linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Date:   Mon, 11 Sep 2023 16:05:20 -0300
In-Reply-To: <20230910082911.3378782-2-guoren@kernel.org>
References: <20230910082911.3378782-1-guoren@kernel.org>
         <20230910082911.3378782-2-guoren@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2023-09-10 at 04:28 -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
>=20
> The arch_spinlock_t of qspinlock has contained the atomic_t val, which
> satisfies the ticket-lock requirement. Thus, unify the arch_spinlock_t
> into qspinlock_types.h. This is the preparation for the next combo
> spinlock.
>=20
> Signed-off-by: Guo Ren <guoren@kernel.org>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> ---
>  include/asm-generic/spinlock.h       | 14 +++++++-------
>  include/asm-generic/spinlock_types.h | 12 ++----------
>  2 files changed, 9 insertions(+), 17 deletions(-)
>=20
> diff --git a/include/asm-generic/spinlock.h b/include/asm-generic/spinloc=
k.h
> index 90803a826ba0..4773334ee638 100644
> --- a/include/asm-generic/spinlock.h
> +++ b/include/asm-generic/spinlock.h
> @@ -32,7 +32,7 @@
> =20
>  static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  {
> -	u32 val =3D atomic_fetch_add(1<<16, lock);
> +	u32 val =3D atomic_fetch_add(1<<16, &lock->val);
>  	u16 ticket =3D val >> 16;
> =20
>  	if (ticket =3D=3D (u16)val)
> @@ -46,31 +46,31 @@ static __always_inline void arch_spin_lock(arch_spinl=
ock_t *lock)
>  	 * have no outstanding writes due to the atomic_fetch_add() the extra
>  	 * orderings are free.
>  	 */
> -	atomic_cond_read_acquire(lock, ticket =3D=3D (u16)VAL);
> +	atomic_cond_read_acquire(&lock->val, ticket =3D=3D (u16)VAL);
>  	smp_mb();
>  }
> =20
>  static __always_inline bool arch_spin_trylock(arch_spinlock_t *lock)
>  {
> -	u32 old =3D atomic_read(lock);
> +	u32 old =3D atomic_read(&lock->val);
> =20
>  	if ((old >> 16) !=3D (old & 0xffff))
>  		return false;
> =20
> -	return atomic_try_cmpxchg(lock, &old, old + (1<<16)); /* SC, for RCsc *=
/
> +	return atomic_try_cmpxchg(&lock->val, &old, old + (1<<16)); /* SC, for =
RCsc */
>  }
> =20
>  static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
>  	u16 *ptr =3D (u16 *)lock + IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
> -	u32 val =3D atomic_read(lock);
> +	u32 val =3D atomic_read(&lock->val);
> =20
>  	smp_store_release(ptr, (u16)val + 1);
>  }
> =20
>  static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock=
)
>  {
> -	u32 val =3D lock.counter;
> +	u32 val =3D lock.val.counter;
> =20
>  	return ((val >> 16) =3D=3D (val & 0xffff));
>  }

This one seems to be different in torvalds/master, but I suppose it's becau=
se of
the requirement patches I have not merged.

> @@ -84,7 +84,7 @@ static __always_inline int arch_spin_is_locked(arch_spi=
nlock_t *lock)
> =20
>  static __always_inline int arch_spin_is_contended(arch_spinlock_t *lock)
>  {
> -	u32 val =3D atomic_read(lock);
> +	u32 val =3D atomic_read(&lock->val);
> =20
>  	return (s16)((val >> 16) - (val & 0xffff)) > 1;
>  }
> diff --git a/include/asm-generic/spinlock_types.h b/include/asm-generic/s=
pinlock_types.h
> index 8962bb730945..f534aa5de394 100644
> --- a/include/asm-generic/spinlock_types.h
> +++ b/include/asm-generic/spinlock_types.h
> @@ -3,15 +3,7 @@
>  #ifndef __ASM_GENERIC_SPINLOCK_TYPES_H
>  #define __ASM_GENERIC_SPINLOCK_TYPES_H
> =20
> -#include <linux/types.h>
> -typedef atomic_t arch_spinlock_t;
> -
> -/*
> - * qrwlock_types depends on arch_spinlock_t, so we must typedef that bef=
ore the
> - * include.
> - */
> -#include <asm/qrwlock_types.h>
> -
> -#define __ARCH_SPIN_LOCK_UNLOCKED	ATOMIC_INIT(0)
> +#include <asm-generic/qspinlock_types.h>
> +#include <asm-generic/qrwlock_types.h>
> =20
>  #endif /* __ASM_GENERIC_SPINLOCK_TYPES_H */

FWIW, LGTM:

Reviewed-by: Leonardo Bras <leobras@redhat.com>


Just a suggestion: In this patch I could see a lot of usage changes to
arch_spinlock_t, and only at the end I could see the actual change in the .=
h
file.

In cases like this, it looks nicer to see the .h file first.

I recently found out about this git diff.orderFile option, which helps to
achieve exactly this.

I use the following git.orderfile, adapted from qemu:

###########################################################################=
#
#
# order file for git, to produce patches which are easier to review
# by diffing the important stuff like interface changes first.
#
# one-off usage:
#   git diff -O scripts/git.orderfile ...
#
# add to git config:
#   git config diff.orderFile scripts/git.orderfile
#

MAINTAINERS

# Documentation
Documentation/*
*.rst
*.rst.inc

# build system
Kbuild
Makefile*
*.mak

# semantic patches
*.cocci

# headers
*.h
*.h.inc

# code
*.c
*.c.inc



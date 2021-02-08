Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B315312A1D
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 06:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBHFd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 00:33:57 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:39263 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhBHFd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 00:33:56 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DYvnN0MTLz9sS8;
        Mon,  8 Feb 2021 16:33:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612762392;
        bh=9rIlokdK+AByWUkDe961EHvrZ4GpKUcGdkxAKlqUIus=;
        h=Date:From:To:Cc:Subject:From;
        b=jKTK3dEb4B8MHacY4vlMYWGoziFVMMwLKpH2MnFHzzbgLA3IcblX5rFHG59kGvljI
         /rQWzlVirOB3E3XBzVb2qjcnM0VS2o+Dln4btLHS9dDY9x2pk8SxaeJy1hwiUkkKA8
         VnP1vph+JN7wc18VP7pxIOlD2xT8oEJ1Op3TyAIjzfLdU0/6aiVBD3/t9CJnnflfcY
         w6hNXiUox5fPac4+yon1eWedFFRHNZgCIDJLuVMXl58T0j6aZfdCzqFXsw1Xh+xz+Z
         usc+Kfvm5Z1MdweYgLYiSMKPaH978fbMduQ3rBXE6pRhvXtoazjeb40CkBE55vLJIt
         pYQOHKmj652hA==
Date:   Mon, 8 Feb 2021 16:33:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20210208163308.26c3c1c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c61//hhvxvgVY0ig/e=VO62";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/c61//hhvxvgVY0ig/e=VO62
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_add':
drivers/gpu/drm/i915/gvt/kvmgt.c:1706:12: error: passing argument 1 of 'spi=
n_lock' from incompatible pointer type [-Werror=3Dincompatible-pointer-type=
s]
 1706 |  spin_lock(&kvm->mmu_lock);
      |            ^~~~~~~~~~~~~~
      |            |
      |            rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  352 | static __always_inline void spin_lock(spinlock_t *lock)
      |                                       ~~~~~~~~~~~~^~~~
drivers/gpu/drm/i915/gvt/kvmgt.c:1715:14: error: passing argument 1 of 'spi=
n_unlock' from incompatible pointer type [-Werror=3Dincompatible-pointer-ty=
pes]
 1715 |  spin_unlock(&kvm->mmu_lock);
      |              ^~~~~~~~~~~~~~
      |              |
      |              rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  392 | static __always_inline void spin_unlock(spinlock_t *lock)
      |                                         ~~~~~~~~~~~~^~~~
drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_remove':
drivers/gpu/drm/i915/gvt/kvmgt.c:1740:12: error: passing argument 1 of 'spi=
n_lock' from incompatible pointer type [-Werror=3Dincompatible-pointer-type=
s]
 1740 |  spin_lock(&kvm->mmu_lock);
      |            ^~~~~~~~~~~~~~
      |            |
      |            rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  352 | static __always_inline void spin_lock(spinlock_t *lock)
      |                                       ~~~~~~~~~~~~^~~~
drivers/gpu/drm/i915/gvt/kvmgt.c:1749:14: error: passing argument 1 of 'spi=
n_unlock' from incompatible pointer type [-Werror=3Dincompatible-pointer-ty=
pes]
 1749 |  spin_unlock(&kvm->mmu_lock);
      |              ^~~~~~~~~~~~~~
      |              |
      |              rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  392 | static __always_inline void spin_unlock(spinlock_t *lock)
      |                                         ~~~~~~~~~~~~^~~~
drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_flush_slot':
drivers/gpu/drm/i915/gvt/kvmgt.c:1775:12: error: passing argument 1 of 'spi=
n_lock' from incompatible pointer type [-Werror=3Dincompatible-pointer-type=
s]
 1775 |  spin_lock(&kvm->mmu_lock);
      |            ^~~~~~~~~~~~~~
      |            |
      |            rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  352 | static __always_inline void spin_lock(spinlock_t *lock)
      |                                       ~~~~~~~~~~~~^~~~
drivers/gpu/drm/i915/gvt/kvmgt.c:1784:14: error: passing argument 1 of 'spi=
n_unlock' from incompatible pointer type [-Werror=3Dincompatible-pointer-ty=
pes]
 1784 |  spin_unlock(&kvm->mmu_lock);
      |              ^~~~~~~~~~~~~~
      |              |
      |              rwlock_t *
In file included from include/linux/wait.h:9,
                 from include/linux/pid.h:6,
                 from include/linux/sched.h:14,
                 from include/linux/ratelimit.h:6,
                 from include/linux/dev_printk.h:16,
                 from include/linux/device.h:15,
                 from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct=
 spinlock *'} but argument is of type 'rwlock_t *'
  392 | static __always_inline void spin_unlock(spinlock_t *lock)
      |                                         ~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors

Caused by commit

  531810caa9f4 ("KVM: x86/mmu: Use an rwlock for the x86 MMU")

I have used the kvm tree from next-20210204 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/c61//hhvxvgVY0ig/e=VO62
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAgzRQACgkQAVBC80lX
0Gw8iwf/d01iOYnYDHyTx9KmplUiLQNYjWelr0b83aGkewL7dIP5qTa25DQLm420
9qXXz9Cybpf7Xae9p4IznkRE1Q3GSCNe1964o8F5DMXgQBt52HDDYaT8dqLzcjvL
zLbtuDMOiOS8d/yXg2a0xJYDqUTrkIbiXLYF54NUicDUA2uZIvI7U37OJIPzEaeA
Y1+yibQeeJ4KPXFjuwDLEcloKAqLohtvMYUmQKefzOaQfEbQLjhVqeBHZtXL2JCz
OIk0cJMx2LnucpulurjNYdmdGJYFL+ZK+aluCZM66lYSKaWmNqf7u6u1yCRemLxv
Y80H25NAuVyjaFbzf2RDIxLUT8Aibw==
=AJwD
-----END PGP SIGNATURE-----

--Sig_/c61//hhvxvgVY0ig/e=VO62--

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789203678B4
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhDVEaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhDVEaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:30:04 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E726C06174A;
        Wed, 21 Apr 2021 21:29:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQkw52jX2z9sRf;
        Thu, 22 Apr 2021 14:29:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619065765;
        bh=S7qxoLL2mxanY8fwURHisQAFOqNZ2RlcleQrIk620V0=;
        h=Date:From:To:Cc:Subject:From;
        b=Zb6uhxXf2hONrLKwxnLkIbF2Sh2kwZ0g0r8Ao9o1gEKe2hi22rJ+UKrY7qx/+lhBS
         0SxKnMghLD48aYJwLfWYRGH2UivkhgElkf/PIusCXpLsueyOyG0jVcC1+e2jWEFUt9
         FtBDo/lSMROE6rNBk1Ttr9rioTueKzXyPhnEADnh1b/YjEirbeYCCezvYrQgP8UMVD
         xOPI3tI3yugflgV+oLf7ouegXMhY6x02gQW+/QN2G5ilMU+njl6v2BrjEiXVNdsouD
         9hVcmXD1YB6yljwJziisKZmq/PPouT7IMvB1xBFvDybQu4SUIA8//ypz/jSJA9ukpZ
         RwwwnQl9jZfcA==
Date:   Thu, 22 Apr 2021 14:29:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with Linus tree
Message-ID: <20210422142924.222f7216@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UWGrul2r5uq=eOZ..HZ8PST";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/UWGrul2r5uq=eOZ..HZ8PST
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  Documentation/virt/kvm/api.rst

between commit:

  b318e8decf6b ("KVM: x86: Protect userspace MSR filter with SRCU, and set =
atomically-ish")

from Linus tree and commit:

  24e7475f931a ("doc/virt/kvm: move KVM_CAP_PPC_MULTITCE in section 8")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/virt/kvm/api.rst
index 245d80581f15,fd4a84911355..000000000000
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@@ -3690,31 -3692,105 +3693,107 @@@ which is the maximum number of possibl
 =20
  Queues an SMI on the thread's vcpu.
 =20
- 4.97 KVM_CAP_PPC_MULTITCE
- -------------------------
+ 4.97 KVM_X86_SET_MSR_FILTER
+ ----------------------------
 =20
- :Capability: KVM_CAP_PPC_MULTITCE
- :Architectures: ppc
- :Type: vm
+ :Capability: KVM_X86_SET_MSR_FILTER
+ :Architectures: x86
+ :Type: vm ioctl
+ :Parameters: struct kvm_msr_filter
+ :Returns: 0 on success, < 0 on error
 =20
- This capability means the kernel is capable of handling hypercalls
- H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
- space. This significantly accelerates DMA operations for PPC KVM guests.
- User space should expect that its handlers for these hypercalls
- are not going to be called if user space previously registered LIOBN
- in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
+ ::
 =20
- In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
- user space might have to advertise it for the guest. For example,
- IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
- present in the "ibm,hypertas-functions" device-tree property.
+   struct kvm_msr_filter_range {
+   #define KVM_MSR_FILTER_READ  (1 << 0)
+   #define KVM_MSR_FILTER_WRITE (1 << 1)
+ 	__u32 flags;
+ 	__u32 nmsrs; /* number of msrs in bitmap */
+ 	__u32 base;  /* MSR index the bitmap starts at */
+ 	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+   };
 =20
- The hypercalls mentioned above may or may not be processed successfully
- in the kernel based fast path. If they can not be handled by the kernel,
- they will get passed on to user space. So user space still has to have
- an implementation for these despite the in kernel acceleration.
+   #define KVM_MSR_FILTER_MAX_RANGES 16
+   struct kvm_msr_filter {
+   #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+   #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+ 	__u32 flags;
+ 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+   };
 =20
- This capability is always enabled.
+ flags values for ``struct kvm_msr_filter_range``:
+=20
+ ``KVM_MSR_FILTER_READ``
+=20
+   Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+   indicates that a read should immediately fail, while a 1 indicates that
+   a read for a particular MSR should be handled regardless of the default
+   filter action.
+=20
+ ``KVM_MSR_FILTER_WRITE``
+=20
+   Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+   indicates that a write should immediately fail, while a 1 indicates that
+   a write for a particular MSR should be handled regardless of the default
+   filter action.
+=20
+ ``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
+=20
+   Filter both read and write accesses to MSRs using the given bitmap. A 0
+   in the bitmap indicates that both reads and writes should immediately f=
ail,
+   while a 1 indicates that reads and writes for a particular MSR are not
+   filtered by this range.
+=20
+ flags values for ``struct kvm_msr_filter``:
+=20
+ ``KVM_MSR_FILTER_DEFAULT_ALLOW``
+=20
+   If no filter range matches an MSR index that is getting accessed, KVM w=
ill
+   fall back to allowing access to the MSR.
+=20
+ ``KVM_MSR_FILTER_DEFAULT_DENY``
+=20
+   If no filter range matches an MSR index that is getting accessed, KVM w=
ill
+   fall back to rejecting access to the MSR. In this mode, all MSRs that s=
hould
+   be processed by KVM need to explicitly be marked as allowed in the bitm=
aps.
+=20
+ This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
+ specify whether a certain MSR access should be explicitly filtered for or=
 not.
+=20
+ If this ioctl has never been invoked, MSR accesses are not guarded and the
+ default KVM in-kernel emulation behavior is fully preserved.
+=20
+ Calling this ioctl with an empty set of ranges (all nmsrs =3D=3D 0) disab=
les MSR
+ filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and c=
auses
+ an error.
+=20
+ As soon as the filtering is in place, every MSR access is processed throu=
gh
+ the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff=
);
+ x2APIC MSRs are always allowed, independent of the ``default_allow`` sett=
ing,
+ and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
+ register.
+=20
+ If a bit is within one of the defined ranges, read and write accesses are
+ guarded by the bitmap's value for the MSR index if the kind of access
+ is included in the ``struct kvm_msr_filter_range`` flags.  If no range
+ cover this particular access, the behavior is determined by the flags
+ field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
+ and ``KVM_MSR_FILTER_DEFAULT_DENY``.
+=20
+ Each bitmap range specifies a range of MSRs to potentially allow access o=
n.
+ The range goes from MSR index [base .. base+nmsrs]. The flags field
+ indicates whether reads, writes or both reads and writes are filtered
+ by setting a 1 bit in the bitmap for the corresponding MSR index.
+=20
+ If an MSR access is not permitted through the filtering, it generates a
+ #GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
+ allows user space to deflect and potentially handle various MSR accesses
+ into user space.
+=20
 -If a vCPU is in running state while this ioctl is invoked, the vCPU may
 -experience inconsistent filtering behavior on MSR accesses.
++Note, invoking this ioctl with a vCPU is running is inherently racy.  How=
ever,
++KVM does guarantee that vCPUs will see either the previous filter or the =
new
++filter, e.g. MSRs with identical settings in both the old and new filter =
will
++have deterministic behavior.
 =20
  4.98 KVM_CREATE_SPAPR_TCE_64
  ----------------------------

--Sig_/UWGrul2r5uq=eOZ..HZ8PST
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCA+6QACgkQAVBC80lX
0Gxq2wf/YJ+vEf0NfoTDSp5PQhzrV1YDlzjTGq3csCUjFDV3fKeKyAWzQI/b1QCb
REG6glUUKLgb9eykD6qQkr0vTWEyINdNi3HHEycIcDqPp3dYNDGjo56snmWU6uNk
xO9GjBdvv1pmetf6oAen5czwqNLhD2OxtqJflLs7b/qqCwWj9vlCHYGIhyz0k/gS
uHfWZLLcHEDsXQ2SZGXeHRxOTO7w3IDwtoKjCWzOnOOyx2YyJKxQFlpGXCVAnjyn
5UbtkfnesPlBmlIwTGeq9xzBigu0ry1+kk2+53iqbMow5dmNzVi/G9cPcNOeJx9h
jEDe+fnLxplxscubCSagahdfeMnLtg==
=c2MS
-----END PGP SIGNATURE-----

--Sig_/UWGrul2r5uq=eOZ..HZ8PST--

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1803B1382
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 07:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFWF4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 01:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWF4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 01:56:15 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D6EC061574;
        Tue, 22 Jun 2021 22:53:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G8srz1kbJz9sVm;
        Wed, 23 Jun 2021 15:53:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624427635;
        bh=Ve6HXVCvVXXFe6dLof+5dJ02Hlr9UcoY4clXXI/pLAs=;
        h=Date:From:To:Cc:Subject:From;
        b=imqBoRFGu3YPrZ7Bz1xwStLbCrJLbj8XrvN968C3eB8gNMCVJMWbd2XSblTaTSrzg
         MQ1fMaUU5kOIoH/IInCgXXFk0jrCePMj0lYOo8/0oQ21mHCnvRr9TlQCgE6OrvTBNs
         AnhehArd5bmNw0CjRLCAgIo1ab8Ge01V0MzzRIEVqL2YzrfFTK2ggkpsllzP3IagTo
         K4GLSixbgEjIiiuUoDkNI7vrksbnETACfqUloNhSIxaYuHhk/RDY4d/Vsy75FaiQIp
         qLjxx/h2C2U/vz7l+XdQXuGkZTW50nSM06G4Tni4CvG2VMW3OD3Jryl4h9iF2XJVz8
         1q9NqAzA0t+EQ==
Date:   Wed, 23 Jun 2021 15:53:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Steven Price <steven.price@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210623155353.466ff149@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BSqM7k6WG.Tl.uc2E1P+V+b";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/BSqM7k6WG.Tl.uc2E1P+V+b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  Documentation/virt/kvm/api.rst

between commit:

  6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")

from the kvm tree and commit:

  04c02c201d7e ("KVM: arm64: Document MTE capability and ioctl")

from the kvm-arm tree.

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
index ef81de1d4a9b,97661a97943f..000000000000
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@@ -5034,54 -5034,43 +5034,91 @@@ see KVM_XEN_VCPU_SET_ATTR above
  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
  with the KVM_XEN_VCPU_GET_ATTR ioctl.
 =20
+ 4.130 KVM_ARM_MTE_COPY_TAGS
+ ---------------------------
+=20
+ :Capability: KVM_CAP_ARM_MTE
+ :Architectures: arm64
+ :Type: vm ioctl
+ :Parameters: struct kvm_arm_copy_mte_tags
+ :Returns: number of bytes copied, < 0 on error (-EINVAL for incorrect
+           arguments, -EFAULT if memory cannot be accessed).
+=20
+ ::
+=20
+   struct kvm_arm_copy_mte_tags {
+ 	__u64 guest_ipa;
+ 	__u64 length;
+ 	void __user *addr;
+ 	__u64 flags;
+ 	__u64 reserved[2];
+   };
+=20
+ Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
+ ``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``=
addr``
+ field must point to a buffer which the tags will be copied to or from.
+=20
+ ``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST=
`` or
+ ``KVM_ARM_TAGS_FROM_GUEST``.
+=20
+ The size of the buffer to store the tags is ``(length / 16)`` bytes
+ (granules in MTE are 16 bytes long). Each byte contains a single tag
+ value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
+ ``PTRACE_POKEMTETAGS``.
+=20
+ If an error occurs before any data is copied then a negative error code is
+ returned. If some tags have been copied before an error occurs then the n=
umber
+ of bytes successfully copied is returned. If the call completes successfu=
lly
+ then ``length`` is returned.
+=20
 +
 +4.131 KVM_GET_SREGS2
 +------------------
 +
 +:Capability: KVM_CAP_SREGS2
 +:Architectures: x86
 +:Type: vcpu ioctl
 +:Parameters: struct kvm_sregs2 (out)
 +:Returns: 0 on success, -1 on error
 +
 +Reads special registers from the vcpu.
 +This ioctl (when supported) replaces the KVM_GET_SREGS.
 +
 +::
 +
 +struct kvm_sregs2 {
 +	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
 +	struct kvm_segment cs, ds, es, fs, gs, ss;
 +	struct kvm_segment tr, ldt;
 +	struct kvm_dtable gdt, idt;
 +	__u64 cr0, cr2, cr3, cr4, cr8;
 +	__u64 efer;
 +	__u64 apic_base;
 +	__u64 flags;
 +	__u64 pdptrs[4];
 +};
 +
 +flags values for ``kvm_sregs2``:
 +
 +``KVM_SREGS2_FLAGS_PDPTRS_VALID``
 +
 +  Indicates thats the struct contain valid PDPTR values.
 +
 +
 +4.132 KVM_SET_SREGS2
 +------------------
 +
 +:Capability: KVM_CAP_SREGS2
 +:Architectures: x86
 +:Type: vcpu ioctl
 +:Parameters: struct kvm_sregs2 (in)
 +:Returns: 0 on success, -1 on error
 +
 +Writes special registers into the vcpu.
 +See KVM_GET_SREGS2 for the data structures.
 +This ioctl (when supported) replaces the KVM_SET_SREGS.
 +
 +
  5. The kvm_run structure
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
@@@ -6408,26 -6397,32 +6445,50 @@@ system fingerprint.  To prevent userspa
  by running an enclave in a VM, KVM prevents access to privileged attribut=
es by
  default.
 =20
 -See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
 +See Documentation/x86/sgx.rst for more details.
 +
 +7.26 KVM_CAP_PPC_RPT_INVALIDATE
 +-------------------------------
 +
 +:Capability: KVM_CAP_PPC_RPT_INVALIDATE
 +:Architectures: ppc
 +:Type: vm
 +
 +This capability indicates that the kernel is capable of handling
 +H_RPT_INVALIDATE hcall.
 +
 +In order to enable the use of H_RPT_INVALIDATE in the guest,
 +user space might have to advertise it for the guest. For example,
 +IBM pSeries (sPAPR) guest starts using it if "hcall-rpt-invalidate" is
 +present in the "ibm,hypertas-functions" device-tree property.
 +
 +This capability is enabled for hypervisors on platforms like POWER9
 +that support radix MMU.
 =20
+ 7.26 KVM_CAP_ARM_MTE
+ --------------------
+=20
+ :Architectures: arm64
+ :Parameters: none
+=20
+ This capability indicates that KVM (and the hardware) supports exposing t=
he
+ Memory Tagging Extensions (MTE) to the guest. It must also be enabled by =
the
+ VMM before creating any VCPUs to allow the guest access. Note that MTE is=
 only
+ available to a guest running in AArch64 mode and enabling this capability=
 will
+ cause attempts to create AArch32 VCPUs to fail.
+=20
+ When enabled the guest is able to access tags associated with any memory =
given
+ to the guest. KVM will ensure that the tags are maintained during swap or
+ hibernation of the host; however the VMM needs to manually save/restore t=
he
+ tags as appropriate if the VM is migrated.
+=20
+ When this capability is enabled all memory in memslots must be mapped as
+ not-shareable (no MAP_SHARED), attempts to create a memslot with a
+ MAP_SHARED mmap will result in an -EINVAL return.
+=20
+ When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl =
to
+ perform a bulk copy of tags to/from the guest.
+=20
  8. Other capabilities.
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20

--Sig_/BSqM7k6WG.Tl.uc2E1P+V+b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDSzHEACgkQAVBC80lX
0GyRWwf/aMGuhelkmZ9KrQ4f8otwPgrkREwqzsQB2l7aW6naJshtcG936J6Fz3MH
u7DNhKdHyoEQGYjOwX55rtPb8v3ORt0uQPFcJlD+0+FqydsTxAY70WExcjOUqq6z
kBlCVu/iLE3isSKMmKjPDg8rKyRlvMPuq5DApE6tkWxC2dazLdEWgC8gu/Ho1PGG
B1b1YVE5rmD0DdrUH55vAOch2cfStm5HvRbnjB5D0diSLZ/lhVe8TeRwyfPE/gj1
2awrE12eVE8VxztJDOTxQMQScXQ9nJO1MQMprZesvxhWUJ+us6brZLT/PX6g+ZTV
PVkhVwFtebNRAP3SgLpLPEnOeSrc0g==
=AQHX
-----END PGP SIGNATURE-----

--Sig_/BSqM7k6WG.Tl.uc2E1P+V+b--

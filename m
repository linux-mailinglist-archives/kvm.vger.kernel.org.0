Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865AB3B3C06
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 07:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhFYFRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 01:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhFYFRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 01:17:37 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD25C061574;
        Thu, 24 Jun 2021 22:15:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GB4vN6kRCz9sWw;
        Fri, 25 Jun 2021 15:15:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624598113;
        bh=n4nmdvprxAbipxGmyKseNuAj2NmWFpDgkSLoT8FEcBA=;
        h=Date:From:To:Cc:Subject:From;
        b=lGYhwFg4Dr629JPLRDZJgD5AE984VPYZXbkqQOgo9VRehyqYQKoNj/HL3kooNVG/E
         b9ovJJBGXfPlkvfKBw5B1zkyirlYQTs0i8iG1J8g0DHBnhgDhcMH256vcgf6ae3bbJ
         Vt8nek/1gGZWqSshN5BJ7iYxg1FC0yLKGA2iQ8WrvMs1QXpioPTIyzn6v3llpTT36X
         kFKD6SFeJslby7vcJsP6n3epCKneG4xeFPHW9xCVKmL6fK1CNmGmKPNTs/BdZkOJdx
         iLA3bNtjh3QHm5wWvZYDSQkL09WXRxAe91RDj3UD/umJGh1odcjZAigJEWEXxxxGh0
         xhQyIOBFDl+3A==
Date:   Fri, 25 Jun 2021 15:15:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Jing Zhang <jingzhangos@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Steven Price <steven.price@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210625151511.270c1611@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gwKE2lCexLJCH9FZ6ULz/Km";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/gwKE2lCexLJCH9FZ6ULz/Km
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  Documentation/virt/kvm/api.rst

between commit:

  fdc09ddd4064 ("KVM: stats: Add documentation for binary statistics interf=
ace")

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
index aba27461edec,97661a97943f..000000000000
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@@ -5039,224 -5034,43 +5039,260 @@@ see KVM_XEN_VCPU_SET_ATTR above
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
 =20
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
 +4.133 KVM_GET_STATS_FD
 +----------------------
 +
 +:Capability: KVM_CAP_STATS_BINARY_FD
 +:Architectures: all
 +:Type: vm ioctl, vcpu ioctl
 +:Parameters: none
 +:Returns: statistics file descriptor on success, < 0 on error
 +
 +Errors:
 +
 +  =3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +  ENOMEM     if the fd could not be created due to lack of memory
 +  EMFILE     if the number of opened files exceeds the limit
 +  =3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +
 +The returned file descriptor can be used to read VM/vCPU statistics data =
in
 +binary format. The data in the file descriptor consists of four blocks
 +organized as follows:
 +
 ++-------------+
 +|   Header    |
 ++-------------+
 +|  id string  |
 ++-------------+
 +| Descriptors |
 ++-------------+
 +| Stats Data  |
 ++-------------+
 +
 +Apart from the header starting at offset 0, please be aware that it is
 +not guaranteed that the four blocks are adjacent or in the above order;
 +the offsets of the id, descriptors and data blocks are found in the
 +header.  However, all four blocks are aligned to 64 bit offsets in the
 +file and they do not overlap.
 +
 +All blocks except the data block are immutable.  Userspace can read them
 +only one time after retrieving the file descriptor, and then use ``pread`=
` or
 +``lseek`` to read the statistics repeatedly.
 +
 +All data is in system endianness.
 +
 +The format of the header is as follows::
 +
 +	struct kvm_stats_header {
 +		__u32 flags;
 +		__u32 name_size;
 +		__u32 num_desc;
 +		__u32 id_offset;
 +		__u32 desc_offset;
 +		__u32 data_offset;
 +	};
 +
 +The ``flags`` field is not used at the moment. It is always read as 0.
 +
 +The ``name_size`` field is the size (in byte) of the statistics name stri=
ng
 +(including trailing '\0') which is contained in the "id string" block and
 +appended at the end of every descriptor.
 +
 +The ``num_desc`` field is the number of descriptors that are included in =
the
 +descriptor block.  (The actual number of values in the data block may be
 +larger, since each descriptor may comprise more than one value).
 +
 +The ``id_offset`` field is the offset of the id string from the start of =
the
 +file indicated by the file descriptor. It is a multiple of 8.
 +
 +The ``desc_offset`` field is the offset of the Descriptors block from the=
 start
 +of the file indicated by the file descriptor. It is a multiple of 8.
 +
 +The ``data_offset`` field is the offset of the Stats Data block from the =
start
 +of the file indicated by the file descriptor. It is a multiple of 8.
 +
 +The id string block contains a string which identifies the file descripto=
r on
 +which KVM_GET_STATS_FD was invoked.  The size of the block, including the
 +trailing ``'\0'``, is indicated by the ``name_size`` field in the header.
 +
 +The descriptors block is only needed to be read once for the lifetime of =
the
 +file descriptor contains a sequence of ``struct kvm_stats_desc``, each fo=
llowed
 +by a string of size ``name_size``.
 +
 +	#define KVM_STATS_TYPE_SHIFT		0
 +	#define KVM_STATS_TYPE_MASK		(0xF << KVM_STATS_TYPE_SHIFT)
 +	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 +	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 +	#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
 +
 +	#define KVM_STATS_UNIT_SHIFT		4
 +	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
 +	#define KVM_STATS_UNIT_NONE		(0x0 << KVM_STATS_UNIT_SHIFT)
 +	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
 +	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 +	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
 +
 +	#define KVM_STATS_BASE_SHIFT		8
 +	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
 +	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
 +	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
 +
 +	struct kvm_stats_desc {
 +		__u32 flags;
 +		__s16 exponent;
 +		__u16 size;
 +		__u32 offset;
 +		__u32 unused;
 +		char name[];
 +	};
 +
 +The ``flags`` field contains the type and unit of the statistics data des=
cribed
 +by this descriptor. Its endianness is CPU native.
 +The following flags are supported:
 +
 +Bits 0-3 of ``flags`` encode the type:
 +  * ``KVM_STATS_TYPE_CUMULATIVE``
 +    The statistics data is cumulative. The value of data can only be incr=
eased.
 +    Most of the counters used in KVM are of this type.
 +    The corresponding ``size`` field for this type is always 1.
 +    All cumulative statistics data are read/write.
 +  * ``KVM_STATS_TYPE_INSTANT``
 +    The statistics data is instantaneous. Its value can be increased or
 +    decreased. This type is usually used as a measurement of some resourc=
es,
 +    like the number of dirty pages, the number of large pages, etc.
 +    All instant statistics are read only.
 +    The corresponding ``size`` field for this type is always 1.
 +  * ``KVM_STATS_TYPE_PEAK``
 +    The statistics data is peak. The value of data can only be increased,=
 and
 +    represents a peak value for a measurement, for example the maximum nu=
mber
 +    of items in a hash table bucket, the longest time waited and so on.
 +    The corresponding ``size`` field for this type is always 1.
 +
 +Bits 4-7 of ``flags`` encode the unit:
 +  * ``KVM_STATS_UNIT_NONE``
 +    There is no unit for the value of statistics data. This usually means=
 that
 +    the value is a simple counter of an event.
 +  * ``KVM_STATS_UNIT_BYTES``
 +    It indicates that the statistics data is used to measure memory size,=
 in the
 +    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
 +    determined by the ``exponent`` field in the descriptor.
 +  * ``KVM_STATS_UNIT_SECONDS``
 +    It indicates that the statistics data is used to measure time or late=
ncy.
 +  * ``KVM_STATS_UNIT_CYCLES``
 +    It indicates that the statistics data is used to measure CPU clock cy=
cles.
 +
 +Bits 8-11 of ``flags``, together with ``exponent``, encode the scale of t=
he
 +unit:
 +  * ``KVM_STATS_BASE_POW10``
 +    The scale is based on power of 10. It is used for measurement of time=
 and
 +    CPU clock cycles.  For example, an exponent of -9 can be used with
 +    ``KVM_STATS_UNIT_SECONDS`` to express that the unit is nanoseconds.
 +  * ``KVM_STATS_BASE_POW2``
 +    The scale is based on power of 2. It is used for measurement of memor=
y size.
 +    For example, an exponent of 20 can be used with ``KVM_STATS_UNIT_BYTE=
S`` to
 +    express that the unit is MiB.
 +
 +The ``size`` field is the number of values of this statistics data. Its
 +value is usually 1 for most of simple statistics. 1 means it contains an
 +unsigned 64bit data.
 +
 +The ``offset`` field is the offset from the start of Data Block to the st=
art of
 +the corresponding statistics data.
 +
 +The ``unused`` field is reserved for future support for other types of
 +statistics data, like log/linear histogram. Its value is always 0 for the=
 types
 +defined above.
 +
 +The ``name`` field is the name string of the statistics data. The name st=
ring
 +starts at the end of ``struct kvm_stats_desc``.  The maximum length inclu=
ding
 +the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 +
 +The Stats Data block contains an array of 64-bit values in the same order
 +as the descriptors in Descriptors block.
 +
  5. The kvm_run structure
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
@@@ -6584,45 -6397,32 +6620,69 @@@ system fingerprint.  To prevent userspa
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
 +
 +7.27 KVM_CAP_EXIT_ON_EMULATION_FAILURE
 +--------------------------------------
 +
 +:Architectures: x86
 +:Parameters: args[0] whether the feature should be enabled or not
 +
 +When this capability is enabled, an emulation failure will result in an e=
xit
 +to userspace with KVM_INTERNAL_ERROR (except when the emulator was invoked
 +to handle a VMware backdoor instruction). Furthermore, KVM will now provi=
de up
 +to 15 instruction bytes for any exit to userspace resulting from an emula=
tion
 +failure.  When these exits to userspace occur use the emulation_failure s=
truct
 +instead of the internal struct.  They both have the same layout, but the
 +emulation_failure struct matches the content better.  It also explicitly
 +defines the 'flags' field which is used to describe the fields in the str=
uct
 +that are valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTE=
S is
 +set in the 'flags' field then both 'insn_size' and 'insn_bytes' have vali=
d data
 +in them.)
 +
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

--Sig_/gwKE2lCexLJCH9FZ6ULz/Km
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDVZl8ACgkQAVBC80lX
0GxMYwgAkDwigCyAeUpjBDEoSHVcSNLaz72C3ydTgtD9Zo5USqsQiuqA82h16GaO
q7U2wRZrgYzebq5FfEmtHvLN6FRAueICOC6xDcziiTXuyKQTkXCn85hF679frfnT
Hrd0ibkY6US0BzFIlDniwAD9D0yN8D59Ad1DD3AtF9jn8FRCxj3zsMrZyq05De7P
xpFU2bOLLAEweYIRzlVDO7qy71ETfGieeFLV9GUWmplWtVzZUoIe1RL+2/z7q/nU
b5ZRaId8jmOvqZYZ6DwrVTt3RwwvM6eVaByiQGB1sG/eKXhzuJbfWnaSucK/UsZv
cauSU5eLd9gmaYTVnH4Rh6WHDva9Wg==
=4sdC
-----END PGP SIGNATURE-----

--Sig_/gwKE2lCexLJCH9FZ6ULz/Km--

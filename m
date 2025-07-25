Return-Path: <kvm+bounces-53465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2113DB122C3
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 19:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8716AA1ACF
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 17:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9240C2EF678;
	Fri, 25 Jul 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTdn1Ccx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4062EF2B7
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463617; cv=none; b=RZHJU7jJKK9m4KvB+0k/Hd6MT7Nx1+Qwx1DgcTi2LBOVKTPDs3kH4nBwPSzIL8tQqMyASeyYGHXYKymPtj+Cr8QRtZqp8GL3Zk6igSQKmGqPH7nqs2BT40P9LQwH0Zy+aRM4f2gTEeoZoHkz0c1pwNrvHPFYW+ldn2N0QTYp3uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463617; c=relaxed/simple;
	bh=T/M2s2xVlYuh/GfNcs9lDBVRLTMpcwRQnMTAYRlWR5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCbrMmTiLY7fN1S3WxYgTl2pMEQVB43T6ovFjB+rRcwJ1x0JEe+eDM43NAfAYLdTXQjD2V0JqAftQZwVgZ9AHrlQUp9541PWGVJ/+PJzMTmFnaftRsOAyQfBr8n3x5O1WltVGQJXcAnwbamTLv2VkujhOUxTZbVaceKUd9K9hR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTdn1Ccx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f3d4c7e7so2148974b3a.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753463615; x=1754068415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+f8ECMzvMCzX3pnQxw0jQaX7GgUHjg6TEwrbmrTx8k=;
        b=tTdn1Ccxnj0an+pmNmWTt6Apg5fMTzOnS28gHbOzQifYTNEk5h4GQIv/vXbY8QS2wV
         hguwWC557B/Q0ZdYu/3Z9lDsJiog0byR2ouA2ozI3p6BqUvgRq4HNjx1sXeFa1StQDFJ
         NPyYXJgrluHfn0UEla7SCsTpP0Q0Mzk05DJLF9EppaUc/j776No/8VsOJcQE2GbaqSQD
         tIIhydnidwvwuLLMz6DsD6lIaGm+c7FZu26CcBrexQiy9cauccyRSwzR2xWG4pr/yw6R
         ZDMzHyKSzbCu/wMdEkCXnmlR8XpPS9cPzwP81LDCVcyXEywSUYXgiyKqA3ewP6yEZyAj
         MJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753463615; x=1754068415;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E+f8ECMzvMCzX3pnQxw0jQaX7GgUHjg6TEwrbmrTx8k=;
        b=iBP+8yJ9fymq5fYO67vOAvxBw+g1YQHC9hFUWpgfaeqelqTzvU7SBxPUyu+9ONCWp9
         +d1A0PgA7rXZxZ6p1dUev+OWCgaGBbrpxxq7GICd4a8bejMoXtR6PRLW1BoWx6LiUphJ
         aHVbQmIwwXUO2e/0NAUCd3XYSnrIAO/ooCR7fNDKIbhJflUtJ3+R3+mvCwueaiJqOlN1
         PsJ+Y4j5ahCjXtWTMBVdVyuIQ30GF3WxeM7Jr9QVfe/NXYcs1svNK0cH1p7wxj7akUCV
         ebMt2q3X0cKhWkTUjliJz8VsJ+ckyEsPHTueGJXgfiPnDKl1okpMZYsnOLKRUZM7Eodd
         dbSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdkBOd/YUlXso/w1FZ/hVeoGarbLLqDAIroiXiirzOXWZDwdcEMTQnEUIuE3yol9o06bk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSfemC7fRsE0WT/z4aBpd5WZmtsu+QOhYtT1XYJCU+WSFG/7pU
	JGz/p5LM0b7OclBABRgCeaOeR2YJ4mVxbpOqqgWedBnTZx8g6Mxq2xoRqPaBP7/GknlmYc9V8CC
	7Q7knNw==
X-Google-Smtp-Source: AGHT+IEe50hQ5xJZE2cI6F06MC+m3pDOUnz2melqMbGj2/g8RniMBVJGng2MMVfHIVNM11FIsL6B6vGVcrc=
X-Received: from pgbfq25.prod.google.com ([2002:a05:6a02:2999:b0:b31:dbad:8412])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:42a3:b0:234:c6a0:8a0f
 with SMTP id adf61e73a8af0-23d701cd8b5mr4246329637.41.1753463615402; Fri, 25
 Jul 2025 10:13:35 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:13:33 -0700
In-Reply-To: <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIO7PRBzpFqk8D13@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Thu, Jul 24, 2025, Ackerley Tng wrote:
> >> Fuad Tabba <tabba@google.com> writes:
> >> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_faul=
t *fault,
> >> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,=
 struct kvm_page_fault *fault,
> >> >  	if (max_level =3D=3D PG_LEVEL_4K)
> >> >  		return PG_LEVEL_4K;
> >> > =20
> >> > -	if (is_private)
> >> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gf=
n);
> >> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
> >> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> >> > +							is_private);
> >> >  	else
> >> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
> >>=20
> >> No change required now, would like to point out that in this change
> >> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
> >> shared pages, guest_memfd will be the only source of truth.
> >
> > It's not an assumption, it's a hard requirement.
> >
> >> This holds now because shared pages are always split to 4K, but if
> >> shared pages become larger, might mapping in the host actually turn ou=
t
> >> to be smaller?
> >
> > Yes, the host userspace mappens could be smaller, and supporting that s=
cenario is
> > very explicitly one of the design goals of guest_memfd.  From commit a7=
800aa80ea4
> > ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing me=
mory"):
> >
> >  : A guest-first memory subsystem allows for optimizations and enhancem=
ents
> >  : that are kludgy or outright infeasible to implement/support in a gen=
eric
> >  : memory subsystem.  With guest_memfd, guest protections and mapping s=
izes
> >  : are fully decoupled from host userspace mappings.   E.g. KVM current=
ly
> >  : doesn't support mapping memory as writable in the guest without it a=
lso
> >  : being writable in host userspace, as KVM's ABI uses VMA protections =
to
> >  : define the allow guest protection.  Userspace can fudge this by
> >  : establishing two mappings, a writable mapping for the guest and read=
able
> >  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
> >  :=20
> >  : Similarly, KVM currently requires the guest mapping size to be a str=
ict
> >  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t =
support
> >  : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
> >  : mapping.  Decoupling the mappings sizes would allow userspace to pre=
cisely
> >  : map only what is needed without impacting guest performance, e.g. to
> >  : harden against unintentional accesses to guest memory.
>=20
> Let me try to understand this better. If/when guest_memfd supports
> larger folios for shared pages, and guest_memfd returns a 2M folio from
> kvm_gmem_fault_shared(), can the mapping in host userspace turn out
> to be 4K?

It can be 2M, 4K, or none.

> If that happens, should kvm_gmem_max_mapping_level() return 4K for a
> memslot with kvm_memslot_is_gmem_only() =3D=3D true?

No.

> The above code would skip host_pfn_mapping_level() and return just what
> guest_memfd reports, which is 2M.

Yes.

> Or do you mean that guest_memfd will be the source of truth in that it
> must also know/control, in the above scenario, that the host mapping is
> also 2M?

No.  The userspace mapping, _if_ there is one, is completely irrelevant.  T=
he
entire point of guest_memfd is eliminate the requirement that memory be map=
ped
into host userspace in order for that memory to be mapped into the guest.

Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wro=
ng, as
KVM will not verify slot->userspace_addr actually points at the (same) gues=
t_memfd
instance.

To demonstrate, this must pass (and does once "KVM: x86/mmu: Handle guest p=
age
faults for guest_memfd with shared memory" is added back).

---
 .../testing/selftests/kvm/guest_memfd_test.c  | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c
index 088053d5f0f5..b86bf89a71e0 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,7 @@
=20
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/sizes.h>
 #include <setjmp.h>
 #include <signal.h>
 #include <sys/mman.h>
@@ -21,6 +22,7 @@
=20
 #include "kvm_util.h"
 #include "test_util.h"
+#include "ucall_common.h"
=20
 static void test_file_read_write(int fd)
 {
@@ -298,6 +300,66 @@ static void test_guest_memfd(unsigned long vm_type)
 	kvm_vm_free(vm);
 }
=20
+static void guest_code(uint8_t *mem, uint64_t size)
+{
+	size_t i;
+
+	for (i =3D 0; i < size; i++)
+		__GUEST_ASSERT(mem[i] =3D=3D 0xaa,
+			       "Guest expected 0xaa at offset %lu, got 0x%x", i, mem[i]);
+
+	memset(mem, 0xff, size);
+	GUEST_DONE();
+}
+
+static void test_guest_memfd_guest(void)
+{
+	/*
+	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
+	 * the guest's code, stack, and page tables, and low memory contains
+	 * the PCI hole and other MMIO regions that need to be avoided.
+	 */
+	const uint64_t gpa =3D SZ_4G;
+	const int slot =3D 1;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t *mem;
+	size_t size;
+	int fd, i;
+
+	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		return;
+
+	vm =3D __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_=
code);
+
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
+		    "Default VM type should always support guest_memfd mmap()");
+
+	size =3D vm->page_size;
+	fd =3D vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL=
, fd, 0);
+
+	mem =3D mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() on guest_memfd failed");
+	memset(mem, 0xaa, size);
+	munmap(mem, size);
+
+	virt_pg_map(vm, gpa, gpa);
+	vcpu_args_set(vcpu, 2, gpa, size);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	mem =3D mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() on guest_memfd failed");
+	for (i =3D 0; i < size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xff);
+
+	close(fd);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -314,4 +376,6 @@ int main(int argc, char *argv[])
=20
 	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
 		test_guest_memfd(vm_type);
+
+	test_guest_memfd_guest();
 }

base-commit: 9a82b11560044839b10b1fb83ff230d9a88785b8
--=20


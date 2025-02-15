Return-Path: <kvm+bounces-38278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2328A36D8B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 12:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E586162C74
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 11:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CFF1A2388;
	Sat, 15 Feb 2025 11:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ce1mR6Mp"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D63192D97;
	Sat, 15 Feb 2025 11:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739617270; cv=none; b=hX/5Q2mzWI0NZreuuWXbumDY0OxMk2/y5O49QK6/e6dEg9YSw9QqHCbzYtgJFd8GnKs3abTtlzImG9qb/UNp6bZc+/Dk9jBw2sxdOahbYhPYqR4B31hAt70rZfhYML36tuUqYVNvqsNxUL/28uOpOgLSs+iQ2PaqU314Z+eD4dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739617270; c=relaxed/simple;
	bh=dJMXZjkxRnJGqf19Krt1G2+pubbDJ/b6B23F0R9noN0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=J3E2qsXJK1wwCEpB7KGJEzlQ3K82o1T3XmSdZKewIFdFJ1cBFXir+64tfSJZQBdtBJvdTOU0/wv8Z1fjSqR99BJQR2s81qsh47qZLgW7X3lvChN12hh2LDt0ZxMIOzQA61bSHR+GWYqsvcw4NMenKUrxXhQwBQHd9a3FHLvH3ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ce1mR6Mp; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=PPMcrClHGwldmJKxzwOU3qelWLajHsspzH8nTkIQ1mI=; b=ce1mR6Mp+Xi3xZCOGFxNUNkzVo
	udkQJfg8zsBfbiBObS3VksNYNY/AFsdK5K9x/8C7LJz7sxUnLOnM5bEjjbwJiF9f44WaQzmQHiauD
	HXHErR6YqiQV9Dj4Qq86U/s22uP7Hde3B1mN4eGV4/lba9UhtMKekn4Nz/TIU2vyjcr35lUETIiHQ
	tQ5VfQHVoEXfV34i9TiVNvGcInzOEs1/MC/gsXlVHiofBcv7Ac+W3Zz4mrL4XdK9RO0saYbH8Vlot
	rgJLeOu8cftYUgoBOF0jz+hmIlIveYyqTZ63FX8HXSbNqpStyyc+RTBfIvgzj5JanAfN9RqheauZj
	s88XKhSQ==;
Received: from [31.94.24.172] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjFut-00000001REG-28sK;
	Sat, 15 Feb 2025 11:01:00 +0000
Date: Sat, 15 Feb 2025 12:00:54 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Paul Durrant <paul@xen.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joao Martins <joao.m.martins@oracle.com>,
 David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/5=5D_KVM=3A_x86/xen=3A_Restrict_?=
 =?US-ASCII?Q?hypercall_MSR_to_unofficial_synthetic_range?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20250215011437.1203084-2-seanjc@google.com>
References: <20250215011437.1203084-1-seanjc@google.com> <20250215011437.1203084-2-seanjc@google.com>
Message-ID: <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 15 February 2025 02:14:33 CET, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>Reject userspace attempts to set the Xen hypercall page MSR to an index
>outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
>as KVM is not equipped to handle collisions with real MSRs, e=2Eg=2E KVM
>doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
>case writes in KVM, etc=2E
>
>While the MSR index isn't strictly ABI, i=2Ee=2E can theoretically float =
to
>any value, in practice no known VMM sets the MSR index to anything other
>than 0x40000000 or 0x40000200=2E
>
>Cc: Joao Martins <joao=2Em=2Emartins@oracle=2Ecom>
>Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>Reviewed-by: Paul Durrant <paul@xen=2Eorg>
>Signed-off-by: Sean Christopherson <seanjc@google=2Ecom>
>---
> arch/x86/include/uapi/asm/kvm=2Eh | 3 +++
> arch/x86/kvm/xen=2Ec              | 9 +++++++++
> 2 files changed, 12 insertions(+)
>
>diff --git a/arch/x86/include/uapi/asm/kvm=2Eh b/arch/x86/include/uapi/as=
m/kvm=2Eh
>index 9e75da97bce0=2E=2E460306b35a4b 100644
>--- a/arch/x86/include/uapi/asm/kvm=2Eh
>+++ b/arch/x86/include/uapi/asm/kvm=2Eh
>@@ -559,6 +559,9 @@ struct kvm_x86_mce {
> #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
> #define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
>=20
>+#define KVM_XEN_MSR_MIN_INDEX			0x40000000u
>+#define KVM_XEN_MSR_MAX_INDEX			0x4fffffffu
>+
> struct kvm_xen_hvm_config {
> 	__u32 flags;
> 	__u32 msr;
>diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>index a909b817b9c0=2E=2E5b94825001a7 100644
>--- a/arch/x86/kvm/xen=2Ec
>+++ b/arch/x86/kvm/xen=2Ec
>@@ -1324,6 +1324,15 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm=
_xen_hvm_config *xhc)
> 	     xhc->blob_size_32 || xhc->blob_size_64))
> 		return -EINVAL;
>=20
>+	/*
>+	 * Restrict the MSR to the range that is unofficially reserved for
>+	 * synthetic, virtualization-defined MSRs, e=2Eg=2E to prevent confusin=
g
>+	 * KVM by colliding with a real MSR that requires special handling=2E
>+	 */
>+	if (xhc->msr &&
>+	    (xhc->msr < KVM_XEN_MSR_MIN_INDEX || xhc->msr > KVM_XEN_MSR_MAX_IND=
EX))
>+		return -EINVAL;
>+
> 	mutex_lock(&kvm->arch=2Exen=2Exen_lock);
>=20
> 	if (xhc->msr && !kvm->arch=2Exen_hvm_config=2Emsr)

I'd still like to restrict this to ensure it doesn't collide with MSRs tha=
t KVM expects to emulate=2E But that can be a separate patch, as discussed=
=2E

This patch should probably have a docs update too=2E


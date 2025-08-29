Return-Path: <kvm+bounces-56371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E895B3C48E
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA98E4E2B80
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4438B275111;
	Fri, 29 Aug 2025 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1v40Er5o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED4A18871F
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756504875; cv=none; b=As0p1Pnhnm3BIis3PW8ot4ur3XxtLI7wuskmdTAO27LhSSyciiMhycWaq3BHCpwZll83r0RQJydjfgm2YhofYdimHr0PvP2FttjtakXRz6OfHE8pwymW/zdhz1cBv8o7AfftRfwySVtdMFWQxHsBtBHOAlq8IVmMcB+puVcMuXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756504875; c=relaxed/simple;
	bh=iPLXyx8i4nwGLxcbS6HSFMUvEQLFAk5T7HM3teO+mVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HSU9te42X/qahOWkoi4OiYlyh/C3Xc7wEDqL6tttbMJd73dXAERq4bfAELF7qtWPV8be0D1rYnqJ7HV4flmntTE89TMRZd0+ufDbkYuUpYEuNoXpuJ5hdjm6GS202h8jZ8u/wqy53g8WqcLrpVb9B/3EHgCpejkl+OL8mO0Zd2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1v40Er5o; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445803f0cfso33519305ad.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 15:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756504873; x=1757109673; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h9GHPlaBYRJg/LqiNX41fKkZYjFrM0pCCrDklkQEttc=;
        b=1v40Er5oEG/hqfMDsTZcIeKsvwDVynhRnulvyCtGn02XxNt1lvk0NUd7LPC9Ls4Ebw
         JzNXJgW+dnK5eToeQVNxz213GwpGOBGIbsss80D9gplogM21ibks6XNV0ZsvaoiDDF86
         kUnnQwBo+d55JYQ1sqOZS1LuqAEI/UhUbJFoqPkazH4cDLeFOymuEoyA5WzZh1LVax8s
         ukNJan26R0KOGm5GQd64IC2RDGDDdwi1BDTuvE9gvD5t+7Qsktj2QuEc+SDMNzNW0kRK
         1TpI7xt1//QOMq0u14vTWbJ92jO5NGm/bS1C2BrBRQfPLqP4HNmlFNzA8urb0nCPuQEu
         /uVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756504873; x=1757109673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h9GHPlaBYRJg/LqiNX41fKkZYjFrM0pCCrDklkQEttc=;
        b=U+P7X8LCwXmZEZrW0vSMSs11B0XgziFX7bzbX5hjog+ZGp6BG2C5FvahGUzpm1Ve4p
         JCD/SFb86fy6mqb9sWQKWZQeiOJU4x/7Km+muUymOxXuLltaVWC0zK9PJ+yKcsXWaU90
         WxYBzuXEzW+ZGqGg6FzFEhkw65C2OkDjzHUx1Bs1L2Pt5a9m3abFnNjkTqDOwNrlzj8a
         Y5b4Y0c4U0pDOvge/MQYz8VY8/KOzlnDRhbpLyYZOe/A0XY3syU2O+WD1Wj5tCCR0x5p
         Kh4UqoH5k3Mbo2p5zoUrhXRl3fvYtxANr+V9A6RejjrB4iqVVFihdDYaSV6vwrxLDBnG
         bFpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrmOyPuBtqvwnhD2n6eeSUdgnqCJK0o7NeiiT2/rax9faVbpNqpiKob1vMtQ97Bxg75Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3w8bJpZ85FdTHniQ2b2VUGWPS28VIqWBTjkBgint0zWS4pOM6
	AoRqml94E6uucWb2laf7S7e6Y6EiP4gnmml9wUH5/0tP6jG1YeQfXy+0Br4E3Xg0H0miv/5y3No
	PxhYLaw==
X-Google-Smtp-Source: AGHT+IHC/YWdD94OPNKo9tuuWQlCwmFoPFP/TYWYJkA+7SN2xuVrPZqRZEOTX3LfK2IVYyi2Duk9ySUVzlk=
X-Received: from plps15.prod.google.com ([2002:a17:902:988f:b0:248:96be:d4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e790:b0:248:79d4:93ba
 with SMTP id d9443c01a7336-24944b2a01amr1760195ad.39.1756504873169; Fri, 29
 Aug 2025 15:01:13 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:01:11 -0700
In-Reply-To: <aLD3yS6LQR7b55CR@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821133132.72322-1-chao.gao@intel.com> <20250821133132.72322-2-chao.gao@intel.com>
 <402d79e7-f229-4caa-8150-6061e363da4f@intel.com> <aLD3yS6LQR7b55CR@intel.com>
Message-ID: <aLIjJ9I1Swf35HPT@google.com>
Subject: Re: [PATCH v13 01/21] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com, 
	mingo@redhat.com, minipli@grsecurity.net, mlevitsk@redhat.com, 
	pbonzini@redhat.com, rick.p.edgecombe@intel.com, tglx@linutronix.de, 
	weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Chao Gao wrote:
> On Thu, Aug 28, 2025 at 08:58:07PM +0800, Xiaoyao Li wrote:
> >On 8/21/2025 9:30 PM, Chao Gao wrote:
> >> From: Yang Weijiang <weijiang.yang@intel.com>
> >> 
> >> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
> >> KVM synthetic MSR through it.
> >> 
> >> In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
> >> it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
> >> and hides the difference of synthetic MSRs and normal HW defined MSRs.
> >> 
> >> Now carve out a separate room in KVM-customized MSR address space for
> >> synthetic MSRs. The synthetic MSRs are not exposed to userspace via
> >> KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
> >> composes the uAPI params. KVM synthetic MSR indices start from 0 and
> >> increase linearly. Userspace caller should tag MSR type correctly in
> >> order to access intended HW or synthetic MSR.
> >
> >The old feedback[*]

Good sleuthing!  I completely forgot about that...

> was to introduce support for SYNTHETIC registers instead of limiting it to MSR.
> 
> GUEST_SSP is a real register but not an MSR, 

Eh, yes and no.  The vCPU's current SSP is a real register, but there's no
interface to access it.  The "synthetic" part here the interface that KVM is
defining.  Though I can see where that gets confusing since "synthetic" in KVM
usually means a completely made up register/MSR.

> so it's ok to treat it as a synthetic MSR. But, it's probably
> inappropriate/inaccurate to call it a synthetic register.
> 
> I think we need a clear definition for "synthetic register" to determine what
> should be included in this category. "synthetic MSR" is clear - it refers to
> something that isn't an MSR in hardware but is handled by KVM as an MSR.

Ah, but I specifically want to avoid bleeding those details into userspace.
I.e. I don't want userspace to know that internally, KVM handles GUEST_SSP via
the MSR infrastructure, so that if for whatever reason we want to do something
different (very unlikely), then we don't create a contradiction.

> That said, I'm still fine with renaming all "synthetic MSR" to "synthetic
> register" in this series. :)
> 
> Sean, which do you prefer with fresh eyes?
> 
> If we make this change, I suppose KVM_x86_REG_TYPE_SIZE() should be dropped, as
> we can't guarantee that the size will remain constant for the "synthetic
> register" type, since it could be extended to include registers with different
> sizes in the future.

Ooh, good catch.  We can keep it, we just need to be more conservative and only
define a valid size for GUEST_SSP.

To avoid confusion with "synthetic", what if we go with a more literal type of
"KVM"?  That's vague enough that it gives KVM a lot of flexibility, but specific
enough that it'll be intuitive for readers, hopefully.

---
 arch/x86/include/uapi/asm/kvm.h | 21 +++++++++++++--------
 arch/x86/kvm/x86.c              | 18 +++++++-----------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 478d9b63a9db..eeefc03120fc 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -412,28 +412,33 @@ struct kvm_xcrs {
 };
 
 #define KVM_X86_REG_TYPE_MSR		2
-#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
+#define KVM_X86_REG_TYPE_KVM		3
 
-#define KVM_X86_REG_TYPE_SIZE(type)						\
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
 ({										\
 	__u64 type_size = (__u64)type << 32;					\
 										\
 	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
-		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
 		     0;								\
 	type_size;								\
 })
 
 #define KVM_X86_REG_ENCODE(type, index)				\
-	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
 
 #define KVM_X86_REG_MSR(index)					\
 	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
-#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
-	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
+#define KVM_X86_REG_KVM(index)			\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
 
-/* KVM synthetic MSR index staring from 0 */
-#define KVM_SYNTHETIC_GUEST_SSP 0
+/* KVM-defined registers staring from 0 */
+#define KVM_REG_GUEST_SSP 0
 
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9930678f5a3b..e0d7298aea94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6057,10 +6057,10 @@ struct kvm_x86_reg_id {
 	__u8  x86;
 };
 
-static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
+static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
 {
 	switch (reg->index) {
-	case KVM_SYNTHETIC_GUEST_SSP:
+	case KVM_REG_GUEST_SSP:
 		reg->type = KVM_X86_REG_TYPE_MSR;
 		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
 		break;
@@ -6204,15 +6204,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (id->rsvd || id->rsvd4)
 			break;
 
-		if (id->type != KVM_X86_REG_TYPE_MSR &&
-		    id->type != KVM_X86_REG_TYPE_SYNTHETIC_MSR)
-			break;
-
-		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
-			break;
-
-		if (id->type == KVM_X86_REG_TYPE_SYNTHETIC_MSR) {
-			r = kvm_translate_synthetic_msr(id);
+		if (id->type == KVM_X86_REG_TYPE_KVM) {
+			r = kvm_translate_kvm_reg(id);
 			if (r)
 				break;
 		}
@@ -6221,6 +6214,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (id->type != KVM_X86_REG_TYPE_MSR)
 			break;
 
+		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
+			break;
+
 		value = u64_to_user_ptr(reg.addr);
 		if (ioctl == KVM_GET_ONE_REG)
 			r = kvm_get_one_msr(vcpu, id->index, value);

base-commit: eb92644efe58ecb8d00a83ef1788871404116001
--


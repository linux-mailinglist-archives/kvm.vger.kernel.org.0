Return-Path: <kvm+bounces-52770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE463B091D4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD0A4A10D9
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEA32FF499;
	Thu, 17 Jul 2025 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CC/GuS0X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C452FF469
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769674; cv=none; b=TBIsuo5U3GsXygQKUy2bKuMSTCwPP3BIp/cXv3aroOnpCSGvw7th5MPe8daOBupR3Wbk4LZevPh35GLTrmJlKWfrNh7Mh/bf688PMi8mUvR6wKjShBBylxGBzvqEDPNfTm+1B85gaLGU7uUOLmFAbrLT6mNFvvximlAXKP9FeEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769674; c=relaxed/simple;
	bh=1w8Rf4FIk8UShH9xK6GMjNGhBeuY0pcttrOoAcb/Rxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/5ZwkD9maacicVLsDFUcFno+dqf3FG2ofSqeguRMYcXMiT5xAC2U07Oa9OYvSFctnNf1jm4limEeibvkozSaqDW1bGGQrBc2IzwPH+LCVNDZW/atcMqqXWjt+ZgFKuw4YduOiiJaal2c07Hux1daEVuKt11Eb/sIbwhT45CjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CC/GuS0X; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso555240f8f.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769670; x=1753374470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=CC/GuS0XJHYakQWggwFikhqw+1eueHYqfYIIfWMC4Hyp8DSEybYoh735extcv32V68
         kq05v6nDx7saMHUP8bZzeB0YaES78Hm63PvS5Jt6dDarIsEIfIMmT1VHdDmCLVYavEwU
         zYN+IfGoofq2DXeTg9L2BM6yHKhhbaggUVT40F2ewfOYPRl5RLpw8FshXeSrotG10ef9
         4NJi1lxkeZuFWvMQwWawlJYOdrYxGYgV5KsmZ7pDIk8GvISwf/12x14deDi3CwYqnyb8
         9ACwqFm0+BBRg2g+jGGtJqly/mDQAf4dduZmfNJgx5WQjNSjP1JQ33xUsjLS9nmUAGM2
         OWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769670; x=1753374470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=TXBIM0k/KgxBh/mUFgZoNe+EVtSspBUsy0KSsmc3M0cIaaM1q7+LGoLSBh7rDOzvEt
         rndsCRmFOcuIGsXreW+yrdMd8SXKv64q/ZGQP6z361ICgwsFiWieJodb3WdXe5XVeNsT
         Okr/ip1PmfXEK31Q4xN9aVPVHCxUU1oRx2044+O4+21sJgZZcVLHulBSn8l+NZ/1tB5x
         pOOdYb+JqQ1F89WjSkPWNz42GGFsDx5g2jc5reiY9odSVUk0FisM2D/hRaJPxg3ejrSQ
         hFB6AkJv5T21ffVni69Or8OJG0pdz0BO5cf2gmCatqPNEfNF4cp+T87wLQcj0weWRjiH
         EbLg==
X-Gm-Message-State: AOJu0YwTOdTQjUrim1IjYrm5FDWxAqPhOvGb8ZyeHOQCuaKsDm9ZUk3C
	McLtvjVjgLBUfGDxRGMjhaewrhdRGcKuHkalJBZ1/rJpbvsdH+yiVnAYPKYkxKivLlPaWOasxY9
	xL+ckBPOUVXkXJof6scUrKhejKJeTIE/Q17/IVr0Byh4yOnRJzq4TURsWEWKFn7qrYkC1VcUraK
	1tdYrsOPde+nC/Zh3W0VXre+CF9ZY=
X-Google-Smtp-Source: AGHT+IGrLJKVjEgj1SDZnlDcjyoevRtzuYkOn+gCuJEKU5WteK+MJa4KEFRnnHxiW/w0ZR9dr94c/ATmfw==
X-Received: from wrus4.prod.google.com ([2002:a5d:6a84:0:b0:3a4:eeba:2067])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4305:b0:3a4:d0dc:184d
 with SMTP id ffacd0b85a97d-3b60dd95c4dmr6783204f8f.27.1752769670073; Thu, 17
 Jul 2025 09:27:50 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:27 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-18-tabba@google.com>
Subject: [PATCH v15 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Handle faults for memslots backed by guest_memfd in arm64 nested
virtualization triggerred by VNCR_EL2.

* Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
  whether the faulted memory slot is backed by guest_memfd.

* Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().

* Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
  Some of the guest_memfd errors need to be handled by userspace,
  instead of attempting to (implicitly) retry by returning to the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dc1d26559bfa..b3edd7f7c8cd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
-static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
@@ -1216,10 +1217,25 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 	smp_rmb();
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
-	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
-	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot)
 		return -EFAULT;
 
+	*is_gmem = kvm_slot_has_gmem(memslot);
+	if (!*is_gmem) {
+		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+					&writable, &page);
+		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+			return -EFAULT;
+	} else {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		if (ret) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+					      write_fault, false, false);
+			return ret;
+		}
+	}
+
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
 			return -EAGAIN;
@@ -1292,23 +1308,36 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid;
+		bool valid, is_gmem = false;
 		int ret;
 
 		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
 			valid = kvm_vncr_tlb_lookup(vcpu);
 
 		if (!valid)
-			ret = kvm_translate_vncr(vcpu);
+			ret = kvm_translate_vncr(vcpu, &is_gmem);
 		else
 			ret = -EPERM;
 
 		switch (ret) {
 		case -EAGAIN:
-		case -ENOMEM:
 			/* Let's try again... */
 			break;
+		case -ENOMEM:
+			/*
+			 * For guest_memfd, this indicates that it failed to
+			 * create a folio to back the memory. Inform userspace.
+			 */
+			if (is_gmem)
+				return 0;
+			/* Otherwise, let's try again... */
+			break;
 		case -EFAULT:
+		case -EIO:
+		case -EHWPOISON:
+			if (is_gmem)
+				return 0;
+			fallthrough;
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:
-- 
2.50.0.727.gbf7dc18ff4-goog



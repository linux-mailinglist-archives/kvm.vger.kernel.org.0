Return-Path: <kvm+bounces-53219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B772B0F059
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B947AA67B5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740B12E54A3;
	Wed, 23 Jul 2025 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ptvrHSw1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C3B2E49AB
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267660; cv=none; b=YEPnMAP8pISAaw7OyprYmQcNVTbIkRjPbaN9cWFX9wy0NKehFVOPA5a8IKdpIn92R0rzNzQG76h5NLfR+kh5Mk7rrXa3n0n35qBNjBQ+0vYH2oESeVTdJ9evLMmNOD4F6Qh7JLjZVOnZ1j5v4O7KAku7PjGqvQnYB3c4KOP5eMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267660; c=relaxed/simple;
	bh=eCDIU4W7AYZKs5u75nkP8rbOQPe6kfu1T+spxjDjQ8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XRIxREENQ9zBgx5zKYqULYwHJMTdSnyWos99aLUtHE4M3+AujjCJglWU2fz7BelYr91Lf2F5IgqwjVNjESij5JzvuvTDGAb1r7h0jmMQwK50gX9YGoT97bFwPHNm78VyHsXDZ1F5XpGu2C4rMVeBvzxR/FEqdcftEgxoCwGCoZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ptvrHSw1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560a30a793so26731795e9.3
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267655; x=1753872455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=ptvrHSw16fg/smdlwtI/SyF2AKcCSRlT+qiE6Oc0i23/pilqFSQvLz24zMwTQrbhqC
         Cmx3HJuYboqAPXABozUxxYc1SFowiiVv+0f4HG9dzUeU2OBOnwGIl9gn6VDV5s0YOAo3
         8E55MBXw82jJ8KUNDi+51ULNMFxDY5IXHvvFw1CaO5EN/LWLQ7513Lb/HKu492KYWO4F
         KejlZvcXu4P1YTxF1cjn5vezymSFk+wwoogoAt4iZCWLwqkhlaGDqtx2omrFPPjhMckJ
         XE3+IMXWG1lfgIi1enfXz9TDDlohV7gcOIolnIDw3+bJp8h7vNl1uyli2yoJXy9PDKJ1
         mekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267655; x=1753872455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=XwsFP5z+/0ffJQOM4dfibznX8YkX+n5ZeiI+CnnltkiJXKOKS+FAv83OxA9IkzOKiu
         btmUfnufL7ZqZ3eJfWSJ7TwqiuJquf9iPzrxCB0Ih1oDLEfn8SyE+s4TYnHFL+cltpUf
         qCEQ0woYmM0+iPMMF49virfVu1vKGmEyc5Q/GTGRPw8upq+cZLrR6bq2u6LWTtCSSxKK
         fQYcfM6XdLAk6AHaQTVUfeedO4KpRvQNHZDQv60INzEAe6hl1Rv8wJiOmWqxFeBYpKHI
         7IknYXgpKg/p0DjnworFvGIZEUtDfwR99b9xDkGysZuk1ed3ugq32sWzT82+CFZWtlt8
         UCGA==
X-Gm-Message-State: AOJu0Yz+kr75R9z7Q2dwTzp55bCubbYI0TN8/N6MB0dnf7q4LyJRPU4T
	r0b7swxOw/pOeorh8zP4t4T0C65rItfzg0KXgSM2Ef8Hk58EI7ew9xLca/SmfHFU3BxyFy7hKZk
	GTepnlhr42LoXCZQDulmOnRXEOL/+NjTaXqE6XoBGiClJeYDJuHpNlACarFCE5Q/uzQ4s4vF492
	XtgQDEk0VN4mbWkcJFIGX2KWnE5uE=
X-Google-Smtp-Source: AGHT+IF7LN4zz7H7kl5hmHOJM2RWeLy8eWEca0zN52GnDIcb6JpxZKh2nX+K8PpdE1V0cGZIooZEsfLT5w==
X-Received: from wmbdv17.prod.google.com ([2002:a05:600c:6211:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3107:b0:456:1752:2b44
 with SMTP id 5b1f17b1804b1-45868d2fe87mr17408105e9.23.1753267654654; Wed, 23
 Jul 2025 03:47:34 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:10 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-19-tabba@google.com>
Subject: [PATCH v16 18/22] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
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
virtualization triggered by VNCR_EL2.

* Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
  whether the faulted memory slot is backed by guest_memfd.

* Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().

* Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
  Some of the guest_memfd errors need to be handled by userspace instead
  of attempting to (implicitly) retry by returning to the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
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
2.50.1.470.g6ba607880d-goog



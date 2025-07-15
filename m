Return-Path: <kvm+bounces-52485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EAC2B0569C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04242189B1D6
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F222DE6EC;
	Tue, 15 Jul 2025 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v3cVeFDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30012D8370
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572071; cv=none; b=gaG8sj7oRFpui0nZHIsoy9XqqYeyQSZ2HOJB/mdY5HibMYDx1ZbPxdtgtlDqfApMPTPI/erZTC4NIPXjSaLDHdvgFx5JeJfssjAZnkWHbZ50rE4oTyjXo+ahwTqiio8TCoYzELFaNPpEREvUrJGASBmYPow/YSsOLyEpcj44WgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572071; c=relaxed/simple;
	bh=1w8Rf4FIk8UShH9xK6GMjNGhBeuY0pcttrOoAcb/Rxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VN7r3bWePgZwsr3jaL0jMF+Z/eVmnyqcBaAwIaqeB7ZFLdOFqew/ilvzsJrsC3v4rpinigQHe6EuLvlyOvQmqXsB3t797AEEml73ihN5hO0d1GFvY1LpPK0nbHAq4aU5TY2+F06f3wKruFz5Tnvh+JnuQqkZmz3bGv6X3NGB7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v3cVeFDn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45624f0be48so4830085e9.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572068; x=1753176868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=v3cVeFDnRgeWg94TbrLopPJutD9PXxRCdLhXg7eW/SRZtNjFHhqCwXeT6zHsCCmBHa
         sTaKp/YoCVCZHx+wXfQesSJeEJGSsLaJsv1ZeFeCYDAgt5N9gdG4tv/1EO+qfSUyc9lO
         rZhxJXZ7NAkb8Hxa6c+y80Fsn9LfwDprYcIQJmHooYg2j4QFg+h1v4kmxcwzljjKp2RI
         vGQWHuBiGqzFaYcQJJAJyij74OkoXu/G7srCLc86Q2MICpxs5GFX8RF6CbUiaRy8F2vD
         0e1LlKTSn0FTm70uJJTxrkIatTiDUHxoPf8yhtbklPCmUF9RjAbUHw0tokR+1GU/OGdx
         yB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572068; x=1753176868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ed5EKdzH3JskFWB3i3+fISnWrXK1xmjcG1/JKwjT7fs=;
        b=EMe3g28KkP/LYKzdT4pJEyAf8ojJnZItvWWo6S9q+XaxLcaxhpR/7hI13bWFOlzPFz
         V/DmR81nAp1YhQ5D78sooWFzMqjkOyR4KbHKCqEkKv3aZolCUuirs9D2K1Mgxn/cl+vd
         he6LgGYEbaRloEEWOoclSA2RMTKdsin1P0er2asjoVDPMvdYT3x3bfU/oiLnCUViwCK0
         sf3HG5hK7FAh+CQaBs27dzBQgqV7eKK2tbIZdH8V5vT7ZePSIX3m1RBjN6DNLm4DewWd
         Bd/rK9m5SpD8VhJEDTNBugNKWNkUgsjgq8ZO5Br0dRhV/bKRg9wv90omCF2QyGIv33Vu
         0Kvw==
X-Gm-Message-State: AOJu0Yy0T9jLd8LkyFTGJvf3Lkeunn5AfMrlr/clJh03Nv7D6zTL3YyV
	0Z/WP59n880IHiQ55ItT9pnsV315k7RNvauDH+Lk4PqKFvZsWRsatTuP45Vl4fIIAu731aPWaFK
	57DxBSA5G/0UzD+o2pocMPhGXQP/JDSKa1GoqN3hwY3gRDVwm51wGM/vpGdVvH0jkg6rrEDtrN8
	oOXE+Bbad3JjwLdSHEbDV+axcP/L0=
X-Google-Smtp-Source: AGHT+IGBogaOn/a2nRCbQgtEGBqaMIjNeCnMyNgJrpcQg8cMebuy76dboaZmnJsfg8PNbJXBbdCUps7GZQ==
X-Received: from wmbes26.prod.google.com ([2002:a05:600c:811a:b0:456:217f:2625])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34c5:b0:43c:fe5e:f040
 with SMTP id 5b1f17b1804b1-45565edc8f4mr129943955e9.23.1752572067858; Tue, 15
 Jul 2025 02:34:27 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:46 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-18-tabba@google.com>
Subject: [PATCH v14 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
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



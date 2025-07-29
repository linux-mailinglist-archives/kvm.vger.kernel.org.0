Return-Path: <kvm+bounces-53699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DC4B1559F
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A8B118A2E68
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B922D3EFB;
	Tue, 29 Jul 2025 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hWCpEuZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2932287259
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829766; cv=none; b=F9J38Wv/wTxVt7m/p72FNdU7SVOnN5szmc0l528SXE6ukmiQu/6slvjiThAyCE6MHaIEPYvQVx9LKAFX2xSh4Gm5vNmfpjofyNwXiYy4L7Aevbvg9l9g5tlO93Zm/x02U2la+/X447IUh5LJcxVjcmKBU1/KAZAcqXz9emWLFZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829766; c=relaxed/simple;
	bh=maUowEREwbh42ONfrRcy3bj/yfM0pHhiYCFRpCgm01Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y18kKyU5Hk3Gfz6EQd7xLPdxXzJK0PZBkbh5Qtx8Ft7BVyxxO6F6vlapOgXC4uBLBpb3DCiRXGEGxWQDTc0qjCsQ+mgzGctzmrdgZLPczb1HHGsx+yaQbysLj/2gpH9iJkQ77zBzcEbmbO0x6wYWoGBvE8aNV+6UpVkUj6nLn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hWCpEuZ1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235dd77d11fso63625365ad.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829764; x=1754434564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2SSy7htSrqmTnWDs8KQ8CPqcAnDaIUsFMxYImLgL19Q=;
        b=hWCpEuZ1An3pr3TdXxEdpjXy0XQicW06AO8yagv0zQUvssyuhEacwHOK87QTmVpW/W
         1I08qTM8yZk4O27m8VsqnWJi3MY6Hein+aPEtK5aECCU4vJfvzTrFFINMh/RX+hhr1/i
         ZcPJJfQuaLLVObSRXfor116QUIcgGaFdgitutdnt8gO1kaTMZmh8eL3eS/Ry6I8Hp8hA
         Bj1tl4b7SG+N6+vf7EHTqY5Q3ttdg8oJIN9ZKHP5h7IgFmxUE6FykkBvEut3/vxl17iy
         eeDYS9PzUW62f3vFdQLdqWi82j2z48hZ8HkougJ/h5WK2jIO/eu/pXgd1jju/0jygtmc
         UozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829764; x=1754434564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SSy7htSrqmTnWDs8KQ8CPqcAnDaIUsFMxYImLgL19Q=;
        b=wS+CUdBVSqFQqVpxiTyFNx3l6B/SfkpHfosNd+wcfD63MDS4dGCwcS8IT2kyO0DR9S
         nxa9Q3mMD/U6yWzIgytQJkQ42Xp2J0uPFDaAZ3xY2QBKxedypyZrqaNzMs+cEAqZlTLv
         txhpSWqftUS4xiNk2LwWDqRgVF3pFBX+qDagfMO5St7ijITu+8Eu6XD/YTms4jk2vx3/
         GSp4Ckpesk1AXVsMVWCaICDifNTIesXc1I08AOKRUqZGM73mZBeBq98j/+lLBfe1t7eq
         WePgyEiD3df7ekLNvUOR3aCJoG4jyYq/E6CF1c9Yvs7Ffa+qzxljgVK6n83/YVcHLrfB
         pmgA==
X-Gm-Message-State: AOJu0Yzlgrcw7SGc7MUa6VNEQlcw8M0yNsQ5hfyzLrVU03eXBxg4wFqW
	DunGZ/QTrGEOrVGYt/grW8O1h3h1OZ9Of9w/x0FsGfI4IQQkfgXNTGsBo70V3aLJRsjQP5UQ2O1
	+bfvCYg==
X-Google-Smtp-Source: AGHT+IHj/510Mv9kPU5X6CNDct4tYO3yblGBJUqMpY3W6X6yaMqYIgXW779LIryKFKVtTEcES1VIMsFWj3M=
X-Received: from pjbsh18.prod.google.com ([2002:a17:90b:5252:b0:31e:cee1:4d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e541:b0:240:7c39:9e4e
 with SMTP id d9443c01a7336-24096b56cd4mr15158665ad.44.1753829764046; Tue, 29
 Jul 2025 15:56:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:50 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-20-seanjc@google.com>
Subject: [PATCH v17 19/24] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog



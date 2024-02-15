Return-Path: <kvm+bounces-8842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5477F85720A
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 058001F22E75
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCFB1474B6;
	Thu, 15 Feb 2024 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NURQsrW3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D703314691E
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041263; cv=none; b=Bus1ab7lMDP7u0Gj4BJcBKY/rN1Ida8f1ES3M4FOROFQsbg8dJUW9ViWLbjXwU1eRvW2L1ladwqsgpLbUok0gsugmIgSVA22j3dtu2Pfa3wWgJAjQDeLGwwplqnCiB1eany5Jg865Lh5GJHg+fFaEOrxeJHgVypS4gT18LxU3f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041263; c=relaxed/simple;
	bh=YToCq6YE1hZ8sueGTK5tm1JNAU/Na0mmX/7tgTx5B8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fo2XCJibeBJm1G6x0kfQFBTqTH/3d+BneEtUKuevszcHTjRmxc7m9IU9HDXbEB7Cadebq1U3fuz12p2tJG8wEIQiP9FqgUe+yvQDZsto8y29Je606v1alc6Q+wjvaNickocKcpcSMB0PJNCXHdL2bG0Za5w5DEHRab2xrUiZw84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NURQsrW3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so1969392276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041261; x=1708646061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a2S+MA0gE/d7KfEW/MnTZniPFqQuhRYWD821pFFz3JE=;
        b=NURQsrW3eOms4ZDS4jYXgFva3Z1rTisxJ3VEczzy038YLln0o3G3RCC7in0QIbBgrv
         +Ur9UC0mAC+HIGr0P4c4Pqc+JlM2QT6snq6f+aUpODs8Au5ya+Lo6sBQ/ND8VIkmVg1+
         WwrWi2ArHDg261jYJfeLAtxHsvCDnOWNxLbgloM0iAIKrXN0f8uqEnzV1gsZuN/jGJvR
         yfOK8kaEzevH2YW3fW8HhvxP6Hm6VHSCf4WhCYlPC1qAErLqjY7QHdyn7Cr6FYgW059X
         57P0eq2AxLeXFKksfx4KvCepvv5n6UJ0iaSfzse1qEufh+0FOTs3cvOM6O9PkwKRNjTs
         KkAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041261; x=1708646061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a2S+MA0gE/d7KfEW/MnTZniPFqQuhRYWD821pFFz3JE=;
        b=h190taYnOnBhEpJitZOLH79rE/c6WY1rRFpFztI+RLML1esAo+Wa9Yuw41TdQBdWj4
         ukOAwy6wbrj7IHTh4gybr13ovXvbr46ar3LqVAYlJC3wJr2TGUqy/9AoU7But+5rA2xM
         k3fWcDyG/rEDgD6di2RE3uGF3vymvc/Vj0TB5QTEKLg0M/T65pyp4hVkfQhmSpJJWSFB
         r7d92i+uB3T+/3VcItGn80x+zfTNnzUxXwY1tkYo+HVjeIXLmpFwB1+/H1hF8iyDS7vy
         6BX5ENWKl4O2Pz6fUHSEdhrcFgNV8ono7iOUyvBpehZTbox/VjUZZ/pPkpnbjLsB28+4
         mhCw==
X-Forwarded-Encrypted: i=1; AJvYcCXfKA4vJNAn4fqtz9ASbcxoS3Keq0IUFe8POqeIELCI1JVGHo/rUqoTAdnm737p2x7a3wRQ2CHGkPh/skN50cObU1sc
X-Gm-Message-State: AOJu0Yyh/JbUZdLeBuhZdMULYJg9tNadzTmncp0yEVoCA1zuzjDWZK+N
	5r2tmQq/6mIIYlmImvSG1FZb+SIjBxbTav2Y+ZgRCzI4z5dbV7bABHDhWoCIceDvMr4p/5AVc6h
	p5BT3BQgV5A==
X-Google-Smtp-Source: AGHT+IGz7VwdL3z2Ro5FaEmODCGgndNM7ib0sMxb1cnlGqMmU2k8rLAE706Rj6Rrb94BZLFTt+/xxEEKwv9eHA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:110a:b0:dcb:fb69:eadc with SMTP
 id o10-20020a056902110a00b00dcbfb69eadcmr129670ybu.6.1708041260877; Thu, 15
 Feb 2024 15:54:20 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:00 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-10-amoorthy@google.com>
Subject: [PATCH v7 09/14] KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
call to check the memslot flag. This effects the delivery of stage-2
faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
can attempt to resolve without terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 arch/arm64/kvm/mmu.c           | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7012f40332b3..01b762272b6f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8052,7 +8052,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 01398d2996c7..309d8e7ebc1c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5b740ddfcc8e..b0f1fef0a52c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1487,7 +1487,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, false, NULL);
+				   write_fault, &writable, true, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.44.0.rc0.258.g7320e95886-goog



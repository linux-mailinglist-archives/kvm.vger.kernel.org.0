Return-Path: <kvm+bounces-8840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69148857208
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B2B9286079
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32CB1474A2;
	Thu, 15 Feb 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NvyVO5ok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85DF145B29
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041261; cv=none; b=npJEW/XKqEL7yZJOwSHD1ZvKRCFjSzufKm0u4KrTMA3VmCuJhTlPSnz2Ud+oUqBp84e+7N+ZsWR1E/mtt6WAAHgFZVnFRq2QIRanDKOY00oSrEJeTgFppCb1rOXrQ5Oqw8fAmJViJjIYAIGqOeqSDyJhWSFruFV3xyOCasP0rHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041261; c=relaxed/simple;
	bh=7QKLk8/MiFSWT7rzgMqDtu0qXhHYiCMoynK98E8XTjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VK+8BlyDKtOaulhxHjTMwcbJsGs3ItCbLkwuOnH0zUQUaFTL4Mg9CTbZxC1zDi/6OQEDY1GsEIaoVynSXWHQ8Zc9YrLEdyUCzlVWUAPccTgpBL2vWNOJFyM16yAZRPyDBShIFO70NXSv0YTQ7PUKw4/oNOSt6X7bHhTi9qLdQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NvyVO5ok; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so282038276.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041258; x=1708646058; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=evAg07Tqv00oZcSIXy7ksZn9JBa6lYxUCa9nTQwmh0k=;
        b=NvyVO5ok4hdEuKwD0bPbc4oMqTXVcMyTUfDa2JKQz93mW5b8aXTqXx/KvRGzlpyzie
         yRXmSkIVIpH46P0rYCptgA5tzRrGhB+iRP8LjrLxDFXAwQ2PF3TgwpJgbwo+Vzd+76+v
         ojVMN0kuHbJYR9mHwfQi939zkQZ944kbpkXxBficZoMR7moya+Ee2zAkW3oYels/Umf3
         +1gioMH//wunIMT32h4E+c7K9azZrPiAehhosytNDzdvQeWw6MkmriKfMiU0dA5vcvoJ
         qPmhSzuMjUY7ODUD9CnhPKcEJcwxaDEfGDwYvsi4kjjKvQHy+0bas7Q6yVk1ka7/pAnX
         pd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041258; x=1708646058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evAg07Tqv00oZcSIXy7ksZn9JBa6lYxUCa9nTQwmh0k=;
        b=wtOOe6fgHTzujJVwzibvCdd8KOGOTsJEKyXteqJtbwlJsApCeg7+FJO9vqB1Ma3iwz
         sSvjweTOdfZVzRAI0Pg4MRgLKoXSS74V0XMdpWUINqrJbg9h/y0VRMb0qPtB3mw7PIou
         OBIhQMq3B7OjQTU2L9dTTk4QpyCNHzOURqstTsIjTn4q9i0iB2n4Y8Fu/s8eBNx6ancL
         jkSG9/AX2nU0n4a1FPGKCQDIZAIcJmLNvtYVSM04uMx/7CJprE8WlFu5i12obpqfOUGv
         5tRO57X4ljXObqP0xo1eyy6XP81yxq/hRunpK4HPysyjhYlqKAHkcYBsP2INvpt/SSVH
         3HJw==
X-Forwarded-Encrypted: i=1; AJvYcCUegsGCNfKMZK52FqOLIAXW/cnQstInCJzricGWFfWCGnGCuNcg0OFzIGSmB6y0tvEDh3MMmR4iwuyZXDvoFfXtUxnQ
X-Gm-Message-State: AOJu0YzbIKOC2NUfyxJsDRkErrwn0FnwEOyiYfU+QwcTHnR4wGMG08eE
	UM/msY2xYBHrADz0nLGNAUrrl+Ef7txEPDWf2Qo07V+I3ffHB7ETu/UvReVKk24ijpOeVbX/yCe
	IFXaPPikPXg==
X-Google-Smtp-Source: AGHT+IEL+octx5Ma1aJhkF6nQtctFbc2VuoDa/1F8Y6Hxj4I3Z7U8nf+fteVhEAb2t5g/T3+SnjYzZ3R4wNElA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:100a:b0:dc6:c94e:fb85 with SMTP
 id w10-20020a056902100a00b00dc6c94efb85mr126325ybt.2.1708041258630; Thu, 15
 Feb 2024 15:54:18 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:58 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-8-amoorthy@google.com>
Subject: [PATCH v7 07/14] KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate EFAULTs from stage-2 fault handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
calls to check the memslot flag.

To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
when the stage-2 handler returns EFAULT, e.g. when it cannot resolve the
pfn. With KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of
stage-2 faults as vCPU exits, which userspace can attempt to resolve
without terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/Kconfig           | 1 +
 arch/x86/kvm/mmu/mmu.c         | 8 ++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bf7bc21d56ac..d52757f9e1cb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8052,7 +8052,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d43efae05794..09224e306abf 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b89a9518f6de..26388e4f42df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3305,6 +3305,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_4K);
+
+	kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SIZE,
+				      fault->write, fault->exec, fault->is_private);
 	return -EFAULT;
 }
 
@@ -4371,7 +4375,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4393,7 +4397,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
-- 
2.44.0.rc0.258.g7320e95886-goog



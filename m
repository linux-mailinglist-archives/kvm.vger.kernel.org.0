Return-Path: <kvm+bounces-35144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F47FA09F34
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 283CC16ACEB
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B6513774D;
	Sat, 11 Jan 2025 00:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6FhCsFs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2944438B
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554833; cv=none; b=WRD77LMV1p+T4eC78tkdx+JoXk3UbPVS8SR3wX5G3BO0hkRoLM5wNL5leNk6JFFg1UCS3Sqsc3FMRsm3HFGU86409U7yk+Y83g0OVGMyrE2oNl790ux1DeBczO5KzSlvKs7HykKrf5kJgXSixWS/WF3mTyt++MMFFTLPUwLAY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554833; c=relaxed/simple;
	bh=srxRFWXBvHrISysQpsmByXcQcCBsfGALuZmTGX0HrTU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFOGX4VwxElZFaCWRhkVetVsg2q/kB7fs1dK08SCU5qGqwXjpuR/CDo4CxjDWkQfp50MMaP54nSFEmawCqNU99qj7ItOS/7apXXmQ5sDJerecxJtHxpnvm3UEUHAM9l/Q9eNark5PktY+OZBOf7tz1P3Z8PBLPC2NeLFQsI6jg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o6FhCsFs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216430a88b0so49519255ad.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554831; x=1737159631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D5gnrYLh2bOfd2KfhYLYfK3u+PPOZNNTRLHmwhfYjRg=;
        b=o6FhCsFsJh7FiBLK1FRCey6c6hE4Kaakc7Xx3xIxqg3dA9OuUl+oAUaZFsDWI9GFJr
         84vDdH0whrEsq5zp1RKlt/hm77VwS2mDcIDmOx35AZpH20v7VKY9OoW/DHwmQxwA+5s6
         wLz/Hpoo/0SJZ5Ge1s5vB3Zo3qQAvkBQJilbwYRicZvhJjJFT0jIt2TCvMKojTQg3eiW
         wLznb5+IQSxAJNxxFYgistnSdhZcdHmu7peO7iA6dJreAAXecI7WksrpE0pkAgraWmO0
         VM+m9eqDKMZbAzlZ2pFq+5neS2emZE277L3KlE9kaIft7uIxAryZo59KJLVn0e/89I/o
         YQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554831; x=1737159631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5gnrYLh2bOfd2KfhYLYfK3u+PPOZNNTRLHmwhfYjRg=;
        b=LmE+XDuDGqs4fSBUMdu/CAu9gBCPzjF1M1UfbrMYWkS6UbIyDsQt3OtSYv+STWj5Ze
         UJvqafM+nDtiYIBK40xfqMDeDbQ1aCjNFDgbeTZJ6SDUSe6Y9akUErvdzh8J4MWpD9Jz
         LwgRiSmqOFH0R/KTwZiOudSdINuyquMkhh13vY3JDOPmaMURksRfNSLjCWrQIfKrmE9X
         HkZz5aOXYgMdOKjw2q3Msdv8fFjMxgNhFDhfhS8xeTIOnqwniMqlllkvA8/1g3mlOKB6
         VF6VIPK29jkLIuPIOJH/n7TM1ZDsMQ5e5+4qFN4BhZwjrU2HVmvAL9fvqN3FoXk6HkAp
         AZaA==
X-Gm-Message-State: AOJu0YzqNZuKVSdupIyt5N5uctwnO+J2uRVs4Eb2wr99XfNfD0P+NnhO
	XywQPi/jK903AOqTF+RjJjAFFLyK50MKx+obaTrbLzVNIMahg/x90FFOcR/WCANs5CJsFViVB/v
	+Jg==
X-Google-Smtp-Source: AGHT+IGxsPV3oLiaWtBJNyEMPx1oG/v/eJjoOZVmnLqym7xeU5cTCoGfqlvryySu/bDBti/qJyF0gohE5Dk=
X-Received: from pgbfe25.prod.google.com ([2002:a05:6a02:2899:b0:801:e378:a64a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:78a0:b0:1e1:e2d9:44d9
 with SMTP id adf61e73a8af0-1e88cfd3cccmr17252164637.27.1736554831472; Fri, 10
 Jan 2025 16:20:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:21 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-5-seanjc@google.com>
Subject: [PATCH v2 4/5] KVM: x86: Drop double-underscores from __kvm_set_memory_region()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that there's no outer wrapper for __kvm_set_memory_region() and it's
static, drop its double-underscore prefix.

No functional change intended.

Cc: Tao Su <tao1.su@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36b5d06e3904..82f389e3910d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12928,7 +12928,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
-	 * old arrays will be freed by __kvm_set_memory_region() if installing
+	 * old arrays will be freed by kvm_set_memory_region() if installing
 	 * the new memslot is successful.
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8707d25a2e5b..dcb59d6e8acb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1183,7 +1183,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
  *   -- just change its flags
  *
  * Since flags can be changed by some of these operations, the following
- * differentiation is the best we can do for __kvm_set_memory_region():
+ * differentiation is the best we can do for kvm_set_memory_region():
  */
 enum kvm_mr_change {
 	KVM_MR_CREATE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e1be2e4e6c9f..ecd4a66b22f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1926,8 +1926,8 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-static int __kvm_set_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region2 *mem)
+static int kvm_set_memory_region(struct kvm *kvm,
+				 const struct kvm_userspace_memory_region2 *mem)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -2057,7 +2057,7 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
 		return -EINVAL;
 
-	return __kvm_set_memory_region(kvm, mem);
+	return kvm_set_memory_region(kvm, mem);
 }
 EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
 
@@ -2068,7 +2068,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	guard(mutex)(&kvm->slots_lock);
-	return __kvm_set_memory_region(kvm, mem);
+	return kvm_set_memory_region(kvm, mem);
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.47.1.613.gc27f4b7a9f-goog



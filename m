Return-Path: <kvm+bounces-35143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39169A09F32
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2140B188CEB2
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A864E4D5AB;
	Sat, 11 Jan 2025 00:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5qmcVK9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470971BC20
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554831; cv=none; b=eZH9mIeUjrsSkcMIvPZRpQYu+tnOMlrWMGUvwtf8DTKAs8uyBeu+oCE+0YOSoVKNQ+fs0wUBnKrxgYFq+hjVDYCJNqmYUld1Pfqt8g/ROWqioxJev3Dx1jogMMxhXAu4tMAaWVUHemR/hZjImRiiw5A3Pe20mA7OlCcyEsaN/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554831; c=relaxed/simple;
	bh=zx4dqWjk0j1kl0acCQQPeLTqubWJGVskp3jgLunn0Fk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WSUkdO6+7VKhyPC1WpPf0er9+EP3jjFEg80HnOh8eF2rRjuCgah5qwWdTs+y99GOIhxKrI7sw+Wt7iqmByHyMFxCz8opDR5eyftKqCaqAQby4qwY0p7eQ7ZSiJeknoFLp0lqJLCT61RjTYiB0XEb/rAW1FGPJpRrtYUV+JpTYrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5qmcVK9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2164fad3792so44085425ad.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554829; x=1737159629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eB8gBJuxbpe5X48d9PLQPVBWlx8r3t3ZJrmp2uj4RCY=;
        b=V5qmcVK91kTOaaFafo+noRd7hFTFGWYgRGNy6TrYaZonLEafH4g5n9sJ3a1sSHz499
         oHUYvpLiLAU9rA+oXinLWea8SaxhtvR0t+CGvWNj1bxde4rc7Vxn8Wr3c92um6nbf6Id
         9NztDY5t/5lRrFMHSOEtS+rTLGpbpYLpKI6PLFbVkqG+mL9CmDCsiBe0JSqMpYmgZhII
         btCR2xRz9EA31tgso4nXr4tU+YYGZOww00d4wDB79ySLi6yxXTzF/13rxT7drAq474/q
         6LtjAsEy++7z0MtvbkZ/+3C3Cs91oxozAC6ttVv/VvB84zMWC3Of2a8XCKm5oKvTyONe
         R40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554829; x=1737159629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eB8gBJuxbpe5X48d9PLQPVBWlx8r3t3ZJrmp2uj4RCY=;
        b=mpoj9IlHZoH56aexEdcZwwoTSLLQl5+8j/AJ9gR83nqsIS5ggyqMz+h+8GkcznvwFV
         M/i86+LEwRYvtrpR3tROju5hkNS6jWZqSjrOLx8O8k9wFAjLczohu9vloQvOQWWEWV8F
         2yOGBR4s2sgLA/7CXXwC/oA+V5vA3JevB2SNVaLN1Ag0BgNek//ufrVbgy6WROyT9Lfl
         WE02eQyw5Ni08qxfU4GKQ/R5Fbh8mBvZFzc/xzOWCPqYeM+5PN//wbucv9H+RGf293FY
         vMaIAecBTNWt2MVfIWsKrhHG4o8UQhUMzckmqZig8WkNJN8u7K/vusmAUYTm8/Dr4jQ2
         HbfQ==
X-Gm-Message-State: AOJu0YwP0/fVSHn/IfI+V238zcO9GO7VviK1iU6LPCxvnKvdHmqnyMo9
	9fYIIWGCKG3nMRcA5z6j/d+ZQqjLn5gmjZJ9JNrEA5ifC3b9MCfySUgeT144YtrXOyk+/2yFxLO
	KIA==
X-Google-Smtp-Source: AGHT+IGNsgJP7koT39cFwI4Yg+3wXDCAQbpwSVw/Id0arVP5ZQq/8yJYYSBpdXsIn/H3/U0UxdATkYQDmUo=
X-Received: from pfjf21.prod.google.com ([2002:a05:6a00:22d5:b0:725:f1d9:f706])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c88b:b0:1e1:a693:d5fd
 with SMTP id adf61e73a8af0-1e88d128f5dmr21173841637.25.1736554829616; Fri, 10
 Jan 2025 16:20:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:20 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-4-seanjc@google.com>
Subject: [PATCH v2 3/5] KVM: Add a dedicated API for setting KVM-internal memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a dedicated API for setting internal memslots, and have it explicitly
disallow setting userspace memslots.  Setting a userspace memslots without
a direct command from userspace would result in all manner of issues.

No functional change intended.

Cc: Tao Su <tao1.su@linux.intel.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 15 ++++++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a861287a67bd..36b5d06e3904 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12827,7 +12827,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 		m.guest_phys_addr = gpa;
 		m.userspace_addr = hva;
 		m.memory_size = size;
-		r = __kvm_set_memory_region(kvm, &m);
+		r = kvm_set_internal_memslot(kvm, &m);
 		if (r < 0)
 			return ERR_PTR_USR(r);
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7443de24b1d9..8707d25a2e5b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1192,8 +1192,8 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
-int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region2 *mem);
+int kvm_set_internal_memslot(struct kvm *kvm,
+			     const struct kvm_userspace_memory_region2 *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7d25b50cb298..e1be2e4e6c9f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1926,8 +1926,8 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region2 *mem)
+static int __kvm_set_memory_region(struct kvm *kvm,
+				   const struct kvm_userspace_memory_region2 *mem)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -2050,7 +2050,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	kfree(new);
 	return r;
 }
-EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
+
+int kvm_set_internal_memslot(struct kvm *kvm,
+			     const struct kvm_userspace_memory_region2 *mem)
+{
+	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
+		return -EINVAL;
+
+	return __kvm_set_memory_region(kvm, mem);
+}
+EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
 
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region2 *mem)
-- 
2.47.1.613.gc27f4b7a9f-goog



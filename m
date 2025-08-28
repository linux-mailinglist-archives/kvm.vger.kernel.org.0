Return-Path: <kvm+bounces-55987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6926AB38FC9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F369461B21
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B781AF0B6;
	Thu, 28 Aug 2025 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1L5Baxdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE6D52F99
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 00:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341012; cv=none; b=otIQmlQLCon8y8FYVwKwtU7wyBacpB95RKLvx9iT+0v6zdH1FhEEclb42hlHeBZjf0oFhuXr5sIPBPrGKbS+An990Orftdd3pWxGTh7u/bAIGrmI2gOUCwmytyziqR/8xCftxVQX9WY9auqDCxuEbaC0ebTT8CmLrtNwcS13G8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341012; c=relaxed/simple;
	bh=eXOBXpkZ02+fsWzn0bIQcLlUn2dEHSjQIN6wZt8ejTs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RxjvrsHSRRcCjO7lMEcT3rWqBfXRVVBIu/SHaYhLzWdhz4ESnovAlCatzHXxGnHe19FcHbPmks2aQ6MFSNzUGnBi5nAjbnLlRV5P+dhlBrn7UJwa7G9tDHhuTbd1V1ggyItfVBYAbyHjozAMhrN2ZqYZsKIsNK+0Z/iGUiL090U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1L5Baxdr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32775b74143so644492a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 17:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756341010; x=1756945810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JQQriFihIdlgv6YMIws6gyaIkwUMDRppRrS82dBz+Zw=;
        b=1L5BaxdrMV1oSDcbl8iut2OLp2Zv0zQ4x2L0w1cI1+2XlHEku+KHhkW10OaMYTSc2W
         DZIqZpWihnSkU/77eCnQcBibH73tA+jdKz2K/Jtkxo8znqAQy0pyd1E4IxLdUXHhMRcf
         6p+nNBZYv0lRjX5Z+EFVe1juhgEbmSyp7cEsmyI5v6EG4kVwi9wD98CrEgakZegi42YI
         gzrYtH/0HRWoAK+5WYfwmVV1NpYrNp5gS6mnJHTwS2JRIEI214mVmHyI7yi1rd53q+W4
         3FqOAqM6imY4ONbFq2RhhcV0gQdRgW2GbF82RjfFbHI6zp1x2NgcTEs9MFweu0f9/1Ii
         aUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756341010; x=1756945810;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JQQriFihIdlgv6YMIws6gyaIkwUMDRppRrS82dBz+Zw=;
        b=URJDNkYv3LZKCXYFfUH6DtRQw2MpFYomlid1fqj2tArZ2aYm1sINXxul+6zJLbOJDp
         cD7XpFwylRfqTKV5I81BQd82DWB3jI4FNXoc/cvM0ThW1b4PDClsovsjLpo77oW9fr0S
         X6/ThMeEUQm6giFxPfL9GEl3Bb8ObKHiLIOOs6BTSYECFRO8/d1wLf9zBo5yN1rSCL+g
         VHqRLLujoQGHwYkwwk9q97ph3R5rMDos3sEGu7LRNOQo34WdjCtKx3qQ5pGc6gxMQHKA
         VJNRYQFJPghKGVb8xU0oZR7sItYnkG1TZwC4DOrSO8zNoBqW0OSyT1oeLaBJdRB/UXtZ
         PRmg==
X-Forwarded-Encrypted: i=1; AJvYcCXum7YBS9XDGZpnL2IZnjk66omOVbdqHEzDh3H7ALHTr1dG7mVgjasdMBc95Ovu2ROgVss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+zKw+DDyg7cTWLYS+aPD1T6RZRwOvV375jMbxK/8F7a2Msj4E
	hMyLZbOniA0YVKblabxUgoBbhRR+njcwrKl32sBpW4A+HuAPSsfrvg/0DclxVbjdeuM97fawpan
	aiA==
X-Google-Smtp-Source: AGHT+IFB42iFf2X16dB5SpgPtPk8Ckez+NS6FJ8J1tyo8xQjf3Jv1HlXEL4rw9Bc9NB7vz3ZZqmTTwZ/CQ==
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:321:abeb:1d8a])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1642:b0:31f:104f:e4b1
 with SMTP id 98e67ed59e1d1-32515e3c8f4mr27001654a91.7.1756341009888; Wed, 27
 Aug 2025 17:30:09 -0700 (PDT)
Date: Wed, 27 Aug 2025 17:30:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828003006.2764883-1-sagis@google.com>
Subject: [PATCH v3] KVM: TDX: Force split irqchip for TDX at irqchip creation time
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	Sagi Shahar <sagis@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

TDX module protects the EOI-bitmap which prevents the use of in-kernel
I/O APIC. See more details in the original patch [1]

The current implementation already enforces the use of split irqchip for
TDX but it does so at the vCPU creation time which is generally to late
to fallback to split irqchip.

This patch follows Sean's recommendation from [2] and adds a check if
I/O APIC is supported for the VM at irqchip creation time.

[1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
[2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/tdx.c          | 1 +
 arch/x86/kvm/x86.c              | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..6a4019d3a184 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1357,6 +1357,7 @@ struct kvm_arch {
 	u8 vm_type;
 	bool has_private_mem;
 	bool has_protected_state;
+	bool has_protected_eoi;
 	bool pre_fault_allowed;
 	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..6daa45dcbfb0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -630,6 +630,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.has_protected_eoi = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..57b4d5ba2568 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6966,6 +6966,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		if (irqchip_in_kernel(kvm))
 			goto create_irqchip_unlock;
 
+		/*
+		 * Disallow an in-kernel I/O APIC if the VM has protected EOIs,
+		 * i.e. if KVM can't intercept EOIs and thus can't properly
+		 * emulate level-triggered interrupts.
+		 */
+		r = -ENOTTY;
+		if (kvm->arch.has_protected_eoi)
+			goto create_irqchip_unlock;
+
 		r = -EINVAL;
 		if (kvm->created_vcpus)
 			goto create_irqchip_unlock;
-- 
2.51.0.268.g9569e192d0-goog



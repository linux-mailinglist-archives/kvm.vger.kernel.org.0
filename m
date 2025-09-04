Return-Path: <kvm+bounces-56741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC98B43232
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D2DE5456C6
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8535D25CC6C;
	Thu,  4 Sep 2025 06:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xXhFRW3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0EA253B5C
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756966815; cv=none; b=J3tloFY5tKf1oCYeFHxVckO3KuhZzx0uDW5LAcmYsDsApaXpnmg8ta89jqvh2jbj/Hc77hodV6y7ug/eMf08GBp6RX5H19Palh1OVDZpGQwuyd/ArATdtOFqtiXqAIxc32GCKQVntwXZWNhlP3GE9lIxrUeL4khGCxiUO5B61co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756966815; c=relaxed/simple;
	bh=L9IbDpl9YeAPbkNWRMRMo/b2Utf7GwlhkdtfUevFjGc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=puUhBsZjMEzR2tWAcA/Z2HHjn3KU5MP1dMqsRd/BVjqCiZtI8giEozxoo9QV22sULh3VJVW+2pP5mcL0XBE1T76b3ReDwOetVDMFFIGLN7A8ZozdKCSm2Z6dqtR+A9sBObWk9sntS3kpleYTwtyBqLIXKRGkO0Q50KLUmeOOmzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xXhFRW3z; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-249118cb74cso8697975ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756966813; x=1757571613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5quzDayhtAriGJg7zaAaFURysSpqDdXw5doHq+jt5QU=;
        b=xXhFRW3zykPGgerALfhOn9ooK2CNuKN7k7Yi9gnSkT2iMfAJKCZvEgyl2zl2kJwe0B
         p2xiu0fbl46cc1T+89aoeOdtjqeJ1MORxBdTWJlEBZDkg/TvXGOAQHubLy3Q8S6nr7m2
         yWrAJPxqH9XFh8QpoY6psNclGwYgTTuxcSom78jFzLsHjyOjoGt7XwgOKu+2ww2JLIX9
         i+d2GM+VdjyWsAvN5SxdOECR8Xk81UsHfTObGO+q+k3wJTl6WC9YWav7CFtT+L+pHdpf
         B68D7ulIUfybbAWQ/vXPS0eUHz0/Nzm6WFeS/sFU88/RuD4b2srdVsl6n8JgSCldQpah
         vT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756966813; x=1757571613;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5quzDayhtAriGJg7zaAaFURysSpqDdXw5doHq+jt5QU=;
        b=odCDx4ThEQEBh5Du/xIfmooR/d0Pew7azIHO7PJFV8Tq/Cv+2S52dMcOutFjhSX5T/
         oqesdZBr/2XbxfbPEkKktxFWMcloje8Rzc//3376ebVFBEL7F8Bbw8F2B1bTH0m3cvv8
         tXJISNYIkFU9KeJSX1i7ScXlbLfrw4MAGXQv1qCmFk4uqrIp5r4BiCUZn/g4YApIucNf
         nVtQl6a/2aYz1J2V762SmavB6NhCYlTsxh+pgH32j6RvbW7g4eGlA+VVra7hCgay98PE
         NvpbjDJEYdyVAHUUxgHV9syrZkJw+f4SE5uj79XMlOYuJ9GZtUrZXVdwh5gTlyNTP9b8
         fKiw==
X-Forwarded-Encrypted: i=1; AJvYcCVz520WEjU8knsP1da8ZRw312CK8Cs37trWRAJQOWlC5QPevAHAHY1s/2Jrd45AtDtsalw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuJseuGRC4y3jqnt5x6HSTdS3GZ8665Zk648k+ncWuBQr5gWLQ
	sLB3NcIEucb1uvEDl0AEtic5zdAR4PP4MeiMPfOZauq3nttaj5m0jHDWrAm1KTfNITPmislDzXH
	/Qw==
X-Google-Smtp-Source: AGHT+IF1Km48eiSONTRaLAhk/LxIal+ixyPLftV6nKQfAlBvSe8kiyLsI8+e4CycXRiD5UG9VK7pSCprOg==
X-Received: from pjbst15.prod.google.com ([2002:a17:90b:1fcf:b0:327:5082:ca1b])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8b:b0:249:113c:b676
 with SMTP id d9443c01a7336-249448d6991mr229945645ad.16.1756966813490; Wed, 03
 Sep 2025 23:20:13 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:20:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904062007.622530-1-sagis@google.com>
Subject: [PATCH v4] KVM: TDX: Force split irqchip for TDX at irqchip creation time
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	Sagi Shahar <sagis@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

TDX module protects the EOI-bitmap which prevents the use of in-kernel
I/O APIC. See more details in the original patch [1].

The current implementation already enforces the use of split irqchip for
TDX but it does so at the vCPU creation time which is generally too late
to fallback to split irqchip.

This patch follows Sean's recommendation from [2] and adds a check if
I/O APIC is supported for the VM at irqchip creation time.

[1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
[2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
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
2.51.0.338.gd7d06c2dae-goog



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3DA2E7D77
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgLaA3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgLaA2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D991DC0617A6
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:39 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id q11so31336444ybm.21
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vWz/7XjNeryyp630nr1DJj55bwLnjvhE7YDu01lE+Dg=;
        b=I4LgBOH8+yxg22Qg6fzB2fWAyVTEhg/xk4ZHl5/5gqdjzc+1roduWn+H8pQLUs3uJF
         i6G1w/taqQhZOjZJ0GBxfX+boaGsH+xG2acge1dCsJbnWeQyn7tERYX4D9tqXueKCpMM
         Vet+vU/u/7FHAJ4p4Ngk5NPXw/ZJvRUVdtIMjynLZBgI4J2FeT63XSmZ8M0oKy5pg2pd
         XslgNxpGbRIGNNwCJMCPOimZReXRRU8fV0lcV9p9d59V/+veP70rRmpS3oUEEMoeCnVw
         kCn7AnAbJ6KZKk7ehf43OPQdElAhpxHOmC5Aw8HhXf6f/1LX2xFCWVlgv0qWbyTVqSFj
         +dtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vWz/7XjNeryyp630nr1DJj55bwLnjvhE7YDu01lE+Dg=;
        b=pXrlEdX6LSV1Tb4YAHLPx45rURUBjjnFsOmCSlJiSwuY+YuwxCEMWAVUzrPmqFJYDv
         qJZzFiGf/OPMuZOT9W90hh/VA+cDK21NLv6OKGs2TXhTyxtGzzj7bqI/lOpKnhBMveNd
         pMp2+uGl9MsiVMNBh5Aqmh40cE99TKZCgzX5d7foFc5Ct4B6VuQrNXFWNgNPG7VltBJO
         p1gEwc/mr4oPxUtuf3UWif5ukGk6UTS8HSs7HaXqGCyCCJXZCmKkz2uwAW9Xbe9KmPO2
         +9llijuvcSj0t9d3fNrhRdyFhg1yhQLiVrz+Z4kQDtKcZfjGmfefSWuJFJREW6YgCYo8
         KxFg==
X-Gm-Message-State: AOAM5306EwfMe5FfunVyFTFQHJYvkSWPrNz3hRucD5rwZp3PGaHJ6tRG
        5dIDcxbjysVXOJT+FoaOWIS27AZQC30=
X-Google-Smtp-Source: ABdhPJzhfpK3QbxW1/mF/Hqsh5JXYQcPMDRZHSVzCzGdFpXQbPRupniByhw6/ygyZ+UDwkXp9rQ2BivbqsI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a5b:147:: with SMTP id c7mr17467602ybp.500.1609374459123;
 Wed, 30 Dec 2020 16:27:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:59 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-7-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 6/9] KVM: VMX: Use the kernel's version of VMXOFF
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_cpu_vmxoff() in favor of the kernel's cpu_vmxoff().  Modify the
latter to return -EIO on fault so that KVM can invoke
kvm_spurious_fault() when appropriate.  In addition to the obvious code
reuse, dropping kvm_cpu_vmxoff() also eliminates VMX's last usage of the
__ex()/__kvm_handle_fault_on_reboot() macros, thus helping pave the way
toward dropping them entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h |  7 ++++++-
 arch/x86/kvm/vmx/vmx.c         | 15 +++------------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 2cc585467667..8757078d4442 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -41,13 +41,18 @@ static inline int cpu_has_vmx(void)
  * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
  * magically in RM, VM86, compat mode, or at CPL>0.
  */
-static inline void cpu_vmxoff(void)
+static inline int cpu_vmxoff(void)
 {
 	asm_volatile_goto("1: vmxoff\n\t"
 			  _ASM_EXTABLE(1b, %l[fault])
 			  ::: "cc", "memory" : fault);
+
+	cr4_clear_bits(X86_CR4_VMXE);
+	return 0;
+
 fault:
 	cr4_clear_bits(X86_CR4_VMXE);
+	return -EIO;
 }
 
 static inline int cpu_vmx_enabled(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 131f390ade24..1a3b508ba8c1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2321,21 +2321,12 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-
-/* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
- * tricks.
- */
-static void kvm_cpu_vmxoff(void)
-{
-	asm volatile (__ex("vmxoff"));
-
-	cr4_clear_bits(X86_CR4_VMXE);
-}
-
 static void hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
-	kvm_cpu_vmxoff();
+
+	if (cpu_vmxoff())
+		kvm_spurious_fault();
 
 	intel_pt_handle_vmx(0);
 }
-- 
2.29.2.729.g45daf8777d-goog


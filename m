Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B408321906D
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGHTZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHTZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:25:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895BC061A0B
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 12:25:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t7so37899085ybk.2
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M9lyp9aB5g7rtu5MiUgfbjfYjZdXTeZw0fg1xRRWYVs=;
        b=M8YyI1cOHmEenNKeoDViXyo+AQX0kE3jm3iwIVLWA4P4XH0qdh5ysQ43fTzbQyPFO1
         MnbGya77iRrx6CFhaFI3kZJIVnTEX7bBL294rMqemb+dfKhEnHxAR8WMFhwGJmReM7kB
         ji00aDP4DTe7S5vq/p4kxMEV2m5CnVJx5xZ/25UBgFp3w4ISZyGMhTIftqZRMS1lRnnY
         1CRtpf3JVllxgJcU1jTYPxlTTXNn/OiHaFA+KoY13oBNKKA6mx0OlLrLayW/DKVYPNf3
         wpknbzNy1pWoLwNKWIOH2IaHKLgOF3R6o5cxD6j9tfA7ZJQOnzcgQKGxfufUl0B8rGAx
         FDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M9lyp9aB5g7rtu5MiUgfbjfYjZdXTeZw0fg1xRRWYVs=;
        b=e15Wt5SKpY+uKz/oFNTz9QU8lYkZ8j5kjOkEDg2bia1M5ope6Ku4PlrS2/JFSSP1nv
         u9aniNZfwj9kmsRrNovULyLHk2vRaPTdUvXp6/ZWAvSfD2ALEyP/KUNvNquWWc59xY+g
         PzDPuPP0qh0h4KldK0pxObGBlQUr2iwrg6QwoG4jo91lm+nEuDFGcOvIs1ZyHnBdZmXf
         QvFSdtzbilhgSKcS93O/YaNZ8cvV5j+UGTMMx/PshHZVTDqDrcp3eO3hDgw/CHkNLfEz
         ELFFTwh6/SHt5i5WfAlKi7Ty5teFH86fylH6G7tIj3+HfhKPFuANFJyvs6i/sm7SMZO8
         znOQ==
X-Gm-Message-State: AOAM53379gunz2Dyae4egf2FUYiEGJv33iApca5YtseURwUUZfkaA1jj
        DxrS2avRmgsuV5BvBCUjkSJwkY8x+iize2FL
X-Google-Smtp-Source: ABdhPJyazEsJdyohKqw0P5UhxeRdYkv49fC19GKY5MKzNLPXDWzWA5Q0Qo9y8EnnTzNN13bmHta9B5nyV4WATkYT
X-Received: by 2002:a25:aaf1:: with SMTP id t104mr101753518ybi.163.1594236350296;
 Wed, 08 Jul 2020 12:25:50 -0700 (PDT)
Date:   Wed,  8 Jul 2020 12:25:46 -0700
Message-Id: <20200708192546.4068026-1-abhishekbh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v4] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
From:   Abhishek Bhardwaj <abhishekbh@google.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds a new kernel configuration that sets the l1d cache
flush setting at compile time rather than at run time.

The reasons for this change are as follows -

 - Kernel command line arguments are getting unwieldy. These parameters
 are not a scalable way to set the kernel config. They're intended as a
 super limited way for the bootloader to pass info to the kernel and
 also as a way for end users who are not compiling the kernel themselves
 to tweak the kernel behavior.

 - Also, if a user wants this setting from the start. It's a definite
 smell that it deserves to be a compile time thing rather than adding
 extra code plus whatever miniscule time at runtime to pass an
 extra argument.

 - Finally, it doesn't preclude the runtime / kernel command line way.
 Users are free to use those as well.

Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>

---

Changes in v4:
- Add motivation for the change in the commit message.

Changes in v3:
- Change depends on to only x86_64.
- Remove copy paste errors at the end of the KConfig.

Changes in v2:
- Fix typo in the help of the new KConfig.

 arch/x86/kernel/cpu/bugs.c |  8 ++++++++
 arch/x86/kvm/Kconfig       | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0b71970d2d3d2..1dcc875cf5547 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1406,7 +1406,15 @@ enum l1tf_mitigations l1tf_mitigation __ro_after_init = L1TF_MITIGATION_FLUSH;
 #if IS_ENABLED(CONFIG_KVM_INTEL)
 EXPORT_SYMBOL_GPL(l1tf_mitigation);
 #endif
+#if (CONFIG_KVM_VMENTRY_L1D_FLUSH == 1)
+enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NEVER;
+#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 2)
+enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_COND;
+#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 3)
+enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_ALWAYS;
+#else
 enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
+#endif
 EXPORT_SYMBOL_GPL(l1tf_vmx_mitigation);
 
 /*
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b277a2db62676..1f85374a0b812 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -107,4 +107,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_VMENTRY_L1D_FLUSH
+	int "L1D cache flush settings (1-3)"
+	range 1 3
+	default "2"
+	depends on KVM && X86_64
+	help
+	 This setting determines the L1D cache flush behavior before a VMENTER.
+	 This is similar to setting the option / parameter to
+	 kvm-intel.vmentry_l1d_flush.
+	 1 - Never flush.
+	 2 - Conditionally flush.
+	 3 - Always flush.
+
 endif # VIRTUALIZATION
-- 
2.27.0.383.g050319c2ae-goog


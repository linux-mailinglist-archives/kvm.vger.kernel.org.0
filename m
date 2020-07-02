Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF85212F51
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGBWMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgGBWMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:12:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A654DC08C5C1
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 15:12:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e20so31226788ybc.23
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 15:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PswgYOjFLHR50otlPxE8b2oGJ3kDUK3h2XTdWa425M0=;
        b=miWQau211dDj1fe/9wWIj67CDW+WofqWHYP6On71PKk8qGABIWIZgsg6QaVQF6200z
         2HekYUpa8CR/8ZH0IXD751av4uDRNbhIdcY+G8Phl/p+3Ou/pfeWlUvJIgpUw6vNbPJg
         LxXCichKPhMD8l+s3+ilWXjoveWcdwpx0o6QwAYWJPoH19aeUDoNCx4srH8TcWuUmzbN
         fYmAJzSvKt/ujCua/IZfLJDHYuK1Xv568YfbiYgddoviuLdQNfo+a9eRDZ0tdhsrYygC
         guLIit+pK9pvWkFfP5DnA3Lng+PSZWCC4j/lTxqrdiuUGwgxuonF2SjkKQZoO7u+xJ/j
         XPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PswgYOjFLHR50otlPxE8b2oGJ3kDUK3h2XTdWa425M0=;
        b=ctg+6dYYIJqoQc5/GYNNnxG2qWqrOxOoD2MqdCh0G0KexRsDUDXyMsGzlPIvVBXcYE
         xbKHjckFwaz33jGn49NlkMH75S8gjDVj0GMe5FsrThQ4Jh1aHFh5sa45uWp5/goLgH3V
         NZujrUVw6pV2TjCebIcGM/noJJfDzMrXoXpxsERwNJz6953ZpcgPWGWG9rsfyFBe6O/f
         +fZ1XxgsZeP9KLxMvnbIOUvtiYhu3yt4iOn5LXGBs4mlZyITkUkixTNpvwaREAv57IP/
         mFAFZroFonmE2svXI80uhGlirb/ztDWI3BPnsiYxELp/i4Wc2pQICb3zralaffnBDZdt
         4xFA==
X-Gm-Message-State: AOAM532IvKnVToOkm/FPve5BmC0ZisIjXRng7loGepFWi0rgr6N9+BU5
        cHVHbRPxHvnJT21Fbs0dyJHRsDtxK1IW6aCv
X-Google-Smtp-Source: ABdhPJxMgLnACwCz65RBY/9qPnP80m0LmIZzQopaUlX4E3h+C8yL6JDA7+Y5Ako8csmqguYSuHXJQYdGnP1puQAi
X-Received: by 2002:a25:38c5:: with SMTP id f188mr54720332yba.332.1593727962818;
 Thu, 02 Jul 2020 15:12:42 -0700 (PDT)
Date:   Thu,  2 Jul 2020 15:12:37 -0700
Message-Id: <20200702221237.2517080-1-abhishekbh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
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

Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>

---

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
2.27.0.212.ge8ba1cc988-goog


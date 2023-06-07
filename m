Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA04725131
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240052AbjFGAnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbjFGAnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:43:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8098510F8
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:43:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b03f2663caso25937485ad.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686098596; x=1688690596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9+MS+yTKdJPUgAK9JMZ2lmcpf9TYn8U5kmreyrww4/k=;
        b=GGY+hlFot4AUKOibBQ139XChSkWEIYm+AJuH7ziOV3noh8d0xYGkgJheiWHDDf0Bed
         v9HBFZtZe4i3+/JpP0y5mcmRM90VCE64QPtXY6VRx6RGq1qcOOuXjYT0jA4Kj1t2WRgP
         I7CQwNOG28qJewg2eW7reUEZeizEeQ3gnhyc6tuBtXpyohzy/ROZV+bAkWvzOSz8fuB0
         BERmi1KuOFmKn4OBfXrtV0eYz0H+yLMJRRkYwMj1LKV4YBX+UpG5Y0rs2D0CHay5djXA
         Q8CZmM+wz4focbAiFmowqNKrW6ZuzUN7GyXf21kBC31fvSbhbA7J1tzMq2oqTCcyutwo
         Xztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686098596; x=1688690596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+MS+yTKdJPUgAK9JMZ2lmcpf9TYn8U5kmreyrww4/k=;
        b=E8lq5COljjvtmfk33HRSUTBYMD/GLnPueE9twkwWamTw6QlLzQmbnnHMMcnIw5jT/Z
         s8CFJx4ANWgyLCBxlF/cyZUl9Dn3YGZd3LRMNNcyftjEC35Nf1YEbvwqXj1SuUgEAWpF
         QQvNw3hyIGjoDPjyu0KEaFZW+ung1SMBUxaPYvdZeAmI3Z30h2Rzb1ZjBiwsydFs3tWz
         q9cbtuWFLFis6Q+4dt6irt+3C/2WKxONzSWGZ4/zUP10MapfePUtxo6vJhKoMKx0uK/V
         QIich2gXfSdYZmOAX3HWaLdi6R3OZTfM3xwMqNoFhcRn9EpG/8ddESiemLCtssbk4drY
         aBRA==
X-Gm-Message-State: AC+VfDxHjV1jRFLSTb+wjMBxpEOel+NMdJ5OoaVoQxHQsbO8tSBOcAwv
        cu3GUT4QNkkOmXHNj9+S3KY6zJulNpA=
X-Google-Smtp-Source: ACHHUZ7CqvxrAff/0HHKCH+uMhqE9Ff8aPZiF/5N6ugn3nZaMd2KZSl8LkQmYc8KxfHAqBACT8z0dkPsMf8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cecf:b0:1b1:86ad:332d with SMTP id
 d15-20020a170902cecf00b001b186ad332dmr1234293plg.12.1686098596054; Tue, 06
 Jun 2023 17:43:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:43:09 -0700
In-Reply-To: <20230607004311.1420507-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607004311.1420507-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607004311.1420507-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the host's MSR_IA32_ARCH_CAPABILITIES, if it's supported, instead
of reading the MSR every time KVM wants to query the host state, e.g. when
initializing the default value during vCPU creation.  The paths that query
ARCH_CAPABILITIES aren't particularly performance sensitive, but creating
vCPUs is a frequent enough operation that burning 8 bytes is a good
trade-off.

Alternatively, KVM could add a field in kvm_caps and thus skip the
on-demand calculations entirely, but a pure snapshot isn't possible due to
the way KVM handles the l1tf_vmx_mitigation module param.  And unlike the
other "supported" fields in kvm_caps, KVM doesn't enforce the "supported"
value, i.e. KVM treats ARCH_CAPABILITIES like a CPUID leaf and lets
userspace advertise whatever it wants.  Those problems are solvable, but
it's not clear there is real benefit versus snapshotting the host value,
and grabbing the host value will allow additional cleanup of KVM's
FB_CLEAR_CTRL code.

Link: https://lore.kernel.org/all/20230524061634.54141-2-chao.gao@intel.com
Cc: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++----------------
 arch/x86/kvm/x86.c     | 13 +++++++------
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d9d155691a7..42d1148f933c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -255,14 +255,9 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 		return 0;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		u64 msr;
-
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
-			l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
-			return 0;
-		}
+	if (host_arch_capabilities & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
+		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
+		return 0;
 	}
 
 	/* If set to auto use the default l1tf mitigation method */
@@ -373,15 +368,10 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 
 static void vmx_setup_fb_clear_ctrl(void)
 {
-	u64 msr;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
+	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
 	    !boot_cpu_has_bug(X86_BUG_MDS) &&
-	    !boot_cpu_has_bug(X86_BUG_TAA)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
-			vmx_fb_clear_ctrl_available = true;
-	}
+	    !boot_cpu_has_bug(X86_BUG_TAA))
+		vmx_fb_clear_ctrl_available = true;
 }
 
 static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c7be4815eaa..7c2e796fa460 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -237,6 +237,9 @@ EXPORT_SYMBOL_GPL(enable_apicv);
 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 
+u64 __read_mostly host_arch_capabilities;
+EXPORT_SYMBOL_GPL(host_arch_capabilities);
+
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
@@ -1612,12 +1615,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
 
 static u64 kvm_get_arch_capabilities(void)
 {
-	u64 data = 0;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
-		data &= KVM_SUPPORTED_ARCH_CAP;
-	}
+	u64 data = host_arch_capabilities & KVM_SUPPORTED_ARCH_CAP;
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -9492,6 +9490,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..1e7be1f6ab29 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -323,6 +323,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 host_xss;
+extern u64 host_arch_capabilities;
 
 extern struct kvm_caps kvm_caps;
 
-- 
2.41.0.162.gfafddb0af9-goog


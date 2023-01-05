Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CB665F17C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 17:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbjAEQyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 11:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbjAEQyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 11:54:41 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1782200D
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 08:54:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4bdeb1bbeafso21931027b3.4
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 08:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RdmIXoppbPamXRLV/ZPAoxp8qfjGfL/jUk9HPqw/f3Q=;
        b=MtyeU//Qgz+a1RJ0OW2B+/zo/LxD2WG8972UzJNzDP5+3KAnMvrAOlK65YIHubqfcR
         9ocVYf7W2UobeUfTFAKnim5NJEuYIaMvC6hlk8H9GfZ+3QmYE1YYD3Rff27QzQjrMQWV
         a2tYx/GuvbRza2WnyA+6TLpUd3Y3gHTriNIUL8wWNzreSTC7efxsQp/WPyWD7x27HNpD
         cIfjwL6FuRkVnVUqK6Xn6MxFihOSwpeN65osiJBhETB3dPImgToILW7tuuKLmvT1GA6G
         O2SQoom1XKzvDko4hNBoxOZeHYPRAB0uM/PQtCas/eyZgkT0gIbKMCvxJlgtxXLQMtJN
         scNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RdmIXoppbPamXRLV/ZPAoxp8qfjGfL/jUk9HPqw/f3Q=;
        b=Py/Mhv4BSVFZ/fzyclCA0mTpWhhqroXP/g/2RLxLZRIR5nb7FXz77BR6stMm13/ayL
         95XmNvO8VG7TkC+nQaa2yYSEFq1E41ZL6ZzqxvZqSU4cczIzmGPu9dH/+TdzUQOxT8N9
         4nu8BHVtB/XtQRqui7zbM7u4jy+hzFrOjne+LT8icAVhXmf7X7KRdy0IeqJKSG9N2rOP
         I1OWoigf5Sx0SZeXXLTuWiW1DSZedy3XG59dahcSb2g9gmbvE7HCSYGIHqiACsQHESdw
         jO/EIiZ1iZD+jqRDHPtGdni5EjWyt3TDRdqVoExuD3ozNB/ND1eLch4Pa3jLE1+YXVtY
         1G/Q==
X-Gm-Message-State: AFqh2kpu92r4HicXlTclhEvJ0I2Fq8Ep7tZYzvrZA24jq1E7H46GBykW
        YETGCbTZgxASeJY5i2WVlYh7txjIkcz0wA==
X-Google-Smtp-Source: AMrXdXuqYWVLQp2RopSij9yQ5M7QhFAl1+gZZfNVA+aAHnGDf4ypcZbSVqBXHMsdi1Up14DiYSvLRe/T615J8w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:dc5:0:b0:76c:7e68:ebbf with SMTP id
 t5-20020a5b0dc5000000b0076c7e68ebbfmr3931513ybr.51.1672937680290; Thu, 05 Jan
 2023 08:54:40 -0800 (PST)
Date:   Thu,  5 Jan 2023 08:54:31 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230105165431.2770276-1-dmatlack@google.com>
Subject: [PATCH] KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop cpu_dirty_logging_count in favor of nr_memslots_dirty_logging.
Both fields count the number of memslots that have dirty-logging enabled,
with the only difference being that cpu_dirty_logging_count is only
incremented when using PML. So while nr_memslots_dirty_logging is not a
direct replacement for cpu_dirty_logging_count, it can be combined with
enable_pml to get the same information.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/vmx.c          | 8 +++++---
 arch/x86/kvm/x86.c              | 8 ++------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2f5bf581d00a..f328007ea05a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1329,7 +1329,6 @@ struct kvm_arch {
 	u32 bsp_vcpu_id;
 
 	u64 disabled_quirks;
-	int cpu_dirty_logging_count;
 
 	enum kvm_irqchip_mode irqchip_mode;
 	u8 nr_reserved_ioapic_pins;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..9c1bf4dfafcc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4606,7 +4606,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	 * it needs to be set here when dirty logging is already active, e.g.
 	 * if this vCPU was created after dirty logging was enabled.
 	 */
-	if (!vcpu->kvm->arch.cpu_dirty_logging_count)
+	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
 	if (cpu_has_vmx_xsaves()) {
@@ -7993,12 +7993,14 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	WARN_ON_ONCE(!enable_pml);
+
 	/*
-	 * Note, cpu_dirty_logging_count can be changed concurrent with this
+	 * Note, nr_memslots_dirty_logging can be changed concurrent with this
 	 * code, but in that case another update request will be made and so
 	 * the guest will never run with a stale PML value.
 	 */
-	if (vcpu->kvm->arch.cpu_dirty_logging_count)
+	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
 		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_ENABLE_PML);
 	else
 		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c936f8d28a53..ee89a85bbd4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12482,16 +12482,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
 {
-	struct kvm_arch *ka = &kvm->arch;
-
 	if (!kvm_x86_ops.cpu_dirty_log_size)
 		return;
 
-	if ((enable && ++ka->cpu_dirty_logging_count == 1) ||
-	    (!enable && --ka->cpu_dirty_logging_count == 0))
+	if ((enable && atomic_read(&kvm->nr_memslots_dirty_logging) == 1) ||
+	    (!enable && atomic_read(&kvm->nr_memslots_dirty_logging) == 0))
 		kvm_make_all_cpus_request(kvm, KVM_REQ_UPDATE_CPU_DIRTY_LOGGING);
-
-	WARN_ON_ONCE(ka->cpu_dirty_logging_count < 0);
 }
 
 static void kvm_mmu_slot_apply_flags(struct kvm *kvm,

base-commit: 91dc252b0dbb6879e4067f614df1e397fec532a1
-- 
2.39.0.314.g84b9a713c41-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36265F5FA
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 22:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbjAEVnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 16:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbjAEVnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 16:43:13 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCB063F4C
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 13:43:08 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y66-20020a25c845000000b00733b5049b6fso37968889ybf.3
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 13:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0k8Eh3FnHHiMlI7XeQYrpdIiTZhNzkhLxpPe3BO8c4A=;
        b=c9YSJY/2otkN7Utg70+ilB8KoZM0milhdm1GdIoK4GyiTm0bzWU2vcb5cLDerZrtes
         wdEidWi7edywndP5LwauyKt/knhk6NyQ3eA1chgtbL0iWe2ibt/rlPz2sSoSNyHqtDON
         XaNR6AVlL6flOqMQYMBjXjlnDd47hUTCokkK+K6TNsMEp0jNPmNDqAXwlCU9l8oygVql
         xHiDBUZ4J4Ex4I2fTBv+QszU6ZCmPkGxFMCGGcYqVjz2GHfhNWBRTwMo3C+DgbLLYxuz
         lLJM1JHfYQeoa2p6/0xdfcRAqc5NvwCu5PiRh0C5OpF4NJ94TIN2yfH+OG0Ebj8Thj09
         Ws+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0k8Eh3FnHHiMlI7XeQYrpdIiTZhNzkhLxpPe3BO8c4A=;
        b=bSv7ALS1sEsTjSdRT+qs+g/T1jHeV1JT5L8TiGNKZm93zI+COp6D8FpVqoxAOjMatm
         Q8Lz6cMLWtq0m0mLs0oPX0DA2aHSOu6oMRYCOLnnKIQqXnYK983cCb86/+TH/q35n5hQ
         Udsc/UkXYqNW3Hx3relQ6zMAKSS+MXTNM0G9gcYutwT5s2eTZE5kPVa86GfNK6YTTGac
         2RBiUQR6LyaCSq9jOnoL/phudksjeEFNgYt0Tod4wup3Vco2nnm8jMpxkqvlR84d/QO7
         8ghQNpa2a/HW2lfu3iYKO+MBPBYPRZcT4rVRXuMwl05Bhni7EcjrEaoQEl1ifJILBQR3
         d90A==
X-Gm-Message-State: AFqh2kqlAosiwg8eVDZgoXFfPJIND7tAzUmWj6JIqwUlKbFj6iDyRqO1
        L8+ZOlxJ6x7l0osi4d6AWKYo5252MJCV/Q==
X-Google-Smtp-Source: AMrXdXs3+W+vVR3jatr9B/Yvna6j2M6l7O8iIYGoAFyg01kg7sH11hDZHV5Vm13VYF9ILDSJXA1HAE7asnB4HA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:1b03:0:b0:4ba:f2ff:566c with SMTP id
 b3-20020a811b03000000b004baf2ff566cmr783615ywb.312.1672954988124; Thu, 05 Jan
 2023 13:43:08 -0800 (PST)
Date:   Thu,  5 Jan 2023 13:43:03 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230105214303.2919415-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging
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
v2:
 - Return early if !enable_pml in vmx_update_cpu_dirty_logging() [Sean]
 - Do a single atomic_read() in kvm_mmu_update_cpu_dirty_logging() [Sean]

v1: https://lore.kernel.org/kvm/20230105165431.2770276-1-dmatlack@google.com/

 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/vmx.c          | 9 ++++++---
 arch/x86/kvm/x86.c              | 8 +++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

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
index c788aa382611..bbf60bda877e 100644
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
@@ -7988,17 +7988,20 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (WARN_ON_ONCE(!enable_pml))
+		return;
+
 	if (is_guest_mode(vcpu)) {
 		vmx->nested.update_vmcs01_cpu_dirty_logging = true;
 		return;
 	}
 
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
index c936f8d28a53..2f273b20fcdf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12482,16 +12482,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
 {
-	struct kvm_arch *ka = &kvm->arch;
+	int nr_slots;
 
 	if (!kvm_x86_ops.cpu_dirty_log_size)
 		return;
 
-	if ((enable && ++ka->cpu_dirty_logging_count == 1) ||
-	    (!enable && --ka->cpu_dirty_logging_count == 0))
+	nr_slots = atomic_read(&kvm->nr_memslots_dirty_logging);
+	if ((enable && nr_slots == 1) || !nr_slots)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_UPDATE_CPU_DIRTY_LOGGING);
-
-	WARN_ON_ONCE(ka->cpu_dirty_logging_count < 0);
 }
 
 static void kvm_mmu_slot_apply_flags(struct kvm *kvm,

base-commit: 91dc252b0dbb6879e4067f614df1e397fec532a1
-- 
2.39.0.314.g84b9a713c41-goog


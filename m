Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2624A7B6D
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347992AbiBBXEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242772AbiBBXEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:04:42 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B04C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:04:42 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id a185-20020a6bcac2000000b00604c268546dso555071iog.10
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=49EqflXLEqhjGeVuRi+NUNOqk5wUT6yfoOQ51n1x3mo=;
        b=XhSn0fIbH8QaNW4Wkx15oVeWqxU2L/sTnsjfTIqM1WSpSbr08R3AR60btkAl0fzIV7
         ZkN1zatwp7wQGAdPiUbJkOwaq0SkKzIX7MjuMFKjbnHj3fUbJY7m/Y6mxUx2j+TRtL8O
         /37vD6PJxMpnwJSxz5eHgOsa9pUYuhpM6vg/Wd3pabTqR50QKBufhA1TBnb+5pAz8aCA
         EtTlJ144IEQseHBA3xGf3ML1No4szQSFKQy2vI928iX07TVVgw6xLrsgvtxsD/iTrL/S
         bU0Rg/etz0RN2piaEqpqXcROchDo3DIjkQN5ZJ8UaV9xkIdjO0amP4wBfzpSGDTo9bhf
         IcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=49EqflXLEqhjGeVuRi+NUNOqk5wUT6yfoOQ51n1x3mo=;
        b=p/hEroca+Soexj95PR8XZJ/kTyBtrni0PKLTjoGTYHu7UzY6L76068IoAFVETNpL6u
         tdprNKt4Jox7o6HdTANQ3PKt8O2Kpc2wSyCpE3aHAOF74Icx2ZnfvxxrIFz0EVSEdizu
         ZbFtzvYSvDPTVWglaGCu+bx+lmy/s6YXhd64J4HPa83KrrN6YM5Z4sfhA0JJ5OBdwm/f
         wByGfR77ry9dKOvhc27TulCkIJ8VDnGe8/pI5OjujVU/C4ElcMDZ2OQIcfyzn4uHAc+N
         9+bp8Pl8ncWh1GL7ztiZBIgNxFFrKKbhmmTYzT9ZDSG+8NUw7ju2hDEOPmIKwGdC7kwX
         s9KA==
X-Gm-Message-State: AOAM531swTqlR/382LzmpHROip8HrNZNjBiZxTY+d29k42j0G9eBv6zq
        hTmV9Qq0eaDWNRpztlmoQVc9wn/LLs7riGYAX4reTpcsBUgDeJauTEr4Ox5wKpORgIkYpUxCBUV
        mBVgJymrMvHImON4qbyFPBnaLmZCEfjjj9yt+noQi7WvoDpPe2LXSUbtR1w==
X-Google-Smtp-Source: ABdhPJxCeUDeTkE43mdUzbWq0+k5bQfc3KqabiiRxOL3ZR4beQ9KVnqw0EY2+c1h70gUbZWRZXN2t71imLY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:884b:: with SMTP id t11mr16746514ios.53.1643843081925;
 Wed, 02 Feb 2022 15:04:41 -0800 (PST)
Date:   Wed,  2 Feb 2022 23:04:33 +0000
In-Reply-To: <20220202230433.2468479-1-oupton@google.com>
Message-Id: <20220202230433.2468479-5-oupton@google.com>
Mime-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 4/4] selftests: KVM: Add test case for "{load/clear}
 IA32_BNDCFGS" invariance
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that clearing the "{load/clear IA32_BNDCFGS" bits is preserved
across KVM_SET_CPUID2.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/vmx.h        |  2 +
 .../kvm/x86_64/vmx_capability_msrs_test.c     | 37 +++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..811c66d9be74 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -80,6 +80,7 @@
 #define VM_EXIT_SAVE_IA32_EFER			0x00100000
 #define VM_EXIT_LOAD_IA32_EFER			0x00200000
 #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER	0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS			0x00800000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -90,6 +91,7 @@
 #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL	0x00002000
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER			0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS			0x00010000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c
index 8a1a545e658b..a0851b1224aa 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c
@@ -67,6 +67,42 @@ static void load_perf_global_ctrl_test(struct kvm_vm *vm)
 		    "\"load IA32_PERF_GLOBAL_CTRL\" VM-Exit bit set");
 }
 
+/*
+ * Test to assert that clearing the "load IA32_BNDCFGS" and "clear IA32_BNDCFGS"
+ * control capability bits is preserved across a KVM_SET_CPUID2.
+ */
+static void bndcfgs_ctrl_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_cpuid2 *cpuid;
+
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	if (!(entry_high & VM_ENTRY_LOAD_BNDCFGS) || !(exit_high & VM_EXIT_CLEAR_BNDCFGS)) {
+		print_skip("\"{load,clear} IA32_BNDCFGS\" controls not supported");
+		return;
+	}
+
+	entry_high &= ~VM_ENTRY_LOAD_BNDCFGS;
+	exit_high &= ~VM_EXIT_CLEAR_BNDCFGS;
+
+	set_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_low, entry_high);
+	set_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_low, exit_high);
+
+	cpuid = kvm_get_supported_cpuid();
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	TEST_ASSERT(!(entry_high & VM_ENTRY_LOAD_BNDCFGS),
+		    "\"load IA32_BNDCFGS\" VM-Entry bit set");
+	TEST_ASSERT(!(exit_high & VM_EXIT_CLEAR_BNDCFGS),
+		    "\"clear IA32_BNDCFGS\" VM-Exit bit set");
+}
+
+
 int main(void)
 {
 	struct kvm_vm *vm;
@@ -77,6 +113,7 @@ int main(void)
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 
 	load_perf_global_ctrl_test(vm);
+	bndcfgs_ctrl_test(vm);
 
 	kvm_vm_free(vm);
 }
-- 
2.35.0.rc2.247.g8bbb082509-goog


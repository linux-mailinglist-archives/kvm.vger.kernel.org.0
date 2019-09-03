Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37219A769A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfICV6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:09 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:34161 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICV6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:08 -0400
Received: by mail-pf1-f201.google.com with SMTP id i2so15079351pfe.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NRnaqKGOMM6Gjnc7Eddxq9QW9f6iAXK8LuOyj+cE24g=;
        b=CsgxhoKjBKHgFbzYo6dd9pFseWpzj5zcbk+HgNRBZbbkTXkitapVLutpUGTot5qvkX
         SWEop8n4jTkw0hHbv2FAdWL369nAGHTLDPBGuly3uUvRFPfLdunNwoJqrEf/KtJ9QPm3
         aG3W3RfZ5DlPvdldWmcXAocTQyfMZTk4cBFZpoX8Om7/S2FascWU6bPM/8FISiOfOeqW
         /b/sjYMFLaH9tteCmLY4EtCOQ3aLE/soQf+m/mFkoGy+N3kGQh4aG0+gBQH76JsGou/l
         TsyTaTkM8BsT1oSgwI4cLvqW3dQHgRWyE361b2nL9UcPe7cC6gALHATj0SOLnD1m2W/X
         TqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NRnaqKGOMM6Gjnc7Eddxq9QW9f6iAXK8LuOyj+cE24g=;
        b=TuKSKrAeUeOE2sbBf4285VCgHdTMFkoVxQUJE2zcfKu0ParkuOWKudEAeLqrv8DOlK
         BvkuziCGWHJ4357+j8RZyn2C/3HgeHiyMPERXHYqnbog6lI5jLxC4gVfzHJE+3bEI1TW
         PvqhnIRlRrZTFN1/7vXU0fVgQ//204FWg/ASgl4lStb7eP7X/ZhKKUdLKE3ffUr1BnSf
         jpyq0CG0+QnNJV2chkfc5RE4rliZfD3uB8vlM16WSGmvL/Jws0iFOSMybFIUacGs07eO
         BkgSxkFRAHP42p5SDYVKMY/Yg2O+PYgDD1glGc2CkETZ32RmjPVju8Q9TJrwIM2dzSiJ
         bffg==
X-Gm-Message-State: APjAAAXYW8If+dQkkSOMxlp1KAbEKbdxdIvJtD/2lN6iw1m2kQ9CKq1g
        oUyomRWsvmbPLC1lhd+uXsDjoMQwAW9SxpMYWNq3sYAPfJnP7Re+4KsjBUNvlt/0e2/nPoYjcm5
        1ybcwCHHcV6kjxgMpxDghXMnJyVVnJTzmB8tfHcllzzZ1ykWw/87hkdqPqg==
X-Google-Smtp-Source: APXvYqzZ3af0gEwBYRpliQddxD82oMBbJ5OKlxf/8ROle4Qg+Q6ObuxMkPfpf9gBifZnXgi+6RkL2xjXUdU=
X-Received: by 2002:a63:f048:: with SMTP id s8mr31617484pgj.26.1567547887571;
 Tue, 03 Sep 2019 14:58:07 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:54 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-2-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 1/8] KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL
 on vmexit
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
could cause this value to be overwritten. Instead, call kvm_set_msr()
which will allow atomic_switch_perf_msrs() to correctly set the values.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..b0ca34bf4d21 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
 	struct kvm_segment seg;
+	struct msr_data msr_info;
 	u32 entry_failure_code;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
@@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
-			vmcs12->host_ia32_perf_global_ctrl);
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		msr_info.host_initiated = false;
+		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
+		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
+		if (kvm_set_msr(vcpu, &msr_info))
+			pr_debug_ratelimited(
+				"%s cannot write MSR (0x%x, 0x%llx)\n",
+				__func__, msr_info.index, msr_info.data);
+	}
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
-- 
2.23.0.187.g17f5b7556c-goog


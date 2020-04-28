Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512E01BB67E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgD1GYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbgD1GXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80887C03C1A9;
        Mon, 27 Apr 2020 23:23:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d17so9841238pgo.0;
        Mon, 27 Apr 2020 23:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c4J23pfnjE51eiU8sg/gmUkqucxcbnJvyvaM93YyDy8=;
        b=sFxQQzq7Mg0a9LVrigkvsGpOutFd3UmHoo7YxqEc2e/CIwse9vEG3VCe7dlSVMd1L4
         Nx6zQZnhL6FYfDXT/LCne37szpqNofdNRrF4qmXnkj5chX5NTOffEyRfGNOOXVHXZevb
         ORWL45so9Q2uygWze4TlTfFtszIpZdZvshtJ2KfNTBif1kUgfo++tH58p4v0GANSsxzQ
         zY2CvFKWMse6vlPklFz/Im0M6bQtEih/bf/3rLadg6+MjlecQ34l4bS2EZMiBQgxgBn1
         CGgCupke1j5ye0TR7e6x+Toq+OyzFAPeSnlltPImbAPfPqNN2LqGlUnpIfdSMcOvzCuO
         R2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c4J23pfnjE51eiU8sg/gmUkqucxcbnJvyvaM93YyDy8=;
        b=VhnrXwqa+nduBNewuI71cg6Bi81E33uWdGxvgja1i8SxgFmzQu56cA5JeLO9lcW+GM
         FjJooivYrdjJIE6J495LCL4cb/mwKoCS3c5xXNwV/iprfgEphHKAL6FCkNlq+sY7z+Gt
         YqvRCX1UIeY5pfy1X4EZ7rBopty7EYMl4Virv5WzeH1ptnUrvRvdl3zpliQKYnXug+UT
         BnF9/pN60riVNoJYnOl2tv3Nj65H8mbjpfd3yIAoz2hiLvaUIgtZM2imX/S+6sw6mBqh
         Skz024W+fsFoRZMqihNrwMff/GGYU2XMPhTdoZ222qUHTvkABSaqUnXJPgm0v1f8EUgE
         kyuA==
X-Gm-Message-State: AGi0PuZuBhkKGC71fQL4y0bOphoYh+IB9JJFnIdbZmJqRpxaAtLQ5I4G
        GZ/kVqA4PlAuP0B1TyySID3KrhIl
X-Google-Smtp-Source: APiQypLQMmro+DQJ5c5SblXXuHsVr5QFrpUVoA0Jh34UQ6ckiRrL94Euwh7qSKyy+M/FsCUJccvn9g==
X-Received: by 2002:a62:4d43:: with SMTP id a64mr30288672pfb.156.1588055033511;
        Mon, 27 Apr 2020 23:23:53 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:53 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 5/7] KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
Date:   Tue, 28 Apr 2020 14:23:27 +0800
Message-Id: <1588055009-12677-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Optimizing posted-interrupt delivery especially for the timer fastpath
scenario, I observe kvm_x86_ops.deliver_posted_interrupt() has more latency
then vmx_sync_pir_to_irr() in the case of timer fastpath scenario, since
it needs to wait vmentry, after that it can handle external interrupt, ack
the notification vector, read posted-interrupt descriptor etc, it is slower
than evaluate and delivery during vmentry immediately approach. Let's skip
sending interrupt to notify target pCPU and replace by vmx_sync_pir_to_irr()
before each reenter guest.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 ++++++++----
 virt/kvm/kvm_main.c    |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 24cadf4..ce19b0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3909,7 +3909,8 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (vcpu != kvm_get_running_vcpu() &&
+	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
 
 	return 0;
@@ -6777,9 +6778,12 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 
 	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
-	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST &&
-	    kvm_vcpu_exit_request(vcpu))
-		exit_fastpath = EXIT_FASTPATH_NOP;
+	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
+		if (!kvm_vcpu_exit_request(vcpu))
+			vmx_sync_pir_to_irr(vcpu);
+		else
+			exit_fastpath = EXIT_FASTPATH_NOP;
+	}
 
 	return exit_fastpath;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33e1eee..2482f3c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4644,6 +4644,7 @@ struct kvm_vcpu *kvm_get_running_vcpu(void)
 
 	return vcpu;
 }
+EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
 
 /**
  * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
-- 
2.7.4


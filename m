Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A458953C2BB
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiFCArG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiFCApM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A44344F8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c2f3431b4so55446327b3.21
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=als6e8A1gJJA6StJM06gRZped3Uc2Gml0Vwsts95sPQ=;
        b=n0gbISWg06Ll7cuaZEHv3NE802KrXOPB9IbonBpGqY2sjwmCRrmNmEviPeI3tIg0nE
         5T0v7im6tbDuDlu3tdddA8nLiqQPjeRRiLoc4+f1pUnK0Ds+nZUsBD5fyjP8oliiJoiz
         oUavzRLEz1vDG1dkHE+KR+BG7IVxLS9yA8jczkUY+sOQhWis7G1n8oU91IkNg9Qy+vf3
         VKSojUY87vc2Okri+YEZGSQntbfpgjCOdP91Wg2cjObL1LE6SZzE0C3FybK1gkkSrOwV
         409Z3XJ55ZGq2q15OzAl3mXM2KRW51IxgUGjhi/2VgyrBMxBzI7AHWfgUJGWkTyKMIm5
         nKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=als6e8A1gJJA6StJM06gRZped3Uc2Gml0Vwsts95sPQ=;
        b=rf9EMXvBYfNRvrkgH70/w3BLKPB3Fwy3t7Z5/czP6fls4ltS/QgJwQzkGpysAbX4S2
         OwCIQOMegNRQZhUKVyKmeOpvbfPGdiZXysCKaQeJz/Ixi7k4fBpLtu56hEZQTe+lTAkr
         vzIbt30cqDMCeveTgsu4sdpiQYPdZKK/7LXhr3nNrOerezcI4D0djTLODVZi7dQXJomC
         KyL0B47VWHUb71VRuoVVFHYhRqoO2x8ivuUsGap9LiVZHSoPESxtjqWr5TFkFonVoFFg
         Dm8DlJ+6Eb4l2hJcLMdYN5JGHntZdGSdZvvl6CRoySq7WA3QZbXGanPp3SO9kRaQ3RKy
         hekg==
X-Gm-Message-State: AOAM530hvU/XlYSu+/kPJNJxjybrVcpLlvMR6UTyhQT3VIZZmD3E7uRQ
        540mrNAWq86Sxn8kElqf4RICkmHzO4A=
X-Google-Smtp-Source: ABdhPJzXS2wVpq8MBsuw34ft2UUYN2PlEvadhYWO+OTpI7RJCToBCOFWNBbWN1kgRIBQm4sWFkEqhV+rHzc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a5b:907:0:b0:65c:b38b:5378 with SMTP id
 a7-20020a5b0907000000b0065cb38b5378mr8096585ybq.331.1654217111825; Thu, 02
 Jun 2022 17:45:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:59 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-53-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 052/144] KVM: selftests: Convert xss_msr_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Convert xss_msr_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index a6abcb559e7c..a89d49ae79a6 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -12,7 +12,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define VCPU_ID	      1
 #define MSR_BITS      64
 
 #define X86_FEATURE_XSAVES	(1<<3)
@@ -23,11 +22,12 @@ int main(int argc, char *argv[])
 	bool xss_supported = false;
 	bool xss_in_msr_list;
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	uint64_t xss_val;
 	int i, r;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, 0);
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	if (kvm_get_cpuid_max_basic() >= 0xd) {
 		entry = kvm_get_supported_cpuid_index(0xd, 1);
@@ -38,11 +38,12 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	xss_val = vcpu_get_msr(vm, VCPU_ID, MSR_IA32_XSS);
+	xss_val = vcpu_get_msr(vm, vcpu->id, MSR_IA32_XSS);
 	TEST_ASSERT(xss_val == 0,
 		    "MSR_IA32_XSS should be initialized to zero\n");
 
-	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, xss_val);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_XSS, xss_val);
+
 	/*
 	 * At present, KVM only supports a guest IA32_XSS value of 0. Verify
 	 * that trying to set the guest IA32_XSS to an unsupported value fails.
@@ -51,7 +52,7 @@ int main(int argc, char *argv[])
 	 */
 	xss_in_msr_list = kvm_msr_is_in_save_restore_list(MSR_IA32_XSS);
 	for (i = 0; i < MSR_BITS; ++i) {
-		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
+		r = _vcpu_set_msr(vm, vcpu->id, MSR_IA32_XSS, 1ull << i);
 
 		/*
 		 * Setting a list of MSRs returns the entry that "faulted", or
-- 
2.36.1.255.ge46751e96f-goog


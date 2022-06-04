Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6053D472
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350138AbiFDBXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiFDBWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACC81D0F5
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s9-20020a634509000000b003fc7de146d4so4573352pga.3
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZEoywqRe2jN83WxMzYeUPBo0DWYGkrwKbHoYsiazcV8=;
        b=JskoIuph7Jqycq6MAN52MeAe6aR/QuA9Xl8V1F4UOWPpX7IsnjaYtMYkj4GRBZ6yBZ
         j9b68ad+sTaT0tI7pY6ZvLWAlkX/ljRKlPQFaTGh8o1UGf977Lo8pfijykmMct0o7ZsI
         pPofcVyuN9bvwuSdz8g1kzP6oyBJETOMnAGPmiMrDRSIrDS9DW7xIBTDUbYMtpJOJ/wK
         Dv/b1AvkhsFeBj5dskON6W+CMqhlTrL7k55VwRLvRl7/9uVLiGHqTVHcUpD44uJIETlQ
         7rRRwg7vBbTm3/SpZ5m4t3exMn34aQTU+AwffDSsvEc6X4NPW5R+ngjS/5vSwCbKpN3a
         jftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZEoywqRe2jN83WxMzYeUPBo0DWYGkrwKbHoYsiazcV8=;
        b=PKNchWEBNhf4uaTyLIU+QuvUoGWAsClaYkkZutaLOgBj4m/rQh8vnZwBE47p5j2Izq
         RzTJSxPXNMb+uaX6DUwenoEDLvuxD0Ginrjv/0oFpSosfKyE1K8SU9XL6tT2iRIgdrba
         mvPcxGvA6GRNVh2W+4IefEDVoVPJC8dxfBps20TvU52TR/1HZ/cE6zuV9sD+ztoBIlSa
         uUkPEw3wVYGjHDZFz/A5psXUMvawTFMp/8Jicw5bWy3HrILGl7XOIq1XuENUhC5Un7iU
         wHv5gmcLJXHvPkk4Mc3n7mqZLbofK6E9Y8PVINQPKWGRODz1hXKPIcHXS+QIeHRHxsUQ
         5R4A==
X-Gm-Message-State: AOAM531of2MN/TgrBw/o807oNHXhr95Dm3/N5XCi29xfzOGOLulj8k3H
        UipSla714r+Zt+qryzK3l/eKZPg/854=
X-Google-Smtp-Source: ABdhPJxBIAnhE84vnj3pmf7obhkXbiQgzGN6yzsHkN4FaCI2JiDwne0lN5S53YNIBOnUgnsYiUb33xBlzVs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d491:b0:164:d43:1a23 with SMTP id
 c17-20020a170902d49100b001640d431a23mr12888255plg.155.1654305709778; Fri, 03
 Jun 2022 18:21:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:44 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-29-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 28/42] KVM: selftests: Use vcpu_{set,clear}_cpuid_feature() in
 nVMX state test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Use vcpu_{set,clear}_cpuid_feature() to toggle nested VMX support in the
vCPU CPUID module in the nVMX state test.  Drop CPUID_VMX as there are
no longer any users.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 -
 .../kvm/x86_64/vmx_set_nested_state_test.c    | 20 ++-----------------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b9b3a19895aa..a1cac0b7d8b2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -158,7 +158,6 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_KVM_MIGRATION_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 17)
 
 /* CPUID.1.ECX */
-#define CPUID_VMX		(1ul << 5)
 #define CPUID_XSAVE		(1ul << 26)
 #define CPUID_OSXSAVE		(1ul << 27)
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 1cf78ec007f2..41ea7028a1f8 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -121,7 +121,7 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	test_nested_state(vcpu, state);
 
 	/* Enable VMX in the guest CPUID. */
-	vcpu_set_cpuid(vcpu);
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_VMX);
 
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
@@ -243,22 +243,6 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	free(state);
 }
 
-void disable_vmx(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid2 *cpuid = vcpu->cpuid;
-	int i;
-
-	for (i = 0; i < cpuid->nent; ++i)
-		if (cpuid->entries[i].function == 1 &&
-		    cpuid->entries[i].index == 0)
-			break;
-	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
-
-	cpuid->entries[i].ecx &= ~CPUID_VMX;
-	vcpu_set_cpuid(vcpu);
-	cpuid->entries[i].ecx |= CPUID_VMX;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -280,7 +264,7 @@ int main(int argc, char *argv[])
 	/*
 	 * First run tests with VMX disabled to check error handling.
 	 */
-	disable_vmx(vcpu);
+	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_VMX);
 
 	/* Passing a NULL kvm_nested_state causes a EFAULT. */
 	test_nested_state_expect_efault(vcpu, NULL);
-- 
2.36.1.255.ge46751e96f-goog


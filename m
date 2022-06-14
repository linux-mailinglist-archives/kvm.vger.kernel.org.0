Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3129E54BB5D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357504AbiFNUJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357600AbiFNUId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F474EA0A
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v191-20020a25c5c8000000b00663d6d41f5aso8239115ybe.12
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XhdgywsCTVr4zamq9DydAKZeu7w865wFF1QrREP6uEA=;
        b=XnMj9gGl/lKHOJ5mLjDMnRzDzsH54eEMvL+WKVfFoCu9AKiSMjvd/qLzQGeIWQjOmZ
         hi77l4USVL2B8BGMgKvtVSyjl/lsH0KzTmXG/WzXiV67+yYb970Mat9oqNgIsgczcmrS
         hQFfHGbc3tTEUmp/UjqmbIjfEqxXtN7noB5Q80nv1JpwGosVBph5iP0HYGO1T2oK4XL+
         C2J/kz7mXhHG7uaTiuv1vJl/q9wG32J1uY7S8LmbjVRnL//RMPovtpSK+WU9w9om+F8G
         RvrDVrDdbo0qn7lKvCQSmV2p/qCZM/YnrwcZ5mJdN8NTAou/GOoUGbtKetJ3lkr2ltV1
         NA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XhdgywsCTVr4zamq9DydAKZeu7w865wFF1QrREP6uEA=;
        b=XIDXUdrsY4gcIt3DXNlf//jZHUshfepPF+xyeMEn5/3x+zFwAjp3R+h7+iLkySWs0m
         VV66KL72fCcav/NFeqyl9K0hXn4SyLAquzKbwajlV5fudRLGkhS7zYrP96X5arbmPg5p
         lpLE8ReCZRmc5F1rv7s7LdA+2kekf0/lkvPPPYBQ+Ip8DYLwWyJD33f36m2icNPd8gs+
         AAk5DmXnLROzzZFtk2ju6YcpyJwqGesEnUhVMnxiajsPPUN+ZMhn6oyQ/CNpw1xoz811
         c79pwXqhqroSwB8LNlJXY0IGDiK3XAqY8wQyO9cWB7IS/gZ0eC5n/lmipfNBB3C5lWqN
         edWw==
X-Gm-Message-State: AJIora9veosj1X6p9p+u/LpG4ooDs3u6xoh8uTHeDfHHtdkaUmviqM4B
        FxVbGJjBQgQU+6ddeeMRs4h/oLq59Sg=
X-Google-Smtp-Source: AGRyM1vx5xJkm24U7PQboLNiezldUvmh9cSFVVSP1ea5iZIYyuZUVr/+NsX8hk36be26wtzmexXJ6A3SR7Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:7209:0:b0:663:f48e:83d6 with SMTP id
 n9-20020a257209000000b00663f48e83d6mr6716225ybc.76.1655237282704; Tue, 14 Jun
 2022 13:08:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:53 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-29-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 28/42] KVM: selftests: Use vcpu_{set,clear}_cpuid_feature()
 in nVMX state test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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
index fb8f98faa58b..0633196e7b79 100644
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
2.36.1.476.g0c4daa206d-goog


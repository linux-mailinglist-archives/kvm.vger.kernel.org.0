Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B3751B354
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354881AbiEDW4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379454AbiEDWyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8753E14
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id b198-20020a6334cf000000b003ab23ccd0cbso1338406pga.14
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5K5Fz1ePxPdVaX17bcThUb5uJeS3vgOUejHN3idcjYI=;
        b=Su+AFXd8gVSwgOvXwJ4uI0nhENW7VzSvc0XkctPnu5pI0EFXFtJOeIZkStTB2yC4Hq
         g/P14AqlA5PL1q1zHb7mqAR00HVv9us0K5/rKiegN+dwaVr43BbvGAhSoB//JEZL1c95
         DNx+YI6HJoEwfTxKvmkPLm253B++QeFX9/nKM+cdXICIbnfK3CfTSXH0R5EPs+b6yTuQ
         m2A8Gt8ROmO2FMduOilZBaagj9pUzjsaj+z9m48Nlx+zg0qR3LjaPD4GTJTzBG3pDWFz
         qdYw2jq/QZtXRJEOg2A7HaP9udIRMOWP9zrcXlZEBBx74mA2pxhQvSWBCbthAVZbkpEv
         13Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5K5Fz1ePxPdVaX17bcThUb5uJeS3vgOUejHN3idcjYI=;
        b=IXE+xrw5NdhKxrLt5fBz3NW0C9Gx74pt+qIMlnsQZ4zuCgjmsKz6ZvTY1ALzf5VNfA
         AuQj5ZwyVi0pzlwoyyDe/hOQ40ujuhZswdkP5okNarZ9b8phi1wvhi8FYQ67R+yGUSvx
         d65oThe8SAt7mOTXZej4dL+kUwugvQEV408eEP0lmmBH7oDMyva7ppYuSe2v+ndYNpv3
         /Zb6ykhNOGwlTB6I8Wd79cxJOJwTQz5Jjg4PErvrQQhDcCYhqwx7L7O/Lc7XAUyxpZ0t
         hMwLDJwocAzZG71llM93lIQbEbPHUizrvKlNNYB+EFzYKCdhjyBNifCrJkiFGqo4CCby
         fW9Q==
X-Gm-Message-State: AOAM530W7p94Qq2DvcSAvg+f+uCTkT9RpZurHdLGDcbNVGDY5oQo7bIc
        Wy+rr0UsB+vT7ofFoE3JgxDJk+bAvf4=
X-Google-Smtp-Source: ABdhPJwKxLZnwu6EdPiTHuTrtlHJYOb3zcL1SaTBUa69e0oYWwN1fY1BmhDI6P3isuiTAiVokRsUo2N/YMY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b0d:b0:1dc:672e:c913 with SMTP id
 nu13-20020a17090b1b0d00b001dc672ec913mr2232357pjb.102.1651704667489; Wed, 04
 May 2022 15:51:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:02 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-57-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 056/128] KVM: selftests: Convert hyperv_cpuid away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Convert hyperv_cpuid to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 896e1e7c1df7..d1a22ee98cf3 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -20,8 +20,6 @@
 #include "processor.h"
 #include "vmx.h"
 
-#define VCPU_ID 0
-
 static void guest_code(void)
 {
 }
@@ -115,25 +113,26 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 	}
 }
 
-void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
+void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 cpuid = {.nent = 0};
 	int ret;
 
-	if (!system)
-		ret = __vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+	if (vcpu)
+		ret = __vcpu_ioctl(vm, vcpu->id, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 	else
 		ret = __kvm_ioctl(vm_get_kvm_fd(vm), KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 
 	TEST_ASSERT(ret == -1 && errno == E2BIG,
 		    "%s KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
-		    " it should have: %d %d", system ? "KVM" : "vCPU", ret, errno);
+		    " it should have: %d %d", !vcpu ? "KVM" : "vCPU", ret, errno);
 }
 
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_cpuid2 *hv_cpuid_entries;
+	struct kvm_vcpu *vcpu;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -143,12 +142,12 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Test vCPU ioctl version */
-	test_hv_cpuid_e2big(vm, false);
+	test_hv_cpuid_e2big(vm, vcpu);
 
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, VCPU_ID);
+	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, vcpu->id);
 	test_hv_cpuid(hv_cpuid_entries, false);
 	free(hv_cpuid_entries);
 
@@ -157,8 +156,8 @@ int main(int argc, char *argv[])
 		print_skip("Enlightened VMCS is unsupported");
 		goto do_sys;
 	}
-	vcpu_enable_evmcs(vm, VCPU_ID);
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, VCPU_ID);
+	vcpu_enable_evmcs(vm, vcpu->id);
+	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, vcpu->id);
 	test_hv_cpuid(hv_cpuid_entries, true);
 	free(hv_cpuid_entries);
 
@@ -169,7 +168,7 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	test_hv_cpuid_e2big(vm, true);
+	test_hv_cpuid_e2big(vm, NULL);
 
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
 	test_hv_cpuid(hv_cpuid_entries, nested_vmx_supported());
-- 
2.36.0.464.gb9c8b46e94-goog


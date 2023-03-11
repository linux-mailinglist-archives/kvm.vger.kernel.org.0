Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C217C6B5704
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjCKAsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjCKAro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:47:44 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B4114265F
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:03 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t185-20020a635fc2000000b00502e332493fso1655057pgb.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BZgH5Eee9L8XSMp14xmQcQyAmW1Ng+mM4Frav4M8BP8=;
        b=oDfm8RGtJfI416/t8hlaquI6QMoR4wxUzcfw6CKhAB2RBWVCL1SmwemdG8vpnF0CvJ
         fTTbQ0GLnEmQu0zQit5uGQpAoptSfwIFDikvaKmcaL6Va2UHNeAaiHC0Z4BcJmZOZfTO
         jhzLwFGgVX2F+/EsIT9Eq7SRgoWWEjvqKQaBuJxOT9dygHJr2lA8S02HV4MZyCISAYCf
         ur2XGdzNAYMdzrdlbqm+iIL4ORLD3I3vgYWnRSXVlYByRIOVpHdALznIuIol5S+BOmoJ
         Xc/oZ9OVUT9VFxlbC065IBwR1FtzkcBcdr99jtBgmkEU10VeljeEb/9awajBkPtOCoIZ
         u5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZgH5Eee9L8XSMp14xmQcQyAmW1Ng+mM4Frav4M8BP8=;
        b=NH5ENEUFh8TfGb6H5E/OBkO/UUsvt9cgDmbJWfkrPavQUVPj8mXicudiKvlGR+7aKx
         vU7w4vL73W6H31BJwhIITyt0yI9pNg68q7aP7UWJ/f/IgmvLcgw17fF18WcWBLOl9i4T
         rJ/6wBijFtn6l//uIzyF65t8zKXs+1DgNm4lDOblHTv7E/d7GoELsIuDQBfvEiL/iXh6
         xj6VofvTGF76zRM/z9k8iXGQIEP+NnA8WyXuWIRdaN0TpJOkqrgGT7Wg/OExT1D3BN4J
         V05zF784D/IXqZh21n/qY3F8jLRGOAsMkwf814vNlny1mU46yl9vht3IlLoYgbfMQtfE
         9zqQ==
X-Gm-Message-State: AO0yUKWgm/a/Mg+S3nE5y2eIkkGPj2kO9VwRpJyZZXbjdGfC6zquZRhQ
        cp5+gwoO9DlR2qscVPaih0/knk+Ehmg=
X-Google-Smtp-Source: AK7set867AijtX5RzA06gfubmn9RP+tWssyGJSUx8tZ1dOGPMWCKp7lIg0JZVqgZpd5zDJQme4rN9dz4xQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:a80c:0:b0:4fc:2369:811 with SMTP id
 o12-20020a63a80c000000b004fc23690811mr8981769pgf.6.1678495606218; Fri, 10 Mar
 2023 16:46:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:10 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-14-seanjc@google.com>
Subject: [PATCH v3 13/21] KVM: selftests: Drop now-redundant checks on
 PERF_CAPABILITIES writes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that vcpu_set_msr() verifies the expected "read what was wrote"
semantics of all durable MSRs, including PERF_CAPABILITIES, drop the
now-redundant manual checks in the VMX PMU caps test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 035470b38400..f7a27b5c949b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -51,10 +51,7 @@ static void test_basic_perf_capabilities(union perf_capabilities host_cap)
 	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), 0);
-
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
 
 	kvm_vm_free(vm);
 }
@@ -67,9 +64,6 @@ static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 	/* testcase 1, set capabilities when we have PDCM bit */
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
 
-	/* check capabilities can be retrieved with KVM_GET_MSR */
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
-
 	/* check whatever we write with KVM_SET_MSR is _not_ modified */
 	vcpu_run(vcpu);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
-- 
2.40.0.rc1.284.g88254d51c5-goog


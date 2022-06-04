Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF853D462
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350034AbiFDBWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350031AbiFDBVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1612259B86
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d11-20020a170902cecb00b00163fe890197so5049621plg.1
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6XC7JtZ5cEAXk5roBNccLsZKMYfOaGpCtF/bFJA0Fvo=;
        b=C8VjAHSs/NC3zH1Ez2SVvAJLV75TFs4IgqG/Uqd2yVHN/PiTpbOsT0TwqgF3ovuEJZ
         i/X43LnEjMzlMZ4UCbl8WFzaovu48WCXOcTfgw0lvGDfPUFb/Z2MsKBQWl0ZWe2CtxuI
         Gy64CJS+I2uVzQM1u+P7Kv6uQY1/3uxKo5n72lsIdb9BUngXinakqUdkT2G2hW8F1Ubk
         8qst0I2Jj//MyaFNEpO1jFEM9eRL4NxZAbvbEFCEZJqndX45Tl7L1rNN81VIL7DhHJgC
         GhnM5r6t8qZRXPEUK8Jgt5sWVoHGDxBw/I7ON5XJnXrLRRqGGNuq39epsyjkSBrzy21Y
         W6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6XC7JtZ5cEAXk5roBNccLsZKMYfOaGpCtF/bFJA0Fvo=;
        b=pRRlicJscff3M9q+OShdFQS9I10MqADHYiIbjnk/ksKDIIAtXdHFtZC57cTCBo+Jn/
         oMDV3XIJFXUkhp7eL3W4efCiAwZmm35CmkdUKL0y7iMsHjKzV8S/dLtUsNUghVoumz9l
         PEheTw4zlpKUbPXSPSsidUaGur42MN0pybEZJ3OIb4MhurgecsdT2EtKPCOIY8IEYxMj
         n3Nbnj2PFm+qqJdzUYbPqMpWu4iqfjl5CcLvO8ceD/LJcpn3cXM2mAOEfqHSfyYYw5zx
         /QugIx09QcaXMuk1+LqerHwCcOP76mGnpLqdzDHdNL5GnqU3wRfxg+ybglSy/rmSYQNh
         09sQ==
X-Gm-Message-State: AOAM533+qnybsuDqq8IzydKb8h422pq2FoHKSnAi/5pWixI+XbW+WLq/
        XDktBHWkFXulg+qUNA7/gRYi/NvOfUo=
X-Google-Smtp-Source: ABdhPJyO/2uj1pfmTeJyJWMIF8PZP2K9Ng5q4hQn0vYEwPUxsXeARv+oplb9rNxrEkjwBbDvbxk4dxoSMi0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2287:b0:164:83cf:bb15 with SMTP id
 b7-20020a170903228700b0016483cfbb15mr12544224plh.49.1654305681851; Fri, 03
 Jun 2022 18:21:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:28 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 12/42] KVM: selftests: Use kvm_cpu_has() for XSAVE in cr4_cpuid_sync_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the CR4/CPUID sync test instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 8b0bb36205d9..092fedbe6f52 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -63,11 +63,9 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
-	struct kvm_cpuid_entry2 *entry;
 	struct ucall uc;
 
-	entry = kvm_get_supported_cpuid_entry(1);
-	TEST_REQUIRE(entry->ecx & CPUID_XSAVE);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
-- 
2.36.1.255.ge46751e96f-goog


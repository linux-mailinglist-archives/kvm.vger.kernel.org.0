Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E603D5F5E0B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJFAvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiJFAvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:43 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376F141987
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:35 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so268405pfm.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RgqORs+iZiHuiK4jt5s3dsauOVZm6CsCgSWJtdsZN8o=;
        b=FxoDzY8XpT60khM5OBGeJ/D5kPXbNfUM4qcx/QTvfmOQXe/vch3V0rTv2Iw9WB8Wxy
         QB45BylluYWq5qpsrVeK2N1XB4KEZYPGISN1pbovBZn4zDjJuSbWdr8qdNF9tTWqni2B
         sbCamdHMqgan5+c7T+Dvq/fmqEzqquDmmyC3MRwVHpmKX/zyib7eQslFP1yMyYV3hwN+
         lwI2xjgDZto+Z/MjkiYyr3JukcLqef/To/eLc+uP7/O1URB+RZEemhoNpVUBAE5R5RM0
         UlJlUCptd4G0OOqKPpCv3MKbwP3tUbS0vhlYJa+P0LvSfXsxyChKzLc06ggE5IqdSyfZ
         /HfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RgqORs+iZiHuiK4jt5s3dsauOVZm6CsCgSWJtdsZN8o=;
        b=PlYVGHQ0VELaxBDvD4+6RcacDucbPBy1vigztlNsQuFrQEyr+DBXNxVvRxSLuaHLwe
         AE9WRzqpkXYmvk9hyr3cxnvie0IoH7FnMbDnnqHbA+IBuvulhKvIEFjQtQKdOQ1uYFY8
         7KipfFFU1qz9rfQEXStABQbDEh1vvYbxA8OBRaDT1mEnm/5Rm5LNVZuzXqDkI3cRsJlC
         ejrIqgLSO2sam1fcir7oeZc2fqOWnC3Rk+tnMvdDUB8YwgDH8OfJ/jSABr5R72uVBppS
         LJcq0JzK1VcTk14m+IIERjmv1bruuEVRNoQTYrJsqaqq/W4rVYFeqqs8uXZKTW3Vbci3
         AWSA==
X-Gm-Message-State: ACrzQf0SL7bUqeXeqJVFS7KBB1WdqZixJrYnn2DD1be3ZutNVpqEQFmV
        5f2cSuyDgh5yunOs40JMSX9PXVZSO2s=
X-Google-Smtp-Source: AMsMyM5Y8ZUJYm2GCo4nEB94UeSd03qSWycjsUKsOL3g8CtGhjzUgZWDKUOskY9v66RS2DxVT+kC0rIDAoQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:aa96:b0:205:bb67:a85f with SMTP id
 l22-20020a17090aaa9600b00205bb67a85fmr2370445pjq.202.1665017494809; Wed, 05
 Oct 2022 17:51:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:17 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-5-seanjc@google.com>
Subject: [PATCH 04/12] KVM: selftests: Use X86_PROPERTY_MAX_KVM_LEAF in CPUID test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Use X86_PROPERTY_MAX_KVM_LEAF to replace the equivalent open coded check
on KVM's maximum paravirt CPUID leaf.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index a6aeee2e62e4..2fc3ad9c887e 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -43,15 +43,6 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 
 }
 
-static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
-{
-	u32 eax, ebx, ecx, edx;
-
-	cpuid(0x40000000, &eax, &ebx, &ecx, &edx);
-
-	GUEST_ASSERT(eax == 0x40000001);
-}
-
 static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 {
 	GUEST_SYNC(1);
@@ -60,7 +51,7 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 
 	GUEST_SYNC(2);
 
-	test_cpuid_40000000(guest_cpuid);
+	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF) == 0x40000001);
 
 	GUEST_DONE();
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog


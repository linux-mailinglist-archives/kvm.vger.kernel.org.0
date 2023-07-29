Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FE07679DC
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjG2AkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbjG2AjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:39:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763155BF
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-584375eacacso26809217b3.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591056; x=1691195856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A8aQo92BGEsQWkSMM0MIWBDLRqK5BVyNdFuue+2u5/k=;
        b=rHAAon41DFnQeXUebX2OJqNtyuIqCjw/zv/LEFTrP6sKfuqbWQWy9vTAeDC9baKzkM
         InL2pbSWIvgmJo1PFc5PkZ9IssaPyWA6beQKHDlATRaITOhgmWiIi4Yc6QNojT4gim2g
         VHEcBgumeC+dZAbxD6aD3GbVFZzVhTveam9/0HVj8PAwwacp6sj79h3MRWTWHVGts8EH
         qeFgp3tJXVbDG7wMwDPRbM2LiNJJ9L5W/iXasZCfE08XzD2USXpqlYmrhqXhXY8U8Dxh
         QtEieDJoOJzHX5jn1vKb8EIGVG6faLPinZHl9nkvORH8R4TaxZmBVa2qWsf+mhcEmiq1
         bkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591056; x=1691195856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8aQo92BGEsQWkSMM0MIWBDLRqK5BVyNdFuue+2u5/k=;
        b=YIaW7j874xj+JUpOMz/c2qW2G6uQgtDMyPVjZ82AkhwukLvmZGCetzsPKVbK14PDes
         iIlZwWdJdr7joSNU8wAM+X7wqAmHB4MKIOc2RwhfACbPMkxTBrQSZ3Ncs73qugEPAqIM
         0aLxryf9zZFJh+0YNfo2Dm8eYGFN1+vxW9EEhrLmsirShyLoAs4ibfHKB9HbGSrnWAbs
         Ab38rvGnjMjOKEZyB+mFkxLeVENLGy/evZ/yUtdYtCjL3p32AEG2CeaI2+9sn6RYcAUs
         gEDLrfYtiR0G5/9UtbJvS65/PW+2ud5/BTh1VyzQnW5SPP52o7qW4Kd3nE0jWy0W+RJ/
         B9MQ==
X-Gm-Message-State: ABy/qLa7pZIZh4pOQB61LORrVzWDQ52rZoy6OxOcf2OINlTGnm37MLBy
        nt/yJsQOfdHDyIxfHdCslCLflpJnvug=
X-Google-Smtp-Source: APBJJlEJnPZI81sdISJjMNXK9i+0b+uyCp/hlcuf7GAPKJmfjcAxHXQ0DG6ODxl42Zjvl3eTSQ7DFBljZzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:29c2:0:b0:d16:89fe:52cd with SMTP id
 p185-20020a2529c2000000b00d1689fe52cdmr17553ybp.11.1690591056277; Fri, 28 Jul
 2023 17:37:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:35 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-27-seanjc@google.com>
Subject: [PATCH v4 26/34] KVM: selftests: Convert x86's set BSP ID test to
 printf style guest asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
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

Convert the set_boot_cpu_id test to use printf-based guest asserts,
specifically the EQ and NE variants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index b25d7556b638..abb3f26d3ce0 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE /* for program_invocation_name */
 #include <fcntl.h>
 #include <stdio.h>
@@ -20,7 +22,7 @@ static void guest_bsp_vcpu(void *arg)
 {
 	GUEST_SYNC(1);
 
-	GUEST_ASSERT(get_bsp_flag() != 0);
+	GUEST_ASSERT_NE(get_bsp_flag(), 0);
 
 	GUEST_DONE();
 }
@@ -29,7 +31,7 @@ static void guest_not_bsp_vcpu(void *arg)
 {
 	GUEST_SYNC(1);
 
-	GUEST_ASSERT(get_bsp_flag() == 0);
+	GUEST_ASSERT_EQ(get_bsp_flag(), 0);
 
 	GUEST_DONE();
 }
@@ -65,7 +67,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 					stage);
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+			REPORT_GUEST_ASSERT(uc);
 		default:
 			TEST_ASSERT(false, "Unexpected exit: %s",
 				    exit_reason_str(vcpu->run->exit_reason));
-- 
2.41.0.487.g6d72f3e995-goog


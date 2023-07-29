Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B447679D1
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbjG2Ajb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbjG2Ail (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012DF49E3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbb97d27d6so18295185ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591046; x=1691195846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BLQZx+pdtuh57o1wL4zXWuuQZRskZOiKVGsasrVHJ/k=;
        b=nnPTjTg5f/WzRDY0G2F5g9I/MpwEw80DlkwGP2Q2BChxakWYZQ2XnR8JayKvBVdnKQ
         CKM3viDb8jPmE5GbrYha5aGJnTTlWFTmcIwmJivT3eDJTxFD2URsQENK6Eh81rE2xWMX
         RZ6ITjibLuUEHo6PcwrfwHDxR4zT0ua5AfnmwXcHoZWyfmSg6BKa2ZB33/ML8XAQvrii
         QVgpwwc2XmC0hCNaWSi8QIWcL1JJXowfEhL7mHg+gIk9DRqso5bgtfBwOHN/w13q7zh2
         P+wiqOsuQFN2OQWzT2ZZ47jXKsfPKtt9IpQyAyPKY3qGjr0jtZBF7Ch+Qk2dIeOH50IR
         vSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591046; x=1691195846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLQZx+pdtuh57o1wL4zXWuuQZRskZOiKVGsasrVHJ/k=;
        b=M6szxeY/up+cUq0nW2y5YjwMIV4jIeJUr/6lH2QzAamBy0U7Km2OKxA6gqnh/COLhQ
         FRrRgBeBL7waK1oFcUx3v5Fd5hkL4rTTLUONkTod+XJqHnQs7ThWPbzKCGeo4lHN7r7r
         CnsHELFgDflJsLBh11IscrqEhIPN/6AzvX0gcrjJzeaqUO6EpMfl9hTxIJ+vxGvamTWE
         goPTDXYQovc8Ln8gr+R4xNrNCHxknMPBVbxD5n35Zmw/PAIs08oP0GOBdWF5I6udMxvz
         wI/mfV+PsKIvALpIcoRNMDp21yBI184caEv7MLEQZk8wigVYOeXwoLJD1isDQiOkYDRl
         x7hQ==
X-Gm-Message-State: ABy/qLbUMb/tjzrkUg3Oc8VuMDTY985tjfhDLAA34U6rG+YgaovDkyP6
        vPQymP+k+pOAKLsZ109FhxQ70KcaoqU=
X-Google-Smtp-Source: APBJJlFlrrUE1tksLhPAq+kwjI0L4IaBgwLyAp0oEOf6o8ykeMtkOh9QkcD45fcBdHtiq3t7HikG7TyuqI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with SMTP id
 j3-20020a170902da8300b001b3c62d71b5mr12053plx.0.1690591046611; Fri, 28 Jul
 2023 17:37:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:30 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-22-seanjc@google.com>
Subject: [PATCH v4 21/34] KVM: selftests: Convert the Hyper-V extended
 hypercalls test to printf asserts
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

Convert x86's Hyper-V extended hypercalls test to use printf-based
GUEST_ASSERT_EQ().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c  | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index 73af44d2167f..0107d54a1a08 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -8,6 +8,7 @@
  * Copyright 2022 Google LLC
  * Author: Vipin Sharma <vipinsh@google.com>
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include "kvm_util.h"
 #include "processor.h"
@@ -84,7 +85,7 @@ int main(void)
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.41.0.487.g6d72f3e995-goog


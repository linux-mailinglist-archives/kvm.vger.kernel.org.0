Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A747277B7C8
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjHNLv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjHNLv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9665EA;
        Mon, 14 Aug 2023 04:51:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-686f19b6dd2so2780199b3a.2;
        Mon, 14 Aug 2023 04:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013886; x=1692618686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOG0YVT8JSBLBHyuyCJeatj3Kijd1In1QFgkizkkf5E=;
        b=qrFxZriGk1WLMSup7efZpsBcf8HRwcBOkpx9Jk7rxrGp7mVaDM4VyoZmMh8Wf5/Qur
         uVumNbksGvajhgCTjBrHcROqjb8dgRmP9uRuwL/w+pfCtdnGI7NW/PBs2Jt8AzVBiOCe
         Uh2G6qWJWlz7kuQTv+NIMAdHN3oQmD63Q8zc43d1Kpy1mQpboHwCWcjVoee/AqZPDgop
         2DKwG7weJhRZ/Zku/oDiV+HeeOfMZ4lhGJ3CWZTE3wm6g+wOu/RUyX2jXsMLXdwvaLTd
         vYZaMD/NBaFkeAZ3D8MJesuJULauujpDgHLMFh+nZ6MvlWxZnjwFCeZk93PtiqXWFY92
         RZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013886; x=1692618686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOG0YVT8JSBLBHyuyCJeatj3Kijd1In1QFgkizkkf5E=;
        b=YPgLFhLHkIh38unU5F9xkD/PzYfGT6XQ9aXf1yTZz/uQoZWKWL1yBTtKII9ZFzV8q9
         sDvdSiiiirjBv321z7CuiII24x2beL5kXNAjSTD+oq5QjckSzk92oVK02Yni1RGVVJUP
         Yp1zwPJO/EvxIcwa8UydMCOTNVy5TYpxmCocqivRNlhBW6IFkahMooEBZbrpsZ8Y/ZBp
         iwRgPRSDTPkAA7LtGFZ22FMXlAQGinOSLb/oUwEFCLSI9EG4dU4YZgkL9OQGn6UL+hEQ
         tBpIkWrO1qv4RVMCQYlSmc2rXADUt2DMXL6MpUOiDFlo2UdvBEBUV5teV4rdm+YUg7x+
         E17w==
X-Gm-Message-State: AOJu0YzHBiLdmQFjPuJbacL8lKg6wHLiOvE0bl49/2HuwNj7HU1sJBO5
        4ifEKpW2rd6TY280fMOfD6M=
X-Google-Smtp-Source: AGHT+IHzoO8azA1GjT65Ok+0vzYcVDaLyni7kd1AOoKhr5junlW9Bay1mVn+CBaJnH+vFqO1IfwVmA==
X-Received: by 2002:a05:6a00:1402:b0:687:5fdb:59ee with SMTP id l2-20020a056a00140200b006875fdb59eemr8547600pfu.12.1692013886089;
        Mon, 14 Aug 2023 04:51:26 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:25 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/11] KVM: selftests: Add vcpu_set_cpuid_property() to set properties
Date:   Mon, 14 Aug 2023 19:50:58 +0800
Message-Id: <20230814115108.45741-2-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Add vcpu_set_cpuid_property() helper function for setting properties,
which simplifies the process of setting CPUID properties for vCPUs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/include/x86_64/processor.h       |  4 ++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd042112526..6b146e1c6736 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -973,6 +973,10 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 
 void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
 
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value);
+
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..0e029be66783 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -760,6 +760,20 @@ void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
 	vcpu_set_cpuid(vcpu);
 }
 
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = __vcpu_get_cpuid_entry(vcpu, property.function, property.index);
+
+	(&entry->eax)[property.reg] &= ~GENMASK(property.hi_bit, property.lo_bit);
+	(&entry->eax)[property.reg] |= value << (property.lo_bit);
+
+	vcpu_set_cpuid(vcpu);
+}
+
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function)
 {
 	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, function);
-- 
2.39.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8710E79B056
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbjIKUtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbjIKLog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:36 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD2CDD;
        Mon, 11 Sep 2023 04:44:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 98e67ed59e1d1-27178b6417fso3386357a91.0;
        Mon, 11 Sep 2023 04:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432671; x=1695037471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOG0YVT8JSBLBHyuyCJeatj3Kijd1In1QFgkizkkf5E=;
        b=H+XmV1ILZjVnR8o+Db8CdJWvn4NFSiwIYTcuqjLIBWCH8COsVNOXrYaaNttVq7zoIQ
         Ul+h786mc/cY/WMZ2CPl3xzF5V10Z9vEeoebz2N2XaW+dneYR6lCuv9UO/Mdro0YXTei
         O8PRQXP5lH25DpykJwziGLlwIWMmfvPhnUjyX4xpd84sAMZaa2QWKN4v2gvrHtCjo8P8
         xn8iBczAMv4R3oEgAzPSWbAjgeAWRTbmJuwlzoMl3XVQHeXx5wJkBOqfPFLhIsy4J4cD
         a09jOz0WJCnk45THBFgwyJc5XWbdXdbVMr/6mQle3xi7ujcrAVpzBs5TFvn0/HjhsJS9
         drQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432671; x=1695037471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOG0YVT8JSBLBHyuyCJeatj3Kijd1In1QFgkizkkf5E=;
        b=ri3OTVG0iAY53OVlMwVJyekeTlBQCwvepdVDjG12V0VgQo77F6tUX+CWOXF9Uj7fs4
         j+uP9MD8uAv2CSdfALfrGAFRXx/QxyhcpN2mfMZfbyqQGA1jQwUn6R8wGeA4Ns8Kf1It
         nxfV6OBvL8vEK/PMSQ3b/xv/WLHK64GIZygApEtctEYToZXGzcIj/TF4SUhJV07PvnBh
         wBnS9wjP+9THr4/yTJrmV09VdyTrKb70KK00XPuZ2mmSCiLMmPiXmf63wTOkmoYDokKq
         MzXHHOJfp+mZjfWAFeorayPoNbT2yGf3f9XCMFkS0stPa/5dwj+5ciH2+H4Y+nXoqqgD
         5SAQ==
X-Gm-Message-State: AOJu0YxWsHLgBDctB9X4QxI/PD+xVhYLa9U9o8WdxuZd6DvBmdp6RPmf
        XTcw8HHc/ShrrsTHB/O/JabHCQO8HVhAU/eb
X-Google-Smtp-Source: AGHT+IHkITCoKd5KYVe+5tPItvaNBVdFo22zUhM5u9LVdtErnZWIgqomo4h/YlTF7eaqLvtWMG5GRA==
X-Received: by 2002:a17:90b:14e:b0:270:1586:b014 with SMTP id em14-20020a17090b014e00b002701586b014mr9579883pjb.28.1694432671389;
        Mon, 11 Sep 2023 04:44:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:31 -0700 (PDT)
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
Subject: [PATCH v4 1/9] KVM: selftests: Add vcpu_set_cpuid_property() to set properties
Date:   Mon, 11 Sep 2023 19:43:39 +0800
Message-Id: <20230911114347.85882-2-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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


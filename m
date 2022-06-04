Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF80653D46D
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347726AbiFDBXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350021AbiFDBWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:30 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD2D1025
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 18-20020a621512000000b0051b90b3a793so4715559pfv.8
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J6Ssq79acMaaHSiEP1fKlZ6/Du4B3+2P34aFf+DVOyk=;
        b=eup/4YoWpFBQgsbyvL1RBm8gYMRPBqN+mF0/+t4VR2laZgangtnClvcdqtTRowypVr
         5c3cbSP2WyGJywo2s+yVZuxL3L91zt5jXe+LXYYy2Yowe0ecDXX8BywnX7AVtRbscRyG
         n4hqpT3RHXllPMeQA00uprQ6g6Hrc95RgIqnLsAGEVMBBG06DRH0xApUNuhiK5sLB/Mi
         PylsbDEA9MvzZXrb1yud6cW9BoRILBQLWD28SDXb1aOEo5ibwTexiY/zpkkt9xE/vKj/
         F5JSg859sheEtk1OwrJiFn1FwXqgd20bkMCB9kKLqQ+12lJid+ts0lx94jRTV6i/BC4D
         a4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J6Ssq79acMaaHSiEP1fKlZ6/Du4B3+2P34aFf+DVOyk=;
        b=FEYTT0xHDw3m8xwMNI2HjX2NGbKShM6LNnW64qhzo6qGT4radjdk6RH5Y/9XiD79Xp
         s+I57C/A4yz8OZPK/6aj8aQxprfoL/A0STaiE7UqTUHh3FQx/pyuiEi87GjDPW/Nz4KX
         01fM7lUO52VVGe3DydopY6rsOolLVirGUqhxbcjeg9g+O9pVxbP6yPLgog/dPeEEAZ81
         sKkdHvcYQJZLn7ehUXVIr3pYEXPVWM582J/IwJEpnpAB0Ph4QmHE7xUPeRKkKsjaqdKt
         m1DewcL94Raqx/9FD0CKIV66xJP8zZlkszYZOjQRH06MeD8QqTSEEvZzYfR/lAw6MEQy
         /6Qg==
X-Gm-Message-State: AOAM530MfL5Sv2vCVoIwVNu5axMg7yN2tKbIWSF7OwfbJY47URb8Qry1
        0BrCzG5wpIfs1Wg1TJIupFJe7Ronafk=
X-Google-Smtp-Source: ABdhPJzzsQjp/JmEChEQM0LBdDCcCp5vkf2dT8tnLgc2Dk3PG4pSi3SprpNSLj/fr4U88iACAb5HqK4LwQQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:319b:b0:51b:c5ec:62ba with SMTP id
 bj27-20020a056a00319b00b0051bc5ec62bamr11398270pfb.1.1654305698761; Fri, 03
 Jun 2022 18:21:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:38 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 22/42] KVM: selftests: Add helpers to get and modify a vCPU's
 CPUID entries
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

Add helpers to get a specific CPUID entry for a given vCPU, and to toggle
a specific CPUID-based feature for a vCPU.  The helpers will reduce the
amount of boilerplate code needed to tweak a vCPU's CPUID model, improve
code clarity, and most importantly move tests away from modifying the
static "cpuid" returned by kvm_get_supported_cpuid().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 30 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 18 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e43a1d2fd112..61b8047243e0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -620,6 +620,19 @@ struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
 					 uint32_t function, uint32_t index);
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid);
 
+static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
+							      uint32_t function,
+							      uint32_t index)
+{
+	return get_cpuid_entry(vcpu->cpuid, function, index);
+}
+
+static inline struct kvm_cpuid_entry2 *vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
+							    uint32_t function)
+{
+	return __vcpu_get_cpuid_entry(vcpu, function, 0);
+}
+
 static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -643,6 +656,23 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
+void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
+				     struct kvm_x86_cpu_feature feature,
+				     bool set);
+
+static inline void vcpu_set_cpuid_feature(struct kvm_vcpu *vcpu,
+					  struct kvm_x86_cpu_feature feature)
+{
+	vcpu_set_or_clear_cpuid_feature(vcpu, feature, true);
+
+}
+
+static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
+					    struct kvm_x86_cpu_feature feature)
+{
+	vcpu_set_or_clear_cpuid_feature(vcpu, feature, false);
+}
+
 static inline struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_index(uint32_t function,
 								     uint32_t index)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a835a63a6924..6c21893f5038 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -767,6 +767,24 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
+void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
+				     struct kvm_x86_cpu_feature feature,
+				     bool set)
+{
+	struct kvm_cpuid_entry2 *entry;
+	u32 *reg;
+
+	entry = __vcpu_get_cpuid_entry(vcpu, feature.function, feature.index);
+	reg = (&entry->eax) + feature.reg;
+
+	if (set)
+		*reg |= BIT(feature.bit);
+	else
+		*reg &= ~BIT(feature.bit);
+
+	vcpu_set_cpuid(vcpu);
+}
+
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
 {
 	struct {
-- 
2.36.1.255.ge46751e96f-goog


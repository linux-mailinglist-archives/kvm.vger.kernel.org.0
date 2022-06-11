Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B9E5470C0
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbiFKA6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347923AbiFKA6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E42D69CF1
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:09 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v202-20020a6361d3000000b0040506cf75d7so287896pgb.15
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oY9FxBNio0SCgLpK/jFKCD4Y7vKbbNfnGMEENFi2tNY=;
        b=rJlcqaygL9Pl8IWHX72a8GtxGllcsh7+hT6QUAaBK7gxlqJOxQSHJJBXNBpTMIwSZb
         sZD+8DU1ua+ccbHpWn/xOHXidemVVburKSy/zUsvFq+H907wCu1wnZBmCHu9t8vogofQ
         SybvseBX2yi+hv9YRIHFMV8olFdOEmPh1e6C+4JaFAu4Vwwf1NMda7a7LXUlns4VrR9Y
         4lFE6tnbsIAI6+MgmqpdDCR5cGrVmJ+NNRENgt2jGQT/iRlNT3fFz8+rlYjJkdCApKCM
         QrpgKqA4rAnNcJf4KdToc5b4jsg6bX1kbqDn+WMe0+rxwP+1dRKdtNy9+ByvivH4gicH
         kiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oY9FxBNio0SCgLpK/jFKCD4Y7vKbbNfnGMEENFi2tNY=;
        b=VhqW9GGMGXG8S4/CXZIqelJuMQTNGCR5TWIANo3nP6UTlJ57dBqV9ZdpwZ7N8ltumY
         sUX2jLyD/lwrFFfuCbFj4RKmqAlos8BVbF8AhGvUMWy8C5td1cNBsHQmGwgtHiyx17kw
         mtggiSG80jbRr6wY0ql4dF6szXNnJdBiXYzNrbIJrNCJFVcA56ExCioZgodRsK85ITlY
         cPfooyWrpzvY2wFxoBNkcdzAw9oWfPBMiHp1K/yRM7Afjj89nqamimjWiLO2jzQa6wQh
         e7L0A7L1XalXItCHYluZZcev5qW/Cf53pZg0/JL+Y1M0d8ZX7QMsgyjCnbKIoUmC6BsJ
         qjkg==
X-Gm-Message-State: AOAM530mRzcQzhwYNhgichLoKLwO55I1rhtPFBE4Gw8g0xlwqGO43J9L
        pHPGgPrx7M0jQJTZinW49lqHZc/Gf4Y=
X-Google-Smtp-Source: ABdhPJwJ2J+Ef2pCi/IhSWV9HgKvMUa2SkTCU/3o5PPE6e/sBKhPhXF6Jg7Q0uJ5k3glRZJFOCqvmjVu/9Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1741:b0:51b:ca1a:8563 with SMTP id
 j1-20020a056a00174100b0051bca1a8563mr46208276pfc.58.1654909088824; Fri, 10
 Jun 2022 17:58:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:54 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 6/7] KVM: x86: Ignore benign host accesses to "unsupported"
 PEBS and BTS MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

Ignore host userspace reads and writes of '0' to PEBS and BTS MSRs that
KVM reports in the MSR-to-save list, but the MSRs are ultimately
unsupported.  All MSRs in said list must be writable by userspace, e.g.
if userspace sends the list back at KVM without filtering out the MSRs it
doesn't need.

8183a538cd95 ("KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS")
902caeb6841a ("KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS")
c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25f471adb8b8..655fb0b3bba4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3786,6 +3786,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
+	case MSR_IA32_PEBS_ENABLE:
+	case MSR_IA32_DS_AREA:
+	case MSR_PEBS_DATA_CFG:
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
+			return kvm_pmu_set_msr(vcpu, msr_info);
+		/*
+		 * Userspace is allowed to write '0' to MSRs that KVM reports
+		 * as to-be-saved, even if an MSRs isn't fully supported.
+		 */
+		return !msr_info->host_initiated || data;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4122,6 +4132,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_IA32_PEBS_ENABLE:
+	case MSR_IA32_DS_AREA:
+	case MSR_PEBS_DATA_CFG:
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+			return kvm_pmu_get_msr(vcpu, msr_info);
+		/*
+		 * Userspace is allowed to read MSRs that KVM reports as
+		 * to-be-saved, even if an MSR isn't fully supported.
+		 */
+		return !msr_info->host_initiated;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
-- 
2.36.1.476.g0c4daa206d-goog


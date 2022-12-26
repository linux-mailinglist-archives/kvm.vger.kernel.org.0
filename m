Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C68F656222
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 12:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiLZLRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 06:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiLZLRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 06:17:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6AA1147;
        Mon, 26 Dec 2022 03:17:35 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso14515050pjp.4;
        Mon, 26 Dec 2022 03:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcuQAG+JKdD/aO7T8iny1vSHAfiWv95oSPUA+CCs7Jg=;
        b=kZKFlcnM+CEZTwXAWeJF6kp7BKU9XfNN9o+TqH7pT0LpGwRYypYXPymMkiOe/jxmsI
         L2FNpT+UXjisuR7Ovmy+g6Z1WwJPxgI3JCgLmyKoiJnwojuZX27M/Rrw+fWNjcBCsqAd
         t0Hd4OcEOlCqlCa8erJVmNuh3ciLQ0R8k7fBn6K6Eef2K1tQgE/J3kN5Mh3vOrjCFcyF
         nB2GzZ1urp9NTqPCJNSqMa/c4O7bkgaeX71t+4kwwmpXXAiqGmqbDi0OGvOAmVgxxrHR
         BkT76JsTsv1xIZ1+BzmPAH6QvwI2XcRllFDJpFS3BKwLtW22axp++Iyu3Z+N2hxB7tqb
         /Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zcuQAG+JKdD/aO7T8iny1vSHAfiWv95oSPUA+CCs7Jg=;
        b=qz+YOKBTOUBNf36aUUb/f0MR9iKcASxtPC/n6iyqmOZF46ggfRsl0lQbTt7oKj+lkY
         FlXqpZlIvbY/bYjKpwpylDHPiHj9xoQxrKNiNrvwTrOQK/y/8J8vcpge8tPKfw2aClNB
         5DmBek+E/V+JH7JbsbWyhuUZ9HcVtRtfhRlQcUZJ/W2uYEL0+0f+V4ifSc9S4/LauyCx
         SV1FIzBJccsRWOi3TC6C8XH5dOvQnb/dlK1NXlOX8BWmnkChdsp147U/XRJLFRmjEX0R
         PTOo0P8RgGIeSAqwcPUWlz5oP2CrQ1UY0U6GyVtJrzp/HtIiB8U9aDjXLjvKAIUUofwL
         Seyw==
X-Gm-Message-State: AFqh2kpPNzuSBOzTS6SOP3gBM7fYtuUMbUbjKqMOPZMXWxAb8oSr+7NS
        a4OfcVS7irWOt9YP5uJ9qzw=
X-Google-Smtp-Source: AMrXdXtlievYYm09jk7x9s0JJBtk6g7GkW2EM4Zw0P7XGaHY4eR7bunwu+h/XQD1Mc/f16oQ8iwC+A==
X-Received: by 2002:a17:90a:e648:b0:223:3642:f74d with SMTP id ep8-20020a17090ae64800b002233642f74dmr33845126pjb.37.1672053455369;
        Mon, 26 Dec 2022 03:17:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id dw6-20020a17090b094600b00223f495dc28sm6281490pjb.14.2022.12.26.03.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 03:17:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Ignore host accesses to higher version PMU features MSRs
Date:   Mon, 26 Dec 2022 19:17:09 +0800
Message-Id: <20221226111710.51831-3-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221226111710.51831-1-likexu@tencent.com>
References: <20221226111710.51831-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

Higher version PMU features are obviously not supported on hosts with
lower version Arch pmu, such as trying to access FIXED_CTR registers
and PERF_GLOBAL registers from pmu.version >1 on a host with version 1.

Ignore host userspace reads and writes of '0' to those PMU MSRs that
KVM reports in the MSR-to-save list, but the MSRs are ultimately
unsupported. All MSRs in said list must be writable by userspace, e.g.
if userspace sends the list back at KVM without filtering out the MSRs
it doesn't need.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f570367463c8..fcb9c317df59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3881,6 +3881,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+	case MSR_CORE_PERF_FIXED_CTR_CTRL:
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		/*
@@ -3984,6 +3989,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+	case MSR_CORE_PERF_FIXED_CTR_CTRL:
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		/*
-- 
2.39.0


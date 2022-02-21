Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE464BE936
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356968AbiBULx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356967AbiBULxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D1620197;
        Mon, 21 Feb 2022 03:52:40 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so4807230pjj.3;
        Mon, 21 Feb 2022 03:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mhtKDiOsLT1DFVkDtSR/HqZI5hm/yp+9fh0AF9ZzPSE=;
        b=HzvfHmXZ10Z3fPpJMxzWMvs/cq9Ow90nVAhjDzhlQFBpuENLsPNcjq7kGEw3uJPFNM
         6RJ1hJCBw0EiCAwEfZh5ok8pAh84dRvDh95OKDfBUOWEGoHErxWWwBe5t0dEZ1dtw0km
         Z7gb4pslxFor4OCr6T7Ceam1vAYLsuiBY5F8GYdtyCSInlaoGt6KN1+0Zp+S9rZ06FDc
         xjBGaf8PPdj8txfrko6KQEOBBDlw3Mvy7maZjZAhmI7RtMqlVRRYEt9Aep/f8nbXBMIw
         cK5ISMBDvMF/+wz4SBxqYAj/KLwyqO2vRZKturvYm68W8cmvuulsmu1QiwRnRQgbynu0
         YmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mhtKDiOsLT1DFVkDtSR/HqZI5hm/yp+9fh0AF9ZzPSE=;
        b=ma/iGNPu22D7zDlzgzaAjYtDNr4lwNsr6IxoT+j1wWdq48mai6w83kOomrz08eMZ3G
         eZk2yMgd5E10NJm6WuWDyyeFXTXi99ZKCLYZWYzxRWCIh12TAAPuXZSyGjXQ1c53Yaif
         r6W0U/HEV7G2uk3VnyoBix3ovrZ5Hb6lbPknb55vfWARsbF0TQOi9aQmrqkevqlTRhqr
         +EiCVbsSZne3myqFLGWEil3yaf+gb7Rq2/yu/O+/Wx1EjM+yWsnB0FSvktwgBdI27km9
         Af5Kt2gHuecvtaF/xPArx9ga3ug7O6ffX1L5rb1u/jzjfnWsGYEnUDtO4Ov/otyYl+6n
         GA2Q==
X-Gm-Message-State: AOAM532RucQfRBNRH8KoHhGCe32NBsU0JDNE25qMycrmyiCpisTMpxNX
        vBSuT9ss34YtiFs0U5aqVJ4=
X-Google-Smtp-Source: ABdhPJxMx+ZUFUREsgdZwXILwUPAUIQIXLsPMgP/yfW63d+hAnPGcDSFRNCrhvv59aBJ81zTxlWIKA==
X-Received: by 2002:a17:902:8d84:b0:14f:83f2:8c0d with SMTP id v4-20020a1709028d8400b0014f83f28c0dmr11898579plo.110.1645444359800;
        Mon, 21 Feb 2022 03:52:39 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:39 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 09/11] KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
Date:   Mon, 21 Feb 2022 19:51:59 +0800
Message-Id: <20220221115201.22208-10-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With the help of perf_get_hw_event_config(), KVM could query the correct
EVENTSEL_{EVENT, UMASK} pair of a kernel-generic hw event directly from
the different *_perfmon_event_map[] by the kernel's pre-defined perf_hw_id.

Also extend the bit range of the comparison field to
AMD64_RAW_EVENT_MASK_NB to prevent AMD from
defining EventSelect[11:8] into perfmon_event_map[] one day.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edd51ec7711d..a6bfcbd3412d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -468,13 +468,8 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int perf_hw_id)
 {
-	u64 old_eventsel = pmc->eventsel;
-	unsigned int config;
-
-	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
-	pmc->eventsel = old_eventsel;
-	return config == perf_hw_id;
+	return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &&
+		AMD64_RAW_EVENT_MASK_NB);
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.35.0


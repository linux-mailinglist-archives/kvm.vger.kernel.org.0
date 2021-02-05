Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B183116EE
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhBEXU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhBEKFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B7BC061224
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:04:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id j11so3291075plt.11
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEERljz4qdFaDpGfFgKzxBmmCvSatSkY1c1MbUYcK2c=;
        b=HOccOI6UP5g7t9cL6Y5c3Ipx2+pKF/eOf4i3OzR4r3Oqow1Li2Ei1fDjYXSCFGhaGO
         zfF0CTQdawIrrTIxgHsGvI2e/8yFPv5fgQi04bASxCTYZaQ5ueWw5CsSBwTewCkwWxor
         zSh/cGLFidNddtHFVfXos+kLdVnB/Jcx0TdHGUVS6b89h70J8HoGFwt1PkVBSF37zzkr
         N1wiZ05+A1E2Ttuji4NoDpGH0VKEJCcf46VKp/xL/IlTXOi/6A3YLIn3trI3ffHjNuY8
         fbmh7n21i1XAHoaLVy/BdTjkDvDeQ/EbLcvoXzP0+OiTP4cJ7hBA01Okww3UavsaOm+3
         grww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEERljz4qdFaDpGfFgKzxBmmCvSatSkY1c1MbUYcK2c=;
        b=dctyH1OP02Ety7N6mVEaCALZR1CNR51uWs5VY5O+1O2ppKKTzvCBD34QWwuZSVW/W8
         n+npTVv3pP1vrdJCJdUNhi1cxMvo7BYLxokaV0qp/zAHOPLKIji9iEhQJzb/7K4M8KVe
         2fEdOUXCxwNCZ8xrNiUiHSyZqHHpl8hhnaKMD/a1d8uvN1uTCEB/tlDTdTTmK7/6bFnJ
         g4AuYXaEkhnIm+XL4yFQkYL0vH8RuIKTm4bWNLcCtzKK/gbFcT3XuWlu8dQhZvsEeHz6
         94Ayj7T7Kygy+GhUvmbefP89gOjOGPVaumrASQEmcv2EUTJ8fi8VOGR3rHgEdxKXO2ly
         2t1Q==
X-Gm-Message-State: AOAM531w1ogvzcpC1M7VcAbDwNtp6r9JCmf62nKrs1g2Jh1WFhKUlsST
        bTJH+MSyxgQy2qh2jc3hM5K2/g==
X-Google-Smtp-Source: ABdhPJyGePJ6u9nVgKlAA50Xb4wCgCVZB+/HoLTzFZAsA9PyQ2sCkDDkXEe7ds5HPfrcSqHEQPaKWA==
X-Received: by 2002:a17:90a:ba02:: with SMTP id s2mr3458890pjr.53.1612519454561;
        Fri, 05 Feb 2021 02:04:14 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.04.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:04:14 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 7/9] KVM: vmx: save the initial value of host tscd
Date:   Fri,  5 Feb 2021 18:03:15 +0800
Message-Id: <20210205100317.24174-8-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Record the host tscd value.

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a12da3cef86d..98eca70d4251 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -251,8 +251,11 @@ static void vmx_host_timer_passth_init(void *junk)
 {
 	struct timer_passth_info *local_timer_info;
 	int cpu = smp_processor_id();
+	u64 tscd;
 
 	local_timer_info = &per_cpu(passth_info, cpu);
+	rdmsrl(MSR_IA32_TSC_DEADLINE, tscd);
+	local_timer_info->host_tscd = tscd;
 	local_timer_info->curr_dev = per_cpu(tick_cpu_device, cpu).evtdev;
 	local_timer_info->orig_set_next_event =
 		local_timer_info->curr_dev->set_next_event;
@@ -266,6 +269,7 @@ static void vmx_host_timer_restore(void *junk)
 	local_timer_info = &per_cpu(passth_info, smp_processor_id());
 	local_timer_info->curr_dev->set_next_event =
 		local_timer_info->orig_set_next_event;
+	local_timer_info->host_tscd = 0;
 }
 
 #define L1D_CACHE_ORDER 4
-- 
2.11.0


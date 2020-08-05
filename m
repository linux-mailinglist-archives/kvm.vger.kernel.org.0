Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F223CC8B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 18:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHEQv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 12:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgHEQts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:49:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA24C0A8939;
        Wed,  5 Aug 2020 07:11:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u10so15826629plr.7;
        Wed, 05 Aug 2020 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t3CWCXEfy1YBGVg4SnMNF6schJfAMQg5KljYK4gfTsI=;
        b=XmnFwMtnjN75K16BQFkOpsa1h5Gm1rBb8O9whIuMSekmr/T3t27uE23AcKyg9byPcU
         dzzBGhvcFRByy1Q8+sYNxodBAWBAwD2Lp4i1aP5x+b0f/TzAD5ltXbyjS57qa5sBvhK4
         itlSPXslxBef0m0GB0yT2v85/iRjCac0hSY5FhBYy8l7+uKOMhY8+F02G+WVyx/EnprU
         Ofmp8Gkc9GZhKDjLBpV3XjErYVXpzmBVXDjmieAcvLAc888ZExmqFetlaWtf5udKQXEE
         6YFMyesazSwkr9VZwLwemb4GPyWF2WVJEabky+DzNfv257CQNCk5SbffNCoCMDGh2/Eu
         /vNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t3CWCXEfy1YBGVg4SnMNF6schJfAMQg5KljYK4gfTsI=;
        b=LaflvK6Rx23mNdWE9DwZoDwBvcQT8I2/nlrcfZHGyGtAvG+g90BgsKu9EXrzyc4hvO
         4p9ROI8ARhEfX2+FyL4RhTJmyI6rLGa1bzf87R5rjo+OXsmFukIja8jbqpyYwQzrQ8Po
         nxgekHzvbyFXNh8SRaG4Qk05ZsCQqJuY53bN7QtGl0V09/AUTPLdZC+KTGW1OCUazruk
         I8eVWNjl5tiO3BcilQFZObs6hiIouPxXdlrjEQZjqL9ZhbYZgxf1Ky9s+MJEhxH4EcrY
         u4ZKIcEu+f9vfltV8v7jzQvtl4nj2QNEvlPCGKJEl7ltXShqaMP1JtIHvn2NHLRa+GJE
         nfrg==
X-Gm-Message-State: AOAM530v9lfwtxw/cMPibba/zpTiCQLb4JcGg6txqhJXKXaNABpIVe7/
        j+HpASxH8Cjemk/s+jrYkcs=
X-Google-Smtp-Source: ABdhPJyOFWD5B/gYZFHtHdIRmVl+RANMmDV8CWKM/a/07nb6tdMmsyGysW9wL9INF3jqqvCSc1Qwug==
X-Received: by 2002:a17:90b:1106:: with SMTP id gi6mr3689116pjb.2.1596636700874;
        Wed, 05 Aug 2020 07:11:40 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id o192sm4300017pfg.81.2020.08.05.07.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:11:40 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 1/9] Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT support
Date:   Wed,  5 Aug 2020 22:12:32 +0800
Message-Id: <20200805141232.8742-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Add parameter global_root_hpa for saving direct build global EPT root point,
and add per-vcpu flag direct_build_tdp to indicate using global EPT root
point.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86e2e0272c57..2407b872f493 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -821,6 +821,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* vcpu use pre-constructed EPT */
+	bool direct_build_tdp;
 };
 
 struct kvm_lpage_info {
@@ -983,6 +986,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+	/* global root hpa for pre-constructed EPT */
+	hpa_t  global_root_hpa;
 };
 
 struct kvm_vm_stat {
-- 
2.17.1


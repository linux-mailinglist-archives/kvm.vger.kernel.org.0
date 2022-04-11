Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAA34FB797
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344466AbiDKJiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344443AbiDKJiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6E192B5;
        Mon, 11 Apr 2022 02:35:52 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t4so13703202pgc.1;
        Mon, 11 Apr 2022 02:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ctb/Dmpvifb3cPDaFvWsUP/a3QdJdiSG7ihOCp2uZLY=;
        b=jtrh/M5Jl58UeeShmz+plGV4GGiXAIXW8of66nHuIr5Qh/mq05gAjEpjvBBkADZa9/
         Fi/eCV02HPU4HzvM5vPyYGf2XtF9VVzUPgvgahMP3nci6+hzlWLAELWsvEhyW+czmagK
         6/dtXuTKb8yO2LXuJGaaovrTM92Vu0A7/7AizTxQj8/0NzytkhQ4dfAWgsPcJjD1VcjL
         waTTKKM9sMRLWtwE7ROTih/UqwUf9w91NfkaSO7GICjxKaxaDK/wOy0BtWSRMavIaJEM
         KQw7zzX9bM4T94/7UpApCLkEY7griv9ohGvgLi8ysQiplGLS3pmCpCJoVOVR7m3At+ra
         /W7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ctb/Dmpvifb3cPDaFvWsUP/a3QdJdiSG7ihOCp2uZLY=;
        b=vCY0wzoG7c2W2cE6dKlx7vFVGiSPCHe00s7yjd7Abl2LImeVGaCYRfzO8SlRsMa9aB
         KBqFr9911Y7lUJp6AwcXAYSqXyN59cR933sy51of92pDATCe7GhvW3BHFMpKHtOVbd8i
         f2jbzE8U/evHRUwxNZlWxakjeH2b3A0bEAhZNqyK6dj14OmAEHi0t+11Hg1tVHlm4rMk
         z/BEprZKiD5zgFB/5szQ5yuh3VtFzlL0M4v2HPBG9IWApG+z+V+a/kiKMC5sMDzby6qX
         SX4TQ/j206sN/15FFqWNubIuKPJkz11+vg1hqTZTxuMFFte08sKOygRF+/S6gKQYy6yl
         Rq1w==
X-Gm-Message-State: AOAM531MCsr9w8cMiOL6/DMvmSibC9WH1iObpdZwl4e1CV7J1Dg4xC6a
        DiWOKpYXgjyF4IRcceq7D9I=
X-Google-Smtp-Source: ABdhPJz+78kqBrLnbR8pHgH159B+u1ynq2i1ACTIAAJ5+SbHzm/4GY8mPH9ojFXj11Jr/ApmaPa4BQ==
X-Received: by 2002:a63:3e0c:0:b0:398:2829:58cd with SMTP id l12-20020a633e0c000000b00398282958cdmr25943204pga.464.1649669752487;
        Mon, 11 Apr 2022 02:35:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:52 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 03/11] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
Date:   Mon, 11 Apr 2022 17:35:29 +0800
Message-Id: <20220411093537.11558-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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

Similar to "kvm->arch.msr_filter", KVM should guarantee that vCPUs will
see either the previous filter or the new filter when user space calls
KVM_SET_PMU_EVENT_FILTER ioctl with the vCPU running so that guest
pmu events with identical settings in both the old and new filter have
deterministic behavior.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 00436933d13c..adbf07695e1f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -211,8 +211,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	bool allow_event = true;
 	__u64 key;
-	int idx;
+	int idx, srcu_idx;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
@@ -235,6 +236,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	}
 
 out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return allow_event;
 }
 
-- 
2.35.1


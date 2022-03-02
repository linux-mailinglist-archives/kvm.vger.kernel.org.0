Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B9D4CA305
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiCBLPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241339AbiCBLO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:57 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CDE60A87;
        Wed,  2 Mar 2022 03:14:12 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e15so71367pfv.11;
        Wed, 02 Mar 2022 03:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ljDwF0Y8ODfLp/v8xYZgjAQF71OWFjDNrATmfFmG+To=;
        b=graQFjVDQ+6NCNuMj+ksCcKkCNGFgCl3v+UTPod2Wcj4/gJF3Jdq7WWPXmCxJLlmpI
         eixVdcJbQjrRENuiQ6rkqjaFoKRSCW2df+yrOdQoL4hHNsbDYIoAMQT6MzCyr0Bmxi88
         Bcym370VN+aTUxpIf3up93c/f8uBKxg+r6qh/53Eai3cceM5vm4BPSJSltAKoyfb1C3p
         UgbHcuHSHa9kw04HiQs4onZEXv9vBFY4uxagtz6aMy01bX884gPPHtqenSHXmRjbaTrN
         aESpKtKXtR3mxnKBDlRFqUb7UKSql+I0WrgcH9eZ22JAB+t+tI5p9N8JwOwINY0e+D3V
         oK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ljDwF0Y8ODfLp/v8xYZgjAQF71OWFjDNrATmfFmG+To=;
        b=pUtrP9KGG5VsTCdME7hw4MLzOY5Jiyf8s/2GEFMZVpjZDnyW7iDpwec1+EZOmkdmpL
         bPTCjfdKphgICPQNLFNM8eeGNx6c0HbIRW4AiQqQzl+CDD4Gpf7+uD79YjzBZY0y3UZd
         wsitgmrBZ5aCpxCaoCuKeiUwFsUvokMOxfO7X/JPXpJpYns7yUehXiPuETSSJI32o4MQ
         y/59WolHoFd9IyTSyScrsWDpLjBJfeQs/GiU24xbFOs+voTtDursiBQ+dCO4QUFcJYN2
         yfIgQwmddUB1kWwP47gybZq/RH0IAK5YxdPotRkycGV//BT5qkAu0HORSySGmIg8GXPm
         NV+g==
X-Gm-Message-State: AOAM530O5AwrjaJqUp9tzecy8YztMYi7YTVg02mqgK8TvzNvnMYKvMuP
        G6HlvtDmw9/4bB70BBKchNk=
X-Google-Smtp-Source: ABdhPJyMUNSg0Piv6j4aaNMwiEzd1VrSm7ScRiE4tu3gxsbbu5rSCJO/sIzNDCHgVx31UkEe1aDoqQ==
X-Received: by 2002:a65:4d0c:0:b0:379:3df:eac8 with SMTP id i12-20020a654d0c000000b0037903dfeac8mr3962615pgt.166.1646219652357;
        Wed, 02 Mar 2022 03:14:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 11/12] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
Date:   Wed,  2 Mar 2022 19:13:33 +0800
Message-Id: <20220302111334.12689-12-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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
index 60f44252540a..17c61c990282 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -185,11 +185,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	bool allow_event = true;
 	__u64 key;
-	int idx;
+	int idx, srcu_idx;
 
 	if (kvm_x86_ops.pmu_ops->hw_event_is_unavail(pmc))
 		return false;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
@@ -212,6 +213,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	}
 
 out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return allow_event;
 }
 
-- 
2.35.1


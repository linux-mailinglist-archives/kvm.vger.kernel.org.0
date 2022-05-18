Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF452BBDC
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbiERNZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbiERNZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCE11B777B;
        Wed, 18 May 2022 06:25:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ds11so2056235pjb.0;
        Wed, 18 May 2022 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ugrUGXg1vJU0Rc38q/y3whV0v+F8aO2EtBiRdNf5FTA=;
        b=Pn3zqp6akFaR1o3StQWduW5FG6yr9lXF6WmbX6vLnzLW2zSwCtoJKDIbefrkqvdj/L
         0g+M2ChNln8NSNXyqgTrj/7m7aDpvTMUGe8mfA6rqwIzN1DEwDbvq1uRxzR/+Z66IWs9
         PM/kygMiPZt1Bhlk2HHg2iDbSzR4oT1mcM+AUp0b12godS3x9XJSgn4YCI6sZ2lc5ykv
         E3cNTtUlc+8uohgDxnHGOJz3fF505pXqpTFZn7dbfKJMkb7dDjAPgJpuBkUynZDwgAAD
         t3g/ZGLzhOjFuyyo1V9cRX3Hi2rtI0U6hQ0kmyFvZg4RwDER2dwB77JmpHNNrqUjjJMa
         5lUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ugrUGXg1vJU0Rc38q/y3whV0v+F8aO2EtBiRdNf5FTA=;
        b=0eCNBON3UtD9vK9G0wc6BXRQ1lcRKvXrKl7ydDoIOw57hPY04EJ0foIszEainFAzKw
         0JDElC7cDJB9L7IKy58hubboqaoQHGN9yyJXHQVy9ziSZbVauwjpgpjPRZ1x149OPWHq
         M4solsngLHEclUW9yCW/t3Y0mDRxHm4xcUcQMlSSZO8T5PJ8eGh7wnoYMUxmFtT7TuQJ
         +RAcIcV/pt8qpaUFXQIr89DuB9kXczMjrRO42+tzpUe7S3h5arpgLG7wCgWVNL0kCD38
         140QeAVe0oB1sKRmMNGEWu1Uckppm7LPFIQmGC/4cbmOfo75vZMPr0uXkcrn7zX8QMRj
         O3Ug==
X-Gm-Message-State: AOAM530pEhjNLTpe1ITzUtdFZ1PTQULRBlpfn+G7ZA5hMCVlE+jBmrRQ
        unYPCSvGJea122FggrVZtYY=
X-Google-Smtp-Source: ABdhPJyrNKLZEsqK7f8koaXenQm3xQWhoUKEeiSktq2NQuD49bRYhEbk4wjXlUNLTRND+JmLZAxKFw==
X-Received: by 2002:a17:903:290:b0:15c:1c87:e66c with SMTP id j16-20020a170903029000b0015c1c87e66cmr27886975plr.61.1652880325618;
        Wed, 18 May 2022 06:25:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 03/11] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
Date:   Wed, 18 May 2022 21:25:04 +0800
Message-Id: <20220518132512.37864-4-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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
index f189512207db..24624654e476 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -246,8 +246,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	bool allow_event = true;
 	__u64 key;
-	int idx;
+	int idx, srcu_idx;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
@@ -270,6 +271,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	}
 
 out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return allow_event;
 }
 
-- 
2.36.1


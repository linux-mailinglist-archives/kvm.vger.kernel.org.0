Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832654BE660
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357115AbiBULxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357048AbiBULxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:24 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1269201B1;
        Mon, 21 Feb 2022 03:52:47 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d17so8647876pfl.0;
        Mon, 21 Feb 2022 03:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+R75ibZOMH2erhPGpJ4UOQrxhD/H+fgSa4LFFJeyR+c=;
        b=C3PUVSAQblKLBoLjedEjZEWr9jzp2hGYGHMzMPJHYg9SFYuiw2ZrL64tc+nFyDgNsR
         je8nKAkTLPlbu4gVoyttixYBZPNLwkK3gMVCpn3a7Rupe5sTZ9cwfYs/mzTHDN75PN98
         ENzMrlI2W1hZJiTfy7GA/lfAPMRC7fGnNYRd40Nhqi8p4NcURtikeIgru1k62ZGERQcD
         yOFZpzvdWTHQ2CM+FTsT3PrePMqHcxUj5XTef2YbFQUUFDPSbZeerkZxxXe2dXOZcVFs
         EHmhqqUUmWaRIlqkJAl6Rue1rzb6xIe/2tXMb0FlJYQUhA1qVrEDiZCNe2IHnYkePEfF
         Qc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+R75ibZOMH2erhPGpJ4UOQrxhD/H+fgSa4LFFJeyR+c=;
        b=C84qdGbC9p4mAoin29+dVRwYHM1G8Jb+//8KFEXtJLcJy6O80KIHegJVvQ2rNEDNbX
         YE1cxhkY9q5K/cKG6dbsqY3iy85sx6m6iAuphWeDziG4usiIRzKMqWyx7N1/r42DIjUT
         tVMycl7J1g5yFJ8x7Xcp8uQ0ny0RvF0KU1IzLO7w08848+taZ1gT9Y0MN9+bhLNi4G14
         f+WNufGfZqPGbrfyqi/Vbf674JxhTztHhzvHmCnzdkVtxZ9MKXsxinm7RhzJXiu21TyE
         Qx0dohOUoTPQ0YMBqu4oA79fO3K6KdlK83u/PtBeUXKlsEn601P1BvdVKJ+fcL62AULA
         vmmQ==
X-Gm-Message-State: AOAM5336fuO0H2gb0SQWKBZMct2BTHjIJNP7jZrLXwdWC8kDTpxsUXaL
        olgN/jUbOcGgyQO/C7lrfpo=
X-Google-Smtp-Source: ABdhPJz/k4Yl4rwR1/MPXLtw/2I6fV4iNnKyLtmElWSrIrE3LJ7gyRNBNfEyGrrKkqh3drzM9pKyIg==
X-Received: by 2002:a63:114:0:b0:34d:efd0:762a with SMTP id 20-20020a630114000000b0034defd0762amr15783747pgb.71.1645444367118;
        Mon, 21 Feb 2022 03:52:47 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:46 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 11/11] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
Date:   Mon, 21 Feb 2022 19:52:01 +0800
Message-Id: <20220221115201.22208-12-likexu@tencent.com>
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
index 40a6e778b3d9..84f0fcbba820 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -183,11 +183,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
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
@@ -210,6 +211,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	}
 
 out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return allow_event;
 }
 
-- 
2.35.0


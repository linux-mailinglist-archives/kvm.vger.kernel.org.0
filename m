Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5D51F9D1
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiEIK1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiEIK1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:27:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739A028E4D3;
        Mon,  9 May 2022 03:22:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so13408249plg.7;
        Mon, 09 May 2022 03:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/KscUgSu+DlH4SnTOHon3YcfRcvIy3eZGU1H9dQC07w=;
        b=NuD79QXPiIDpamCnzpVgpF+Z/rwFjNUgkt28orvyyqiYCcOtiCjLll4jMZJR7GAu+F
         Sig9HeJSUbTwYmIgdm6QeKXqgdERJF4zvuQO8QhwEILcdTR7HsN6GDN54FmUrUOfcxgA
         8Gr6KSfVMOjg/UsrJ6zhu62iy2Ljkmz6zzBzM2IJKOdo6uNgtAqSOxSEtzxa3HaQxWjn
         R2CGWN4rUKM6fxWIqMyhNJAtf7SoWme89hid/X0T/5xfIgtBNDJpgJ1CIhFvpXfmKa36
         Kq0LHenY+FDdat1OVt5mALL/tHhJ4tO5mp05nCbGhlXYtDtYjYS2HhyHdM7vtHLHYCyU
         Ll5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/KscUgSu+DlH4SnTOHon3YcfRcvIy3eZGU1H9dQC07w=;
        b=eet9jghre2RhvvlLDiA+cpa/UVe1k1O0VKXwE6rFSBkIKMNO/d2Gn2GgVPw16HByxB
         0+DvAyTVpazvFRd1LnFguCPsd1lRJ/sUtgwCIhenprzt0uZbt6AZXvf+KDToxvAVD/0Z
         LqigS61MWV9rIpChIQnFRZAENHcxRZ2j8x55i63AaLhJMgHGWNI4w63yby0wgkm0LrM4
         SDFmy+P6XjxYWqJLVrRq5WrAsc2XkGtP2hhTVFKa8PtDbVui8vRD6oDH9hdZhQmDAb//
         4K9fIpC9ODpxvaFDL3TINm7KQeBMkR4Pw1366vt9TV7FT08zEdkS3MM+2OcbGp/YcDlQ
         vpJg==
X-Gm-Message-State: AOAM532TTn0t7PUWYoymouSGU61KNoMjIWmqOB1dwz5Cx8fkUKFglwYa
        7GaH3rbpRW7AZn2S6hTGb+FyzLhnCft6SA==
X-Google-Smtp-Source: ABdhPJzSGfIDAJMvWOYBIZ1DcN/yg1OCjsbigRe0bvdQ6wHdVcd+wSIQLa/BiuHdwyVRoKpaS1dTrQ==
X-Received: by 2002:a17:90a:408f:b0:1d1:d1ba:2abb with SMTP id l15-20020a17090a408f00b001d1d1ba2abbmr25819382pjg.152.1652091739545;
        Mon, 09 May 2022 03:22:19 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902b09100b0015ee985a54csm6688891plr.56.2022.05.09.03.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:22:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/pmu: Don't pre-set the pmu->global_ctrl when refreshing
Date:   Mon,  9 May 2022 18:22:03 +0800
Message-Id: <20220509102204.62389-2-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220509102204.62389-1-likexu@tencent.com>
References: <20220509102204.62389-1-likexu@tencent.com>
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

Assigning a value to pmu->global_ctrl just to set the value of
pmu->global_ctrl_mask in a more readable way leaves a side effect of
not conforming to the specification. The global_ctrl is reset to zero on
Power up and Reset but keeps unchanged on INIT, like an ordinary MSR.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cff03baf8921..4d6cc95bc770 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -525,9 +525,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
+	pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
-	pmu->global_ctrl_mask = ~pmu->global_ctrl;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-- 
2.36.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66C651F9CA
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiEIK1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiEIK06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:26:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D228E4CD;
        Mon,  9 May 2022 03:22:19 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e24so12743308pjt.2;
        Mon, 09 May 2022 03:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dV2FPN7PIa/uNEp+Ct0krf8WyX1xQjO91HcqOH/26U=;
        b=HaX8OjAyKk5UjP7m+w5IbTSKrKFgFl5+MMz9H6ScoXld7N6QmitNPAxf4G1Sv/9DPr
         xFzl3L0OdQ+t/vJIz5PeYTnRVPpXjKLfV0QS2s3AiWHhpEfckyvd8al7Xl+FOSqyGSom
         24cZZjEpM5FOq1yV24w2RvI8EtbjePfK6R8cpeVWNWvKQJxqPCGDKFH2KbrS7Pr4uEma
         cFbBOCktn0aJif1PtIzAlCpH+QoIi5WeARPG5nmWCvV4oS6509GAoDKCIvuCuPH3B+Xu
         U0LgruRSW1V53e0J1qmZJnC/zDpcPqljgQPo6n9uUEX5pJBov+8AFmdB3BAhisOQZhc0
         ohEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dV2FPN7PIa/uNEp+Ct0krf8WyX1xQjO91HcqOH/26U=;
        b=Oxa9RyKC9ynDqzZ/vk0MdF1iR1ueNKFQoJkUg6CTDU9MMB8s0+JtFq+B+8xhxDXycE
         whm5ip8VtysyXa+gY+YqU6KLKF4nzzVrVoJNGHSJaiyMmVAwDLquoXDwClutQgauhuq9
         Qs7vVExuaywpoGNV3vcu1LnDlhncSswG3C9HE6uw9xqftrhzNI/iNEQMjEO7Ei46BsuN
         3MdlAueEjdtvuYUGACC5rSJ0szjY97eFZSmrmKs5i89AQiSRKCisMmPL6d0EpDO/+G2Y
         PjkcJg5DNPeqUXtnWGk46UlJ2mXavZpGiSWFcely9LjmrvuUsqjQPmbhP8YklECkfgtC
         UYtg==
X-Gm-Message-State: AOAM53177RkXAwAklvz6nbV3bUZv/a3opmKSnbo616cBf3Iofv188K+m
        CQpI5gX4GBWIiarTpl74gEK4y2Xmyk5FOA==
X-Google-Smtp-Source: ABdhPJx4nRwsvEWhM/JKnxCAdMzjTdkhTq77E7F0zcu7mP/+6VupUTNx+NoLFgzIPefHR16nV20P0g==
X-Received: by 2002:a17:90b:3ecd:b0:1dc:945e:41b1 with SMTP id rm13-20020a17090b3ecd00b001dc945e41b1mr17222115pjb.208.1652091737152;
        Mon, 09 May 2022 03:22:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902b09100b0015ee985a54csm6688891plr.56.2022.05.09.03.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:22:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl
Date:   Mon,  9 May 2022 18:22:02 +0800
Message-Id: <20220509102204.62389-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
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

MSR_CORE_PERF_GLOBAL_CTRL is introduced as part of Architecture PMU V2,
as indicated by Intel SDM 19.2.2 and the intel_is_valid_msr() function.

So in the absence of global_ctrl support, all PMCs are enabled as AMD does.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b82b6709d7a8..cff03baf8921 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -98,6 +98,9 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
+	if (pmu->version < 2)
+		return true;
+
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
-- 
2.36.1


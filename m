Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11441783B62
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjHVIEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjHVIDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:03:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612321A2;
        Tue, 22 Aug 2023 01:03:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a3082c771so1666973b3a.0;
        Tue, 22 Aug 2023 01:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692691412; x=1693296212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pn4QZBlC1MfWTK1af89ZYn8h7oBBHoPehAz2HG5N6gY=;
        b=calxf7xMFPIAze1bL+VKS3G36LFoTLpABqntKtyQNF2PbKuv0jbMge8Wzzjzy4ppT+
         zEmeysflbvg3qi4n8APf6uDiMc6PVZ9QL05Mc9MY/+pay2gPYGs4MPPX2DlrFt1EYlYW
         LpK5v4NB3fy3c3pn0wIojXrFHgDpel23r4geG2xebhl6xRwoux9dE3b4oqB5gheZShSJ
         tzDhfDEhOkSf/Ot9QfS39EGAxbCWw1Q5dxkKzBRY7BY4QSdWlGxroycNpcFdvjADkvsj
         PjSztWMHwn89x0LFSffUUHG9y7WErFRAaXM1wjHAhAezm19oLNnIqj67zL6T50perp+D
         6bzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692691412; x=1693296212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pn4QZBlC1MfWTK1af89ZYn8h7oBBHoPehAz2HG5N6gY=;
        b=I6ChZK5nN0vqVGst0N7V60zxbAryVWMen4N3AN5p/IrgL9cwOrDfkfa0olV9B+4Yyq
         epKpcHep+TcolU8wq8b7LfIyI3RAn+KiNzBh5wk1VdepcQeJ4HVs3e/w9IFwN1kOXxSW
         kdOWPZwYrJz0Px8eUEyGPYF3qaGw6Na06k02cRqTUf6qRur4Vo/4NGIYROMh8W6+WJqX
         sdL4UzJiOpCWPm5LOrmwPxssDwnRNc66F+o1j/rIup4YBk7MqHSFPLRrbYDYreUoKBck
         zcMIDwbLgmzEjB+TxV83w8c/tUTdFvgFgeyjYr6kBX6lcpn+D2wsODFuZvx6vPYTTfpR
         edcA==
X-Gm-Message-State: AOJu0YxCefAhV1uClMG5vpbcj3HMFwb1HNZvS+wpC3QNF8Dh8CEopzD2
        SXZTbZrCeJyc5iWf5DaMLdiAOYnIMf5bH9oV
X-Google-Smtp-Source: AGHT+IEFIZejmRgtEnfiwk2h1y+BUEPAmQAV9vlRCTZPr1TdIrKlrhCXXwqG+NoPgiTqQP7s3mLf4A==
X-Received: by 2002:a05:6a00:4a0d:b0:68a:6cbe:35b8 with SMTP id do13-20020a056a004a0d00b0068a6cbe35b8mr1575097pfb.6.1692691411593;
        Tue, 22 Aug 2023 01:03:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c2-20020a62e802000000b00686fe7b7b48sm7257381pfi.121.2023.08.22.01.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 01:03:30 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Allow exposure of VMware backdoor Pseudo-PMCs when !enable_pmu
Date:   Tue, 22 Aug 2023 16:03:12 +0800
Message-ID: <20230822080312.63514-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
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

Fix kvm_pmu_rdpmc() logic to allow exposure of VMware backdoor Pseudo-PMCs
if pmu is globally disabled.

In this usage scenario, once vmware_backdoor is enabled, the VMs can fully
utilize all of the vmware_backdoor-related resources, not just part of it,
i.e., vcpu should always be able to access the VMware backdoor Pseudo-PMCs
via RDPMC. Since the enable_pmu is more concerned with the visibility of
hardware pmu resources on the host, fix it to decouple the two knobs.

The test case vmware_backdoors from KUT is used for validation.

Cc: Arbel Moshe <arbel.moshe@oracle.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..c896328b2b5a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -526,12 +526,12 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	struct kvm_pmc *pmc;
 	u64 mask = fast_mode ? ~0u : ~0ull;
 
-	if (!pmu->version)
-		return 1;
-
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
+	if (!pmu->version)
+		return 1;
+
 	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;

base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.41.0


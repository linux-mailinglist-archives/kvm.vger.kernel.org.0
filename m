Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3464CF1FC
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 07:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiCGGjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 01:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbiCGGjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 01:39:12 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C83D21E0A;
        Sun,  6 Mar 2022 22:38:18 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d187so12876898pfa.10;
        Sun, 06 Mar 2022 22:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hlJQ+XgCbYmU2b5PFSmSFsvCWIeaJuMoYnTA7mdc6RQ=;
        b=CLPyGMv2xW5xrhX6ODf0JGNlwNnLU/VotOZNKudnoGF16G5tm4/AQW4wJvgcADxxmK
         lOsGRD0SPCRZtafU6Uq3JfJN1iNjx2ZG2fNt7d3rqM3r9r5xX+pn5X1jz2+t56OR7Mqp
         DX4MOT/cUaO6MMY8KV2VOhkCMACbO9xuTjW5FxgiDsZa4PtOi4xu1JOLfeeEICd9dSAR
         EYvLOFYjdntVRYggTXKltge6TDgegT2VeVlmQnWjETlgamOcLcjiFdTiFSvQmyGiiFI8
         dIZTy3GV2mFlP1GLExvBAT0jKKRmEdMNojhJgkTJCrrAvTyvH6ualZCNDrGe4pv3Z9HQ
         IvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hlJQ+XgCbYmU2b5PFSmSFsvCWIeaJuMoYnTA7mdc6RQ=;
        b=xZbpUO/2AQJLCu4+IBqT4i0DrblE5jlAgx6MPGGoCDIj2z4koFDi9TAaCSnpgpnKYA
         XLwza2yQhn2cQCeZXEDVFSDkuLnosEmj8xUCvN/H8SBms3kX6AuPe51zP5bvHBpHKtH0
         M9ZYMQNz4ZOxexgG9MQ99tfU4MOhV6en05pGWHSiXACgxaxwtbqTrkdmHBS0QKkH53Xl
         QZPm7XFTeKrrCYC/qSs1shntrgYY4LM1i4R2XKLVl92Q/wWTH+qbbDYebODL7xmTdMnd
         1oEBgKpA3wsLPMvjNZwKvUgzadn9ednOgGZpxFIhCB3nnxClbVEvmCPKpQ8IWJWr4wnU
         cCug==
X-Gm-Message-State: AOAM532rq0PCQYMUEXlLAWsOHDKGJw+N4V1h3+q8R56WS81ddugGNFmW
        72BNkSlBoPQYsbDJokKUB9Y=
X-Google-Smtp-Source: ABdhPJxvvzeqR0jnq79NJUHVu11FZCXl3znAlYicg60rY9IG0lSOqgKRJaU9Ts1jsKR4N43ASNbbnQ==
X-Received: by 2002:a05:6a00:150a:b0:4cc:f6a6:1bc6 with SMTP id q10-20020a056a00150a00b004ccf6a61bc6mr11370956pfu.74.1646635098029;
        Sun, 06 Mar 2022 22:38:18 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b004f0edf683dfsm14134781pfv.168.2022.03.06.22.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 22:38:17 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ravi Bangoria <ravi.bangoria@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Isolate TSX specific perf_event_attr.attr logic for AMD
Date:   Mon,  7 Mar 2022 14:38:05 +0800
Message-Id: <20220307063805.65030-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

HSW_IN_TX* bits are used in generic code which are not supported on
AMD. Worse, these bits overlap with AMD EventSelect[11:8] and hence
using HSW_IN_TX* bits unconditionally in generic code is resulting in
unintentional pmu behavior on AMD. For example, if EventSelect[11:8]
is 0x2, pmc_reprogram_counter() wrongly assumes that
HSW_IN_TX_CHECKPOINTED is set and thus forces sampling period to be 0.

Opportunistically remove two TSX specific incoming parameters for
the generic interface reprogram_counter().

Fixes: 103af0a98788 ("perf, kvm: Support the in_tx/in_tx_cp modifiers in KVM arch perfmon emulation v5")
Co-developed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
Note: this patch is based on [1] which is considered to be a necessary cornerstone.
[1] https://lore.kernel.org/kvm/20220302111334.12689-1-likexu@tencent.com/

 arch/x86/kvm/pmu.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 17c61c990282..d0f9515c37dd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -99,8 +99,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
-				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool exclude_kernel, bool intr)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -116,16 +115,18 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
-	if (in_tx)
-		attr.config |= HSW_IN_TX;
-	if (in_tx_cp) {
-		/*
-		 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
-		 * period. Just clear the sample period so at least
-		 * allocating the counter doesn't fail.
-		 */
-		attr.sample_period = 0;
-		attr.config |= HSW_IN_TX_CHECKPOINTED;
+	if (guest_cpuid_is_intel(pmc->vcpu)) {
+		if (pmc->eventsel & HSW_IN_TX)
+			attr.config |= HSW_IN_TX;
+		if (pmc->eventsel & HSW_IN_TX_CHECKPOINTED) {
+			/*
+			 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
+			 * period. Just clear the sample period so at least
+			 * allocating the counter doesn't fail.
+			 */
+			attr.sample_period = 0;
+			attr.config |= HSW_IN_TX_CHECKPOINTED;
+		}
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -268,9 +269,7 @@ void reprogram_counter(struct kvm_pmc *pmc)
 			(eventsel & AMD64_RAW_EVENT_MASK),
 			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			(eventsel & HSW_IN_TX),
-			(eventsel & HSW_IN_TX_CHECKPOINTED));
+			eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
-- 
2.35.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4294D69F00C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjBVIU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjBVIUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:20:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A6E3BB;
        Wed, 22 Feb 2023 00:20:21 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p6so3807864pga.0;
        Wed, 22 Feb 2023 00:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tOIPcKaW3fnRQUh4fOwQO2ufRZq2a018DBv9vQ84s10=;
        b=Y7r98+xtj8zwwt5nPL8yaERcRvmhAjNVEOBZSL9IFP4iUMGvIg5oPWyScgm3PXH9vT
         bPiKZcHs72DsHjs+mXA7LL44O7Z/xZHSCU8QbgE/0O122spKcThy20YWBYf4fq9uBXrX
         18ipCILhPaW1dnMUQJDx10RRutROiJ/3PVfoeOw8cFVC/r/Z1Vr8vfLMG3I+pySXIc0T
         ninaZxPMkr3qi0t0ePO7Bc3oIuxcBv0c+/Yj3+2/b96/A/PL0TlGF0BduLzsO9LbqHik
         HehPEVJgb8gVlzAN3MWgeiFXo2uIHFC4zdvrWhPo2MTIwGlcYAbzi0wruQL1eAT4DxzM
         jD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOIPcKaW3fnRQUh4fOwQO2ufRZq2a018DBv9vQ84s10=;
        b=rdofNAGZ2wcA43L505pman7p4RN+8L2WY8JiiGoU0n5SN3nihCIrv289XNPdAHwquI
         HJh4c7Mfqmxd8zkQRpRH7I3yKUuPShvBU0Z1vSs8k1ACk/p7X/vZIzFEzuRNgRhKU6mh
         Lm1MwVcKcJ7nLnogLerPX8Hkv27bPrcTilrv8IjIgUth2JbCOPEoGqxH2G0En+dryQBA
         z52bukRK/kHYwb+2Do9nrXZpDcmasisNlZnGn9zNfBRm57hZBWOCeqG6Pu66Vxk6VJbC
         z2GijGxI9E8ZEiD+1PBbQ0cffTY334aFZiQJdc28MPdc0mBF6LghlbyCW64U+xydDpgy
         +klQ==
X-Gm-Message-State: AO0yUKW8yU37qA816qmd6P6Ir4cmbotGNx8DqDeChqWlca8R6uy9WP51
        g0H+rr0a7ZUHlj03Wb31Pak=
X-Google-Smtp-Source: AK7set9fZZy6DITBKCZApQyZeU9eOiGa/YY9BwAYYXkBjc5D8SospUdamWwkk+2zGxZ3mWiKkpEvxQ==
X-Received: by 2002:a05:6a00:3305:b0:5a8:d438:c72 with SMTP id cq5-20020a056a00330500b005a8d4380c72mr5554296pfb.5.1677054021116;
        Wed, 22 Feb 2023 00:20:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a11-20020aa780cb000000b005cdc64a287dsm2658187pfn.115.2023.02.22.00.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 00:20:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>
Subject: [PATCH] KVM: x86/pmu: Apply event filter mechanism to emulated instructions
Date:   Wed, 22 Feb 2023 16:20:02 +0800
Message-Id: <20230222082002.97570-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
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

The check_pmu_event_filter() prevents the perf_event from being created
and stops the associated counters from increasing, the same check should
also be applied to counter increases caused by emulated instructions.
Otherwise this filter mechanism cannot be considered to be in effect.

Reported-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7b6c3ba2c8e1..1fd1c2f0d4da 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -684,7 +684,8 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc) ||
+		    !check_pmu_event_filter(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */

base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
-- 
2.39.2


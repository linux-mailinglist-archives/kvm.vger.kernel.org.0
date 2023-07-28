Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C527767460
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbjG1SUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbjG1SUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:20:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488134231
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:20:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c6db61f7f64so2280852276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568407; x=1691173207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=69C/ntI6f1AOmR1sB1xGfWOc1uE0vjjS6a/8TiFNaMY=;
        b=4imiPj/W9BwPalHOzSmw17NqttBRQo5o87hsgLVbMTlVmd/zBz0lRAimJvIDRV4WdE
         r+gxspdcXCtepHLMuOluphMantxnNzisQBUf88GFsz+BmYeK9BeB55+0okua86LKOxU+
         NjZvQoJhPEQWEkhKojZNYVyui45IbdRp/Ul8n0lbLS02iL2UhRDICNo1e4dohFmFUkbo
         lPfxWdqTRPZAb/6xg65Y1GZH5JvMfWX5HSpDppDP2c0EgAh19zghIogAY2iCtWeeSoYS
         mn5ojApZi7HdigofpZ+vY024pSWUwn8FwASrIWAb0U0bBw8UoN9K0mqtOWIev5TTR3A0
         t54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568407; x=1691173207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69C/ntI6f1AOmR1sB1xGfWOc1uE0vjjS6a/8TiFNaMY=;
        b=CkScGoqx1oeEGks2yDKIwVGkp9V8kCWbijaKeCjNdviJXnnxbNPOZLm4KHFqXV5eQX
         SEROn4ksVX9SoGFaX37m4TMlWfaY3zPK0EutAGfkkvklTaizj7VAQ+R3DuA2Amu9cCFn
         vxtZLS9ewDKHVmIWmRoAJRToGfxVwgkxwKkmIDe9y8X6ivG3niy8l3BOZGZX+EkTXOCH
         e3st23kdeJqnJ1OSYpWzziPKaI3RxhPq11IYLivHyuo3KefqB5FwQbdJXv+v0NSnd9jg
         YWHNcw+qD+Qfkfu+tJ5qngT5Gc4K0tYX3CooD2V9SSDtQ8MpZ9b2ih4Mzy6+U0x+Qc5g
         C4qg==
X-Gm-Message-State: ABy/qLY1QRghempMFwNi5BIT7ZS8YjUJUS5CHTGvYjL5LLW/LSETjVzs
        RGSN4QFpyfK1Le5dGKpXYelN6R2cuyc=
X-Google-Smtp-Source: APBJJlHrauGCVrlINhpGcDmzp09heYPiNXagZxSTvSvZvveFxIbf1oHobA+L0v+vSB3K7l2kPHKEOClCwfE=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1611:b0:d0d:587c:e031 with SMTP id
 bw17-20020a056902161100b00d0d587ce031mr15462ybb.9.1690568407149; Fri, 28 Jul
 2023 11:20:07 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:06 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-5-reijiw@google.com>
Subject: [PATCH v2 4/5] KVM: arm64: PMU: Don't advertise the STALL_SLOT event
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM hides the STALL_SLOT event for guests if the
host PMU version is PMUv3p4 or newer, as PMMIR_EL1 is handled
as RAZ for the guests. But, this should be based on the guests'
PMU version (instead of the host PMU version), as an older PMU
that doesn't support PMMIR_EL1 could support the STALL_SLOT
event, according to the Arm ARM. Exposing the STALL_SLOT event
without PMMIR_EL1 won't be very useful anyway though.

Stop advertising the STALL_SLOT event for guests unconditionally,
rather than fixing or keeping the inaccurate checking to
advertise the event for the case, where it is not very useful.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f0cbc9024bb7..68f44f893b44 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -754,8 +754,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
-			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
 
-- 
2.41.0.585.gd2178a4bd4-goog


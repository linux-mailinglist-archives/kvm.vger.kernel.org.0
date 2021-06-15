Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227D03A80EE
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFONm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhFONme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:34 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA7BC061153
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:04 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id y5-20020a37af050000b02903a9c3f8b89fso28026549qke.2
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fFb5EdfjHO+ewt5HOuLeS1mR20gu2Eahh4MlZRHs87o=;
        b=uKaxyGfPO489RueaQxt7plGasBN2wxPBdDP9z18kBH5QsmXdJmOlWt8qsZ7fWyWg4Z
         Tf//G1/iiAP67NdxyLmKercnkJs0TK2St7DeUD7sP4JgqDPllgRUqSfADFSresHo9rjN
         wud6qkKNi/AzL/R29gFpKSs8mr3evLA2jhkf1U0LsfofKWt3WUTM4huvPRZKNg7JMURS
         g8WN+BbSuRdnqmj6vmI3a1aV5p7GQe3ZEnzBxVKUVIgfww3v3tYcGgraZK2GjWfl70hz
         T911O8r8pHnOkWSJPKIr2jDpYRn/XQw/O4TKpQDWBCCdG+uwAiVvLdEMYkWfKaQO5njr
         Am4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fFb5EdfjHO+ewt5HOuLeS1mR20gu2Eahh4MlZRHs87o=;
        b=ImfZXOQJnZSNzSaTz8zJg49r07aiLg2HgT8G4DmFMqHnClryyAulUYdhcUeocUPZjj
         KdBvHimfq/3gnC8rotY5q4jLtyfOe0tVIK/ot1/rHdt4Ev00QQgEslK5POCVM+QsdgSk
         42NP3kSPkX6dZLaI+PfR9KM8Zqe3HlgPK3IHVlDWZXR/d6hSt89z9Q9Q4eJbDLiAlAh4
         EyQKXP4YIQrVPIsA5Gwjk8hKKOKTAq1uqB6Wl1H/S3Ccnrqq/V/GHD89PANN4WKHa9uP
         1x5Y1t8/1Xnrq7kzsbucTH3LhE9pyke+aOWziip2qicd4v/r1Mx4pnHL5KaK3Ted7ZD8
         Fg+Q==
X-Gm-Message-State: AOAM531oSMYpSOl62/YQ1n3qYncwZmuT/DFOeXhef02GF7nB7KwMCAKX
        4SAa/5e85zvIIsalHgDzpfihWoyjUg==
X-Google-Smtp-Source: ABdhPJyIzj64ZU0rwOF1Tns2cDZxg6a1VMvSmsV4v/YREuu/92HJn1cyThLZrrOSb3o9FBNoCaWcDXZWqA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:c6b:: with SMTP id
 t11mr4873488qvj.31.1623764403740; Tue, 15 Jun 2021 06:40:03 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:42 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-6-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On deactivating traps, restore the value of mdcr_el2 from the
vcpu context, rather than directly reading the hardware register.
Currently, the two values are the same, i.e., the hardware
register and the vcpu one. A future patch will be changing the
value of mdcr_el2 on activating traps, and this ensures that its
value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..430b5bae8761 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
-- 
2.32.0.272.g935e593368-goog


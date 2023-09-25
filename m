Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75917ADDDA
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjIYRfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjIYRfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:35:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7198410F
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:34:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c0e161e18fso89426755ad.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695663299; x=1696268099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/SyWpsTveCt8sOgUzwdLFOIMv03DArAYAXRCSsRfzC8=;
        b=fclNOGWqTOH/DVBvx0pK874VLTc62EHr9aEgkwpmpf+gwX+k1Ue8BnCnpnDAzdf519
         7wBCIk5gD/QgQbfdsMyHQG16DvEGagsQjLlIhamu/YelP8dmrUnVDDjn1nQ52poL0uj9
         mxSun8vztCj2KHvlK9+er8EmMqIDmMHlsJEK0p1KpLhi/NUjDqxFPLFIdFVUSDGEXkS2
         yyFuPNtNT+/8Co1juZKqHz3cPNbtm5kgaj5uaKQuh8J5PLjKiAiUorIhsj/Cn5EFf8pG
         tDY6HGInO2Gok+nrILJJFA9mPlGST54/Yr/7Bqb5d/SnwV4A5QbO4I7YarMr4akmob0q
         PAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695663299; x=1696268099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/SyWpsTveCt8sOgUzwdLFOIMv03DArAYAXRCSsRfzC8=;
        b=k9rZyEp/84znOIPIHmAtijDWKpnY69s6moUMSI+iyrDz4pLXJ5nLM3S8RCJU7XFPnm
         7YRkeZQvxNCcjIaBpkmNbp0sJv3P5y26JNxTirnsLsclyHLiaPjdzMWE8DL/USyaxv9a
         vrVOatA6OE2oaisYby6QG4MzjtztJGCdHH7h2xs1RiSz4/5HlpZAYPwhtSDJtM5C+E+4
         UWur+UW9hMak9pClsfWgIWYg8Z/Nlv8Lod7+iFtq8lWZAQiHLzfn+QpdgcjJ7pAONgmd
         2UEm5/AO33avH+luRhP82pQtbegyrnVA28acUtWzydGJQaTJoPQnrwIw5eqGJCZhA1wX
         HFjg==
X-Gm-Message-State: AOJu0YwBNUTRaDbMkKxQdXwY7V8p6W+mhvczojPOB+9wW2cnBCmrWdR5
        RA8OZAuxS5KEN/Di6wR3J+omKx4JolF+
X-Google-Smtp-Source: AGHT+IHHVPx4CEHMOcu9Vydd13YKljJMjj1+Oz4IRzG/afBOf9et7oMDDEm1qZycCqGjcUCSCMt9IBaHj9WE
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:cf52:b0:1c4:5e07:6d87 with SMTP id
 e18-20020a170902cf5200b001c45e076d87mr3367plg.4.1695663298881; Mon, 25 Sep
 2023 10:34:58 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 25 Sep 2023 17:34:47 +0000
In-Reply-To: <20230925173448.3518223-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230925173448.3518223-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925173448.3518223-3-mizhang@google.com>
Subject: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

Per the SDM, "When the local APIC handles a performance-monitoring
counters interrupt, it automatically sets the mask flag in the LVT
performance counter register."

Add this behavior to KVM's local APIC emulation, to reduce the
incidence of "dazed and confused" spurious NMI warnings in Linux
guests (at least, those that use a PMI handler with "late_ack").

Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT source")
Signed-off-by: Jim Mattson <jmattson@google.com>
Tested-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 113ca9661ab2..1f3d56a1f45f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2729,13 +2729,17 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 {
 	u32 reg = kvm_lapic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
+	int r;
 
 	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
-		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
-					NULL);
+
+		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
+		if (r && lvt_type == APIC_LVTPC)
+			kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);
+		return r;
 	}
 	return 0;
 }
-- 
2.42.0.515.g380fc7ccd1-goog


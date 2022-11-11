Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A98962584F
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiKKK1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiKKK1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:19 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56DB64E6;
        Fri, 11 Nov 2022 02:27:18 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o13so4081024pgu.7;
        Fri, 11 Nov 2022 02:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAd+4xMrLdn7uEK5OU9JGHuakvbD4Z5nbQFr3uazpz0=;
        b=fDpKlPQnYum4rSpRNBJ0Rv5Bvhz2rA00jSi1bCfcvR//TNAabls0hd5JiAZFJBi3IW
         jNbSk7k6F6Uq+e4UMsU405CStaqt5NYzjNC4D7p/N94zq7BnOmQtF6ULjrXCvBudpIsD
         peXrXgcKlxQCQmmrl5t8LOFJlZ0vLZOz64NH3bBRsi+0H3k4XX5oKSnb+fSpMoFZd1Oh
         BHLKIX21/Qtauifnl+v6vtNYE3P/mH24DFyiHeEx6EmtElkL9qE1qbD5GmvS1p58+P3I
         VyDdiM5Yrqk5Q61L52sLKEC1y5j6TPTeRibUly+o8g8tci2DSMW8HN+/BADFnLdLLTlr
         GgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAd+4xMrLdn7uEK5OU9JGHuakvbD4Z5nbQFr3uazpz0=;
        b=Alz1olhAyxl1Ei6vkFjAraugbwE5SFEvyuK5smygg472lYytP0efhMI3y4Lw+EwSEr
         Gk+F58c9oHDcNJQ/8SMvy0hvpvC4XaKcRvjoogG0GvZei0cxEzai0HREnzESHS6M7Oki
         u50WDasfVv2fHjNPBcWMkDukUmY3tjO9Zg71VuMDP1UszLk2tcVXHfsWEPArmFVKa7sw
         AMZeXOuoxjUlGT9pwRmnMoOqBEoPf7XZ1Tvwut+dskFDEYP2fMMGcira5dS16sWSHOEH
         eHeMZ12U8ICP47fEPRXNq5evSq7wB/dybAJNaXEXgpcERh9KUEVcd5PoW0j6wBXcfspx
         FPeg==
X-Gm-Message-State: ANoB5pl4KH9l7PBxpDHIIZNEpfuJ1AHCGTT2vD16YK3ykHshwfT8xJVJ
        mvv2ekdCCdjTpQEaxpNwORQ=
X-Google-Smtp-Source: AA0mqf5a4yZhpWZx4cQLkE1r6JMLphPS+YDXlfuj0q5W1lHa9iuPUTkIbk7qNvIZRrjs1vLLtVuJAQ==
X-Received: by 2002:aa7:88d2:0:b0:56b:8181:fe3e with SMTP id k18-20020aa788d2000000b0056b8181fe3emr1955735pff.57.1668162438306;
        Fri, 11 Nov 2022 02:27:18 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:18 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/8] KVM: x86/cpuid: Use fast return for cpuid "0xa" leaf when !enable_pmu
Date:   Fri, 11 Nov 2022 18:26:45 +0800
Message-Id: <20221111102645.82001-9-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
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

Although when !enable_pmu, KVM will have zero-padded kvm_pmu_cap to do
subsequent cpuid leaf assignments, one extra branch instruction saves
a few subsequent zero-assignment instructions, speeding things up a bit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index df551fa66ccc..719290ff6d77 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -922,7 +922,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
+		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
-- 
2.38.1


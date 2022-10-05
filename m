Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA245F5D56
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJEXw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJEXwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFE87D7BB
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 126-20020a630284000000b0043942ef3ac7so130904pgc.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A9k38L9re/AGoeahP+oh+3Rs38LYxET3MNOB8Cd7R58=;
        b=CbeqU6DwEI84lUJZLpbwKgOQMwCtA55MFTLGS/TzYHgWC4U/IFrA9iFwYuu2JQo5bJ
         A9IXE63IrX2Mfz8i663pwOg0Q3dKI2AybfJJmClcDfaqt0+JeTOdQ1L5avvdEloRh0PX
         553Q4RUaPr0Xx7nZnLgRjfiSOP58f9CEDZbQAEtD0jujnL4EUVYkN+oD63m/WmNvrLxe
         mM1pkr7giqwxMd1FAyKL0eL9W9dO40dQAfBLLnZUUge81gjfTJ8rXRaQG+2+B82QwJUz
         4XpZ2NVjHC+UOI1B/FYKDMyxzL1F6HUvTvWzVt2mV2Vfb6uKIu8LaKyMGrhEVvMhpAtp
         t0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9k38L9re/AGoeahP+oh+3Rs38LYxET3MNOB8Cd7R58=;
        b=fy5byoKcxvMhj21olWsxrX3k27LNzbH/M5+plrxoz6QdgOxEIW3X2q89IQxa43Qg4l
         Yrw12yOHomhdwmg7dundQ1U/HQjMXNnKLuL0kuGYozZ6Snz6NoaWcLP2/eIjOxQeVMuw
         36BVvRmIAvI/2ZGthXcHq7uO9wgVC/LYpEPODLiNAzD9u6b0WnmP12Ez0svjeHEqTubl
         SD+sDmf5vk/Tb+NVM1UmnH7pIOK85IoQX1OPkcpoNczhMtpd3AXkVFMR1PiRM44BPIKL
         SoKEnOG6xWO9Q9vnMxw8V0cv0yXtFwGsgbtwXNyaGGHbL+ddE8vPVDjRnPeYmp9pYx4M
         iB0w==
X-Gm-Message-State: ACrzQf0lC3f64pZpcKFRzWxyMF79cRsOZcNUO9laIRmHH3Us937xvkDM
        jwDKOUozXp6ybjZaX2vnR5mpi0S9o6w=
X-Google-Smtp-Source: AMsMyM6elQ2A4+WEx8EPS3OQPfeRyXAYj2m7E/9w5Ias8E5h/aL1ydDpgWpHpehWXadCilGuDWFZG3CLSj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6807:b0:17f:7fa2:be26 with SMTP id
 h7-20020a170902680700b0017f7fa2be26mr1800239plk.34.1665013941203; Wed, 05 Oct
 2022 16:52:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:07 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 4/9] nVMX: Drop one-off INT3=>#BP test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the dedicated INT3=>#BP test, it's a subset of what is covered by
the INT3=>#BP case in the generic exceptions test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index edb8062..368ad43 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2136,31 +2136,6 @@ static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 	return VMX_TEST_VMEXIT;
 }
 
-static int int3_init(struct vmcs *vmcs)
-{
-	vmcs_write(EXC_BITMAP, ~0u);
-	return VMX_TEST_START;
-}
-
-static void int3_guest_main(void)
-{
-	asm volatile ("int3");
-}
-
-static int int3_exit_handler(union exit_reason exit_reason)
-{
-	u32 intr_info = vmcs_read(EXI_INTR_INFO);
-
-	report(exit_reason.basic == VMX_EXC_NMI &&
-	       (intr_info & INTR_INFO_VALID_MASK) &&
-	       (intr_info & INTR_INFO_VECTOR_MASK) == BP_VECTOR &&
-	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
-	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
-	       "L1 intercepts #BP");
-
-	return VMX_TEST_VMEXIT;
-}
-
 static void exit_monitor_from_l2_main(void)
 {
 	printf("Calling exit(0) from l2...\n");
@@ -10795,7 +10770,6 @@ struct vmx_test vmx_tests[] = {
 	{ "vmmcall", vmmcall_init, vmmcall_main, vmmcall_exit_handler, NULL, {0} },
 	{ "disable RDTSCP", disable_rdtscp_init, disable_rdtscp_main,
 		disable_rdtscp_exit_handler, NULL, {0} },
-	{ "int3", int3_init, int3_guest_main, int3_exit_handler, NULL, {0} },
 	{ "exit_monitor_from_l2_test", NULL, exit_monitor_from_l2_main,
 		exit_monitor_from_l2_handler, NULL, {0} },
 	{ "invalid_msr", invalid_msr_init, invalid_msr_main,
-- 
2.38.0.rc1.362.ged0d419d3c-goog


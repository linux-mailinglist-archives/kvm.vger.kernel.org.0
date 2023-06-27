Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF073FB67
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjF0LwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjF0LwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:52:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65059120
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:52:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51d9a925e9aso2637301a12.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866723; x=1690458723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Exw+JZXOL4uO7+3m9iYv0CMoNufl6q663SemmcVGUDs=;
        b=D243fL8YZ2ilzOwTH/R8fl1t9I9RYRViHPE68ZXBeP+S469Nr7nvuq4AqADY5HOsyu
         zq9quS90T8MgbQ7+yyRMLjcPtSE347AwW60WlQ5t5OYGSNaz7KMjHMqpR7rujdO0iMOA
         aryT5Wtx7M4p6y+JSfmdYDUCxAileqJkzUDSh09Pd7zzPJF5NxyXSdYhWqjSx0z7vcH6
         7COGTXxcsk0Z+/cqu6QwPo0GsQRk5kPyiXvWmbRjqTvBaPU8ZKuhCKlUhnOUzOGLhqBL
         sIRRkvo2lkxuucS9iU0L65KEQvNQJP1J0HA58464MLtV2nvdEqSTC3ASlRMC5nMBKKHW
         ZlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866723; x=1690458723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Exw+JZXOL4uO7+3m9iYv0CMoNufl6q663SemmcVGUDs=;
        b=KiSJO1IWN3h1A+KO+nfB0hcivOVeKeZhW8sQn9oHYxO6BFclIDwDjDoh9Tndu6uOYH
         vgtzBaA/1OsDlw3suxM0HXF43NNUlqVEYjlAYD5SZrOtj2sOjsTuV2GMTrenzrh3tIsY
         rRfDw0+KzwVK+3nJYhymMsy8etroLNDUctbHFuzesxmlzRCLVmo4NjRKIxXEpxZbb6jY
         ym7SqYJbTrWiQeQj/hJwlJVRcrusjpZZQAHCXmzFXELKlMl1hZvLsapi9rgOGxxkO8UE
         HseQ3ajXcAgsRVz1BILleEMDVDxj+y2IX8cocI5dJOLUmn9PuvLf0p8NsP3o4ODBT5EH
         ddPA==
X-Gm-Message-State: AC+VfDw+JwG4JYwfaZ6u3UrFq9Wp9OgT5jatewfnZQIaZG25UPaKsheO
        tNtfqe51BWlny0uk+OxxxotOeg==
X-Google-Smtp-Source: ACHHUZ6uCsnqM9P3N/MzuPiI6BmEG2Gg8wTsAU8ZrHvRjeKw1Voa0SIfZlyjcTP+MPN77umcbDZmgA==
X-Received: by 2002:a05:6402:498:b0:519:b784:b157 with SMTP id k24-20020a056402049800b00519b784b157mr20050286edv.12.1687866722978;
        Tue, 27 Jun 2023 04:52:02 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id q14-20020a056402040e00b0051d890b2407sm3384524edv.81.2023.06.27.04.52.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:52:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 6/6] target/ppc: Remove pointless checks of CONFIG_USER_ONLY in 'kvm_ppc.h'
Date:   Tue, 27 Jun 2023 13:51:24 +0200
Message-Id: <20230627115124.19632-7-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 901e188c9a..6a4dd9c560 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -42,7 +42,6 @@ int kvmppc_booke_watchdog_enable(PowerPCCPU *cpu);
 target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
                                      bool radix, bool gtse,
                                      uint64_t proc_tbl);
-#ifndef CONFIG_USER_ONLY
 bool kvmppc_spapr_use_multitce(void);
 int kvmppc_spapr_enable_inkernel_multitce(void);
 void *kvmppc_create_spapr_tce(uint32_t liobn, uint32_t page_shift,
@@ -52,7 +51,6 @@ int kvmppc_remove_spapr_tce(void *table, int pfd, uint32_t window_size);
 int kvmppc_reset_htab(int shift_hint);
 uint64_t kvmppc_vrma_limit(unsigned int hash_shift);
 bool kvmppc_has_cap_spapr_vfio(void);
-#endif /* !CONFIG_USER_ONLY */
 bool kvmppc_has_cap_epr(void);
 int kvmppc_define_rtas_kernel_token(uint32_t token, const char *function);
 int kvmppc_get_htab_fd(bool write, uint64_t index, Error **errp);
@@ -262,7 +260,6 @@ static inline void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset)
 {
 }
 
-#ifndef CONFIG_USER_ONLY
 static inline bool kvmppc_spapr_use_multitce(void)
 {
     return false;
@@ -322,8 +319,6 @@ static inline void kvmppc_write_hpte(hwaddr ptex, uint64_t pte0, uint64_t pte1)
     abort();
 }
 
-#endif /* !CONFIG_USER_ONLY */
-
 static inline bool kvmppc_has_cap_epr(void)
 {
     return false;
-- 
2.38.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7462E601
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiKQUgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiKQUgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:36:18 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7252E657E4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:36:17 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n20so8219516ejh.0
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MmBSzpTQgrhdycBHu+zmSBD54hUCoH6IXmpPlYlFYQg=;
        b=O4RHLJDyx1Syh1iv5MNxTaz1+KPIpBIMMh74nc1xy+iM9LTtkI2rhmPXIzbkk6uKj3
         2y/YU4VEsdCpqlw4ExsUtXlykbWOUZMr4RZpi9ILCa17p0tqYkDsS3vr7KyaL/UXHW5r
         AUJW8/i1zK29qLCndfmymPA0NHTuFT2n8Fq85ZwkQqtw+15kXh1UnXWvgjFBkT/VhFnA
         O+lyPClIl6NiwAp3zSxYgvS3A52gfoWACL9KhvLcfDt38t9PxvQFQEfATOz1ycuyN4md
         DPOGHucwGZL4p95VydWhzKum4xFFieiW++T4e16x/jf3MPs0bWkvbvVk6evuHhpFQqIv
         9SDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmBSzpTQgrhdycBHu+zmSBD54hUCoH6IXmpPlYlFYQg=;
        b=lxZ0AzM0418WwcOjb77VTkPwwJ+JykdWtBv3uRI+F6ar0ymB1AzzLPS1Tu5oh79888
         UIP7/vN5fkqgr+0P50pes5ebiPc0P79fMkCh3TFQ7NTSzA/4om67mrBgQgQxLCJh1Q9S
         K53QPll85+urqXpolHqPklJWLgs27MbgLoOP058vylJNBRXph/SpnCfjIK7wG+cNHjAP
         hz9tjmEcTNzHR2lDP01fBj85b1QPO7xIjGWV/lFHL1sNHodjTQXbV1NNCX5FKEBil8xY
         iZoDOo1YyRchPGqnTl10m4x6zzBxx1ffCmMx484ngkUjlORyyiZUax/F9hBqx8OS73KJ
         8NXg==
X-Gm-Message-State: ANoB5pmnDxQtXlqX80OzM0PsvAPJ92rVOkZcHGZPRjSD0P5YiWv6e8xm
        BnqckVFlZJ7OC1mhYSGZUZvqrrtNDw==
X-Google-Smtp-Source: AA0mqf60Ihpr3mOqz4jL6rtt4ahQ0W3SAp+RGBq4yvJyqO4vTyCkLtHbMHSzrPdOT7maGw4fxVg7vw==
X-Received: by 2002:a17:906:b29a:b0:78d:b695:1d68 with SMTP id q26-20020a170906b29a00b0078db6951d68mr3573158ejz.235.1668717375939;
        Thu, 17 Nov 2022 12:36:15 -0800 (PST)
Received: from p183 ([46.53.253.26])
        by smtp.gmail.com with ESMTPSA id eq5-20020a056402298500b00461cdda400esm963471edb.4.2022.11.17.12.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:36:15 -0800 (PST)
Date:   Thu, 17 Nov 2022 23:36:13 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH] vmx: use mov instead of lea in __vmx_vcpu_run()
Message-ID: <Y3abPTOAxbLOpnVN@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"mov rsi, rsp" is equivalent to "lea rsi, [rsp]" but 1 byte shorter.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kvm/vmx/vmenter.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -72,7 +72,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
-	lea (%_ASM_SP), %_ASM_ARG2
+	mov %_ASM_SP, %_ASM_ARG2
 	call vmx_update_host_rsp
 
 	ALTERNATIVE "jmp .Lspec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL

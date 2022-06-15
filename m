Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8A54D55B
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbiFOXaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345675AbiFOXaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967BC13E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c10-20020a170903234a00b00168b5f7661bso7256115plh.6
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yqjDdVpZoxotKdsEZQIBQxwwihvS4IhvfCEjjfoAySc=;
        b=pd7iaZHlGaWpIMkbHhuEq5ffGgcurkJZrbICg07K7QEnssolOh6aSr7XlWnyh3ceLc
         5eKbHp5YmahKGqqjBCCu+xi4dIlWQfMa/ett3co0AF5gcLLoaqc/ylcB3i00M8XMQFOj
         c0Jwpga9YaDdK1SCRUm8KMS4eaMvaielzg1B9imDoK12J8Iqlitp/o6AJ7nFoTo+0uUZ
         nUoTHvk3XhrPIB1E41I8rzv1NNiRp1KFervLZJc65gt7WrwMZM37UnPUvwSN3UPMIxy2
         3XGrXZbezOuzzOSK7z4kXbV8kkF12ITBlSG/fpaolsgTpJT2kBUgoehm8Zubu8A4xx8L
         7JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yqjDdVpZoxotKdsEZQIBQxwwihvS4IhvfCEjjfoAySc=;
        b=5LwT4u0rkqOANnpQAcu8OlENg8tmWb6wnlRD+Fgrdcp7Lu0ldBu5gyJUO1cgVJtjHP
         Fa3Ftg93GJdtznjqkpluOcM/0th1XYudTPy/BpGlRUt7P4KcDiiIMPvEDxsaXrULCbL8
         t+FYn3/FUzpCjDw71yHBig+7OxyOpnyh0XE8ocu0FL2QT/PV7YGpUIvQDb9433UKrR7N
         xIzo6aHpj0NOe5SlIivuCfPWdebQzJYrx9zx70swgbARqGcLy+ZB76LzkfuM94rvb3hF
         HjyRsOHrcKXXy91T3m28KnU7DDFOglMfXtlWlGpbuZRUMccDpxPMvATP3BxpgIfBuAMo
         NwQw==
X-Gm-Message-State: AJIora9stttTfa56sc7YBPOb66qq5REhqm9J5obrBN+ix5H8X1/4CzNs
        D1YLVr4t6kYsHpUVcCil0cK54OpGM48=
X-Google-Smtp-Source: AGRyM1uRRviul0ZQR8L9ogw+jvMGs//tDBpcqwzcuH6oazAWFwHfkxVvZMWw3KyguUbDCM37vJ2Cjxe5dt8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d11:b0:1e8:436b:a9cc with SMTP id
 mw17-20020a17090b4d1100b001e8436ba9ccmr12927871pjb.40.1655335802126; Wed, 15
 Jun 2022 16:30:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:37 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 07/13] x86: efi: Provide a stack within
 testcase memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
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

From: Varad Gautam <varad.gautam@suse.com>

UEFI test builds currently use the stack pointer configured by the
UEFI implementation.

Reserve stack space in .data for EFI testcases and switch %rsp to
use this memory on early boot. This provides one 4K page per CPU
to store its stack.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/efi/crt0-efi-x86_64.S | 3 +++
 x86/efi/efistart64.S      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
index eaf1656..1708ed5 100644
--- a/x86/efi/crt0-efi-x86_64.S
+++ b/x86/efi/crt0-efi-x86_64.S
@@ -58,6 +58,9 @@ _start:
 	popq %rdi
 	popq %rsi
 
+	/* Switch away from EFI stack. */
+	lea stacktop(%rip), %rsp
+
 	call efi_main
 	addq $8, %rsp
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index b94c5ab..3a4135e 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -4,7 +4,13 @@
 #include "asm-generic/page.h"
 #include "crt0-efi-x86_64.S"
 
+
+/* Reserve stack in .data */
 .data
+.align PAGE_SIZE
+	. = . + PAGE_SIZE * MAX_TEST_CPUS
+.globl stacktop
+stacktop:
 
 .align PAGE_SIZE
 .globl ptl2
-- 
2.36.1.476.g0c4daa206d-goog


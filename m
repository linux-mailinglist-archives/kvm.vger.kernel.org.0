Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F20500ABE
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiDNKJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiDNKJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:09:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FE770924;
        Thu, 14 Apr 2022 03:07:22 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r13so6186001wrr.9;
        Thu, 14 Apr 2022 03:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFoJHVfLIsD3E+on3fTDKrttYh+nASwnL70uWLoYl9Q=;
        b=VscGeHgYpmqeZ24KSQ/hrzLntZvcTorl7hNN8mWj2wVp30uAyGkYNMQKP5pAepk+Un
         fNtFCRZwDfFHcKQwosalJ5McUw/MADo+ebT8PWfvovN8VSCSqBKMSOW1np+kXuePcXna
         49NUH9NxDn2VbsWyBzOycnqrPo2Y0a9zlQiXlFizwLte3fS+claG54t0m4apRKQj0mvU
         HKHvpLFJ9cAUuthpQNFjY5hSHW9txaW25djdd3mMjbfP6uHCzjJBZepwJHkGx8+jCYQK
         tjzhX0TJwAJsW6jKFJDRL96bIHEmFXBsBZYcH0LunRq3Irg9Gh16yKiAEfWVar4GDwun
         AQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFoJHVfLIsD3E+on3fTDKrttYh+nASwnL70uWLoYl9Q=;
        b=EGMFb1g9mPAi0hKxWrNfe7k3nvc8NawQ9JEO9qs59MLKi/POswVGz4FV++YhhPUO4i
         EtPhSmJKUIlpaBAlYcIUuwZQB0MMfcj37IyEh4Kckxe5089tDJYp60fAo+sc3mGiMuAS
         oat2yOsxnTcJyjXtgXqXXhKf712UTaLUFodq7fPW4JgOIwLypNv60sfdKAJa5Jlwt4CX
         aOBriAi7FI8SmJ8+7GGDcT2A8mqzLknCdBh/2x7ZMiwomgObZzD0aHIkfszY/KWIu1Z8
         wv1EvJLOlNsih8FQ0d1hDXcI7grxptEh4unbhEaGxrBCYsMEr02LGWKe7ZL/Yspivk7i
         euyg==
X-Gm-Message-State: AOAM532i3ozPVYiQnzkT4Izl0UnX09GmKxV+QM0tvWr0A6hUebMhP8XZ
        Mls4mRHdo1HfdeaJXi2p3ws=
X-Google-Smtp-Source: ABdhPJyH8xWu3hK9Rp5rWB/cER0XqvTzFgaHtKIxauOasle6toXEo+fVD2SGosOUt/9LjDccndSFHQ==
X-Received: by 2002:a5d:4d02:0:b0:207:a6e8:ef4a with SMTP id z2-20020a5d4d02000000b00207a6e8ef4amr1501714wrt.245.1649930841574;
        Thu, 14 Apr 2022 03:07:21 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c2c4700b0038eb7d8df69sm1580412wmg.11.2022.04.14.03.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 03:07:21 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: make read-only const array vmx_uret_msrs_list static
Date:   Thu, 14 Apr 2022 11:07:20 +0100
Message-Id: <20220414100720.295502-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Don't populate the read-only array vmx_uret_msrs_list on the stack
but instead make it static. Also makes the object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c654c9d76e09..36429e2bb918 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7871,7 +7871,7 @@ static __init void vmx_setup_user_return_msrs(void)
 	 * but is never loaded into hardware.  MSR_CSTAR is also never loaded
 	 * into hardware and is here purely for emulation purposes.
 	 */
-	const u32 vmx_uret_msrs_list[] = {
+	static const u32 vmx_uret_msrs_list[] = {
 	#ifdef CONFIG_X86_64
 		MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 	#endif
-- 
2.35.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EB496828
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiAUXTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiAUXTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:01 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8148C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i16-20020aa78d90000000b004be3e88d746so6787220pfr.13
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Dcu9PfCh7HKxTPntEIuKuLRkOI4ZAJFlfGUmwwwSjU0=;
        b=Gd2Q8Up+IUn2PDgXL+UP9HprfjowQkj1AMzwjA0XrWKggYJb992aE1lxr365ChoX++
         kcXzRWuDigwkRKVQb1hWT9doZCrk5D4vz6OSc+BiypYFq6cnfizuD+x8pMQgmky/bHPa
         a1uAAZiW/OJKNhUoJ9HKS1Cpdb6KJNtYmOZ0CawNShOV+foAmW3HlHnr9gAiCvubrntd
         9gpBHZbkB2P4BbhedzZjY891sSMvFWOJ2XuAIsobb22xqZAik4jwAcQFQ1qNEF62cQt3
         hbOvu10DXRZcmlSS0WE2xhsTuEDpMm0/cjz06jHSH92vd9yprW/2WeW7w72JMLdAj5D8
         s/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Dcu9PfCh7HKxTPntEIuKuLRkOI4ZAJFlfGUmwwwSjU0=;
        b=iPD8DzjuTIePdWrNXZ7QMlT5GElNNMio85785hGiTHpXT1M1CoeMYEZ5xIKlXHsEyr
         L5PxRmsRt0FIy+1kFFCXiizRZKKNAQdFdAcHW2Lk+ogIewLfjDlKE3oIvBxDeCOTUCHK
         eDxi0UXCYumvJKo03BoBuHsfwJ1TbHD2/LdTEHkETBV0pSzoMSJI6fchF1+LZKxsqo6U
         MXSjy/l7mraGwMX+GjzQrCZ9aDe90+Dd+ljl/WttesmPKbirBVoC4BgykxXfZnCH7m6o
         IioSdnopSIc/B8wCXO1C1eFNXWd1vdqpIdgEvBHZhyY2xMViPLUDxH7AVLDfLD6wmtGq
         qUCg==
X-Gm-Message-State: AOAM53203JAWyKbcVx4JQHSbR5aurHgr7sxwIPgljH0UXVnOaS3DPYxq
        H2WEClm8owHc4aQSI9AbbZtQmVwckkw=
X-Google-Smtp-Source: ABdhPJyRRPJ+QxCvzGgdDwj3eVrXK7QEznQAfrp/1XCCzIUOzhzOiYjo2eP640+bxAdwDMRDWM7/kLGQhSc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40b:b0:14a:e2d5:3b1b with SMTP id
 k11-20020a170902c40b00b0014ae2d53b1bmr5678663plk.45.1642807139704; Fri, 21
 Jan 2022 15:18:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:46 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 2/8] x86: nVMX: Load actual GS.base for both
 guest and host
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Load KUT's actual GS.base on VM-Entry and VM-Exit so that the VMX tests
can access per-cpu data.  A future commit will track xAPIC vs. x2APIC ops
on a per-cpu basis.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f4fbb94d..756deb38 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1209,7 +1209,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_BASE_GDTR, gdt_descr.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
-	vmcs_write(HOST_BASE_GS, 0);
+	vmcs_write(HOST_BASE_GS, rdmsr(MSR_GS_BASE));
 
 	/* Set other vmcs area */
 	vmcs_write(PF_ERROR_MASK, 0);
@@ -1261,7 +1261,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_BASE_SS, 0);
 	vmcs_write(GUEST_BASE_DS, 0);
 	vmcs_write(GUEST_BASE_FS, 0);
-	vmcs_write(GUEST_BASE_GS, 0);
+	vmcs_write(GUEST_BASE_GS, rdmsr(MSR_GS_BASE));
 	vmcs_write(GUEST_BASE_TR, get_gdt_entry_base(tss_descr));
 	vmcs_write(GUEST_BASE_LDTR, 0);
 
-- 
2.35.0.rc0.227.g00780c9af4-goog


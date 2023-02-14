Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00231696D36
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 19:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjBNSqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 13:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjBNSq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 13:46:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF8C2FCDE
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4bdeb1bbeafso167372147b3.4
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yFTrZ49NPc/OCN422DTCBQnAUieTNXYf1AUTcxKKvJo=;
        b=HkiNOU0OtF0CfkY42/ahYT9mmm4slpuv+KGwhyzZGBxJ7S+wC9r1M0X7JT9YhltQca
         VKbAk2ZR15AQcB6XBfCFC5nNuXzWQcCApf8nWUiAAuIq1Oym4XMmrfaWRHJljB8ceTkh
         W7ci1QAam82T757rvrhOmt6xe08JQcIQS5lImc48pPMqdSVDQwnZQ4WlxGBZ2BJU5CMP
         Sh2yCuKp9LYj106cTZoHjb6wRLvUHqInuWShbiLlngs+0OVkIwzDTCFW1mw0QMhSYI6o
         IITMqyO6TEyQFx4rLl9qwosAhabd2sb6poZ8UZchfe0jMzMDHNMus26SuAFvmp1IpJNJ
         LhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFTrZ49NPc/OCN422DTCBQnAUieTNXYf1AUTcxKKvJo=;
        b=wTSA+wo4bMuxXOnt9jXpZ+uSEnVGE89DG4qCrGT1c+bVVBMh7/IvPc4X/GIEry4iN6
         gs/tL9TAnojK4k6ofabC4xTKEQGj89YgynH+SbWsA34cOh/7VUM2LnvPqlqUVKRPKXdW
         easeTL3haI17RaeS4/AvKK7/rcAqmAXR+9Qu4332K/lZR/+sBIGyvfG0D2qp0Tpu1+dq
         vjqXwixFFw6gjEtZiwseANRleppnTmAFPo2C9obItZjHa7YfV72nAKvW3GQC3yZkGRp5
         iKl3DAzaExfdZwO0dVt7+l0DMh6sjQM63QDkN+E/pxDGxDD/lcLQHdPQHOoVkugqzxdO
         mL3g==
X-Gm-Message-State: AO0yUKUTSyeAdYVWEbTqiXdRaZcE/1YwWD/Mn1XK4XYRL6kOJylef0F6
        EvFD2Rw0vQr5WTz/Cl9DqrhFrAClK7uj
X-Google-Smtp-Source: AK7set9KuUaNnI3Q0H0pQH8TJTXywQ56ZpibfOMhNc75iu7Y8nfC8wCG/aWVPnx016Mn3unZW4Bcbn+4Mbyx
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6902:110f:b0:8da:f656:8da6 with SMTP
 id o15-20020a056902110f00b008daf6568da6mr30ybu.7.1676400383934; Tue, 14 Feb
 2023 10:46:23 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 14 Feb 2023 18:46:02 +0000
In-Reply-To: <20230214184606.510551-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230214184606.510551-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230214184606.510551-4-mizhang@google.com>
Subject: [PATCH v2 3/7] KVM: selftests: x86: Add check of CR0.TS in the #NM
 handler in amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>
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

Add check of CR0.TS[bit 3] before the check of IA32_XFD_ERR in the #NM
handler in amx_test. This is because XFD may not be the only reason of
the IA32_XFD MSR and the bitmap corresponding to the state components
required by the faulting instruction." (Intel SDM vol 1. Section 13.14)

Add the missing check of CR0.TS.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index aac727ff7cf8..847752998660 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -215,6 +215,7 @@ void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
 	GUEST_SYNC(7);
+	GUEST_ASSERT((get_cr0() & X86_CR0_TS) == 0);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
 	GUEST_SYNC(8);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
-- 
2.39.1.581.gbfd45094c4-goog


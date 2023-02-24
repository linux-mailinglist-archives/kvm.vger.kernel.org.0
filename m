Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4921C6A2455
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBXWhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXWhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:05 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE156F42B
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:04 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a5a0b6e3so12875697b3.10
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fAVyG2WHazY43z49qj9fYBID6cROjq1KBIUlLyemaNE=;
        b=WZgR4mXE0BrXLwYzScTMpcI68LCDELmNUm0RZqeySyrFKaTgc8pIoYDVjA1tMsCczb
         sU/JP46eDTM6iCN0BFIeyZMLSpQJjg2wSe9hCJoj83LnSJELwYCPaT9FX4tWYJg5YnKl
         hFS/16lzPOtvaCshS4BCr6UNnXHftDgAvHBM8gX8kn24kro1oyV4gHbE2w8XGbuI6hv/
         K1tkNJSE3HtpEuQ201qR8kN50k0wb4men5lHF5Nh87SWNynQisuzilxiidbhJ2SeZJQT
         oRHTmTls2oPidpNL0qvzbmWqC1quJVJV5cjgx6md2olyi2hGq8OxrEbvKsLjUkRu+d5F
         Dghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAVyG2WHazY43z49qj9fYBID6cROjq1KBIUlLyemaNE=;
        b=sniZOxmdAG9iULFWTMkyBsttUIgmGMsthNpV8AMy7w7w+vXNErdefbVA4didY9qWMl
         LcyZNEc6p6xDdSw0LPo7kLpoQeiXp9fwwGxOkjfmODTjF3L2mS0uSwPgAXThlbENETxy
         az4P91JBqF1E1GNXBzLkrtZHWCGJGX/IwMK+cFTiVOnQTS1OA+6fUMHsI21LF1BD6mBW
         Miaj5uLTTtyEN7vIKXdh6st3wQ1aPHa9xFCYWDF4cphyGUle9M5sR+CIuyR1+WiP1uvT
         YGDitBQydE/x0+Yp8H9RDBBLClbaLKJUqkeZSuGz6U+KcaEvfyd/wJmTMSE/8884GGo9
         +R1w==
X-Gm-Message-State: AO0yUKWs0s9w4zbM/p1/4OG6Z2V2zh4xvbtHxWd98qqEwYuHNH2pid9s
        WHZzwpXQm4HxIE3lZVjJvJMgD/WdzXbUFLYMSdEWqPPx/4JqDMX9hEGb08ckAexQpJE4VrZs1HS
        MGfq5MnwINfzu/4j+BT0lZVfVGDCMjPuQbZFyy4omSX66WBb+Oo2eYqim9O7UJCY+BYJe
X-Google-Smtp-Source: AK7set/6uT7Zh24+KjEsJLN7KTypnShr9Z0qh+V8rz6MmQoaBSrqEb0zW1O+AlDRlesxbtZxqwg5W3WZrGYROxrg
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a5b:cc:0:b0:966:b0c5:d7c with SMTP id
 d12-20020a5b00cc000000b00966b0c50d7cmr4538548ybp.9.1677278223703; Fri, 24 Feb
 2023 14:37:03 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:01 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-3-aaronlewis@google.com>
Subject: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if they
 are not all set
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

Be a good citizen and don't allow any of the supported MPX xfeatures[1]
to be set if they can't all be set.  That way userspace or a guest
doesn't fail if it attempts to set them in XCR0.

[1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
    CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e1165c196970..b2e7407cd114 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -60,9 +60,22 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	return ret;
 }
 
+static u64 sanitize_xcr0(u64 xcr0)
+{
+	u64 mask;
+
+	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
+	if ((xcr0 & mask) != mask)
+		xcr0 &= ~mask;
+
+	return xcr0;
+}
+
 u64 kvm_permitted_xcr0(void)
 {
-	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+	u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+
+	return sanitize_xcr0(permitted_xcr0);
 }
 
 /*
-- 
2.39.2.637.g21b0678d19-goog


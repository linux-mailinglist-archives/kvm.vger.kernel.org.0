Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE08469E4CC
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 17:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbjBUQhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 11:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbjBUQha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 11:37:30 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC92CFE2
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w130-20020a628288000000b005d1f4325e2aso483331pfd.18
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LHzOHHZRF0Z0PxEe7g90IRKekQBPW5kSPBGZ896mCAw=;
        b=iYq/M/swxMz4Ajz5CWey7J9Cn2hGpOfZNKoeQVqLmLqWDDu83kf7cKxB5F54bE8hgY
         6vq352hL3hkuyr+xvGGBPsMBFVU/kUaywZAPGbjpw45pwBVNsUBhXvaHp3p5ij76cNyt
         rDAfZbAgReB4EQSAA7OwInJ6lY9U5BvKp/01wMwOxtpg44NJRhHT8Xq4rTmDcrsxjTti
         pfGVpDEXEfEJGnxNtzFVmYPT2BiwBWDwDKgsfrnnVyf/fxGl4166/OjhO4zVgoSeAI5l
         SvSQxAOupvX+FgQXWxfzi4j2RPAPPbmJeclJTu28XTV+YePpR+2e/aj+jRqUzJYVs/du
         fzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHzOHHZRF0Z0PxEe7g90IRKekQBPW5kSPBGZ896mCAw=;
        b=qOh+KBHJXZz/c+LzbZ0L7SvVCFvEU7SGMEcumzPt2+iDUhmjcdwo5pLhKluVecPbJi
         rtGs3Mr9a0oZKB4v14E2/tjiYl7pq9OslUvWJqFaVs76rcsl3hDxak3vLh0/aKWEdlDm
         H83GWMBYj0U3z2jTKlRHx9bAsrP1sPJyhNGUlmEW/ckMf70EeY0YyDzZjgSVxR59qYbG
         KDNH1XnbLvXH4+/S7wOKBKpzjrhW/iVSENkysgzV+JaVv6hSamvsPxJuW+tNN+zPZcum
         xOT6fRCGEfDm6H10F4lrsoS+IzdH9WW5K9Fw+ABPf16bWIH8SS3e4xmTeYW0/btn3fHZ
         3w0A==
X-Gm-Message-State: AO0yUKWCLYypollh/PDdXWHSQWJbxCh9LFvqi1vLlL3SVzb8peIbshKv
        Jz0TJNj3Iw+1J4ZLPvmZfv3LVWcC6mhL
X-Google-Smtp-Source: AK7set/FsPqQ8rlzY7E1G6gdIEFDYIPaZx1jD1gvFI1btYAhTJ4yElO3zkb5t9OHD55Nxe6cLFjy5KIM8l9A
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:3344:0:b0:502:e48d:6ea7 with SMTP id
 z65-20020a633344000000b00502e48d6ea7mr9485pgz.10.1676997445850; Tue, 21 Feb
 2023 08:37:25 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 21 Feb 2023 16:36:47 +0000
In-Reply-To: <20230221163655.920289-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221163655.920289-6-mizhang@google.com>
Subject: [PATCH v3 05/13] KVM: selftests: x86: Add check of CR0.TS in the #NM
 handler in amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
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
index ba8c0afdbac8..ac49b14460b6 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -216,6 +216,7 @@ void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
 	GUEST_SYNC(7);
+	GUEST_ASSERT((get_cr0() & X86_CR0_TS) == 0);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
 	GUEST_SYNC(8);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
-- 
2.39.2.637.g21b0678d19-goog


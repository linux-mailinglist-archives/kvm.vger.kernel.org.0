Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C14F6FB423
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbjEHPqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjEHPq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:46:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA6BA267
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:46:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bc22805d3so7287784a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560772; x=1686152772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcGjxFwn5C+DW/CBTpII+bmNf6QTkHSVvjbNFA7/wRQ=;
        b=me38dQUbEuiJ3i7HUhs23JsgD/VxjxUDU2zyDRbm25DkpQQThVNlDl5FREddxzENDf
         nqEzKRFs/Z6n6vG+Pm8dGMMwzz6cQY3raVTarLVRCWqZHgj9AksnO7739BYQr0wO7thX
         mWdTQ+/kwkbAhzagCSqYkkcYSwRSYMVqk4s3wPLlhQKh6+D8Gmm09YG8kJ56eyv/KPP/
         0rjCYNwegv1cAyQyq0EBOBjYUojLI9xlszTG6lQVipWjHMAwUNECiRQpZzjHIxHR4vuU
         XUq5ZTTFEY7D3PiBmmmewrWGfrrqt24duPx/WE5wvfEr50LtVWwMWavylss8lVUDw14K
         Rm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560772; x=1686152772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hcGjxFwn5C+DW/CBTpII+bmNf6QTkHSVvjbNFA7/wRQ=;
        b=dLf30xoU7ar3IzsOZ4P5U7c96pYl493irbLdNMmKERbjmu0Xb7ROYRxk4GUB6CsmdI
         fdDcXMfzizs2cvGA9PPxoiwrpUMStZ3Vy4faHQfREMc83q4kRKW5iDPQKhVGmlBMX9Vb
         Zvf8Sv6IwldHGPLb03xwNNy9uWFxslgssY4r8sI8VgdE+Q4sGlk28rHRPIRJo5fP965p
         MpJZCUmhC5vksbPZwyHnXPEvYPKQ8g1Z4JlKV7nt0n5fHBWrdrAUqla0ZIGZHTZOqxpX
         onhhU23Jh5rxyx40VtahF5QpV0NHbxWFhsR8FF5Z4ufX3QZUkKfcehZJl37dl/cGnYbP
         yRIw==
X-Gm-Message-State: AC+VfDym4g+1/gf6TD0EKciPpw06HyD7HkgvqKuJKt9WwJJP5ZiG1Cfr
        SwuUfP312Vi+thqK6wwszcTlDg==
X-Google-Smtp-Source: ACHHUZ5xlTT5G0Ab2nprbHr3ddC09SS1fs8kIWgpVZjp61JIcjx3+r7scNKxVmHUAlngG3OMCgNMTA==
X-Received: by 2002:a05:6402:104f:b0:50b:c397:bbac with SMTP id e15-20020a056402104f00b0050bc397bbacmr9030003edu.29.1683560771839;
        Mon, 08 May 2023 08:46:11 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id j19-20020aa7ca53000000b0050bc27a4967sm6213551edt.21.2023.05.08.08.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:46:11 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.1 2/5] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Mon,  8 May 2023 17:45:59 +0200
Message-Id: <20230508154602.30008-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154602.30008-1-minipli@grsecurity.net>
References: <20230508154602.30008-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ Upstream commit 01b31714bd90be2784f7145bf93b7f78f3d081e1 ]

There is no need to unload the MMU roots with TDP enabled when only
CR0.WP has changed -- the paging structures are still valid, only the
permission bitmap needs to be updated.

One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
implement kernel W^X.

The optimization brings a huge performance gain for this case as the
following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
grsecurity L1 VM shows (runtime in seconds, lower is better):

                       legacy     TDP    shadow
kvm-x86/next@d8708b     8.43s    9.45s    70.3s
             +patch     5.39s    5.63s    70.2s

For legacy MMU this is ~36% faster, for TDP MMU even ~40% faster. Also
TDP and legacy MMU now both have a similar runtime which vanishes the
need to disable TDP MMU for grsecurity.

Shadow MMU sees no measurable difference and is still slow, as expected.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-3-minipli@grsecurity.net
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab09d292bded..496bb9a58273 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -910,6 +910,18 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
+	/*
+	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
+	 * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata needs
+	 * to be updated, e.g. so that emulating guest translations does the
+	 * right thing, but there's no need to unload the root as CR0.WP
+	 * doesn't affect SPTEs.
+	 */
+	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {
+		kvm_init_mmu(vcpu);
+		return;
+	}
+
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
-- 
2.39.2


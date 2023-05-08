Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCA6FB431
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbjEHPrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbjEHPrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12A049F0
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:20 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50b383222f7so7142709a12.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560839; x=1686152839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvMBpYGUUFbOhtoeU6tZl9mcm8XZOcaQ6enJN2RpEHs=;
        b=ecsq9ypdG7ZRARLjZW8Emx2S8hbt9VVx7CQmTQQ5bVRbcTQ1XQOMmJei2JhIfYngbI
         sdJ/uk2mG9tpr7zXZ88/TwbUM1FuHhh8r9xWA03phExNboobCL46/QEFH76PQlrPtvV4
         mmJDDDpxsfWxgadvfLHS3rHbt5hu8u57XThNC6fWYDaTsyDcWSiubYw/aaLR0ei+eIu/
         T/7OMQ65d0aaxy3TVWLl69GFETfPh+Y/pWyrWUgWLhDWT8i9FoHQCJ36calMSBWzBvtG
         lJYp6h54kd32+XcKED7g/VCJH2hy8Cu3aMVx1eMdEiETmvNerPrnm1qLZcN9bcop0C/a
         8MBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560839; x=1686152839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvMBpYGUUFbOhtoeU6tZl9mcm8XZOcaQ6enJN2RpEHs=;
        b=N9rBVGsCZqkt4H3MVuAHYQZCX/KgP21J+ERxuMKEOg7TyWdjQcFZc5VC37TCha3V77
         msN1wv21j39sBeijAY/kKh4jf9DA4qjC7RltJ1bEzJENK3FDz+gUQCWkaEKQh+slF7a1
         hpmgOGJ5dOV7nDVWwgWDrQvUHA7Lq5M58+0aZCKbmSSPQb7w57SPd7TioBGTcnOvOQ9D
         gbled+6HZTUfGwWekdcX56+FvfKQQqynW0C6mpZM3aS31xduiaGQf777O2ArjR01E3lg
         UUZHXQ7Ejp/0CTpLmKcIc5ogGO0uTzgGgNd2ai6CarW+phujxW5jEeB6f38W2Ckn6B+a
         DONg==
X-Gm-Message-State: AC+VfDwHse14NwSCJdvuspQpt7HhwtFYC0yV45rMExiWqK5bEHvzf6k0
        wpoM5y5C2WkaWlD6b2pI6K8bgA==
X-Google-Smtp-Source: ACHHUZ5/u4SgZ1Df3Vxq+zvKFE+Zqa3Bu3zrMmOOg0tv1QZinxH5syijLyX11+GoDI+9NhhiGWsMtw==
X-Received: by 2002:a17:907:ea6:b0:951:f54c:208b with SMTP id ho38-20020a1709070ea600b00951f54c208bmr9167633ejc.24.1683560839338;
        Mon, 08 May 2023 08:47:19 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:18 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 2/8] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Mon,  8 May 2023 17:47:03 +0200
Message-Id: <20230508154709.30043-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
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
index 018f6a394d44..27900d4017a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -878,6 +878,18 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
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


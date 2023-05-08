Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B676FB414
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbjEHPpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjEHPpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:45:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DAC9003
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:45:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-965e93f915aso667683266b.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560712; x=1686152712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zv5jxo4A4M09xK+CgdnY7TNGrFXWGeW2rvoeJckh5pQ=;
        b=O0OUEazRF08OvMNX4AUXuCLff5KJlzxTgl8NTWFPa/f/5mNevEUlbvovv89G1iChlV
         vczdRlan42b9SoIBSM48ydK91aQaDPzp9JBnykSbaflRDlplXaK8endjzKwRr965kuwI
         z3gGtS11yan8s2spcpqvqwSxv2bxmx2xFxxEYL6J1Lf77FgQbfDQQFRqibtz6PXkKlrw
         /nZdcg1MdkPDYGoS2OOp2IrV6L9wl4fRzUOrL4TRHeYBrEf51y6hAEZ+VKPTFtesyXKk
         itq3gQIIGVwvCFjBTrodlvnQt5E2KBunVXnkhbafzW9mJMQn3pcQyViRUCSFMxnhz/7D
         sETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560712; x=1686152712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zv5jxo4A4M09xK+CgdnY7TNGrFXWGeW2rvoeJckh5pQ=;
        b=Dak6UNwtKCSq/RG+vomSkk6GTZzR1S0uKymteEne62QBQEDhIUvPEPUEfZxjPbwGpz
         JS/eWStdqXSd7l4hcaGiCDheiytoukakN8PNQpWeXOvR/RfJOY83gDULvZ7N2bX1lGDl
         rsrfnBANDG9028XRxja8ngKkEh6fakml7H2ZnQDvUBiWtzOhwK3wurC3QwKcoCePqK61
         Z/QB9531CwXc44rjYw0b+8tIzKF6/pNqFwhw+9oBSHawfnaxEG0dJ9Njg2MGtIpu8Spe
         OLbIWu8SXqKaamHdD+Xrjs3+rj9mJd/HdfL5hOoD3w81dCkseRsetiPAV1SS40UqrD+k
         FZag==
X-Gm-Message-State: AC+VfDx4c9o75Yq9YBopYuYy97vrEssoAiqQMGtz12jIYJHLrGCFn1j/
        hToq7AGs+F6Gd3sE5lT0Mwoou6t8mZ7sscuYG5FSRw==
X-Google-Smtp-Source: ACHHUZ4fDZtM3R1LfVlXHrpCv6tS1WN5fBuNPEcR8H9Es36SKvCWWCHDqKQ+17j4+nQe+D8YWM7KKw==
X-Received: by 2002:a17:907:3e1b:b0:967:3963:dab8 with SMTP id hp27-20020a1709073e1b00b009673963dab8mr2687816ejc.7.1683560712549;
        Mon, 08 May 2023 08:45:12 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b0096621c999c6sm121758ejc.79.2023.05.08.08.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:45:11 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.2 2/5] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Mon,  8 May 2023 17:44:54 +0200
Message-Id: <20230508154457.29956-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154457.29956-1-minipli@grsecurity.net>
References: <20230508154457.29956-1-minipli@grsecurity.net>
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
index 0ec7a0cb5da8..d8d679ee5327 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -904,6 +904,18 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
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


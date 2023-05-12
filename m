Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1EC700910
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbjELNUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbjELNUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:20:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011DA19A3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bc456cc39so14751011a12.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683897640; x=1686489640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNBZZe+hK/JPzfkEifbI0WOzbwUyqQzgKe8Z+nBTG/U=;
        b=N3T2E0clk/GWt9lw7qt3VgAO674vhkBlydpGiqPAVahLG3lfLWzYHcEYZdCFFgrM05
         m4UK97gMqwwhN/+ObCrhEEvtvteqQYHpIg89c+f42c7ZW0W92oX7k4c/M7y/lPh/cw1a
         zbZmmG5yRWlJtGm91aVVQNK0AKutUHWvXFBu3jiLyQSHNFSl4QLiEGsbQHAv/kPxN7to
         KkpkohJgwZWJhBflVIZ8pn3M4k0NxlaVfA/opPIHNVYUdO3ahSFAFUlQeyUFNbwYftdy
         GV6Vc3cms+d57UeXeWMNxSqTDxqIfO87sZJEBk5ZTMtmvjqGN5/E92iX0QAH3rJ8yFaN
         656A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897640; x=1686489640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNBZZe+hK/JPzfkEifbI0WOzbwUyqQzgKe8Z+nBTG/U=;
        b=EpWp6CZjQ37rPwthNNM8PfLRo2FgS6jy96EcapgRBAvwPxA5fXBrM1OaNepLzCdXVB
         022QroE3L7yvnSPZJnSxIgmfUQP2TmprWd5Lk7XUh+8jDgFKztbWqgumBHyKx1lgxqX8
         E1T9pC9mF4bYi1ANE4Fk2uhUqJ/2Hnz2JuchGxuvqHQsZUgXPu1gk1z2ezM9VqLiaTRV
         POmjuA88Ggug/lPnhuRXuZsacAGyJmLt+RX604mWl+D2VdbUeHIonWXSQzZJMdmRYb69
         wvmSI9yPOrM/o86zmdE3aICxnC/EvCvkH1ueJLwj7W6sOaXuSHjlUqzHkTBGiuNvIaCX
         ng4w==
X-Gm-Message-State: AC+VfDyl7RZmhvcQW1SHeyBHrrnGKpaJNBxdmYDuPlSy3lDaxAJ/HAyz
        Srde4xCBtC6zjFNs6+SKusRhjg==
X-Google-Smtp-Source: ACHHUZ4L0+19Klo2sUHt/UWdTBVCXPS1HNY3WJzIoK5W098pPdD3GcXlcFF+LLBnBfdSn45/GiCseQ==
X-Received: by 2002:a17:907:9445:b0:96a:3e7:b588 with SMTP id dl5-20020a170907944500b0096a03e7b588mr10169506ejc.40.1683897640513;
        Fri, 12 May 2023 06:20:40 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af43a100a78da3f586d44204.dip0.t-ipconnect.de. [2003:f6:af43:a100:a78d:a3f5:86d4:4204])
        by smtp.gmail.com with ESMTPSA id w21-20020a170907271500b00969dfd160aesm5077981ejk.109.2023.05.12.06.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:20:40 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.3 2/5] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Fri, 12 May 2023 15:20:21 +0200
Message-Id: <20230512132024.4029-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512132024.4029-1-minipli@grsecurity.net>
References: <20230512132024.4029-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 3d852ce84920..999b2db0737b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -906,6 +906,18 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
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


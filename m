Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E4C6FB45E
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbjEHPvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbjEHPvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:51:03 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2EED04F
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:50:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so49966444a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560990; x=1686152990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4cI1DYhc91LVns7RU9eVWRU/DvYrdEigQV2qupYVtP8=;
        b=Bx/ESbzRF4sQrXMXdtvmC1tALX8Pv07DxHdFOZzm5FpM8khW2G8njJ0MCxfCUWXNZ/
         X6deM8XB2ba7ynQfkhm5AvWXa5gHvm5BP+B5nilAG7msk6ngDLsT0afvWN+dcKJ4NUHB
         AzjtpueMWZjQbUR7TBrNxYtVLbAyfsy/fphBknrXnPXwQ04N5nRnvYAOJ1ufmrSstocc
         srufpxmkSgA9KViWWNukQ3/ThFEy1/UHL7WPDZClOhCLQxsgrfwf1R8qdUoRIwDvIZik
         gB6ZuoHippQlaLb3kBtJq+iOV4shjaGG3a6WqY/wYuYdguKt+eHZeQ1ja5ETYMUzhgxJ
         yGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560990; x=1686152990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4cI1DYhc91LVns7RU9eVWRU/DvYrdEigQV2qupYVtP8=;
        b=cTfUtcDl+7c8NaETJZR4O9f4BVvBVFdpj0wbLwMpNyS6D6pFQtk2V8M/YWgXWuQJuq
         vsr1Y/CtTJTIT6enup2onLe7jQPNmK/Y9XB+Zvh0NrXj5j7QA0PkPTksQ+eJhKh3g8gb
         T04ynxKWmv7DmvPr05C9cDh1RE4dz7ERdhCeD6CPP9SFiH/DchbvjKvs7U1btin2mZxL
         X4LgExfb0XYZd1HAIYc5uOdSUqeI8P3g7oChPP1Anq6ZmPTVh8kDB0NWKZlVGCpawwpx
         XQOYDwE96mxHrkEq1tTYYE4jR6H+ebw18kV/g98cqNK5idbzE1Q8i4tehHbRQC53cTzo
         wP+Q==
X-Gm-Message-State: AC+VfDwAMUITGyBsSMAdX+YOg8+5vZgRzuH0c92ctvLbglcOs5D1TqC2
        hpK8J/7My1ypc4FSOHXtItc1vA==
X-Google-Smtp-Source: ACHHUZ6sDiz99qKJFqH+gwml0GjG5UelofZG/r6CSoOj+7yMmhD/u2RMCajOniCLMwlSLuugYGe9HQ==
X-Received: by 2002:a17:906:db04:b0:960:175a:3af7 with SMTP id xj4-20020a170906db0400b00960175a3af7mr8509407ejb.19.1683560990040;
        Mon, 08 May 2023 08:49:50 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id bu2-20020a170906a14200b0096654fdbe34sm117550ejb.142.2023.05.08.08.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:49:49 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.4 2/3] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Mon,  8 May 2023 17:49:42 +0200
Message-Id: <20230508154943.30113-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154943.30113-1-minipli@grsecurity.net>
References: <20230508154943.30113-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.4.x
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f073c56b9301..2903fd5523bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -799,6 +799,18 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 
+	/*
+	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
+	 * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata needs
+	 * to be updated, e.g. so that emulating guest translations does the
+	 * right thing, but there's no need to unload the root as CR0.WP
+	 * doesn't affect SPTEs.
+	 */
+	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {
+		kvm_init_mmu(vcpu, false);
+		return 0;
+	}
+
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
-- 
2.39.2


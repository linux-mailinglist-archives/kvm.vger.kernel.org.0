Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AFB53DA7B
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244302AbiFEGnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243907AbiFEGnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:00 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFBE29805;
        Sat,  4 Jun 2022 23:42:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x4so1768343pfj.10;
        Sat, 04 Jun 2022 23:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KM1oikz+Ia9mBiSM3+pw9WjtCt1EQ9hMQl48+WeL5cM=;
        b=HX8EfDf5WIq4AlYOacnyiqpv687wfE7clq7qblX2gZCKD/SJjyRVEpsfdmEE5hN/dx
         GRa3nOiWAHG1Qg50NUnkvf+jgvHXyiCvP0j/toJmLOfbbYTw7KMI4aXADgSZZ0EMPGLS
         8K+s0TrmN5QbiuPEMix7EiyfHFT0yCqcfEbup9cp87hzCUUUcSXdDlVyZt1owQIKruug
         sTslzmaP3akqW43NdPrGlxKHheK0Jpmn7Qt4SEPMo+VvW6wqtpgE34ClnOjzCuWYPEyB
         8iXFKONQFTKMCnGoBTScxRc+yLVPgUIY4QTQh0Zyh/rHoKwyyfJnYLS/q5VVJbejr9+E
         KFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KM1oikz+Ia9mBiSM3+pw9WjtCt1EQ9hMQl48+WeL5cM=;
        b=GKT+8sPSbgFk1ZYdLa8mWZmEqvqFzRddqrqKTwDq8CtB68+6k63fwtNuEoOby1dFGa
         Lyfso9Z2tR4uFDTZ621009YaBxMyf9gO6edFVBkUzCeeBWreru9SocP969jvnoSDgpX3
         t/D9a+qKDGWtwWfki2Eq3AM7pxdGQ3WVpOjqAP25JIbJzMaYhA6PYZlqEXTou2TwVZ1k
         buJkRjIPb95fMaJusL+ACq2VQOCULrtnWU3ziImAiYOoWtDy28xdmcWeAiHvlsZbAjek
         +nqHAQP8AnRf2l/mrOz1DbV+0YB0vexrWjWRbDERPnJe58pDKc2ZDoEN++ZFO3vUkpn/
         z/gg==
X-Gm-Message-State: AOAM5318vT9O0Q1R4sJ2D/dbKItX2RytAO+QTCcqp2ffxeVrn/TeTOWp
        JMvYSEMKIsr8zXZzcymRkaEFb0LLXwk=
X-Google-Smtp-Source: ABdhPJxydESjX02nx0dTvWq2uEG82KGX3cWEuD45WHQtRyWrMfukHWuo2zgk70Nmo57dm2nNQYCXVA==
X-Received: by 2002:a05:6a00:2293:b0:51b:f02e:de32 with SMTP id f19-20020a056a00229300b0051bf02ede32mr7524558pfe.17.1654411375583;
        Sat, 04 Jun 2022 23:42:55 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902eb8f00b0015e8d4eb25asm8059385plg.164.2022.06.04.23.42.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:42:55 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 01/12] KVM: X86/MMU: Warn if sp->unsync_children > 0 in link_shadow_page()
Date:   Sun,  5 Jun 2022 14:43:31 +0800
Message-Id: <20220605064342.309219-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The check for sp->unsync_children in link_shadow_page() can be removed
since FNAME(fetch) ensures it is zero.  (@sp is direct when
link_shadow_page() is called from other places, which also means
sp->unsync_children is zero.)

link_shadow_page() is not a fast path, check it and warn instead.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 086f32dffdbe..f61416818116 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2197,7 +2197,13 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	mmu_page_add_parent_pte(vcpu, sp, sptep);
 
-	if (sp->unsync_children || sp->unsync)
+	/*
+	 * Propagate the unsync bit when sp->unsync.
+	 *
+	 * The caller ensures the sp is synced when it has unsync children,
+	 * so sp->unsync_children must be zero.  See FNAME(fetch).
+	 */
+	if (sp->unsync || WARN_ON_ONCE(sp->unsync_children))
 		mark_unsync(sptep);
 }
 
-- 
2.19.1.6.gb485710b


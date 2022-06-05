Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D214753DA75
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350705AbiFEGeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350702AbiFEGd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42F139BA6;
        Sat,  4 Jun 2022 23:33:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so10176705pjf.5;
        Sat, 04 Jun 2022 23:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NUqtccdmHpVOa+ywhrLDU/DEc/VQZ0bOnsbWDSLDOhE=;
        b=SWegMuBHwVm86rAMIdjeOqJQmSxdml17S0fO9qMiE26K9ALz8kNPDUz0JAT0JdA9tM
         lf9Vr9q0qeNGIvOh5U7I1HFsr7A6F7V5QCzMWzzwaf6uYuCpGEtWD4l7jbRAjEuXBLM4
         WiPTxOkWkoI/bf66whbmr0lDQqE7pP3qw9czwuMWWr/blhoSvT57KsQDK7vQISNFvz1z
         AIfjiOQaOFVqo2CaNjbeID5tyr5L4qENYEw1lKrc3gAQ08+RTsCkFFaXHeEKSzutJMri
         Ji5rPZKyWj377D/1UBimDpIZ85LYAm3TK+Y6nWqYTGPWcpSItSzi2Wwn/N7EMN8VjW4k
         s+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NUqtccdmHpVOa+ywhrLDU/DEc/VQZ0bOnsbWDSLDOhE=;
        b=56wEgLngi7aFEWqBeWHqWmq6vY+0c/ey/nv51+GM/Igyw3E2U9bNra1BOZLXySJDwD
         gU6fJ0IhT9ZNWUchP9uM1aKFOiyfjkO/5rtC7mm+3McQUXIkZ3t/z3tSLcW1jUHaVQlN
         i/gbunboUiB41NwOamrYHgc1/MHUDjZEhNEXbOKMv5ODEAARFCdkXkIWU5DDw0MbR52k
         dvxpxXkR7+OYXmhgMfw57WPr/aSSdwlVVF3q9wyA4yJ/AJ/ODUqZwqA7rhrM5G0UuX5A
         aAKL9VusJrJBkxfHOu4diUo4W7fOqvzP6PB2R1sPgmK1eA0T8X9UkbsfgNmR9aUkGynF
         pjCg==
X-Gm-Message-State: AOAM531jVvtuYwv1gimYaYu1dM2QK6DbLFR3H8BsW1BE2erQ8OpTrvHw
        874OMq7wkm7/VQvPwE8zBcV+Z1ihcP0=
X-Google-Smtp-Source: ABdhPJxg9O5VcnLtJYttD3zdKhVKxVGRXqauAI0C8YF/4D5lxoH63YNeChP+lE2eADEHBk/mJ4qAYw==
X-Received: by 2002:a17:902:f605:b0:14d:bd53:e2cd with SMTP id n5-20020a170902f60500b0014dbd53e2cdmr17930942plg.164.1654410830007;
        Sat, 04 Jun 2022 23:33:50 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id s21-20020a635255000000b003db072fd9adsm8113867pgl.74.2022.06.04.23.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:49 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 6/6] KVM: X86/SVM: Use root_level in svm_load_mmu_pgd()
Date:   Sun,  5 Jun 2022 14:34:17 +0800
Message-Id: <20220605063417.308311-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
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

The caller always call it with root_level = vcpu->arch.mmu->root_role.level.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b49337998ec..f45d11739314 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3951,7 +3951,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		hv_track_root_tdp(vcpu, root_hpa);
 
 		cr3 = vcpu->arch.cr3;
-	} else if (vcpu->arch.mmu->root_role.level >= PT64_ROOT_4LEVEL) {
+	} else if (root_level >= PT64_ROOT_4LEVEL) {
 		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
 		/* PCID in the guest should be impossible with a 32-bit MMU. */
-- 
2.19.1.6.gb485710b


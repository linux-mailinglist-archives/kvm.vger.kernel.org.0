Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8BD715550
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjE3GFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjE3GFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:05:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBA1109;
        Mon, 29 May 2023 23:05:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d247a023aso2924109b3a.2;
        Mon, 29 May 2023 23:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426699; x=1688018699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=suUfujzWdFjqH2s+YoUsYzVbyOY1lZZXklDFsgzM+q8=;
        b=LVl9B75ihUJfSeSleTrzsje5FRP5zNMdUotm/gX3MamDHkv4yaWCuiLZxOOj9avasm
         zPD4RY9g5KNzT3kfqdLppfKmw8muOGyQ2aZAytdn+oe6BmrUPW3A5RaxQj391pTOFJ4h
         yxwP0rGKSBWcGWfXzLdR84sucANpMxwKrFfrKNV6PUO18OzYoMq2UE2VQQY6SY3Wz6Dq
         xAoAWp0ARAJu7k/w+ed/jI47icjAQ06RBUJ7iF31lLsKBC+4tzzPUYq7Rd7ruMBOyc61
         N5z2rHx5wdK20EnecxC8cisFACdFpadL7wMB/u1MkMoCN/QK1yMFls9zwLoi3cI6ASYa
         EClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426699; x=1688018699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suUfujzWdFjqH2s+YoUsYzVbyOY1lZZXklDFsgzM+q8=;
        b=gZRvDol3uR65YuMJN3abiBnGjbM5oHEayztLY4XF2gFp0QmF//ymJ6s5iT552jTAgI
         JShbeBgS5ikMka7lEbZipi49ZVDqwgtD0s6H0nlHhk06cs5/h+hIRI3ps8Wj1kvU5R1c
         8P6csR8qx2M5hPFiRfFXWu96V+lZte+6v3P5BSPbO/ljVem+ubJqThouZ0w0dqg3DjMT
         +XGTTUuhzDxloA2ZOOU3JcZ/Vvs7XXcc3YgzLBvSmS1xGfkrh7e1PvPGqwos/6QlcvH9
         PUmnySqraHwV5p4tATyWidZom3dKUVHrWeBEIWeTWUAGCigvE+/4B9fEYodBvL3CCxtG
         qMiA==
X-Gm-Message-State: AC+VfDxMUvc7vk4Jw5uENcVAZGyG+kenbix06NWgDtPakj3ehmq2e+o9
        7aac8UuRIci2AMuEw6604uQ=
X-Google-Smtp-Source: ACHHUZ5MGzKxtvYSlYVjd4gNhfy3M9efxfUCxfIyKUF5qgT9EhwrcnKmlKXDRchGHuJvkvT0uVAgng==
X-Received: by 2002:a05:6a20:914e:b0:10f:500b:18a2 with SMTP id x14-20020a056a20914e00b0010f500b18a2mr1325854pzc.48.1685426699465;
        Mon, 29 May 2023 23:04:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:59 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/10] KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
Date:   Tue, 30 May 2023 14:04:20 +0800
Message-Id: <20230530060423.32361-8-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

A sanity check is added to limit the number of AMD guest counters,
which help avoid a situation if KVM only has access to 4 counters, but
user space sets guest X86_FEATURE_PERFCTR_CORE anyways.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e5c69062a909..c03958063a76 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -170,6 +170,9 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	else
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
+	pmu->nr_arch_gp_counters = min_t(unsigned int, pmu->nr_arch_gp_counters,
+					 kvm_pmu_cap.num_counters_gp);
+
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
-- 
2.40.1


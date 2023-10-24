Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A57D7D43E9
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjJXA0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjJXA0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:26:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F5E110
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:39 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9d4e38f79so28089345ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107199; x=1698711999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eiyrZUCrtXg6DUYczSD0Onn4lO3H8IBkZ8lYsggwbsM=;
        b=prC4RNRG9KDEzUdaKcOxD4bCKkR79gHNgBrWobLc3nJT/IUYiPAZVeEC8/FT1WrAPP
         Ium5Uz5RtJLP39gGZRvTsEm6UxjqbhwYb2NDL8xv646BQ+UpqLRvhJaByh0/FTC/lEY2
         WUv9YX29SF2x1Rpk3nyU08d2NLNkvgKlbCQdG8akyeD7bntsrKCCaU67vt6IAcaB+y8C
         Uks4skqGFCHek1Vgtx4KEBHG83kCe6llbz9PBN/27d//yC975/Uk7G9tNG9o+K4k/ZcE
         uenz3U2F4Y3Yo/sEXn3HQaaluWgRfjki0VBsrCYLVNe23mGjkHpU5xIpr53L8RuAfO2U
         zFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107199; x=1698711999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiyrZUCrtXg6DUYczSD0Onn4lO3H8IBkZ8lYsggwbsM=;
        b=nyRrCZ2I57qXR0uKZ7ZTq3026GfO/YGGL5Ym4z/lgU8WHG0JTbazskCdLQ7JboBapp
         0m/LuDoGJCQWjjyksINdU3aZVghCwlYd2nnsp8GPnVY+A0OX2rpg/ghJqtFTajRUpFvh
         CgOrtOS9/Y7Udyunbi/VbSwGbWbhVeNVvzmcguaqgy48376MN4vBqCnkfbB74WO4baU7
         Qgn5B0ZvAeOInFicL7D8M5tFRqO04GlSqw92sw9hWbzKAJAs1NRXl0ZV4upBbxeIEb90
         a+wxAJ4ARVNT/lzkepYTI7gqlWua6ur/vEIYxnn2W1QJX7hlXPbAFwVadca4cP8WJRc4
         fseg==
X-Gm-Message-State: AOJu0YxASx97GVP3cMoYAMbpJqU0SwUUJ9p8j1zx3tJtDhARQ5xRhEZh
        rdBzj9KXGnFiw9zwPhIO3/ihnDDRoOo=
X-Google-Smtp-Source: AGHT+IHj+FCYxGfNDar24spee5O/pearaB0iU2QWyVFO7sEtB/opWMPS5qVffZgO+HIP0D03p+DS6Qbjq4g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4346:b0:1ca:85ab:1638 with SMTP id
 lo6-20020a170903434600b001ca85ab1638mr189311plb.12.1698107198877; Mon, 23 Oct
 2023 17:26:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:21 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-2-seanjc@google.com>
Subject: [PATCH v5 01/13] KVM: x86/pmu: Don't allow exposing unsupported
 architectural events
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hide architectural events that are unsupported according to guest CPUID
*or* hardware, i.e. don't let userspace advertise and potentially program
unsupported architectural events.

Note, KVM already limits the length of the reverse polarity field, only
the mask itself is missing.

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..1b13a472e3f2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -533,7 +533,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length,
 				      kvm_pmu_cap.events_mask_len);
-	pmu->available_event_types = ~entry->ebx &
+	pmu->available_event_types = ~(entry->ebx | kvm_pmu_cap.events_mask) &
 					((1ull << eax.split.mask_length) - 1);
 
 	if (pmu->version == 1) {
-- 
2.42.0.758.gaed0368e0e-goog


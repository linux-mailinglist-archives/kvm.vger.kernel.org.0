Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4C352FCC6
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355051AbiEUNRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355266AbiEUNRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:17:19 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4E75675B;
        Sat, 21 May 2022 06:16:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so9416875plk.8;
        Sat, 21 May 2022 06:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AOz0mmcwPMc1b3ipLhmnfSVEDUnpfpIWhOsFHZTCejQ=;
        b=MHDMjiHPg9cFx3n8pExhMq7Uf0fuABChD6WsgKEXubgKkZKoeEHOi3u/9q0NRLrf/K
         mkg03PBGQ0ETVn9lO7MCxdEWTDmJTtnhnFJqMuSctSRhRmpaA/4JsDVUYpqdSeo7wzQQ
         MspPCxHCwmaqNacszOJvheKIwKZS8DsHMFUqUXUN6W57qUXf+RWLfyEPJZxzOFOdheFn
         MNkzejHcp7JvbEsoU/EQCARUykfUTbDvr941sBdp3MgbukBaH/hXxVNeh2liqBPT0jpT
         uk6V7fOCBzHpvBA6cOs3tCCCn9s9GNZ8j4o9u7PIJL8bTEezAEc9ABcoQuAtk/qzNrVG
         ITvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AOz0mmcwPMc1b3ipLhmnfSVEDUnpfpIWhOsFHZTCejQ=;
        b=hGEuRfgkkz0wKpb9VLqXIqapT4tjkXbrT3CbKczn3UkdTGCnRph/jwZJNCvbCUspXL
         R9aFXSxYVRHdKnNPYbwrD3LK2vgBLu4JL7DbQ6FcKPVtW9DEkgcnjWb8M1CaFcih0FHW
         psHBaVAIyBasvoOaw0F1d6kak8i2cpPoWEChJc/6mtMZAhmBcIYPwUOA/I1u/sORsmU9
         h4x2+uxt/PwGWojRjNAdQ7Vb6xg8rmLwUIlbFFdZrC8gryem7wsg6wyXYBfCjcn7fBF3
         Ta9kc93ykCWzOoPo6cvjxSh9Qkvip3/1oc6QRWEosFkkusWRLQiwZ7Gthe/KkfoXgzT/
         9h5w==
X-Gm-Message-State: AOAM532ul1+KyhKgzNJ/XrdyteMsuGSlSymOS8VRgQwNCyB7igpFU22+
        AiZBkeNWoHMK5BqLbYgVjvIeYkm439g=
X-Google-Smtp-Source: ABdhPJxviNdrc+pHZNkMhsNRanRHsHb1czV3atCcpVsj0z4FUpOoU2EiU2dqP8Dbop5wO6rA7/GzDw==
X-Received: by 2002:a17:90b:48d1:b0:1df:4fc8:c2d7 with SMTP id li17-20020a17090b48d100b001df4fc8c2d7mr16259585pjb.45.1653139001990;
        Sat, 21 May 2022 06:16:41 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id o24-20020aa79798000000b0050dc76281b9sm3730168pfp.147.2022.05.21.06.16.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:41 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 10/12] KVM: X86/MMU: Remove unused INVALID_PAE_ROOT and IS_VALID_PAE_ROOT
Date:   Sat, 21 May 2022 21:16:58 +0800
Message-Id: <20220521131700.3661-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
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

They are unused and replaced with 0ull like other zero sptes and
is_shadow_present_pte().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bd2a26897b97..4feb1ac2742c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,16 +20,6 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
-/*
- * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
- * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
- * PDPTR is !PRESENT, its corresponding PAE root cannot be set to INVALID_PAGE,
- * as the CPU would treat that as PRESENT PDPTR with reserved bits set.  Use
- * '0' instead of INVALID_PAGE to indicate an invalid PAE root.
- */
-#define INVALID_PAE_ROOT	0
-#define IS_VALID_PAE_ROOT(x)	(!!(x))
-
 typedef u64 __rcu *tdp_ptep_t;
 
 struct kvm_mmu_page {
-- 
2.19.1.6.gb485710b


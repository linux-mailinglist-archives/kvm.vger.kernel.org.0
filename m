Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7A9603528
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJRVqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiJRVq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE3ABA90F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h4-20020a5b02c4000000b006bc192d672bso14629955ybp.22
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e6vUZSm5Ysu3Ie0FZjoZ4ACjFfUmR0ukkZmmaTBIo2Y=;
        b=FF4z/R1ug4N+Ef+I+42aX96gdx/j+18q56mhQMwl6CNxqfgmUDOJ+bu9cE84BODxo/
         cbyQg2UxAvdaeWRwU2OM6tFrQynwgLHGoyHqrdotP2kKIb/6Jzz87kTDb262tmRn+baN
         fjnZaXGfljR4GRSgUB6wfEcBjcy0lzK3lxasgQ5B18cbrx3cnUD4ghUf6EdLvJYpt2Fj
         MMa8k9lBz1Ou04zi2hBSoI+15jadQpPxEs8x8rbLQbXMhw9LF+q75rBXb68RzQDKQOrU
         5aMe04SdEFlm/MF7NyjNE/OucwvZIU08CrbaKSY4DbgEu+4QlhIfTu5xedRuBLxRDOWG
         Vd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6vUZSm5Ysu3Ie0FZjoZ4ACjFfUmR0ukkZmmaTBIo2Y=;
        b=dt6MsnWVu2FCPS3X/iG8w9LPYTHSDAFe2QOEcdZNQxG79oY1rzh28s3S+hkSiWP7sz
         nh49mOVO+/rAhGQTTPguPYv9I5hsaKNXgIRdonx5uG9bmwOo8tRtVma+iyMGZCoADQA7
         35jXyA4P+VZURtgpYoMGByrDEqbFn8odyMz3tfpyZZWT9NO04UXHJZXBJ81p2uLwKd67
         vrZAB86W6EpHmxieKJnK9xup/e4NJNENzBO7ompAQroXhVbFospX+115HCO+sTGvd5E3
         ZU42Lg5JfBKYIixE/teAUEzD9LKihlpdxw5DxbPi4pR5SmFmUATv8nEqmSXcAtBJ5iF0
         ZvMA==
X-Gm-Message-State: ACrzQf2GurBs/Rfl2FRRkBJ3jOQjvn4bP6ROdo30IAy9B86y4HZLRP7T
        nV+mIC5Gdzh26vwCW1gCvNsi40/QVBOLQA==
X-Google-Smtp-Source: AMsMyM5APhfCJoyAC4iQcOZNhKzzqWq8GTx+OV8PNsoqML4Zy7JCeL9FSIAIm3rHF4dcXljJoZMxPVkLne22zw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:264a:0:b0:6c0:3e00:f5b0 with SMTP id
 m71-20020a25264a000000b006c03e00f5b0mr4271819ybm.305.1666129585771; Tue, 18
 Oct 2022 14:46:25 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:10 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-7-dmatlack@google.com>
Subject: [PATCH v2 6/8] KVM: selftests: Copy KVM PFERR masks into selftests
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copy KVM's macros for pafe fault error masks into processor.h so they
can be used in selftests.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6762bc315464..c3ae21237af3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -891,4 +891,26 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define GET_REG(insn_byte) (((insn_byte) & 0x38) >> 3)
 #define GET_MOD(insn_byte) (((insn_byte) & 0xc) >> 6)
 
+#define PFERR_PRESENT_BIT 0
+#define PFERR_WRITE_BIT 1
+#define PFERR_USER_BIT 2
+#define PFERR_RSVD_BIT 3
+#define PFERR_FETCH_BIT 4
+#define PFERR_PK_BIT 5
+#define PFERR_SGX_BIT 15
+#define PFERR_GUEST_FINAL_BIT 32
+#define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_IMPLICIT_ACCESS_BIT 48
+
+#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
+#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
+#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
+#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
+#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
+#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
+#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.38.0.413.g74048e4d9e-goog


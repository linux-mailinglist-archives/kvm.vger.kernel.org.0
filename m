Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E75603522
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJRVqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJRVqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:25 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C35EB56D6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso10409162plg.7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ki8KREEmOD9pYn9HlzodteOUGs4bQu9Nhvxnlmmz8V4=;
        b=r92V8W3d9Y9PKpjxnUbnpmJiFvDPElXPqXHXHGAMAuSMYp6MYg2snohMBrGHnumLvd
         0APcQWyuoEpss3BLYH9q8SyJZsuInDgiIa/tq7hWuYnqtDnz4xC8jChZDzhXy9xU/txD
         xOrKTmfA47Y7RybneY08MP5e+gbar5lEHd3lnhuONMfub0jFvpAJ868JdsrwHpre7SmD
         IavpQmVPY8HsWMZXjaMaW5tz9wVHNDpRn+ZZ2uKkpljrnHX1JS+LvbzQcE4m1VQNlhki
         2vkP9kcKpJS0SX6849qwgFEX8dDPSsUOt8lSwM4n8mER7EVKbGg0dJUjFvvg64YD/tv/
         bEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ki8KREEmOD9pYn9HlzodteOUGs4bQu9Nhvxnlmmz8V4=;
        b=3IBkEcDbkV2CRxxyUTVxH6nQnappcOD1B0zBUzWpNTRvIhTS6mrK9nepXCJjPfQaA9
         7q5hRaclMpMzKPiLC5U0NxGPnaOPKmgGynyIYcJIvjSdyr2vpdKZvW14mnNTBa+dDdd5
         20n3VqNN52t4Gp0c4T7lmm64JjaSVcD3vvkp7/F1s+rRaXyHBNam+EerUTgz9b02XW9r
         iaWmcyCQBygy1mCRXr4fRLa9hD7OGlfhtN+fPH8EwGjinriPL9YIJc1Wqc3NapwsQ+Zp
         hItO6257H9ilGuP5rF5caaAD0hcGy4MfnN6y5L+0Vx4SINNK1mDu0qewdfOGqF3T/rjL
         pOIw==
X-Gm-Message-State: ACrzQf08OdMa7l/AsImHOejV7Ftptm2WHfbfnttEV07vceATgmiQEjXk
        N+3nplMzkWPI2uWbZS3QHEserCY2QMBU+w==
X-Google-Smtp-Source: AMsMyM7iSm9LKqIFtTcsQznRC674C05cbHdZgVWIP+UTTgsRQi4ZGIgbDC3IOyqmHNxq+0UPHyWuHSdcvHpalw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1d4d:b0:20a:794a:f6e7 with SMTP
 id ok13-20020a17090b1d4d00b0020a794af6e7mr41878821pjb.151.1666129583995; Tue,
 18 Oct 2022 14:46:23 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:09 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-6-dmatlack@google.com>
Subject: [PATCH v2 5/8] KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
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
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the preferred BIT() and BIT_ULL() to construct the PFERR masks
rather than open-coding the bit shifting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa381ab69a19..1d7605b079bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -253,16 +253,16 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
-#define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
-#define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
-#define PFERR_USER_MASK (1U << PFERR_USER_BIT)
-#define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
-#define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
-#define PFERR_PK_MASK (1U << PFERR_PK_BIT)
-#define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
-#define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
-#define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
-#define PFERR_IMPLICIT_ACCESS (1ULL << PFERR_IMPLICIT_ACCESS_BIT)
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
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.38.0.413.g74048e4d9e-goog


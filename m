Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12FC71625C
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjE3NnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjE3NnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761CBC5;
        Tue, 30 May 2023 06:43:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-2568befcf1dso1350657a91.0;
        Tue, 30 May 2023 06:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454192; x=1688046192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8c2s74iUUNGsc6Dh5neSW8P+hakCPPk2A4/G5EB25KA=;
        b=ke6Q55LNayLybxR1pAMty+aco8rE2z8ews3orYt3ma9/KKc093da/DVvYg7EO8mOuO
         gXycVadIp2YVfrTTnp5w5LWXbwq4gJNlpLWSZKp1iPzFvqQTRezG8gQbvQ1Bp/3eIr+S
         tVS9a0ZyDPmB6hWOfe+Rqv6/WjNX8ZUd7dT3BYQ9Q08hctoR13ucIiDpLxurFI6ghRk3
         OQaaK6zJMSxdfcHbq0JAPkIRQhj5b6QeOgE6zi1MaxxAralxSdrVATGuI8TIvguzAw38
         OWRVZNxZo4ZaGP/05APH1ja0vWOdLXoj8Lz4G3GlCKG0/tZWEBzDqJ7dIIvCZgo4b6Zx
         xTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454192; x=1688046192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8c2s74iUUNGsc6Dh5neSW8P+hakCPPk2A4/G5EB25KA=;
        b=WVwrSbPaYF5x3q66uVdT/5EyqFKVvMDjnzB2rSAa+UBz1M+urBuHIBhoyZ2sDJn1iv
         mvWMr73+rML/6TQy0Fr5gzKTREKyPNGdn7G8CEXtUcz9NxMfdaW/yHMn/ErjzL2DHYzv
         2nnIDJfi2BtCUaC2yZK0OD21FLuK2FHAtXkXomeKtF5UeRWyjPUywJov4YuqMLe13Ukf
         K3hG6aRIDjUmd4jvM4Cqdrz8yR2Uwe95zqrl9O1VC+4MKw6MZtzHP1x8WT3nIzlOKPFR
         tdy1po3TaphV0WrfK6eb0FwIZ8xYJyaMfqgb66E0TfHsDT6ZPA3JVCO9MeRBNveRrHF5
         VsWQ==
X-Gm-Message-State: AC+VfDw3nTqE6oYbeMb4Y3H+xObiO9wmcTHRa96UkF9ETy7wedeVTYr1
        n99iECxdo0yJF1Cg9xsU8G4=
X-Google-Smtp-Source: ACHHUZ6121LHR8/P8mpA92BlEdnAS9JsslBBP9p/Sa1edN7FHKCdm+Ym8VcqeyGRMYP8ytN3WAZE/Q==
X-Received: by 2002:a17:90a:9206:b0:253:4f8f:52fb with SMTP id m6-20020a17090a920600b002534f8f52fbmr11786296pjo.10.1685454191900;
        Tue, 30 May 2023 06:43:11 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:11 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] KVM: selftests: KVM: selftests: Add macros for fixed counters in processor.h
Date:   Tue, 30 May 2023 21:42:41 +0800
Message-Id: <20230530134248.23998-2-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Add macro in processor.h, providing a efficient way to obtain
the number of fixed counters and fixed counters bit mask. The
addition of these macro will simplify the handling of fixed
performance counters, while keeping the code maintainable and
clean.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index aa434c8f19c5..94751bddf1d9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -240,6 +240,8 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_PMU_VERSION		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 0, 7)
 #define X86_PROPERTY_PMU_NR_GP_COUNTERS		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
 #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
+#define X86_PROPERTY_PMU_FIXED_CTRS_BITMASK	KVM_X86_CPU_PROPERTY(0xa, 0, ECX, 0, 31)
+#define X86_PROPERTY_PMU_NR_FIXED_COUNTERS	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 0, 4)
 
 #define X86_PROPERTY_SUPPORTED_XCR0_LO		KVM_X86_CPU_PROPERTY(0xd,  0, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0	KVM_X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
-- 
2.31.1


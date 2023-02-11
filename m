Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26971692C1E
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 01:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBKAfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 19:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBKAfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 19:35:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F33D4FCCB
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v63-20020a254842000000b008f257b16d71so2781236yba.15
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X6TgvLo7n+Bb8KOSP/vZmJv1xhcZgtbvfH2zPkbhDXU=;
        b=jn4wb5K92haDB2Lj78Wxpit5Kn13Amv7hqgu5Z2DvDo26lAZF2p3XGmY/wYuTeoFny
         d4sKUAkZ76iMkHhL8um+uZdrGwkxy2/6xmQupKDpWNSYWh3vVWY1M+VRkzLveHT+ArJA
         ENzm9D3vCo0Na3tgubLuPnThaJxKuMG0gGUA5ZikpmDYFjEX35/kdPnZM3Xjl3Mf66Qg
         hPt+8lTxiM5phAMzldnLr9a+dzJXj4yJDcsa7Igc3Ca/7EwAy2xFUXiFFYELoP5Psh2x
         xGeA07ctNOu1pLFYdedYH7+X1wHZvdODkJX8rzMsc0ld3wFAIUzDhdQI5SYwBbtnHpjV
         DZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6TgvLo7n+Bb8KOSP/vZmJv1xhcZgtbvfH2zPkbhDXU=;
        b=UMFrGm2xPM6AY6wXdpuAbqYYPjHx8JrGjxjtPnttOxEhY79ni8+ymMLb7nekC6W61A
         g0n77YVlgDTcLzikL/DQv2xF8mEZF4YA5faq/j/W8EakrAm7m+VKmRueXz5OcB2/FbUM
         +XWuEbSS7tQhDN51yGw2sB+d+S1D51WWsDh3XMvi4wPJ6DW5QHhRsipOiQWSYX36Bp7w
         ONoEBMagvdmv+4qegUaE0wHOdj7WGmUqJ11QWl7CsvIT07SWgvmfWnF1JBp9O0GLtf0a
         QZcY+aGYWJHIb+ocZh7fJOR+ESGAp75odZKdHArgFi19zK+RTcdfsy9NW3OkbaL9bzC7
         bxfA==
X-Gm-Message-State: AO0yUKXG+At3sg6k3y5dqSahQfy92I8lkIVZAHkmJgNY4UXI/8XbBGxt
        R308DTXtxxTSiqYuK02C84DgHUIi6po=
X-Google-Smtp-Source: AK7set9shJ9bmilQI6tP7xB2aAs9sJO0+YzRFDZJex/b2A70BIlK/P1roI4ftkMvW1ziFsCEDrGkTbI79Cs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d709:0:b0:52e:b17f:dd4f with SMTP id
 z9-20020a0dd709000000b0052eb17fdd4fmr820865ywd.63.1676075742388; Fri, 10 Feb
 2023 16:35:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Feb 2023 00:35:34 +0000
In-Reply-To: <20230211003534.564198-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230211003534.564198-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211003534.564198-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: VMX: Rename "KVM is using eVMCS" static key to
 match its wrapper
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Rename enable_evmcs to __kvm_is_using_evmcs to match its wrapper, and to
avoid confusion with enabling eVMCS for nested virtualization, i.e. have
"enable eVMCS" be reserved for "enable eVMCS support for L1".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/hyperv.c | 2 +-
 arch/x86/kvm/vmx/hyperv.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 274fbd38c64e..79450e1ed7cf 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -609,7 +609,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 }
 
 #if IS_ENABLED(CONFIG_HYPERV)
-DEFINE_STATIC_KEY_FALSE(enable_evmcs);
+DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
 
 /*
  * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index a54a2fdf0a5b..9623fe1651c4 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -67,11 +67,11 @@ static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
 
 #if IS_ENABLED(CONFIG_HYPERV)
 
-DECLARE_STATIC_KEY_FALSE(enable_evmcs);
+DECLARE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
 
 static __always_inline bool kvm_is_using_evmcs(void)
 {
-	return static_branch_unlikely(&enable_evmcs);
+	return static_branch_unlikely(&__kvm_is_using_evmcs);
 }
 
 static __always_inline int get_evmcs_offset(unsigned long field,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d80cbe01b5d7..651037b06eb2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -579,7 +579,7 @@ static __init void hv_init_evmcs(void)
 
 		if (enlightened_vmcs) {
 			pr_info("Using Hyper-V Enlightened VMCS\n");
-			static_branch_enable(&enable_evmcs);
+			static_branch_enable(&__kvm_is_using_evmcs);
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-- 
2.39.1.581.gbfd45094c4-goog


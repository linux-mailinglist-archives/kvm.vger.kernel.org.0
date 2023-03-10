Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB16B530D
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjCJVoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjCJVn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:28 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E172F1C7E5
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:59 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u14-20020a170902e5ce00b0019e3ce940b7so3475522plf.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UHhz2SM3hbXDmjQ5GG0MGaymCbgCzXDenHPbdfsOnbY=;
        b=NWakKGjFu0EWsnYX1psS20AQF/gXe7rJoA2vL0aZFBZE8kyu4Pfz2kqG7+uwqbRd7v
         /sLXLqryy7U3CpVacKtj7cOrZ3t17rkW2kmB4gA0Q0NRAM1sLwMe6oZIq70lIk/5IlId
         lBJUMAiteSgScEUAdSK8tGIlFi1H+uYck9Lmlry6TWsBq1++7a4S2ruZ60UE/wmb/SPJ
         jVTBf3Hbh3AH6BBNsA4U+S2kjWfNHtWMcK9XB6gFeBeRVG3kN8qX12S2vg6wGRiNJeED
         GM9LohJe3fa8cqPIX95tWRWXhpFYBUdRKHUiAIrqnLFcFbD3MT0758sbdAOYDa4LBoYs
         m2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UHhz2SM3hbXDmjQ5GG0MGaymCbgCzXDenHPbdfsOnbY=;
        b=ao3qU6jU7PHZFLJ+LPAi30T9MReKT70HgGYN02LrLQCqHk1LlebxdYfr7+8wGA1Toq
         VLjY05mSZdBBA/2j/9O/tea3HyzY4e5/5jpHep1T5R7PdMcMnVhz0NCC/YCyoYgQrk1U
         pWme6gCWRCEHia37XzXYsW+TxtJQ4Nqc9tE1Ie/2HJ8GM2hCKkGKhCClCYi23zQbqZ3P
         cEVklY0RXba80H/jUa8Pxv52lb55QL2Ixy043+7748lvWiL8eDSRzT92WxKOpgVmNhJO
         UOQ0+78b5GdnpAtT+GXQ4i69YjqAeKwWsqRcH3mxEp8RP4OYgoEkACJrpdHU50+y6/zs
         I96A==
X-Gm-Message-State: AO0yUKXIkWP9iMZzOlWN6iW6ppOT2WfFSa4JkvAgOdsA044KMsVIQ+zB
        wR4NDg0C24YQO2/QEBpaftfAYMNHAe4=
X-Google-Smtp-Source: AK7set9oP0fNLPvfFdlaNaH0cdl0ArMLceObGYfUDJeVFyT8/bj6tnrBnImT2Ih1Ffy1Bp3zsCr1xuh1n2k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7bc6:b0:22c:2048:794e with SMTP id
 d6-20020a17090a7bc600b0022c2048794emr9891329pjl.7.1678484578692; Fri, 10 Mar
 2023 13:42:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:25 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-12-seanjc@google.com>
Subject: [PATCH v2 11/18] KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Make building KVM SVM support depend on support for AMD or Hygon.  KVM
already effectively restricts SVM support to AMD and Hygon by virtue of
the vendor string checks in cpu_has_svm(), and KVM VMX supports depends
on one of its three known vendors (Intel, Centaur, or Zhaoxin).

Add the CPU_SUP_HYGON clause even though CPU_SUP_HYGON selects CPU_SUP_AMD
to document that KVM SVM support isn't just for AMD CPUs, and to prevent
breakage should Hygon support ever become a standalone thing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8e578311ca9d..0d403e9b6a47 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -102,7 +102,7 @@ config X86_SGX_KVM
 
 config KVM_AMD
 	tristate "KVM for AMD processors support"
-	depends on KVM
+	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
 	help
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
-- 
2.40.0.rc1.284.g88254d51c5-goog


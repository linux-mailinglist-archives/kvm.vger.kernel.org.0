Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE74C0AE1
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiBWETe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiBWETd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:33 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C7C3B2BE
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:07 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d61b4ef6cdso161201307b3.11
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EnWXwLktezdYxVf4VXehGQaziGIoOwllvHGoxXaFkSk=;
        b=NEjgsqtOFotB8rwtwgxw3nTKJIjcy3ygfSUnOerwYC8jtMBPV+WVzZP7gk6Sw+8rAQ
         slf46M+kM70WVhS9OC1Dftw3Fd9xageH2ezIhLlTlAULl2ZNqEtjXEmfHcoJ1z3leWRL
         Y2Q1TcuhaUfhM2y4Zu233zlNlZGcXS3xiPunbw9VaVelj8gALfVkGtKFjWS3HblWVNcC
         NT9R6s5QfOf9QdyEMQqnPnfyVE5Wy62eKrQt/uytmG3x55QlnmP9RAbpQYjYLerhDRcE
         OfRn3H4RXHIkN70lq1/ZumftMAc3OSme/5IwSAT1z1FCoR/lHXYabE0J7Det7jXyh8pM
         WGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EnWXwLktezdYxVf4VXehGQaziGIoOwllvHGoxXaFkSk=;
        b=PtnPnG8veOGlCx8Z0MVSHOktG9ZQftq5+W83/f7LPQeyZyEpV+I2PzcieRCt9YByvs
         cC6l38kR2yDNaq/YXFpFMCvN+acPPddhWzPvZuclsqj+vr9uIyHgnPKZjugFM/jMjplt
         XIhNVlj1aYvUtHH2pw+VxoamHWfWJwd/CIoxA0mMGb8rjIP2gzyF+gt6tgy79ZtwKVVM
         563iU/LcdFxc1OWPLYaFM0mNhPjznXepRJmFs422AqgLv3bm26Kc7p+8/3SKc8XiIdFA
         FpCDY6rP12JGJmROEER/YI0X0NWNSzpp+JyHO+3DONPxLm6cOUEMNAR2Sjvu4jTYBhOi
         0ntA==
X-Gm-Message-State: AOAM530gDq7wRplLUQf43Jr3PQcM2bWj2cWszRE7HIA9NnW5NoMA5pZp
        saxl8QhBJqDBMqePhEgaTvqa6Egodf0=
X-Google-Smtp-Source: ABdhPJyjm1Ng5s7CW1KhrIyzYIpmZbuuYhZ/Y0UPWEqvGtpWPaulnfintVKcauly/pEhuTNpasU+6iJod1Q=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8b0a:0:b0:61a:4aab:3e78 with SMTP id
 i10-20020a258b0a000000b0061a4aab3e78mr26177594ybl.619.1645589946470; Tue, 22
 Feb 2022 20:19:06 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:27 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-3-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 02/19] KVM: arm64: Create a helper to check if IPA is valid
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a helper that tests if a given IPA fits within the guest's
address space.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h      | 9 +++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 81839e9a8a24..78e8be7ea627 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -111,6 +111,7 @@ alternative_cb_end
 #else
 
 #include <linux/pgtable.h>
+#include <linux/kvm_host.h>
 #include <asm/pgalloc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
@@ -147,6 +148,14 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
 
+/*
+ * Returns true if the provided IPA exists within the VM's IPA space.
+ */
+static inline bool kvm_ipa_valid(struct kvm *kvm, phys_addr_t guest_ipa)
+{
+	return !(guest_ipa & ~kvm_phys_mask(kvm));
+}
+
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c6d52a1fd9c8..e3853a75cb00 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -27,7 +27,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 	if (addr + size < addr)
 		return -EINVAL;
 
-	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
+	if (!kvm_ipa_valid(kvm, addr) || addr + size > kvm_phys_size(kvm))
 		return -E2BIG;
 
 	return 0;
-- 
2.35.1.473.g83b2b277ed-goog


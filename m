Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA0D660B4F
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbjAGBKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbjAGBKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:10:38 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE855848D0
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:10:35 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h2-20020a170902f54200b0018e56572a4eso2220035plf.9
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ytl00DlerGscM1Z2s2nAhDtn5opR5GZn7robSFrZWZY=;
        b=MfxUKpWUJ1zSJQHSCeUHIcVc8OawjLuZjKMS1fzXz+zYl32lKol+qKMauguiR5vYqV
         cHCSulvbxQhF8LgBzOWfgUBdV4zhhP6CWfEUnCQrWOT5RdvEap0UkoClBPPocPiFBoUl
         L4F+KvkbcGk/adXM0WZTWqXuXJbGB90vh9gNpB9i3fVF5CwsgoFZQWg1jzTI1yVan/rj
         8kNYdDdaiBTVKubzEv6eexqqceQRZHZy0Pfj7ibPF8TM8fZeesp4Bs2qtTycaPeG/bSZ
         hrLWtIOC1n4oZ2TIq0+19Fba5y+230omi0hagx+ythej4bk2tfzK7H5XpVUUXDe7zkUE
         r+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytl00DlerGscM1Z2s2nAhDtn5opR5GZn7robSFrZWZY=;
        b=WEFDduiXrkHmVEtBS/vKlzRxFJJd9Fk+cpTI4kEKs1No770gszXboBwowRlAkcrL5g
         85aP48u+mvQvsNMeVjaW59B8YgxZL1ugpyTNWyh44f/lzNHfYQ2iVUDlRO6+AieCfjGs
         R1i0FLrAIGCZaw0DFjhKoOOSUoOe9isUxDRarqWmUoFuCwtW9rTSpZwBM0d7EVKZ4Jly
         X9YsQypV83g7WkJ6LeITPct/us7aUmwEj3YEBs5e8amIu7e5F1MFilnpgSBfw1Z7PIGy
         iB+n7N/CIYiob5TmVlsvsINqF+wQNzboIcE0XwM6RFuxin0IgSgxjuSeHBKgi1ug5by7
         E2Ew==
X-Gm-Message-State: AFqh2krEoNeXIuoLRoAPcJYtdXJJFBzGEmDXWC7jYpwpo7eIwwbjg09P
        yswgg8vG5z4eizx0ecKsz+Mcc/4XjcA=
X-Google-Smtp-Source: AMrXdXtQ4Ak35Lb34wlJ+kqfXpwqQmaTB1EiKJZqxY0/z0Y2spI3fFkKlj6H7g+5x+h8/JI+XU3gIl+YQd4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f985:b0:223:9019:6996 with SMTP id
 cq5-20020a17090af98500b0022390196996mr4325710pjb.204.1673053835513; Fri, 06
 Jan 2023 17:10:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:10:23 +0000
In-Reply-To: <20230107011025.565472-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011025.565472-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011025.565472-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86: Split out logic to generate "readable" APIC
 regs mask to helper
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
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

Move the generation of the readable APIC regs bitmask to a standalone
helper so that VMX can use the mask for its MSR interception bitmaps.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 34 +++++++++++++++++++++-------------
 arch/x86/kvm/lapic.h |  2 ++
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c49b13418638..19697fe9b2c7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1529,12 +1529,9 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
-static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
-			      void *data)
+u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 {
-	unsigned char alignment = offset & 0xf;
-	u32 result;
-	/* this bitmask has a bit cleared for each reserved register */
+	/* Leave bits '0' for reserved and write-only registers. */
 	u64 valid_reg_mask =
 		APIC_REG_MASK(APIC_ID) |
 		APIC_REG_MASK(APIC_LVR) |
@@ -1560,22 +1557,33 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (kvm_lapic_lvt_supported(apic, LVT_CMCI))
 		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
 
-	/*
-	 * ARBPRI, DFR, and ICR2 are not valid in x2APIC mode.  WARN if KVM
-	 * reads ICR in x2APIC mode as it's an 8-byte register in x2APIC and
-	 * needs to be manually handled by the caller.
-	 */
+	/* ARBPRI, DFR, and ICR2 are not valid in x2APIC mode. */
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
 				  APIC_REG_MASK(APIC_DFR) |
 				  APIC_REG_MASK(APIC_ICR2);
-	else
-		WARN_ON_ONCE(offset == APIC_ICR);
+
+	return valid_reg_mask;
+}
+EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
+
+static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
+			      void *data)
+{
+	unsigned char alignment = offset & 0xf;
+	u32 result;
+
+	/*
+	 * WARN if KVM reads ICR in x2APIC mode, as it's an 8-byte register in
+	 * x2APIC and needs to be manually handled by the caller.
+	 */
+	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
 
 	if (alignment + len > 4)
 		return 1;
 
-	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
+	if (offset > 0x3f0 ||
+	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
 		return 1;
 
 	result = __apic_read(apic, offset & ~0xf);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index df316ede7546..0a0ea4b5dd8c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -146,6 +146,8 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
+u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
+
 #define VEC_POS(v) ((v) & (32 - 1))
 #define REG_POS(v) (((v) >> 5) << 4)
 
-- 
2.39.0.314.g84b9a713c41-goog


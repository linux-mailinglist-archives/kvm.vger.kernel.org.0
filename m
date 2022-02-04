Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0BE4AA284
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbiBDVmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245247AbiBDVmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:35 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1885C061755
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:19 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k13-20020a65434d000000b00342d8eb46b4so3510478pgq.23
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k5UFgI2I9MLs2H4ssnRT873l7YLngEbdEt/P0KNnq10=;
        b=rf3nxdHlYTt9yk9qc8xQwkwU37D+FTjmdYyFbOS1P0CJyzITmO2YxxakNBUTAi09Z7
         VmbnBDoG1r+DcWx23X9OgAgLLX/SgwPlURVbet91RkY4W2w9BP85AiNHD1Mx6SSY6CTv
         9D18qtAH/LlN4V5MAErzYlF2ZG8mDMM6ifQWpdJCwZzELTkUgbIC4jLNcxOe2sGuc+K4
         MZFIYupxHpxirfJNXPedybQj95fb0rldAC7e9pnl+DVVjXliTXlI8CVNyjbyHDTZ0Mpm
         Un+iqGqPLs15nsCoGBbabN0OC7IT5R/hf5v3NLvZNIA1JeuBmNk5PIuQwZpIRXjCNYRa
         okkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k5UFgI2I9MLs2H4ssnRT873l7YLngEbdEt/P0KNnq10=;
        b=ipAOwQoieZAloP+c4xh+/nESiC10BoONHh16m+yX184rwnumqegsQ4p4llzFV3btCc
         B/MuhjrfilfJaDp3pnoi/vBCfGGs1g0Ffslc08pY2IYpfizB6ss1CDIVG4zexnx3JtdH
         USISIZxLwPhqaD8P+qdndWOdPHWiXqlqYuf3hWwuOvGHlDdf78ipJOVv969S6s5x4X8U
         R7e9zu2Fv60njKLT9KZbdxemsvUL+DOK/nZBZdccqbgH25XJOlEIeLE22EorXpAAHnzw
         CF66OKYPFw+kkH7K52wT77gyj+YJ8Bv0P2Dg8HbY5+8jU+MwzuXrpLqETcHq7IWvKMqn
         z0YQ==
X-Gm-Message-State: AOAM531V/aCB6Bp4ac10FUFewQTpe8ek84tQhVcPsiSisKFdczp5A9DA
        PZZYWy6KYtfKNGHF2mSPnI8eDKh4g8s=
X-Google-Smtp-Source: ABdhPJzobXBMkjgYQ5hcgjZNpX3NLiZ6BOhpRK4BZiHqfM7NniGi2ow+0kFIDeKTi+Z0wVXRqNfwwbQXHks=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c68c:: with SMTP id
 n12mr1024171pjt.219.1644010939400; Fri, 04 Feb 2022 13:42:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:42:01 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 07/11] KVM: x86: Make kvm_lapic_reg_{read,write}() static
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the low level read/write lapic helpers static, any accesses to the
local APIC from vendor code or non-APIC code should be routed through
proper helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 8 +++-----
 arch/x86/kvm/lapic.h | 3 ---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4f57b6f5ebd4..deac73ce2de5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1385,8 +1385,8 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
-int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
-		void *data)
+static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
+			      void *data)
 {
 	unsigned char alignment = offset & 0xf;
 	u32 result;
@@ -1442,7 +1442,6 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_reg_read);
 
 static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
 {
@@ -2003,7 +2002,7 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
-int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
+static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
 
@@ -2151,7 +2150,6 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
 
 static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..ab76896a8c3f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -85,9 +85,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
-int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
-int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
-		       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
-- 
2.35.0.263.gb82422642f-goog


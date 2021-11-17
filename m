Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95027454127
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhKQGte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhKQGtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:49:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B739C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:46:35 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id l8-20020a056a0016c800b0049ffee8cebfso1086616pfc.20
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N8fXLZvqvLp46Vlb4MzkHW+PGd4Y1uV4+vNk1MNsoX0=;
        b=elNT4EfICJasbMSr/sYT0V1/WkFPMoqyqLRbGmG7zbzGDFT6A4OQRNMQGgcXR0LaSX
         oLEu/mbv1y3wwz3gKGrHjlgyRVltbe5BnSEaGEUFHNujVkdVYM7yEnqle/1ENDCe59t4
         yfQK7K/JOWgUWTTmlLUj+CgQjQgrgQnltIJ9mc065L65W9UDIAtVBzxY/T9FxKVtGU4Z
         pPabu4FCY5kW58/Np0jr4Pmd1Hg6LcbQkgOzQJShJfb9aqtddBl85imtFziYKFyKIRWj
         ArwDotwmWfET5LLJ55ke68oyxkVYzKI0hR/rDvAIfOw37WfDwQ5rBxhavWPRQtst24dk
         XTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N8fXLZvqvLp46Vlb4MzkHW+PGd4Y1uV4+vNk1MNsoX0=;
        b=HHKtYRTL0Frg/aKrTUvFZHI4qKInnGsP0Ef/i5CdHvCgvTd5YM9ffOUdlH6q2dHWON
         jrKkpFmBwBRkLNu5iXi6VX55tfKmF0R3toFqOoJp8m1EPBTdqFlZ+uF/Sepu2w+9qw3x
         kEoBLJg3EX1m93+JGr/TNke7pkE5BcWARBEm3JVWaVgdAyXyGIWv0mNonRCj9gW4mguQ
         +KeQWiKOnhM8v+4pESTfgzpsfRexqbolW6G/QfPSmBlUsYWKQyif7sF8IN9c3laxXuz6
         8pCiuH0fr/nL4Z3uiF5aeZ5h304kEZQO1kkMFTp0MscdNqEss95gip2vUSG6pxLt7Ke9
         MT+A==
X-Gm-Message-State: AOAM5321eCyOvoU578SBPh8FccrdjGCDJH9SpP9JZ21mLuyst005YFKd
        bFh7nEOdxYEMeiphWfq5G49bTQ2CBj8=
X-Google-Smtp-Source: ABdhPJwNBUSOEB1JuFJIrJfbR51JUxxZJ1OON4wodu+1NC7Urx/fRiLZJ4etkL1sB/ACUMvvsEJ5yqyqc0k=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:15d0:0:b0:4a0:2dd5:ee4e with SMTP id
 199-20020a6215d0000000b004a02dd5ee4emr46726718pfv.14.1637131594948; Tue, 16
 Nov 2021 22:46:34 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:31 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-2-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 01/29] KVM: arm64: Add has_reset_once flag for vcpu
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
if the vCPU reset has been done once, for later use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..edbe2cb21947 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -385,6 +385,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+	bool has_reset_once;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -450,6 +451,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..c3a91ab370fa 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	if (!ret && !vcpu->arch.has_reset_once)
+		vcpu->arch.has_reset_once = true;
+
 	return ret;
 }
 
-- 
2.34.0.rc1.387.gb447b232ab-goog


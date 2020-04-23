Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAE21B57A3
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgDWJCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWJCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:02:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B82CC03C1AF;
        Thu, 23 Apr 2020 02:02:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so2239880pjt.4;
        Thu, 23 Apr 2020 02:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3iVAexC8qZgJVYVSdtYQ77zlb7+GaDPDyad/7k/Ooa0=;
        b=ldOr25ELZ7lHvrOHjIRfwT0wIZZA/rWfTXAAnhb3pQiWywguZJL1NdZfPIyGDQnKdF
         V1sK43U21Ub2769jq5g0/regAiSCi4d3N/btX6gz6mmUyRWf8WznBVxuzuGXkv+AOL1b
         4XD3lPg1Nt8KXZt3F8urm0Z+JQx9gLc3SLfOXCtL/I3Zi5AeBoIgcU4b7hM1Cdal5ZzJ
         e6Jqc9bPPz+YGu0NsmaGExlYbp15dU6IznmpYi6zBWFI88mlq/9JW1oiUAmEMnkPxuHA
         pBYg6+CluZrojQPEkXdgs+TBQVrocf80FNZqRRslGwhpvYwjsFM6aRfubU1mo36KKivM
         XBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3iVAexC8qZgJVYVSdtYQ77zlb7+GaDPDyad/7k/Ooa0=;
        b=SjKfRmy3GVOuKAVcce9meTakAsO3LdMgDHd7+gdjflH/A4herp9Z2ZyLqLDeLuTFPP
         2ArTjcAqgTQNBmu6UypSF8yMc5cz1rT+OlG+ixu5Bf1tj7FilJrDFZAFnYQNRYNfy42Z
         A+i8vJreOB8uPqqcsJfyPjhH72IFkSnomKT58FOvKibD7xjzAUhY8ZT6D9qHoXHN1p0m
         qUosvaps2reeMB2TNQgTFMX6qso8mcC05oRrtEnPojFBCKG5+e2BuvqiwQSN7sty9ilv
         SugCkkDo8Hjgv94H2Kfh3Cc2kX8TrlzEjidtJuOXPl2wwqmkUxHj6XqDe7ZKwMxniT6g
         mRDQ==
X-Gm-Message-State: AGi0PubGDpXpBFFLRor3Y38I/Cu283WXI+gOoqmFnJxVvUWJSIXkTF1t
        lS/m2L1Q9RKvX5WnGXEcvwwtu4xB
X-Google-Smtp-Source: APiQypKs32G6emy9/+Ba+HYCZLOSbNsVsc0lb6fafCYzYlEdZYzIYEA6BigjRE8e98NKxwfw30gJBw==
X-Received: by 2002:a17:902:7285:: with SMTP id d5mr2815208pll.239.1587632522830;
        Thu, 23 Apr 2020 02:02:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w28sm1574204pgc.26.2020.04.23.02.02.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:02:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v2 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
Date:   Thu, 23 Apr 2020 17:01:44 +0800
Message-Id: <1587632507-18997-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce need_cancel_enter_guest() helper, it will be used by later patches.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 arch/x86/kvm/x86.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce..4561104 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
+	    || need_resched() || signal_pending(current));
+}
+EXPORT_SYMBOL_GPL(kvm_need_cancel_enter_guest);
+
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
  * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
@@ -8373,8 +8380,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
-	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
-	    || need_resched() || signal_pending(current)) {
+	if (kvm_need_cancel_enter_guest(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7b5ed8e..1906e7e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -364,5 +364,6 @@ static inline bool kvm_dr7_valid(u64 data)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.7.4


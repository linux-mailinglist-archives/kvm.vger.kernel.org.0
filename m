Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3533C52F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 09:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404232AbfFKHe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 03:34:27 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43226 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404100AbfFKHeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 03:34:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so6855289pfg.10;
        Tue, 11 Jun 2019 00:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oho9VDmi/+Ex8ie4fSltHPSm+wJ4YXOIowBWuLU3JVE=;
        b=BAPbViolh2+1DB7kE8s+euWUARkmRMk/kCv8gbEO1jnhjQ8MpVl5pH8NqFG8vPO4fk
         Vc8duC6GwAr3n++X1X4dwaESGagzKKSeAeUubRDU4nQD84hWsCZvusGveW2ioz0KSn2P
         0eolLaXzIKIHEfcoTWOBGwbbWNYE+JEaD1pZrQ4ETutN1fv+dJRdl801pp48ObGrBDoT
         1oVnvCvDb6Q3VF0NcmU3dIMtePvr5OSvkfjXUiiUWDKZAfLa1aDfvQVKLsUZnOM+2Xp7
         BmRrS9TK74ZamR6OBe8Vggit8EkwoyvyURT4Gk3CWMPdQPeqeQYm36J2P454+oLooI21
         BHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oho9VDmi/+Ex8ie4fSltHPSm+wJ4YXOIowBWuLU3JVE=;
        b=FodrBAS64IPWZrwj3Vlwh8/djJHHRJ/ROHLad7Y1sG2iMKz+mDpWJjPS9OwKebPMe1
         I7TBQoY6fSi1jXZjYjjZADGdL7qBjCjGaN0jvagCtAZzIAJrchAdyay8keK9W4CJbyk1
         IImFCHZ82nJrOraM17nVejD+2BA+/KMo7g52YJa+AilGTSPuDaAb7DWBxGk2rlHBdoAG
         yFcGCt6o5lxD4AUMarfSDa3uBQ11PKd1M6BzvIn7shY+VIeW3NU9uiD1Qi34iIN60BqD
         z+2VEaARwJgdUyekJpPGTn1gPyFCfYWpzxcv572HMVtmjtJtkJahbRp8Zh/RnqmWPAdJ
         lTOA==
X-Gm-Message-State: APjAAAVnDlZlXSkGldEuUJLc0wu9oMQFTfrgXJGDYu34PPT00aqiUinC
        58vM2jjEUlZ3+eOPvMnq3EfHvbGR
X-Google-Smtp-Source: APXvYqyTx+O9CVxwMsBbFupmHAMhhliGcrexIjAX0dpC5QLSDkitY5tN3ZHDS06uBcxddhvBLylxeg==
X-Received: by 2002:a63:5961:: with SMTP id j33mr2859406pgm.89.1560238463691;
        Tue, 11 Jun 2019 00:34:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 14sm6860800pfj.36.2019.06.11.00.34.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 00:34:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 1/5] KVM: X86: Dynamic allocate core residency msr state
Date:   Tue, 11 Jun 2019 15:34:07 +0800
Message-Id: <1560238451-19495-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Dynamic allocate core residency msr state. MSR_CORE_C1_RES is unreadable 
except for ATOM platform, so it is ignore here.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 15e973d..bd615ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -538,6 +538,15 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
 
+#define NR_CORE_RESIDENCY_MSRS 3
+
+struct kvm_residency_msr {
+	s64 value;
+	u32 index;
+	bool delta_from_host;
+	bool count_with_host;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -785,6 +794,8 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	struct kvm_residency_msr *core_cstate_msrs;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0b241f4..4dc2459 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6658,6 +6658,11 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			goto free_vmcs;
 	}
 
+	vmx->vcpu.arch.core_cstate_msrs = kzalloc(sizeof(struct kvm_residency_msr) *
+		NR_CORE_RESIDENCY_MSRS, GFP_KERNEL_ACCOUNT);
+	if (!vmx->vcpu.arch.core_cstate_msrs)
+		goto free_vmcs;
+
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
 					   vmx_capability.ept,
-- 
2.7.4


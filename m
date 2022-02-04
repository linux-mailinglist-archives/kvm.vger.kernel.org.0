Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121B64AA272
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243829AbiBDVmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiBDVmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:12 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5BCC06173E
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s15-20020a17090a440f00b001b86bbe3de6so1298576pjg.4
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SN0Z+icyOC8azJmY8lil5AT+GqrQYLTXy+CHe5R+yDA=;
        b=rgBolqPf4C1gRSpaHVzt97AmfFoycWf3gvpXXQU5yyTs/tcpym9X6O9sQrA/ucSv41
         5T5lN3f2nuRvKSpJJNYS1yCx+8u2YSTpQzmbbIcrap7trHRAwSqnHM7pEOrWw9tWWLOz
         dyjBRu8VrP0ceh4TrFjN6Md2g8+zbv4kELjnpEcdBSFG5uZh9JfGnQCrZq0iAroHWq2Z
         CpJtvjL0+zeM5vXUorgLoE/gwK8OiwT2PH0RWtD1DLscprMZST9cc/6Yt2cwFpc9pkDK
         C6ufbMRd3XVsZHZBcg0t0j9hTJH4XTdmp1CqHSaIZeCJF2K7dA44dJEUYa+lqES++U+1
         cPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SN0Z+icyOC8azJmY8lil5AT+GqrQYLTXy+CHe5R+yDA=;
        b=LNoTmOT9n3az4867Zh1LYoTAE1fe5aeFgCL4ouSh9tPUeA9kcHBP0pB+J8s0/a6q36
         fj+w7BTmiDLGEEMPpcMZXvIqRfNUwHfsra/sSKqQZfhIds/GCspUPGM+H5Fffi7ptCDL
         HLNxYwQpspr2ZBgj9J2ZUtAckcK5H3IhalnYwk8Up+UMKsJhpTS3XaZhwbgJmm4uhaCs
         te/YEimetqXcEj7V53qg4Jz9hukaoP/Mj9CZYp5TAvylsZa+iOXVYnQRMw/n+rhptXI3
         zuXf1ZkRgceZEN8PedFbL0avvx9PyprZmE6wOX+FaOY9hXpVHiFN4pHjlSS0KpUYKPsl
         /CnQ==
X-Gm-Message-State: AOAM530SRI0z4Pae6FZNGs+R5T5X1zTEc1D+k5sAuafb7xIGXtldch32
        qcDXHx2ja463uJahVlpEYn0AcOcwraU=
X-Google-Smtp-Source: ABdhPJzQXB3jNCCPs2r426cwfrERg3u0KFyRu3mEURa+fe/3WgXQLUz7ChRCmM2gdVmhIuMIs05DsOfhpTU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1409:: with SMTP id
 l9mr5033269pfu.20.1644010931015; Fri, 04 Feb 2022 13:42:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:56 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 02/11] KVM: VMX: Handle APIC-write offset wrangling in VMX code
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

Move the vAPIC offset adjustments done in the APIC-write trap path from
common x86 to VMX in anticipation of using the nodecode path for SVM's
AVIC.  The adjustment reflects hardware behavior, i.e. it's technically a
property of VMX, no common x86.  SVM's AVIC behavior is identical, so
it's a bit of a moot point, the goal is purely to make it easier to
understand why the adjustment is ok.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c   |  3 ---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4662469240bc..fbce455a9d17 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2188,9 +2188,6 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
 	u32 val = 0;
 
-	/* hw has done the conditional check and inst decode */
-	offset &= 0xff0;
-
 	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
 
 	/* TODO: optimize to just emulate side effect w/o one more write */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b1165bb13a5a..1b135473677b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5302,9 +5302,16 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 static int handle_apic_write(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
-	u32 offset = exit_qualification & 0xfff;
 
-	/* APIC-write VM exit is trap-like and thus no need to adjust IP */
+	/*
+	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
+	 * hardware has done any necessary aliasing, offset adjustments, etc...
+	 * for the access.  I.e. the correct value has already been  written to
+	 * the vAPIC page for the correct 16-byte chunk.  KVM needs only to
+	 * retrieve the register value and emulate the access.
+	 */
+	u32 offset = exit_qualification & 0xff0;
+
 	kvm_apic_write_nodecode(vcpu, offset);
 	return 1;
 }
-- 
2.35.0.263.gb82422642f-goog


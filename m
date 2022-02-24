Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE004C35AE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiBXTT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiBXTTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:19:53 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2660717289C
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:19:23 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id g2-20020a170902740200b0014fc971527eso1570224pll.14
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yieelq7XzoMm9U+sAB44XjR1x4+Di8aVqI+Ht06XBSY=;
        b=BP3ft1zkTKcGkK0f2+HsK7YjABI81wEEkbltSB6pfEqw5GleoGN3Rbmaw4xhmLahBg
         zFJE25ew/HqvKM3hS1EI5nqz+Tbo9kI7x0uwTu49dyjupTeta0I+LRaEFXPcD5kRcLa+
         rf1Plaby0PUZoHqizdWUa7xQJh45NumpLi5vhFOxL86X4waXeMwbzYVznNaiA+5KYLTl
         /mZ9UEzhi87gfwzjaPWkWLB6WAAMdVUrFZmqHIVcHoyY10+IEQSh24u6wIUtk2Pqrsej
         GzRs96vkd9G8p/T4JAA+pER+i+hTWykK9JqkHFkN9LXRpr8Z+bGwgA/yS4R92HaasltI
         EyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yieelq7XzoMm9U+sAB44XjR1x4+Di8aVqI+Ht06XBSY=;
        b=YV3ykOzxcb4LlkfBj9IAP31xkbtmXkSiBM6ZTxw3l7Pdea9HDbWGdU+olmlBb1iwjU
         iYMjKysASfXN4nNmaiZJpTyr7Wbw03hEZxvwrfRuO1zPauLCh/hD0P5LQKwKUVmU2s0o
         Cgy0KKcH8XvO0GJlabMSSJbb4106WSy7IYBhBw3O/UsGR9tlgWKDgdieFKB0meLUnucd
         H4xxu4Ak96A9h4NTX+g0AOeatBfeAAPqq0mqREKkLURjUg8Al9kNlMZ5xBL3XiJbR+Ni
         csVfIeQgaDjkeVuQgE4vT2EhOXgpOGa3+evpkzXK8M4lOKK1IA5+/IqFxIanTYl9dUBI
         JZzw==
X-Gm-Message-State: AOAM5339Q0kSZrDcBMdtdH2yVTZFmuJWjDWcksqvxHi8Dh3l1IRMC7hS
        cyc9jHbNAUFW0oblyjhuoRLhaGaVEvw=
X-Google-Smtp-Source: ABdhPJxEOKP7SjXFgqmje7/U4JD92c0LMC57eWxrJRQqbSQt6GELqxMbBC9x4ksWOzaksc5zc6zN7bKMSPg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:654b:b0:14d:964d:7578 with SMTP id
 d11-20020a170902654b00b0014d964d7578mr4168544pln.166.1645730362575; Thu, 24
 Feb 2022 11:19:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Feb 2022 19:19:16 +0000
In-Reply-To: <20220224191917.3508476-1-seanjc@google.com>
Message-Id: <20220224191917.3508476-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220224191917.3508476-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 1/2] Revert "KVM: VMX: Save HOST_CR3 in vmx_set_host_fs_gs()"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
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

Undo a nested VMX fix as a step toward reverting the commit it fixed,
15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()"),
as the underlying premise that "host CR3 in the vcpu thread can only be
changed when scheduling" is wrong.

This reverts commit a9f2705ec84449e3b8d70c804766f8e97e23080d.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  3 +--
 arch/x86/kvm/vmx/vmx.c    | 20 +++++++++++---------
 arch/x86/kvm/vmx/vmx.h    |  5 ++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ba34e94049c7..c12f95004a72 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -246,8 +246,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	src = &prev->host_state;
 	dest = &vmx->loaded_vmcs->host_state;
 
-	vmx_set_vmcs_host_state(dest, src->cr3, src->fs_sel, src->gs_sel,
-				src->fs_base, src->gs_base);
+	vmx_set_host_fs_gs(dest, src->fs_sel, src->gs_sel, src->fs_base, src->gs_base);
 	dest->ldt_sel = src->ldt_sel;
 #ifdef CONFIG_X86_64
 	dest->ds_sel = src->ds_sel;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efda5e4d6247..beb68cd28aca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1080,14 +1080,9 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
-void vmx_set_vmcs_host_state(struct vmcs_host_state *host, unsigned long cr3,
-			     u16 fs_sel, u16 gs_sel,
-			     unsigned long fs_base, unsigned long gs_base)
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base)
 {
-	if (unlikely(cr3 != host->cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		host->cr3 = cr3;
-	}
 	if (unlikely(fs_sel != host->fs_sel)) {
 		if (!(fs_sel & 7))
 			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
@@ -1119,6 +1114,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	int cpu = raw_smp_processor_id();
 #endif
+	unsigned long cr3;
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
 	int i;
@@ -1182,8 +1178,14 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	gs_base = segment_base(gs_sel);
 #endif
 
-	vmx_set_vmcs_host_state(host_state, __get_current_cr3_fast(),
-				fs_sel, gs_sel, fs_base, gs_base);
+	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+
+	/* Host CR3 including its PCID is stable when guest state is loaded. */
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != host_state->cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		host_state->cr3 = cr3;
+	}
 
 	vmx->guest_state_loaded = true;
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f2c82e7f38f..9c6bfcd84008 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -374,9 +374,8 @@ int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
-void vmx_set_vmcs_host_state(struct vmcs_host_state *host, unsigned long cr3,
-			     u16 fs_sel, u16 gs_sel,
-			     unsigned long fs_base, unsigned long gs_base);
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
 bool vmx_emulation_required(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
-- 
2.35.1.574.g5d30c73bfb-goog


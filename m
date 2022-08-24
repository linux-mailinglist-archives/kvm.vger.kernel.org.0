Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6B59F1B5
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiHXDD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiHXDDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:15 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6EE7DF57
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a16-20020a17090abe1000b001fad8c29b0bso177207pjs.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=orsRLLvld9XncDlS+K6sh5SJLZUjNkl/NTQ67ye5NYE=;
        b=XVAeJMGxqZWW2BYgqmuE+Zgbr8DLybKR6hdfs2j6JkmuzB1+Qo30JYXOO9ANqGiJCr
         +KwJG+T3PHAhgSH+wEqo77J7n1rvuQUe7moXoelZlWuuShoIp3IHDtv3b52NF9a8Q8RQ
         KKvC6vHX1szc8WoP4UMY634sxW2LgQtLspshiRJfzJrAGVTtRl5hTHNLcdvY44adFAEu
         K+jLqlKfVJVEqqslVVnlQufYSuABz7XKD4KFV/yCo7a0mxhh/FSgZUID0NucKHsItmWs
         Sqq5qf6ZL+STbMdcknIlil0dmYlFmyUqEb9/FRgFPQusOnQL5mEJvZEquQIptD9ZPiTU
         IScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=orsRLLvld9XncDlS+K6sh5SJLZUjNkl/NTQ67ye5NYE=;
        b=OL+fa7jK1KZnBy52ZPatQOOT0i1mnAfhKpLAvONyb0h6aAOVL6OWyNozf0YpuYQE48
         r18tDisZOR3Y/kZyNA9g5T5MCQ9Mi/638zgbPdia7FidroF1T68G3zbBauJpuD+ZE/cN
         oOpYIK/KTEiAelEBp/iufbq8obsaWdzutLJVRPu6X1NAFXiHJ9WqY3YVJkrDHlJxRqPs
         K1Tt0k0MnU3fYlGOCGAu48uunErnPgsnaA+8E2Y+mS2z0BcdwbhbqWNhtwMEwJ3eN/nR
         sZLR2ZPzkl4B9idYkwh8tyo8z7k29m6XlGz3OuAzyVDGXUK/P4xmzBO/VIQZ5IuPJI6e
         HM4g==
X-Gm-Message-State: ACgBeo3UfDGs8CcFUlB6oUjMW9cBHlfRZxrGNBcV8f6mUvq5a8AxOrZA
        o5TSTAUWJI1KUpd7XvK0Mlt5f7Qpqpc=
X-Google-Smtp-Source: AA6agR6YviNFy51PTHzFQeE5ed/dMQt30doalJvKHzPy1zNDGZVjtByjxIToN1zouwhsmzel6QjbfBhk8DA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf42:b0:172:ed15:ee with SMTP id
 e2-20020a170902cf4200b00172ed1500eemr11227292plg.149.1661310120086; Tue, 23
 Aug 2022 20:02:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:13 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 11/36] KVM: nVMX: Support several new fields in eVMCSv1
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Enlightened VMCS v1 definition was updated with new fields, add
support for them for Hyper-V on KVM.

Note: SSP, CET and Guest LBR features are not supported by KVM yet
and 'struct vmcs12' has no corresponding fields.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 52d299b9263b..57e96f4ab765 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1616,6 +1616,10 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_rflags = evmcs->guest_rflags;
 		vmcs12->guest_interruptibility_info =
 			evmcs->guest_interruptibility_info;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ssp = evmcs->guest_ssp;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1662,6 +1666,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->host_fs_selector = evmcs->host_fs_selector;
 		vmcs12->host_gs_selector = evmcs->host_gs_selector;
 		vmcs12->host_tr_selector = evmcs->host_tr_selector;
+		vmcs12->host_ia32_perf_global_ctrl = evmcs->host_ia32_perf_global_ctrl;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->host_ia32_s_cet = evmcs->host_ia32_s_cet;
+		 * vmcs12->host_ssp = evmcs->host_ssp;
+		 * vmcs12->host_ia32_int_ssp_table_addr = evmcs->host_ia32_int_ssp_table_addr;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1729,6 +1740,8 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->tsc_offset = evmcs->tsc_offset;
 		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
 		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
+		vmcs12->encls_exiting_bitmap = evmcs->encls_exiting_bitmap;
+		vmcs12->tsc_multiplier = evmcs->tsc_multiplier;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1776,6 +1789,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_bndcfgs = evmcs->guest_bndcfgs;
 		vmcs12->guest_activity_state = evmcs->guest_activity_state;
 		vmcs12->guest_sysenter_cs = evmcs->guest_sysenter_cs;
+		vmcs12->guest_ia32_perf_global_ctrl = evmcs->guest_ia32_perf_global_ctrl;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ia32_s_cet = evmcs->guest_ia32_s_cet;
+		 * vmcs12->guest_ia32_lbr_ctl = evmcs->guest_ia32_lbr_ctl;
+		 * vmcs12->guest_ia32_int_ssp_table_addr = evmcs->guest_ia32_int_ssp_table_addr;
+		 */
 	}
 
 	/*
@@ -1878,12 +1898,23 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 	 * evmcs->vm_exit_msr_store_count = vmcs12->vm_exit_msr_store_count;
 	 * evmcs->vm_exit_msr_load_count = vmcs12->vm_exit_msr_load_count;
 	 * evmcs->vm_entry_msr_load_count = vmcs12->vm_entry_msr_load_count;
+	 * evmcs->guest_ia32_perf_global_ctrl = vmcs12->guest_ia32_perf_global_ctrl;
+	 * evmcs->host_ia32_perf_global_ctrl = vmcs12->host_ia32_perf_global_ctrl;
+	 * evmcs->encls_exiting_bitmap = vmcs12->encls_exiting_bitmap;
+	 * evmcs->tsc_multiplier = vmcs12->tsc_multiplier;
 	 *
 	 * Not present in struct vmcs12:
 	 * evmcs->exit_io_instruction_ecx = vmcs12->exit_io_instruction_ecx;
 	 * evmcs->exit_io_instruction_esi = vmcs12->exit_io_instruction_esi;
 	 * evmcs->exit_io_instruction_edi = vmcs12->exit_io_instruction_edi;
 	 * evmcs->exit_io_instruction_eip = vmcs12->exit_io_instruction_eip;
+	 * evmcs->host_ia32_s_cet = vmcs12->host_ia32_s_cet;
+	 * evmcs->host_ssp = vmcs12->host_ssp;
+	 * evmcs->host_ia32_int_ssp_table_addr = vmcs12->host_ia32_int_ssp_table_addr;
+	 * evmcs->guest_ia32_s_cet = vmcs12->guest_ia32_s_cet;
+	 * evmcs->guest_ia32_lbr_ctl = vmcs12->guest_ia32_lbr_ctl;
+	 * evmcs->guest_ia32_int_ssp_table_addr = vmcs12->guest_ia32_int_ssp_table_addr;
+	 * evmcs->guest_ssp = vmcs12->guest_ssp;
 	 */
 
 	evmcs->guest_es_selector = vmcs12->guest_es_selector;
-- 
2.37.1.595.g718a3a8f04-goog


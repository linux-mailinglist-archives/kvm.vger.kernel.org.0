Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8555CEBF
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbiF0QE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238689AbiF0QEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:04:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAC0BBC8B
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lFWL93dgvSyQfByxDYBPGvJ9P1pf5kwm9M7UicRCc0w=;
        b=En7op9b1BzUiL9YMoPk3PNan2B7OUh0gu5xXcY3Cvw0Weu2/j1Z9qFufg4e1AvWgcczfBf
        V3AVUdCDkhQA/gu7pR+/Be0oomViPbaLh3vbXpp/wIgFrKhxskl2h1oFN/OG6vhzt/sK+G
        fQPnRFseyh1y/C0zD2cWAlQxRMe9+XA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-tMefaSufNv-g9ou-JBInrQ-1; Mon, 27 Jun 2022 12:04:49 -0400
X-MC-Unique: tMefaSufNv-g9ou-JBInrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C811829DD99B;
        Mon, 27 Jun 2022 16:04:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A862CC15D40;
        Mon, 27 Jun 2022 16:04:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
Date:   Mon, 27 Jun 2022 18:04:28 +0200
Message-Id: <20220627160440.31857-3-vkuznets@redhat.com>
In-Reply-To: <20220627160440.31857-1-vkuznets@redhat.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
but setup_vmcs_config() doesn't check their existence. Add the check and
filter the controls out in vmx_exec_control().

No (real) functional change intended as all existing CPUs supporting
VMX are supposed to have these controls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7d5c837e5a7c..ecd00fc69674 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2487,7 +2487,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      CPU_BASED_MWAIT_EXITING |
 	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING |
-	      CPU_BASED_RDPMC_EXITING;
+	      CPU_BASED_RDPMC_EXITING |
+	      CPU_BASED_INTR_WINDOW_EXITING |
+	      CPU_BASED_NMI_WINDOW_EXITING;
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
@@ -4305,6 +4307,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
+	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
+			  CPU_BASED_NMI_WINDOW_EXITING);
+
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-- 
2.35.3


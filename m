Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5665A651D
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiH3NkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiH3Njl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:39:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BE8F72CC
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CgW5RnPq93SjDOoyaTew0QAuHZFiRvh5YMiNccXT1qY=;
        b=VzPlnL04R5wXNs1Jwz8omBi5PDK3bTDBLDfDKYS7czeWhmlvDoLT3HNV87yFv5m4YFB/vI
        Ho8tj6qCkmv6fFvCGltqMEb37aQ95kruPATr/bUcU0CdqgD63qpJE/88lb4z9iPIdOjfkx
        jV/U6oHXQX5xLoqPyBKheyusRgbYocM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-hka2J9cDOlqGMc2xbNKcUw-1; Tue, 30 Aug 2022 09:38:27 -0400
X-MC-Unique: hka2J9cDOlqGMc2xbNKcUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ED9C18E0045;
        Tue, 30 Aug 2022 13:38:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1E772166B26;
        Tue, 30 Aug 2022 13:38:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 18/33] KVM: nVMX: Always emulate PERF_GLOBAL_CTRL VM-Entry/VM-Exit controls
Date:   Tue, 30 Aug 2022 15:37:22 +0200
Message-Id: <20220830133737.1539624-19-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Advertise VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL as being supported
for nested VMs irrespective of hardware support.  KVM fully emulates
the controls, i.e. manually emulates MSR writes on entry/exit, and never
propagates the guest settings directly to vmcs02.

In addition to allowing L1 VMMs to use the controls on older hardware,
unconditionally advertising the controls will also allow KVM to use its
vmcs01 configuration as the basis for the nested VMX configuration
without causing a regression (due the errata which causes KVM to "hide"
the control from vmcs01 but not vmcs12).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c9b17239c9e8..19a96cf65b99 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6602,11 +6602,12 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
-		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
+		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
+		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
@@ -6621,10 +6622,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
 	msrs->entry_ctls_high |=
-		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
+		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
+		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 
 	/* We support free control of debug control loading. */
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
-- 
2.37.2


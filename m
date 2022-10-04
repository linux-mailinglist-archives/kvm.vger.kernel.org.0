Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D16C5F4319
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiJDMk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiJDMkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BDE5AC48
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0izNvrILj4s9gSeGOR18da7XjNKtdJ8f7Z5zOvHNxU=;
        b=XcYB1Y1uOncXoECftFz8uZv90cJooW5yWZjPnN8F9axwxBLzgsje+wu0rbM4e4xQ996e23
        jQpLQIm+ppVOKrqr1kvkGdGrFX3YNoLFu7NtP6xf6PFEVl2MxmQol8tQDaV8hEL7SXp4bD
        UiuFDmyACRS8xaxPnAOy60HbAvNY4Bg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-VKV57MvvNCeKBTvb39-gOA-1; Tue, 04 Oct 2022 08:40:16 -0400
X-MC-Unique: VKV57MvvNCeKBTvb39-gOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B8521C05140;
        Tue,  4 Oct 2022 12:40:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 890287AE5;
        Tue,  4 Oct 2022 12:40:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 06/46] KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
Date:   Tue,  4 Oct 2022 14:39:16 +0200
Message-Id: <20221004123956.188909-7-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To conform with SVM, rename VMX specific Hyper-V files from "evmcs.{ch}"
to "hyperv.{ch}". While Enlightened VMCS is a lion's share of these
files, some stuff (e.g. enlightened MSR bitmap, the upcoming Hyper-V
L2 TLB flush, ...) goes beyond that.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/Makefile                  | 2 +-
 arch/x86/kvm/vmx/{evmcs.c => hyperv.c} | 3 +--
 arch/x86/kvm/vmx/{evmcs.h => hyperv.h} | 8 +++++---
 arch/x86/kvm/vmx/nested.c              | 1 -
 arch/x86/kvm/vmx/vmx.c                 | 1 -
 arch/x86/kvm/vmx/vmx_ops.h             | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)
 rename arch/x86/kvm/vmx/{evmcs.c => hyperv.c} (99%)
 rename arch/x86/kvm/vmx/{evmcs.h => hyperv.h} (98%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 30f244b64523..4412f0b8244c 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -22,7 +22,7 @@ kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
-			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
+			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/hyperv.c
similarity index 99%
rename from arch/x86/kvm/vmx/evmcs.c
rename to arch/x86/kvm/vmx/hyperv.c
index d8b23c96d627..5e239158174e 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -3,9 +3,8 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
-#include "../hyperv.h"
 #include "../cpuid.h"
-#include "evmcs.h"
+#include "hyperv.h"
 #include "vmcs.h"
 #include "vmx.h"
 #include "trace.h"
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/hyperv.h
similarity index 98%
rename from arch/x86/kvm/vmx/evmcs.h
rename to arch/x86/kvm/vmx/hyperv.h
index 6f746ef3c038..99a151af7a81 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __KVM_X86_VMX_EVMCS_H
-#define __KVM_X86_VMX_EVMCS_H
+#ifndef __KVM_X86_VMX_HYPERV_H
+#define __KVM_X86_VMX_HYPERV_H
 
 #include <linux/jump_label.h>
 
@@ -8,6 +8,8 @@
 #include <asm/mshyperv.h>
 #include <asm/vmx.h>
 
+#include "../hyperv.h"
+
 #include "capabilities.h"
 #include "vmcs.h"
 #include "vmcs12.h"
@@ -242,4 +244,4 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 
-#endif /* __KVM_X86_VMX_EVMCS_H */
+#endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4da0558943ce..292591e93286 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,7 +7,6 @@
 #include <asm/mmu_context.h>
 
 #include "cpuid.h"
-#include "evmcs.h"
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87ef9aefc4ac..5d9754e543e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -51,7 +51,6 @@
 
 #include "capabilities.h"
 #include "cpuid.h"
-#include "evmcs.h"
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "irq.h"
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index ec268df83ed6..f6f23c7397dc 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -6,7 +6,7 @@
 
 #include <asm/vmx.h>
 
-#include "evmcs.h"
+#include "hyperv.h"
 #include "vmcs.h"
 #include "../x86.h"
 
-- 
2.37.3


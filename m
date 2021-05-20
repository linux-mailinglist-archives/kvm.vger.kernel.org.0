Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA64C38B9FE
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhETXFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhETXFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:35 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5815C061342
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x24-20020aa784d80000b02902dd5846d381so7631243pfn.20
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oIzsQQKUBlmG+L5Z1kb0XOIo6gMIumBtyoNwBG1Mros=;
        b=ZN1Lfn7D2fMxg2rKY32lCBKVgRSthmgRRVJM76COwTHqcjaN7b0+vxoBA8lqWwctLt
         y3QY7R9MCeJNUudxCT+cE2tF/xAcH6dWo2y8TDH/UFJiN1YB7mQ4bLOpVd6QPr/p/qrd
         UVrOOk/6WHDQ1TPvn3Cw/Ums48wTek9UlHi/b9TB8XNOL4KxINgpEyS4JUzFtCOCkLeo
         HUkxwABXo2pi69tBSWWH4jYFrjwFrwb2YfJqT35YMQX9ZqNjK48yxNGDdbHc1KXF2q52
         BhBo7nrZu/c/+ExS/sblRX67E6Qqe/omleAyxmIlCm5r/8pXG7ISvv7SCFFGZw2ZSo0f
         LS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oIzsQQKUBlmG+L5Z1kb0XOIo6gMIumBtyoNwBG1Mros=;
        b=sPg+8ugFczcP1TSbQ2kID7fS3yfZFEVoOOz631cjhcWHHo8c/mxWvSUplma6duofud
         Rh2diuKp1W8rlep4jflF6KzAP66aoWDyg7BU8MoiAJFFjuJWhyhN2/nIO5dp3C92ruQx
         lQi8N/Jz3r2D4wDzu0uJ0M+beV+ZlKdHX48pWr7M3+QypjRWnzJbMqI4A/0KjJQuoeGm
         +CN8oy3CyY+SrSdPATSv1yBAV4nXgYiqLzM9n6d5ui743FtvprRO9S270YHOyVvJm7xb
         TMilStu+2hl5ACmWms8URXVtqe2WFLDg8h360igI67mLQYbEgPnimwi4gLs0jRCbYxt5
         pjRA==
X-Gm-Message-State: AOAM530kL2WnN3yWNQjvzMGP1BxCdVH1nJTZUgLjWZjRLdcVySztdEJu
        BOmYx8dQTpNFXKTvzEWGn9amgy/NjojcPXz4rLi9+DwGYIKyGAk8BFDjKrQ8Ra1zUCsyvC110ra
        1HaRuoxurD2R6sETjZsloHV4mRDcBER9FeRFssyNfPhtK53S5TsHlKUGCXfUS6g0=
X-Google-Smtp-Source: ABdhPJylHSXWop/Ej1LHSKIKYtI8GMoroxVy9mLQM7IJft8k1lX8WhGmiueuNC9e32W32lNDeqfLGGZW3QbXEg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:ba07:: with SMTP id
 s7mr7239125pjr.129.1621551849857; Thu, 20 May 2021 16:04:09 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:38 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-12-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 11/12] KVM: selftests: Introduce prepare_tpr_shadow
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for yet another page to hang from the VMCS12 for nested
VMX testing: the virtual APIC page. This page is necessary for a
VMCS12 to be launched with the "use TPR shadow" VM-execution control
set (except in some oddball circumstances permitted by KVM).

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 5 +++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 516c81d86353..83ccb096b966 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -574,6 +574,10 @@ struct vmx_pages {
 	void *apic_access_hva;
 	uint64_t apic_access_gpa;
 	void *apic_access;
+
+	void *virtual_apic_hva;
+	uint64_t virtual_apic_gpa;
+	void *virtual_apic;
 };
 
 union vmx_basic {
@@ -618,5 +622,6 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
 				      uint32_t eptp_memslot);
+void prepare_tpr_shadow(struct vmx_pages *vmx, struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 2448b30e8efa..1023760d1bf7 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -551,3 +551,11 @@ void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
+
+void prepare_tpr_shadow(struct vmx_pages *vmx, struct kvm_vm *vm)
+{
+	vmx->virtual_apic = (void *)vm_vaddr_alloc(vm, getpagesize(),
+						  0x10000, 0, 0);
+	vmx->virtual_apic_hva = addr_gva2hva(vm, (uintptr_t)vmx->virtual_apic);
+	vmx->virtual_apic_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->virtual_apic);
+}
-- 
2.31.1.818.g46aad6cb9e-goog


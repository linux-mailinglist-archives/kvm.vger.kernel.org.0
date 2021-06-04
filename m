Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781F439BEBB
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFDR3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:48 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:39756 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhFDR3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:47 -0400
Received: by mail-yb1-f201.google.com with SMTP id r5-20020a2582850000b02905381b1b616eso12731843ybk.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IlVve+6Rq2S9fS+3CXZhYRmldp994V/4F8spl4ldNqk=;
        b=Bgdq248awNvgUajbXS3gn2iTmfXwB27JqRfXLKkobr1WqKbIaxNmmZBDhkIf0WGY5H
         k0Ku0KpLJPJIUniD5uV/XLCiqUMzORZzesL7Ne42rL+ZjPy/i39G38nw8bpIQE8utXYu
         GiQiofZ/ywGp6KG8YskZIdwGmBD8b9cKxljEvQWb6EjKn+o8yOWXbFiWbjKHFBmglrXY
         Dy1Oa0uOG4uMz9EOcghNzfL3KjSksgkaDWDEFFyHVQBImj+E6NKowhFMdrEs/YqQhUQU
         Zz4ZVSFQCuCKH0Jz5dz1bgN4apVvklP6goCqlFlNBBv9KFfjunQoOpKZp1cvAczvUSWP
         DFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IlVve+6Rq2S9fS+3CXZhYRmldp994V/4F8spl4ldNqk=;
        b=KNPeJYa/Okm8HPF/lbgqPpADtVK/Xw0w4eyufvY3auXCS8IBfygtdRtevv3dYLfkH/
         LKcy/PjWpjqislDcWoXC0c46FNsMILdd5xJqOAel317zj+0uXRRLnZebZukSfwRlg8y0
         LnZQUOawVinWXncF9sbQ3VjAwZiBUXODJ5cfbDKArmvIm6sNqy07FitUINbik+FReehS
         1S9tglLsyQZQ/BAuT8uDfXWd38u3TEUESgifRJHIUoufOUM691E9WLk7wEz8yjr21uFp
         viGbTYyG1vdOj6PrAzEhABmjyHsfikSvUkqVrsPvzLzLgu9x2FHLJZ+wmBRb3AXJKZs6
         msyA==
X-Gm-Message-State: AOAM533xroMAOuxqakI22FcxL++ejY0w71RdrC7zyJCkb9sA59WKPHuh
        Xab8C8mjz+yws3uiT3Pnx2+funqJ3PqqwkcLoA+mz+lRwoHwRbE/6PfQC418O6wzT4DVYGHyI3p
        h0uxXSW7SMxcMeXaBGksxeCZaiDIWw8zdpZbgJ2WLG8cv2DZnSAlr/lLqsI0jrGo=
X-Google-Smtp-Source: ABdhPJztOrcK32XGrANtG1zz5Iu25D8q2P3Aelk5X5/sx/nmW3jGVoxhj+KOtOE+gXsmJKZj0/Wo0EZjgF5/Wg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:ccd2:: with SMTP id
 l201mr6829888ybf.35.1622827605724; Fri, 04 Jun 2021 10:26:45 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:10 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-12-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 11/12] KVM: selftests: Introduce prepare_tpr_shadow
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
2.32.0.rc1.229.g3e70b5a671-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA816645D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgBTRWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:22:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37537 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728881AbgBTRWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 12:22:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582219333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXh0YutU9qoqkcD8FcXhGXyVijzyIFeaoys2bDNLpvY=;
        b=cRR+U8euGAo2P1c8sobZKKqgT2DKXJ1b7SkygR9qcWoXoungC82zcXV7Oa238BddquTYMW
        iMNKMpRhEQ2w3SfIiCxMip1YQnfUPUyz5byzPygAhuueDo5NGwLH+qt6pyu3lzTxkt8m1p
        yIwHgSnXym9y8ms3o6mHnY/6Xhq28Fo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-cIn0mne9PEOjH-G2tJkhVg-1; Thu, 20 Feb 2020 12:22:10 -0500
X-MC-Unique: cIn0mne9PEOjH-G2tJkhVg-1
Received: by mail-wm1-f70.google.com with SMTP id y125so1188057wmg.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 09:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXh0YutU9qoqkcD8FcXhGXyVijzyIFeaoys2bDNLpvY=;
        b=bMtAPSIOn5wmWPr0e+w1ZBXO43D24/JYlQ+PFMn+62UeQ2nj6f1uMguHoMF3/9Rw1I
         Rybq5emQi9Ziu9MCgoHiUwT8sqUIODYiqbJ25AO28JQva9mU56ObDlzgGHWnrAw5Xten
         hm9YwQCnEhyPLDdaMLolOlKnr+s2EI+TZdIC/+Fyd6blpRPXtI9yRKqw7T690PTgzA2c
         0wj1RvVlYPXkS2aSrfhVhad3rPqrweCfjv0S5ozIQpMwB4+T8lv3b8epCeHVBCxJbtGR
         rb7eu6A0Ox6Cr87+EOsGglDAUjfy8/FW5yhEi5/kak4YcOOZkY6PJH3QnicmB0HGMC04
         ItNw==
X-Gm-Message-State: APjAAAXlAB4rjZdOaww3PhLYsjQMh8DUqX8meBdvaBJyp8O4A0CkfxCR
        RGW8yO09xL2oURfnvxMnVB6gj20CV1rm0D6o9xsyZb2Iwcn2Yo/ltDWlmfKDLN++fA786yPfSDb
        gBoZlWKPA3JEt
X-Received: by 2002:a1c:4e02:: with SMTP id g2mr5738543wmh.131.1582219329476;
        Thu, 20 Feb 2020 09:22:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjPMNGd6W5n2fR2ezNTcPuzWvxZ6/kAyOLdN6JXfJNlYpHkQt54qct+8w0ddDZP86sZhBmQg==
X-Received: by 2002:a1c:4e02:: with SMTP id g2mr5738512wmh.131.1582219329112;
        Thu, 20 Feb 2020 09:22:09 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a184sm5355891wmf.29.2020.02.20.09.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 09:22:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/2] KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled
Date:   Thu, 20 Feb 2020 18:22:04 +0100
Message-Id: <20200220172205.197767-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220172205.197767-1-vkuznets@redhat.com>
References: <20200220172205.197767-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When apicv is disabled on a vCPU (e.g. by enabling KVM_CAP_HYPERV_SYNIC*),
nothing happens to VMX MSRs on the already existing vCPUs, however, all new
ones are created with PIN_BASED_POSTED_INTR filtered out. This is very
confusing and results in the following picture inside the guest:

$ rdmsr -ax 0x48d
ff00000016
7f00000016
7f00000016
7f00000016

This is observed with QEMU and 4-vCPU guest: QEMU creates vCPU0, does
KVM_CAP_HYPERV_SYNIC2 and then creates the remaining three.

L1 hypervisor may only check CPU0's controls to find out what features
are available and it will be very confused later. Switch to setting
PIN_BASED_POSTED_INTR control based on global 'enable_apicv' setting.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  5 ++---
 arch/x86/kvm/vmx/nested.h       |  3 +--
 arch/x86/kvm/vmx/vmx.c          | 10 ++++------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 283bdb7071af..f486e2606247 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,6 +12,7 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
+extern bool __read_mostly enable_apicv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3589cd3c0fcc..d0462a035505 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5949,8 +5949,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
  */
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
-				bool apicv)
+void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 {
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
@@ -5977,7 +5976,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
 		PIN_BASED_VIRTUAL_NMIS |
-		(apicv ? PIN_BASED_POSTED_INTR : 0);
+		(enable_apicv ? PIN_BASED_POSTED_INTR : 0);
 	msrs->pinbased_ctls_high |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
 		PIN_BASED_VMX_PREEMPTION_TIMER;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..1c5fbff45d69 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,8 +17,7 @@ enum nvmx_vmentry_status {
 };
 
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
-				bool apicv);
+void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
 void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be25ecae145..946c74e661e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -95,7 +95,7 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
-static bool __read_mostly enable_apicv = 1;
+bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);
 
 /*
@@ -6757,8 +6757,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
-					   vmx_capability.ept,
-					   kvm_vcpu_apicv_active(vcpu));
+					   vmx_capability.ept);
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
@@ -6839,8 +6838,7 @@ static int __init vmx_check_processor_compat(void)
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept,
-					   enable_apicv);
+		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
@@ -7702,7 +7700,7 @@ static __init int hardware_setup(void)
 
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept, enable_apicv);
+					   vmx_capability.ept);
 
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7D4481C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404689AbfFMREP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33674 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404674AbfFMREP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so21633304wru.0;
        Thu, 13 Jun 2019 10:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9i5HvQGX2IO7JtOGi96JvfWNChLfBbVzY3tYUVYUuzw=;
        b=eEYlH8zdjrIFN+Q2lbBrqMxU6LcmMPxNOyQBz5TVuisj/Wcu8vj7vdrdWs8VX1HU97
         NPjuwdBzu+UtkcojeziernujpMola/w0aLtC+Sgjfv3gjSTfwBxHIp3e6B6+fVdNyxP0
         L32k0SjM6yW+pphfQsMT9EIqbsAMHwvxNHMLiMVSrU0eisz0M9M4QXFT2glqEYoglwJ4
         oZCqTObfkO4ZPFoys5/hEi1DbqkGdzqB55tRlf0GF9lOphw1v9ogAP8TtlUnkY84k2Tl
         4MwzSGI5pkhqYbt7AQvijI4hbEY5SZgv2S3S8EYSoTLl2+eb9OQgtvUaoOlVCpPNRBU4
         X5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=9i5HvQGX2IO7JtOGi96JvfWNChLfBbVzY3tYUVYUuzw=;
        b=Ubw6sPR6mMcZO4upih6+EBv74oGMTGlExgP03LQk0MatVDE83dvnnNyv0r+extonVx
         tp3uk/deRJcBWuajR1rVEg/hkSeJjrrLoqojdzmSMVk1qjTLs7jyWC+Xfp40mQTWaa/R
         A9kXsVcp4FulKKigVnkv1ej7D72HkPjcsddld6F96RVp1pOPXMO62WOHPtKJtib8ATC9
         kIeiXnvcJSrt/p0EJBek4BOfuihJh2yykziQqGvs+2PzTUVF1rYOty2ax7q+FBddGybj
         PnKrT+AxEBawz5bzBHbj9V+x/W+XQzW9BO0j3C3UpZ5MNBBMPsODTASc/7avsIZiJkQ0
         CbdA==
X-Gm-Message-State: APjAAAWjPl3JMBSXoGoEG9bR3I3/UNQM5eUjvq2ymDlAYYo4tlmhjxs8
        G3YUITADec9rBag84ZhiybMqJ6AQ
X-Google-Smtp-Source: APXvYqxVxk5bQtqpwXUTM0cIhLghSWoz67Y1J38JxnmbmiX72QznBCX0ImcCkyHuZFOKrAm/xMVMGg==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr5033698wru.288.1560445453446;
        Thu, 13 Jun 2019 10:04:13 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:12 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 41/43] KVM: VMX: Drop hv_timer_armed from 'struct loaded_vmcs'
Date:   Thu, 13 Jun 2019 19:03:27 +0200
Message-Id: <1560445409-17363-42-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... now that it is fully redundant with the pin controls shadow.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 arch/x86/kvm/vmx/vmcs.h   | 1 -
 arch/x86/kvm/vmx/vmx.c    | 8 ++------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 598540ce0f52..33d6598709cb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2015,7 +2015,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control |= vmcs12->pin_based_vm_exec_control;
 	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
 	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
-	vmx->loaded_vmcs->hv_timer_armed = false;
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
 	if (nested_cpu_has_posted_intr(vmcs12)) {
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 52f12d78e4fa..9a87a2482e3e 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -61,7 +61,6 @@ struct loaded_vmcs {
 	int cpu;
 	bool launched;
 	bool nmi_known_unmasked;
-	bool hv_timer_armed;
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
 	ktime_t entry_time;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6afb2bc3d0ab..86f29ab22dec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6359,9 +6359,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
-	if (!vmx->loaded_vmcs->hv_timer_armed)
-		pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-	vmx->loaded_vmcs->hv_timer_armed = true;
+	pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
@@ -6388,9 +6386,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (vmx->loaded_vmcs->hv_timer_armed)
-		pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-	vmx->loaded_vmcs->hv_timer_armed = false;
+	pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
-- 
1.8.3.1



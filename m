Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCC44892
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393561AbfFMRI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:08:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36952 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfFMRDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so10898816wmg.2;
        Thu, 13 Jun 2019 10:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xd75nA1E+RR+V+EqJJhYre0VQvBzS9uhfm+ymghyVO4=;
        b=kX71kav7thfhM8lGri1rSF9j0fC3vkoeOQdapqOPzGCGhL9IHd9HbNGKtH+Sd4ZLbP
         k2Ff3NwDzm5mgRHJhrBksN2zwv4sNGq6CJaRs4nJ4pWoU+wAuzD9sAzfvocEzx2AQRM0
         a9wZXFo9X6NuqBh+Hwwm0S4Wkr1w2U+YYDAjgWGdVMZsokpC14VR6TXmvmzB8q+6VoYU
         dzU1ifGwTZzi+k4EahyWB3r1msYWA7MdylG+zpY/4C0V/qdB1R03uYgfX64v0gOi75be
         TdkVp0bSzUsPPzMoS4323XAWHpua8+EMLA6JeQzQfJ9oy0PkTeyPdtExj4dU7fiv0Apn
         MnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Xd75nA1E+RR+V+EqJJhYre0VQvBzS9uhfm+ymghyVO4=;
        b=CG5kLoHJgEIpPLdmzPz9ojwlla9jONAUxCpSCM8a6FwZEneGjkTv9CvukJI7Wpav/H
         R7xR1PtPPO5bJtnXCMCsq+oxwRocFqZG5Y27kq4O05ftw1glR/nrajcjjyFbgI5/zmFX
         kMUXmqRI8P0XK2fpM7T/i66KB7mhc/d3pntosDKYcUNIU3ean5gnLJgsSLLy62Jqo8vN
         qJGhxAIaV071EJjgufs/XY8MfnQDSVRsIiI7Ezuwo5GsA8/QIVdL7jk2LjXjcyc/7JBV
         uPtK4YPH9OC90Nwnd0zfokhWu4NJmn2igssLrVNCCrH34RzKHImW8+YPhnrsGsC8aZm6
         RoDA==
X-Gm-Message-State: APjAAAWJXn8UucJyPH1bhC6WRQstUJvo/7lx7inR7155pMM7K2EI1Z/Q
        eAI1gM5Z/ZMKS0MbE3KJnVyTTyyk
X-Google-Smtp-Source: APXvYqxXKJoUtJwkguHWtmJ8hFBNdi/CC8qYK23cMwC1NxJZKOquoD5Sms/pxFZS8YUlKsZ+kmBP6A==
X-Received: by 2002:a1c:df46:: with SMTP id w67mr4379861wmg.69.1560445428894;
        Thu, 13 Jun 2019 10:03:48 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:48 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 14/43] KVM: nVMX: Rename prepare_vmcs02_*_full to prepare_vmcs02_*_rare
Date:   Thu, 13 Jun 2019 19:03:00 +0200
Message-Id: <1560445409-17363-15-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These function do not prepare the entire state of the vmcs02, only the
rarely needed parts.  Rename them to make this clearer.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6f7b572417a4..fb7eddd64714 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1955,7 +1955,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	vmx_set_constant_host_state(vmx);
 }
 
-static void prepare_vmcs02_early_full(struct vcpu_vmx *vmx,
+static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 				      struct vmcs12 *vmcs12)
 {
 	prepare_vmcs02_constant_state(vmx);
@@ -1976,7 +1976,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
-		prepare_vmcs02_early_full(vmx, vmcs12);
+		prepare_vmcs02_early_rare(vmx, vmcs12);
 
 	/*
 	 * PIN CONTROLS
@@ -2130,7 +2130,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	}
 }
 
-static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
 
@@ -2254,7 +2254,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
-		prepare_vmcs02_full(vmx, vmcs12);
+		prepare_vmcs02_rare(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
 	}
 
-- 
1.8.3.1



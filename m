Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF9734E24
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfFDQ7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:59:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44001 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbfFDQ7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:59:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so7608448wrm.10
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 09:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EKCYTdYUbqcJu9i3EJZirzTD5O2uxQ2U+uZgMVDaR6A=;
        b=mYXBu6inbWEc8XAkUVzZPPBDHmLAsDNWG/WmR2qQzpiA7lrr7ZG8g9AomVW2tHfxim
         vI49xG+zmI0yrASqMCa1RvF+t6pFlvZcHDdQ/OPp0ZJiA9B9FHHx8wRBu6M3HRcONk5S
         3e8N4P+S7CH2rXYFFOfOBmDtZ3/uPL88vh14onOiTeZFKfIdbhKG01CYXINofbEs9fQE
         CtZmkTjNHBZFPMJktkciyUHLsVbmU/+8RmlJV/pVuZ56hOKWiVkSGwI8zIenumpxIRKZ
         BZ6lCt6TpfxaKYQ9ziq9HxuGkC2X3dFp8lcAvqo8TVZSKClc7PuKv+dwipUWNDzgRbQV
         UTzw==
X-Gm-Message-State: APjAAAW7LcG2YfJQT6hLMx4uNKkSElSGVv5dlFUsPchcECCrD12bssFf
        Aua2dPBYb6JCTobHqAwxolgThJ4VxxtDEg==
X-Google-Smtp-Source: APXvYqz7dlJsNZq75A+mF0pRAPY9uCleP7A20f0COgWbpMWntYayFz1ZRRAPvbfM3AZGnDdUgbVtxw==
X-Received: by 2002:a5d:404a:: with SMTP id w10mr3205526wrp.177.1559667568398;
        Tue, 04 Jun 2019 09:59:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id c14sm17740912wrt.45.2019.06.04.09.59.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 09:59:27 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <501ef28f-7463-7f49-c219-1c3fdd8cc476@redhat.com>
Date:   Tue, 4 Jun 2019 18:59:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558418814-6822-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/19 08:06, Wanpeng Li wrote:
> 
> The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit,
> CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
> kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
> guest visibility.

This needs some adjustment so that the default is backwards-compatible:

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e3ae96b52a16..f9b021e16ebc 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -378,11 +378,11 @@ struct kvm_sync_regs {
 	struct kvm_vcpu_events events;
 };
 
-#define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
-#define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
-#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
-#define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
-#define KVM_X86_QUIRK_MISC_ENABLE_MWAIT (1 << 4)
+#define KVM_X86_QUIRK_LINT0_REENABLED	   (1 << 0)
+#define KVM_X86_QUIRK_CD_NW_CLEARED	   (1 << 1)
+#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
+#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f54d266fd3b5..bfa1341ce6f1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -137,10 +137,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
-	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT)) {
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
 		if (best) {
-			if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT)
+			if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_NO_MWAIT)
 				best->ecx |= F(MWAIT);
 			else
 				best->ecx &= ~F(MWAIT);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 528935733fe0..0c1498da46c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2548,17 +2548,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
-		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT) &&
-			((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
-			if ((vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT) &&
-				!(data & MSR_IA32_MISC_ENABLE_MWAIT)) {
-				if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-					return 1;
-			}
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
+		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_NO_MWAIT)) {
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
+				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
 			kvm_update_cpuid(vcpu);
+		} else {
+			vcpu->arch.ia32_misc_enable_msr = data;
 		}
-		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)

Please double check, in the meanwhile I've queued the patch.

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE9100B59
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKRSSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 13:18:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36026 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfKRSR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 13:17:57 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so20696649wrx.3;
        Mon, 18 Nov 2019 10:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z7VePZDzHZowJGl/xdI66FEXu09OjvRm1SCaKoiUlYY=;
        b=MmOnOlVQXb3YjJpoGh+JssyXMzCkneqaTzSSQD2LGy1yLTFm4Vk22ckhfdb1TQo3HK
         cNJDJ3Zgc4+31Nskwok/dPx+U3wqf/AwHPXf6ps7rfg2uTt7Mmj3HYatI/lAykmzaxCw
         kUAHWbZZDj2IQvVK7+839zlQSMbBUNOtE6CYCs5rLFvadNOQ05YNnCwfB7Pkxobq095Z
         6Kd69+ZB07IO+0IZhX1BEu6MDiRd/j9WqqXjDp4vj+XGlIIoSpdXTEIfvwf4ct7wIkvL
         DJyYjJBsOvlakNRq7MnwytVKab2SoR9oK5cb046X2k4xZ0gInv92+3Dk8NwE/wJjKrAK
         9Ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=z7VePZDzHZowJGl/xdI66FEXu09OjvRm1SCaKoiUlYY=;
        b=SL6wYYYNDVLidX0D4UJnYfakRMlaMtPaB3IWvuwCWVS3dzzMO2c3NthdWq+rSL3uWC
         Z95wCJwbYFYCRb770stPeFbxHulHDHrZMq9ONKjApApaPFRoSrsNSTVqT0T5pdjt7Hxz
         XQ1NTfWhpP+WJ8791pXF69LF5sIBYjAllvYFU4GrmcvZfSZn/o2LzXKRJwc8RB2iGgEG
         2dA5ZZsJosNJLF1VuS7WUPpBulUG9VuwijO7/KW0cmocTPu6A1V4rWBmP3Tg2Js2aNjD
         o6TCOCL+1qj5xiiDP/J0y5+Mzy/kBndaC8FCRjY12hFE3diTvlFR7jG3X5bS7R9bth4e
         CrjA==
X-Gm-Message-State: APjAAAW99669/8caKG07nNYgdTE74yxxHMPuaLlvk8ZlBmVRi4N3KHmJ
        zMYkXL/zvM+qb10RUGjqxGCoG0t5
X-Google-Smtp-Source: APXvYqw8+ENLIUm+Zb/NqcXDUObYJmBSpwkdCTObnDu8In3EEB/WhU6PvL+U9y6zpw8cx3KVAaM7xg==
X-Received: by 2002:a5d:54cb:: with SMTP id x11mr32671074wrv.161.1574101075378;
        Mon, 18 Nov 2019 10:17:55 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:54 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4/5] KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality
Date:   Mon, 18 Nov 2019 19:17:46 +0100
Message-Id: <1574101067-5638-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current guest mitigation of TAA is both too heavy and not really
sufficient.  It is too heavy because it will cause some affected CPUs
(those that have MDS_NO but lack TAA_NO) to fall back to VERW and
get the corresponding slowdown.  It is not really sufficient because
it will cause the MDS_NO bit to disappear upon microcode update, so
that VMs started before the microcode update will not be runnable
anymore afterwards, even with tsx=on.

Instead, if tsx=on on the host, we can emulate MSR_IA32_TSX_CTRL for
the guest and let it run without the VERW mitigation.  Even though
MSR_IA32_TSX_CTRL is quite heavyweight, and we do not want to write
it on every vmentry, we can use the shared MSR functionality because
the host kernel need not protect itself from TSX-based side-channels.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 34 +++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c     | 23 +++++------------------
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04a8212704c1..ed25fe7d5234 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -450,6 +450,7 @@ noinline void invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
 	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
+	MSR_IA32_TSX_CTRL,
 };
 
 #if IS_ENABLED(CONFIG_HYPERV)
@@ -1683,6 +1684,9 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	index = __find_msr_index(vmx, MSR_TSC_AUX);
 	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
 		move_msr_up(vmx, index, save_nmsrs++);
+	index = __find_msr_index(vmx, MSR_IA32_TSX_CTRL);
+	if (index >= 0)
+		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
 	vmx->guest_msrs_ready = false;
@@ -1782,6 +1786,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_TSX_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
+			return 1;
+		goto find_shared_msr;
 	case MSR_IA32_UMWAIT_CONTROL:
 		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
 			return 1;
@@ -1884,8 +1893,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
-		/* Else, falls through */
+		goto find_shared_msr;
 	default:
+	find_shared_msr:
 		msr = find_msr_entry(vmx, msr_info->index);
 		if (msr) {
 			msr_info->data = msr->data;
@@ -2001,6 +2011,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
+	case MSR_IA32_TSX_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
+			return 1;
+		if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
+			return 1;
+		goto find_shared_msr;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -2152,8 +2169,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		/* Check reserved bit, higher 32 bits should be zero */
 		if ((data >> 32) != 0)
 			return 1;
-		/* Else, falls through */
+		goto find_shared_msr;
+
 	default:
+	find_shared_msr:
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
 			u64 old_msr_data = msr->data;
@@ -4234,7 +4253,16 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 			continue;
 		vmx->guest_msrs[j].index = i;
 		vmx->guest_msrs[j].data = 0;
-		vmx->guest_msrs[j].mask = -1ull;
+
+		switch (index) {
+		case MSR_IA32_TSX_CTRL:
+			/* No need to pass TSX_CTRL_CPUID_CLEAR through.  */
+			vmx->guest_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			break;
+		default:
+			vmx->guest_msrs[j].mask = -1ull;
+			break;
+		}
 		++vmx->nmsrs;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 648e84e728fc..fc54e3905fe3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1314,29 +1314,16 @@ static u64 kvm_get_arch_capabilities(void)
 		data |= ARCH_CAP_MDS_NO;
 
 	/*
-	 * On TAA affected systems, export MDS_NO=0 when:
-	 *	- TSX is enabled on the host, i.e. X86_FEATURE_RTM=1.
-	 *	- Updated microcode is present. This is detected by
-	 *	  the presence of ARCH_CAP_TSX_CTRL_MSR and ensures
-	 *	  that VERW clears CPU buffers.
-	 *
-	 * When MDS_NO=0 is exported, guests deploy clear CPU buffer
-	 * mitigation and don't complain:
-	 *
-	 *	"Vulnerable: Clear CPU buffers attempted, no microcode"
-	 *
-	 * If TSX is disabled on the system, guests are also mitigated against
-	 * TAA and clear CPU buffer mitigation is not required for guests.
+	 * On TAA affected systems:
+	 *      - nothing to do if TSX is disabled on the host.
+	 *      - we emulate TSX_CTRL if present on the host.
+	 *	  This lets the guest use VERW to clear CPU buffers.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_RTM))
-		data &= ~ARCH_CAP_TAA_NO;
+		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
 	else if (!boot_cpu_has_bug(X86_BUG_TAA))
 		data |= ARCH_CAP_TAA_NO;
-	else if (data & ARCH_CAP_TSX_CTRL_MSR)
-		data &= ~ARCH_CAP_MDS_NO;
 
-	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
-	data &= ~ARCH_CAP_TSX_CTRL_MSR;
 	return data;
 }
 EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
-- 
1.8.3.1



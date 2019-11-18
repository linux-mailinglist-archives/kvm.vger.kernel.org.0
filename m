Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17012100B4C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKRSSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 13:18:01 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33552 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKRSR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 13:17:59 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so20714454wrr.0;
        Mon, 18 Nov 2019 10:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jpG2kEyEJHc8/CbQPiWfOD/+xRzsS5WNXU8AFKfy8Cg=;
        b=EMsOtal5IxuXRR6Ovh9l1jsckcRu6ANKKAO4xosjmjDrrOT5p1sN4prnJYcTztqv20
         6jdjXPjqdT1deIscnpJeu5rIgUQ7ARgpvbI0jUwKDRw0xFaQoGA52n6lHGu0wN4DHJqS
         uCQFu/du47+++EaynzJ/qMUpl0+kK0FSW1PqwTDu9MgtU/54v8HyCp94AHUqSaNcYz8T
         z4d4vaascf+LHRW2vVrQR6cGRDCeI7dIomeSDy1B5x1dkstq1Qq6J2PTQSMEm1J+Hp7A
         ZhB/UgBM2/VqrB2ygn7T8qWnZmpFweWAmy6bVkmWq4vqO8ByG/f/vbgdii3tHTVgrwao
         JyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=jpG2kEyEJHc8/CbQPiWfOD/+xRzsS5WNXU8AFKfy8Cg=;
        b=QwKOGHYbETGJCXRmXKLEHWr/mx/gHh7s6Sy05cSwkRNu4IpxoTXaG+5umcVYTevgsF
         h6awhhvklewSoiNtojo0I5UnEsYjzcVrvM6aYSVlS4vSuFqwX6RNQh3U1J/saMePZ9Wh
         yb1gxapFkJlpdWGKlUOW0rqgTRCC/vUjpN68ZDllPFv3/maauWjfpiwsn6vVKPF1GPyk
         7iEvs4JxWql7UeQLt0dj0ISuR19TdTjBsuRJVNkuGuTBy1hCqVMVrmis1WqrijjmVXid
         r9sT5hgpznBNT8xWGRC94MYXn2Kd1ScyLN0m1po4t0kGcI1uEa8gsMamh5pKscfyYiRN
         Ayfg==
X-Gm-Message-State: APjAAAXnBXE0hNaAxDsglQzFvBPXTEtwKEr7e7GiS+Tu+X2N/bBcmjp4
        BbhNsA6mteiRREQK1CPg0wWtAmrc
X-Google-Smtp-Source: APXvYqxRMPUdmTzKr9fbr/6UsyRvQMFo7cWSZV09SuiPptY2AUJ+tlECky1XRY2ahQqroDirkyHvQA==
X-Received: by 2002:a5d:5686:: with SMTP id f6mr32984073wrv.231.1574101076166;
        Mon, 18 Nov 2019 10:17:56 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:55 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5/5] KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable TSX on guest that lack it
Date:   Mon, 18 Nov 2019 19:17:47 +0100
Message-Id: <1574101067-5638-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If X86_FEATURE_RTM is disabled, the guest should not be able to access
MSR_IA32_TSX_CTRL.  We can therefore use it in KVM to force all
transactions from the guest to abort.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ed25fe7d5234..8cba65eec0d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -639,6 +639,23 @@ struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 	return NULL;
 }
 
+static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr, u64 data)
+{
+	int ret = 0;
+
+	u64 old_msr_data = msr->data;
+	msr->data = data;
+	if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
+		preempt_disable();
+		ret = kvm_set_shared_msr(msr->index, msr->data,
+					 msr->mask);
+		preempt_enable();
+		if (ret)
+			msr->data = old_msr_data;
+	}
+	return ret;
+}
+
 void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 {
 	vmcs_clear(loaded_vmcs->vmcs);
@@ -2174,20 +2191,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 	find_shared_msr:
 		msr = find_msr_entry(vmx, msr_index);
-		if (msr) {
-			u64 old_msr_data = msr->data;
-			msr->data = data;
-			if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
-				preempt_disable();
-				ret = kvm_set_shared_msr(msr->index, msr->data,
-							 msr->mask);
-				preempt_enable();
-				if (ret)
-					msr->data = old_msr_data;
-			}
-			break;
-		}
-		ret = kvm_set_msr_common(vcpu, msr_info);
+		if (msr)
+			ret = vmx_set_guest_msr(vmx, msr, data);
+		else
+			ret = kvm_set_msr_common(vcpu, msr_info);
 	}
 
 	return ret;
@@ -7138,6 +7145,15 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
+
+	if (boot_cpu_has(X86_FEATURE_RTM)) {
+		struct shared_msr_entry *msr;
+		msr = find_msr_entry(vmx, MSR_IA32_TSX_CTRL);
+		if (msr) {
+			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
+			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
+		}
+	}
 }
 
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
-- 
1.8.3.1


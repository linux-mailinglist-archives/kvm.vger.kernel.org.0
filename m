Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08497100B50
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 19:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKRSSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 13:18:05 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42052 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKRSSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 13:18:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so20684644wrf.9;
        Mon, 18 Nov 2019 10:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2HUFJLIZjUtoKz36+3lGPkEKaVezwkcvwNllb+a7/YQ=;
        b=jO/oc17SOAruLzuU5AFEJpHCJ5Pp0TYCRA+w7GAhhd54oCy+GqK4u8NQGJG7aiP79/
         Kqn7lc9v7uvn4eLKPgmvAvSkruoqcXmBWinTqKqDT3HaBXOQjEBq6OK1pKewxRh50Nqd
         kMkkzPMRMriaR9vgd9oGaG43sV9e0zU17lPSqHttBiQzUlgcueSAoIvEVJow3jznX8g8
         Dc7gl+y+FWNLqe5KKEBYVeB+DjUdLGypQGssqp56R1T9xvBQDnJXzvRQxrQJuAvsZeuK
         8a/VGHASK/fVRpmlXtX2DYai57gEQUpNvY/n2UinxLGjQfr7UN73V8E7Xo8fLsCqfj/Y
         PcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=2HUFJLIZjUtoKz36+3lGPkEKaVezwkcvwNllb+a7/YQ=;
        b=RGz314RrYHs1PQxOWzWvl68GU86TYBgQLRGazMsNxlVNkMFbcMHpa7T4r4T3Z9ZJzx
         aYMYoRd+pwkM+/Knf6saJT5BTZfNoRklPFXcPsWKDzzU7RjHv1CG9PqgnImk98GLiK5J
         AvYEZHof7f85lMF1eWvbXoYW7ESlsk+woHhahTXT5As30q3qHH7vHbJXeP0HUyFTl1iu
         soPis8vSWGmiu2TN3edmDw/T1dupHqgzIb0uNvItbV7Evu+BZQDKplFTC03HPMrDG0nR
         MfzKb1ELD0QpT9cNbGBolXaX2HutktrkkXU5BPSuiEyOUoB3xHOnc0wWOIBaG3PjSSXW
         RIwA==
X-Gm-Message-State: APjAAAUP0TyIfSm1Ui2uB+n7Q4O8F/m+w2WLTCIR9Ei06BBXMEzoRMRV
        FHlZgg5d3oyh87WuNFgG/k4aIdeQ
X-Google-Smtp-Source: APXvYqzzbR7nPca/Caq8V6IMvadnST9fn6aw0yxe95FM8V4NlR+9bLv2rIwQ1tTIACzzrKOTIzIEpg==
X-Received: by 2002:adf:9f43:: with SMTP id f3mr32188486wrg.76.1574101074605;
        Mon, 18 Nov 2019 10:17:54 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:53 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 3/5] KVM: x86: implement MSR_IA32_TSX_CTRL effect on CPUID
Date:   Mon, 18 Nov 2019 19:17:45 +0100
Message-Id: <1574101067-5638-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because KVM always emulates CPUID, the CPUID clear bit
(bit 1) of MSR_IA32_TSX_CTRL must be emulated "manually"
by the hypervisor when performing said emulation.

Right now neither kvm-intel.ko nor kvm-amd.ko implement
MSR_IA32_TSX_CTRL but this will change in the next patch.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 8 ++++++--
 arch/x86/kvm/x86.c              | 4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fc61483919a..663d09ac7778 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1357,6 +1357,7 @@ int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
+int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f68c0c753c38..c0aa07487eb8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -816,8 +816,6 @@ static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
 	return __do_cpuid_func(entry, func, nent, maxnent);
 }
 
-#undef F
-
 struct kvm_cpuid_param {
 	u32 func;
 	bool (*qualifier)(const struct kvm_cpuid_param *param);
@@ -1015,6 +1013,12 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*ebx = entry->ebx;
 		*ecx = entry->ecx;
 		*edx = entry->edx;
+		if (function == 7 && index == 0) {
+			u64 data;
+		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+			    (data & TSX_CTRL_CPUID_CLEAR))
+				*ebx &= ~(F(RTM) | F(HLE));
+		}
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02863998af91..648e84e728fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1484,8 +1484,8 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
-			 bool host_initiated)
+int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+		  bool host_initiated)
 {
 	struct msr_data msr;
 	int ret;
-- 
1.8.3.1



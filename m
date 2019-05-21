Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87E247C1
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 08:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfEUGHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 02:07:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46550 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfEUGHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 02:07:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so7987048pgb.13;
        Mon, 20 May 2019 23:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMmDh5ublSWiaoVJ7xAuxbCA1uJ5y/sAAbLy4QWe0yE=;
        b=cttOljSYk+vMwjaiHb8qs6lDzVkinsv9NdsfmzJCnvtV4G1hq2AWTZbnjNtY/9VsET
         tmt4twqqjni2qgRmV9cgah1IclAmaW8SOJz5pzmsLSRCbQSL+M3lcp5CSfvmRDpf5Ykc
         1KgHReDOrt3p8/KoQ75pnQn8fG6Uqjyz9texu+3t8H253KjxHVUhIFeyuI1ok3f8zQmh
         ik6i8b9WT0h9m7TNjLDc7Gzl017CP3XHQdSDp8WHflcjTulBIM4GMWia4AtFD3Iqrk/Q
         fjU54rMj3IrmnVkWI1iO/9GL1xu1qjdpIrKmNBKeLmEj5esMcJyqDHl/ddCh52GYcDbS
         o6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMmDh5ublSWiaoVJ7xAuxbCA1uJ5y/sAAbLy4QWe0yE=;
        b=ZWMa4+5kfj1DBT1GOMqw+V7q/f9C72OaG07usDJ0IfDltEYqJYChZZn6HkNa3PFBF0
         bfArsUCLH26bzNikj7kO7Lb40+Z+V2kq1SZ2TsusUwH9qJHSfXNk2XMN5DJUQ7EoOr5k
         KsiH+xP3gJ5BgXiayRxI0AkikPj45ElsruTWQ6pvRlf2EwUwDSTClYSzM3j+6HUslWBU
         p18a4omdskVgmMPu1wbp9ezSM/6X32INKyUGPOAllcTB2jKLOyMJPUznFsd7Yp4HkpcM
         htr4tLicrdNQzj4llCmbyaZQgQECVNo1DFEDdjPhE4h6iB0rEYHT2lGtApCwC+Wgx8Ge
         NEqw==
X-Gm-Message-State: APjAAAXajx7QXhioIzwNRfwrdFYAGwz9lZPehVGXPuTcbxzRFtJxhESw
        oJFizZniI5Ta3DnJzHvofnYWQUst
X-Google-Smtp-Source: APXvYqzpfv0DvbWjagjfN8oSkahd2AdQkFRkh8YKneIumuxFFobNOVb9Wln528UFGPNSiXTJun2Pnw==
X-Received: by 2002:a62:6585:: with SMTP id z127mr45612843pfb.179.1558418822658;
        Mon, 20 May 2019 23:07:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id a15sm2351484pgv.4.2019.05.20.23.07.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 23:07:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 2/3] KVM: X86: Provide a capability to disable cstate msr read intercepts
Date:   Tue, 21 May 2019 14:06:53 +0800
Message-Id: <1558418814-6822-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Allow guest reads CORE cstate when exposing host CPU power management capabilities 
to the guest. PKG cstate is restricted to avoid a guest to get the whole package 
information in multi-tenant scenario.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * use a separate bit for KVM_CAP_X86_DISABLE_EXITS

 Documentation/virtual/kvm/api.txt | 1 +
 arch/x86/include/asm/kvm_host.h   | 1 +
 arch/x86/kvm/vmx/vmx.c            | 6 ++++++
 arch/x86/kvm/x86.c                | 5 ++++-
 arch/x86/kvm/x86.h                | 5 +++++
 include/uapi/linux/kvm.h          | 4 +++-
 tools/include/uapi/linux/kvm.h    | 4 +++-
 7 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 33cd92d..91fd86f 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4894,6 +4894,7 @@ Valid bits in args[0] are
 #define KVM_X86_DISABLE_EXITS_MWAIT            (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
+#define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5457c7..1ce8289 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -882,6 +882,7 @@ struct kvm_arch {
 	bool mwait_in_guest;
 	bool hlt_in_guest;
 	bool pause_in_guest;
+	bool cstate_in_guest;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0861c71..da24f18 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6637,6 +6637,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	if (kvm_cstate_in_guest(kvm)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	}
 	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 202048e..765fe59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3098,7 +3098,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_TSC_STABLE;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE;
+		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
+		      KVM_X86_DISABLE_EXITS_CSTATE;
 		if(kvm_can_mwait_in_guest())
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 		break;
@@ -4612,6 +4613,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.hlt_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+			kvm->arch.cstate_in_guest = true;
 		r = 0;
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0..275b3b6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -333,6 +333,11 @@ static inline bool kvm_pause_in_guest(struct kvm *kvm)
 	return kvm->arch.pause_in_guest;
 }
 
+static inline bool kvm_cstate_in_guest(struct kvm *kvm)
+{
+	return kvm->arch.cstate_in_guest;
+}
+
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b4..c2152f3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -696,9 +696,11 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
+#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE)
+                                              KVM_X86_DISABLE_EXITS_PAUSE | \
+                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 6d4ea4b..ef3303f 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -696,9 +696,11 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
+#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE)
+                                              KVM_X86_DISABLE_EXITS_PAUSE | \
+                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.7.4


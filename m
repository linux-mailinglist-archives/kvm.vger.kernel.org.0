Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092EC46D21
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2019 02:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfFOAN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 20:13:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38262 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFOAN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 20:13:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so4187960wrs.5;
        Fri, 14 Jun 2019 17:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IIP1/YvYoY92mUfSqOCesL/m+06w4rNNJnBcAjHL0iM=;
        b=JYeNrkiNcBDnRy47zYB7oBeGqPPZDAr1nukQ3TVL0JTGpHNYqXrPcJfXthyjCniRG5
         QqBpTNKxCmLRpdL2WX7+FPbyoS4xg08Qb09o7oPc3Q+IKLE2k8EQD5J5Q27nPhal1QU3
         fDeWrqE/bKJVLH0IDcPhtvSH/x2Y1Gx+iGoE+mnxsaBXtCVWKA+qrKTCaFcJAUKs09+0
         zVpybWUzNtF5UiVaIhTGayzM4FxPht7tey1VrK1sen0qnUv43OvzxnPaIHsXCyXVcqCi
         bKXKi+KRJx54r2a/ksSNLTl11g3nSx02azM6YgG+e+PYMfiBFWPZx70Mx56YlddIpwZC
         RbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=IIP1/YvYoY92mUfSqOCesL/m+06w4rNNJnBcAjHL0iM=;
        b=arlSFa0iXYAB2DzDZMLDPwhljmrvmaxqbK/xqXdPXD5vj78vRp1m6XA8V/G+AFyB9v
         rphVNUtMXxiR0D31k5/hH3AI4hDASeHHIO80qHb0pcm1qBE6Y8tvqncd8yP7e5D0cSqZ
         N/9yAqfthA2ZLew1icJgyrHxKaBdLlgQ5r/jJ54TABPVrNjanApV9nRumSdKXqFaKF6s
         otwy/ftgLeNLGNdv5Pehcpbgdkf5WL+l+5GFqUwRNlmbICNJG0nguKteeEyfa6GI0edf
         IuBj4w5sPOqPWXT3JrxcyFttoe64RpYdDB/6jl5rxF686EuPinVR0af8EGYJTkO4RAuL
         1mlQ==
X-Gm-Message-State: APjAAAWveakQGDBAOlTVMTjxyFENNtwvUE7LNq/iWrqxBrabQ+twp1Xf
        AQ8T7636Pn3KPDVkJuFyK4gXgbxn
X-Google-Smtp-Source: APXvYqwWPgLwgMMlsIhJPF/R2iJnnlgj0seuShzihkDe1jsYQ3xm+5mCY9qtwFzYjSxsUVdKOSRL9w==
X-Received: by 2002:a5d:5582:: with SMTP id i2mr16218961wrv.209.1560557603364;
        Fri, 14 Jun 2019 17:13:23 -0700 (PDT)
Received: from donizetti.lan ([2001:b07:6468:f312:1da0:213e:1763:a1a8])
        by smtp.gmail.com with ESMTPSA id z19sm3203367wmi.7.2019.06.14.17.13.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 17:13:22 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: improve definition of KVM_GET/SET_NESTED_STATE structs
Date:   Sat, 15 Jun 2019 02:13:24 +0200
Message-Id: <20190615001324.4776-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran sent me a patch with a large overhaul of the
KVM_GET/SET_NESTED_STATE structs.  However, I am wary of changing the
userspace ABI in backwards-incompatible ways, so here is the bare minimum
that is needed to achieve the same functionality.

Namely, the format of VMX nested state is detailed in a struct, and is
accessible through struct kvm_vmx_nested_state.  Unfortunately, to avoid
changing the size of the structs it has to be accessed as "vmx.data[0]"
rather than just "vmx.data".

Also, the values of the "format" field are defined as macros, which is
easy and not controversial.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 11 +++++++++++
 arch/x86/kvm/vmx/nested.c       |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7a0e64ccd6ff..06b8727a3b58 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -383,6 +383,9 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
 
+#define KVM_STATE_NESTED_FORMAT_VMX	0
+#define KVM_STATE_NESTED_FORMAT_SVM	1
+
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
@@ -390,6 +393,11 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
+struct kvm_vmx_nested_state_data {
+	__u8 vmcs12[0x1000];
+	__u8 shadow_vmcs12[0x1000];
+};
+
 struct kvm_vmx_nested_state {
 	__u64 vmxon_pa;
 	__u64 vmcs_pa;
@@ -397,6 +405,9 @@ struct kvm_vmx_nested_state {
 	struct {
 		__u16 flags;
 	} smm;
+
+	__u8 pad[120 - 18];
+	struct kvm_vmx_nested_state_data data[0];
 };
 
 /* for KVM_CAP_NESTED_STATE */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c601d079cd2..d97b87ef209b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5269,6 +5269,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.vmx.vmcs_pa = -1ull,
 	};
 
+	BUILD_BUG_ON(sizeof(struct kvm_vmx_nested_state)
+		     != sizeof_field(struct kvm_nested_state, pad));
+
 	if (!vcpu)
 		return kvm_state.size + 2 * VMCS12_SIZE;
 
-- 
2.21.0


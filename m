Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39BC4489A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393283AbfFMRJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:09:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33610 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393292AbfFMRDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so21631335wru.0;
        Thu, 13 Jun 2019 10:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MGc1+UMVvTK6r3rG0maNLVulGjfwhlashI6eD08I9Jg=;
        b=dfDBa1LO4SdNR5+tZhpNfnLnRcIwjpXgCDI1yNI272KAI02hY5Fr0napsqg/uMtJDa
         TDSPeVHqldu1X/WSFBj8fPAYdK/bt2UzDzA4UMPF3ukUDkLBes/NJENP5cXmH9M0LYwL
         POpmF7dyYQXdQNAYLetGqm+rNzfW/nf48itkjW9n15+UpShg52DtRQGtY7c7DQb0QU4+
         QIr1GtNYfdwTNJgDwmjftU2vmMkqNOwo5cHmIIHfq+xc99d7zIx0uqMaxIV1vOcdmvX/
         Wnpr5yFvbN79qthqtGwuDfZLJ2rvOmjxndpAlV+wTX9HZpwOYTj6vKt+26muAfhfXZo6
         /MsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=MGc1+UMVvTK6r3rG0maNLVulGjfwhlashI6eD08I9Jg=;
        b=scGsDlaDOo2epfNYbi8YmorJRaNOxV3KjJqaAAYNSOvjlXkhoPWrQECWrG//2WYjYT
         yiz1tNFqDro0ISyDmNd5uaJWMzUW3AoqYvrreLq52Mj2FGOZ8HC4UwSpwirsr+s+HZvt
         eC2rAfX9hbV5dbsshJRCOsbmUTpze/rFsiDPgQW+RqDYink0jYHORq6yOPajylJ6d02Z
         41/yK1YzkepbDvc/I+BMcomePssxa1H9vDO4fhF/2SXK5IqagFnf1SSSpPzxwdSIPzps
         iBt0ucph4HfZaaRlNemAUM3PIz+PLh3OVRkqtc78vUtGDzo1flK+UuOH86ZvfbMd6KMb
         bT2w==
X-Gm-Message-State: APjAAAU1NtIji2rAcqgRiOa6CjwtG6aVaqlxl7qBoJrZCfDcBXw0tukj
        dacNBBTjxTdgr3CrEJu7yZWxE1uF
X-Google-Smtp-Source: APXvYqwH79gLcqKgw4BEZmzr9Udn4RG9BfCiSjEYJxqhHbpDU5Px7ZMpTyPRRuCnOqCC7uxsWifUVg==
X-Received: by 2002:adf:e841:: with SMTP id d1mr61292398wrn.204.1560445418508;
        Thu, 13 Jun 2019 10:03:38 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:37 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 08/43] KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
Date:   Thu, 13 Jun 2019 19:02:54 +0200
Message-Id: <1560445409-17363-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

VMMs frequently read the guest's CS and SS AR bytes to detect 64-bit
mode and CPL respectively, but effectively never write said fields once
the VM is initialized.  Intercepting VMWRITEs for the two fields saves
~55 cycles in copy_shadow_to_vmcs12().

Because some Intel CPUs, e.g. Haswell, drop the reserved bits of the
guest access rights fields on VMWRITE, exposing the fields to L1 for
VMREAD but not VMWRITE leads to inconsistent behavior between L1 and L2.
On hardware that drops the bits, L1 will see the stripped down value due
to reading the value from hardware, while L2 will see the full original
value as stored by KVM.  To avoid such an inconsistency, emulate the
behavior on all CPUS, but only for intercepted VMWRITEs so as to avoid
introducing pointless latency into copy_shadow_to_vmcs12(), e.g. if the
emulation were added to vmcs12_write_any().

Since the AR_BYTES emulation is done only for intercepted VMWRITE, if a
future patch (re)exposed AR_BYTES for both VMWRITE and VMREAD, then KVM
would end up with incosistent behavior on pre-Haswell hardware, e.g. KVM
would drop the reserved bits on intercepted VMWRITE, but direct VMWRITE
to the shadow VMCS would not drop the bits.  Add a WARN in the shadow
field initialization to detect any attempt to expose an AR_BYTES field
without updating vmcs12_write_any().

Note, emulation of the AR_BYTES reserved bit behavior is based on a
patch[1] from Jim Mattson that applied the emulation to all writes to
vmcs12 so that live migration across different generations of hardware
would not introduce divergent behavior.  But given that live migration
of nested state has already been enabled, that ship has sailed (not to
mention that no sane VMM will be affected by this behavior).

[1] https://patchwork.kernel.org/patch/10483321/

Cc: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c             | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0dc9505ae9a2..cd51ef68434e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -91,6 +91,10 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_write_field %x\n",
 			       field + 1);
 
+		WARN_ONCE(field >= GUEST_ES_AR_BYTES &&
+			  field <= GUEST_TR_AR_BYTES,
+			  "Update vmcs12_write_any() to expose AR_BYTES RW");
+
 		/*
 		 * PML and the preemption timer can be emulated, but the
 		 * processor cannot vmwrite to fields that don't exist
@@ -4477,6 +4481,17 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		vmcs12 = get_shadow_vmcs12(vcpu);
 	}
 
+	/*
+	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
+	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
+	 * behavior regardless of the underlying hardware, e.g. if an AR_BYTE
+	 * field is intercepted for VMWRITE but not VMREAD (in L1), then VMREAD
+	 * from L1 will return a different value than VMREAD from L2 (L1 sees
+	 * the stripped down value, L2 sees the full value as stored by KVM).
+	 */
+	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
+		field_value &= 0x1f0ff;
+
 	if (vmcs12_write_any(vmcs12, field, field_value) < 0)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 132432f375c2..97dd5295be31 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -40,14 +40,14 @@
 SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD)
 SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE)
 SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE)
+SHADOW_FIELD_RO(GUEST_CS_AR_BYTES)
+SHADOW_FIELD_RO(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP)
 SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE)
 SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD)
 SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN)
 SHADOW_FIELD_RW(TPR_THRESHOLD)
-SHADOW_FIELD_RW(GUEST_CS_AR_BYTES)
-SHADOW_FIELD_RW(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO)
 SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE)
 
-- 
1.8.3.1



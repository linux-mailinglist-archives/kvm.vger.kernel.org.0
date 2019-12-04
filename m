Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBE711209A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 01:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLDAYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 19:24:53 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:50795 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfLDAYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 19:24:53 -0500
Received: by mail-pl1-f201.google.com with SMTP id c18so2592105plo.17
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 16:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XK0YqNOqBf++GW8F+qSvBh8TlM8iwDKRqB87FNLDCgc=;
        b=tT/Rr/kx2NL+uP/dyMOEO4OkQHXc9vjgXyZcicRSdOUtcdV/73ldlf8aY6lte6i/bb
         KRf3u2MinFH+v3H+jGztK51Od+CxT0PfLNUZnRRFDKv/Qs3unSs19EAohp0f/KCAKE74
         EfBPj/WmQ4/o0gSDUtKUiQHMhI/TN992+Z1vDxmNJRLGBd6kiGWXCoWpQhPGoBWpbzaq
         1EZHAQJEXueQy7kOJKdGAYOjv9oE626KyTkeG6fVSpSo5hSUiG0JcXK4fji+RPFl7NIT
         g2L2Edet2dSmOzSAJ/JIsx2/1BiJXJg4d8yNusg93GzY7rzXb7yOt5yclP8B4kHqDSp0
         BlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XK0YqNOqBf++GW8F+qSvBh8TlM8iwDKRqB87FNLDCgc=;
        b=FBJnWjYRVY8vAj3Mh2c6nfpkT3PQCGPm5IWmcTjb3GZQ/PTuSHCrSDYU+6muovsEwE
         PMA0XnNqFHHyIP4fImu2CM2QC2CuyMUPG6wLmWNf8w9gwryGYKqnB2RLfXzikfreDbjk
         IrP2bchuvGUAQz//9ZpfyVnX0LsybW9sddFXUS2pD4orYNre+904KtbZpKsYeAMza767
         Eu9FiCm6x0BwEb2//CwyAQyZ71zmYV1XYeg9Patz/f8sldezBq9UiknG4FDcm1PiPyMz
         4PECsAFRZycu/t3WnNeYDDNE7kzCoZEp7W+p8/mWB/9s1o7lJgoPQUznkmTjfY0SjM4x
         Uyng==
X-Gm-Message-State: APjAAAW2lwBXyzncmSh4UTsE8UHXKdmTobZZFlGly04zXp2Jkqril2Jp
        /t6wYuTHWOppvphW1cofLKraNrpAmTJHAVGa6ClqNO1iZQqy+aC8pE2O5uQ7Wbl64Pn8UVvVyNc
        bxq1bDIGobvFd1PsYg7mNc4FqZ+KqxXDqYz77w8216ahTyTZ3/K0V/+2mgN/h48k=
X-Google-Smtp-Source: APXvYqymFATEUdEorat4ogLD0EWFv2FYNhX+bHfY/3gn+xxCEeG91yQNlwKI8Z83Vg6OslGl7MfjCBeg3fMKMw==
X-Received: by 2002:a63:de08:: with SMTP id f8mr466986pgg.107.1575419092432;
 Tue, 03 Dec 2019 16:24:52 -0800 (PST)
Date:   Tue,  3 Dec 2019 16:24:42 -0800
Message-Id: <20191204002442.186018-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v2] kvm: vmx: Stop wasting a page for guest_msrs
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will never need more guest_msrs than there are indices in
vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
168 bytes.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
---
v1 -> v2:
  Changed NR_GUEST_MSRS to NR_SHARED_MSRS.
  Added BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS).

 arch/x86/kvm/vmx/vmx.c | 12 ++----------
 arch/x86/kvm/vmx/vmx.h |  8 +++++++-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b9ab4166397d..e3394c839dea6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
-	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
@@ -6723,12 +6722,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			goto uninit_vcpu;
 	}
 
-	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
-		     > PAGE_SIZE);
-
-	if (!vmx->guest_msrs)
-		goto free_pml;
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);
 
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
@@ -6760,7 +6754,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
 	if (err < 0)
-		goto free_msrs;
+		goto free_pml;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
@@ -6822,8 +6816,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
-free_msrs:
-	kfree(vmx->guest_msrs);
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 uninit_vcpu:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7c1b978b2df44..a4f7f737c5d44 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
+#ifdef CONFIG_X86_64
+#define NR_SHARED_MSRS	7
+#else
+#define NR_SHARED_MSRS	4
+#endif
+
 #define NR_LOADSTORE_MSRS 8
 
 struct vmx_msrs {
@@ -206,7 +212,7 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct shared_msr_entry *guest_msrs;
+	struct shared_msr_entry guest_msrs[NR_SHARED_MSRS];
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
-- 
2.24.0.393.g34dc348eaf-goog


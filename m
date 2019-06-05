Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811E13650B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 22:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFEUBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 16:01:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36864 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEUBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 16:01:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id 131so11758082ljf.4
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 13:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=8zXB00VhNFIp3175zI0kYAOVYFwwpLME/T4frTwR03c=;
        b=YxImq76I+Ddii0gTCv92JgmMtP5GMlTGKDklv5tfNM259r1Sejp5WhY3thBdMX2PU8
         sIF866Huc55K47J3heG3sIDGldPQ41T3KlhhKz1e6MBZoD3Axps6ZQbiRvc2jr459ZvE
         Cd1xh7Csg3WeCjwS3k2yyAlt+ak4+L8jYq385pNwZhJs4bZFcDSrjHg3hw6uA/MGt124
         8GFKwxVVmabvgcjv2Zc1oNFaJKFHWZhv85KQ2EIBdtu9cc+tB2ESARbQBzAzg9Qeggkl
         dWQ0LBoQS5xKctsyieHdl6v3uQ+/Mej5oKwN24Z9wrmuM9BETvurm7E8b/YaX8ExWuFd
         7zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=8zXB00VhNFIp3175zI0kYAOVYFwwpLME/T4frTwR03c=;
        b=S16BPQY0dFWtl/s2CgaUa/0EMjRTtFaQVj4DcVSJ1HzaV/9SgMgZyFZin0bzVamjFV
         f2UdcVg8X873eA3oHqzN224Qks+62taV31L4XvDuYrQqgviGiGN5OjLBe5baFgoa6WLK
         XUb27pe0GcVOfbbbzFzgNAtq/7BJezf/B524URuKgRkKIbDyDTrtj3EAmJN1hqXRJbuZ
         uuZGAoPO2zJOplCEytlv7zlU1BKhFpiRBczrLNvod6H4cDxXIgvvJSERXJn7jdJjiP/4
         kgnUGS6seBROYLWKhmrTTy0RMzGTYCaz77ljeL8dINm8Sb5t8W0BVErRi9CpuB4+F1hR
         LLTg==
X-Gm-Message-State: APjAAAWYpQRYxApEv8Y7CyqvtAHrV6wbwNdQIhD5jUU2VOyGmw9hc4IW
        fsKMhShoCrkJ3mj6mCDSqwgEheqZ
X-Google-Smtp-Source: APXvYqwOUEUSmhK8TDlLzGlqFX71QlTJ4sU1sXrpGs9tdkCFStJs+C1Y5D5K8mDTCxj/9pyGDoSkCw==
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr11287421ljk.219.1559764857905;
        Wed, 05 Jun 2019 13:00:57 -0700 (PDT)
Received: from dnote ([5.35.65.245])
        by smtp.gmail.com with ESMTPSA id g15sm4477351ljk.83.2019.06.05.13.00.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 13:00:57 -0700 (PDT)
Date:   Wed, 5 Jun 2019 23:00:55 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 2/2] kvm: vmx: segment limit check: use access length
Message-ID: <20190605200055.GA25739@dnote>
Mail-Followup-To: Eugene Korenevsky <ekorenevsky@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is an imperfection in get_vmx_mem_address(): access length is ignored
when checking the limit. To fix this, pass access length as a function argument.
The access length is obvious since it is used by callers after
get_vmx_mem_address() call.

Note: both handle_vmread() and handle_vmwrite() should use is_long_mode()
instead of is_64_bit_mode() because VMREAD/VMWRITE opcodes are invalid in
compatibility mode and there is no any reason for extra checking CS.L.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
Changes in v2 since v1: fixed logical bug (`len` argument was not used inside
get_vmx_mem_address() function); fixed the subject
Changes in v3 since v2: replace is_64_bit_mode() with is_long_mode() in
handle_vmwrite()

 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  3 ++-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 93df72597c72..2a1be6a4c6eb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4008,7 +4008,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
  * #UD or #GP.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret)
+			u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
 {
 	gva_t off;
 	bool exn;
@@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || (off + sizeof(u64) - 1 > s.limit);
+			exn = exn || (off + len - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
@@ -4134,7 +4134,8 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 	struct x86_exception e;
 
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmcs_read32(VMX_INSTRUCTION_INFO), false, &gva))
+				vmcs_read32(VMX_INSTRUCTION_INFO), false,
+				sizeof(*vmpointer), &gva))
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
@@ -4386,6 +4387,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	u64 field_value;
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	int len;
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
 
@@ -4423,12 +4425,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
 			field_value);
 	} else {
+		len = is_long_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, true, &gva))
+				vmx_instruction_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value,
-					    (is_long_mode(vcpu) ? 8 : 4), NULL);
+		kvm_write_guest_virt_system(vcpu, gva, &field_value, len, NULL);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -4438,6 +4440,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
 	unsigned long field;
+	int len;
 	gva_t gva;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
@@ -4463,11 +4466,11 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
+		len = is_long_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, false, &gva))
+				vmx_instruction_info, false, len, &gva))
 			return 1;
-		if (kvm_read_guest_virt(vcpu, gva, &field_value,
-					(is_64_bit_mode(vcpu) ? 8 : 4), &e)) {
+		if (kvm_read_guest_virt(vcpu, gva, &field_value, len, &e)) {
 			kvm_inject_page_fault(vcpu, &e);
 			return 1;
 		}
@@ -4615,7 +4618,8 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (unlikely(to_vmx(vcpu)->nested.hv_evmcs))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, exit_qual, instr_info, true, &gva))
+	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
+				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
 	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
@@ -4661,7 +4665,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
@@ -4723,7 +4727,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..29d205bb4e4f 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -21,7 +21,7 @@ void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret);
+			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1ac167614032..6ecf9e4de2f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5342,7 +5342,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-				vmx_instruction_info, false, &gva))
+				vmx_instruction_info, false,
+				sizeof(operand), &gva))
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-- 
2.21.0


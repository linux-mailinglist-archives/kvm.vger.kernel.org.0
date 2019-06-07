Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185BB3840E
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 08:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFGGD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 02:03:27 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36144 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfFGGD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 02:03:27 -0400
Received: by mail-lj1-f195.google.com with SMTP id i21so664635ljj.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 23:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=8GpH2/AsoDcjNS5c7qWj4v9T2WnCo4ViW9xFu4Gblkk=;
        b=T+PtGM0wWj4y1IS+yGvIO8iak2dMcl91yDxkIUZQ+00oillVCndvPyfvAty4IzIrOF
         OOrEWhgqTgfxy74CqJZCF2DQhd+cg/PrrF2jneAvLuFTLLX8zlcE8q8lRq0PUzW4yyZN
         lLOoCFjIkUvOI1BeaC/JDJYXOjcTzsy3Gy0LhefiJSKa6RtFPUOzZq9AUkgvAbeof0Kl
         dcacp4dDoCp9bFwLua/xV/GwGPuCi+BoBQJbusoNCY62mQxuh9pZmvwFgMtXKvsXEEeh
         Ic/RjQnMrjTc3k0qkDsLvN7BhKkC0y/BEpfU1HrE6rIOhnCaFdgXw9VSeOC+AvjLCB9w
         /EqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=8GpH2/AsoDcjNS5c7qWj4v9T2WnCo4ViW9xFu4Gblkk=;
        b=Jox2VjqrxZCk6lS4satgCURpCsrQYLyVsT9mbF+mF0jCu0MUYRKy4/3JewY1VqxNyr
         DifVD48RHvdAX8yNEBWq2blf4YfkpW9cUoU3AoeyveKB/NrKZbE6hqdNXukNHhV708Qn
         dl1V9tLqhnzxn6lZtu4gqLfANHsoLjelBAtSxZgCLuCfKlq73SuL3om5QDBzhOe2gwG3
         cy7GwOOfhUIMTeRm37foUx7cd3Q7OKlIObT83kvNciB/mtSF7Ka6yZW129bWqHdD0KNv
         NQQf9xQfLE3CdwA0xJUYoPl4uU4wfXis4IG5ZTQHPiQkMKAsUm3/53fU+8YcoaJ004U/
         HwDQ==
X-Gm-Message-State: APjAAAVCj4vQS3HdVZJAnhV5DuSffobW5DnUDT7d+Eb4RF1SoI5NTe11
        1gzEArQslyW+MMZip+gVOwUjDmYe
X-Google-Smtp-Source: APXvYqy2bXf3rk8cAahe8cm23+3EFqEve6ROdzipLqP4JFpEPDT18ekzSdylN6KKj0mZosnFuurBAQ==
X-Received: by 2002:a2e:824c:: with SMTP id j12mr19175822ljh.53.1559887404538;
        Thu, 06 Jun 2019 23:03:24 -0700 (PDT)
Received: from dnote ([31.173.87.118])
        by smtp.gmail.com with ESMTPSA id p10sm209390ljh.50.2019.06.06.23.03.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 23:03:23 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:03:21 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v5 2/3] kvm: vmx: segment limit check: use access length
Message-ID: <20190607060321.GA29109@dnote>
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

There is an imperfection in get_vmx_mem_address(): access length is
ignored when checking the limit. To fix this, pass access length as a
function argument. The value of access length is obvious since it is
used by callers after get_vmx_mem_address() call.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
Changes in v2 since v1: fixed logical bug (`len` argument was not used inside
get_vmx_mem_address() function); fixed the subject
Changes in v3 since v2: replace is_64_bit_mode() with is_long_mode() in
handle_vmwrite()
Changes in v4 since v3: revert previous change
Changes in v5 since v4: get_vmx_mem_address(): change type of `len` argument
from `int` to `unsigned int`

 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h |  3 ++-
 arch/x86/kvm/vmx/vmx.c    |  3 ++-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a51bff129a8..a2d744427d66 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4008,7 +4008,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
  * #UD or #GP.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret)
+			u32 vmx_instruction_info, bool wr,
+			unsigned int len, gva_t *ret)
 {
 	gva_t off;
 	bool exn;
@@ -4115,7 +4116,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || ((u64)off + sizeof(u64) - 1 > s.limit);
+			exn = exn || ((u64)off + len - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
@@ -4134,7 +4135,8 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 	struct x86_exception e;
 
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmcs_read32(VMX_INSTRUCTION_INFO), false, &gva))
+				vmcs_read32(VMX_INSTRUCTION_INFO), false,
+				sizeof(*vmpointer), &gva))
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
@@ -4386,6 +4388,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	u64 field_value;
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	unsigned int len;
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
 
@@ -4423,12 +4426,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
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
@@ -4438,6 +4441,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
 	unsigned long field;
+	unsigned int len;
 	gva_t gva;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
@@ -4463,11 +4467,11 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
+		len = is_64_bit_mode(vcpu) ? 8 : 4;
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
@@ -4615,7 +4619,8 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (unlikely(to_vmx(vcpu)->nested.hv_evmcs))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, exit_qual, instr_info, true, &gva))
+	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
+				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
 	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
@@ -4661,7 +4666,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
@@ -4723,7 +4728,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..a6cddb0a3564 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -21,7 +21,8 @@ void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret);
+			u32 vmx_instruction_info, bool wr,
+			unsigned int len, gva_t *ret);
 
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


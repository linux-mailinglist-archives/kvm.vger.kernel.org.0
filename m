Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33F35274
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 00:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFDWCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 18:02:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34333 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDWCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 18:02:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id j24so21256169ljg.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=+lABKIPUvfX8cKUr1kiD5ZprxnnCcJls/dac/xOhz94=;
        b=DrEszI6Y58cK6KgNKHq8kcwPiDBUHHt5cEWh67ZUvidPpfUXQQi1zMXsj7tWSbYNn6
         TBhFt0h44nWv0KEPtFKFtiJmEuB+gcF0gptgfQ0g8Cwmdjssbi4uARozJABBQ+zxgiqh
         eSuNSaC4kWHECytPFdW52FRyqbvM1WVPJ090Ek9IhPPEuK0GgEiiUf9ceL7egi4PMsZe
         MulS44hpMiLYSkubIx0NY0DLlbFPwvFsM5pETklpqizsJGYh32H06kMClS2wcRDPi3EC
         8o5pnwpfevS+H50DghvaNQfkLf1GioV86q2YXnbp99INTuw2+8QdWp7NSsiSda5y+ZnK
         TSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=+lABKIPUvfX8cKUr1kiD5ZprxnnCcJls/dac/xOhz94=;
        b=UqKtvrwadvsT2/6HCQm1zm9TciDJX3IrVYnX+AZYZ1pm0xzSYRjkEgESH0zjxurxX8
         liKq5BJCEyk1dORZCj0E6Wb2IY7+xu44K9zvCGxzrDpZIvVUdfHEm+ASHZgktdXlc9el
         pF4fCNSbOMsuLdVHe6Mv9Nl1vPlp6hADWt1RJO8gAg0WW38FooG1IKb52zMvVD1VqIKG
         IKBu2XHNKT8fPjSxGbkeUhCfDHXXclWnCi8e/OAZLipzkGdLqTVoOxXwUQObguSoTwVL
         DXfeL9qP8FcU4ZSBIu+gHPgbeMGNLQcCuQXYVwbEBuKQh7hT/vOehiOSVAmuzLdavxRt
         Ggrw==
X-Gm-Message-State: APjAAAVDvCI22AQ/wNmogPSymu2C0z2uiBV5Dqvcp/T7OFZ1OoEWRYjY
        /3cS27mxB3wVHF7zqVcsupJ4qLmA
X-Google-Smtp-Source: APXvYqxHmJ8xNfB287e+8qbVs6jrIao7pcs7VWWx6sIzDVO0Nb5g9Zs+4aeyLsqkPBAhvyAEFm6GZw==
X-Received: by 2002:a2e:9f41:: with SMTP id v1mr11945542ljk.66.1559685772078;
        Tue, 04 Jun 2019 15:02:52 -0700 (PDT)
Received: from dnote ([5.35.65.245])
        by smtp.gmail.com with ESMTPSA id 21sm3976624ljv.56.2019.06.04.15.02.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 15:02:51 -0700 (PDT)
Date:   Wed, 5 Jun 2019 01:02:48 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 2/2] kvm: vmx: segment limit check: use access length
Message-ID: <20190604220248.GA23569@dnote>
Mail-Followup-To: Eugene Korenevsky <ekorenevsky@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
Changes in v2: fixed logical bug (`len` argument was not used inside
get_vmx_mem_address() function); fixed the subject

 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  3 ++-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fef3d7031715..918629c79c4a 100644
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
-			exn = exn || (off > s.limit + 1 - sizeof(u64));
+			exn = exn || (off > s.limit + 1 - len);
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
+		len = is_64_bit_mode(vcpu) ? 8 : 4;
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


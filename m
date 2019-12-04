Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACA1113725
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 22:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfLDVki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 16:40:38 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:47108 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfLDVki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 16:40:38 -0500
Received: by mail-pj1-f73.google.com with SMTP id u6so581612pjv.14
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 13:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mjcK8lPLhzxkrEpDX3fdUCq0irDtJ+UuKGtrEMM0y18=;
        b=U9dkXQL/FYHvV8r9puFbhF8kHh+wFfJ0CZsq6R5AEBryGmZaEmsQwcj1nMXBoEb1YA
         l/iHJgfVK09JE49Wx78H+wLTzV2wgPOv7MSCbZcjRmJwoyo0JjgMFLTEtpJWyZm2feWq
         Izy9aCDmodC7gys/SfVSmyAGT0BydFAnEJxPy9i4NFwAqlO6hio8WsIa4vUbuJww4S4p
         xrXlteYuuHKmEaV0QIQfIhJxZRpdSuc3URzKmcoLKV5h0MkjigtfgMeG7UCLOklPazeJ
         xdo1Q8YSPlg/cLfz6DnqQ6UJ91hQHZF6AL+z5TMeF+av1fS4tOE5GQBS2vYKJ73OhDRZ
         sHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mjcK8lPLhzxkrEpDX3fdUCq0irDtJ+UuKGtrEMM0y18=;
        b=AXfARloqVHlMkP76rQw03xXYN2mX7fEob2/WCnZcmVfTn8GUQeZOpfJx0GlNDXxMWx
         GOc7RVffPEBJfiiTvGgA4RD7eeWIFE+TOf7NYY/UBfN/vsi+TQsegJm+ygyS86mP4AFJ
         O9JDJ7lwCIdiodfFLVpwwrGaUYLtr0LjLhMZW0KWhplRk9CfRwwXlIWAwUs1GGChzb7b
         bcU+pJfAliW7Xbb9Jr3hmG9+CgX591yoTlhmCXrTKB99vwkCZRiYJznH6ReD8+Ffd5op
         sTAKKkfVEJCJjx5wmaTeJCruuugYVtkV0vHC1hkS9trpfa6k1Kb5YzKV2KuRFGPqydGA
         6Mdg==
X-Gm-Message-State: APjAAAVMBEs89rtE7zCvF4L2IP4dfYvn7mT3tpLNNL6F4ZFFaebIB9aT
        LdiYyclFvkfa6Hz0Rbkwake3ECT40PCFwjJnv4lSnJuJqRiOW20M8mgEDazzvI9pNLf4+vkymx3
        1N3PIV7t53jTfr//hiKxM8GKV5bjjBXiwhSKV8UZdf12+DEEA/q75RjeC5kOE4Rc=
X-Google-Smtp-Source: APXvYqzm+G6CcMvWLqD1xdpShQJi1kDMbzsrDZa8KiTZGEFPrrzrC5uqirwrHlHkeD2vquQHbQTa9d7ETLOPWQ==
X-Received: by 2002:a63:ca4d:: with SMTP id o13mr5688626pgi.360.1575495637340;
 Wed, 04 Dec 2019 13:40:37 -0800 (PST)
Date:   Wed,  4 Dec 2019 13:40:27 -0800
Message-Id: <20191204214027.85958-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, a VMWRITE in VMX non-root operation with an
invalid VMCS-link pointer results in VMfailInvalid before the validity
of the VMCS field in the secondary source operand is checked.

Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..146e1b40c69f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4864,6 +4864,25 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (vmx->nested.current_vmptr == -1ull)
 		return nested_vmx_failInvalid(vcpu);
 
+	if (!is_guest_mode(vcpu)) {
+		vmcs12 = get_vmcs12(vcpu);
+
+		/*
+		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+		 * vmcs12, else we may crush a field or consume a stale value.
+		 */
+		if (!is_shadow_field_rw(field))
+			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+	} else {
+		/*
+		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
+		 * to shadowed-field sets the ALU flags for VMfailInvalid.
+		 */
+		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
+			return nested_vmx_failInvalid(vcpu);
+		vmcs12 = get_shadow_vmcs12(vcpu);
+	}
+
 	if (vmx_instruction_info & (1u << 10))
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
@@ -4889,25 +4908,6 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu)) {
-		vmcs12 = get_vmcs12(vcpu);
-
-		/*
-		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
-		 * vmcs12, else we may crush a field or consume a stale value.
-		 */
-		if (!is_shadow_field_rw(field))
-			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
-
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
 		return nested_vmx_failValid(vcpu,
-- 
2.24.0.393.g34dc348eaf-goog


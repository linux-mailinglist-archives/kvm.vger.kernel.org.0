Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6316AFC5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 19:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgBXS4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 13:56:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33271 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBXS4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 13:56:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so11710506wrt.0;
        Mon, 24 Feb 2020 10:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w9zV191iFIzgVf2uJex71w1ZLs3Fj/CvGHCv2DEAjG4=;
        b=JXQW4VAozluhvyt3S72RHfXszgcYK0wN+RLSNY9LMAaD+H9LpZh8BKeaocbIjrHwWH
         tqub/StDtuy7Wtw6zMbvLXucpg6FnHYAu0yEVGYUlLou6AAJ93sgSc+0dHwDLVTOBbxK
         HaAIlxZYm7Ucz9z5rPVRmL2M3auC9CBmQSWKociHoVRDKhzLY9Qt52gmoIIe3dCKbFF1
         oZDWQGY0T8tLx/m0ogM+9OC5il04mkkcnpCr0saxYy/MzxKZvUT2lwEbUuoDEzkmm85r
         8oemZqHilTT9PXcP3AmUssENARryBwae3PtQfXZHQlJCVBhdcYijJJcCe23i/pZOifcn
         Livg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=w9zV191iFIzgVf2uJex71w1ZLs3Fj/CvGHCv2DEAjG4=;
        b=PBtzof5TUd6FWvrx6gzopEJymArRyIRoxKakB64LjjcBj+++QLdysG0OswO0nmpKtB
         PuoimAh+eyLHwIiPe6MhOFnJ1k81tQLSVQ+2YxPuVXwrhYqk7b6RBQXIA47xtfSx2fYO
         gUDc7tBIxJAdPlUYL+n4AsFHk2EebNLtVnzXFA4x7zandPdrHo2AXoiKKgWHIXkeMnV3
         iR3ChSxD9RS57k1HS+hbc6R7Gs6UXbLsYfX1cOcdvmHMtsEzC9p2hwrUzEc/6XzXNDQY
         TnGE+2thy3CiFMmrb6J/QqteLZbRL8hyRK++F7H0E1QZzKlOgFOmusnD6c/dcxMcF7Vs
         1trQ==
X-Gm-Message-State: APjAAAX3zIzoKJQFmmX011zwYBhW+nyM66bTQ64FDgLI6O+j2bnlznid
        /OCLGK3qVHt8akkS9oDSfwY7lGw7
X-Google-Smtp-Source: APXvYqzaGtuqrAnDC33YD008DTvWW7rLyI9ADFirl4w+sEOfmdD4j0NSvu9sahbRuFHXtFStIQJ5kQ==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr3123597wrk.407.1582570601249;
        Mon, 24 Feb 2020 10:56:41 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z8sm19900838wrv.74.2020.02.24.10.56.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:56:40 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: [FYI PATCH 3/3] KVM: nVMX: Check IO instruction VM-exit conditions
Date:   Mon, 24 Feb 2020 19:56:36 +0100
Message-Id: <1582570596-45387-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

Consult the 'unconditional IO exiting' and 'use IO bitmaps' VM-execution
controls when checking instruction interception. If the 'use IO bitmaps'
VM-execution control is 1, check the instruction access against the IO
bitmaps to determine if the instruction causes a VM-exit.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 57 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f979832c394d..e920d7834d73 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5353,7 +5353,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
 	unsigned long exit_qualification;
-	unsigned int port;
+	unsigned short port;
 	int size;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5801a86f9c24..63aaf44edd1f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7145,6 +7145,39 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 	to_vmx(vcpu)->req_immediate_exit = true;
 }
 
+static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
+				  struct x86_instruction_info *info)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	unsigned short port;
+	bool intercept;
+	int size;
+
+	if (info->intercept == x86_intercept_in ||
+	    info->intercept == x86_intercept_ins) {
+		port = info->src_val;
+		size = info->dst_bytes;
+	} else {
+		port = info->dst_val;
+		size = info->src_bytes;
+	}
+
+	/*
+	 * If the 'use IO bitmaps' VM-execution control is 0, IO instruction
+	 * VM-exits depend on the 'unconditional IO exiting' VM-execution
+	 * control.
+	 *
+	 * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
+	 */
+	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
+		intercept = nested_cpu_has(vmcs12,
+					   CPU_BASED_UNCOND_IO_EXITING);
+	else
+		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
+
+	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
+}
+
 static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage)
@@ -7152,18 +7185,30 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 
+	switch (info->intercept) {
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
 	 */
-	if (info->intercept == x86_intercept_rdtscp &&
-	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
-		ctxt->exception.vector = UD_VECTOR;
-		ctxt->exception.error_code_valid = false;
-		return X86EMUL_PROPAGATE_FAULT;
-	}
+	case x86_intercept_rdtscp:
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
+			ctxt->exception.vector = UD_VECTOR;
+			ctxt->exception.error_code_valid = false;
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+		break;
+
+	case x86_intercept_in:
+	case x86_intercept_ins:
+	case x86_intercept_out:
+	case x86_intercept_outs:
+		return vmx_check_intercept_io(vcpu, info);
 
 	/* TODO: check more intercepts... */
+	default:
+		break;
+	}
+
 	return X86EMUL_UNHANDLEABLE;
 }
 
-- 
1.8.3.1


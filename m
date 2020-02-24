Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0016AFC6
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 19:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBXS4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 13:56:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44266 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgBXS4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 13:56:43 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so11646544wrx.11;
        Mon, 24 Feb 2020 10:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gkvBXvzMhYSRTcZy4oNhDjYmBjZXTwydzqi0XRBUfwo=;
        b=ndr627BAdd19splYc1OkL4rR05y/Phvxmg6Rt5sEL/5+MjOb5ISJv1i1U4hzHcmV2C
         bPY/rlhwWC9X7Ni8ZrBsMXyHGv1wByCDHb/j7VW/dUR8FQHU/yLCf0wJkxpeZLJl+o2o
         9kEzQHOJ/85Q/Q9ZDPEdHasHZWJhood0QXB0Lja6ORXzlW+TxKdEOs1iO41GIDjIVIhE
         hKmWVlIpvLRW75FCLjVTibEKwWZY0sRxonaQknDVsrCmd0NGTn0D8jgf+sznr5pK905p
         IRzhzCKOpHqTA9vUMbJ68w6+v4BPWydAIAGIvPfcUBtb1wQGJStfqVYEgDyG6nRx+WJX
         BZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=gkvBXvzMhYSRTcZy4oNhDjYmBjZXTwydzqi0XRBUfwo=;
        b=BGyOE2ETARf32VPxjzxTdC2ZguKSRkD7YlrVh+pBR4Z8e8HE15sGYZGhXeV4VqWSyp
         O7fWj9osvH3f7liDOPGQtPmHI+6BKdDQTKkuQJylYQ5XJx6Pc1T7S9j3G0aG48fF+5N8
         eLcC8nkxEgGeGUyBfflpFAjOF5aJ94DVjSrKjOOXJyN0sEHEdfXhT+GV+a+LVg8g3xaV
         qk6UQDgPELZx3YGzMdWIuaDK46oRkECe0MHcbt0u85i17p6M3/PacBIFkPEE7Y5cE9qw
         ggcyv3zRvDEZuNViCY2ErteWVU5xA1KmFdb9sU8Ub2oUXkkqkjgGnz7te9W+LOh/U2er
         +ibw==
X-Gm-Message-State: APjAAAVt0jW90CCCUt9PthDMZKCwbLQyRfAvIuaqmBqaWHMjlicKa1gc
        BUFAC0/NLWYnuK+Dvl4RVaaipT/i
X-Google-Smtp-Source: APXvYqxElkytF55z65Bb7mzhdXuWYY/dfaxj7PPmu1yAlTAgJH+GV5AyqDuHZdFopZAmUucJcvyAvw==
X-Received: by 2002:adf:a19c:: with SMTP id u28mr67542832wru.221.1582570600410;
        Mon, 24 Feb 2020 10:56:40 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z8sm19900838wrv.74.2020.02.24.10.56.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:56:39 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: [FYI PATCH 2/3] KVM: nVMX: Refactor IO bitmap checks into helper function
Date:   Mon, 24 Feb 2020 19:56:35 +0100
Message-Id: <1582570596-45387-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

Checks against the IO bitmap are useful for both instruction emulation
and VM-exit reflection. Refactor the IO bitmap checks into a helper
function.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 39 +++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h |  2 ++
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 50d8dbb3616d..f979832c394d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5312,24 +5312,17 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-
-static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
-				       struct vmcs12 *vmcs12)
+/*
+ * Return true if an IO instruction with the specified port and size should cause
+ * a VM-exit into L1.
+ */
+bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
+				 int size)
 {
-	unsigned long exit_qualification;
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	gpa_t bitmap, last_bitmap;
-	unsigned int port;
-	int size;
 	u8 b;
 
-	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
-		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
-
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-
-	port = exit_qualification >> 16;
-	size = (exit_qualification & 7) + 1;
-
 	last_bitmap = (gpa_t)-1;
 	b = -1;
 
@@ -5356,6 +5349,24 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+	unsigned long exit_qualification;
+	unsigned int port;
+	int size;
+
+	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
+		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
+
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	port = exit_qualification >> 16;
+	size = (exit_qualification & 7) + 1;
+
+	return nested_vmx_check_io_bitmaps(vcpu, port, size);
+}
+
 /*
  * Return 1 if we should exit from L2 to L1 to handle an MSR access,
  * rather than handle it ourselves in L0. I.e., check whether L1 expressed
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 1db388f2a444..9aeda46f473e 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -33,6 +33,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
+				 int size);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
-- 
1.8.3.1



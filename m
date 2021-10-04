Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885724218B0
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhJDUvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbhJDUvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:46 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D5AC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u7so15511390pfg.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1DVzjRL09JB2xUZP0AjJSrzo6xvcKNISRV/HPGityTU=;
        b=VJl9H2ujB+AXmd4RiltnVlDA7FD+nY4yIB45fASsFHCFaMADblO2EP/qS307+AhU+w
         JK2GS6+8nWLozx5YIz8BR51WNY05lk7dQt2ILxgki8bAgGXBL7DB3ihcvnBD13YpI4EB
         5v/tx9jxqR6jpQ0QHXRjTGqJ1EwNJ164A/TYlwlsEO1uyL3JgtP4bKk1cyi9r8DOpBbm
         GCz5Mi+++vT/Xlq8FO3imiIuHgxrtP5fIyA8vbPODB+T7hEfZSK4E2unYlLxHB8GcKpO
         qms7vt83kn7becDwvdGjQ6oLh1FGM7N11XsL/XBEd+ePSDgH4/RSZLAZvlgb9ogJBYSR
         Yxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1DVzjRL09JB2xUZP0AjJSrzo6xvcKNISRV/HPGityTU=;
        b=TjL2XApiNY3yartalQcClI8zk7gSCcY1u5GBBz58jcNQeOGkBkb8y7Z4zvCPyJAOj5
         Ccqufg+fFb+qh6Tw4qYeVbSJV7N+mTUBeR2inVPhnDP0RtwHwUBz6ItiCmiFRj7GTZgM
         UUTg7NSKpaqqgqTgckreG6NY3+tDt3C9J/u7tAFBwo4jBcJxV6QdsueHMgyTAHyyEjcp
         dJzW8aGbEaqseI24ncuCSpkA5/bHvJPI1aczAbajPCDPC6dByX5QIvWYtvSHuO8tN+8H
         m5/sEFQtT8ws8wQKPBSOCKTA1pAz6OBwMSfiKAGJQR45Pi3xnLuv+XRi7JjT0K3wDiNy
         e9NA==
X-Gm-Message-State: AOAM53117LvAcBsxXqPhbW1fbX+82bbEKgaTVQa4VKF3sZiUyOugpSUx
        tFreuGo9OzrFbIR1jD/EHkrMItX1x+qJ3w==
X-Google-Smtp-Source: ABdhPJzVQRG/3EW7Bm2SPxqvaCQykzNz6SJkhY8xTkU/Fqz7rRXg+IgYakcR9nHAWgM0puE2HH+1cA==
X-Received: by 2002:a63:4b5a:: with SMTP id k26mr12713226pgl.241.1633380595957;
        Mon, 04 Oct 2021 13:49:55 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:55 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 15/17] x86 AMD SEV-ES: Copy UEFI #VC IDT entry
Date:   Mon,  4 Oct 2021 13:49:29 -0700
Message-Id: <20211004204931.1537823-16-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

AMD SEV-ES introduces a new #VC exception that handles the communication
between guest and host. UEFI already implements a #VC handler so there
is no need to re-implement it in KVM-Unit-Tests. To reuse this #VC
handler, this commit reads UEFI's IDT, copy the #VC IDT entry into
KVM-Unit-Tests' IDT.

Reusing UEFI #VC handler is a temporary workaround, and the long-term
solution is to implement a #VC handler in KVM-Unit-Tests so it does not
depend on specific UEFI's #VC handler. However, we still believe that
the current approach is good as an intermediate solution, because it
unlocks a lot of testing and we do not expect that testing to be
inherently tied to the UEFI's #VC handler.

In this commit, load_idt() can work and now guest crashes in
setup_page_table(), which will be fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 30 ++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++++
 lib/x86/setup.c   | 12 ++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 88cf283..50352df 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -87,6 +87,36 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
+efi_status_t setup_amd_sev_es(void)
+{
+	struct descriptor_table_ptr idtr;
+	idt_entry_t *idt;
+	idt_entry_t vc_handler_idt;
+
+	if (!amd_sev_es_enabled()) {
+		return EFI_UNSUPPORTED;
+	}
+
+	/*
+	 * Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
+	 * not have to re-implement a #VC handler. Also update the #VC IDT code
+	 * segment to use KVM-Unit-Tests segments, KERNEL_CS, so that we do not
+	 * have to copy the UEFI GDT entries into KVM-Unit-Tests GDT.
+	 *
+	 * TODO: Reusing UEFI #VC handler is a temporary workaround to simplify
+	 * the boot up process, the long-term solution is to implement a #VC
+	 * handler in kvm-unit-tests and load it, so that kvm-unit-tests does
+	 * not depend on specific UEFI #VC handler implementation.
+	 */
+	sidt(&idtr);
+	idt = (idt_entry_t *)idtr.base;
+	vc_handler_idt = idt[SEV_ES_VC_HANDLER_VECTOR];
+	vc_handler_idt.selector = KERNEL_CS;
+	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = vc_handler_idt;
+
+	return EFI_SUCCESS;
+}
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	if (amd_sev_enabled()) {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index fb51fc2..0ea1fda 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -39,7 +39,14 @@
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
+/*
+ * AMD Programmer's Manual Volume 2
+ *   - Section "#VC Exception"
+ */
+#define SEV_ES_VC_HANDLER_VECTOR 29
+
 bool amd_sev_es_enabled(void);
+efi_status_t setup_amd_sev_es(void);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index ad7f725..529c3d0 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -263,6 +263,18 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
 		}
 	}
 
+	status = setup_amd_sev_es();
+	if (status != EFI_SUCCESS) {
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			/* Continue if AMD SEV-ES is not supported */
+			break;
+		default:
+			printf("Set up AMD SEV-ES failed\n");
+			return status;
+		}
+	}
+
 	return EFI_SUCCESS;
 }
 
-- 
2.33.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FC6E3FDC
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733191AbfJXXDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:03:45 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:54296 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJXXDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:03:44 -0400
Received: by mail-pf1-f202.google.com with SMTP id 2so334095pfv.21
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZvUs3prfac8nMA+DjbJb3Eq53kw+EBDussXq7EoWCTQ=;
        b=mVOmSWgmDo0egTO90mOaE4VXzmf3Bq6O7o3NZvERc/MGcS6+uvLJMZ920I5g9KWx58
         XZc55Extb5ex2bRzZIjvTuzgaUZGXsC2iI4N5ZmQRtpmpSV/F33ZSJXKkSsISO4xEEZ8
         6w8aM9JHrPm0XCV+wZoTrTsv0D3YiIepzQJE1PbNP9oUwXmUGXdv1gxoEdrTSN/n4dno
         FdXs7UNTheUp0tNxp/KY4btiffb20ebFTFBfgQJRTBhxMG80SpZjkYZMZ6EZeOjIbMcj
         psoo0VoLjoWQEiZ9o+bpRiff67LnkHk1WB00KsuJhOX9aBWKTbIyqwfQS3lgmRG3nsFY
         LX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZvUs3prfac8nMA+DjbJb3Eq53kw+EBDussXq7EoWCTQ=;
        b=cPvzciJG769C3Hc4G8+xAjq7HjPghwQae5MHHDzdn2S7CmaLWc0av05pJwAnqn4vBS
         bmciJEzWiOcVTkiEh3tUGCR0wHVODXQxXr8NDxEaxUzRviUYLtl+1SnAT1r0iDRAUA8K
         B9V0nw7ppgmeS1XOUqaIsA67mBVFfjE+DeqsYsFho3WduQetXsH9aTp1nIoRbktUnaxR
         W9MvaGUcfyNLehsCdA4DJKLZ5ozEYpmmB7rLMWxtueH5870DYkCz3YpKt2tltIWriXJh
         55fsVGilQj5m/o8mf69CYrBFVY8L/m7lYMITsxdlH91cYtdmvoH5LVnHzwkEpgadWDY4
         +uJw==
X-Gm-Message-State: APjAAAUYx1rwA7QYFcEGTo40OmUKmtAY2FyjXcRMUJdrwIUwnBmBeXtH
        F3+KvsXYCri3xd5B8YeuYwQM6Y059j4QMytKX9MyiHU49TI/z7XvfmUmDT1hqW5VUDdz5wCdVMh
        9d6JJorVTbAqKtQSa+fIdHCnCrB0DC/CP/AEnc0Ss7Y0BdK+CgTIc4VGcq/nJoWE=
X-Google-Smtp-Source: APXvYqwMZOA/EZw6RnhifiGMxU/lx0Ye19kKB++dqwgcMu7FkCg+tIUYfuOZdrDAmi9Q3cdzb673eRPo/wrzZw==
X-Received: by 2002:a63:778f:: with SMTP id s137mr532709pgc.147.1571958223448;
 Thu, 24 Oct 2019 16:03:43 -0700 (PDT)
Date:   Thu, 24 Oct 2019 16:03:25 -0700
In-Reply-To: <20191024230327.140935-1-jmattson@google.com>
Message-Id: <20191024230327.140935-2-jmattson@google.com>
Mime-Version: 1.0
References: <20191024230327.140935-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 1/3] kvm: Don't clear reference count on kvm_create_vm()
 error path
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer setting the reference count, kvm->users_count, until the VM is
guaranteed to be created, so that the reference count need not be
cleared on the error path.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Junaid Shahid <junaids@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd68fbe0a75d2..525e0dbc623f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -640,7 +640,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
-	refcount_set(&kvm->users_count, 1);
 	INIT_LIST_HEAD(&kvm->devices);
 
 	r = kvm_arch_init_vm(kvm, type);
@@ -682,6 +681,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err;
 
+	/*
+	 * kvm_get_kvm() isn't legal while the vm is being created
+	 * (e.g. in kvm_arch_init_vm).
+	 */
+	refcount_set(&kvm->users_count, 1);
+
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
@@ -697,7 +702,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_srcu:
 	hardware_disable_all();
 out_err_no_disable:
-	refcount_set(&kvm->users_count, 0);
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-- 
2.24.0.rc0.303.g954a862665-goog


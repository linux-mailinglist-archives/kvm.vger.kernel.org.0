Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE2CE3FDD
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbfJXXDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:03:47 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:41062 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJXXDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:03:47 -0400
Received: by mail-vs1-f73.google.com with SMTP id w21so35537vsi.8
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 16:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/BV7uNDFObPZOlRgBYTU85zjLW/xsxNULPw999+cfbg=;
        b=dirNz+mEYUTujXYODoiLrnwE+SBSKWgLC+9GI2iAdK/u4sZGy5reqc1P4GSUmYRTNT
         5fU+yvl+XpwGZ0BPrUKiuy7zIq5q6iNaihfSwEViSy/6G2RlT1ZFSa4FMpl0oRnHFsti
         aTbQe8IWwRVqzMlObhpOaV+8HAqYuU5SBbwTeh1jJdNWlqpIeUX0hFVQ2qifa3A/QWH4
         NbEEk6qdUhR6Rf/bd7x7h1DYwe7loZ5RkWfutj/js+AesZtYz36j4lRA+eeSgZhTBmfY
         kQutKiTreMdwIegBo0UUENkHcCeO/lobCsIZxtNOpoo/dl4mFCDC3RG6cCAPD1tuyU6S
         mh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/BV7uNDFObPZOlRgBYTU85zjLW/xsxNULPw999+cfbg=;
        b=eQLT5JMOUOUKadcimGEvL9mZriwEvVmMP1eW4T4JJV7Hdij8WzwgMfEW8kwOFDW1EI
         c/DvMOkgpjYXXOB+yJYMMAPAVfuQDICILbrkAD/XLGoA+oU0GGzO6xqGRiKGuJzsfdlY
         L5PuvbG7AkAizG1lFSr+OAHs/+v77Mw2F3+fjX14yZaQmPFRQsNaBChI9559zLFhfWfA
         k+dBKqsHnQBM0jdjgFyT7MisYy/QjGvTFET/mQRlO5xIydX95ySFLgKzgT7pvsp3HlPZ
         eo5dXPprGZjJgqe+V40+tOiD2CWc832x8OCbe3T9rkLTMwpYJXXpJyRt6pPi7pTvHBay
         2D1w==
X-Gm-Message-State: APjAAAXG4Ue4Zw136kC+d88dUWverp02cDIMPT/3GMax/3AyUbdB378r
        mK063y2R0uvLp6qQm+mnePeeWpYh579t7rXp4TU6g2x12XmLkqr3eRQ7gB72vCoRNYIJS2i1f3u
        jhaVoftNQ346M7UWJxNENJVkZSgQRUEKCcMUWpxH5Bmn7Kokpb3xwmryk4BuVXA0=
X-Google-Smtp-Source: APXvYqzNI2QPlDCRuIgCIoUJs9vZKnq4w+Ub6QFcPJgyCc1VHvR5pW+sHD0Cvnzk+g3dN7DK8T2AM0njVcim5A==
X-Received: by 2002:a9f:31e1:: with SMTP id w30mr72213uad.59.1571958225915;
 Thu, 24 Oct 2019 16:03:45 -0700 (PDT)
Date:   Thu, 24 Oct 2019 16:03:26 -0700
In-Reply-To: <20191024230327.140935-1-jmattson@google.com>
Message-Id: <20191024230327.140935-3-jmattson@google.com>
Mime-Version: 1.0
References: <20191024230327.140935-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 2/3] kvm: Allocate memslots and buses before calling kvm_arch_init_vm
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

This reorganization will allow us to call kvm_arch_destroy_vm in the
event that kvm_create_vm fails after calling kvm_arch_init_vm.

Suggested-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Junaid Shahid <junaids@google.com>
---
 virt/kvm/kvm_main.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 525e0dbc623f9..77819597d7e8e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -627,8 +627,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 
 static struct kvm *kvm_create_vm(unsigned long type)
 {
-	int r, i;
 	struct kvm *kvm = kvm_arch_alloc_vm();
+	int r = -ENOMEM;
+	int i;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
@@ -642,6 +643,25 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
 
+	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct kvm_memslots *slots = kvm_alloc_memslots();
+
+		if (!slots)
+			goto out_err_no_disable;
+		/* Generations must be different for each address space. */
+		slots->generation = i;
+		rcu_assign_pointer(kvm->memslots[i], slots);
+	}
+
+	for (i = 0; i < KVM_NR_BUSES; i++) {
+		rcu_assign_pointer(kvm->buses[i],
+			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
+		if (!kvm->buses[i])
+			goto out_err_no_disable;
+	}
+
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_disable;
@@ -654,28 +674,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
-	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
-
-	r = -ENOMEM;
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		struct kvm_memslots *slots = kvm_alloc_memslots();
-		if (!slots)
-			goto out_err_no_srcu;
-		/* Generations must be different for each address space. */
-		slots->generation = i;
-		rcu_assign_pointer(kvm->memslots[i], slots);
-	}
-
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
 		goto out_err_no_irq_srcu;
-	for (i = 0; i < KVM_NR_BUSES; i++) {
-		rcu_assign_pointer(kvm->buses[i],
-			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
-		if (!kvm->buses[i])
-			goto out_err;
-	}
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
-- 
2.24.0.rc0.303.g954a862665-goog


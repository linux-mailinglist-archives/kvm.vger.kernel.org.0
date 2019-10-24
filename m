Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063F0E3FDE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733255AbfJXXDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:03:49 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:50551 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733241AbfJXXDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:03:49 -0400
Received: by mail-pf1-f202.google.com with SMTP id y191so341632pfg.17
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 16:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ewOgdXmkRaG77Ncabl1Le2AWyjyNwQvNzTMJoq6ee0U=;
        b=EFOuKlNK4oJukTE4z/hsRGeSfxswOLvXRbVcP9e5N7xArb4035qPBTAw8fpXN9ibu5
         P+skpg58nqh9pFnXNKC5JA/VF3VI/skMPkq7hggZEjADM8Q7qQVVjUG41983qCXuS9To
         rBzbLz/w0ge+xRZkiXS1Ko3Gdn20ubR7mqKFDbb72mBFj3UvGHF4KIAItPuIRjrobw8Z
         XcpgdIbO/wKyAuw5/McF2ac/52uMzmnGSvTKsfQlu0KSFjUXlHe3bZE5rxoP9YWldJsR
         caoPIS1vMAZBqKp0+Aem5EG43FNt3J9PBby99dPwfSui+2pekMo8CsaJgr9oGuEvOfYB
         U74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ewOgdXmkRaG77Ncabl1Le2AWyjyNwQvNzTMJoq6ee0U=;
        b=Sl6RCF847qMTxlnX2Ye7lJIvvRUAfmAxOVNZLJmxJLBrcckV91CFQ+/2RzUmctEZhp
         2mxFtzg9LbdIkAM+AZWL4PYCjqrx1HwPhFLyUjFYplezD543M+szTBIYQ/XPK5cYXbQT
         5UPZR7OUUg6ULBgNPcqzjHEltelKQXpqLp+Gaulol9yPsHj9nZyCYTxOIA4oMD7/qfNg
         H1pa57hvKOOWnaLUlQNOXpG3Ek2lwIlfGgRVgPFpd4jJAh7kuYgPz2wP3b/A2nzYLiL9
         BvbTNPGuJBU89kT6lSZ/C0k1ZeXnLgKzaUllpuHdSBNlG0l1BRnTa+M59TAbRHysmrLJ
         twxA==
X-Gm-Message-State: APjAAAUgOAe6SY2bBoI6FY7gVyn5Wq6BaT+DsetAcI1Ok/RHyWp0GOie
        VT1GKDDb2bVl5pK6nlVbRzsI/TXdpbJgT3+ZzfZbRMjH3a9sxvxZzDXcDZP0mzNc19e5GN0t7wu
        3J6l87xDXCSnHxuY0iLldyXqXTgaCXx3F/hkph7Y5p6xCN48/yQ7vn4XwdPT0tDw=
X-Google-Smtp-Source: APXvYqy8XQGl5Wr2QHQLbcrxYxRJou9PTb+oqHlsrCqsam1d+EQuyGhqXdTRh+4UPcP1ExJ42zAWtVRLZR+XWQ==
X-Received: by 2002:a65:46c8:: with SMTP id n8mr559794pgr.354.1571958228090;
 Thu, 24 Oct 2019 16:03:48 -0700 (PDT)
Date:   Thu, 24 Oct 2019 16:03:27 -0700
In-Reply-To: <20191024230327.140935-1-jmattson@google.com>
Message-Id: <20191024230327.140935-4-jmattson@google.com>
Mime-Version: 1.0
References: <20191024230327.140935-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
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

From: John Sperbeck <jsperbeck@google.com>

In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
then fail later in the function, we need to call kvm_arch_destroy_vm()
so that it can do any necessary cleanup (like freeing memory).

Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Junaid Shahid <junaids@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77819597d7e8e..f8f0106f8d20f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -649,7 +649,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
 		if (!slots)
-			goto out_err_no_disable;
+			goto out_err_no_arch_destroy_vm;
 		/* Generations must be different for each address space. */
 		slots->generation = i;
 		rcu_assign_pointer(kvm->memslots[i], slots);
@@ -659,12 +659,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		rcu_assign_pointer(kvm->buses[i],
 			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
 		if (!kvm->buses[i])
-			goto out_err_no_disable;
+			goto out_err_no_arch_destroy_vm;
 	}
 
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
-		goto out_err_no_disable;
+		goto out_err_no_arch_destroy_vm;
 
 	r = hardware_enable_all();
 	if (r)
@@ -685,7 +685,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	/*
 	 * kvm_get_kvm() isn't legal while the vm is being created
-	 * (e.g. in kvm_arch_init_vm).
+	 * (e.g. in kvm_arch_init_vm or kvm_arch_destroy_vm).
 	 */
 	refcount_set(&kvm->users_count, 1);
 
@@ -704,6 +704,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_srcu:
 	hardware_disable_all();
 out_err_no_disable:
+	kvm_arch_destroy_vm(kvm);
+out_err_no_arch_destroy_vm:
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-- 
2.24.0.rc0.303.g954a862665-goog


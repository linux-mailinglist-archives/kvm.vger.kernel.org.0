Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3955A44D97B
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKPwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:52:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234005AbhKKPw2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2mGVdn6PVX7Jko7t0Xrev6xzjkKgcX/9zsbWBKv04s=;
        b=JIyaeRNRDqjiSqlBmvXxDrrPHvs0kbvUF9ailTOebFdZekq2/guUDHCipTF74anJ9pdW1G
        /Kz7eMC0jPFku5XJ+qI0JM3Jqnr/qVQhdZYn4GDlYYafs0bD61HVvtjPcKu2yewmeruQst
        VMGpgPJQsJ0X8b3/PauwXmsweK8vnLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-7GnFsPlfODyqQCJq2-5EXQ-1; Thu, 11 Nov 2021 10:49:35 -0500
X-MC-Unique: 7GnFsPlfODyqQCJq2-5EXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FDD9A40C0;
        Thu, 11 Nov 2021 15:49:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6DC25E26A;
        Thu, 11 Nov 2021 15:49:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 2/7] KVM: generalize "bugged" VM to "dead" VM
Date:   Thu, 11 Nov 2021 10:49:25 -0500
Message-Id: <20211111154930.3603189-3-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generalize KVM_REQ_VM_BUGGED so that it can be called even in cases
where it is by design that the VM cannot be operated upon.  In this
case any KVM_BUG_ON should still warn, so introduce a new flag
kvm->vm_dead that is separate from kvm->vm_bugged.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h | 12 ++++++++++--
 virt/kvm/kvm_main.c      | 10 +++++-----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..622cb75f5e75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9654,7 +9654,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..9e0667e3723e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -150,7 +150,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
-#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -617,6 +617,7 @@ struct kvm {
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
 	bool vm_bugged;
+	bool vm_dead;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -650,12 +651,19 @@ struct kvm {
 #define vcpu_err(vcpu, fmt, ...)					\
 	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
 
+static inline void kvm_vm_dead(struct kvm *kvm)
+{
+	kvm->vm_dead = true;
+	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
+}
+
 static inline void kvm_vm_bugged(struct kvm *kvm)
 {
 	kvm->vm_bugged = true;
-	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
+	kvm_vm_dead(kvm);
 }
 
+
 #define KVM_BUG(cond, kvm, fmt...)				\
 ({								\
 	int __ret = (cond);					\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..d31724500501 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3747,7 +3747,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3957,7 +3957,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
 		return -EIO;
 
 	switch (ioctl) {
@@ -4023,7 +4023,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_dead)
 		return -EIO;
 
 	switch (ioctl) {
@@ -4345,7 +4345,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm || kvm->vm_bugged)
+	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -4556,7 +4556,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm || kvm->vm_bugged)
+	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.27.0



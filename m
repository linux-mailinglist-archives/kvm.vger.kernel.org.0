Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08CE68F04C
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjBHODO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjBHODJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:03:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067AC9EF8
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675864908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/nsobX2ruZfUuZDf5t48MOb356vKr1L1ibFdLfAXYU=;
        b=RnAqGrjz0rgy0RAL5sDEB48qhdLkudV6vUB7v6Ft5sUm+1u0otZfThWrrK6df/v7aAZ3oa
        dJkoPZY1/h0VZ0mObYmMdoeakG8P46E7yhcxsGH/98KuguI6t1lxvZXc3akHV7hBnyknsv
        6/5avGGvl+3Pjwo/nQ2wa+p/tpMODKI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-PFqbRkqyPz6WJTX1JMymZg-1; Wed, 08 Feb 2023 09:01:44 -0500
X-MC-Unique: PFqbRkqyPz6WJTX1JMymZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2281E885622;
        Wed,  8 Feb 2023 14:01:42 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6398140EBF4;
        Wed,  8 Feb 2023 14:01:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 6/6] KVM: Change return type of kvm_arch_vm_ioctl() to "int"
Date:   Wed,  8 Feb 2023 15:01:05 +0100
Message-Id: <20230208140105.655814-7-thuth@redhat.com>
In-Reply-To: <20230208140105.655814-1-thuth@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All kvm_arch_vm_ioctl() implementations now only deal with "int"
types as return values, so we can change the return type of these
functions to use "int" instead of "long".

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/kvm/arm.c       | 3 +--
 arch/mips/kvm/mips.c       | 4 ++--
 arch/powerpc/kvm/powerpc.c | 5 ++---
 arch/riscv/kvm/vm.c        | 3 +--
 arch/s390/kvm/kvm-s390.c   | 3 +--
 arch/x86/kvm/x86.c         | 3 +--
 include/linux/kvm_host.h   | 3 +--
 7 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..e791ad6137b8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1449,8 +1449,7 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
-long kvm_arch_vm_ioctl(struct file *filp,
-		       unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..84cadaa2c2d3 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1003,9 +1003,9 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 	kvm_flush_remote_tlbs(kvm);
 }
 
-long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	long r;
+	int r;
 
 	switch (ioctl) {
 	default:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 04494a4fb37a..6f6ba55c224f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2386,12 +2386,11 @@ static int kvmppc_get_cpu_char(struct kvm_ppc_cpu_char *cp)
 }
 #endif
 
-long kvm_arch_vm_ioctl(struct file *filp,
-                       unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm __maybe_unused = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	long r;
+	int r;
 
 	switch (ioctl) {
 	case KVM_PPC_GET_PVINFO: {
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 65a964d7e70d..c13130ab459a 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -87,8 +87,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
-long kvm_arch_vm_ioctl(struct file *filp,
-		       unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	return -EINVAL;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8ad1972b8a73..86ca49814983 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2850,8 +2850,7 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 	return r;
 }
 
-long kvm_arch_vm_ioctl(struct file *filp,
-		       unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d210ab47e21..52a8c993cd55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6645,8 +6645,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
-long kvm_arch_vm_ioctl(struct file *filp,
-		       unsigned int ioctl, unsigned long arg)
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..ed2f1f02976b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1398,8 +1398,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 			bool line_status);
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap);
-long kvm_arch_vm_ioctl(struct file *filp,
-		       unsigned int ioctl, unsigned long arg);
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg);
 long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
 			      unsigned long arg);
 
-- 
2.31.1


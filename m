Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE723E951
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgHGIkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728193AbgHGIkQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 04:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L00fvImj+Aem/rZ4jTFnPDHDfEBv268QH0yH7XjxJsc=;
        b=KIoX4tuJ1vkbhvVnXeOJ+RI0d9vnRuT98BI9J6W3AAErwb7dUmWG6FcGZhW2uDFZxcLcq0
        SWekHa7dTab4/eUbv/Y+HdinA6wh6gDvlE2ojvrHQiCLo71wYMkkrtfL358YS+vlwbpCjg
        8MuPy+WItqlAc6rYd7nQFOU6UfhGyDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193--iTQFr-JOCSqlY7VPsjDsA-1; Fri, 07 Aug 2020 04:40:14 -0400
X-MC-Unique: -iTQFr-JOCSqlY7VPsjDsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B28C58064AC;
        Fri,  7 Aug 2020 08:40:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 399825C1D2;
        Fri,  7 Aug 2020 08:40:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] KVM: x86: hyper-v: drop now unneeded vcpu parameter from kvm_vcpu_ioctl_get_hv_cpuid()
Date:   Fri,  7 Aug 2020 10:39:44 +0200
Message-Id: <20200807083946.377654-6-vkuznets@redhat.com>
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_ioctl_get_hv_cpuid() doesn't use its vcpu parameter anymore,
drop it. Also, the function is now untied from vcpu, rename it accordingly.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 +--
 arch/x86/kvm/hyperv.h | 3 +--
 arch/x86/kvm/x86.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a8ebaa66a8e1..daed68139765 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1950,8 +1950,7 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
 	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
 }
 
-int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-				struct kvm_cpuid_entry2 __user *entries)
+int kvm_get_hv_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 __user *entries)
 {
 	uint16_t evmcs_ver = 0;
 	struct kvm_cpuid_entry2 cpuid_entries[] = {
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e68c6c2e9649..1fc4997e7f01 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -126,7 +126,6 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
-int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-				struct kvm_cpuid_entry2 __user *entries);
+int kvm_get_hv_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 __user *entries);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95ef62922869..4659067c2e53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4749,8 +4749,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
 
-		r = kvm_vcpu_ioctl_get_hv_cpuid(vcpu, &cpuid,
-						cpuid_arg->entries);
+		r = kvm_get_hv_cpuid(&cpuid, cpuid_arg->entries);
 		if (r)
 			goto out;
 
-- 
2.25.4


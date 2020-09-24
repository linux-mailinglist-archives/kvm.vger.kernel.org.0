Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42423277479
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgIXO6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728350AbgIXO6U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OslUPmgyxXpudhjchQ/qdDKuPQsyw2Ukn270L0xB5GM=;
        b=NSWdl2WnNGVNioYPVN34GcB5+urio92ZT8NgZ1jrEtdCHj5wU46QjvjoGHT68Mvxy7Jugh
        sIS/fKyPFH4oYVeH1BgoBegHQ1xGsfhnhl5xqgC3s28hm/rTc0ROzqrEBfXVF1vfZ2H2Eh
        a/27s/QGM0khsXaKCt2Y0S7j4eGGN18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-4PFHgRKSMrCzxEIIRTSvcw-1; Thu, 24 Sep 2020 10:58:18 -0400
X-MC-Unique: 4PFHgRKSMrCzxEIIRTSvcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B7C01882FB8;
        Thu, 24 Sep 2020 14:58:17 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9754F5576C;
        Thu, 24 Sep 2020 14:58:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: x86: hyper-v: drop now unneeded vcpu parameter from kvm_vcpu_ioctl_get_hv_cpuid()
Date:   Thu, 24 Sep 2020 16:57:55 +0200
Message-Id: <20200924145757.1035782-6-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 503829f71270..34d8a4c76828 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1951,8 +1951,7 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
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
index 17f4995e80a7..4b1a092d9e51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4748,8 +4748,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
 
-		r = kvm_vcpu_ioctl_get_hv_cpuid(vcpu, &cpuid,
-						cpuid_arg->entries);
+		r = kvm_get_hv_cpuid(&cpuid, cpuid_arg->entries);
 		if (r)
 			goto out;
 
-- 
2.25.4


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D204537BF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhKPQjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233238AbhKPQjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637080571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fzs/tu22nSIiklxyWhqw5I8HgPrSNduRvkzTjwACmGg=;
        b=CbBZiUZC8qkT9ia1SOJqC+k5n5AEQKClsAo1qHMg8xaF6UOEuYM+k7eX5QOXqrHj+bIsAn
        O9AKJbb7iDl/xCxjcJ88zfE8AxL2HcQJRuJpxgmkP4lc53ltBKGj9fF/sMBEBxFWfVjDgv
        b50W55QlYzL8bXp1kN926tHicDX7xaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-kiLU4MXTPMSt6gKSd-U_OQ-1; Tue, 16 Nov 2021 11:36:08 -0500
X-MC-Unique: kiLU4MXTPMSt6gKSd-U_OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 151D6192203A;
        Tue, 16 Nov 2021 16:36:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADD9160C0F;
        Tue, 16 Nov 2021 16:35:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
Date:   Tue, 16 Nov 2021 17:34:43 +0100
Message-Id: <20211116163443.88707-7-vkuznets@redhat.com>
In-Reply-To: <20211116163443.88707-1-vkuznets@redhat.com>
References: <20211116163443.88707-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_NR_VCPUS is used to get the "recommended" maximum number of
VCPUs and arm64/mips/riscv report num_online_cpus(). Powerpc reports
either num_online_cpus() or num_present_cpus(), s390 has multiple
constants depending on hardware features. On x86, KVM reports an
arbitrary value of '710' which is supposed to be the maximum tested
value but it's possible to test all KVM_MAX_VCPUS even when there are
less physical CPUs available.

Drop the arbitrary '710' value and return num_online_cpus() on x86 as
well. The recommendation will match other architectures and will mean
'no CPU overcommit'.

For reference, QEMU only queries KVM_CAP_NR_VCPUS to print a warning
when the requested vCPU number exceeds it. The static limit of '710'
is quite weird as smaller systems with just a few physical CPUs should
certainly "recommend" less.

Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..0232a00598f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,6 @@
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
 #define KVM_MAX_VCPUS 1024
-#define KVM_SOFT_MAX_VCPUS 710
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..18a00a7c23bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4137,7 +4137,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = KVM_SOFT_MAX_VCPUS;
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.1


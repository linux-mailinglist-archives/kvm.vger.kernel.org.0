Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F0351B32
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhDASGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:06:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235278AbhDAR7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMwVPIRuutm/mg4jT4wBYpyFXiE89KqV/L7ffhzIn/0=;
        b=MqQoqSKcfFylqOFWiUizYy1VgwVaTfph1rLDAuCJjOKgGFoPcwgujYo4PDrXOweZD4Zz0N
        jyOgn3aja2r3t+PKntrrZhfED2w4fmgTkGgZSljhQtWxCZkcamyWQLjWag2XjVl53GRM5f
        BHO2k36pNJXRSKOJDQkIxXf+zmAKCIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-1O5aWV9lOwaPC3HfHnwHug-1; Thu, 01 Apr 2021 09:55:36 -0400
X-MC-Unique: 1O5aWV9lOwaPC3HfHnwHug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8B2419251A0;
        Thu,  1 Apr 2021 13:55:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4C4D5D6B1;
        Thu,  1 Apr 2021 13:55:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64)), Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-arm-kernel@lists.infradead.org (moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 (KVM/arm64)), James Morse <james.morse@arm.com>
Subject: [PATCH v2 3/9] KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2
Date:   Thu,  1 Apr 2021 16:54:45 +0300
Message-Id: <20210401135451.1004564-4-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store the supported bits into KVM_GUESTDBG_VALID_MASK
macro, similar to how arm does this.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/x86.c              | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..cc7c82a449d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -221,6 +221,15 @@ enum x86_intercept_stage;
 #define DR7_FIXED_1	0x00000400
 #define DR7_VOLATILE	0xffff2bff
 
+#define KVM_GUESTDBG_VALID_MASK \
+	(KVM_GUESTDBG_ENABLE | \
+	KVM_GUESTDBG_SINGLESTEP | \
+	KVM_GUESTDBG_USE_HW_BP | \
+	KVM_GUESTDBG_USE_SW_BP | \
+	KVM_GUESTDBG_INJECT_BP | \
+	KVM_GUESTDBG_INJECT_DB)
+
+
 #define PFERR_PRESENT_BIT 0
 #define PFERR_WRITE_BIT 1
 #define PFERR_USER_BIT 2
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d95f90a048..956e8e0bd6af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3798,6 +3798,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r = 1;
 		break;
+	case KVM_CAP_SET_GUEST_DEBUG2:
+		return KVM_GUESTDBG_VALID_MASK;
 #ifdef CONFIG_KVM_XEN
 	case KVM_CAP_XEN_HVM:
 		r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
-- 
2.26.2


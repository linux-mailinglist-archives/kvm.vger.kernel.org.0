Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95343351AA3
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhDASCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236613AbhDAR7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Beke6p3SuuLc9PEBd5EVBwfI5FcHk7u5ME5KWl6tIhg=;
        b=BE/3S1SRQcU9krpV8ZkcZ6SLjR+BU4vuC5IQEPwp42yklVH/QQwazV9Ur2iBm8afdZMPKi
        ronHmfMfNoifQXqe9zIBV8iwyVpaJVbbKFr0NInZBKjdN0ezBXckqzOmU037sIhTGMXz/r
        vgXO9KY8j2nYzkHUHjMZH4cWb26UdCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-_HcijJiUNj-mXO3Df2jx2A-1; Thu, 01 Apr 2021 09:55:49 -0400
X-MC-Unique: _HcijJiUNj-mXO3Df2jx2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C75BD107BEF6;
        Thu,  1 Apr 2021 13:55:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32E505D6B1;
        Thu,  1 Apr 2021 13:55:32 +0000 (UTC)
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
Subject: [PATCH v2 4/9] KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
Date:   Thu,  1 Apr 2021 16:54:46 +0300
Message-Id: <20210401135451.1004564-5-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move KVM_GUESTDBG_VALID_MASK to kvm_host.h
and use it to return the value of this capability.
Compile tested only.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/guest.c            | 5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..613421454ab6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -401,6 +401,10 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
 
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
+				 KVM_GUESTDBG_USE_SW_BP | \
+				 KVM_GUESTDBG_USE_HW | \
+				 KVM_GUESTDBG_SINGLESTEP)
 /*
  * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
  * take the following values:
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..e575eff76e97 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -208,6 +208,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
+	case KVM_CAP_SET_GUEST_DEBUG2:
+		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
 		r = 1;
 		break;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9bbd30e62799..6cb39ee74acd 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -888,11 +888,6 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
-			    KVM_GUESTDBG_USE_SW_BP | \
-			    KVM_GUESTDBG_USE_HW | \
-			    KVM_GUESTDBG_SINGLESTEP)
-
 /**
  * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
  * @kvm:	pointer to the KVM struct
-- 
2.26.2


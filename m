Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51C2351A8E
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhDASB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235931AbhDAR5S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NuvXglGlpdJ/QEHoOnrFCNfTazwjmv2hUiB2qqpR7J0=;
        b=Jye7GeSkBzrxqwy0zimxvYAkC2KSdtxlVDWoMWzH+h1N9FwV8k4Wuy5glWpXEIZ01vObe7
        ZjsBobGpzrpF5X1pOAEc2KFcNg1pDsvspDUvhzNlX/phEbw7jwSdxUKfN6bu1qqPobFQZ9
        Ag1XHm5grgum6VUkjk8gv9jYeMbMJ0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-YmW1MhWNNkGN89uyV9ZwLg-1; Thu, 01 Apr 2021 09:55:56 -0400
X-MC-Unique: YmW1MhWNNkGN89uyV9ZwLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363BA802690;
        Thu,  1 Apr 2021 13:55:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FC8D5D6B1;
        Thu,  1 Apr 2021 13:55:44 +0000 (UTC)
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
Subject: [PATCH v2 5/9] KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2
Date:   Thu,  1 Apr 2021 16:54:47 +0300
Message-Id: <20210401135451.1004564-6-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define KVM_GUESTDBG_VALID_MASK and use it to implement this capabiity.
Compile tested only.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/s390/include/asm/kvm_host.h | 4 ++++
 arch/s390/kvm/kvm-s390.c         | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 6bcfc5614bbc..a3902b57b825 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -700,6 +700,10 @@ struct kvm_hw_bp_info_arch {
 #define guestdbg_exit_pending(vcpu) (guestdbg_enabled(vcpu) && \
 		(vcpu->guest_debug & KVM_GUESTDBG_EXIT_PENDING))
 
+#define KVM_GUESTDBG_VALID_MASK \
+		(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP |\
+		KVM_GUESTDBG_USE_HW_BP | KVM_GUESTDBG_EXIT_PENDING)
+
 struct kvm_guestdbg_info_arch {
 	unsigned long cr0;
 	unsigned long cr9;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2f09e9d7dc95..2049fc8c222a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -544,6 +544,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_DIAG318:
 		r = 1;
 		break;
+	case KVM_CAP_SET_GUEST_DEBUG2:
+		r = KVM_GUESTDBG_VALID_MASK;
+		break;
 	case KVM_CAP_S390_HPAGE_1M:
 		r = 0;
 		if (hpage && !kvm_is_ucontrol(kvm))
-- 
2.26.2


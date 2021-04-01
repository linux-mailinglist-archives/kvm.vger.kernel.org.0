Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F65351AAC
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhDASCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236923AbhDAR7I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93LEfSuuqIW0DBrW+Poi8yq3BZzX4V4otYYlW/jGzRg=;
        b=RoqCZAjvhPOl8sZWr92Dc8gYaF2UygfZw1KnFt2vEI7M69m+UgFqjTXtX2xzac5EY911qo
        1HuPT0pbPxLAbFF0iwVT6PVclZ32lSCD+pFfBktjK5YSWURhvuLBd1QYVnp+T8Enr3jBdm
        wTvOWb6Yxe6A7+3r5D+5zLHJ/mhDCns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-lvtRGc1hNvyqH7m-ZYkRWg-1; Thu, 01 Apr 2021 09:56:11 -0400
X-MC-Unique: lvtRGc1hNvyqH7m-ZYkRWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB2DDA40C1;
        Thu,  1 Apr 2021 13:56:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 944725D6B1;
        Thu,  1 Apr 2021 13:55:53 +0000 (UTC)
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
Subject: [PATCH v2 6/9] KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS
Date:   Thu,  1 Apr 2021 16:54:48 +0300
Message-Id: <20210401135451.1004564-7-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GUESTDBG_BLOCKEVENTS is a guest debug feature that
will allow KVM to block all interrupts while running.
It is mostly intended to be used together with single stepping,
to make it more robust, and has the following benefits:

* Resuming from a breakpoint is much more reliable:
  When resuming execution from a breakpoint, with interrupts enabled,
  more often than not, KVM would inject an interrupt and make the CPU
  jump immediately to the interrupt handler and eventually return to
  the breakpoint, only to trigger it again.

  From the gdb's user point of view it looks like the CPU has never
  executed a single instruction and in some cases that can even
  prevent forward progress, for example, when the breakpoint
  is placed by an automated script (e.g lx-symbols), which does
  something in response to the breakpoint and then continues
  the guest automatically.
  If the script execution takes enough time for another interrupt to
  arrive, the guest will be stuck on the same breakpoint forever.

* Normal single stepping is much more predictable, since it won't
  land the debugger into an interrupt handler.

* Chances of RFLAGS.TF being leaked to the guest are reduced:

  KVM sets that flag behind the guest's back to single step it,
  but if the single step lands the vCPU into an
  interrupt/exception handler the RFLAGS.TF will be leaked to the
  guest in the form of being pushed to the stack.
  This doesn't completely eliminate this problem as exceptions
  can still happen, but at least this eliminates the common
  case.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 1 +
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 4 ++++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9778b2434c03..a4f2dc84741f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3338,6 +3338,7 @@ flags which can include the following:
   - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
   - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
   - KVM_GUESTDBG_EXIT_PENDING:  trigger an immediate guest exit [s390]
+  - KVM_GUESTDBG_BLOCKIRQ:      avoid injecting interrupts/NMI/SMI [x86]
 
 For example KVM_GUESTDBG_USE_SW_BP indicates that software breakpoints
 are enabled in memory so we need to ensure breakpoint exceptions are
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cc7c82a449d5..8c529ae9dbbe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -227,7 +227,8 @@ enum x86_intercept_stage;
 	KVM_GUESTDBG_USE_HW_BP | \
 	KVM_GUESTDBG_USE_SW_BP | \
 	KVM_GUESTDBG_INJECT_BP | \
-	KVM_GUESTDBG_INJECT_DB)
+	KVM_GUESTDBG_INJECT_DB | \
+	KVM_GUESTDBG_BLOCKIRQ)
 
 
 #define PFERR_PRESENT_BIT 0
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a3022c8af82..b0f9945067f7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -282,6 +282,7 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW_BP		0x00020000
 #define KVM_GUESTDBG_INJECT_DB		0x00040000
 #define KVM_GUESTDBG_INJECT_BP		0x00080000
+#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
 
 /* for KVM_SET_GUEST_DEBUG */
 struct kvm_guest_debug_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 956e8e0bd6af..3627ce8fe5bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8460,6 +8460,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		can_inject = false;
 	}
 
+	/* Don't inject interrupts if the user asked to avoid doing so */
+	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
+		return;
+
 	/*
 	 * Finally, inject interrupt events.  If an event cannot be injected
 	 * due to architectural conditions (e.g. IF=0) a window-open exit
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD11D33C923
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhCOWLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhCOWKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 18:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615846242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9NrupMURdEuUMDF610xSyzzhCAN0PBHUS0Y8SXmWZA=;
        b=SHKc/CrwAI3h/davTaO5K+vC5hS4x5PZubSQljVtizTQdLNeXF6QRwcyn8ZSZQNCR1rqdF
        1UH4KMezvC6ac1rirmAziVjn5eL6Y2w3BJZ00H8TrLvG/mvGuiU1GNkthz6CgPxXxJwaqy
        PxxnJSZ7fxVajYkGmZ1LHL82Qef5CjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-3Oks0f7rMSyKvgBBSD5aJg-1; Mon, 15 Mar 2021 18:10:40 -0400
X-MC-Unique: 3Oks0f7rMSyKvgBBSD5aJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AB18100C619;
        Mon, 15 Mar 2021 22:10:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0264A5F706;
        Mon, 15 Mar 2021 22:10:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while single stepping
Date:   Tue, 16 Mar 2021 00:10:19 +0200
Message-Id: <20210315221020.661693-3-mlevitsk@redhat.com>
In-Reply-To: <20210315221020.661693-1-mlevitsk@redhat.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change greatly helps with two issues:

* Resuming from a breakpoint is much more reliable.

  When resuming execution from a breakpoint, with interrupts enabled, more often
  than not, KVM would inject an interrupt and make the CPU jump immediately to
  the interrupt handler and eventually return to the breakpoint, to trigger it
  again.

  From the user point of view it looks like the CPU never executed a
  single instruction and in some cases that can even prevent forward progress,
  for example, when the breakpoint is placed by an automated script
  (e.g lx-symbols), which does something in response to the breakpoint and then
  continues the guest automatically.
  If the script execution takes enough time for another interrupt to arrive,
  the guest will be stuck on the same breakpoint RIP forever.

* Normal single stepping is much more predictable, since it won't land the
  debugger into an interrupt handler, so it is much more usable.

  (If entry to an interrupt handler is desired, the user can still place a
  breakpoint at it and resume the guest, which won't activate this workaround
  and let the gdb still stop at the interrupt handler)

Since this change is only active when guest is debugged, it won't affect
KVM running normal 'production' VMs.


Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d95f90a0487..b75d990fcf12b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8458,6 +8458,12 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		can_inject = false;
 	}
 
+	/*
+	 * Don't inject interrupts while single stepping to make guest debug easier
+	 */
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		return;
+
 	/*
 	 * Finally, inject interrupt events.  If an event cannot be injected
 	 * due to architectural conditions (e.g. IF=0) a window-open exit
-- 
2.26.2


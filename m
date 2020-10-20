Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA442816ED
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgJBPnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387777AbgJBPnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601653401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4n/vvpNwLnfm6WZ1RtB9x/PAi54sYaqURdYPn6d7brA=;
        b=G2KnIv2LndmWOeb/ZU0BnJtj53Ft5MdJIQx2imdthJSpU7fMSsGM6UeCCmm0flyLtyVb+m
        kphJ4Uh/lvSLpV3znTEgHAhfXlYxlF4lnvGyCV+8ROlPDMp3nKA+Ha4peNSu9JfxfMtlkS
        UobDnv9zOh6T6oMoYzX8Lkj3cT1nFbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-iiZI2-hePA-Sn87Iz7wFpw-1; Fri, 02 Oct 2020 11:43:19 -0400
X-MC-Unique: iiZI2-hePA-Sn87Iz7wFpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B300A186DD37;
        Fri,  2 Oct 2020 15:43:17 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BDFE19C78;
        Fri,  2 Oct 2020 15:43:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: Update the comment about asynchronous page fault in exc_page_fault()
Date:   Fri,  2 Oct 2020 17:43:13 +0200
Message-Id: <20201002154313.1505327-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM was switched to interrupt-based mechanism for 'page ready' event
delivery in Linux-5.8 (see commit 2635b5c4a0e4 ("KVM: x86: interrupt based
APF 'page ready' event delivery")) and #PF (ab)use for 'page ready' event
delivery was removed. Linux guest switched to this new mechanism
exclusively in 5.9 (see commit b1d405751cd5 ("KVM: x86: Switch KVM guest to
using interrupts for page ready APF delivery")) so it is not possible to
get older KVM (APF mechanism won't be enabled). Update the comment in
exc_page_fault() to reflect the new reality.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/mm/fault.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6e3e8a124903..3cf77592ac54 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1446,11 +1446,14 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 	prefetchw(&current->mm->mmap_lock);
 
 	/*
-	 * KVM has two types of events that are, logically, interrupts, but
-	 * are unfortunately delivered using the #PF vector.  These events are
-	 * "you just accessed valid memory, but the host doesn't have it right
-	 * now, so I'll put you to sleep if you continue" and "that memory
-	 * you tried to access earlier is available now."
+	 * KVM uses #PF vector to deliver 'page not present' events to guests
+	 * (asynchronous page fault mechanism). The event happens when a
+	 * userspace task is trying to access some valid (from guest's point of
+	 * view) memory which is not currently mapped by the host (e.g. the
+	 * memory is swapped out). Note, the corresponding "page ready" event
+	 * which is injected when the memory becomes available, is delived via
+	 * an interrupt mechanism and not a #PF exception
+	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
 	 *
 	 * We are relying on the interrupted context being sane (valid RSP,
 	 * relevant locks not held, etc.), which is fine as long as the
-- 
2.25.4


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC3247018
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390195AbgHQSB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:01:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388631AbgHQSAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 14:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597687246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M7O0Zd6WuXF1RKsXDTV/oWCgHc9hBiiy2FXt3YXOKsQ=;
        b=Gs6qf9vFRjVNzyyo5Jdgb4vaA3lTrAplhhEDEIHEdSDYVBKnmgVf1h5jHorJsXWwLAI3nP
        ZIrAqtD/Of92M9upmi7pLl/8Fz0ztz2zUTyN8xVv2DZMR7xLaSMDIk7/PMPuXj+EYIFmHS
        hP1wOKndvSlV7on+j2bTxscd4YJ0RtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-qQDItl9mNwqrS87_GLAxJQ-1; Mon, 17 Aug 2020 14:00:44 -0400
X-MC-Unique: qQDItl9mNwqrS87_GLAxJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54F4E1008549;
        Mon, 17 Aug 2020 18:00:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01BBA7A3B4;
        Mon, 17 Aug 2020 18:00:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: x86: fix access code passed to gva_to_gpa
Date:   Mon, 17 Aug 2020 14:00:42 -0400
Message-Id: <20200817180042.32264-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PK bit of the error code is computed dynamically in permission_fault
and therefore need not be passed to gva_to_gpa: only the access bits
(fetch, user, write) need to be passed down.

Not doing so causes a splat in the pku test:

   WARNING: CPU: 25 PID: 5465 at arch/x86/kvm/mmu.h:197 paging64_walk_addr_generic+0x594/0x750 [kvm]
   Hardware name: Intel Corporation WilsonCity/WilsonCity, BIOS WLYDCRB1.SYS.0014.D62.2001092233 01/09/2020
   RIP: 0010:paging64_walk_addr_generic+0x594/0x750 [kvm]
   Code: <0f> 0b e9 db fe ff ff 44 8b 43 04 4c 89 6c 24 30 8b 13 41 39 d0 89
   RSP: 0018:ff53778fc623fb60 EFLAGS: 00010202
   RAX: 0000000000000001 RBX: ff53778fc623fbf0 RCX: 0000000000000007
   RDX: 0000000000000001 RSI: 0000000000000002 RDI: ff4501efba818000
   RBP: 0000000000000020 R08: 0000000000000005 R09: 00000000004000e7
   R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
   R13: ff4501efba818388 R14: 10000000004000e7 R15: 0000000000000000
   FS:  00007f2dcf31a700(0000) GS:ff4501f1c8040000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 0000000000000000 CR3: 0000001dea475005 CR4: 0000000000763ee0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   PKRU: 55555554
   Call Trace:
    paging64_gva_to_gpa+0x3f/0xb0 [kvm]
    kvm_fixup_and_inject_pf_error+0x48/0xa0 [kvm]
    handle_exception_nmi+0x4fc/0x5b0 [kvm_intel]
    kvm_arch_vcpu_ioctl_run+0x911/0x1c10 [kvm]
    kvm_vcpu_ioctl+0x23e/0x5d0 [kvm]
    ksys_ioctl+0x92/0xb0
    __x64_sys_ioctl+0x16/0x20
    do_syscall_64+0x3e/0xb0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   ---[ end trace d17eb998aee991da ]---

Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db369a64f29..a6e42ce607ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10743,9 +10743,13 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
 {
 	struct x86_exception fault;
+	const unsigned access_mask =
+		PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK;
 
 	if (!(error_code & PFERR_PRESENT_MASK) ||
-	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, error_code, &fault) != UNMAPPED_GVA) {
+	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva,
+					    error_code & access_mask,
+					    &fault) != UNMAPPED_GVA) {
 		/*
 		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
 		 * tables probably do not match the TLB.  Just proceed
-- 
2.26.2


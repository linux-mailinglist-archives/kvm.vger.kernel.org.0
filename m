Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDDA3B18F0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhFWLcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhFWLcu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tum1CTGmPm04rKghm9LyJ7SukpoUTV1Aobxrma6xMTo=;
        b=Z16SBlBxUgzMsqCcNAxb1TTcQRwXAA+XDv+XdZ0OPvoziuo3qTvbwsFggoJV22P7psfnVi
        BGRpDOuTHQpBA2SYiKga/Qn+nb50Ol4iDAbVDERI8d4TblM1d+JTljonIWsE8ylnHY2PoT
        NHUWTWYxTiKk/5WgPIhqMzBXFc3yDAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-aGrPNkyKO4G2w9O9nLzuHQ-1; Wed, 23 Jun 2021 07:30:29 -0400
X-MC-Unique: aGrPNkyKO4G2w9O9nLzuHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F62A19067E0;
        Wed, 23 Jun 2021 11:30:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFD6D18428;
        Wed, 23 Jun 2021 11:30:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 04/10] KVM: SVM: add warning for mistmatch between AVIC state and AVIC access page state
Date:   Wed, 23 Jun 2021 14:29:56 +0300
Message-Id: <20210623113002.111448-5-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is never a good idea to enter a guest when the AVIC state doesn't match
the state of the AVIC MMIO memory slot.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12c06ea28f5c..50405c561394 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3780,6 +3780,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pre_svm_run(vcpu);
 
+	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
+		     kvm_vcpu_apicv_active(vcpu));
+
 	sync_lapic_to_cr8(vcpu);
 
 	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-- 
2.26.3


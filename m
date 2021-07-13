Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E1B3C7209
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhGMOXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236917AbhGMOXv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIa8h4OP7mxNX4HqLsB2yEzaUhCUBYXl4u9g4DRB7tM=;
        b=Nylw6AEMz91RGVyDcfuZl5zZ3xKaBB4qWu/cce3v2KwxIwlGzT1nE0rlbFo9rYZk0rouKJ
        BzJRmPiKOUrLZo+DiMiLPrhJl0xbw8gHiUZu+RLpwzBRH2/1ZVYaifPVHv0DIl2FMR0Yln
        mgRwlUgARPZT1geu1Ul11pVWnp/2T/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243--iMWNmwoMw6QEOS7EMR3LQ-1; Tue, 13 Jul 2021 10:20:59 -0400
X-MC-Unique: -iMWNmwoMw6QEOS7EMR3LQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCA18100CA8A;
        Tue, 13 Jul 2021 14:20:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FB125D6AB;
        Tue, 13 Jul 2021 14:20:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 6/8] KVM: SVM: add warning for mistmatch between AVIC state and AVIC access page state
Date:   Tue, 13 Jul 2021 17:20:21 +0300
Message-Id: <20210713142023.106183-7-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is never a good idea to enter a guest when AVIC state doesn't match
the state of the AVIC MMIO page state.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4d14e318ab5..d14be8aba2d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3783,6 +3783,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pre_svm_run(vcpu);
 
+	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
+		     kvm_vcpu_apicv_active(vcpu));
+
 	sync_lapic_to_cr8(vcpu);
 
 	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-- 
2.26.3


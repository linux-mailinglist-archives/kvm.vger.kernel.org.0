Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4362C3DDF4A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhHBSe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232249AbhHBSeV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4i+FN8C1wl9Zuq0S0DvCaERyy5ricnHZCno8hajsU+g=;
        b=F3bdDQTitICGQKp1neEMwsFVaUoWFSI51XXHXx4qq4EjPjIzXlRrUrYnvD9+xtEiUcHYAj
        fRUV3iY25rWsM9ck4UA3hX22JFwSAS1NBUATRydZIFCHiZ9fMryjdwrDIqHGe45Q9o7mVG
        PkYchSwWm0+lJzMzpYNpdUqN9xNF8CQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-jaM7SvrvOvya0wCXi-I98Q-1; Mon, 02 Aug 2021 14:34:10 -0400
X-MC-Unique: jaM7SvrvOvya0wCXi-I98Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA00F3639F;
        Mon,  2 Aug 2021 18:34:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 810D83B02;
        Mon,  2 Aug 2021 18:34:02 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 08/12] KVM: SVM: add warning for mistmatch between AVIC state and AVIC access page state
Date:   Mon,  2 Aug 2021 21:33:25 +0300
Message-Id: <20210802183329.2309921-9-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 4feff53dd1d3..3923d383face 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3781,6 +3781,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pre_svm_run(vcpu);
 
+	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
+		     kvm_vcpu_apicv_active(vcpu));
+
 	sync_lapic_to_cr8(vcpu);
 
 	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-- 
2.26.3


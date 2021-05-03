Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63031371586
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhECM4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233995AbhECM4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xkkVfn9TpT53mrvYYNcxvOEmriMUhwwVeXNf2+DjjRY=;
        b=BcUXCQXo3Wtf7zOWjv/kFLks6dHt2RWewiIYoCSnW5CJ5t28muRP2vB82Ha7wKAmJh3t6s
        dLvtAm0aXOmW/YdzZo/cKqfODowgYiQ15P4SvkEJoUUt2sP1UtFWiJx6EJlT6MGGzPcIBr
        KLgr/Ky+hyi+hjObNZl023QWMo7VS6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-XgbUNEq-OFS03402vmyisQ-1; Mon, 03 May 2021 08:55:17 -0400
X-MC-Unique: XgbUNEq-OFS03402vmyisQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C69FA106B257;
        Mon,  3 May 2021 12:55:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E8D8756A4;
        Mon,  3 May 2021 12:55:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/5] KVM: nSVM: set a dummy exit reason in L1 vmcb when loading the nested state
Date:   Mon,  3 May 2021 15:54:46 +0300
Message-Id: <20210503125446.1353307-6-mlevitsk@redhat.com>
In-Reply-To: <20210503125446.1353307-1-mlevitsk@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the nested migration is a result of a VMRUN, this makes it
possible to keep a warning that L1 vmcb should always have
VMRUN exit reason when switching back to it, which
otherwise triggers incorrectly.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 12a12ae940fa..146be4b5084b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1338,6 +1338,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm->vmcb01.ptr->save.rip = save->rip;
 	svm->vmcb01.ptr->save.cpl = 0;
 
+	/*
+	 * For consistency sake, restore the L1 exit reason
+	 * (that happened prior to the migration) to SVM_EXIT_VMRUN.
+	 */
+	svm->vmcb->control.exit_code = SVM_EXIT_VMRUN;
+
 	nested_load_control_from_vmcb12(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-- 
2.26.2


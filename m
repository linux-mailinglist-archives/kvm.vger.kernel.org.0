Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3921A294
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgGIOyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727814AbgGIOyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 10:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OkhWN9XI/HC21/2OiJMRv96UCzqp2quwlazUkUpR+k=;
        b=Jqke3kASvK9Gu/T2TMBUTCyMLWWLPm6Q6IRlGBep4Vh+nWFwonO7Zn0augj+IsoMl49m0t
        PT5ui6U+rqxa0WLPfVoQ5ObyyIifk957DDiEEBW82kHhanLUD0q5+jA1Rgl27z/ic/U650
        Kyx41eXzVMKUArb8IT9rNf5hTk94Xqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-vqZ6nCWiO-62dSg3pNlpWQ-1; Thu, 09 Jul 2020 10:54:15 -0400
X-MC-Unique: vqZ6nCWiO-62dSg3pNlpWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0B95100A8EB;
        Thu,  9 Jul 2020 14:54:13 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B65E60E1C;
        Thu,  9 Jul 2020 14:54:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/9] KVM: nSVM: reset nested_run_pending upon nested_svm_vmrun_msrpm() failure
Date:   Thu,  9 Jul 2020 16:53:52 +0200
Message-Id: <20200709145358.1560330-4-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN_ON_ONCE(svm->nested.nested_run_pending) in nested_svm_vmexit()
will fire if nested_run_pending remains '1' but it doesn't really
need to, we are already failing and not going to run nested guest.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e424bce13e6c..1cc8592b1820 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -468,6 +468,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
+		svm->nested.nested_run_pending = 0;
+
 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 		svm->vmcb->control.exit_code_hi = 0;
 		svm->vmcb->control.exit_info_1  = 0;
-- 
2.25.4


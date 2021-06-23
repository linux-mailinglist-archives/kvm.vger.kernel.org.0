Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85683B18F7
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFWLdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:33:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhFWLdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CjgrkpT1XZ7YgIRuKXYjRPMRpWpXq21IXhBaCP4M988=;
        b=YY8qmRmsaB53HskWzSUC+LyQiCZf2d0sCETntoqEInZIQgr6IYl1/78sgWKLUUnEyAtk0w
        EUJ/n/bUmvwyg609tbd1g7OcnV/Ea3FRZW57ZHYsM7UadRE9Q+we5899TMbk+SiZhI8vuL
        nOJcErjjuqHZc2jLz/cvmIuPTtNY3BA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-F3kOCSHjMXOJ0imrIT0mgA-1; Wed, 23 Jun 2021 07:30:42 -0400
X-MC-Unique: F3kOCSHjMXOJ0imrIT0mgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B2EA1084F5A;
        Wed, 23 Jun 2021 11:30:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C835B5D705;
        Wed, 23 Jun 2021 11:30:36 +0000 (UTC)
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
Subject: [PATCH 07/10] KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl
Date:   Wed, 23 Jun 2021 14:29:59 +0300
Message-Id: <20210623113002.111448-8-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVIC is not supported for nesting but in some corner
cases it is possible to have it still be enabled,
after we entered nesting, and use vmcb02.

Fix this by always using vmcb01 in svm_refresh_apicv_exec_ctrl

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1d01da64c333..a8ad78a2faa1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -646,7 +646,7 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 	bool activated = kvm_vcpu_apicv_active(vcpu);
 
 	if (!enable_apicv)
-- 
2.26.3


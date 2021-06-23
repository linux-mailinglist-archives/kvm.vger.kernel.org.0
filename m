Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972163B18F2
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFWLc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhFWLcw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kyV08rMmmvEQF3eJw4Z6JVOY9gBgkXpDBjcpnJt2ooo=;
        b=fc72iwVZoxrY999gVSev4t6stJWfhQYWeZPtTNMF1+aZ/RVcD2gcgF9i9NAzpLjzi43qMj
        G2NevYzdVVJxNUhGag99YfSCc+bsH4cI72Izi8cKZwtB/1Wnul8MQC8RLFUMEd9loC8c56
        trtWKYRoNxo1EKl8h3/3Z9QseOaolK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-kUK3cQYnNMuZQgkmnNVfTQ-1; Wed, 23 Jun 2021 07:30:33 -0400
X-MC-Unique: kUK3cQYnNMuZQgkmnNVfTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194E6800C60;
        Wed, 23 Jun 2021 11:30:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A72C5D740;
        Wed, 23 Jun 2021 11:30:27 +0000 (UTC)
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
Subject: [PATCH 05/10] KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to be deactivated
Date:   Wed, 23 Jun 2021 14:29:57 +0300
Message-Id: <20210623113002.111448-6-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible for AVIC inhibit and AVIC active state to be mismatched.
Currently we disable AVIC right away on vCPU which started the AVIC inhibit
request thus this warning doesn't trigger but at least in theory,
if svm_set_vintr is called at the same time on multiple vCPUs,
the warning can happen.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 50405c561394..d14be8aba2d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1560,8 +1560,11 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control;
 
-	/* The following fields are ignored when AVIC is enabled */
-	WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
+	/*
+	 * The following fields are ignored when AVIC is enabled
+	 */
+	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
+
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
 	/*
-- 
2.26.3


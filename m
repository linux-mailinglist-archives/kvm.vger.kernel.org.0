Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD41387B85
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbhEROpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:45:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236568AbhEROpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 10:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621349035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyZqA/lEHopR022+gKHNImNj/1J/RllfZJqdZZCyKE8=;
        b=Qm/B4UTGfqpRapWU+letDU+kVDkLU5BMkEBsnBEI4ZGGNPjfgFGJnnTByo5qHc+gkDJlBk
        NnfqhRFk6PUXDM7HUszfqRAlhxZmnLsf1rN04dTzs40gdFlGiGppqCmOO3b/4ZPjgsI3iD
        0tWyiBElbO78TMzBkZ94SGVDFOYdL7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-dNVZV9U-N7eTZ9Z8ya5iUg-1; Tue, 18 May 2021 10:43:51 -0400
X-MC-Unique: dNVZV9U-N7eTZ9Z8ya5iUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCFFA8049D1;
        Tue, 18 May 2021 14:43:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91AFC1349A;
        Tue, 18 May 2021 14:43:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check for AVIC
Date:   Tue, 18 May 2021 16:43:35 +0200
Message-Id: <20210518144339.1987982-2-vkuznets@redhat.com>
In-Reply-To: <20210518144339.1987982-1-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVIC dependency on CONFIG_X86_LOCAL_APIC is dead code since
commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 --
 arch/x86/kvm/svm/svm.c  | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712b4e0de481..1c1bf911e02b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -29,9 +29,7 @@
 
 /* enable / disable AVIC */
 int avic;
-#ifdef CONFIG_X86_LOCAL_APIC
 module_param(avic, int, S_IRUGO);
-#endif
 
 #define SVM_AVIC_DOORBELL	0xc001011b
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa351e605de..8c3918a11826 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1010,9 +1010,7 @@ static __init int svm_hardware_setup(void)
 	}
 
 	if (avic) {
-		if (!npt_enabled ||
-		    !boot_cpu_has(X86_FEATURE_AVIC) ||
-		    !IS_ENABLED(CONFIG_X86_LOCAL_APIC)) {
+		if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC)) {
 			avic = false;
 		} else {
 			pr_info("AVIC enabled\n");
-- 
2.31.1


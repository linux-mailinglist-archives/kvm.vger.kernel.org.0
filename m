Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E80835F3E4
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 14:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350961AbhDNMgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 08:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350951AbhDNMgQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 08:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618403755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dKkaTH7hpNFzDTl2DIM6SgVCwH1tMksVM+Mg4H8vkI=;
        b=M9mdFncKiY0efB915An8YOe2WzgZjhF88NegEp6acK/UJPj6QJIEsaGKEzLQ89Z6f/luq6
        r8lBDhJljvVlreVCkDp6Gap+Svsb1lJLnaESIZo6Ria+w+KGiKck4/5vVIL/Gd2KYcDnYu
        4Qn4J4DqQmeEijv5SJPR5kPVH8ovXiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-mX3ssg0zNa-s_Yw0bGJN1g-1; Wed, 14 Apr 2021 08:35:53 -0400
X-MC-Unique: mX3ssg0zNa-s_Yw0bGJN1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B549188353B;
        Wed, 14 Apr 2021 12:35:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86C285D9DE;
        Wed, 14 Apr 2021 12:35:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Mohamed Aboubakr <mabouba@amazon.com>,
        Xiaoyi Chen <cxiaoyi@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86/kvm: Fix pr_info() for async PF setup/teardown
Date:   Wed, 14 Apr 2021 14:35:40 +0200
Message-Id: <20210414123544.1060604-2-vkuznets@redhat.com>
In-Reply-To: <20210414123544.1060604-1-vkuznets@redhat.com>
References: <20210414123544.1060604-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'pr_fmt' already has 'kvm-guest: ' so 'KVM' prefix is redundant.
"Unregister pv shared memory" is very ambiguous, it's hard to
say which particular PV feature it relates to.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kernel/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 78bb0fae3982..79dddcc178e3 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -345,7 +345,7 @@ static void kvm_guest_cpu_init(void)
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
-		pr_info("KVM setup async PF for cpu %d\n", smp_processor_id());
+		pr_info("setup async PF for cpu %d\n", smp_processor_id());
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
@@ -371,7 +371,7 @@ static void kvm_pv_disable_apf(void)
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
 	__this_cpu_write(apf_reason.enabled, 0);
 
-	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
+	pr_info("disable async PF for cpu %d\n", smp_processor_id());
 }
 
 static void kvm_pv_guest_cpu_reboot(void *unused)
-- 
2.30.2


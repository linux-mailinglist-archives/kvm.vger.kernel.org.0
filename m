Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7D462ED6
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 09:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhK3Iul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 03:50:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239783AbhK3Iud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 03:50:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638262033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iHEcxWX/hnu+skhv46r4CV8pF6jbkPwZ6560HYUpego=;
        b=Y3Efly1pd0RStRYyNiOMrEMAZRGqRsZyokaS3IYhk231VUNstX/ntKo+J1outAOETivJK+
        Ky8VKl5TTD5MP2zX+RyCQCySXTZlIcrVTtky+mkIhqYf/OxBgeLn1dJos6XKqy+7Mm7emZ
        /5iLn3cxpROmJHsEwYTgredQcU8sh5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-ekjKe4tSMBe_3qw00V5qcg-1; Tue, 30 Nov 2021 03:47:09 -0500
X-MC-Unique: ekjKe4tSMBe_3qw00V5qcg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D23410168C3;
        Tue, 30 Nov 2021 08:47:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B72045DF3A;
        Tue, 30 Nov 2021 08:46:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: fix avic_set_running for preemptable kernels
Date:   Tue, 30 Nov 2021 03:46:44 -0500
Message-Id: <20211130084644.248435-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

avic_set_running() passes the current CPU to avic_vcpu_load(), albeit
via vcpu->cpu rather than smp_processor_id().  If the thread is migrated
while avic_set_running runs, the call to avic_vcpu_load() can use a stale
value for the processor id.  Avoid this by blocking preemption over the
entire execution of avic_set_running().

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0a58283005f3..560807a2edd4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1000,16 +1000,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int cpu = get_cpu();
 
+	WARN_ON(cpu != vcpu->cpu);
 	svm->avic_is_running = is_run;
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		if (is_run)
+			avic_vcpu_load(vcpu, cpu);
+		else
+			avic_vcpu_put(vcpu);
+	}
+	put_cpu();
 }
 
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.31.1


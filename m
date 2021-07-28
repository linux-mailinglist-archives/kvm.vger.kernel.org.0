Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7DD3D8D30
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 13:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhG1LxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 07:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234638AbhG1LxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 07:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627473201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8WAexIXwMU6WXsuKm8nm0H68XqR0D98nZayVKGg2cZM=;
        b=A2JFve8+a2E6ikhx24Z4GFozqGfIdik3FSrPFu1DzKdahg95nM834sZs/qt7nQW+kHGZCl
        sKNLXD6kvo6MDjFmKX49UmIqUYDtRooXbo/H+jxhMz44as/j7CLpCtsO2+rO1yz3M1DPj2
        uqWquLcMSuU+Afmqqpm0y7GgkOhbpQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-UKvLjqBnP7WWR8bqZqaKrA-1; Wed, 28 Jul 2021 07:53:19 -0400
X-MC-Unique: UKvLjqBnP7WWR8bqZqaKrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A7B1101C8AA;
        Wed, 28 Jul 2021 11:53:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2536C60854;
        Wed, 28 Jul 2021 11:53:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: x86: Exit to userspace when kvm_check_nested_events fails
Date:   Wed, 28 Jul 2021 07:53:17 -0400
Message-Id: <20210728115317.1930332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

If kvm_check_nested_events fails due to raising an
EXIT_REASON_INTERNAL_ERROR, propagate it to userspace
immediately, even if the vCPU would otherwise be sleeping.
This happens for example when the posted interrupt descriptor
points outside guest memory.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 348452bb16bc..916c976e99ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9752,10 +9752,14 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
+static inline int kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
+	int r;
+	if (is_guest_mode(vcpu)) {
+		r = kvm_check_nested_events(vcpu);
+		if (r < 0 && r != -EBUSY)
+			return r;
+	}
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
@@ -9770,12 +9774,16 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
-		if (kvm_vcpu_running(vcpu)) {
-			r = vcpu_enter_guest(vcpu);
-		} else {
-			r = vcpu_block(kvm, vcpu);
+		r = kvm_vcpu_running(vcpu);
+		if (r < 0) {
+			r = 0;
+			break;
 		}
 
+		if (r)
+			r = vcpu_enter_guest(vcpu);
+		else
+			r = vcpu_block(kvm, vcpu);
 		if (r <= 0)
 			break;
 
-- 
2.27.0


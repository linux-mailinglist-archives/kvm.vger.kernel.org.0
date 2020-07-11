Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2A21C372
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 12:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGKKEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 06:04:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50489 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbgGKKEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jul 2020 06:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594461884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+UmIX9bjp1SsTNPgtJx0GFQxPx7B6KTaPKfrg10fpU=;
        b=jDc2COYMRS+PqXB5tQFln31AOne/CgSW1KBxDFzbbDvmtbAv8FiENo2lKO1g1nlgZGb5Fy
        ci8eXt2wHuGhdbgjZ0KspDooArHCSDjFzB5Wt76MV5hXnkQ46j9XZilXcXE70Y/Y4bopw9
        m1ngueaXejzOtj1NVEAtjNO4miMaCKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-LzASmirmOQ2Eg7629F0cTw-1; Sat, 11 Jul 2020 06:04:40 -0400
X-MC-Unique: LzASmirmOQ2Eg7629F0cTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 980F780183C;
        Sat, 11 Jul 2020 10:04:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA87619D61;
        Sat, 11 Jul 2020 10:04:37 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported when configured
Date:   Sat, 11 Jul 2020 12:04:30 +0200
Message-Id: <20200711100434.46660-2-drjones@redhat.com>
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't confuse the guest by saying steal-time is supported when
it hasn't been configured by userspace and won't work.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index f7b52ce1557e..2b22214909be 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -42,9 +42,12 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
-	case ARM_SMCCC_HV_PV_TIME_ST:
 		val = SMCCC_RET_SUCCESS;
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		if (vcpu->arch.steal.base != GPA_INVALID)
+			val = SMCCC_RET_SUCCESS;
+		break;
 	}
 
 	return val;
-- 
2.25.4


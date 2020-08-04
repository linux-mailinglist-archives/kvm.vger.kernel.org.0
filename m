Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11F723BE9E
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgHDRIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53983 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729628AbgHDRI2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 13:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HlVkiJnSNVI4x7t+z04fPiRVA5fdQRUo1magtB6wKU=;
        b=MC4JjPyP84Mpod7QqOamBjQXgfIWMsSO2CXAoZSrzDsj/etuipNq3uiIYGUyW67YVtTaMq
        pb64cAGHpWQQtTCAC50gksxHfh8mAHqntZ/C17zYksc16HP5ErO+V1K/SkbHUTSbLxzGsZ
        7WJvCS/U1l5w2Wugycm84jImnsgwvps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-LBjWo_doM36pEaK3DmHtUg-1; Tue, 04 Aug 2020 13:06:13 -0400
X-MC-Unique: LBjWo_doM36pEaK3DmHtUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2A36106B243;
        Tue,  4 Aug 2020 17:06:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA4C88D58;
        Tue,  4 Aug 2020 17:06:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 2/6] KVM: arm64: pvtime: Fix potential loss of stolen time
Date:   Tue,  4 Aug 2020 19:06:00 +0200
Message-Id: <20200804170604.42662-3-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should only check current->sched_info.run_delay once when
updating stolen time. Otherwise there's a chance there could
be a change between checks that we miss (preemption disabling
comes after vcpu request checks).

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index c3ef4ebd6846..95f9580275b1 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -13,6 +13,7 @@
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
+	u64 last_steal = vcpu->arch.steal.last_steal;
 	u64 steal;
 	__le64 steal_le;
 	u64 offset;
@@ -24,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 
 	/* Let's do the local bookkeeping */
 	steal = vcpu->arch.steal.steal;
-	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
-	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
+	steal += vcpu->arch.steal.last_steal - last_steal;
 	vcpu->arch.steal.steal = steal;
 
 	steal_le = cpu_to_le64(steal);
-- 
2.25.4


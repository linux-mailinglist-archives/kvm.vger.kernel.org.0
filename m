Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E569021C373
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 12:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGKKEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 06:04:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgGKKEp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Jul 2020 06:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594461884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aSv5IXYYxd1NQmBH+MOSA+b9yG3TWpxn7m1nNIW/CVc=;
        b=JntBp8QkjmvBs7+VQaDr0ibV4ESicHL+GLrVyeKIQiSqqhVCuto2un0jBsnC6CFD+PZoN/
        bC9zorU+wA0CtMCX92OR3rNHLEWs+mT82eIEEfppUdvW+hxoTOEXlF44abFe6tsEymyzQq
        mtUAPXudPVaNnvxKDVUOS/5LgTykRjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-wJHDSJtkMC-mYWyIQerywg-1; Sat, 11 Jul 2020 06:04:42 -0400
X-MC-Unique: wJHDSJtkMC-mYWyIQerywg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5569102C7ED;
        Sat, 11 Jul 2020 10:04:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 022E719D61;
        Sat, 11 Jul 2020 10:04:39 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 2/5] KVM: arm64: pvtime: Fix potential loss of stolen time
Date:   Sat, 11 Jul 2020 12:04:31 +0200
Message-Id: <20200711100434.46660-3-drjones@redhat.com>
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 arch/arm64/kvm/pvtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 2b22214909be..db5ef097a166 100644
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
 	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	steal += vcpu->arch.steal.last_steal - last_steal;
 	vcpu->arch.steal.steal = steal;
 
 	steal_le = cpu_to_le64(steal);
-- 
2.25.4


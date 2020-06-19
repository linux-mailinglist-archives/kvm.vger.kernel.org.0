Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98022201AA8
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392389AbgFSSqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:46:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390079AbgFSSqo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 14:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592592404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zt6Anjj0Yd0Vhhr8BqGCZDNMc9cFRPQZ9/9/Ct6l9YM=;
        b=Xt84BPf3Rimzf0k7ZVYHmSZiCTH2+pL2NvDGwjcthsqCL87sF44Oo8tP3bL5Bj261tPBLU
        XGJUmbHiG/qleR+qKNPF0yJ7BIu651b/up1AO1OxxqDscMSDXci6320ruQFfV7wh1R8tYL
        WHsKLO1H/E50vH6KchNhgR7Q5xs5UxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-HPkS2LdGPOWwugwanhNd6w-1; Fri, 19 Jun 2020 14:46:42 -0400
X-MC-Unique: HPkS2LdGPOWwugwanhNd6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12811052502;
        Fri, 19 Jun 2020 18:46:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DB1160C81;
        Fri, 19 Jun 2020 18:46:38 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 4/4] KVM: selftests: Use KVM_CAP_STEAL_TIME
Date:   Fri, 19 Jun 2020 20:46:29 +0200
Message-Id: <20200619184629.58653-5-drjones@redhat.com>
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/steal_time.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fcc840088c91..704bd3ee799a 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -70,6 +70,10 @@ static void steal_time_init(struct kvm_vm *vm)
 		exit(KSFT_SKIP);
 	}
 
+#ifdef KVM_CAP_STEAL_TIME
+	TEST_ASSERT(kvm_check_cap(KVM_CAP_STEAL_TIME), "CAP doesn't match CPUID feature");
+#endif
+
 	for (i = 0; i < NR_VCPUS; ++i) {
 		int ret;
 
@@ -177,8 +181,12 @@ static void steal_time_init(struct kvm_vm *vm)
 	};
 	int i, ret;
 
+#ifndef KVM_CAP_STEAL_TIME
 	ret = _vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
 	if (ret != 0 && errno == ENXIO) {
+#else
+	if (!kvm_check_cap(KVM_CAP_STEAL_TIME)) {
+#endif
 		print_skip("steal-time not supported");
 		exit(KSFT_SKIP);
 	}
-- 
2.25.4


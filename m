Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3453C7815
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhGMUkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhGMUkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 16:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626208668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3BE+KBwmpKZs3HfTywA3YepA+ZFEmEvW/zZIsH9yzY=;
        b=aFNIw4XIj7NWs/l8kpBXo81ObNfYetfTQJKCWkxCWYhEgVgGE/ATRO44JKl52r/Nhv4H1o
        nrtJq5Jam33yB7VKlON8YZGO5cEd4Ww/PIMAGT94BnNQHEKuGhXYEfp+TjWLTytDoGH/tC
        BibkcjWFqcvi1x6bKnBp+KXNiVZUxyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-OxfjYbIcPK2i_muuum3CcA-1; Tue, 13 Jul 2021 16:37:47 -0400
X-MC-Unique: OxfjYbIcPK2i_muuum3CcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CB3E804145;
        Tue, 13 Jul 2021 20:37:46 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.22.8.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4581002D71;
        Tue, 13 Jul 2021 20:37:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com
Subject: [PATCH 2/2] KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist
Date:   Tue, 13 Jul 2021 22:37:42 +0200
Message-Id: <20210713203742.29680-3-drjones@redhat.com>
In-Reply-To: <20210713203742.29680-1-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We reworked get-reg-list to make it easier to enable optional register
sublists by parametrizing their vcpu feature flags as well as making
other generalizations. That was all to make sure we enable the PMU
registers when we want to test them. Somehow we forgot to actually
include the PMU feature flag in the PMU sublist description though!
Do that now.

Fixes: 313673bad871 ("KVM: arm64: selftests: get-reg-list: Split base and pmu registers")
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index a16c8f05366c..cc898181faab 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -1019,7 +1019,8 @@ static __u64 sve_rejects_set[] = {
 #define VREGS_SUBLIST \
 	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
 #define PMU_SUBLIST \
-	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
+	{ "pmu", .capability = KVM_CAP_ARM_PMU_V3, .feature = KVM_ARM_VCPU_PMU_V3, \
+	  .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
 #define SVE_SUBLIST \
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
-- 
2.31.1


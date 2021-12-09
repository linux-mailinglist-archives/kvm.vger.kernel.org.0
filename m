Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9546F3A7
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 20:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhLITOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 14:14:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhLITOl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 14:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639077067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JMaWWP821bwJCvNI5VTsjKW9n6DlPFaj+di/EZl3hBk=;
        b=AKwdZHzjNPbog2munRWrzxlHT/rCrr5odyqL81lqkVhToPQwPiXD0ZyEtJ9Ww5qZ4DABsv
        p+7Zi5FxeJ0Ixx/L2yV5sf03iLcn8dSXlYnvu0MFnbEsZmIlaFNYlCb3ssVXu4oI1VZrWD
        7CeABpOOB+0ZGUSn5rLl3oV8AhueQRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-kr0UCeqiOa-TMjDIn5vc8g-1; Thu, 09 Dec 2021 14:11:05 -0500
X-MC-Unique: kr0UCeqiOa-TMjDIn5vc8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8D9480573B;
        Thu,  9 Dec 2021 19:11:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F49F78374;
        Thu,  9 Dec 2021 19:11:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, like.xu.linux@gmail.com, wanpengli@tencent.com
Subject: [PATCH] KVM: x86: avoid out of bounds indices for fixed performance counters
Date:   Thu,  9 Dec 2021 14:11:01 -0500
Message-Id: <20211209191101.288041-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because IceLake has 4 fixed performance counters but KVM only supports 3,
it is possible for reprogram_fixed_counters to pass to
reprogram_fixed_counter an index that is out of bounds for
the fixed_pmc_events array.

Ultimately intel_find_fixed_event, which is the only place that uses
fixed_pmc_events, handles this correctly because it checks against the
size of fixed_pmc_events anyway.  Every other place
operates on the fixed_counters[] array which is sized
according to INTEL_PMC_MAX_FIXED.  However, it is cleaner if
the unsupported performance counters are culled early on
in reprogram_fixed_counters.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b7456b2177b..d33e9799276e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -91,7 +91,7 @@ static unsigned intel_find_fixed_event(int idx)
 	u32 event;
 	size_t size = ARRAY_SIZE(fixed_pmc_events);
 
-	if (idx >= size)
+	if (WARN_ON_ONCE(idx >= size))
 		return PERF_COUNT_HW_MAX;
 
 	event = fixed_pmc_events[array_index_nospec(idx, size)];
@@ -500,8 +500,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters = 0;
 	} else {
 		pmu->nr_arch_fixed_counters =
-			min_t(int, edx.split.num_counters_fixed,
-			      x86_pmu.num_counters_fixed);
+			min3(ARRAY_SIZE(fixed_pmc_events),
+			     (size_t) edx.split.num_counters_fixed,
+			     (size_t) x86_pmu.num_counters_fixed);
 		edx.split.bit_width_fixed = min_t(int,
 			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
-- 
2.31.1


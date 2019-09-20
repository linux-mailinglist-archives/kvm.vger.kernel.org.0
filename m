Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461A3B9902
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394017AbfITV0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:26:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391072AbfITVZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:13 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32F81308123B;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15B945D6B2;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] KVM: monolithic: x86: enable the kvm_pmu_ops external functions
Date:   Fri, 20 Sep 2019 17:24:58 -0400
Message-Id: <20190920212509.2578-7-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Plug in the new external functions and their extern declarations in
the respective kernel modules (kvm-intel and kvm-amd).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/pmu.h           | 2 ++
 arch/x86/kvm/pmu_amd.c       | 2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..a9c2f68a40cc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -19,6 +19,8 @@ struct kvm_event_hw_type_mapping {
 	unsigned event_type;
 };
 
+#include "pmu_ops.h"
+
 struct kvm_pmu_ops {
 	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
 				    u8 unit_mask);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index c8388389a3b0..12d1fa3ba35a 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -301,6 +301,8 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+#include "pmu_amd_ops.c"
+
 struct kvm_pmu_ops amd_pmu_ops = {
 	.find_arch_event = amd_find_arch_event,
 	.find_fixed_event = amd_find_fixed_event,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e39..5ef36a75c31e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -358,6 +358,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+#include "pmu_intel_ops.c"
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,

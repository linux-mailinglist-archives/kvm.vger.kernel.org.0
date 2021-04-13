Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B135DECC
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbhDMM2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345624AbhDMM1c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5RkoZJPpYuUMwwp56iKJSKnffXVtZjSnsRl9pwHa2c=;
        b=PxmMyxYONnHzgC2z7O1QYxGNoiIa1pQbEJBjERdxW5esNno36xs0XMDKxTK8dlX9yK9Th4
        DKWqGVlkjxCqw3Zfmi6beb0XmUBnNeUzBgYV1aM0RJI/zAYeoF6S9kzlKHr58qycEA2LLO
        ljLCgx9ZgMP8Tzo8FPGcEOrWN1AGHYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-YHyVfSzTPKSXDiv9RMVFTQ-1; Tue, 13 Apr 2021 08:27:10 -0400
X-MC-Unique: YHyVfSzTPKSXDiv9RMVFTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2805107ACC7;
        Tue, 13 Apr 2021 12:27:08 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6A960C04;
        Tue, 13 Apr 2021 12:27:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 10/22] KVM: x86: hyper-v: Honor HV_MSR_SYNTIMER_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:18 +0200
Message-Id: <20210413122630.975617-11-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic timers MSRs (HV_X64_MSR_STIMER[0-3]_CONFIG,
HV_X64_MSR_STIMER[0-3]_COUNT) are only available to guest when
HV_MSR_SYNTIMER_AVAILABLE bit is exposed.

While on it, complement stimer_get_config()/stimer_get_count() with
the same '!synic->active' check we have in stimer_set_config()/
stimer_set_count().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d85c441011c4..032305ad5615 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -637,7 +637,9 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (unlikely(!host && (!synic->active ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+				 HV_MSR_SYNTIMER_AVAILABLE))))
 		return 1;
 
 	trace_kvm_hv_stimer_set_config(hv_stimer_to_vcpu(stimer)->vcpu_id,
@@ -661,7 +663,9 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (unlikely(!host && (!synic->active ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+				 HV_MSR_SYNTIMER_AVAILABLE))))
 		return 1;
 
 	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,
@@ -680,14 +684,32 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	return 0;
 }
 
-static int stimer_get_config(struct kvm_vcpu_hv_stimer *stimer, u64 *pconfig)
+static int stimer_get_config(struct kvm_vcpu_hv_stimer *stimer, u64 *pconfig,
+			     bool host)
 {
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
+
+	if (unlikely(!host && (!synic->active ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+				 HV_MSR_SYNTIMER_AVAILABLE))))
+		return 1;
+
 	*pconfig = stimer->config.as_uint64;
 	return 0;
 }
 
-static int stimer_get_count(struct kvm_vcpu_hv_stimer *stimer, u64 *pcount)
+static int stimer_get_count(struct kvm_vcpu_hv_stimer *stimer, u64 *pcount,
+			    bool host)
 {
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
+
+	if (unlikely(!host && (!synic->active ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+				 HV_MSR_SYNTIMER_AVAILABLE))))
+		return 1;
+
 	*pcount = stimer->count;
 	return 0;
 }
@@ -1571,7 +1593,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		int timer_index = (msr - HV_X64_MSR_STIMER0_CONFIG)/2;
 
 		return stimer_get_config(to_hv_stimer(vcpu, timer_index),
-					 pdata);
+					 pdata, host);
 	}
 	case HV_X64_MSR_STIMER0_COUNT:
 	case HV_X64_MSR_STIMER1_COUNT:
@@ -1580,7 +1602,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		int timer_index = (msr - HV_X64_MSR_STIMER0_COUNT)/2;
 
 		return stimer_get_count(to_hv_stimer(vcpu, timer_index),
-					pdata);
+					pdata, host);
 	}
 	case HV_X64_MSR_TSC_FREQUENCY:
 		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
-- 
2.30.2


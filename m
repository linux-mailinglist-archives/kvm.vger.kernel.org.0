Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276C338C3F2
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhEUJzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235807AbhEUJyM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8EWwZqFoaBcdfJhsEam+65aHB3SYeclKlGOWW0aLIg=;
        b=JsyApk2ildWdkrbqyS1egQZdpwEZK2va2AeM6JTp0wTMtmmpMSPVW5uygthEV2QSx4TYwt
        +mGszGRCWkh6QMaLdt8uLzWyQy8A5rAgs4RlfQPvRXbVacMP0wOyGInRi+81EdHgX34wFi
        qD8PjqVPH/V4ldR9x5yhIsp7210VrQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-xb0gLtfhPgWTecK-0x9yJg-1; Fri, 21 May 2021 05:52:43 -0400
X-MC-Unique: xb0gLtfhPgWTecK-0x9yJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73317101F7AD;
        Fri, 21 May 2021 09:52:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24E24687F7;
        Fri, 21 May 2021 09:52:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/30] KVM: x86: hyper-v: Honor HV_MSR_SYNTIMER_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:46 +0200
Message-Id: <20210521095204.2161214-13-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic timers MSRs (HV_X64_MSR_STIMER[0-3]_CONFIG,
HV_X64_MSR_STIMER[0-3]_COUNT) are only available to guest when
HV_MSR_SYNTIMER_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 17bdf8e8196e..2582c23126fa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1227,6 +1227,16 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_SYNIC_AVAILABLE;
+	case HV_X64_MSR_STIMER0_CONFIG:
+	case HV_X64_MSR_STIMER1_CONFIG:
+	case HV_X64_MSR_STIMER2_CONFIG:
+	case HV_X64_MSR_STIMER3_CONFIG:
+	case HV_X64_MSR_STIMER0_COUNT:
+	case HV_X64_MSR_STIMER1_COUNT:
+	case HV_X64_MSR_STIMER2_COUNT:
+	case HV_X64_MSR_STIMER3_COUNT:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_SYNTIMER_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.31.1


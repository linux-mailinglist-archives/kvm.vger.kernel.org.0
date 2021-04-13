Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84E35DED4
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbhDMM2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345659AbhDMM1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGKsPnVxHN+rV7QkwVZgihnSFhdmtIKMdN32lHyLDqk=;
        b=SainEpSFASp4OjGkJwMVW/RtokiQlmc05M3UXTpJsFtq/NQsR4+7bFji4BntU0zNq++y9Z
        JrkH6MsTLxi3GK7C/6enuwvwKfp3baZXZ/qDwtf5M9PdqKHGogRX8Wq3Z9AktZd724Wfxz
        56N+joMxB+rDM7cz/hY2wZvBAceI3UY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-viQY6Q-eO7KDnPY6o4UhCQ-1; Tue, 13 Apr 2021 08:27:20 -0400
X-MC-Unique: viQY6Q-eO7KDnPY6o4UhCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E479A40C0;
        Tue, 13 Apr 2021 12:27:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DACB260C04;
        Tue, 13 Apr 2021 12:27:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 13/22] KVM: x86: hyper-v: Honor HV_ACCESS_REENLIGHTENMENT privilege bit
Date:   Tue, 13 Apr 2021 14:26:21 +0200
Message-Id: <20210413122630.975617-14-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_REENLIGHTENMENT_CONTROL/HV_X64_MSR_TSC_EMULATION_CONTROL/
HV_X64_MSR_TSC_EMULATION_STATUS are only available to guest when
HV_ACCESS_REENLIGHTENMENT bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e92a1109ad9b..259badd3a139 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1330,13 +1330,22 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		}
 		break;
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT)))
+			return 1;
+
 		hv->hv_reenlightenment_control = data;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT)))
+			return 1;
+
 		hv->hv_tsc_emulation_control = data;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
-		if (data && !host)
+		if (unlikely(!host && (!(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT) || data)))
 			return 1;
 
 		hv->hv_tsc_emulation_status = data;
@@ -1545,12 +1554,24 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = 0;
 		break;
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT)))
+			return 1;
+
 		data = hv->hv_reenlightenment_control;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT)))
+			return 1;
+
 		data = hv->hv_tsc_emulation_control;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_ACCESS_REENLIGHTENMENT)))
+			return 1;
+
 		data = hv->hv_tsc_emulation_status;
 		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
-- 
2.30.2


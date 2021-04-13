Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF335DEC4
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbhDMM1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345597AbhDMM1Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58yQdjmzuuFTBFxu8NFpHua93UCwx434i+t9ebr6W8o=;
        b=aMWS06G7JrKiRV2g9wI/TaX6F8iTwsB/KYrYmt1IytykeI9tOje205UB//GtOYjyDDnft0
        rQ+oJP7tebcdXIUhSDsWUiaEYFQlL7hpf7ewSOvxWQ0y4e4yMxHYZahWgzjA5detiuY9XN
        b5unL2CGYubOuth6NugqvCj17/tojVc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-o7xUXSozOayhW2Iw_JGcdA-1; Tue, 13 Apr 2021 08:27:02 -0400
X-MC-Unique: o7xUXSozOayhW2Iw_JGcdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4C06A40C1;
        Tue, 13 Apr 2021 12:27:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDAE460C04;
        Tue, 13 Apr 2021 12:26:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 08/22] KVM: x86: hyper-v: Honor HV_MSR_REFERENCE_TSC_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:16 +0200
Message-Id: <20210413122630.975617-9-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_REFERENCE_TSC is only available to guest when
HV_MSR_REFERENCE_TSC_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 15d557ce32b5..48215ad72b6c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1257,6 +1257,10 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		break;
 	}
 	case HV_X64_MSR_REFERENCE_TSC:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_REFERENCE_TSC_AVAILABLE)))
+			return 1;
+
 		hv->hv_tsc_page = data;
 		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
 			if (!host)
@@ -1478,6 +1482,10 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = get_time_ref_counter(kvm);
 		break;
 	case HV_X64_MSR_REFERENCE_TSC:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_REFERENCE_TSC_AVAILABLE)))
+			return 1;
+
 		data = hv->hv_tsc_page;
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
-- 
2.30.2


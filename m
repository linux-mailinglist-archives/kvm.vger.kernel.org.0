Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4885735DECE
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345733AbhDMM2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345635AbhDMM1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nN+KjQNXh47kMIiCTZej4CSQDx8Hemm8xXr2LbcGx30=;
        b=VeOGBuUVsFbNMO/ft/n/6n3ffcgwjSzJSGCt3Cxpoh/6yCg76YNJ3sqoKIY7AcMMFZwsY8
        fW+WF8bwlF1/lRraBlqhJ6eEO18nImIhI76FOsgSJHBpk3v9Yi0YtsJTuwLyObT04ka1hq
        4GTR/2x4DuQWXwJvcMHDRTzmyRjalsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-V2wxoPDpOlGZZoYvLeUrYQ-1; Tue, 13 Apr 2021 08:27:12 -0400
X-MC-Unique: V2wxoPDpOlGZZoYvLeUrYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 240C719611A0;
        Tue, 13 Apr 2021 12:27:11 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B61E60C04;
        Tue, 13 Apr 2021 12:27:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 11/22] KVM: x86: hyper-v: Honor HV_MSR_APIC_ACCESS_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:19 +0200
Message-Id: <20210413122630.975617-12-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_EOI, HV_X64_MSR_ICR, HV_X64_MSR_TPR, and
HV_X64_MSR_VP_ASSIST_PAGE  are only available to guest when
HV_MSR_APIC_ACCESS_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 032305ad5615..9c4454873e00 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1401,6 +1401,10 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		u64 gfn;
 		unsigned long addr;
 
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
 			if (kvm_lapic_enable_pv_eoi(vcpu, 0, 0))
@@ -1428,10 +1432,22 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		break;
 	}
 	case HV_X64_MSR_EOI:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_write(vcpu, APIC_EOI, data);
 	case HV_X64_MSR_ICR:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_write(vcpu, APIC_ICR, data);
 	case HV_X64_MSR_TPR:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_write(vcpu, APIC_TASKPRI, data);
 	case HV_X64_MSR_VP_RUNTIME:
 		if (!host)
@@ -1564,12 +1580,28 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = hv_vcpu->vp_index;
 		break;
 	case HV_X64_MSR_EOI:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_read(vcpu, APIC_EOI, pdata);
 	case HV_X64_MSR_ICR:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_read(vcpu, APIC_ICR, pdata);
 	case HV_X64_MSR_TPR:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_vapic_msr_read(vcpu, APIC_TASKPRI, pdata);
 	case HV_X64_MSR_VP_ASSIST_PAGE:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_APIC_ACCESS_AVAILABLE)))
+			return 1;
+
 		data = hv_vcpu->hv_vapic;
 		break;
 	case HV_X64_MSR_VP_RUNTIME:
-- 
2.30.2


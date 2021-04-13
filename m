Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9837435DEB1
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbhDMM1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345525AbhDMM1M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQsi6oAbmmsLMWW2Im9sfgWFXjkeVw9JOu392FQJjvU=;
        b=PXiqNnL2EbfHmXMOnDAuDVL+PGNBQX3Blq1zNfIeyqqPo5qkd8laUYvK/KU7x7Og9XRzwO
        Cpu6c+cZLUvHLpHE+afy+5nEfFVmFhWhqndanR8+klUq7vCD8SCcQgs37onM/FAsfJRPF3
        7SERIubYHgCNCrBZGtLKE411XQjyp4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-kqhxorceOc6-2H2AFxBhKg-1; Tue, 13 Apr 2021 08:26:48 -0400
X-MC-Unique: kqhxorceOc6-2H2AFxBhKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C067A40C1;
        Tue, 13 Apr 2021 12:26:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B69D60C04;
        Tue, 13 Apr 2021 12:26:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 04/22] KVM: x86: hyper-v: Honor HV_MSR_TIME_REF_COUNT_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:12 +0200
Message-Id: <20210413122630.975617-5-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_TIME_REF_COUNT is only available to guest when
HV_MSR_TIME_REF_COUNT_AVAILABLE bit is exposed.

Note, writing to HV_X64_MSR_TIME_REF_COUNT is unsupported so
kvm_hv_set_msr_pw() doesn't need an additional check.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b39445aabbc2..efb3d69c98fd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1440,6 +1440,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	u64 data = 0;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_hv *hv = to_kvm_hv(kvm);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
@@ -1449,6 +1450,10 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = hv->hv_hypercall;
 		break;
 	case HV_X64_MSR_TIME_REF_COUNT:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_TIME_REF_COUNT_AVAILABLE)))
+			return 1;
+
 		data = get_time_ref_counter(kvm);
 		break;
 	case HV_X64_MSR_REFERENCE_TSC:
-- 
2.30.2


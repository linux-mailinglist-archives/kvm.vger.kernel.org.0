Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B1235DEC2
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345583AbhDMM1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345580AbhDMM1V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xaMlQr4MKoqstu2cBg+edI2HAsA2QPhMayZlMyzIYx4=;
        b=cruFLB+pO40GcqkaqgJWD1HmfKyqqWV5B+OsZb2WX+UYawlArsIwE6du0EVFni2DivHbNx
        ZOO5yS/XWVegATXAGI2nfv5WznOmxk5adTdkesZ4RARecw/gVLrPJz2ibNzY340OE/5Pmj
        02WgBqxvIY0P0U+7VfKBhgZvPv7RAHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-rwBtXm4cMlOAQjmjokN4hw-1; Tue, 13 Apr 2021 08:27:00 -0400
X-MC-Unique: rwBtXm4cMlOAQjmjokN4hw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E74783DD20;
        Tue, 13 Apr 2021 12:26:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48C9B60C04;
        Tue, 13 Apr 2021 12:26:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 07/22] KVM: x86: hyper-v: Honor HV_MSR_RESET_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:15 +0200
Message-Id: <20210413122630.975617-8-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_RESET is only available to guest when HV_MSR_RESET_AVAILABLE bit
is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 07f1fc8575e5..15d557ce32b5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1289,6 +1289,10 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		}
 		break;
 	case HV_X64_MSR_RESET:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_RESET_AVAILABLE)))
+			return 1;
+
 		if (data == 1) {
 			vcpu_debug(vcpu, "hyper-v reset requested\n");
 			kvm_make_request(KVM_REQ_HV_RESET, vcpu);
@@ -1483,6 +1487,10 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_CRASH_CTL:
 		return kvm_hv_msr_get_crash_ctl(kvm, pdata);
 	case HV_X64_MSR_RESET:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_RESET_AVAILABLE)))
+			return 1;
+
 		data = 0;
 		break;
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
-- 
2.30.2


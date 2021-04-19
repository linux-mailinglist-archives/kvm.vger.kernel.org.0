Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C313647BA
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242409AbhDSQDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:03:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242152AbhDSQCd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RPQnpulbnDBtruNQvpj4Fu5bHC2VqRSK2Th5hPcNLA=;
        b=X7o+Ke2wg1d6iSVb/5F6YrMUN/YUwx+qU0FLzsjRexj6BebmItopHrBa160NL5t12ZQiho
        FmkFjUgRqUOikK/q77460Obx+dO/tgB6Epy5zgq39LrKCkeLWmKbsqvKbTee+6nxjgvi+Q
        /gXi12Pz1qzCydnLTTroY5aqkNoP5cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-xmvgH5x2Pzer4d2eooObgQ-1; Mon, 19 Apr 2021 12:01:59 -0400
X-MC-Unique: xmvgH5x2Pzer4d2eooObgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5000A801814;
        Mon, 19 Apr 2021 16:01:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A28460636;
        Mon, 19 Apr 2021 16:01:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/30] KVM: x86: hyper-v: Honor HV_MSR_SYNIC_AVAILABLE privilege bit
Date:   Mon, 19 Apr 2021 18:01:08 +0200
Message-Id: <20210419160127.192712-12-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SynIC MSRs (HV_X64_MSR_SCONTROL, HV_X64_MSR_SVERSION, HV_X64_MSR_SIEFP,
HV_X64_MSR_SIMP, HV_X64_MSR_EOM, HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15)
are only available to guest when HV_MSR_SYNIC_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index be6156a27bd7..17bdf8e8196e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1219,6 +1219,14 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_REFERENCE_TSC:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_REFERENCE_TSC_AVAILABLE;
+	case HV_X64_MSR_SCONTROL:
+	case HV_X64_MSR_SVERSION:
+	case HV_X64_MSR_SIEFP:
+	case HV_X64_MSR_SIMP:
+	case HV_X64_MSR_EOM:
+	case HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_SYNIC_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.30.2


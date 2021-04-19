Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0813647C8
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbhDSQDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:03:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242292AbhDSQCs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6P3+cKPYdDKDmenZuGlj9cVt3ST/qjoajUXYcQIiasA=;
        b=HGawlsUaqxKE502wBB6nK8MWS6bCk12Ak3CUwHGHZxWQ+JdK0EqkJqJ5s7LDAj3bIDMQf/
        OC//4sLb4spU4OrSlqotWlocbg6ZDwVRyk7/OwNRAQhuDP6CnsElLgyS7jbIY9Is70+nZd
        qaxoSRHe7MrZ/Yrlyo0Bv6mRYvQK1mg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-H4GGb8ebP_-M7ImHdvZVmA-1; Mon, 19 Apr 2021 12:02:14 -0400
X-MC-Unique: H4GGb8ebP_-M7ImHdvZVmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B6B587A83A;
        Mon, 19 Apr 2021 16:02:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 425AB9CA0;
        Mon, 19 Apr 2021 16:02:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/30] KVM: x86: hyper-v: Honor HV_FEATURE_DEBUG_MSRS_AVAILABLE privilege bit
Date:   Mon, 19 Apr 2021 18:01:14 +0200
Message-Id: <20210419160127.192712-18-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic debugging MSRs (HV_X64_MSR_SYNDBG_CONTROL,
HV_X64_MSR_SYNDBG_STATUS, HV_X64_MSR_SYNDBG_SEND_BUFFER,
HV_X64_MSR_SYNDBG_RECV_BUFFER, HV_X64_MSR_SYNDBG_PENDING_BUFFER,
HV_X64_MSR_SYNDBG_OPTIONS) are only available to guest when
HV_FEATURE_DEBUG_MSRS_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 43ebb53b6b38..f54385ffcdc0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1257,6 +1257,10 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_CRASH_CTL:
 		return hv_vcpu->cpuid_cache.features_edx &
 			HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return hv_vcpu->cpuid_cache.features_edx &
+			HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.30.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50E938C3FB
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbhEUJzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236951AbhEUJy0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XIn2j7sxxkG8SPFOeEYP4aMyRw9QUBTSknuiH9fSXhM=;
        b=ccut6924tBD5gtm7o+QQ8LRvw6GakJWZKKIT4ZiEfK0i2KdsB2AHTDVD8KqkGV8U4hgoQE
        XpbIrERGlAwZLqRADBW4tYK4GVFCZjcjRUDxb3GE8zoAsD/XVdfZBOcRZp71PWnBLG5J6f
        sNzAWfP3+JxlwSRmSr47NwlTrDMyHYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-Av1X73MFPSiaVcqrK6hBOg-1; Fri, 21 May 2021 05:53:00 -0400
X-MC-Unique: Av1X73MFPSiaVcqrK6hBOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6C1E107ACCD;
        Fri, 21 May 2021 09:52:57 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6D6E687F7;
        Fri, 21 May 2021 09:52:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/30] KVM: x86: hyper-v: Honor HV_FEATURE_DEBUG_MSRS_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:51 +0200
Message-Id: <20210521095204.2161214-18-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
2.31.1


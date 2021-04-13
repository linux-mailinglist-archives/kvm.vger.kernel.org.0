Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D335DEAF
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbhDMM1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345520AbhDMM1H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9sP7+bqT1/7D4m+jHPuhuseMhiAgoZVCcAP69ZyNS4=;
        b=YjZsdaP5p9BMN0QRffkgaCFlD40wVbZcTxyIyNAuYfByy3jDM5T6uhrsrm2GaD0Xu2TZte
        3IRk9Sfwwm3vPbhtIz5qITz/5aaR6JF5jepPQ/VYZSX3hiTEBZYR3wXZNmYyEWZZhgZG35
        qJs+6TGN3tK6JHCAEirF3XslAaDA6n4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-8msTuak6NVuvH4CML75q3Q-1; Tue, 13 Apr 2021 08:26:46 -0400
X-MC-Unique: 8msTuak6NVuvH4CML75q3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3A5483DD20;
        Tue, 13 Apr 2021 12:26:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9972760C04;
        Tue, 13 Apr 2021 12:26:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 03/22] KVM: x86: hyper-v: Honor HV_MSR_VP_RUNTIME_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:11 +0200
Message-Id: <20210413122630.975617-4-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_VP_RUNTIME is only available to guest when
HV_MSR_VP_RUNTIME_AVAILABLE bit is exposed.

Note, writing to HV_X64_MSR_VP_RUNTIME is only available from the host so
kvm_hv_set_msr() doesn't need an additional check.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 781f9da9a418..b39445aabbc2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1504,6 +1504,10 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = hv_vcpu->hv_vapic;
 		break;
 	case HV_X64_MSR_VP_RUNTIME:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_VP_RUNTIME_AVAILABLE)))
+			return 1;
+
 		data = current_task_runtime_100ns() + hv_vcpu->runtime_offset;
 		break;
 	case HV_X64_MSR_SCONTROL:
-- 
2.30.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FEC38C3F4
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhEUJzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235971AbhEUJyP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grcdgJFQIl2/KKzWs4rre8Vq7Xi9iCDM/q/Zh6jC7Co=;
        b=SqVU5nPzjJ37oiBWW23Laxxzt641Urjh5SBmA3hJvh2ljDiKN7Mz5oO848ZvGrqjiTUpyb
        iDfvAYycO4DpEPVF74chGaf2ugjjtuC9ZwbZKH1N8Dd3rpmlY0YzwYjfE/wW3XYMPU+7d/
        LCQoQB+/Ds7inIb1NjxQwLpFjQXj64M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Aa6OepGyPqukzoMpmqfKFQ-1; Fri, 21 May 2021 05:52:49 -0400
X-MC-Unique: Aa6OepGyPqukzoMpmqfKFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B79791922963;
        Fri, 21 May 2021 09:52:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF644687F7;
        Fri, 21 May 2021 09:52:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/30] KVM: x86: hyper-v: Honor HV_MSR_APIC_ACCESS_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:47 +0200
Message-Id: <20210521095204.2161214-14-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_EOI, HV_X64_MSR_ICR, HV_X64_MSR_TPR, and
HV_X64_MSR_VP_ASSIST_PAGE  are only available to guest when
HV_MSR_APIC_ACCESS_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2582c23126fa..a41ad21768ed 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1237,6 +1237,13 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_STIMER3_COUNT:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_SYNTIMER_AVAILABLE;
+	case HV_X64_MSR_EOI:
+	case HV_X64_MSR_ICR:
+	case HV_X64_MSR_TPR:
+	case HV_X64_MSR_VP_ASSIST_PAGE:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_APIC_ACCESS_AVAILABLE;
+		break;
 	default:
 		break;
 	}
-- 
2.31.1


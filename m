Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256D135DED7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbhDMM2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345664AbhDMM1p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybYLyGLI8B1h8ZrI6LQaJZzD99e7NrMyNl/2PJiBtKY=;
        b=C2OX/lDwOojvl47nVc1UFrH11/hQuKLIcVw66wYDQbalRu+PvAIYuoHTTfEyYIsqClWJE0
        xtcLcvEj8g4Qap8Z7Sp4RQRJ2O3JkoBpMp6xZAQXjeKyJesdmWAwceaMsYZRLfcqI/5QUQ
        9PUSuAY1wpOXZSW1cJCh6bJQ4BnicbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-gy_L8MyiNFam_ObiDc3U6A-1; Tue, 13 Apr 2021 08:27:23 -0400
X-MC-Unique: gy_L8MyiNFam_ObiDc3U6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F11421008060;
        Tue, 13 Apr 2021 12:27:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBE4460C04;
        Tue, 13 Apr 2021 12:27:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 14/22] KVM: x86: hyper-v: Honor HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:22 +0200
Message-Id: <20210413122630.975617-15-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4, HV_X64_MSR_CRASH_CTL are only
available to guest when HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE bit is
exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 259badd3a139..0678f1012ed7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1300,10 +1300,18 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		}
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_edx &
+					HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_msr_set_crash_data(kvm,
 						 msr - HV_X64_MSR_CRASH_P0,
 						 data);
 	case HV_X64_MSR_CRASH_CTL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_edx &
+					HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE)))
+			return 1;
+
 		if (host)
 			return kvm_hv_msr_set_crash_ctl(kvm, data);
 
@@ -1541,10 +1549,18 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = hv->hv_tsc_page;
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_edx &
+					HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_msr_get_crash_data(kvm,
 						 msr - HV_X64_MSR_CRASH_P0,
 						 pdata);
 	case HV_X64_MSR_CRASH_CTL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_edx &
+					HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE)))
+			return 1;
+
 		return kvm_hv_msr_get_crash_ctl(kvm, pdata);
 	case HV_X64_MSR_RESET:
 		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
-- 
2.30.2


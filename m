Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F6E38C3ED
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhEUJzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235391AbhEUJx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h924Tt7vS/d/aBELkm3BfFNKgy4bBHAwsnO1aTJGpdQ=;
        b=GPXWkywBgNLdYcAnl7Vomi4/11k/2548IN/Q9ZBWdRJ2bsO7mVTdG8mLksl7Irn7BDLUUu
        N82IooGQdRNkrqk5Sx8jYSxe11tQKzdbNg1RHrovaRyGCgyy/+HJmLYbvoXG6845S9svXV
        P4ZZf4ppjN35eptyLgZ0huXewHKFxWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-cCdfyRG8PHeHpf9JENTcFQ-1; Fri, 21 May 2021 05:52:32 -0400
X-MC-Unique: cCdfyRG8PHeHpf9JENTcFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8124427C4;
        Fri, 21 May 2021 09:52:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7474687F7;
        Fri, 21 May 2021 09:52:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/30] KVM: x86: hyper-v: Honor HV_MSR_RESET_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:43 +0200
Message-Id: <20210521095204.2161214-10-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_RESET is only available to guest when HV_MSR_RESET_AVAILABLE bit
is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0f3f30f6ca69..affc6e0cda09 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1213,6 +1213,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_VP_INDEX:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_VP_INDEX_AVAILABLE;
+	case HV_X64_MSR_RESET:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_RESET_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.31.1


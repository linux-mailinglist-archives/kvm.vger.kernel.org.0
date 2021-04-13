Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EB35DEBA
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345640AbhDMM1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345566AbhDMM1S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1/+pxwOIYBMLawW9LxG6HUvWrXK++Jmrxahabnl8/8=;
        b=izF+69VSJuMxEiG47SwR99DgrR+rS6IBI5vL3WUC3laKpY01sBr0nBaEgGH8MxohswsaLK
        fp87xWgJRtVo5deGwDKRkjbc9MMRRxTkt7O8YOH14W56JrNrWGRY3roD96h0E8PTYmZb96
        arznNti7HoaXTQ9m2Uj7yJo39a9l7EU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-aoV2_RPoMy2DDbJIB71_pg-1; Tue, 13 Apr 2021 08:26:55 -0400
X-MC-Unique: aoV2_RPoMy2DDbJIB71_pg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5FFBA40CA;
        Tue, 13 Apr 2021 12:26:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EED7060C04;
        Tue, 13 Apr 2021 12:26:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 06/22] KVM: x86: hyper-v: Honor HV_MSR_VP_INDEX_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:14 +0200
Message-Id: <20210413122630.975617-7-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_VP_INDEX is only available to guest when
HV_MSR_VP_INDEX_AVAILABLE bit is exposed.

Note, writing to HV_X64_MSR_VP_INDEX is only available from the host so
kvm_hv_set_msr() doesn't need an additional check.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7fdd9b9c50d6..07f1fc8575e5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1514,6 +1514,10 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_VP_INDEX_AVAILABLE)))
+			return 1;
+
 		data = hv_vcpu->vp_index;
 		break;
 	case HV_X64_MSR_EOI:
-- 
2.30.2


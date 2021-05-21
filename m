Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFECE38C404
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhEUJ4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237248AbhEUJys (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kvI4aHrKBDx4iPPvJtxqjnBs76a0HVDHkAqFclxUy4w=;
        b=TTbbuVqkGu8aEi+hrHnPB+UFd8lNWa+wSNtV96uPDPg2FGvTgpocsCk3frvtBuVO1OpN43
        nvqtxX50Z/rxp68R4PZL90dbNPpdatbX8Vdx6SFdrPt2u2HaO2olvMKalwSSoYfZUkEuQ1
        0DSi/ojNxgmzdvXtMFB/krsZpSQ+uJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-ZvSgprDDPZCM6F3wfozC5A-1; Fri, 21 May 2021 05:53:21 -0400
X-MC-Unique: ZvSgprDDPZCM6F3wfozC5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BE281922964;
        Fri, 21 May 2021 09:53:20 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49E5A687F7;
        Fri, 21 May 2021 09:53:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 22/30] KVM: x86: hyper-v: Honor HV_POST_MESSAGES privilege bit
Date:   Fri, 21 May 2021 11:51:56 +0200
Message-Id: <20210521095204.2161214-23-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_POST_MESSAGES' privilege to issue
HVCALL_POST_MESSAGE hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bd424f2d4294..ff86c00d1396 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2031,6 +2031,8 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
 		return hv_vcpu->cpuid_cache.enlightenments_ebx &&
 			hv_vcpu->cpuid_cache.enlightenments_ebx != U32_MAX;
+	case HVCALL_POST_MESSAGE:
+		return hv_vcpu->cpuid_cache.features_ebx & HV_POST_MESSAGES;
 	default:
 		break;
 	}
-- 
2.31.1


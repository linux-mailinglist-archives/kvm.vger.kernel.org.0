Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9F3647D8
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhDSQEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242365AbhDSQDD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YxjJtwWBeF+z9dF/cyj+nCPje49Cec0gv/o6FFFLPWw=;
        b=URAUX9DGAb791j5iwiTixlNaBiWckueK0ka800qkViPfqU1M0aiZFzAZvjee3IyZWQiYiB
        YcIKlqg+FIaRncfOcQPO9GCVddW1ua2L8iymtylQkByWF+QBosr7w9mi4rVH9fL8JWA6NN
        U4LvGm8B3VnypWg/oWy/QTCh57E4h/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-luE5RFWKNCyIp3MKZxeYPg-1; Mon, 19 Apr 2021 12:02:31 -0400
X-MC-Unique: luE5RFWKNCyIp3MKZxeYPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7471E107ACF8;
        Mon, 19 Apr 2021 16:02:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74BE619172;
        Mon, 19 Apr 2021 16:02:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/30] KVM: x86: hyper-v: Honor HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED bit
Date:   Mon, 19 Apr 2021 18:01:22 +0200
Message-Id: <20210419160127.192712-26-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED'
privilege ('recommended' is rather a misnomer) to issue
HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST/SPACE hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 36ec688cda4e..f99072e092d0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2044,6 +2044,12 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 		 */
 		return !kvm_hv_is_syndbg_enabled(hv_vcpu->vcpu) ||
 			hv_vcpu->cpuid_cache.features_ebx & HV_DEBUGGING;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
+		return hv_vcpu->cpuid_cache.enlightenments_eax &
+			HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
 	default:
 		break;
 	}
-- 
2.30.2


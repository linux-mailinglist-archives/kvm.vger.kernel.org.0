Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082C43647AC
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbhDSQCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242006AbhDSQCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N65nLInY3iy8M06TTEb2HxtzF/bwajwxxiE5F9vYI6U=;
        b=RbMu/YJgWFhNcsMWDiKWwfmcf86Q+02G2tIdD0QlVqNFP2eFPad+N79vuK4Qz2PKtcs69I
        Esoyi1B9uUYsPpkz4n+WF+PjA6JumQotgHuIum1RVImmf9oS/ZlUOqfAa6EclQoR1g64gr
        P6AAu2qR4IJd5kT4quRjOPWM2AGyUfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-D2R_9jx4MHWv321pE5KqwQ-1; Mon, 19 Apr 2021 12:01:49 -0400
X-MC-Unique: D2R_9jx4MHWv321pE5KqwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23B2A6D4E0;
        Mon, 19 Apr 2021 16:01:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DBD75B4B0;
        Mon, 19 Apr 2021 16:01:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/30] KVM: x86: hyper-v: Honor HV_MSR_VP_RUNTIME_AVAILABLE privilege bit
Date:   Mon, 19 Apr 2021 18:01:03 +0200
Message-Id: <20210419160127.192712-7-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_VP_RUNTIME is only available to guest when
HV_MSR_VP_RUNTIME_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 13011803ebbd..152d991ed033 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1204,6 +1204,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_HYPERCALL:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_HYPERCALL_AVAILABLE;
+	case HV_X64_MSR_VP_RUNTIME:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_VP_RUNTIME_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.30.2


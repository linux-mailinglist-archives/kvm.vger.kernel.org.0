Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0E63647DC
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbhDSQEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:04:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242401AbhDSQDI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q1n4o18GGyFzjWpbowfP+dNqOUCHVUzvAS4FyOkvWS8=;
        b=ckxoGbh+yOREeADyM2VDea6rEjz//1vM53wxF8VjyarD0DYsYQ8Ji2uJsKOPaxForu9+xs
        9tJR3GK8CDAw+541np9ULXIDP9IRqEWbMYsY2RQsqz7K63ssN2WMcdqjsukE39peiNwRDF
        WSMHiE9RHGnoMOmamuGDNknavgFi6G0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-EylpUtc0NvqZsg-OBwyM1Q-1; Mon, 19 Apr 2021 12:02:36 -0400
X-MC-Unique: EylpUtc0NvqZsg-OBwyM1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA98E1020C26;
        Mon, 19 Apr 2021 16:02:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 015E860636;
        Mon, 19 Apr 2021 16:02:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/30] KVM: x86: hyper-v: Honor HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED bit
Date:   Mon, 19 Apr 2021 18:01:24 +0200
Message-Id: <20210419160127.192712-28-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hypercalls which use extended processor masks are only available when
HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED privilege bit is exposed (and
'RECOMMENDED' is rather a misnomer).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ba5af4d27ccf..4ad27e7cdb05 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2046,11 +2046,19 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 			hv_vcpu->cpuid_cache.features_ebx & HV_DEBUGGING;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+		if (!(hv_vcpu->cpuid_cache.enlightenments_eax &
+		      HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED))
+			return false;
+		fallthrough;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
 	case HVCALL_SEND_IPI_EX:
+		if (!(hv_vcpu->cpuid_cache.enlightenments_eax &
+		      HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED))
+			return false;
+		fallthrough;
 	case HVCALL_SEND_IPI:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_CLUSTER_IPI_RECOMMENDED;
-- 
2.30.2


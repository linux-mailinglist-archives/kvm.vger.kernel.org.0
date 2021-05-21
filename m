Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48138C40A
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237674AbhEUJ4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237282AbhEUJy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cfdDucaY3FT6ApPsOsDgWYLA/uHMxTRD4Ck5qNiJBno=;
        b=VlQYMOKCKR3zW484RujP1R9CISeYWYsTBAG3N7VftpgI4wFSc703OXYcR8qABpl39aYp0M
        fMkoGIT0MJChS7cJUGetxvO+jBCN0Z7yigPOyYkX9Ga1Sb7xHGhhiN68Y8Ml3PZLO/Z37N
        qfRGgScnvPY4c2/aMOlwqmEPqgxq6p8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-IaLMEsb0Oa-2rni_A0tsUw-1; Fri, 21 May 2021 05:53:31 -0400
X-MC-Unique: IaLMEsb0Oa-2rni_A0tsUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43E0E3464C;
        Fri, 21 May 2021 09:53:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C67A6A04D;
        Fri, 21 May 2021 09:53:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 26/30] KVM: x86: hyper-v: Honor HV_X64_CLUSTER_IPI_RECOMMENDED bit
Date:   Fri, 21 May 2021 11:52:00 +0200
Message-Id: <20210521095204.2161214-27-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_X64_CLUSTER_IPI_RECOMMENDED'
privilege ('recommended' is rather a misnomer) to issue
HVCALL_SEND_IPI hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f99072e092d0..ba5af4d27ccf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2050,6 +2050,10 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+	case HVCALL_SEND_IPI_EX:
+	case HVCALL_SEND_IPI:
+		return hv_vcpu->cpuid_cache.enlightenments_eax &
+			HV_X64_CLUSTER_IPI_RECOMMENDED;
 	default:
 		break;
 	}
-- 
2.31.1


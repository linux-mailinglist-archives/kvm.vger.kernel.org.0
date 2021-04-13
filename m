Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3E35DEE6
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbhDMM2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345719AbhDMM2G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTvzthIKNUC0rB2NTyk3OkjMbXSFp6Zmo0roi+yCo4M=;
        b=cu772m00BmV4A0kcc1c/bv3UEWjubLkJtVScit/TbB2Gt5fsMT5OWb8TCaaEjBFN+BwayS
        7MLEYeWOd5lSHz+klLE6wCChAexvHR6yb5URuM3bixcEuQG/OyamlETVGAkx0H8HK/RWmq
        a2g/3YXWKgIMZ9fVD29hxZn1DC3jYV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-nyfZX1gdPImRBMCnrGP9sQ-1; Tue, 13 Apr 2021 08:27:43 -0400
X-MC-Unique: nyfZX1gdPImRBMCnrGP9sQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9AEC814256;
        Tue, 13 Apr 2021 12:27:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC2CA60C04;
        Tue, 13 Apr 2021 12:27:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 19/22] KVM: x86: hyper-v: Honor HV_DEBUGGING privilege bit
Date:   Tue, 13 Apr 2021 14:26:27 +0200
Message-Id: <20210413122630.975617-20-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_DEBUGGING' privilege to issue
HVCALL_POST_DEBUG_DATA/HVCALL_RETRIEVE_DEBUG_DATA/
HVCALL_RESET_DEBUG_SESSION hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b661f92d90c8..7cb1dd1a9fc1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2211,6 +2211,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		if (unlikely(!(hv_vcpu->cpuid_cache.features_ebx &
+			       HV_DEBUGGING))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
 			ret = HV_STATUS_OPERATION_DENIED;
 			break;
-- 
2.30.2


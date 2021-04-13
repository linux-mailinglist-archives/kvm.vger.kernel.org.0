Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917D335DEE5
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345848AbhDMM2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345636AbhDMM2C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8Pc6sjKzyL/ywQSK9iQAj3O9qrUD0TkuhHTS3lVgIo=;
        b=XafcObQtlAN/13cyUsGtO+1cWs7WBeT+8qrJXVsMUSW6ZApTaMaigpZ/ly2S1P9SLujdcK
        rQsFY3kAfjX9H+u/zrrTmVFh7jc/5WpRlVrMnVuxaAWyyZuuqkQnSeOWcCExAP6+CtuuKr
        qaRwWnDAYiZuFQgWkhY8WkQ9BN76hbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-2GCwpfY2OMODe7607fW5RA-1; Tue, 13 Apr 2021 08:27:41 -0400
X-MC-Unique: 2GCwpfY2OMODe7607fW5RA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7903483DD21;
        Tue, 13 Apr 2021 12:27:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A75460C04;
        Tue, 13 Apr 2021 12:27:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 18/22] KVM: x86: hyper-v: Honor HV_SIGNAL_EVENTS privilege bit
Date:   Tue, 13 Apr 2021 14:26:26 +0200
Message-Id: <20210413122630.975617-19-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_SIGNAL_EVENTS' privilege to issue
HVCALL_SIGNAL_EVENT hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6e4bf1da9dcf..b661f92d90c8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2120,6 +2120,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		kvm_vcpu_on_spin(vcpu, true);
 		break;
 	case HVCALL_SIGNAL_EVENT:
+		if (unlikely(!(hv_vcpu->cpuid_cache.features_ebx &
+			       HV_SIGNAL_EVENTS))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
-- 
2.30.2


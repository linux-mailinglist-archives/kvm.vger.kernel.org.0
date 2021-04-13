Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0835DEE9
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345728AbhDMM2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345725AbhDMM2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PErpyPGhqGNtr7svl+Fwqu8iV8JH5DeJvIL2VScbpsI=;
        b=Opw3ZYjpNScoFyZVRKC+oWnEpeWzi0Kz29ca+1xz3nN4q2GgXdMMBTX+9mQt5Y06T1nSTJ
        jId3j+V2bj+IZ+PJxAYuOjvY13vps8zZy018v6tHXYYNRjhRWFne6c6yDik/bLh3iEOmr2
        0PkW7hY3oNdRfQCK6Pz5dcr17vVlR6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-RJtQxeNDMRK-dga8x9sHHQ-1; Tue, 13 Apr 2021 08:27:45 -0400
X-MC-Unique: RJtQxeNDMRK-dga8x9sHHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DCD984E20A;
        Tue, 13 Apr 2021 12:27:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34AC060C04;
        Tue, 13 Apr 2021 12:27:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 20/22] KVM: x86: hyper-v: Honor HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED bit
Date:   Tue, 13 Apr 2021 14:26:28 +0200
Message-Id: <20210413122630.975617-21-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED'
privilege ('recommended' is rather a misnomer) to issue
HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST/SPACE hypercalls. '_EX' versions of these
hypercalls also require HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7cb1dd1a9fc1..3e8a34c08aef 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2155,6 +2155,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(fast || !rep_cnt || rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -2162,6 +2168,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(fast || rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -2169,6 +2181,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED) ||
+			     !(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(fast || !rep_cnt || rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -2176,6 +2196,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED) ||
+			     !(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(fast || rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
-- 
2.30.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4D735DEEC
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345731AbhDMM24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345735AbhDMM2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8a+p1xND4+9nssX9gPA93ZAB8L5Zabb5xlKU9ufvRsk=;
        b=NXNiXF0RMgmS0JEVhi88WponDZv36WflwwuCgezj0h5YBXVYmrGzpwpIRVIfY1QD9xlqNN
        TDEQfGLbGpUp9CAkbVYsBrNQzBT54UkRumo+LlahOZCo9Y6ScdIWhJP81xGeB0lsuMhMhH
        cH2xd0X0N8n0BcGMUwe3BO6A4oN0Z+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-qw6YnGXWOMSyYfDJje5iAw-1; Tue, 13 Apr 2021 08:27:48 -0400
X-MC-Unique: qw6YnGXWOMSyYfDJje5iAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 946B01008064;
        Tue, 13 Apr 2021 12:27:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C65960C04;
        Tue, 13 Apr 2021 12:27:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 21/22] KVM: x86: hyper-v: Honor HV_X64_CLUSTER_IPI_RECOMMENDED bit
Date:   Tue, 13 Apr 2021 14:26:29 +0200
Message-Id: <20210413122630.975617-22-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_X64_CLUSTER_IPI_RECOMMENDED'
privilege ('recommended' is rather a misnomer) to issue
HVCALL_SEND_IPI hypercalls. 'HVCALL_SEND_IPI_EX' version of the
hypercall also requires HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3e8a34c08aef..37b8ff30fc1d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2211,6 +2211,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
 		break;
 	case HVCALL_SEND_IPI:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_CLUSTER_IPI_RECOMMENDED))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -2218,6 +2224,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
 		break;
 	case HVCALL_SEND_IPI_EX:
+		if (unlikely(!(hv_vcpu->cpuid_cache.enlightenments_eax &
+			       HV_X64_CLUSTER_IPI_RECOMMENDED) ||
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


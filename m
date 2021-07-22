Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8413D2357
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 14:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhGVLtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:49:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231772AbhGVLtu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 07:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626957025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WSL7ZJVKiQveNIWfD94p7ezZFAiUNBxVvFp4267kOUk=;
        b=Ej5sJqC5YV2WBYZJKU9H9IsOaRXkiSrkiZCN/2LY9yLf+3jVLU4aRH5r45vuBs/PmanMFf
        jLReZJ8qHudpM/HKP1pYv8MeDgT1Tq8Rv3RpzRFJ3IQAJOR8DEXhzXQUqMaSGMAOJXkDQb
        r78t5K6zdX/v+zzwguXosrlXwJvoCh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-D2Z8quUJPO-raM6b1OQUyQ-1; Thu, 22 Jul 2021 08:30:23 -0400
X-MC-Unique: D2Z8quUJPO-raM6b1OQUyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67CA98B0604;
        Thu, 22 Jul 2021 12:30:22 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C391D10016F2;
        Thu, 22 Jul 2021 12:30:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access
Date:   Thu, 22 Jul 2021 14:30:18 +0200
Message-Id: <20210722123018.260035-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
stated in Documentation/virt/kvm/msr.rst.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d715ae9f9108..88ff7a1af198 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3406,7 +3406,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
-		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
 			return 1;
 		if (data & 0x1) {
 			vcpu->arch.apf.pageready_pending = false;
@@ -3745,7 +3745,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
-		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
 			return 1;
 
 		msr_info->data = 0;
-- 
2.31.1


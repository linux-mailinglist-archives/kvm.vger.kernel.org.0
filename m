Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EB135DEB6
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345610AbhDMM10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345549AbhDMM1Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vCx4IZ39Nb4y8oc16CqkD3jG4/D7DhB39RA7N814hEs=;
        b=PLhX9E7rwkZ3xbkLVaQrIUhJUOUEuXf/+xb/ZklGw2++wjtvdjNLP3TufHO8CiiJVySeS3
        nFwl548xgsj0DoSWMpUci4XXVOLdGsgHc8ffZVeRruhUk+bGeuROujNX6c6SlL/erzwuNs
        lFnU7fxKoO8OF1GWD/bDysiT0HAH29w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-V7tOLyuvMlGP-uwmeJ0ExA-1; Tue, 13 Apr 2021 08:26:52 -0400
X-MC-Unique: V7tOLyuvMlGP-uwmeJ0ExA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 954FE19611A1;
        Tue, 13 Apr 2021 12:26:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AA4260C04;
        Tue, 13 Apr 2021 12:26:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 05/22] KVM: x86: hyper-v: Honor HV_MSR_HYPERCALL_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:13 +0200
Message-Id: <20210413122630.975617-6-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_GUEST_OS_ID/HV_X64_MSR_HYPERCALL are only available to guest
when HV_MSR_HYPERCALL_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index efb3d69c98fd..7fdd9b9c50d6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1198,9 +1198,14 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_hv *hv = to_kvm_hv(kvm);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_HYPERCALL_AVAILABLE)))
+			return 1;
+
 		hv->hv_guest_os_id = data;
 		/* setting guest os id to zero disables hypercall page */
 		if (!hv->hv_guest_os_id)
@@ -1211,6 +1216,10 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		int i = 0;
 		u64 addr;
 
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_HYPERCALL_AVAILABLE)))
+			return 1;
+
 		/* if guest os id is not set hypercall should remain disabled */
 		if (!hv->hv_guest_os_id)
 			break;
@@ -1444,9 +1453,17 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_HYPERCALL_AVAILABLE)))
+			return 1;
+
 		data = hv->hv_guest_os_id;
 		break;
 	case HV_X64_MSR_HYPERCALL:
+		if (unlikely(!host && !(hv_vcpu->cpuid_cache.features_eax &
+					HV_MSR_HYPERCALL_AVAILABLE)))
+			return 1;
+
 		data = hv->hv_hypercall;
 		break;
 	case HV_X64_MSR_TIME_REF_COUNT:
-- 
2.30.2


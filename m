Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950E35DED9
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbhDMM2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345672AbhDMM1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xtkR+la884G0GZlwBjdyXQVnue3TEt0UwAvDqmJdh4=;
        b=Ntk1xPDVNzVBKUfA7VyiIfxB3RXgEWj6ROD3b/BKFNOiELrTdmgm0XZ1KmPP7BSxZznXKp
        cOBL3avUIcdv9uACjc24TWdMwKGS1Fhig6ztChoZRwmFJyo6Wr57XX/D7fA3GUKwvgK655
        /2b0qlfWv8HvOWnZP4G6GQ+c9ePVf7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-wr1BQZ7aNIGpA_Ns600GXg-1; Tue, 13 Apr 2021 08:27:26 -0400
X-MC-Unique: wr1BQZ7aNIGpA_Ns600GXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E2A5107ACCA;
        Tue, 13 Apr 2021 12:27:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A25E60C04;
        Tue, 13 Apr 2021 12:27:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 15/22] KVM: x86: hyper-v: Honor HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:23 +0200
Message-Id: <20210413122630.975617-16-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic debugging MSRs (HV_X64_MSR_SYNDBG_CONTROL,
HV_X64_MSR_SYNDBG_STATUS, HV_X64_MSR_SYNDBG_SEND_BUFFER,
HV_X64_MSR_SYNDBG_RECV_BUFFER, HV_X64_MSR_SYNDBG_PENDING_BUFFER,
HV_X64_MSR_SYNDBG_OPTIONS) are only available to guest when
HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0678f1012ed7..1299847c89ba 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -312,7 +312,9 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
 	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
-	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
+	if (unlikely(!host && (!kvm_hv_is_syndbg_enabled(vcpu) ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_edx &
+				 HV_FEATURE_DEBUG_MSRS_AVAILABLE))))
 		return 1;
 
 	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
@@ -351,7 +353,9 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
 	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
-	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
+	if (unlikely(!host && (!kvm_hv_is_syndbg_enabled(vcpu) ||
+			       !(to_hv_vcpu(vcpu)->cpuid_cache.features_edx &
+				 HV_FEATURE_DEBUG_MSRS_AVAILABLE))))
 		return 1;
 
 	switch (msr) {
-- 
2.30.2


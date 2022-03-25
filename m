Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FB34E7418
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354331AbiCYNXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354619AbiCYNX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAD98D112B
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648214513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGcphh+FSCJkCtquixHZ+Ppqf8dAW6dwu2JqKDu/J40=;
        b=br5825ogys9PD0azP6ODqKDLeZtYCsvtMk59OTMEH0dL23quhz3d9OB51i8NLxxMQvLJBm
        K850yKW3l/8SRp9i+XBjhViIJLxX5LBP40aZ2Kn5CRoLyUu0kGH1hMn1aeVW1a6xhGVXjV
        L7gKzENrmuZ0Li39tkJUberfI1atXyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-AWhCHrn_OLuKCMj93ui8aw-1; Fri, 25 Mar 2022 09:21:50 -0400
X-MC-Unique: AWhCHrn_OLuKCMj93ui8aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E40802A59540;
        Fri, 25 Mar 2022 13:21:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BED52166B16;
        Fri, 25 Mar 2022 13:21:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated
Date:   Fri, 25 Mar 2022 14:21:40 +0100
Message-Id: <20220325132140.25650-4-vkuznets@redhat.com>
In-Reply-To: <20220325132140.25650-1-vkuznets@redhat.com>
References: <20220325132140.25650-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting non-zero values to SYNIC/STIMER MSRs activates certain features,
this should not happen when KVM_CAP_HYPERV_SYNIC{,2} was not activated.

Note, it would've been better to forbid writing anything to SYNIC/STIMER
MSRs, including zeroes, however, at least QEMU tries clearing
HV_X64_MSR_STIMER0_CONFIG without SynIC. HV_X64_MSR_EOM MSR is somewhat
'special' as writing zero there triggers an action, this also should not
happen when SynIC wasn't activated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a79a094c1266..123b677111c5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -243,7 +243,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || data))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -289,6 +289,9 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -668,7 +671,7 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || config))
 		return 1;
 
 	if (unlikely(!host && hv_vcpu->enforce_cpuid && new_config.direct_mode &&
@@ -697,7 +700,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || count))
 		return 1;
 
 	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,
-- 
2.35.1


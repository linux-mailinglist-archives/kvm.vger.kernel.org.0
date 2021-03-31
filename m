Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9768334D056
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhC2MsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 08:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231249AbhC2MsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 08:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617022096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=StRb7UVN5Yp/VEOKdrPoTELQdTs1f4wblUD2484mrPw=;
        b=UQJoXHai4wj6yoX5tj4sjSFmdrezsvYdwgFpr9lGqtdOWAwKNhXaecwjLIPvz2r2pwQ6JL
        S8wAOxqTsm/v7NfeysbtgBIxmblcvv+wTc8jiL7Sh8yeLZ6pbU84DMtueBnxc4FFJnsZhZ
        5m9lPQdLPJQZtHwAmJ6iSKNk3A04MY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-1cfcLZwAN1m63PTtdQ7PHQ-1; Mon, 29 Mar 2021 08:48:12 -0400
X-MC-Unique: 1cfcLZwAN1m63PTtdQ7PHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6593A1018F74;
        Mon, 29 Mar 2021 12:48:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D58719C45;
        Mon, 29 Mar 2021 12:48:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/vPMU: Forbid reading from MSR_F15H_PERF MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE
Date:   Mon, 29 Mar 2021 14:48:04 +0200
Message-Id: <20210329124804.170173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs have a CPUID bit assigned
to them (X86_FEATURE_PERFCTR_CORE) and when it wasn't exposed to the guest
the correct behavior is to inject #GP an not just return zero.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe806e894212..125453155ede 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3381,6 +3381,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+			return kvm_pmu_get_msr(vcpu, msr_info);
+		if (!msr_info->host_initiated)
+			return 1;
+		msr_info->data = 0;
+		break;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-- 
2.30.2


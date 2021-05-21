Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230CE38C3EA
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhEUJzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhEUJxt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxtSzgjXlBsgmNJ5qGmP06v2CRY7gLTjTG+qTZc4mRY=;
        b=ZGhsJNMvShLxQbvdxMUNTovXByK6BeWu+Us5H/SjQ/nPQxYssP3KaqKzMSCVlKquP7dw32
        8eZXGw2Es5uPmvVBEybDXknmegiXvM2Ww0rsLAz3PEvWGbd/bs2Zg6pIxA5uK6S1u77WNY
        ylTbGJAGEMp72e8SYhFMM6MOaQnp+u0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-M7KoTwd3P1arpcMsi_WtFg-1; Fri, 21 May 2021 05:52:22 -0400
X-MC-Unique: M7KoTwd3P1arpcMsi_WtFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26A74800C60;
        Fri, 21 May 2021 09:52:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFF52687F7;
        Fri, 21 May 2021 09:52:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/30] KVM: x86: hyper-v: Honor HV_MSR_HYPERCALL_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:39 +0200
Message-Id: <20210521095204.2161214-6-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_GUEST_OS_ID/HV_X64_MSR_HYPERCALL are only available to guest
when HV_MSR_HYPERCALL_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b5bc16ea2595..13011803ebbd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1196,6 +1196,18 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 
 static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 {
+	if (!hv_vcpu->enforce_cpuid)
+		return true;
+
+	switch (msr) {
+	case HV_X64_MSR_GUEST_OS_ID:
+	case HV_X64_MSR_HYPERCALL:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_MSR_HYPERCALL_AVAILABLE;
+	default:
+		break;
+	}
+
 	return true;
 }
 
-- 
2.31.1


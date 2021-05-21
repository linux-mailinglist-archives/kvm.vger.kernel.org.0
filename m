Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC7B38C402
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhEUJ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237210AbhEUJyn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWp1e00uQPkiuNFm0DDmpoydb43OrymiF5jKfalTPPI=;
        b=D9Gs7sttOLgR1hUQy90bBiW4snqFCzhYL/NHq5we6Tb1pCagxFOGdI/ZFZlxzvUHSP1Dg2
        wv0OvYDsSyI0eL7hzjIWE3yYcarJRgVL51Ak4hQ6mWHHgD8YH8koR9Y2b30ENPqJ2J8auB
        dZElpbWAnRMUrQLNVc4O932ejVbEMyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-QL5mNBSmPHiePZfrrMGQQw-1; Fri, 21 May 2021 05:53:19 -0400
X-MC-Unique: QL5mNBSmPHiePZfrrMGQQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD9CD107ACC7;
        Fri, 21 May 2021 09:53:17 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C82F3687F7;
        Fri, 21 May 2021 09:53:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/30] KVM: x86: hyper-v: Check access to HVCALL_NOTIFY_LONG_SPIN_WAIT hypercall
Date:   Fri, 21 May 2021 11:51:55 +0200
Message-Id: <20210521095204.2161214-22-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLFS6.0b states that partition issuing HVCALL_NOTIFY_LONG_SPIN_WAIT must
posess 'UseHypercallForLongSpinWait' privilege but there's no
corresponding feature bit. Instead, we have "Recommended number of attempts
to retry a spinlock failure before notifying the hypervisor about the
failures. 0xFFFFFFFF indicates never notify." Use this to check access to
the hypercall. Also, check against zero as the corresponding CPUID must
be set (and '0' attempts before re-try is weird anyway).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f0ab0c50c44..bd424f2d4294 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2024,6 +2024,17 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 
 static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 {
+	if (!hv_vcpu->enforce_cpuid)
+		return true;
+
+	switch (code) {
+	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
+		return hv_vcpu->cpuid_cache.enlightenments_ebx &&
+			hv_vcpu->cpuid_cache.enlightenments_ebx != U32_MAX;
+	default:
+		break;
+	}
+
 	return true;
 }
 
-- 
2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BFF34AC14
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCZP40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhCZP4S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 11:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616774177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uRFDlwL1+lzKzSu8HKEgD5Pq5CxP3Jk8mXy5xseyFU=;
        b=YJfCBuFwWbR9R9svCLSAZAjYy9fkim+UdJ9mTSlYCbfzYihVWL37+iLGeGcATiuuhH0oUy
        Z9cfmoOTc9q5CBKGhTv5yG3tl4oMJd2iJQeIARHC7+YpHViDcQqplWlsA5Kt5a/EISlR4y
        NH+AF8ckoMC/sW5zzsiPStP+IuR01i4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-IIHrNclkM1WDku7XUy1nPQ-1; Fri, 26 Mar 2021 11:56:15 -0400
X-MC-Unique: IIHrNclkM1WDku7XUy1nPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D744C8008C;
        Fri, 26 Mar 2021 15:56:03 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 003FC12C82;
        Fri, 26 Mar 2021 15:56:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/2] KVM: x86: hyper-v: Forbid unsigned hv_clock->system_time to go negative after KVM_REQ_CLOCK_UPDATE
Date:   Fri, 26 Mar 2021 16:55:50 +0100
Message-Id: <20210326155551.17446-2-vkuznets@redhat.com>
In-Reply-To: <20210326155551.17446-1-vkuznets@redhat.com>
References: <20210326155551.17446-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest time is reset with KVM_SET_CLOCK(0), it is possible for
hv_clock->system_time to become a small negative number. This happens
because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
kvm_guest_time_update() does

hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;

And 'master_kernel_ns' represents the last time when masterclock
got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
problem, the difference is very small, e.g. I'm observing
hv_clock.system_time = -70 ns. The issue comes from the fact that
'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
compute_tsc_page_parameters() becomes a very big number.

Forbid 'hv_clock.system_time' to go negative in kvm_guest_time_update().
A similar computation in get_kvmclock_ns() seems fine and doesn't require
the quirk.

Alternatively, we could've used 'master_kernel_ns' when computing
'arch.kvmclock_offset' but that would reduce the precision for normal
cases a bit. Another solution is to cast 'hv_clock.system_time' to
's64' in compute_tsc_page_parameters() but it seems we also use
'hv_clock.system_time' in trace_kvm_pvclock_update() as unsigned.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe806e894212..320da7912375 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2742,7 +2742,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	}
 
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
-	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
+
+	/*
+	 * 'kvmclock_offset' can be negative and its absolute value can be
+	 * slightly greater than 'kernel_ns' because when KVM_SET_CLOCK is
+	 * handled, we use more precise get_kvmclock_ns() there. Make sure
+	 * unsigned 'system_time' doesn't go negative.
+	 */
+	vcpu->hv_clock.system_time = max(kernel_ns + v->kvm->arch.kvmclock_offset,
+					 (s64)0);
 	vcpu->last_guest_tsc = tsc_timestamp;
 
 	/* If the host uses TSC clocksource, then it is stable */
-- 
2.30.2


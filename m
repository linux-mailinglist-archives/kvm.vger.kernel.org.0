Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CD34CF53
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhC2Lsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:48:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbhC2LsM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617018492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJNvcB1fUL2ck9v3qFq4z8Aij/Mol/eyuXm3sbGS/ac=;
        b=RTq/k/kau5uD0SvIzj64u/f/HrY0jmwQrdvlehKnRIVSOPV1VJ7EfFbO+/LxR9ernbc/fA
        QCPbROd3zIOs5W/QG6m2Hy64sk8UB74T19BASDOmyMb8RFTjJZAu2wVAgOfR6DjunhDplC
        +3C7faFSqK4Oq7McHNLdPafumhzMVQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-UasKfQbnOzaFv-fDGxFphg-1; Mon, 29 Mar 2021 07:48:10 -0400
X-MC-Unique: UasKfQbnOzaFv-fDGxFphg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1512E180FCA1;
        Mon, 29 Mar 2021 11:48:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F7A0100239A;
        Mon, 29 Mar 2021 11:48:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative 'hv_clock->system_time' in compute_tsc_page_parameters()
Date:   Mon, 29 Mar 2021 13:47:59 +0200
Message-Id: <20210329114800.164066-2-vkuznets@redhat.com>
In-Reply-To: <20210329114800.164066-1-vkuznets@redhat.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Use div_s64() to get the proper result when dividing maybe-negative
'hv_clock.system_time' by 100.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..0529b892f634 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1070,10 +1070,13 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
 				hv_clock->tsc_to_system_mul,
 				100);
 
-	tsc_ref->tsc_offset = hv_clock->system_time;
-	do_div(tsc_ref->tsc_offset, 100);
-	tsc_ref->tsc_offset -=
+	/*
+	 * Note: 'hv_clock->system_time' despite being 'u64' can hold a negative
+	 * value here, thus div_s64().
+	 */
+	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
 		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
+
 	return true;
 }
 
-- 
2.30.2


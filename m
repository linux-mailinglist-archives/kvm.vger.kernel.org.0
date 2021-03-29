Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C873F34CF55
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhC2Lse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:48:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231341AbhC2LsR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617018496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7dNXYaOTclqUn9MijXwZ7hg6tnWG/YqlnOo2zWP1Ro=;
        b=aupr5yL80KkkTA31hXUEMh1s8+jLN7tkboWzmRKn6rabNFiEsrv8Simg46cuDGGX+klrSd
        Z1L8GKDI4GNXhzkq1ivAM455YlYL10MHUeK9gjh5qHk3eUR9MOI0RO4sPXmALkdYTp77lS
        0yPu0LXJr1VXLCVGdnPY2PC8oYWJR9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-ZJ2Y8tAYM0One8UwMiFmqA-1; Mon, 29 Mar 2021 07:48:15 -0400
X-MC-Unique: ZJ2Y8tAYM0One8UwMiFmqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3201A180FCAF;
        Mon, 29 Mar 2021 11:48:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72CC71001B2C;
        Mon, 29 Mar 2021 11:48:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 2/2] selftests: kvm: Check that TSC page value is small after KVM_SET_CLOCK(0)
Date:   Mon, 29 Mar 2021 13:48:00 +0200
Message-Id: <20210329114800.164066-3-vkuznets@redhat.com>
In-Reply-To: <20210329114800.164066-1-vkuznets@redhat.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test for the issue when KVM_SET_CLOCK(0) call could cause
TSC page value to go very big because of a signedness issue around
hv_clock->system_time.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index ffbc4555c6e2..7f1d2765572c 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -80,19 +80,24 @@ static inline void check_tsc_msr_rdtsc(void)
 	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
 }
 
+static inline u64 get_tscpage_ts(struct ms_hyperv_tsc_page *tsc_page)
+{
+	return mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+}
+
 static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
 {
 	u64 r1, r2, t1, t2;
 
 	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
-	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+	t1 = get_tscpage_ts(tsc_page);
 	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 
 	/* 10 ms tolerance */
 	GUEST_ASSERT(r1 >= t1 && r1 - t1 < 100000);
 	nop_loop();
 
-	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+	t2 = get_tscpage_ts(tsc_page);
 	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 	GUEST_ASSERT(r2 >= t1 && r2 - t2 < 100000);
 }
@@ -130,7 +135,11 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
 
 	tsc_offset = tsc_page->tsc_offset;
 	/* Call KVM_SET_CLOCK from userspace, check that TSC page was updated */
+
 	GUEST_SYNC(7);
+	/* Sanity check TSC page timestamp, it should be close to 0 */
+	GUEST_ASSERT(get_tscpage_ts(tsc_page) < 100000);
+
 	GUEST_ASSERT(tsc_page->tsc_offset != tsc_offset);
 
 	nop_loop();
-- 
2.30.2


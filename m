Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B7053A956
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbiFAOna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 10:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiFAOn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 10:43:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B856377CB
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 07:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654094607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5oaA/9Elp8e0DDOKFrrXNfdudey8cnq8ZY7R8iT31qA=;
        b=V4FR4rLzAVA6i3HwJmgfpjRY0sgxPeXE0qrJVcEasiZquRg4KEYoLG3ZWKMlI16jHdWtyJ
        BGea73CA1AuKgsNmnikZQXKudtLhFNYNUvPxGY7QmVJaoVEI+rrXPpIUnqkKPC4d1CxDbd
        8PcxUnRETWvKPUWNzjzsgSQvaVdBAIg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-WLXFyeubNDSqolgcwGfvcw-1; Wed, 01 Jun 2022 10:43:25 -0400
X-MC-Unique: WLXFyeubNDSqolgcwGfvcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F41C83C0F73C;
        Wed,  1 Jun 2022 14:43:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63EBF1410F36;
        Wed,  1 Jun 2022 14:43:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Make hyperv_clock selftest more stable
Date:   Wed,  1 Jun 2022 16:43:22 +0200
Message-Id: <20220601144322.1968742-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyperv_clock doesn't always give a stable test result, especially with
AMD CPUs. The test compares Hyper-V MSR clocksource (acquired either
with rdmsr() from within the guest or KVM_GET_MSRS from the host)
against rdtsc(). To increase the accuracy, increase the measured delay
(done with nop loop) by two orders of magnitude and take the mean rdtsc()
value before and after rdmsr()/KVM_GET_MSRS.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..3330fb183c68 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -44,7 +44,7 @@ static inline void nop_loop(void)
 {
 	int i;
 
-	for (i = 0; i < 1000000; i++)
+	for (i = 0; i < 100000000; i++)
 		asm volatile("nop");
 }
 
@@ -56,12 +56,14 @@ static inline void check_tsc_msr_rdtsc(void)
 	tsc_freq = rdmsr(HV_X64_MSR_TSC_FREQUENCY);
 	GUEST_ASSERT(tsc_freq > 0);
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer rdmsr() */
 	r1 = rdtsc();
 	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	GUEST_ASSERT(r2 > r1 && t2 > t1);
 
@@ -181,12 +183,14 @@ static void host_check_tsc_msr_rdtsc(struct kvm_vm *vm)
 	tsc_freq = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TSC_FREQUENCY);
 	TEST_ASSERT(tsc_freq > 0, "TSC frequency must be nonzero");
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer ioctl */
 	r1 = rdtsc();
 	t1 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	TEST_ASSERT(t2 > t1, "Time reference MSR is not monotonic (%ld <= %ld)", t1, t2);
 
-- 
2.35.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B426A7D7113
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbjJYPjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjJYPjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11EB10CE
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MiLrHcm1jHxIj86P0YZpTBI2aY7ofRBfJwnJst86kZs=;
        b=g9Dh2beT/XsdYTcp8GS1/HlndgfjKTzW34yiQBVV/nQq586qbr9J8pHtQqAyCadDbT6I5S
        4gaOfm4SJKiD3jSh7aK+RUdtmDPAHSHOEN2mrNWY+Alx3y97JLfSkkr1jTOHH3+frcxYJH
        VPiCYKYXtULI1NoKNCbEwIJadHRyEyw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-br9Zkg-dMF2GxD5U1p93qQ-1; Wed,
 25 Oct 2023 11:29:22 -0400
X-MC-Unique: br9Zkg-dMF2GxD5U1p93qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F53D3C1E9DD;
        Wed, 25 Oct 2023 15:29:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1FD2166B26;
        Wed, 25 Oct 2023 15:29:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH kvm-unit-tests 4/4] x86: hyper-v: Unify hyperv_clock with other Hyper-V tests
Date:   Wed, 25 Oct 2023 17:29:15 +0200
Message-ID: <20231025152915.1879661-5-vkuznets@redhat.com>
In-Reply-To: <20231025152915.1879661-1-vkuznets@redhat.com>
References: <20231025152915.1879661-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always do 'return report_summary()' at the end, use report_abort() when an
abnormality is detected.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_clock.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index f1e7204a8ea9..7eb4f734ee5b 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -144,7 +144,6 @@ static void perf_test(int ncpus)
 
 int main(int ac, char **av)
 {
-	int nerr = 0;
 	int ncpus;
 	struct hv_reference_tsc_page shadow;
 	uint64_t tsc1, t1, tsc2, t2;
@@ -152,7 +151,7 @@ int main(int ac, char **av)
 
 	if (!hv_time_ref_counter_supported()) {
 		report_skip("time reference counter is unsupported");
-		return report_summary();
+		goto done;
 	}
 
 	setup_vm();
@@ -167,10 +166,8 @@ int main(int ac, char **av)
 	       "MSR value after enabling");
 
 	hvclock_get_time_values(&shadow, hv_clock);
-	if (shadow.tsc_sequence == 0 || shadow.tsc_sequence == 0xFFFFFFFF) {
-		printf("Reference TSC page not available\n");
-		exit(1);
-	}
+	if (shadow.tsc_sequence == 0 || shadow.tsc_sequence == 0xFFFFFFFF)
+		report_abort("Reference TSC page not available\n");
 
 	printf("scale: %" PRIx64" offset: %" PRId64"\n", shadow.tsc_scale, shadow.tsc_offset);
 	ref1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
@@ -196,5 +193,6 @@ int main(int ac, char **av)
 	report(rdmsr(HV_X64_MSR_REFERENCE_TSC) == 0,
 	       "MSR value after disabling");
 
-	return nerr > 0 ? 1 : 0;
+done:
+	return report_summary();
 }
-- 
2.41.0


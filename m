Return-Path: <kvm+bounces-11908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8192487CF08
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 406042847D4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 14:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C28538FB2;
	Fri, 15 Mar 2024 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnECXpvA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD371B7FF
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710513318; cv=none; b=ZTmf72OMXdCpjHX77PVVI2jL/7GtipNtMbBstNyj7erCS/CefJKKh0G9hzZcgZZlJtodsS/Di3/tvg4xDmTOGynlupNjq3Qha/s4LajWXHKR067cj3S4ihKROeY+Dw3yEHdNGd3pJv8G7bclxEly13FVLfKGjK1aObDEkjCSQuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710513318; c=relaxed/simple;
	bh=Bnp7XWkyPj45TcVE/OTtDC1VSqGlz7YOyH8lcokg3ec=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JeXUnH4XENWIlnq5gg/ZCoKJSoahKSvmiSAedKW4SbHnqetF7r5WRmH2RnxEP8oarOryiUEkFkNpSoHdSrV2k1HMbrRQag6Ox8jAb4wpMtdsUXJ3TPfU6tUTaMvum4Rb3122iIBvi0OlwzuOVaIxDsvNtK2DSVbN/DZmYwHKEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnECXpvA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710513315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SrsZ3sRjJ0cd4TSAU6qFDBULeyMZSqfIVaf6DxKRBJs=;
	b=BnECXpvAxelwjxehlvR/zY2qBNuJep2ebbkXwTGs48igElQuy+odwg/RwpwPWyY2KjYmPS
	EI22iOHB4PhpQ3ldL9DqzcLhM58RLG9dPTHZTb18PNSGxiqQXwVGmstonjeBDbssdxAcsU
	gPg8J23P6Hmr8etQ+TJ/yqLlLAhGVXc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-IO3P_mF2M4yxJoySzljqKA-1; Fri, 15 Mar 2024 10:35:13 -0400
X-MC-Unique: IO3P_mF2M4yxJoySzljqKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86C4E8007A3;
	Fri, 15 Mar 2024 14:35:13 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.10.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3FB1C04128;
	Fri, 15 Mar 2024 14:35:12 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: selftests: fix max_guest_memory_test with more that 256 vCPUs
Date: Fri, 15 Mar 2024 10:35:07 -0400
Message-Id: <20240315143507.102629-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

max_guest_memory_test uses ucalls to sync with the host, but
it also resets the guest RIP back to its initial value in between
tests stages.

This makes the guest never reach the code which frees the ucall struct
and since a fixed pool of 512 ucall structs is used, the test starts
to fail when more that 256 vCPUs are used.

Fix that by replacing the manual register reset with a loop in
the guest code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 .../testing/selftests/kvm/max_guest_memory_test.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 6628dc4dda89f3c..1a6da7389bf1f5b 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -22,10 +22,11 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
 	uint64_t gpa;
 
-	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-		*((volatile uint64_t *)gpa) = gpa;
-
-	GUEST_DONE();
+	for (;;) {
+		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+			*((volatile uint64_t *)gpa) = gpa;
+		GUEST_SYNC(0);
+	}
 }
 
 struct vcpu_info {
@@ -55,7 +56,7 @@ static void rendezvous_with_boss(void)
 static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu_run(vcpu);
-	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
 }
 
 static void *vcpu_worker(void *data)
@@ -64,17 +65,13 @@ static void *vcpu_worker(void *data)
 	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
-	struct kvm_regs regs;
 
 	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
 
-	/* Snapshot regs before the first run. */
-	vcpu_regs_get(vcpu, &regs);
 	rendezvous_with_boss();
 
 	run_vcpu(vcpu);
 	rendezvous_with_boss();
-	vcpu_regs_set(vcpu, &regs);
 	vcpu_sregs_get(vcpu, &sregs);
 #ifdef __x86_64__
 	/* Toggle CR0.WP to trigger a MMU context reset. */
-- 
2.40.1



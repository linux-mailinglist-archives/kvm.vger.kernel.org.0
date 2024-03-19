Return-Path: <kvm+bounces-12180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A5388059A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 20:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57D181C22818
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1869D3B785;
	Tue, 19 Mar 2024 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NvZI8fo1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444639FFD
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877445; cv=none; b=oq5xntjaaL8wmmFxj368N8z0NHxCWJ4l8n8OYM7KIjgLS6V1cbsdOHoFK0b9Pa8OFtH7mK8yYPWgTGKPbIq+mdvJ7T216H3mcMY+MiMkbaBMQO7+naIzn/XEzgB3FXslgoYlNt1zb2gWXiywRu6zcBQiro1AKcO7mT9GVMonMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877445; c=relaxed/simple;
	bh=DpTVlNXrctec4b3CsWrFlQYf/h/hDyzV3LAmJBcqDjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=leoAAGwnZdHqJ99L5oN39VDN1oxUK/N7qQpvwqtzjJkcZHGMVSHrNTQCDmltFe4VLenes747itys11FJ2fKdosKYjGyIAuy0dSHfhraOrbmnuljwaEfJHalYIFITPb6vOSG/WoqtGcvvcOZDr9qYzc4XLvX0TIfYN30WCW7OiXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NvZI8fo1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710877442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtkIQ4MjvqbejQVBH3/CsAsyaYz00eM1hO1APdOnE38=;
	b=NvZI8fo1QJjrFKFeuQJV0rNt/FZHR6hIDoykKsPegHssm3wSJMY3iSpEcJpo85zh2oRLXH
	X1Wny0cWqxMSgdv205IhB7m85zth/l6oQm1L6i5Cl6b2nOv3RgWl3oYyo6wJ0fde/Awa+L
	Gv5j6YmAz+8GPXUZdqDxxhmW5OJ4/xw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-Nb-o7brNP_6pKt0lYMlZug-1; Tue, 19 Mar 2024 15:43:58 -0400
X-MC-Unique: Nb-o7brNP_6pKt0lYMlZug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63450800262;
	Tue, 19 Mar 2024 19:43:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 416BC492BC8;
	Tue, 19 Mar 2024 19:43:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH v4 17/15] selftests: kvm: split "launch" phase of SEV VM creation
Date: Tue, 19 Mar 2024 15:43:56 -0400
Message-ID: <20240319194357.2766768-2-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Allow the caller to set the initial state of the VM.  Doing this
before sev_vm_launch() matters for SEV-ES, since that is the
place where the VMSA is updated and after which the guest state
becomes sealed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/sev.h |  3 ++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c     | 16 ++++++++++------
 .../selftests/kvm/x86_64/sev_smoke_test.c        |  7 ++++++-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
index 0719f083351a..82c11c81a956 100644
--- a/tools/testing/selftests/kvm/include/x86_64/sev.h
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -31,8 +31,9 @@ void sev_vm_launch(struct kvm_vm *vm, uint32_t policy);
 void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
 void sev_vm_launch_finish(struct kvm_vm *vm);
 
-struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
 					   struct kvm_vcpu **cpu);
+void vm_sev_launch(struct kvm_vm *vm, uint32_t policy, uint8_t *measurement);
 
 kvm_static_assert(SEV_RET_SUCCESS == 0);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
index 597994fa4f41..d482029b6004 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -113,26 +113,30 @@ void sev_vm_launch_finish(struct kvm_vm *vm)
 	TEST_ASSERT_EQ(status.state, SEV_GUEST_STATE_RUNNING);
 }
 
-struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
 					   struct kvm_vcpu **cpu)
 {
 	struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
-		.type = policy & SEV_POLICY_ES ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM,
+		.type = type,
 	};
 	struct kvm_vm *vm;
 	struct kvm_vcpu *cpus[1];
-	uint8_t measurement[512];
 
 	vm = __vm_create_with_vcpus(shape, 1, 0, guest_code, cpus);
 	*cpu = cpus[0];
 
+	return vm;
+}
+
+void vm_sev_launch(struct kvm_vm *vm, uint32_t policy, uint8_t *measurement)
+{
 	sev_vm_launch(vm, policy);
 
-	/* TODO: Validate the measurement is as expected. */
+	if (!measurement)
+		measurement = alloca(256);
+
 	sev_vm_launch_measure(vm, measurement);
 
 	sev_vm_launch_finish(vm);
-
-	return vm;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 026779f3ed06..234c80dd344d 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -41,7 +41,12 @@ static void test_sev(void *guest_code, uint64_t policy)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);
+	uint32_t type = policy & SEV_POLICY_ES ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
+
+	vm = vm_sev_create_with_one_vcpu(type, guest_code, &vcpu);
+
+	/* TODO: Validate the measurement is as expected. */
+	vm_sev_launch(vm, policy, NULL);
 
 	for (;;) {
 		vcpu_run(vcpu);
-- 
2.43.0




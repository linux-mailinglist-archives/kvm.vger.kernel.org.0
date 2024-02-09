Return-Path: <kvm+bounces-8471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D25C84FC16
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0CFA1F2A522
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531861292FB;
	Fri,  9 Feb 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwzVrE6m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF0C84A45
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503874; cv=none; b=HULVjzs/J8/pD4NngQQQWcTb7Qm8SyCSKdVfklqOlKVkK3S8poKHCLX9wpZxkc2hSiAJlkDNcup61qyPzsNFRfiJ5s79y2zTm4h+1tvILvKOdwXzJ7y5v960MZboap19fOz+USYbvosWbCFhlExutdbVhNYcvrLo6wcvBscxmPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503874; c=relaxed/simple;
	bh=uQGym0uY8E+sVE8krP9c0q2ErXtRcLOKpg09TRNB1ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwCaD8Nms3ukh20Zo88SB5/aCfPJSn0Gjo1GdN0rPFWFvLOxQBeXogiEED/5X+tB1x1nD2NRQWCt58YGOnTiBSnmv0PzqLofchOdUP2qDWsHvw2ALCCJ9a3HMOHGutSsBRQtb5gggSLTLa6/uV51BF42T8TPJcSR43lknymcE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cwzVrE6m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707503871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKAk4/TG7DQbNymtLCqGi+ahWWWkN+eb/YBYVWviCeg=;
	b=cwzVrE6mD9KA2SPP1Ybtpjf8L1EjXsKDv8JJ+B5vL/6l9hsglj3cuCl7CsnDT9jqEju8jw
	tYEI+J1Er8zlB/+33MSE0oQKU82tU4zYOhQwrXjWGe3JW0uoIKouL3chIdXakYWXE1G0C0
	gSdVyyWtkd5APafek20AbK8YXhkugs0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-SQsfi3rrPhWvZ2SsnRDvbA-1; Fri,
 09 Feb 2024 13:37:47 -0500
X-MC-Unique: SQsfi3rrPhWvZ2SsnRDvbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7041B1C068ED;
	Fri,  9 Feb 2024 18:37:46 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41B8B2166B33;
	Fri,  9 Feb 2024 18:37:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 11/10] selftests: kvm: switch sev_migrate_tests to KVM_SEV_INIT2
Date: Fri,  9 Feb 2024 13:37:43 -0500
Message-Id: <20240209183743.22030-12-pbonzini@redhat.com>
In-Reply-To: <20240209183743.22030-1-pbonzini@redhat.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index c7ef97561038..301f7083cad0 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -50,11 +50,12 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
 static struct kvm_vm *sev_vm_create(bool es)
 {
 	struct kvm_vm *vm;
+	struct kvm_sev_init init = { 0 };
 	struct kvm_sev_launch_start start = { 0 };
 	int i;
 
-	vm = vm_create_barebones();
-	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
+	vm = vm_create_barebones_type(es ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM);
+	sev_ioctl(vm->fd, KVM_SEV_INIT2, &init);
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		__vm_vcpu_add(vm, i);
 	if (es)
@@ -65,12 +66,12 @@ static struct kvm_vm *sev_vm_create(bool es)
 	return vm;
 }
 
-static struct kvm_vm *aux_vm_create(bool with_vcpus)
+static struct kvm_vm *aux_vm_create(bool es, bool with_vcpus)
 {
 	struct kvm_vm *vm;
 	int i;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(es ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM);
 	if (!with_vcpus)
 		return vm;
 
@@ -102,7 +103,7 @@ static void test_sev_migrate_from(bool es)
 
 	src_vm = sev_vm_create(es);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		dst_vms[i] = aux_vm_create(true);
+		dst_vms[i] = aux_vm_create(es, true);
 
 	/* Initial migration from the src to the first dst. */
 	sev_migrate_from(dst_vms[0], src_vm);
@@ -164,16 +165,17 @@ static void test_sev_migrate_locking(void)
 
 static void test_sev_migrate_parameters(void)
 {
-	struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu, *vm_no_sev,
+	struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu,
 		*sev_es_vm_no_vmsa;
 	int ret;
 
 	vm_no_vcpu = vm_create_barebones();
-	vm_no_sev = aux_vm_create(true);
-	ret = __sev_migrate_from(vm_no_vcpu, vm_no_sev);
+	sev_vm = aux_vm_create(false, true);
+	ret = __sev_migrate_from(vm_no_vcpu, sev_vm);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
 		    errno);
+	kvm_vm_free(sev_vm);
 
 	if (!have_sev_es)
 		goto out;
@@ -213,7 +215,6 @@ static void test_sev_migrate_parameters(void)
 	kvm_vm_free(sev_es_vm_no_vmsa);
 out:
 	kvm_vm_free(vm_no_vcpu);
-	kvm_vm_free(vm_no_sev);
 }
 
 static int __sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
@@ -272,7 +273,7 @@ static void test_sev_mirror(bool es)
 	int i;
 
 	src_vm = sev_vm_create(es);
-	dst_vm = aux_vm_create(false);
+	dst_vm = aux_vm_create(es, false);
 
 	sev_mirror_create(dst_vm, src_vm);
 
@@ -295,8 +296,8 @@ static void test_sev_mirror_parameters(void)
 	int ret;
 
 	sev_vm = sev_vm_create(/* es= */ false);
-	vm_with_vcpu = aux_vm_create(true);
-	vm_no_vcpu = aux_vm_create(false);
+	vm_with_vcpu = aux_vm_create(false, true);
+	vm_no_vcpu = aux_vm_create(false, false);
 
 	ret = __sev_mirror_create(sev_vm, sev_vm);
 	TEST_ASSERT(
@@ -345,13 +346,13 @@ static void test_sev_move_copy(void)
 		      *dst_mirror_vm, *dst2_mirror_vm, *dst3_mirror_vm;
 
 	sev_vm = sev_vm_create(/* es= */ false);
-	dst_vm = aux_vm_create(true);
-	dst2_vm = aux_vm_create(true);
-	dst3_vm = aux_vm_create(true);
-	mirror_vm = aux_vm_create(false);
-	dst_mirror_vm = aux_vm_create(false);
-	dst2_mirror_vm = aux_vm_create(false);
-	dst3_mirror_vm = aux_vm_create(false);
+	dst_vm = aux_vm_create(false, true);
+	dst2_vm = aux_vm_create(false, true);
+	dst3_vm = aux_vm_create(false, true);
+	mirror_vm = aux_vm_create(false, false);
+	dst_mirror_vm = aux_vm_create(false, false);
+	dst2_mirror_vm = aux_vm_create(false, false);
+	dst3_mirror_vm = aux_vm_create(false, false);
 
 	sev_mirror_create(mirror_vm, sev_vm);
 
@@ -378,9 +379,9 @@ static void test_sev_move_copy(void)
 	 * destruction is done safely.
 	 */
 	sev_vm = sev_vm_create(/* es= */ false);
-	dst_vm = aux_vm_create(true);
-	mirror_vm = aux_vm_create(false);
-	dst_mirror_vm = aux_vm_create(false);
+	dst_vm = aux_vm_create(false, true);
+	mirror_vm = aux_vm_create(false, false);
+	dst_mirror_vm = aux_vm_create(false, false);
 
 	sev_mirror_create(mirror_vm, sev_vm);
 
-- 
2.39.0



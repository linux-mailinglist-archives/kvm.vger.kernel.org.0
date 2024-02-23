Return-Path: <kvm+bounces-9458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 273388607D8
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B1EEB212F8
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888221429C;
	Fri, 23 Feb 2024 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z1fqfPJU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701D12E43
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708649001; cv=none; b=XeG3nW7AsOj1a0oBaUjEkECxCLEeYeSgpoP8atdxg3QLm3IX9mDVN9ijVmr3BJUi/X7Wf4Eu643cNlCDp0ztEJDGmPHhMNg3nDt0VKbFxr66Heayyoakxl/+HqOr91cluyxsAjsu/1IAQQWRZbZz295xlbhRX4w30g1NCZAv0zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708649001; c=relaxed/simple;
	bh=tyZgfxNkQndxJJOO7ECuOTfeiV340CWZKe8/mOgdQK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SC+vBkJjtM0BFYIdZllebxdfvw/4RwouuyZy1QjaIoOiKY2rrOP1H4KY08joquSsEfw9DpUdZaW520mf+kWCRxX7LAhJwe9YudMpr9ZdgXJkM9ewv66lQ7sgagKA+2S8N3BMNRHuktqwHBUDOHzG+kCB4zh1929ODJFnnk+Yr8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z1fqfPJU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2995baae8b4so314382a91.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648999; x=1709253799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lRpse7Hgpajlk57C2H5vth1Tg0pkPPWc04aEOHzQOwA=;
        b=Z1fqfPJUV+2UqYUSJtafJe8vLVB9XizU+aOn9sFXD6S0fm6oaLGS4E1DNI7snLbVs9
         8GKrRjRlslYLGAXNMKHL0MeAmThcFnM9ysEI1ICg4MeROyVYJx9uFKIYODGBNq+KiHih
         S0SxywN7xIQd5JJ32+aNtGdPkWfoc5u9CwHloMZ9CEPiS+YRsXwhMbx2oeg4Es2wsQde
         yeY9piBAgqRMhK81CGmitNgJbvTiFYEX63ZnjFWPniPd2tCpUlh71hUou7+BUYFHpjc/
         5TMYy6hZY5gJSp5Tmcc9lKwELLwEQAU4yAKKrxJqxTlj+1oKNbxQGjAgtd62YkPOoJ7l
         PoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648999; x=1709253799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRpse7Hgpajlk57C2H5vth1Tg0pkPPWc04aEOHzQOwA=;
        b=c/aD9X9DsjOd0WGi89lRH18+C6jYQZkWmu3sLMJOrZnsdDeTzogpoff9W0vOcI43Rd
         TwCgwCQbL0HQu7TklIT+hQYfxPXR3wgFzGwlcgBFyC8PLlVdK8Le6X8EArUxeCVR8MYr
         /fqTRR27TTHX/6/jWGi6jOhzMJBR7ZXF+uwJdZLg10JA7ZvFDPiUN6W6KXQ8CvkKu3ec
         hoQ3u8ik7lAhifCyt2b3d6VUD92LOJ0NiEPUwiDiZCl4FhkCQAPxbfyty9tkjXvWkVIY
         toRgd4448EI1Rl4fIF3gSvRnI35WXupzPFp1IO64+8vv66kPrrJ20/oOk1CIErY4WxbY
         eQ9w==
X-Gm-Message-State: AOJu0YyYqLu6TiS41JkYtN3wWfesxzZ2oVjo0r/1/iWsTGrg9B3FQstO
	7O2hLXEoEDoIX9UixJfHtNm7/oV83ak3YlDsgW5s/JCZc6YdiwFABnsUW2XNLi1KuV9fVsQVzBY
	TGA==
X-Google-Smtp-Source: AGHT+IHDQETePQetxa/9bLHgOPQ91WhsyrAdMFKDkfvyNMFp3v4runbA1w2m83674UspLgdjLo+hqAFR40U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3d01:b0:299:942e:6634 with SMTP id
 pt1-20020a17090b3d0100b00299942e6634mr1218pjb.1.1708648999474; Thu, 22 Feb
 2024 16:43:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:56 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-10-seanjc@google.com>
Subject: [PATCH v9 09/11] KVM: selftests: Use the SEV library APIs in the
 intra-host migration test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Port the existing intra-host SEV(-ES) migration test to the recently added
SEV library, which handles much of the boilerplate needed to create and
configure SEV guests.

Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 67 ++++++-------------
 1 file changed, 21 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index a49828adf294..d6f7428e42c6 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -10,11 +10,9 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
-#include "svm_util.h"
+#include "sev.h"
 #include "kselftest.h"
 
-#define SEV_POLICY_ES 0b100
-
 #define NR_MIGRATE_TEST_VCPUS 4
 #define NR_MIGRATE_TEST_VMS 3
 #define NR_LOCK_TESTING_THREADS 3
@@ -22,46 +20,24 @@
 
 bool have_sev_es;
 
-static int __sev_ioctl(int vm_fd, int cmd_id, void *data, __u32 *fw_error)
-{
-	struct kvm_sev_cmd cmd = {
-		.id = cmd_id,
-		.data = (uint64_t)data,
-		.sev_fd = open_sev_dev_path_or_exit(),
-	};
-	int ret;
-
-	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
-	*fw_error = cmd.error;
-	return ret;
-}
-
-static void sev_ioctl(int vm_fd, int cmd_id, void *data)
-{
-	int ret;
-	__u32 fw_error;
-
-	ret = __sev_ioctl(vm_fd, cmd_id, data, &fw_error);
-	TEST_ASSERT(ret == 0 && fw_error == SEV_RET_SUCCESS,
-		    "%d failed: return code: %d, errno: %d, fw error: %d",
-		    cmd_id, ret, errno, fw_error);
-}
-
 static struct kvm_vm *sev_vm_create(bool es)
 {
 	struct kvm_vm *vm;
-	struct kvm_sev_launch_start start = { 0 };
 	int i;
 
 	vm = vm_create_barebones();
-	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
+	if (!es)
+		sev_vm_init(vm);
+	else
+		sev_es_vm_init(vm);
+
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		__vm_vcpu_add(vm, i);
+
+	sev_vm_launch(vm, es ? SEV_POLICY_ES : 0);
+
 	if (es)
-		start.policy |= SEV_POLICY_ES;
-	sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
-	if (es)
-		sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+		vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 	return vm;
 }
 
@@ -181,7 +157,7 @@ static void test_sev_migrate_parameters(void)
 	sev_vm = sev_vm_create(/* es= */ false);
 	sev_es_vm = sev_vm_create(/* es= */ true);
 	sev_es_vm_no_vmsa = vm_create_barebones();
-	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
+	sev_es_vm_init(sev_es_vm_no_vmsa);
 	__vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
 	ret = __sev_migrate_from(sev_vm, sev_es_vm);
@@ -230,13 +206,13 @@ static void sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
 	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d", ret, errno);
 }
 
-static void verify_mirror_allowed_cmds(int vm_fd)
+static void verify_mirror_allowed_cmds(struct kvm_vm *vm)
 {
 	struct kvm_sev_guest_status status;
+	int cmd_id;
 
-	for (int cmd_id = KVM_SEV_INIT; cmd_id < KVM_SEV_NR_MAX; ++cmd_id) {
+	for (cmd_id = KVM_SEV_INIT; cmd_id < KVM_SEV_NR_MAX; ++cmd_id) {
 		int ret;
-		__u32 fw_error;
 
 		/*
 		 * These commands are allowed for mirror VMs, all others are
@@ -256,14 +232,13 @@ static void verify_mirror_allowed_cmds(int vm_fd)
 		 * These commands should be disallowed before the data
 		 * parameter is examined so NULL is OK here.
 		 */
-		ret = __sev_ioctl(vm_fd, cmd_id, NULL, &fw_error);
-		TEST_ASSERT(
-			ret == -1 && errno == EINVAL,
-			"Should not be able call command: %d. ret: %d, errno: %d",
-			cmd_id, ret, errno);
+		ret = __vm_sev_ioctl(vm, cmd_id, NULL);
+		TEST_ASSERT(ret == -1 && errno == EINVAL,
+			    "Should not be able call command: %d. ret: %d, errno: %d",
+			    cmd_id, ret, errno);
 	}
 
-	sev_ioctl(vm_fd, KVM_SEV_GUEST_STATUS, &status);
+	vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
 }
 
 static void test_sev_mirror(bool es)
@@ -281,9 +256,9 @@ static void test_sev_mirror(bool es)
 		__vm_vcpu_add(dst_vm, i);
 
 	if (es)
-		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+		vm_sev_ioctl(dst_vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 
-	verify_mirror_allowed_cmds(dst_vm->fd);
+	verify_mirror_allowed_cmds(dst_vm);
 
 	kvm_vm_free(src_vm);
 	kvm_vm_free(dst_vm);
-- 
2.44.0.rc0.258.g7320e95886-goog



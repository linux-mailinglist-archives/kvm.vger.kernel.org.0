Return-Path: <kvm+bounces-7884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47408847D9A
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7D36B2917D
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2CE1758F;
	Sat,  3 Feb 2024 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eF5KUrtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C112E68
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918981; cv=none; b=DX0i9kM8jlqdx783Gd3LwL1LpiQ5hZv5YC52txGXp9AtCqL5p15E4KsAmGOu/B5vZQV1cI/nI85oVIQSqf3KTbfgqA5w4+4ZxJZcF+4uI4rOwtVH1BHFnxspfWVktOiIPYjRsoQoNFBRfZc03tD3evgbfwnmN4Mz1JQ/9jFoSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918981; c=relaxed/simple;
	bh=WErIq3K7OOqOd3xHpYtlDNEPs0UpZWxiYWZgTo/MP4I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aIT52U8FPNVNQlv81FH4mg0/86B+2yPV7H2o5oiB0SDHowiQnhllu4x1IMyQd7HpU9P9B/fyE09CD6PrbN7iAwOU6becgseghguWNHv3QK1hOQI+YSMLdAgZTUyghtDt5LbW/2rmiAJMymKvxzbk+cG/SRwlWvV7LAIB3ba7BVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eF5KUrtV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6041dbb7a78so40889307b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918978; x=1707523778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XX/qPWiFzcrNc98rmsyPZwe0j7yaMHMPDZjofeW64Pk=;
        b=eF5KUrtVovEJ4MDY6oGzaFPy1rOPDlgm8O18gNe4qm2R10VKwzOXH/clL8xMTRKe5t
         MX5BWFW4o57RNP9UcLtjUpz8pr8XFiA/E9xjW1WoKd8KDE6LumUWVADgMckxLDk+j/Qb
         Rv+L/R8v05AMTl+1NuGlDw5BYyOKEY3PW+S2VEHYFPkKsMt2V8YgY1iMgqLbH0CiEK3E
         rgmRXMQoq2hI1X1OzUGRWDMuU6Kf+kG30Z+OUZ35FrVZ1Ko7+6hXWfd/fDhnVoZ45Jg6
         FTQXsOQFpoLeNscsRsX4jkaaDRvlJZB4yMiseOvl/E4lcKBbSNP0hFFbh25WVwufR4E5
         d8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918978; x=1707523778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XX/qPWiFzcrNc98rmsyPZwe0j7yaMHMPDZjofeW64Pk=;
        b=vTOFDDOBUrD27jheUaFaSmCFiZPXOFXhEXkJdJIWYtk05k/s7gVxDcWvPn0ETxz/0G
         Pc3xu5Bp2qO/qiGER/uRgYtS9xpQtuhD2/eM84KhC7JVIu1Sw5CtrPrG42+eUllZJVmo
         03ctgP6oSE6CZ37GAX2D4neN4zJAw+x9j5bJ6K4CPwZp0L6iB48jME4DaUN0jOiegXcr
         GBZ7PdkgQ7eDbmdMg8F/uYVsLKJxTkaW5aAkv7WVs4qnRIHHNwrN7UUsUK7NR9wh2uMr
         FcvLjDLWvqwD9UUGunj47QZgJTFmeW3VBO9Cvks9bGZT9HfccYe1YGd8OGd+PyX/EvbD
         m3uA==
X-Gm-Message-State: AOJu0YyfiqzBCiOkXDj6VM6T4uc7qG/s7l6Rw+ANNMRC3SHnRmcS6cXW
	TTy8pmphUnFf2VKpKk+VS2qRaEeA1nL4bdccSLk+HwH1BgK2VeBVZ9Py0TriefUXGDcGCszO4hT
	rpQ==
X-Google-Smtp-Source: AGHT+IGBKIXyRsAwi5cacC2RTa4GkVM2EUkU98GzGDTFoqRDoIOEQUQo2SlZwq83sHOJV7drFveoG9mVQK8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1085:b0:dc6:e5e9:f3af with SMTP id
 v5-20020a056902108500b00dc6e5e9f3afmr1242765ybu.9.1706918978596; Fri, 02 Feb
 2024 16:09:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:15 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-10-seanjc@google.com>
Subject: [PATCH v8 09/10] KVM: selftests: Use the SEV library APIs in the
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
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

Port the existing intra-host SEV(-ES) migration test to the recently added
SEV library, which handles much of the boilerplate needed to create and
configure SEV guests.

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
2.43.0.594.gd9cf4e227d-goog



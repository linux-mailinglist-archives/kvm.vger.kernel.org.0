Return-Path: <kvm+bounces-27597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5652987C1C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 02:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D44828514B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F1874C08;
	Fri, 27 Sep 2024 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NC7jcXPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5951B5AA
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727396205; cv=none; b=PG1RxsXsC4NaFXCezGJ2NKU8a53Px0YzymzT9e8ca1NOahs0u9ovApdAd+1ghFekrStzB0OKQDrKP4gsg1LKfQrhEk2Oc6KVPyo7aZJQ8cNHZkhtvTzJb9h8NuSmLfGkZ7neMYUxFWgXr2WxwgDzxmY8k6XhL6iPjtZZFCI9LIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727396205; c=relaxed/simple;
	bh=qPB840LKVU6ZflRf4RW/o9F2/cJChriS9wj2fwnqz/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BZFUul7NyJjt5pIb/FcuDlUmk4dn9YcRqMzxcweR/UtVKJQW9EXcxVBSUX3hHzzWmKsZpno90Y+S9ddaUcZpGTKaqfyubNAyl0kKlQ9BXhnU2VDl/Ek/KclSG2YLhtMSAQ1PWNsLNVVSPqjMA5848GdxgtIS+HVnjXEw+0xSaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NC7jcXPL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206b912491eso25693945ad.0
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 17:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727396202; x=1728001002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LnipXkdMp/tlON0pah63FvB2MDul+F9hL2RAHqV8Mqc=;
        b=NC7jcXPLf7b4SblfqLKX+beZUKFvbWkFWWfTAU/PKAoWG7eyRQG4slbU6YytIeuMeB
         ySP47Y+UAIN3hn/cSZLwHbEB5pnaDwj5jkviBRe3pSyUnhVwHCpQkGteINz9omPy+vY7
         31qlNy5r3nNJl0K3P1yyNUtGmZ7zvxqIvodLNLHD8Ycv74escpf5gk8lPsHxu7JR/mZP
         8Sdea/KIYJ4Zz4LtT2wbKLf8eDeCeVJ/bUooWhSqLYgs0bIBxCREcL1dcUFcraEeVDed
         5wERlESEX0OWMTdc7MdX75ByTQb0Oem8+BWPsrcHCY9EC9HDlYjTqnKrmUD2Bv7z9/mi
         qebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727396202; x=1728001002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LnipXkdMp/tlON0pah63FvB2MDul+F9hL2RAHqV8Mqc=;
        b=LpKyNEFMtGvztUU408Uk5Ewx8dGjoi6+1uI97lVVmMB3G6C3OseCBcdWjInUSbSPUa
         7zciQduhkvltCMg8oYMDvEBJCP9kL5w3NF987ju0tCA15f5mqZKTrQtQQ5fknZ3XjEv9
         wDLeHVlFz7I2utmWlM0yfw+aAo3V9seIHdq0DCJq4/sYCskwMpXV3cDzqdE1P0KxsXhm
         VEgrEdDvCyUyOeuPf89jgNYhSgIYHpjCuKhyJHtieBbD+3PWrtzhwKVssKz8VBRzeZIU
         BAhI0cWJeucKO9+Yc6k/h3tg9fGiujItEfhYO6wvyhx7ZJ24Qwln1uO5xym/l0xFN0dw
         AbjQ==
X-Gm-Message-State: AOJu0YxaIADUouZcJpxdYC8Afc0HxPl0+5DUWCeKF1F1qDDARleq1VRz
	vhkrGTsJi2hynER0oISTHshfC8shT5s/POdVX39sdqCy8qZ5ZyrvMpHTDTX6TiCxvemGTH8/wBe
	K8A==
X-Google-Smtp-Source: AGHT+IGBgI29zkiAKYn/9+spEvVm1fKGkUxDR5oSOVdglhJX+CIn7SSutJlwoDocu8LwMv7t2j2eZRuCCYQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:33cf:b0:205:3bc6:bf1 with SMTP id
 d9443c01a7336-20b19cad0f2mr59905ad.4.1727396201564; Thu, 26 Sep 2024 17:16:41
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Sep 2024 17:16:33 -0700
In-Reply-To: <20240927001635.501418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927001635.501418-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240927001635.501418-3-seanjc@google.com>
Subject: [PATCH 2/4] Revert "KVM: selftests: Allow slot modification stress
 test with quirk disabled"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Revert memslot_modification_stress_test's KVM_X86_QUIRK_SLOT_ZAP_ALL
testcase, as the quirk is being removed, i.e. the KVM side of things is
being reverted.

This reverts commit 218f6415004a881d116e254eeb837358aced55ab.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/memslot_modification_stress_test.c    | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index e3343f0df9e1..49f162573126 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -79,7 +79,6 @@ struct test_params {
 	useconds_t delay;
 	uint64_t nr_iterations;
 	bool partition_vcpu_memory_access;
-	bool disable_slot_zap_quirk;
 };
 
 static void run_test(enum vm_guest_mode mode, void *arg)
@@ -90,13 +89,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
-#ifdef __x86_64__
-	if (p->disable_slot_zap_quirk)
-		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-
-	pr_info("Memslot zap quirk %s\n", p->disable_slot_zap_quirk ?
-		"disabled" : "enabled");
-#endif
 
 	pr_info("Finished creating vCPUs\n");
 
@@ -115,12 +107,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m mode] [-d delay_usec] [-q]\n"
+	printf("usage: %s [-h] [-m mode] [-d delay_usec]\n"
 	       "          [-b memory] [-v vcpus] [-o] [-i iterations]\n", name);
 	guest_modes_help();
 	printf(" -d: add a delay between each iteration of adding and\n"
 	       "     deleting a memslot in usec.\n");
-	printf(" -q: Disable memslot zap quirk.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     accessed by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -146,7 +137,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:d:qb:v:oi:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:d:b:v:oi:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -169,12 +160,6 @@ int main(int argc, char *argv[])
 		case 'i':
 			p.nr_iterations = atoi_positive("Number of iterations", optarg);
 			break;
-		case 'q':
-			p.disable_slot_zap_quirk = true;
-
-			TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
-				     KVM_X86_QUIRK_SLOT_ZAP_ALL);
-			break;
 		case 'h':
 		default:
 			help(argv[0]);
-- 
2.46.1.824.gd892dcdcdd-goog



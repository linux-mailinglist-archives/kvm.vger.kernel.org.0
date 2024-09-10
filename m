Return-Path: <kvm+bounces-26411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4C49746C2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE1952884E4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2F61BF327;
	Tue, 10 Sep 2024 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qBJJpB7n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C441AE843
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011907; cv=none; b=fsReSqjrv+azm7kaYFZ7+ctYIUSUFiZRE+DQRmtSMaPId7Ka7XzPOgnTnmewNymDAdrIWMlh0bvX/EGZyatBWX9zs8aqUgxSGJZ+GFto/H2sfr4t/iln92+UhDQrHCHOEktQv7qmsnCkhzIFntQXEHzyjmnPGCOYOsaZxyw99l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011907; c=relaxed/simple;
	bh=TzSJJrRlAi780A8pE55jdRFKRZBu64XpcxDuBoryqQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GyFILsKzqktjwklnHHZdWrZW4SWnUwPbK4iZci5gegLbHGfhkAHyTLznnwDvd9AeXTUpg1iYZgQw7DY/aj1ARJq2u5CFFQL4lW9aJy/qTme2wBx5DCt+Z7ZGROgB0YBzJA1VTFNXItbmNBFnSShpvYqPE8UfnkKELFmlF9FmVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qBJJpB7n; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4fb78fe49so5332070a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011905; x=1726616705; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JNe/WmHLeg6VKg7h5W2f+s+eqgKPFc2fIX3V6u3knDI=;
        b=qBJJpB7n5mTvijCfEdMh2HbVXo1BCYMHQbNlSNfKFWq+K8pGQyhWQQOOodkJRxLTOO
         Xnka5U1glb+Eor5CES1U6pvCgkC/peoM8mwIlda6IgnIQfVqj2o0+IK7xfJLdANdknbJ
         cgu2V8psQ2uxiCFU0eXwrQd9q2TEGsp4FZWVcptQ2mNjCGGIqOMO7Hdo+bMIeG7ThEgj
         wV9IBLz/g3MfUjng7fkk5KLk4GTrP5iHIBWj9mvJrrG95LuJ8FBcWwp49e6ssLwFpaov
         dzdw/tb+WulrtLW5jpv/eH8BH22m18vkj024F05piYoUiPkVcwCuqLIW2kWMpmQ5U9UI
         OmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011905; x=1726616705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JNe/WmHLeg6VKg7h5W2f+s+eqgKPFc2fIX3V6u3knDI=;
        b=ntwY0LtQYtu6dFt/2m74M6HQj8ETntcNBtTWpw/1wijpPhm7xDaqe0vRNoAkdC8ziZ
         mG8c1cp3akS9p9bQNFj0kfaCbaoX/g9D+BIJnuodv8KMUq+H26iDlE1W1H6+4OEi3ulr
         t2PkpxaxdS0GM52m7AIE3gXaESOf9rFYserVrOHMrS24P3Bt8CvwHtv5dpGlpgePZC10
         RdFkhD1KgWJkoRv9BftRF+DKibDcdW5cpFdm9QS32De94oQvTSKVlrlCcuh1ZDpOFVWr
         OnhDUvqUVQarKbbWangRCrHc50UmZOfuLpqGY0x3SV8R4DmEPuovZDqDuNLnMJLQMrRP
         /YdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeto73O8hs+Gz73XpqOc5UGQbMMfMYJ5piWXrWSyRa3sT7fYwKeqB2IxueN7PRpV0BcV8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh24QyB3rhQeVmtBjUkbZCWtewzWnWDrCAfxObFaGLR7puUe9+
	dRKGDBPyDPaus07x/cehKqV4T6HtX0GYScwY0wCrW+gOKx7cdHeBMrWhWHiUD2UVi+rn9Zf/8SV
	ucVw2AgiBe801V0ko63hMYw==
X-Google-Smtp-Source: AGHT+IEf/I6TXDj4AnDTGwL9SBffiRIBIsWvgKs+GwMaxvWB3wQdGWq/Gxc5GyUB8zA1nCQX52oCQ5i2eL9ajayvXg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a63:2506:0:b0:7c9:58ed:7139 with SMTP
 id 41be03b00d2f7-7db084ae38emr8766a12.2.1726011904575; Tue, 10 Sep 2024
 16:45:04 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:50 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <41d7d714cfa7cec3e7089a184918da39e93008ee.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 19/39] KVM: selftests: Update test for various private
 memory backing source types
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

Update private_mem_conversions_test for various private memory backing
source types.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 82a8d88b5338..71f480c19f92 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -366,14 +366,20 @@ static void *__test_mem_conversions(void *__vcpu)
 	}
 }
 
-static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t nr_vcpus,
-				 uint32_t nr_memslots)
+static void
+test_mem_conversions(enum vm_mem_backing_src_type src_type,
+		     enum vm_private_mem_backing_src_type private_mem_src_type,
+		     uint32_t nr_vcpus,
+		     uint32_t nr_memslots)
 {
 	/*
 	 * Allocate enough memory so that each vCPU's chunk of memory can be
 	 * naturally aligned with respect to the size of the backing store.
 	 */
-	const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
+	const size_t alignment = max_t(size_t, SZ_2M,
+				       max_t(size_t,
+					     get_private_mem_backing_src_pagesz(private_mem_src_type),
+					     get_backing_src_pagesz(src_type)));
 	const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
 	const size_t memfd_size = per_cpu_size * nr_vcpus;
 	const size_t slot_size = memfd_size / nr_memslots;
@@ -394,7 +400,9 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	memfd = vm_create_guest_memfd(
+		vm, memfd_size,
+		vm_private_mem_backing_src_alias(private_mem_src_type)->flag);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
@@ -440,10 +448,12 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 static void usage(const char *cmd)
 {
 	puts("");
-	printf("usage: %s [-h] [-m nr_memslots] [-s mem_type] [-n nr_vcpus]\n", cmd);
+	printf("usage: %s [-h] [-m nr_memslots] [-s mem_type] [-p private_mem_type] [-n nr_vcpus]\n", cmd);
 	puts("");
 	backing_src_help("-s");
 	puts("");
+	private_mem_backing_src_help("-p");
+	puts("");
 	puts(" -n: specify the number of vcpus (default: 1)");
 	puts("");
 	puts(" -m: specify the number of memslots (default: 1)");
@@ -453,17 +463,21 @@ static void usage(const char *cmd)
 int main(int argc, char *argv[])
 {
 	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	enum vm_private_mem_backing_src_type private_mem_src_type = DEFAULT_VM_PRIVATE_MEM_SRC;
 	uint32_t nr_memslots = 1;
 	uint32_t nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
-	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:s:p:n:")) != -1) {
 		switch (opt) {
 		case 's':
 			src_type = parse_backing_src_type(optarg);
 			break;
+		case 'p':
+			private_mem_src_type = parse_private_mem_backing_src_type(optarg);
+			break;
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
 			break;
@@ -477,7 +491,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	test_mem_conversions(src_type, nr_vcpus, nr_memslots);
+	test_mem_conversions(src_type, private_mem_src_type, nr_vcpus, nr_memslots);
 
 	return 0;
 }
-- 
2.46.0.598.g6f2099f65c-goog



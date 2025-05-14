Return-Path: <kvm+bounces-46563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79354AB79A5
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1E18C69EA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218E2235047;
	Wed, 14 May 2025 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qc3Hqwi+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9D3230BF2
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266192; cv=none; b=kGhqhmksDGDhOKX3c/gNQiO7ErqqGZJje4oBjoyknS7fPD9cI69iEVHlqzEBYN48B+N89+BSXmGaGqWjwcuBj4tsNwjoQRQdWYIMmd9cIWikutxYcYB/4fWbOI9RQ27+36uIMQ9D1sawBzdUO/MukoJWezilcxXd6UiS5ATy2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266192; c=relaxed/simple;
	bh=TuCNdCmxfK0dmEiyt2S0QuAAbIE9Srge8FQVDB0ZAyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ccyce9jDXC1tbgzuamiJYG0+VY5Oq7wefsfLgoD2fNytXxCIOIJY9GFSGwClZFsmTQ25bHi1fEvrYg2tbAPBuq6spdxeyo9Y8sko0bQl1kQFNBcaeDvw120v9xsvTI6PQpF1L2NKfYRA0PZksZMUeRRBz/n5KXXyVIQv8wMOf4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qc3Hqwi+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ac9abbd4bso589532a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266190; x=1747870990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4oPfv2n35WjJH2QrKz/exL9QiCodfRoanXJUAdhzSo=;
        b=Qc3Hqwi+RdTmMP8o5BfDPMMa0DOonJYElm5vx1OVGSiD0ekNGhc3zHt6RUP0rwO7YZ
         sbAP5XcYCaGXja8PEpnMX5tfHesNGtkjDulRN7IY0G3fDVLunr9H+lr4tRcZlzZzue4n
         rp4LbHMXGo4a/cFOdt8oAkcqeSydhYPpSs61QFedt0kni1QOJzVWOBbiAF5fFiX43AsK
         BSxr+cIP8bcCVp6sgNSEQV2ySZsb55oP9nRef2B58fQB20ba7NR4VkKnlM8+2BV8Dbi1
         OKWTfliDvdSMQhoHfr4oNlET/TMTQSXEuFVYo8HFVFJ6wFCp4CR5FRSzibVkHBZWwUSb
         lV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266190; x=1747870990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4oPfv2n35WjJH2QrKz/exL9QiCodfRoanXJUAdhzSo=;
        b=YQJTjEw8MB7YTNL81Q0FST+OkqeWClMPWIgvwaIu0Z1eMEsN+2FXte1EE12hx9uqsp
         7LWfQV5LLxrRLaDp0MVhoC8osA8ImfTpfinipMkrmRZ+7j903nM6mPYfzqIetw1tRfc/
         Rk17K0M+FMFrLIEq3zvMceJYwTmQOMhsqN77SsajM8sFpjaOFSsrM0qiWyIK8mW1dVKx
         LAMxx4BBj3pyvJGUFsEd9BlpxVUwxwTc4Fcha6DezpLBBaWKWGHAgy28Za+y/85hTmKr
         YU9fPGtp/lo4Bflc27pnmGvpHnCiwpmxsRI7gfCqsrC8n7xdZdg9PupNufhlIk2k2ED9
         hi/Q==
X-Gm-Message-State: AOJu0YxGlvOCAQQ5Adt4y6abSIKSM/kpQ8aa+RQ6Pb2MSz8+0Gt8w4CF
	VR8GmJ4HX85M8f18GOQxOVDBt8UxLeSkyjDrs9O/dHCuKfiyRFdF0m6VTqr2aJtJ+ByL9Z18U6f
	bUSFTTbLsUpKt+7IsaBMtkHgk+y6zdJPQxcMSXqc5wzZyioJjU6ZrdEFq1xObtHuBPc4LtmOtzL
	QajV7CTcaPvn776jnvZ7ixrHDW7VyC27DTDiFUkUG9/ff3xBq9XYKUNys=
X-Google-Smtp-Source: AGHT+IEA8LrfLfFI8PpcjddLO/wbh1V8oxL5OnFdRpSUscIRk8byP+XixVrSrRP2XLlfKkrpW4t+rWo0H2IMHIeXcA==
X-Received: from pjbqx15.prod.google.com ([2002:a17:90b:3e4f:b0:308:64ce:7274])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2dc2:b0:2ee:f687:6acb with SMTP id 98e67ed59e1d1-30e5158e007mr667015a91.13.1747266189745;
 Wed, 14 May 2025 16:43:09 -0700 (PDT)
Date: Wed, 14 May 2025 16:41:47 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <7ae972e602f94cef707ccb19b139638f4266d361.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 08/51] KVM: selftests: Test flag validity after
 guest_memfd supports conversions
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Before guest_memfd supports conversions, Coco VMs must not allow
GUEST_MEMFD_FLAG_SUPPORT_SHARED.

Because this is a platform stability requirement for hosts supporting
Coco VMs, this is an important test to retain.

Change-Id: I7a42a7d22e96adf17db3dcaedac6b175a36a0eab
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index bf2876cbd711..51d88acdf072 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -435,7 +435,8 @@ static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
 	for (flag = BIT(0); flag; flag <<= 1) {
 		test_vm_with_gmem_flag(vm, flag, flag & expected_valid_flags);
 
-		if (flag == GUEST_MEMFD_FLAG_SUPPORT_SHARED) {
+		if (flag == GUEST_MEMFD_FLAG_SUPPORT_SHARED &&
+		    kvm_has_cap(KVM_CAP_GMEM_CONVERSION)) {
 			test_vm_with_gmem_flag(
 				vm, flag | GUEST_MEMFD_FLAG_INIT_PRIVATE, true);
 		}
@@ -444,7 +445,7 @@ static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
 	kvm_vm_release(vm);
 }
 
-static void test_gmem_flag_validity(void)
+static void test_gmem_flag_validity_without_conversion_cap(void)
 {
 	uint64_t non_coco_vm_valid_flags = 0;
 
@@ -462,11 +463,30 @@ static void test_gmem_flag_validity(void)
 #endif
 }
 
+static void test_gmem_flag_validity(void)
+{
+	/* After conversions are supported, all VM types support shared mem. */
+	uint64_t valid_flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+
+	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, valid_flags);
+
+#ifdef __x86_64__
+	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, valid_flags);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, valid_flags);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, valid_flags);
+	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, valid_flags);
+	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, valid_flags);
+#endif
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
-	test_gmem_flag_validity();
+	if (kvm_has_cap(KVM_CAP_GMEM_CONVERSION))
+		test_gmem_flag_validity();
+	else
+		test_gmem_flag_validity_without_conversion_cap();
 
 	test_with_type(VM_TYPE_DEFAULT, 0, false);
 	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
-- 
2.49.0.1045.g170613ef41-goog



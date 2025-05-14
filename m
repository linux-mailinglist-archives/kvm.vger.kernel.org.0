Return-Path: <kvm+bounces-46558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47169AB7996
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA36D1BA401D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162EA22DFAF;
	Wed, 14 May 2025 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RUiD2veF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875F422CBD2
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266185; cv=none; b=q+R9tdsxQ6ichh00dldlYoFVP36ELXkbAMClig5USpfOxwbrOgoi3ke+nAG+wytlllk58iAyVFjGcXyNUGm1+V4P2bdPO/oaS4BUAMgwAZmthxL2vOaEygVYHWJHLOT9U1A861hTeJQ/b0qZBffSoyntGxWWMdTGVkNa1yHy+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266185; c=relaxed/simple;
	bh=TvFIoSrzCO8w1cNFBdYkZGoalAviBLZzlcndl+DTNy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nhIa7rGkh+StYEB4XOopnaDf+qQOsoJy2xtre93Hf/y+s1IV6IRifQJ0gRk2S0bZooC7kgnR0E5VlkzLY9xasAFNkTgAbZtqlmrG5iyEBIfoND23H1NeSZK7ZxbzmyMDIyq6SrUmmnIb9UOYf//jvi5x1VXwZ+AA9tsFYnlJwW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RUiD2veF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so166762a12.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266183; x=1747870983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OB4Vu62B2E9k02apRztGbb6VkHGr4YYVx8kY72Oa8kw=;
        b=RUiD2veFBgB4e/9GIEvsGJOEViwnuD0kDl8jAeToKmGQz5mbpTDLcb/2eCFWyvbq02
         /chTj+4uIfvw6RZJTYysxa0oW35F3h4vCOHwG3oBTAdpv7ywn9p9iptJbMsZ/QmiWh2d
         x3KKKP0ColGHRWZr+DbjGovFs5WjMM+HhLy6UNzwpjwYyIEReZZeqVrbfh275BUHB/Ok
         AE3S1nY8dt7smj53vqqe4ao/e3d35i3VhirtnprnXmR8WCqhAJ56hs9enRdBFSfm1NiW
         6o/CY/cnvnGrbebmFEdsthkcXzlPNDIZ9JoDgW/G0gJ9Gh7Nx8NZxxZ0TlgVbG/MzBxX
         bXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266183; x=1747870983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OB4Vu62B2E9k02apRztGbb6VkHGr4YYVx8kY72Oa8kw=;
        b=Mt19y3Fv/3JuqT8QEj58tyTQpDGcq4mXD0FZN7+F4RM3yxUOzDKFHcUGbuA8ACapRp
         1MJpC9p1YQUYN33nUyzrPktrYumJ7KICdxuTnSeZr/GvUCjJQzI0FmpTcLGywTR6ZYWh
         mkTOAPR7wJqlHkftFggZZ9evm1wtzqmZRPPhtnMH3H10uXxighxPosLu7IsmOBg24y9w
         WdSZxWUx6J8s4dc0jGgYtnD9DO4K4t1aeqlvXRS/ofBQRajZg8HiNZnPS007fxTTLg0R
         ytjycTi/OGz0M1UMSOmXkvJSjyWl7Ms8amtamW062QEmqfCHzo6cfpQLwA13UGqqauUb
         RTgQ==
X-Gm-Message-State: AOJu0YziTCyrlSdJtvTdGnE0JvPJXcBiYF7I+PHgAnFykff95X0AgPOd
	IQ8rAc+JDw/TAjKKxn1F5LzM3ArlT09Onbb+7Qj8Fvi1/Wz+Cx9hy5FSwBJQ4qrBditd8kRsFy5
	CQWmX6eUO3q8vb8+u4rXP+5++YmDdw9EmvHpJrZeDU8MwWtyI34k4iYW8XuMVV4G6s9LawIGyqD
	w8iCr+Tjlpfyx+lF/injbbMXDBnXhbUpDplZNhw+OKdzbbFRxuohi8SAA=
X-Google-Smtp-Source: AGHT+IF+adSlhp7zDJmm2A5yYOEU8SOORDatD26qz6M1m2iFgXS5k7ij7O/H0tkK9p9BEbICVXUoFAXr3q9vRCbvwQ==
X-Received: from pjbsb11.prod.google.com ([2002:a17:90b:50cb:b0:2fc:13d6:b4cb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a86:b0:305:5f28:2d5c with SMTP id 98e67ed59e1d1-30e2e5d6aa8mr8073892a91.15.1747266181709;
 Wed, 14 May 2025 16:43:01 -0700 (PDT)
Date: Wed, 14 May 2025 16:41:42 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <65afac3b13851c442c72652904db6d5755299615.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 03/51] KVM: selftests: Update guest_memfd_test for
 INIT_PRIVATE flag
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

Test that GUEST_MEMFD_FLAG_INIT_PRIVATE is only valid when
GUEST_MEMFD_FLAG_SUPPORT_SHARED is set.

Change-Id: I506e236a232047cfaee17bcaed02ee14c8d25bbb
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 36 ++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 60aaba5808a5..bf2876cbd711 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -401,13 +401,31 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
 	kvm_vm_release(vm);
 }
 
+static void test_vm_with_gmem_flag(struct kvm_vm *vm, uint64_t flag,
+				   bool expect_valid)
+{
+	size_t page_size = getpagesize();
+	int fd;
+
+	fd = __vm_create_guest_memfd(vm, page_size, flag);
+
+	if (expect_valid) {
+		TEST_ASSERT(fd > 0,
+			    "guest_memfd() with flag '0x%lx' should be valid",
+			    flag);
+		close(fd);
+	} else {
+		TEST_ASSERT(fd == -1 && errno == EINVAL,
+			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
+			    flag);
+	}
+}
+
 static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
 					    uint64_t expected_valid_flags)
 {
-	size_t page_size = getpagesize();
 	struct kvm_vm *vm;
 	uint64_t flag = 0;
-	int fd;
 
 	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type)))
 		return;
@@ -415,17 +433,11 @@ static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
 	vm = vm_create_barebones_type(vm_type);
 
 	for (flag = BIT(0); flag; flag <<= 1) {
-		fd = __vm_create_guest_memfd(vm, page_size, flag);
+		test_vm_with_gmem_flag(vm, flag, flag & expected_valid_flags);
 
-		if (flag & expected_valid_flags) {
-			TEST_ASSERT(fd > 0,
-				    "guest_memfd() with flag '0x%lx' should be valid",
-				    flag);
-			close(fd);
-		} else {
-			TEST_ASSERT(fd == -1 && errno == EINVAL,
-				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
-				    flag);
+		if (flag == GUEST_MEMFD_FLAG_SUPPORT_SHARED) {
+			test_vm_with_gmem_flag(
+				vm, flag | GUEST_MEMFD_FLAG_INIT_PRIVATE, true);
 		}
 	}
 
-- 
2.49.0.1045.g170613ef41-goog



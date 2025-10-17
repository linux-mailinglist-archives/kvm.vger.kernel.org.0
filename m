Return-Path: <kvm+bounces-60378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD25BEB8AE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4D60189B9FE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8F63446BD;
	Fri, 17 Oct 2025 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YUrfYpR2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10EB33FE2F
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760731983; cv=none; b=C07hdXX9+9bC6CKMBVfzO6OT2Ne/yglZmSa1NdEy3kDtb3CXyA21oFJXPyE6KMfrymS3Mbq0mmaFS3QHPDW8FM2KSnMAVg48RqQcRpH9AVM8z4eOY2+tvn+MXLc57FixVkh+uNBFHuACbkR8z93Q5ddSzr6Xmkl5QZqOvciIxow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760731983; c=relaxed/simple;
	bh=pi5VSKfhBzaK0pja1AboLbydPX5/8PXDX0PMb0d86Ys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=etXvrjEqsbPwb8GBWND+VFyjis5y6+FycPhm5tt4CHGRw2qZldIB+jX6pCoi9mSsg511PM9aN/ZmuvelLeEFARUYxwZq7oRkMah/9Q0Qq351d5Yo8lb3iQxXz+zFmBYBila5Ie/o1I4GzwK48j8gOk9a6fpQlMawYM8359NVsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YUrfYpR2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27356178876so16886305ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731977; x=1761336777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
        b=YUrfYpR28q2og2vHBJ/6LmUYqRPznaJwmQDvvL/Q8pIjUblukhJWYwBbxCqdK+x7Fw
         W4M5b7c/+8prByWNCwRsvOP8v4dehJL5vmlGTOXBJorrSOE+8IL8axwYIOrHZoBWeSRJ
         Edl253qzPcrQCf/hxhlrG2ASd7hmUAuMvTSEjCWAqsAR6G2aD1ImNovainf0AtAiamZM
         zAtR9Eqm4VHfP973d5ghGT/y/qq6SCOvzwAXt3z9obYuvum0Qk4y9HY6e3Fu+q+88jT6
         g8kDkNeBTXBa3zkFzEFk7eSSxZA62p0CzBvPFJ/zgawgbJOR66qrnpyIrjGYDyY2KhML
         aeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731977; x=1761336777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBN6AwEHXD/aiISNDR8pg8faV6ZyO7L8ox+VpVWfPhQ=;
        b=Ex2RutUoFEBCXcNyXQGfUduZxVNAre0LWgCIfRa9p6kbTNQ1RHwHZgu09i9pIGUbCk
         ltSXrYgf1rrDYXzRdR2W9dRq9ZVQCFnwDMtWgIgQMKRB5f3AqItV2jvtmujBzNCe+6Bk
         jitMDsLHxK8T7JIKEbjNgFT0bopRjHyFgD9nSDOGKjU8Z6XT20RifIHEamH9Z79xgihv
         2+RUNlFIvqOy9wyMCqRPpqVHAgXFw9vmIYFbqPNCiBusXTuP33tzL4AtbPeWSZbXM3fX
         R6dKQUO4B+WaA+bOEzXzZEnH3+nDVDauPDlb+BN4vRq6HP4pYKydeBkSrkiT91Ro2XBd
         epDg==
X-Forwarded-Encrypted: i=1; AJvYcCXVFJaEicM8l/4o4NmKdlpwkXmgM+0g8smGKWsPTkfAwLdvKkAM7FHqx9XmrMAYAWl1kKI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6UkS4mex9ADROi3zqDEJcrML9wV5lTxeyDWISGZ/dCN+5nTM8
	C7onbRC2UIIZ7LxC5/VorqzWSHawVrSXTslTIUZ1AAO3vpuY4S/CR9IMWsM6wQmyeBQ6eP7bJXv
	ShSrVxqyBgLMy1WSEZShoGFVQRg==
X-Google-Smtp-Source: AGHT+IGqSqDsWsx806j5fx5Gr2lF7zksRxZnbRglNYfztC6ik3n9V25acElVgVa649/iudD/hPxzJ8Jc0ivuaCEvLQ==
X-Received: from plbbf3.prod.google.com ([2002:a17:902:b903:b0:269:9358:ea3f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e944:b0:290:b14c:4f36 with SMTP id d9443c01a7336-290cba4edaemr54722075ad.31.1760731977088;
 Fri, 17 Oct 2025 13:12:57 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:58 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <8fbb93e2ffc8e4bd42f931d460a26ef9392afe4c.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 17/37] KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Update KVM selftest framework to use KVM_SET_MEMORY_ATTRIBUTES2 and the
accompanying struct kvm_memory_attributes2.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index de8ae9be19067..019ffcec4510f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -394,24 +394,30 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+#define TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2()				\
+	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_MEMORY_ATTRIBUTES2),		\
+		       "KVM selftests now require KVM_SET_MEMORY_ATTRIBUTES2")
+
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
-	struct kvm_memory_attributes attr = {
+	struct kvm_memory_attributes2 attr = {
 		.attributes = attributes,
 		.address = gpa,
 		.size = size,
 		.flags = 0,
 	};
 
+	TEST_REQUIRE_SET_MEMORY_ATTRIBUTES2();
+
 	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
+	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
 	 * need significant enhancements to support multiple attributes.
 	 */
 	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
 		    "Update me to support multiple attributes!");
 
-	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
 
-- 
2.51.0.858.gf9c4a03a3a-goog



Return-Path: <kvm+bounces-60396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6BCBEBA04
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF549742CF3
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4AE338B46;
	Fri, 17 Oct 2025 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WA1qRovC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BBD33890F
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760732022; cv=none; b=V/88yytE8dk3pz09dUA7U6o/fhX59DmEgQNXIFpcB/4DNHmyZ5IXHoG1ou6F2bpnJCC4Of3UC3/H9OWOFBPip3o7LxNfr/4qTvHivft9ksH+5dsSbEZnzv1kVozNtbwdkeeYjxsGZ3WWqZ3iD/kDFUsQ523/21fXw/kcOaw3lFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760732022; c=relaxed/simple;
	bh=2DMaKOK2VXBsbJz3JTwxWGUFGZP6PnidI4mpyVFTIRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rwoy2YTeoxDT8OBOiumvXuEBaXCllLo+s7XPp32ACJvCX4xA4nRHr1P8ACggm5OczvoBevX9XiUaRrl891NHcx/E7G7VjzpNSufagMJyuo+IM+BAE6NTtPNR5oX8ALBPGNqpoEEdkcNCNfe7PFo7Leg4lJsdtsFigH2sXn3KUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WA1qRovC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57c2371182so2092726a12.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732009; x=1761336809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dmdP6R9nC9lX1jXEEElpeV73O9FQiFshjkk2aEtJ9fU=;
        b=WA1qRovCNHN2ZAT/8sz67z19z/LJuOECnGMWDiVMA/B331sLklnw5e6ERhoA/gbAtR
         QEG4dm2N5hooHB4GPOUI4GVHoirFlh5pDTIdEKlOwVbHCZaK0NfeE0nVcg2e4MhEJ3Yk
         P++bjQS3wAmLrjhhkrRGEkvYMjkpsdtGoDbrzEpEORpXZHluqOfBZnBBsqmooepxS1sE
         MGkqwVjiPjKM5V0kqygfCi+zsJFR+FBd08sTslPUcTG/Tl0VD45h8KcMG4VwiLRip/X5
         5HSgDtcMqNf0jYzW9WAGJOFdPpYeLQY9z9GWpe5rwLk2Zfha+KwskAk4sNwi9xYosCDI
         sH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732009; x=1761336809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmdP6R9nC9lX1jXEEElpeV73O9FQiFshjkk2aEtJ9fU=;
        b=YcD+/bvh182RUHltAnWpwPrBxBgd2MA6gu+T1Xi7+4f43i5rdGXKlnXgyEdfTgtTtT
         hZuRKPSvtpHlIH703EcVypND6WBa5hvNEmWM708Et3CX+sF8I+72gw2QCThIttOdPbhx
         5mOiNkzjfkE0a1KGScj1EPAbDG1hDLCdr+Ra8NU00odujvlxAVzWaj8PhJVUlaea0PJi
         Vb7uxMeOvAO21AdX3o/nBKR7YOW2T8wjBCpyiGvCpCGb8mxQvMMW9P0hFBuaRrZ5Iaaq
         mZ5lNoZ9FHthSN6G9RE7d0fXfXcPRYKRm4dIY5GTlVXtz+SeOrloGhhoyZcI9m39T71l
         GLaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpSB2JcH+9txEhnAxU/UyrGOa0jXDW7iYXHJ+HOl8Ztol6HNwVvoKp2zq9ONjEa8VzC5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ao3YR2Br9NI/Os0YNX+Rzf/bB5pz5tN8thXDyPDEdv5iFj62
	gW6K4YaQjzlCSU3eSRvwnP2F4qckUK7Mv8WspUNuqoRUnAsArNcxBidOpqIfANEkIURhVAjfm75
	c2ZkzWjOLwgswvZsChDTIZRxNCQ==
X-Google-Smtp-Source: AGHT+IGzgAEN2nLVpJn47Rpink95697ahn9+YSd6/QfacQuWgps1G1sah8dROQQkq3FQWO7kCJad1FtwMfse5d5QhQ==
X-Received: from pjbsr14.prod.google.com ([2002:a17:90b:4e8e:b0:33b:8b81:9086])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52d0:b0:33b:bed8:891e with SMTP id 98e67ed59e1d1-33bcf8fa427mr6248763a91.19.1760732009057;
 Fri, 17 Oct 2025 13:13:29 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:17 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <ab7645218a87a45b0f3214a07138d3c8eadd3164.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 36/37] KVM: selftests: Update pre-fault test to work
 with per-guest_memfd attributes
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

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the pre-fault memory test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/pre_fault_memory_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 6db75946a4f89..6bb5e52f6d948 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -188,7 +188,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 				    private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
-	if (private)
+	if (!kvm_has_gmem_attributes && private)
 		vm_mem_set_private(vm, gpa, TEST_SIZE);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
-- 
2.51.0.858.gf9c4a03a3a-goog



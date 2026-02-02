Return-Path: <kvm+bounces-69932-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DB8M2gpgWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69932-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:47:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD74D26CC
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B7F43067A23
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDED38F93A;
	Mon,  2 Feb 2026 22:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kEJ7qLtn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DC3921EE
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071452; cv=none; b=K2mWvrr+AoeWE68XlbZfiLp389cVrFeBS+tGrQBxq7LFYLLb3zn7eq3T+pgV9Ay5mOg1T9dAPb3oN+hRH/MSzprgaV9OLf/sSF2SaDV1ghcuF7VAnkBVejeMqWArjM+DK9Abd6Bl4vlhXhfaOOvrMdiiH7AqvSztmRvqobKjbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071452; c=relaxed/simple;
	bh=BOuDl5FNJBY78R3/sjP1Z8mI8xgIety+sC9BdjeSYJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uFphlNwfsSAV0sBgZ/AvdqP9vBG7WV7o6Urizf2lN28dRVeW7Pjd5Y+HmxWUEooSJSTQciXYT8Na9euufNE7VeUbyF25Cyc/B+g2/+hf6vATkGAN6g5p8NYxRa5h6UcXNHh0U2QnjFKlb3luCjQKGVlzXE0v17hSuYVmb36rQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kEJ7qLtn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso216837a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071450; x=1770676250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jVz8/vXYYvlyUGSqOW3ETp8FRnG4u38fEDm5kewK59s=;
        b=kEJ7qLtneBDaaD2aHAJ0fLEy+gDo6dP25vK3BfiW8MCDNecQEoNNAkLTl/k8QsYtiB
         4PK6k1+LYlOq3NtR8kdePXTAwCDpl+GsMpJBnaSYMBn/L4LsKG+vTGvdanLc+A8od3IR
         LpsAJInIcvFvIb1Pit+RQNv9pO+el9JSeY7zWC2VIuIN1GdpCXRFt/ulMgYFOdk2bO4B
         IZQYKs0NH7kWiF+VCCnVWtKY1B7M8o2G1AWHULl4Wr0lJr1NQ6NI2XtKMo9mU6ZyaFzH
         X7swscfxcx+f+ekd/WDxyn3sg1/Q0qBl1JbI+hASQ2Atpp6gcRg6RnAVgXQpxuyb2or2
         NiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071450; x=1770676250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVz8/vXYYvlyUGSqOW3ETp8FRnG4u38fEDm5kewK59s=;
        b=pMt5bhKVkHAgK0DCKZ2fnYtUuSaH5dA+CQZHxwdw9whvXL1+zWSI45BJMYwS/wm/AE
         JbhACb1zFdsJggE9xScK/HHMU3APR1x9rILg0znKR+M+SA5olaSR8ER+WAGnF0mso2Ak
         77nj53FXzVxjaKNkhoDFGYeKDhyZaV46Wo+EBMq0MuTSbbEdz7hBQWd7/HojJmtayHdS
         PxOz49SxHnxjNeBWmgbmrFBlEakcTjC1wc8OEwnJt96VqpAfOYsRTrhAWCj+OajR0rby
         H4fP0qdbr+eO6WTQFawFGfemE0gxkkqtalXYFAA9OwYWI9vP32f6oHxOTwK+7+1w1Nu0
         WipQ==
X-Gm-Message-State: AOJu0YxMELojHaXGJCrOWLH/L30h6Zvb9LwIpxuqD6RHyVsuBm1gIhBH
	E/43EXcYUGJEygifW0aQUdLLxuW+w4kHG4zhF9VeS/auxO5NyKXZmqrOhBt82Uf1MutAHfAEX3G
	Kp/LLYwLjke2ehUH+Up34gDrvRIReF1pRUl9mpcWQkHW4Nn2vVQzUz13TvdwpMtCdfxR3ckmz6u
	whbfiCtJnuEzZHq7VM9g4nUQw9GYR9dahzyNcWBsMY26F8cHDB3rZnr02RGC8=
X-Received: from pjtw2.prod.google.com ([2002:a17:90a:c982:b0:352:925c:a29c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c3:b0:34c:2f01:2262 with SMTP id 98e67ed59e1d1-3547769019fmr617275a91.3.1770071450254;
 Mon, 02 Feb 2026 14:30:50 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:55 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <544fc9c8c519560d8622ca1def8dbc676baf2d73.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 17/37] KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69932-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4CD74D26CC
X-Rspamd-Action: no action

Update KVM selftest framework to use KVM_SET_MEMORY_ATTRIBUTES2 and the
accompanying struct kvm_memory_attributes2.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a64aae271a6a..872988197a5c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -397,7 +397,7 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
-	struct kvm_memory_attributes attr = {
+	struct kvm_memory_attributes2 attr = {
 		.attributes = attributes,
 		.address = gpa,
 		.size = size,
@@ -405,13 +405,16 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	};
 
 	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
+	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
 	 * need significant enhancements to support multiple attributes.
 	 */
 	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
 		    "Update me to support multiple attributes!");
 
-	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+	__TEST_REQUIRE(kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0,
+		       "No valid attributes for VM fd ioctl!");
+
+	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
 
-- 
2.53.0.rc1.225.gd81095ad13-goog



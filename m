Return-Path: <kvm+bounces-69947-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKSKEvwngWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69947-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:41:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB18AD2503
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7133F30C2C96
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20AD396D36;
	Mon,  2 Feb 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/KdC8Ue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9406D396D00
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071476; cv=none; b=nVduLnm8myXw3nqKStsKne3h/+DhVnAv/jwpVE/2uuSNI1I5ejkMOvVaR9WNa7G8Tp+yCDgepBBEPn5CrbnvNJ62+p9J9oze6l1OoYDTz7530OW1+32A7QayOgObdYQy3VY2boLvAoMb0PISWoDjKrQlQWrliSIKKPVKRcAAP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071476; c=relaxed/simple;
	bh=ee5l2ClDma6/YXnJfwgPUbzGPKbpN0773ap3sBlNofI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pg3xr51TGpnIk7Z0eaWes5CTdWO+9pO31ubTGbN+lIjZ96WadyPEinLCEF9yLnIj3surBSOyeChxwcFNP8iFq2QpfBUggxzr4vNiN0TrB+wEzXojGtt/Z87OfI9lJud2dx+yYnPsygSycQ5Xl0q4X8ipPEXgjHAsGr20wcurd8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/KdC8Ue; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so132401445ad.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071475; x=1770676275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=95UOeZXD/5+uUIhnBxiSZcIj9shW0bLjIz9vgTckCB4=;
        b=x/KdC8Uetp0HV6q0h5sOpSS77q8CYl97Rryup0yHlyb1yj6+8IMBysRcW+ajRHHDdf
         MP4O+uBIuB9i2a4prPgOl/QaE6jpO229gkrxyhNse3wFkilXCngmlDQW0hy3psZd60pm
         QDqIHWb7uEzyQl+NKnxUlkuYFDn4Rz2epsxnnIlD1jP24XL2RBCvyA5cpl3UIpiEB3rk
         fksmQ0wIL+1zzPBRVQPl+qWbFuE18bOmIfrf6e9Hav7zDvMu51lwufzjlYF8S9l5I52j
         h4157d1D00SIbbeIYsY1lJ6FxUavY6N1w+FKZ8dUvM7kQ+8GinSjejv0FuW9bx4hY/Wy
         tatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071475; x=1770676275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=95UOeZXD/5+uUIhnBxiSZcIj9shW0bLjIz9vgTckCB4=;
        b=ewfiJu97hpVBWEVlKPiIm3uzciKNSdP1mvTq1g0iO09sPqoW7PJWtWYus0X9alrLfg
         b/g5UrTzVjvzyVsrn/ecWynAofApndXLxAqLcdR8itZ5Ni9c1LHkHyOqCqa2QTT8vAsb
         f1y+bmD5isZDc++eHp0px/sAdkHeEcdafGUoewVGkVXRmHJB4bFGFnpsRjNE43qWRqgd
         4ZDYyMl/5wOAUATgZwA6apFI4IsLnQfsotOeWgn3wNbNmZGY/wjan04F/6JuaK+v7Gg/
         7QkGAiOrI/Va4qLoJmPZsEHwYyDjDlTQF46T5O6CECjHc/9qOPlAvo4CX9Dg9V3nmCl/
         L2jA==
X-Gm-Message-State: AOJu0YyaRVM7Myb9+yz9ygKbshScdavtdJ4rdeIgfgva2ppjWKYU30Vx
	cp4OyCVHEoOPk1kEa8Ad2zS+0F9Nj0DamGiirJOlvf0AOShSO0f+ZALy7oC+jWZ15Go2uxuw5US
	NUT1+tkffJ37lYlrrNd7V+NF7rte5oYQJtaRNwuxOcEDnHNMqNMDNxsD4b75Kv7khXZlIbvTUi6
	V0e8E7oTi/UugS3jUCpWmXhm1VTQPd+CVN8X+tWWldcMfcknTkoH9PSZ3fQIU=
X-Received: from plgc7.prod.google.com ([2002:a17:902:d487:b0:2a7:6887:341c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2306:b0:2a2:f1d4:3b64 with SMTP id d9443c01a7336-2a8d96a9095mr144868535ad.21.1770071474531;
 Mon, 02 Feb 2026 14:31:14 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:10 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <952780cd94193f935e9e96c848f16f5773a22d78.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 32/37] KVM: selftests: Check fd/flags provided to
 mmap() when setting up memslot
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69947-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB18AD2503
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.

With an invalid fd (usually used for anonymous mappings), there are no
constraints on mmap() flags.

Add this check to make sure that when a guest_memfd is used as region->fd,
the flag provided to mmap() will include MAP_SHARED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rephrase assertion message.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 61adfd7e623c..aec7b24418ab 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1062,6 +1062,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 	}
 
+	TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
+		    "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
+
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					vm_mem_backing_src_alias(src_type)->flag,
 					region->fd, mmap_offset);
-- 
2.53.0.rc1.225.gd81095ad13-goog



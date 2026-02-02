Return-Path: <kvm+bounces-69918-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ED9lLZclgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69918-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:30:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65298D229E
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 538933008C13
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030703815EF;
	Mon,  2 Feb 2026 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DY7MTWU6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01883557E9
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071430; cv=none; b=EbmQHcpOvlxmLxSbz97RluzAtGIopiak3m2za32gc0Zbl9KF4YrbSQRwZef6PYoBoKANCsNiodfBQqEU0ddYogXPJD2xf4dpc75C6SPfFQZseVlgJ/4Q0eXPGPylMO1Th/L5LRqLJzjn8rpmplawysgQzGqJQ0d0qTCsoN3y99k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071430; c=relaxed/simple;
	bh=WorvCjpgns2C+Ce5/F3Rb80WYbvrDTVDudVlO0Kxxhs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YjO+nkELyWyUIPNBFbLeMi5yXjMg0Xzol49Lf5yDrby9ictyAAmVQaoFQ71zX4jxK1WBN28qNWN9xMkMkPseCzOInlgtOJLKhzbjHXEc9qHm6ub36BkyuRPBaLItQD3qWi0gmutFMdakSFW3szpuLf2+pXrgpLUyLn0TToyxDxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DY7MTWU6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6133262e4eso3045276a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071428; x=1770676228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XrHR5u0tXK8+IxgO/pbPsCcUw6Jina1DaW7jGvD7ugE=;
        b=DY7MTWU6XVikzfxbgksUGTVt/YBXTiG/1xqy3Ne/CAvUkTNoR3lTL3yu3g7zxq+q/+
         cogpxJLMhcE2Q65gpobBA7kMa3xBn/nFQjAwTUOnO32Dg11JSHO6ctq9284KKGxJ0AMC
         EG0pc1obKaSm55Cuyxl4eags+tmvsZWq2swL59sKS8F4TJuQUVetltVkp30uVgvP3p5C
         QGIcp2HjTT9VbS6eoOFpJPMDR4lfQCgGoJNK2TvuQjyzndaNb5driggYUQPHAxakID1o
         Y58BZNz/fhOnmMae4F3i6A0kVlMDiaGAZvIlO9712Xdtl8bH00XzNnKVhlf0RyrgmmXM
         SZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071428; x=1770676228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrHR5u0tXK8+IxgO/pbPsCcUw6Jina1DaW7jGvD7ugE=;
        b=wVRkMRpxjU+9ck1uEDz4wc3bQAhcRdmSviwWoA2ddkZrnQdIhmqtRrpQA2CqxM0zN2
         CroKY+qGOgN0XkfFv4bqBV5PG8Rlm6xTZgJjRggsbFqPd0VjIpDAsadZgoedrIcTB90e
         0tKramVILf1IvTb8mZt7FAxb+V+VlCvgnBvxW9pru9m1xi+FYieie0tN8FOkGwS3Yrt2
         MbKLJG0GhubgD2ZXR/Gkr6yQ/wwRWGRaFV5eM7wledvrSuO2BbKNjr0i5SDm6htzPTra
         55Yo3ORO0liC4tm0F4TOd4+550harj8q2sZyuz4eHemJ3heQSWaRov1fPordUziAwdKN
         gxXg==
X-Gm-Message-State: AOJu0YxEXSKIez3Yz+KgcM/UMHms8/zw9QvmAGnH6eSBiowswEKHzrHS
	qBJBQ42ehwnUHZyNY6sJYD45OavdJXR7SGyi7eqDYwdoB3ykH6y6lvgWA7zid4F90+za3PTiNj/
	LLZ5YztoJAoXWWGY2J4z4Mk46d1swgFt5R/NGfMY8YBn9Ad8skZbAb4snQgnFftU9r8WqLQ5CLx
	soCP+Ernl2KK5TsnVOqlNQyOTf+SGgaWLiwxWOHgX02pu2A0VvwDbcTS1eY70=
X-Received: from pjon10.prod.google.com ([2002:a17:90a:928a:b0:34c:dd6d:b10e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dc1:b0:32e:5646:d448 with SMTP id 98e67ed59e1d1-3543b3d4a49mr10688959a91.21.1770071427601;
 Mon, 02 Feb 2026 14:30:27 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:41 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <490841ae4dac3292d74f2250867f90cd5d16b29f.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 03/37] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69918-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 65298D229E
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expected to
use per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 66a5e05bb5b7..af2fcfff7692 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -721,7 +721,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 11c34311b0ac..26e0d532ba03 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2444,8 +2444,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog



Return-Path: <kvm+bounces-26310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B7C3973D4E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4A0A1C24F53
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DE61A4B7F;
	Tue, 10 Sep 2024 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="O5pyT0+p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F831A42DB;
	Tue, 10 Sep 2024 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985894; cv=none; b=u28r33VW3SXZqNxR/Hr5/ZbhmRyvQNjLZVW/2ZcbcvugUAYHSK1l8LN/TjFTpDFMgjFhV0yglwh3p5JM8JnQmLkI8IUvAKvYTde8XidZWV2vj1sWTjHYvJ+P5pNdWk7LXs6wVcFh/yfa2P5FHKSOBqFaJ80li3JaJSR8Ps40RrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985894; c=relaxed/simple;
	bh=BGx1rC1njIBlKD9diD98c69YvRK0p/zTsudpQQw1hYI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbyHG4ZdZ+iikA0GJU+15jb48scK9FxHChUwhZ2VqRKFpQ6eTQFgCxtqTvI7KTxVuUffM2I9Cf9B3hZv26cGnCgyBYn2K+QeHWBR2gmoUw7vsUQ1kjK/16bF+XTtiuqrayFyDNdq/yRon8/TsvKSmYCLW7euxptR1jwJRdqDlts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=O5pyT0+p; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985892; x=1757521892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mg6x7TwXBxF2qrgNjQW5TE5s/jw6SkTYEEB7LumyV7k=;
  b=O5pyT0+pbzl00PxxshCYQOm2J5DYsVr267+2ehBgluZBP6rjP0a5BwGp
   DJXQgd2h+ullHm4LJNlWsEq4L80ggZMYviTwbF5iosTKTe3SPg/IFtE78
   RgKr+cKoaMLLELIqUuvYfvb6f9hPmKM9+P2TjjaUZCUDuDT3YSKffSee8
   Y=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="124249487"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:20 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.29.78:64554]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.48.28:2525] with esmtp (Farcaster)
 id c989717d-c1d0-4610-a59c-ea42657013e3; Tue, 10 Sep 2024 16:31:19 +0000 (UTC)
X-Farcaster-Flow-ID: c989717d-c1d0-4610-a59c-ea42657013e3
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:09 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:08 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:04 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 04/10] kvm: Allow reading/writing gmem using kvm_{read,write}_guest
Date: Tue, 10 Sep 2024 17:30:30 +0100
Message-ID: <20240910163038.1298452-5-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

If KVM can access guest_memfd memory (or at least convert it into a
state in which KVM can access it) without causing a host-kernel panic
(e.g. currently only if the vm type is KVM_X86_SW_PROTECTED_VM), allow
`kvm_{read,write}_guest` to access gfns that are backed by gmem.  If KVM
cannot access guest_memfd memory (say, because it is running a TDX VM),
prepare a KVM_EXIT_MEMORY_FAULT (if possible) and return -EFAULT.

KVM can only prepare the memory fault exit inside the
`kvm_vcpu_{read,write}_guest` variant, as it needs a vcpu reference to
assign the exit reason to.

KVM accesses to gmem are done via the direct map (as no userspace
mappings exist, and even if they existed, they wouldn't be reflected
into the memslots). If `KVM_GMEM_NO_DIRECT_MAP` is set, then temporarily
reinsert the accessed folio into the direct map. Hold the folio lock for
the entire duration of the access to prevent concurrent direct map
modifications from taking place (as these might remove the direct map
entry while kvm_{read,write}_guest is using it, which would result in a
panic).

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc0..13347fb03d4a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3286,11 +3286,51 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	return 0;
 }
 
+static int __kvm_read_guest_private_page(struct kvm *kvm,
+					 struct kvm_memory_slot *memslot, gfn_t gfn,
+					 void *data, int offset, int len)
+{
+	kvm_pfn_t pfn;
+	int r;
+	struct folio *folio;
+
+	r = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL,
+			     KVM_GMEM_GET_PFN_SHARED | KVM_GMEM_GET_PFN_LOCKED);
+
+	if (r < 0)
+		return r;
+
+	folio = pfn_folio(pfn);
+	memcpy(data, folio_address(folio) + offset, len);
+	r =  kvm_gmem_put_shared_pfn(pfn);
+	folio_unlock(folio);
+	folio_put(folio);
+	return r;
+}
+
+static int __kvm_vcpu_read_guest_private_page(struct kvm_vcpu *vcpu,
+					       struct kvm_memory_slot *memslot, gfn_t gfn,
+					       void *data, int offset, int len)
+{
+	int r = __kvm_read_guest_private_page(vcpu->kvm, memslot, gfn, data, offset, len);
+
+	/* kvm not allowed to access gmem */
+	if (r == -EPERM) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn + offset, len, false,
+					      false, true);
+		return -EFAULT;
+	}
+
+	return r;
+}
+
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
+	if (kvm_mem_is_private(kvm, gfn))
+		return __kvm_read_guest_private_page(kvm, slot, gfn, data, offset, len);
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
@@ -3300,6 +3340,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
+	if (kvm_mem_is_private(vcpu->kvm, gfn))
+		return __kvm_vcpu_read_guest_private_page(vcpu, slot, gfn, data, offset, len);
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
@@ -3390,11 +3432,50 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	return 0;
 }
 
+static int __kvm_write_guest_private_page(struct kvm *kvm,
+					  struct kvm_memory_slot *memslot, gfn_t gfn,
+					  const void *data, int offset, int len)
+{
+	kvm_pfn_t pfn;
+	int r;
+	struct folio *folio;
+
+	r = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL,
+			     KVM_GMEM_GET_PFN_SHARED | KVM_GMEM_GET_PFN_LOCKED);
+
+	if (r < 0)
+		return r;
+
+	folio = pfn_folio(pfn);
+	memcpy(folio_address(folio) + offset, data, len);
+	r =  kvm_gmem_put_shared_pfn(pfn);
+	folio_unlock(folio);
+	folio_put(folio);
+	return r;
+}
+
+static int __kvm_vcpu_write_guest_private_page(struct kvm_vcpu *vcpu,
+					       struct kvm_memory_slot *memslot, gfn_t gfn,
+					       const void *data, int offset, int len)
+{
+	int r = __kvm_write_guest_private_page(vcpu->kvm, memslot, gfn, data, offset, len);
+
+	if (r == -EPERM) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn + offset, len, true,
+					      false, true);
+		return -EFAULT;
+	}
+
+	return r;
+}
+
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 			 const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
+	if (kvm_mem_is_private(kvm, gfn))
+		return __kvm_write_guest_private_page(kvm, slot, gfn, data, offset, len);
 	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
@@ -3404,6 +3485,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
+	if (kvm_mem_is_private(vcpu->kvm, gfn))
+		return __kvm_vcpu_write_guest_private_page(vcpu, slot, gfn, data, offset, len);
 	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
-- 
2.46.0



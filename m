Return-Path: <kvm+bounces-21191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E761A92BADD
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38997B2720D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C1615F400;
	Tue,  9 Jul 2024 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="TZ2rp0jy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FE52D057;
	Tue,  9 Jul 2024 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531265; cv=none; b=kH7p9wLePVE23Nm44VPoMBanTeyLM3e8VSaE+wGuCQeJjW9iU/KKyIuaPavsqJlyNwCngcfK09Dr9fQpEgUfi1uz390euNFNIq7fyKh4iPWjn0NboSWtDwv64lXYTJBJqnjrHkq9GZH+qHim8TP9jwnW04xoi8HW3HYnxOvSHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531265; c=relaxed/simple;
	bh=ofrjlTwjZutvnSbSpWjUvPgpAsV5ivDbnT/GrlE1wMY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkmqlE8QpfHF4pEb3+CGAiyVYYbRcHrlmcr8uefNzVetnfDx7cSeFjNECeE7mzYh41fAEYG5cUdxMPkFvc1OLUrQ6iPyBymLxXn/UbCR39J3fD2MxQf0oeRj2rO11dB8rN1gIjTm5+ocR6zOH8ow8pHvvEHm0B+h8997wvGR25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=TZ2rp0jy; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531263; x=1752067263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/DNQp/z0GUBgLTV7ZRmRKhZQi2WgjcFO0AlHckf358s=;
  b=TZ2rp0jyaEv7Fhw6699bQXwux3wtJpG9Ssn2sELoX9EhPTOGaUA/JUD3
   caz1/WE64tFFZNYZe8FbYXcGHpdTvzTaIoQsJmsFRTsG9MWaEMZqzfGIN
   GSY83QZ0NuFXcSLBCSbLQFeLTknfc0eNObqnoVf7eINj3RR0XPFTTL6/6
   8=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="644664049"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:21:01 +0000
Received: from EX19MTAUEA002.ant.amazon.com [10.0.0.204:55215]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.85:2525] with esmtp (Farcaster)
 id cb50a819-87b3-4fab-a17a-29e4e0b8d5a4; Tue, 9 Jul 2024 13:21:00 +0000 (UTC)
X-Farcaster-Flow-ID: cb50a819-87b3-4fab-a17a-29e4e0b8d5a4
Received: from EX19D008UEC001.ant.amazon.com (10.252.135.232) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:00 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEC001.ant.amazon.com (10.252.135.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:00 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:20:57 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 2/8] kvm: use slowpath in gfn_to_hva_cache if memory is private
Date: Tue, 9 Jul 2024 14:20:30 +0100
Message-ID: <20240709132041.3625501-3-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709132041.3625501-1-roypat@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Currently, KVM uses gfn_to_hva_caches to cache gfn->memslot->userspace
host virtual address (uhva) translations. If a gfn is backed by
guest_memfd however, there is no uhva-equivalent item we could possible
cache, since accesses go through a file descriptor instead of a VMA.
Thus, we effectively disable gfn_to_hva_caches in the case where gfns
are gmem-backed, and instead do a gfn->pfn translation on the fly by
calling `kvm_{read,write}_guest` inside `kvm_{read,write}_guest_cached`.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b3b3de70a4df..4357f7cdf040 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3603,7 +3603,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
-	if (unlikely(!ghc->memslot))
+	if (unlikely(!ghc->memslot || kvm_mem_is_private(kvm, gpa_to_gfn(gpa))))
 		return kvm_write_guest(kvm, gpa, data, len);
 
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
@@ -3641,7 +3641,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
-	if (unlikely(!ghc->memslot))
+	if (unlikely(!ghc->memslot || kvm_mem_is_private(kvm, gpa_to_gfn(gpa))))
 		return kvm_read_guest(kvm, gpa, data, len);
 
 	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
-- 
2.45.2



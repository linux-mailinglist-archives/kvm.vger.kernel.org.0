Return-Path: <kvm+bounces-60369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6D5BEB814
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7139D1892181
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC5636CE12;
	Fri, 17 Oct 2025 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vCirA5dF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2133B962
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760731967; cv=none; b=ZmDf3EbnB3V+WVAyd1PJ8f2T1jdUFS3D+JUUVDm0maet/4r82vqaWLq4wAUk2BGEmGaPDjUUp7dZprNzubhriae+9Jf/hrDPYeT69VNzSR1bUoKlUnPSIU9pxrhtwJ+fXodX1cHPsZik6UQCwA1Ccw+2LKEQIuuwj7c6ngxeJqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760731967; c=relaxed/simple;
	bh=PrT4ou7XQfgOKQRqWqv9C6n4BMphf05VQOlhpJXtJ9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ryZNB5Sub3+asnShKxF2TSPmCjC3lImHpBExtXw5Y12PiwWiq2rv8byvS2ZsDJlQU/2xvgYupDNXY6pZYCDtt9b5biWjxd9zrLtpSbej5yumMWQQqc4BXaI7sLBwR+rAGyrp6m07Cjz4Dl9QPSGqN1sHf1/pQsuTJ9dvacmqPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vCirA5dF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb779733so1622312a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731962; x=1761336762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4k+wUXHe9yzfzIaac4y4gtWpxK47yZCE3hgs7ubdV9A=;
        b=vCirA5dFHQOlUFq8tqxQYA3tNiztzrjGCwf+nTYzGw8Q4M0+tRKSFA59dPO2MVCs+4
         iYSF51zh8r5UPmbw/bSYVgCy4W/v0So7JfKq7rzJWb4d0SoVIm9wpwGNIMwvMh8p/FyR
         QCTWAFIhq1W59e9bSjh/dhOxNkF/hgARQSHVPTaYKqbAIoS8MhjRZqpZ0YuErAVnuHve
         W1xwEO3h0GnDU2q8WylRtebxY71rxNkZXeQw7mg3WPGdvbww0cNvCLKFNWe9dLnCgZ15
         esRNwlioMZsnIaccvROlXQQSL0qTr2dNkJaAPcgWzFMl7FeFBCkmhSa11WLuukK8uQU/
         T6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731962; x=1761336762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4k+wUXHe9yzfzIaac4y4gtWpxK47yZCE3hgs7ubdV9A=;
        b=govNRW5Gos//erMH5ebC9iNv0tODraGtoTF3WeHb4vBqwbVK0k0iw3FeI629Apa+ue
         t/n1pGSXwCFY+DUJKTsej03oUc55S+lXC2YlV7COwIH4zIpstl1H5g/FqtPm8rDG73KH
         rQ1wnplERLFoJn2YrhGGQd3gKw0H8ZAV90/E7yJrvMm33aQwyKjgn2j6DpFzxgGiA4l0
         lf079zyCSlRcr+m9674mpog1yg9zEo5kTatjz1PtvhIrDz3sEyqPkmKz3VV8exQ5XytZ
         V0Prk0vpmrOwOh+NupQolfAqGPXaXm00a8qy4fIAq50qMO49+3oSUoDht6sAyhjvP/Gb
         T5rg==
X-Forwarded-Encrypted: i=1; AJvYcCXr0nJKFiBufsLjwM5/eA6T89QhyEYYPJiex7VbB+E+1PDTgAHIieBDhNGAFIPkx1vnOM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwPeqGwOtCWBlsZQJwSBweVym+K1wPXIEoKujG0qp1upxNx1Ti
	Li/q21D5Wgo77Khu0q69DwrryBlhdsnV8e7eb0XruAQGI4d+K5d4bFE/XUegbnYRwu8MbOrVCNq
	Fv++PRCwpL0CeJbBcp6ZdpR2baw==
X-Google-Smtp-Source: AGHT+IGg5FDaopQnzU8E3MEM1vtMjI3mvE8ocZ5rZ8kLqVulK1tXCXVmLHJ4NfMXIzG1n1oaer7VJJObZU+ocU7zyg==
X-Received: from pjrv8.prod.google.com ([2002:a17:90a:bb88:b0:32e:b34b:92eb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48c8:b0:33b:ba55:f5dd with SMTP id 98e67ed59e1d1-33bcf93ab88mr4933500a91.37.1760731962171;
 Fri, 17 Oct 2025 13:12:42 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:49 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <dc5f58f5d3427b6291486a24061b6301761dda3d.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 08/37] KVM: guest_memfd: Don't set FGP_ACCESSED when
 getting folios
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

guest_memfd folios don't care about accessed flags since the memory is
unevictable and there is no storage to write back to, hence, cleanup the
allocation path by not setting FGP_ACCESSED.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 855e682041311..2a9e9220a48aa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -167,14 +167,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
-- 
2.51.0.858.gf9c4a03a3a-goog



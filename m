Return-Path: <kvm+bounces-46580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32817AB79D8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D81A3B717E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327072522B6;
	Wed, 14 May 2025 23:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X3aGCmoK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62742512D9
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266218; cv=none; b=e5qEZXikFlLjkrH/hGOYKsy/McwQLbGPitFzYZmDkS4b8eNg7ogfAfcEP8Xv+5+VQq3Yc+pPWnzSd1SmcQowvZavYz/bFhFxDZlTICQa/A/qc+PStwLK44kQt/1Fb4CXs1im/nSMd4P4b6H+OlPkUrDlZdUAySshJ4bmWudErs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266218; c=relaxed/simple;
	bh=P4f0b62NWOp+NPWKRTgUNNPji/5ERCLjnY9pODYzlUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a8/xDNzGxGPkwmzA9q9nNdZTa6nRs8Fv00i7WDA2Bbkb2syzxnzNdWVG9Xg9eN+M2WlnQRMYW91gavepIXbGVI6iwIZBOwfmEWSupAfl8gxaD/KESTw/vT/lPyZe/k1ynjErbTKy1+lHMqdsmFQh5dGk5AvsmpwfibKDeH0YqC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X3aGCmoK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c4b072631so348118a91.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266216; x=1747871016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7idB2ZTiegZ6IK12Tr/2nYezS5KZiJSYYU8LHDGXMQ=;
        b=X3aGCmoKl/t1PnndVwmh2h0I9wXGB88CzUqrLj9/ASoXDCLVAuD2OpqN1iOg+Jsyv0
         QqAixmStyQqLyikPurcbAqeYN2p+nhIzBSC7KXw+kpoMm1TcTHe5yafvYBUkNt4EL+AK
         L13oz6T3422l+WFwQ88asyW6y/NYNH/jiVcKiSFdeDaFdgAqhiIRHqpb6pPf1iQaQgn4
         q0EqoPZ8zhO9J1ytmo6lLQHfxC4LW0eRkQrD1PG0NC0A+dTbvdTOCU/72Me9kYWeyChO
         0nsuwIUf+tT5GhDYh7S8FP8mTmWkIydqtEZBpBeNkSQ2082dVwMtrLg1OQQnUKBo9BIU
         8utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266216; x=1747871016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7idB2ZTiegZ6IK12Tr/2nYezS5KZiJSYYU8LHDGXMQ=;
        b=hOW0SRWnGcg+XpPnSxLrBIYMrSZyAk2l7p0ODmX4BTNC5nma+U8AxbnPeKZICQVeI/
         rBmlFx446sFICOHBwLa6z/lrGl8S2yEf71GFn3rrF0pjFJaKgObSyUQeImfAzoJjssYw
         ukcq3EQVWhlD6XyLmKnVdjxaLwzehpjYbTFCk44rB/P1M4Vo2jFqr7TEx1KvzMkUJuG8
         7xYayVJAmIXgKXIsi/GYWL+55dbG/5I46EFedcXe1c4RMvDcMY9P74nm4ox5fqWRnFhS
         w2b4gJRaYZlieMDKBLXFCyLEcbCA2MT+Z3buoPGoiQDYGsvHLFKut21b1sExfa9In+8O
         jZ3w==
X-Gm-Message-State: AOJu0Yw/c83+WNFUq2XRrZwEFeGyAygzhmQQ8cgMVyAwsiwJpSrAEK1v
	fS+qBxX54y6Tpd/EYafbtybyItoMeALmAhVgvqkt+eXKWxY5JTdycvmmDo+rNkF+uWq3RI/EahS
	bUx7bBmlVQz/TL/N1CVMHqIrDCG48PtBLKq8cTRHgSd3K2580wZW1q/X4+gpKa6pNTU9Zup5efe
	8YX/a/+I7gVBIVt3LDhNP8hA9kWa6frYvkxMBurg3eGK4IWddyvhP1sls=
X-Google-Smtp-Source: AGHT+IE2emob7ne9xgmmOZ/2Nz4UUhKEr9sTG+LQ/jCh4mtM1mNcZXbWVXEVF+2dcFUaFpOL2yid3wyO7OHIppEddw==
X-Received: from pjbee7.prod.google.com ([2002:a17:90a:fc47:b0:2fa:1fac:269c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:55d0:b0:309:fac6:44f9 with SMTP id 98e67ed59e1d1-30e51947471mr583415a91.31.1747266215905;
 Wed, 14 May 2025 16:43:35 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:04 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <b01365820cca734c1c37de6709167d8c81afb295.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 25/51] mm: truncate: Expose preparation steps for truncate_inode_pages_final
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

This will allow preparation steps to be shared while implementing
truncation differently.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I83ad5965b8b50283ad930c20c99e3165cb5626c9
---
 include/linux/mm.h |  1 +
 mm/truncate.c      | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf55206935c4..e4e73c231ced 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3514,6 +3514,7 @@ extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
+extern void truncate_inode_pages_final_prepare(struct address_space *mapping);
 extern void truncate_inode_pages_final(struct address_space *);
 
 /* generic vm_area_ops exported for stackable file systems */
diff --git a/mm/truncate.c b/mm/truncate.c
index 5d98054094d1..057e4aa73aa9 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -457,16 +457,7 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-/**
- * truncate_inode_pages_final - truncate *all* pages before inode dies
- * @mapping: mapping to truncate
- *
- * Called under (and serialized by) inode->i_rwsem.
- *
- * Filesystems have to use this in the .evict_inode path to inform the
- * VM that this is the final truncate and the inode is going away.
- */
-void truncate_inode_pages_final(struct address_space *mapping)
+void truncate_inode_pages_final_prepare(struct address_space *mapping)
 {
 	/*
 	 * Page reclaim can not participate in regular inode lifetime
@@ -487,6 +478,21 @@ void truncate_inode_pages_final(struct address_space *mapping)
 		xa_lock_irq(&mapping->i_pages);
 		xa_unlock_irq(&mapping->i_pages);
 	}
+}
+EXPORT_SYMBOL(truncate_inode_pages_final_prepare);
+
+/**
+ * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * @mapping: mapping to truncate
+ *
+ * Called under (and serialized by) inode->i_rwsem.
+ *
+ * Filesystems have to use this in the .evict_inode path to inform the
+ * VM that this is the final truncate and the inode is going away.
+ */
+void truncate_inode_pages_final(struct address_space *mapping)
+{
+	truncate_inode_pages_final_prepare(mapping);
 
 	truncate_inode_pages(mapping, 0);
 }
-- 
2.49.0.1045.g170613ef41-goog



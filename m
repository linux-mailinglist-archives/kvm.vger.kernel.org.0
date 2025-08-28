Return-Path: <kvm+bounces-56057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8EA0B39876
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7856A167CFE
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27012EA170;
	Thu, 28 Aug 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="EQX9hwot"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E1283FD0;
	Thu, 28 Aug 2025 09:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.156.205.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373968; cv=none; b=kLMGW4xDSAqhwlc36GgB6CLezYSW2KaKbhEH5bIaUcqVGzv77dKxXZS6fBJ2iZ/fB6BTXPTnUlKDxVtJDNEuzBAzwreIh7xbnUi79qdSzWFccCQ3qlb0PAYBlg3scMJHV+vldzZqlExgqzsAmDTh9wFvXzHW7rdENkGM/cet1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373968; c=relaxed/simple;
	bh=FkmstGPos2cmw5BMnAKLlCRIAGH2LRWhyE9HIDVmtyM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ngeZyw0I3SuPuYm+Azwovl5MzqFhk0v949v1iw4gm6MX5xs84lt02/oNnl7uk4tngmWzrHfZVO/jTDAJewyNJAMBrLe80k5KLQM0i7U5thA2xXazQgSS7fdBXffb1p9pYvxUFD1sAxeeGzTGAKUkcErbYxkgcy28AmM2GV8xST0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=EQX9hwot; arc=none smtp.client-ip=18.156.205.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373966; x=1787909966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L6MGuHLofg/UQ6j3od6DFBlP6h40d9oLh3k2QL5DRKE=;
  b=EQX9hwotzFaTTrByFcOju61Qf0Eiy4yvGA8VDdIhj0TWYTQ6NQOW/unN
   8Q/QwJ0rGd9KlZ9+KPUxSA7wsqYtCj7J6tH0iNYbODKJBd1Mm8ArGVrO5
   WCBjx05DCLMGs2HeKVFtphidWxHtSS0MimKVOTL17KxVHpGdYdK/BdfFM
   x7DUClfku7MLiS1AXLAE7SlsNg3Zou0e4AVepI5Femt1H8MoiA+1o0gyA
   DopLjh60n3Ac+1Wa+ZvaLFKVKc01NzbuTpEEoh51AMFrYJH4J0uiBSo3Q
   j/ZcAFzAJUSL3jj8VrEwD/H+FRHHuNuwBqhhK9sAo91RzXNuuzI8gTknz
   A==;
X-CSE-ConnectionGUID: xHLGpQ9EQomHh63vS1uFkA==
X-CSE-MsgGUID: peFr5JATRJ+PESY0Origbw==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303198"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:16 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:15240]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.43.161:2525] with esmtp (Farcaster)
 id 88d0e6d1-2f79-4aea-8d55-7d6f4981dd7e; Thu, 28 Aug 2025 09:39:16 +0000 (UTC)
X-Farcaster-Flow-ID: 88d0e6d1-2f79-4aea-8d55-7d6f4981dd7e
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:16 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:15 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:15 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: Elliot Berman <quic_eberman@quicinc.com>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Roy,
 Patrick" <roypat@amazon.co.uk>
Subject: [PATCH v5 01/12] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Topic: [PATCH v5 01/12] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Index: AQHcF/+eDtAQnAAgHUCJHWFnAQTX+Q==
Date: Thu, 28 Aug 2025 09:39:15 +0000
Message-ID: <20250828093902.2719-2-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

From: Elliot Berman <quic_eberman@quicinc.com>=0A=
=0A=
When guest_memfd removes memory from the host kernel's direct map,=0A=
direct map entries must be restored before the memory is freed again. To=0A=
do so, ->free_folio() needs to know whether a gmem folio was direct map=0A=
removed in the first place though. While possible to keep track of this=0A=
information on each individual folio (e.g. via page flags), direct map=0A=
removal is an all-or-nothing property of the entire guest_memfd, so it=0A=
is less error prone to just check the flag stored in the gmem inode's=0A=
private data.  However, by the time ->free_folio() is called,=0A=
folio->mapping might be cleared. To still allow access to the address=0A=
space from which the folio was just removed, pass it in as an additional=0A=
argument to ->free_folio, as the mapping is well-known to all callers.=0A=
=0A=
Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@redh=
at.com/=0A=
Suggested-by: David Hildenbrand <david@redhat.com>=0A=
Acked-by: David Hildenbrand <david@redhat.com>=0A=
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>=0A=
[patrick: rewrite shortlog for new usecase]=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/filesystems/locking.rst |  2 +-=0A=
 fs/nfs/dir.c                          | 11 ++++++-----=0A=
 fs/orangefs/inode.c                   |  3 ++-=0A=
 include/linux/fs.h                    |  2 +-=0A=
 mm/filemap.c                          |  9 +++++----=0A=
 mm/secretmem.c                        |  3 ++-=0A=
 mm/vmscan.c                           |  4 ++--=0A=
 virt/kvm/guest_memfd.c                |  3 ++-=0A=
 8 files changed, 21 insertions(+), 16 deletions(-)=0A=
=0A=
diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesyst=
ems/locking.rst=0A=
index aa287ccdac2f..74c97287ec40 100644=0A=
--- a/Documentation/filesystems/locking.rst=0A=
+++ b/Documentation/filesystems/locking.rst=0A=
@@ -262,7 +262,7 @@ prototypes::=0A=
 	sector_t (*bmap)(struct address_space *, sector_t);=0A=
 	void (*invalidate_folio) (struct folio *, size_t start, size_t len);=0A=
 	bool (*release_folio)(struct folio *, gfp_t);=0A=
-	void (*free_folio)(struct folio *);=0A=
+	void (*free_folio)(struct address_space *, struct folio *);=0A=
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);=0A=
 	int (*migrate_folio)(struct address_space *, struct folio *dst,=0A=
 			struct folio *src, enum migrate_mode);=0A=
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c=0A=
index d81217923936..644bd54e052c 100644=0A=
--- a/fs/nfs/dir.c=0A=
+++ b/fs/nfs/dir.c=0A=
@@ -55,7 +55,7 @@ static int nfs_closedir(struct inode *, struct file *);=
=0A=
 static int nfs_readdir(struct file *, struct dir_context *);=0A=
 static int nfs_fsync_dir(struct file *, loff_t, loff_t, int);=0A=
 static loff_t nfs_llseek_dir(struct file *, loff_t, int);=0A=
-static void nfs_readdir_clear_array(struct folio *);=0A=
+static void nfs_readdir_clear_array(struct address_space *, struct folio *=
);=0A=
 static int nfs_do_create(struct inode *dir, struct dentry *dentry,=0A=
 			 umode_t mode, int open_flags);=0A=
 =0A=
@@ -218,7 +218,8 @@ static void nfs_readdir_folio_init_array(struct folio *=
folio, u64 last_cookie,=0A=
 /*=0A=
  * we are freeing strings created by nfs_add_to_readdir_array()=0A=
  */=0A=
-static void nfs_readdir_clear_array(struct folio *folio)=0A=
+static void nfs_readdir_clear_array(struct address_space *mapping,=0A=
+				    struct folio *folio)=0A=
 {=0A=
 	struct nfs_cache_array *array;=0A=
 	unsigned int i;=0A=
@@ -233,7 +234,7 @@ static void nfs_readdir_clear_array(struct folio *folio=
)=0A=
 static void nfs_readdir_folio_reinit_array(struct folio *folio, u64 last_c=
ookie,=0A=
 					   u64 change_attr)=0A=
 {=0A=
-	nfs_readdir_clear_array(folio);=0A=
+	nfs_readdir_clear_array(folio->mapping, folio);=0A=
 	nfs_readdir_folio_init_array(folio, last_cookie, change_attr);=0A=
 }=0A=
 =0A=
@@ -249,7 +250,7 @@ nfs_readdir_folio_array_alloc(u64 last_cookie, gfp_t gf=
p_flags)=0A=
 static void nfs_readdir_folio_array_free(struct folio *folio)=0A=
 {=0A=
 	if (folio) {=0A=
-		nfs_readdir_clear_array(folio);=0A=
+		nfs_readdir_clear_array(folio->mapping, folio);=0A=
 		folio_put(folio);=0A=
 	}=0A=
 }=0A=
@@ -391,7 +392,7 @@ static void nfs_readdir_folio_init_and_validate(struct =
folio *folio, u64 cookie,=0A=
 	if (folio_test_uptodate(folio)) {=0A=
 		if (nfs_readdir_folio_validate(folio, cookie, change_attr))=0A=
 			return;=0A=
-		nfs_readdir_clear_array(folio);=0A=
+		nfs_readdir_clear_array(folio->mapping, folio);=0A=
 	}=0A=
 	nfs_readdir_folio_init_array(folio, cookie, change_attr);=0A=
 	folio_mark_uptodate(folio);=0A=
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c=0A=
index a01400cd41fd..37227ba71593 100644=0A=
--- a/fs/orangefs/inode.c=0A=
+++ b/fs/orangefs/inode.c=0A=
@@ -452,7 +452,8 @@ static bool orangefs_release_folio(struct folio *folio,=
 gfp_t foo)=0A=
 	return !folio_test_private(folio);=0A=
 }=0A=
 =0A=
-static void orangefs_free_folio(struct folio *folio)=0A=
+static void orangefs_free_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
 {=0A=
 	kfree(folio_detach_private(folio));=0A=
 }=0A=
diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
index d7ab4f96d705..afb0748ffda6 100644=0A=
--- a/include/linux/fs.h=0A=
+++ b/include/linux/fs.h=0A=
@@ -457,7 +457,7 @@ struct address_space_operations {=0A=
 	sector_t (*bmap)(struct address_space *, sector_t);=0A=
 	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);=0A=
 	bool (*release_folio)(struct folio *, gfp_t);=0A=
-	void (*free_folio)(struct folio *folio);=0A=
+	void (*free_folio)(struct address_space *, struct folio *folio);=0A=
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);=0A=
 	/*=0A=
 	 * migrate the contents of a folio to the specified target. If=0A=
diff --git a/mm/filemap.c b/mm/filemap.c=0A=
index 751838ef05e5..3dd8ad922d80 100644=0A=
--- a/mm/filemap.c=0A=
+++ b/mm/filemap.c=0A=
@@ -226,11 +226,11 @@ void __filemap_remove_folio(struct folio *folio, void=
 *shadow)=0A=
 =0A=
 void filemap_free_folio(struct address_space *mapping, struct folio *folio=
)=0A=
 {=0A=
-	void (*free_folio)(struct folio *);=0A=
+	void (*free_folio)(struct address_space *, struct folio *);=0A=
 =0A=
 	free_folio =3D mapping->a_ops->free_folio;=0A=
 	if (free_folio)=0A=
-		free_folio(folio);=0A=
+		free_folio(mapping, folio);=0A=
 =0A=
 	folio_put_refs(folio, folio_nr_pages(folio));=0A=
 }=0A=
@@ -820,7 +820,8 @@ EXPORT_SYMBOL(file_write_and_wait_range);=0A=
 void replace_page_cache_folio(struct folio *old, struct folio *new)=0A=
 {=0A=
 	struct address_space *mapping =3D old->mapping;=0A=
-	void (*free_folio)(struct folio *) =3D mapping->a_ops->free_folio;=0A=
+	void (*free_folio)(struct address_space *, struct folio *) =3D=0A=
+		mapping->a_ops->free_folio;=0A=
 	pgoff_t offset =3D old->index;=0A=
 	XA_STATE(xas, &mapping->i_pages, offset);=0A=
 =0A=
@@ -849,7 +850,7 @@ void replace_page_cache_folio(struct folio *old, struct=
 folio *new)=0A=
 		__lruvec_stat_add_folio(new, NR_SHMEM);=0A=
 	xas_unlock_irq(&xas);=0A=
 	if (free_folio)=0A=
-		free_folio(old);=0A=
+		free_folio(mapping, old);=0A=
 	folio_put(old);=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(replace_page_cache_folio);=0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index 60137305bc20..422dcaa32506 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -150,7 +150,8 @@ static int secretmem_migrate_folio(struct address_space=
 *mapping,=0A=
 	return -EBUSY;=0A=
 }=0A=
 =0A=
-static void secretmem_free_folio(struct folio *folio)=0A=
+static void secretmem_free_folio(struct address_space *mapping,=0A=
+				 struct folio *folio)=0A=
 {=0A=
 	set_direct_map_default_noflush(folio_page(folio, 0));=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
diff --git a/mm/vmscan.c b/mm/vmscan.c=0A=
index a48aec8bfd92..559bd6ac965c 100644=0A=
--- a/mm/vmscan.c=0A=
+++ b/mm/vmscan.c=0A=
@@ -788,7 +788,7 @@ static int __remove_mapping(struct address_space *mappi=
ng, struct folio *folio,=0A=
 		xa_unlock_irq(&mapping->i_pages);=0A=
 		put_swap_folio(folio, swap);=0A=
 	} else {=0A=
-		void (*free_folio)(struct folio *);=0A=
+		void (*free_folio)(struct address_space *, struct folio *);=0A=
 =0A=
 		free_folio =3D mapping->a_ops->free_folio;=0A=
 		/*=0A=
@@ -817,7 +817,7 @@ static int __remove_mapping(struct address_space *mappi=
ng, struct folio *folio,=0A=
 		spin_unlock(&mapping->host->i_lock);=0A=
 =0A=
 		if (free_folio)=0A=
-			free_folio(folio);=0A=
+			free_folio(mapping, folio);=0A=
 	}=0A=
 =0A=
 	return 1;=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 08a6bc7d25b6..9ec4c45e3cf2 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -430,7 +430,8 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
-static void kvm_gmem_free_folio(struct folio *folio)=0A=
+static void kvm_gmem_free_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
-- =0A=
2.50.1=0A=
=0A=


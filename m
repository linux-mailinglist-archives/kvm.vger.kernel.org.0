Return-Path: <kvm+bounces-46875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7D3ABA4AF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B7694A859D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 20:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6085F280011;
	Fri, 16 May 2025 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0siapPWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943062222B2
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 20:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747427179; cv=none; b=Z/YbBROGXJDOrQJoGzDJubOLQbdVAra132UArpEz2CB74pK1unW0+oNOM60wc3HnfpVkzm74tJi/veHfYzMzJWx0n690az0eIkQwEwzd9SArUNKB6E2OE9RYh7UO0SggjosTo5J9YWrkbjjL8pmDWv6RAi6YGhYKfjGzpj564/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747427179; c=relaxed/simple;
	bh=aoUi559TcBbVXOT1mOLhinOxSo81UkFp8l42knSwhE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FGFXReOi3U3mKjv7YDTfXpH/OQlvfnwyGiFNZYdtcYEl8RcxkaATXVkZbD5aRJgPOfZF/Jy6D9TehBhoRlSQWR0IixZp6KbPmUCryFaRY/PhQ/LH398fwriZkavj8BfG1YHfvfaudeuyFB5RseXj3PwAsVlJ1nl/bn3wiGC1QHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0siapPWH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742b8c0eaf0so123293b3a.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747427176; x=1748031976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uNYsA1VxpeAmKMsl0ZmuzjWNkULRjyT0q4ZSttGXwmE=;
        b=0siapPWHsrYSCYgc++f+j71JGfg+tTNG9SMOdSoD04aVxz3wZNMRG71YP3q4dq5df9
         49gojksGCvrTnUciJVbKSvkTHDDfXS73eda7DwFQEnN4UeMlHvAJl7y9iSh+3JOeg9ca
         4qpYVsPmymDjb6DsePDNmtbVc5iTFBGek/lb6yil9W9+p4DVOzYl5kIlckH27VlDwkxc
         AbR2/BP2mAAltJE4a9ODkamabhfv8MyIRR5QFN+U9BO+RKK/2oSRBNNptqm3QuLBtsx5
         sHjjS7ZWRNtsQ9w9heFosz2Agjmhu8Til+4dF3xlPA5GWfQ3u3DQJT3BQkBe8aeMlJ1e
         u/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747427176; x=1748031976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNYsA1VxpeAmKMsl0ZmuzjWNkULRjyT0q4ZSttGXwmE=;
        b=jZGEzBVwFcJc/hbJHWlDyu9RFz3tbmyE3wts4agoMEcWqgq1DclSHlzlTfESEkS7MU
         Zt/2+TK1bYaLSJ1adzaDiytA/VSc2iuR+F8F7dh0wfqPqFnUoYGFH5bMiTdV7LCSDBtE
         h2rB01zZoGcUGhnl/aJ8Hodsr7I093C9fbk2odaV0JcqWrCTDBRdD/BHYjQEaCUs4Ht0
         FOFpF63PtibxPiwc7lPOtwzARvpfNo+/xeTuj9pyqQuxIaV34M2vvDfceeoUJwunxX33
         iwcuSKW+zFhQvtUd8p20ZonS8v2+frG3/mlcTOdBGI/AdwQkkOWdgB7kPCFW/3XgsLWK
         /J0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPky0idPFIEANhzlP2cnttAn7uSqHPOb2ZujROmhRkp7AV2lwCbPNvfOcrD8NHGjXKTrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSf2WYlKPdllCPez1a9yuYX5GbH+3jguaTPza46UVHZ3EtEbYE
	7etV2n/XUMVOcAURlULrdjtHzmoJhFgn2UCEk6WyDp/sclbUxiPTVT2yBhLWdzF5Bd9xFdU/LvJ
	sVnerok81p4v5iCG0r+BHETeReQ==
X-Google-Smtp-Source: AGHT+IGfoQoSez5L7XMlxA74tcaMgsb6OuotCbmC/vXVp/yg3sAHFsjCX4IagThUsKW7q3KLy4Ee5VF0Th4MiQ5ZJw==
X-Received: from pfgu25.prod.google.com ([2002:a05:6a00:999:b0:736:38eb:5860])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3c96:b0:73e:30af:f479 with SMTP id d2e1a72fcca58-742a98ad9famr5898497b3a.19.1747427175604;
 Fri, 16 May 2025 13:26:15 -0700 (PDT)
Date: Fri, 16 May 2025 13:26:14 -0700
In-Reply-To: <682799177f074_345d2c29482@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <6827969540b5d_345b8829485@iweiny-mobl.notmuch>
 <682799177f074_345d2c29482@iweiny-mobl.notmuch>
Message-ID: <diqzh61kfgk9.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Ira Weiny <ira.weiny@intel.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-fsdevel@vger.kernel.org, 
	afranji@google.com
Cc: aik@amd.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, bfoster@redhat.com, binbin.wu@linux.intel.com, 
	brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com, 
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, graf@amazon.com, haibo1.xu@intel.com, 
	hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
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

Ira Weiny <ira.weiny@intel.com> writes:

> Ira Weiny wrote:
>> Ackerley Tng wrote:
>> > Hello,
>> > 
>> > This patchset builds upon discussion at LPC 2024 and many guest_memfd
>> > upstream calls to provide 1G page support for guest_memfd by taking
>> > pages from HugeTLB.
>> > 
>> > This patchset is based on Linux v6.15-rc6, and requires the mmap support
>> > for guest_memfd patchset (Thanks Fuad!) [1].
>> 
>> Trying to manage dependencies I find that Ryan's just released series[1]
>> is required to build this set.
>> 
>> [1] https://lore.kernel.org/all/cover.1747368092.git.afranji@google.com/
>> 
>> Specifically this patch:
>> 	https://lore.kernel.org/all/1f42c32fc18d973b8ec97c8be8b7cd921912d42a.1747368092.git.afranji@google.com/
>> 
>> 	defines
>> 
>> 	alloc_anon_secure_inode()
>
> Perhaps Ryan's set is not required?  Just that patch?
>
> It looks like Ryan's 2/13 is the same as your 1/51 patch?
>
> https://lore.kernel.org/all/754b4898c3362050071f6dd09deb24f3c92a41c3.1747368092.git.afranji@google.com/
>
> I'll pull 1/13 and see where I get.
>
> Ira
>
>> 
>> Am I wrong in that?
>>

My bad, this patch was missing from this series:

From bd629d1ec6ffb7091a5f996dc7835abed8467f3e Mon Sep 17 00:00:00 2001
Message-ID: <bd629d1ec6ffb7091a5f996dc7835abed8467f3e.1747426836.git.ackerleytng@google.com>
From: Ackerley Tng <ackerleytng@google.com>
Date: Wed, 7 May 2025 07:59:28 -0700
Subject: [RFC PATCH v2 1/1] fs: Refactor to provide function that allocates a
 secure anonymous inode

alloc_anon_secure_inode() returns an inode after running checks in
security_inode_init_security_anon().

Also refactor secretmem's file creation process to use the new
function.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I4eb8622775bc3d544ec695f453ffd747d9490e40
---
 fs/anon_inodes.c   | 22 ++++++++++++++++------
 include/linux/fs.h |  1 +
 mm/secretmem.c     |  9 +--------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 583ac81669c2..4c3110378647 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -55,17 +55,20 @@ static struct file_system_type anon_inode_fs_type = {
 	.kill_sb	= kill_anon_super,
 };
 
-static struct inode *anon_inode_make_secure_inode(
-	const char *name,
-	const struct inode *context_inode)
+static struct inode *anon_inode_make_secure_inode(struct super_block *s,
+		const char *name, const struct inode *context_inode,
+		bool fs_internal)
 {
 	struct inode *inode;
 	int error;
 
-	inode = alloc_anon_inode(anon_inode_mnt->mnt_sb);
+	inode = alloc_anon_inode(s);
 	if (IS_ERR(inode))
 		return inode;
-	inode->i_flags &= ~S_PRIVATE;
+
+	if (!fs_internal)
+		inode->i_flags &= ~S_PRIVATE;
+
 	error =	security_inode_init_security_anon(inode, &QSTR(name),
 						  context_inode);
 	if (error) {
@@ -75,6 +78,12 @@ static struct inode *anon_inode_make_secure_inode(
 	return inode;
 }
 
+struct inode *alloc_anon_secure_inode(struct super_block *s, const char *name)
+{
+	return anon_inode_make_secure_inode(s, name, NULL, true);
+}
+EXPORT_SYMBOL_GPL(alloc_anon_secure_inode);
+
 static struct file *__anon_inode_getfile(const char *name,
 					 const struct file_operations *fops,
 					 void *priv, int flags,
@@ -88,7 +97,8 @@ static struct file *__anon_inode_getfile(const char *name,
 		return ERR_PTR(-ENOENT);
 
 	if (make_inode) {
-		inode =	anon_inode_make_secure_inode(name, context_inode);
+		inode = anon_inode_make_secure_inode(anon_inode_mnt->mnt_sb,
+						     name, context_inode, false);
 		if (IS_ERR(inode)) {
 			file = ERR_CAST(inode);
 			goto err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 016b0fe1536e..0fded2e3c661 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3550,6 +3550,7 @@ extern int simple_write_begin(struct file *file, struct address_space *mapping,
 extern const struct address_space_operations ram_aops;
 extern int always_delete_dentry(const struct dentry *);
 extern struct inode *alloc_anon_inode(struct super_block *);
+extern struct inode *alloc_anon_secure_inode(struct super_block *, const char *);
 extern int simple_nosetlease(struct file *, int, struct file_lease **, void **);
 extern const struct dentry_operations simple_dentry_operations;
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 1b0a214ee558..c0e459e58cb6 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -195,18 +195,11 @@ static struct file *secretmem_file_create(unsigned long flags)
 	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
-	int err;
 
-	inode = alloc_anon_inode(secretmem_mnt->mnt_sb);
+	inode = alloc_anon_secure_inode(secretmem_mnt->mnt_sb, anon_name);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-	err = security_inode_init_security_anon(inode, &QSTR(anon_name), NULL);
-	if (err) {
-		file = ERR_PTR(err);
-		goto err_free_inode;
-	}
-
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR, &secretmem_fops);
 	if (IS_ERR(file))
-- 
2.49.0.1101.gccaa498523-goog

>> > 
>> > For ease of testing, this series is also available, stitched together,
>> > at https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
>> > 
>> 
>> I went digging in your git tree and then found Ryan's set.  So thanks for
>> the git tree.  :-D

Glad that helped!

>> 
>> However, it seems this add another dependency which should be managed in
>> David's email of dependencies?

This is a good idea. David, do you think these two patches should be
managed as a separate patch series in the email of dependencies?

+ (left out of RFCv2, but is above) "fs: Refactor to provide function that allocates a secure anonymous inode"
+ 01/51 "KVM: guest_memfd: Make guest mem use guest mem inodes instead of anonymous inodes"

They're being used by a few patch series now.

>> 
>> Ira
>> 


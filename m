Return-Path: <kvm+bounces-26419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D70AE9746D9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5835B1F24CD6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0033A1C1759;
	Tue, 10 Sep 2024 23:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y6yv1uUZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99921C172E
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011922; cv=none; b=cn+syQOtdjzkr0prrJKlNtN3sY0Bm1WzrqByJffD517LRrJYuS+cpp844BNs7miMpG4VonEvkhdFEO/wf0YbcAV3aVkz4kL8FAmcWW6IaGPpAcfWNAYf/xk/EQT++FBR9cR7qdMve4bLEff/JJnW+1lZ068fz1ZfN/fjRTx5sEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011922; c=relaxed/simple;
	bh=HDEODfs0sW9DcivdVbXGJVJf24chSDZ1+b7TBU5QrCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DgZgcYN/KeT3FMsEA8tq7ZvmFJEc3nq/oB2hEMd+WHZwicW+vSAPKZmu5wDzPHw8PqfkhoDTetOhgOxHpRmW/S4EgvyTlg0c6tkQHcgdb1MFzf8Yq9pyu9kQBZ/j043HoI2mDf+TK8235h9cKowQQH7GqnFzM+1xcq3EM7RkPkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y6yv1uUZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4fc1a2bb7so6953110a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011920; x=1726616720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=34wlcJFkfGNQzzb1hZdL7ujzeulibiS7N8dJMuUgV78=;
        b=Y6yv1uUZ1BTUTpadaccGK0CgdnG5qo6Av8UwKc8ujmKUD7nJFE6qIWjXAcGmH0hmWR
         bUEw2N56bXAOEA8K9zhtlFt1RuPbnGedMGnf1UHKK3oHo43947wBzPO1LxkNvjJvdVRL
         e3mOsdYBQvTSbkcIS4wN70mI2CEQyjNBueeO98xAL0CF6V7j2wi5j+wIEY7XrjLrKFJI
         uhOa1awuYB0bWnb2wlQ43QeBIPq5lOCyj7O8dUTlN9RBa2DMV986aKAlrgION4pXpgZs
         iL3cPHqf3kqay+PAzaaHM9X9WVemDidoCZ6jomBhTUVmG5bQyEhaozACxFTPzJm3ktN/
         AAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011920; x=1726616720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34wlcJFkfGNQzzb1hZdL7ujzeulibiS7N8dJMuUgV78=;
        b=rlKho4JRwj/RWrrKSHvhuMRnQ3Q1xwerriHpZjD5ETWxFDQJhwJFyKZNJlXRvO8/1s
         QLMZn7CVvLQrl/KbtcFcU7B45/zX2FhVDlkmsVmNAdqIXQv8ciTDX+ETSIK7iqhQ4bPC
         qJxIEoveHu/6+A0wg9CxNZSNhMCdun222++Ba0GHrs40GXNGOivW4Hv1nwJmDu1C7TXM
         tiSuvVw1AhwL1lJhF3NdY+KvhDG5uK6N+0PJfeRvlLsuQuNiOr+Er2CYsvLKfHwnPbGz
         JR3BWhvvohmIDzBYQjtBEQUBt4YU4EhJ4v5rmJ6fhdbGr6aLVQhOGOQONwEXPylGqTND
         u4XQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7zKWHoryb6mlwtvfVayUluyMI4Uu1QBhm/i4FREr3STiaUzWCLgTqxYYM5VhjF9EOcKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtGFoeFM3H9jAe/zWJ5Cvk452y2fi/r5rsjWKNGiVQ6iEoz0uL
	ECAUArMOqmHO7xwhw+mXqyoSZpZU8p0kK+/xaFCZZWGXUknnoohpLwFLekaXqPIp1NIc5lySyJx
	zwOLgdoDZ7D7NiaYlgYFFJg==
X-Google-Smtp-Source: AGHT+IHhJHaKR4KPnPlGSVYGkBp4x4+Xb5fuhdBUkXuBYQ8usu5fhaV07d9H987RUToHw3cMQAZNLNO7RWO0YnhXdQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a65:41c6:0:b0:785:e3e:38db with SMTP
 id 41be03b00d2f7-7db08543c58mr8464a12.8.1726011919943; Tue, 10 Sep 2024
 16:45:19 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:58 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 27/39] KVM: guest_memfd: Allow mmapping guest_memfd files
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

guest_memfd files can always be mmap()ed to userspace, but
faultability is controlled by an attribute on the inode.

Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>

---
 virt/kvm/guest_memfd.c | 46 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b603518f7b62..fc2483e35876 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -781,7 +781,8 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
+	pgoff_t nr = len >> PAGE_SHIFT;
+	pgoff_t end = start + nr;
 	struct kvm_gmem *gmem;
 
 	/*
@@ -790,6 +791,9 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
+	/* TODO: Check if even_cows should be 0 or 1 */
+	unmap_mapping_range(inode->i_mapping, start, len, 0);
+
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
@@ -946,6 +950,9 @@ static void kvm_gmem_hugetlb_teardown(struct inode *inode)
 {
 	struct kvm_gmem_hugetlb *hgmem;
 
+	/* TODO: Check if even_cows should be 0 or 1 */
+	unmap_mapping_range(inode->i_mapping, 0, LLONG_MAX, 0);
+
 	truncate_inode_pages_final_prepare(inode->i_mapping);
 	kvm_gmem_hugetlb_truncate_folios_range(inode, 0, LLONG_MAX);
 
@@ -1003,11 +1010,46 @@ static void kvm_gmem_init_mount(void)
 	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
 	BUG_ON(IS_ERR(kvm_gmem_mnt));
 
-	/* For giggles. Userspace can never map this anyways. */
 	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
 }
 
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
+{
+	struct inode *inode;
+	struct folio *folio;
+
+	inode = file_inode(vmf->vma->vm_file);
+	if (!kvm_gmem_is_faultable(inode, vmf->pgoff))
+		return VM_FAULT_SIGBUS;
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (!folio)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	file_accessed(file);
+	vm_flags_set(vma, VM_DONTDUMP);
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
-- 
2.46.0.598.g6f2099f65c-goog



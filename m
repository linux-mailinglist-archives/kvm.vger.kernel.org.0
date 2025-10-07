Return-Path: <kvm+bounces-59608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B23BC2D7D
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F1E8334F29F
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377362773F1;
	Tue,  7 Oct 2025 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v9BSHA4w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C1E277029
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875302; cv=none; b=UCeaozTh6O8izhHzPc/X7bHrPT4z5FFOtnHo1g9jsd1gjM3BeQ0Wf8SJJ1oNVHpxOtr+slZLj6quQhvqX4MHVsGJ9bNosea9zz9DjHIUCxAowZJ12yHsR5EOKC3TEKvl6DuF5gDXZnxwiTKsoWBtH2/JOCoj0IzZ/Cs/TVw0CeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875302; c=relaxed/simple;
	bh=ercJrCIZ2Uh4j1w9fwtjPtGjrYq3ynhNx8655WKwJ3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aeCq7X7A6o2FpF8G7Hi6cecJMgRAR9mlmxeE+9aiEO2XsUWGjUYn7LHKvS35Noa0W5KkcbSvzvJdwyjxYJTD/Zbs4YLYD48qPmnFI6wcRONxxuKx50nzY+NMcgRJGZqf8TOptoCUnXMmUL2uT5ciLwUsbi6aTPlKUC9vEh38h2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v9BSHA4w; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269af520712so74212115ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875300; x=1760480100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7fMZ7OhM8JOlJvnfA26tbvkth+uO96Z3bmtnJ/qhoYI=;
        b=v9BSHA4wm104IZvMDEZUSR6qTlukB4o9tl66BHKw1fgWMoMl4rVd0XT8u2UkiYOgId
         KKJlqnKJC+icJGrLcI3SjhH0gBmEJw4QNgsajBuk+sLHuhqk6uvdEXpobwhHCnebSc/j
         YTjA1uilfDt51KF5Q3eHQ6lMG7umrmXtL3RTFA/WdYTF9QcejgQpK1rZ5binrKoJtQcX
         lG+eJRReuKjF3KnsWEFE/MkREF9Hl2PDkJwUMPXzWqZVnTjd5WRgjMT5Afmp0n2wxd1M
         jrOqwhgqmMuZSeyix39DXtg0kuInQyyESyrtjvvBnxM6qQax2ih+4t3XVkzCbo2TKoSy
         Ne9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875300; x=1760480100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fMZ7OhM8JOlJvnfA26tbvkth+uO96Z3bmtnJ/qhoYI=;
        b=wMleLMSe7RyxzVNqlVdOe6iXUWA3tnezvJa+mu7PBkGQqdAANo9ZslznpE5c0Zg6WV
         GiKAkyXWhG1ZPy9ic95Ysy2FWaz/iQXJ/3h5tBzKAwQq6EBTEs9POahRuuxayZAjcoJ9
         KNI+83THCgvctt4RvFt0HT9T4HFcLVYjGeFx0guZsEKnpD01EHbKvdlojNd7MxkrcB8l
         JdCI2932npJWsq5qfJF6vdgmUdzOXsu6fDOB0NY48DIw7E8p5+pvjFd6ZXxMYmwvsIbM
         5tUqqd4yZpYQjEUEGlUERQSSp16fxyBJXX8pjoRW38m0PbQIL0W0PzIHCxnI+J+LwFRe
         zzIg==
X-Forwarded-Encrypted: i=1; AJvYcCWxhkCtg91gQoSHEbo4hSjts5ThlQc+6koelNc6PF8WcCWuwY3cgXqM1CHznvRv4yPSLvw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye5Z3U11bs6tJkJvLUEtpg3uUaS1ZMWOzu7hmOfOKQGNq7GZ+9
	CQrjaq7sjPvSdiELpQ3UMdCcUOoUqiZXlPtiYWhKbCaYB1HKEJzgmVMQ40nwim2cFvR6gMv0oCo
	AtsgStw==
X-Google-Smtp-Source: AGHT+IECKNXtIHUW5N14ZiXdwr22UXg6a0qRVDT9HGhdqQLa/WqCTYC09KfmHy6MwiN8aQHU+fr/YvGCioI=
X-Received: from plblb3.prod.google.com ([2002:a17:902:fa43:b0:269:a2bc:79bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c5:b0:27f:1c1a:ee57
 with SMTP id d9443c01a7336-290273736d4mr15592295ad.16.1759875300207; Tue, 07
 Oct 2025 15:15:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:20 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-13-seanjc@google.com>
Subject: [PATCH v12 12/12] KVM: guest_memfd: Add gmem_inode.flags field
 instead of using i_private
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Track a guest_memfd instance's flags in gmem_inode instead of burying them
in i_private.  Burning an extra 8 bytes per inode is well worth the added
clarity provided by explicit tracking.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 95267c92983b..10df35a9ffd4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,8 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+
+	u64 flags;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -162,7 +164,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
-	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 
 	return KVM_FILTER_PRIVATE;
@@ -398,9 +400,7 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	const u64 flags = (u64)inode->i_private;
-
-	return flags & GUEST_MEMFD_FLAG_MMAP;
+	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -412,7 +412,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return VM_FAULT_SIGBUS;
 
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
@@ -601,7 +601,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fops;
 	}
 
-	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
@@ -611,6 +610,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
+	GMEM_I(inode)->flags = flags;
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -931,6 +932,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	mpol_shared_policy_init(&gi->policy, NULL);
+
+	gi->flags = 0;
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0.710.ga91ca5db03-goog



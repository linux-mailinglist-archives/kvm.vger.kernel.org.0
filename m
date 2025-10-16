Return-Path: <kvm+bounces-60186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E037BE4DA3
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B4CF4FA0C3
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F16A32AAC6;
	Thu, 16 Oct 2025 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AN0wSfzq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA4822424E
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635818; cv=none; b=psOs9W6N6vWTpcHNG1D3liQqQGqPL51Fpl3jyu1cYiqR/TWCXaU2d+CMgmgzS6wYLwnOS/Zny0WezSySdhIshiTJ5wlge+lSG8j6MDrOi7crdPsCzUHqdChQJy7BJphvrVDr5Ahe5lXk+iaE4z/0lh8WNv1wxY/Vhv1h0zApJ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635818; c=relaxed/simple;
	bh=+KxRHhvCBviGDFsIU3Lsgn+jy+PLVOG7yrAqda/g69w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uuxOxMNlUyopBx4NNo6azTrDeDtUvAnARwb628KizNh0nNACyAZ5d2Juil9xT3X1bLappGINDxq9+RUQNfoB0mvs1UrIBekuSZfCOrlOo66yQ9h7nHZDQnZEZDneOPhoFp2xQeOBvBq3aK2hkfI5Ii8cRrVd6QSMZW+FlkElIns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AN0wSfzq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-334b0876195so1187885a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635816; x=1761240616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hTGJgj5iiOhAO7S5Tta2IQsGxNpf9yY+7OEbh2Vbabs=;
        b=AN0wSfzq9DtWiyTbeyVmtTZxgDHw3/6u1MAcB2rI7wC9Qk0dU/D3wEczZdGgiMFtqE
         FInit94jzR9D9kkz27fnYQGj0J0RAS0y4EQwZG3O6++T12hbbS+Q/qdNmgUgMEkHNU0+
         3HuCkrhaFpHr5WfEbjiv9wztIBA5Ne1pfGOHHMm9XU3d2HPcXLQ12ISTWUAPzRIeEtzA
         E4uPG+OHNGmrfz5xKFemO0Nss00T9p0N4cyHvSjrAMrudjH4poxFFuiiA16boODbWesR
         IO70u7sHCuzTNQrcN/iuitU0xQuFMVIKMXVIkaDDXnFnRD/Jl4H7GhNtuJxcRfuKHt5Y
         0olg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635816; x=1761240616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hTGJgj5iiOhAO7S5Tta2IQsGxNpf9yY+7OEbh2Vbabs=;
        b=dLl5CJ2j1rEo6Fm1tHUgLoMlzGU19bpk6s3gceER5k1DMViylErV3CY6E7eyCsGt4f
         +ygOywst+SxFN/ub0mWcQ3FiKzjv6eABvJ13WI3fexE6xfsvE9fRNuxzgO6eCtxfRvob
         uYEtox8jqfcM9ZNRfCSloDAFyIiJVZVQh/mDQnV7B6gxEi9pUt2OGqRJ4fMDJifRe5VQ
         oHfYVWFJKjFZbFf5rJMQblm5xpy8yo7zlFaZWxEG//RpmK+iM9glqgA2E6o85h86u3aA
         molNvPSWdFQG2kFAhl1Lksz2jNrySyy5k2EyfJ6NIzrze4kUBZRIJLBspy1HEpCo7rfc
         ShQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtHYBAvWur1NH31/Arc67NszQelrQnv4C0RJP3jL0HiIkFJKfMACXk3BgCi3bfyvMZ/z4=@vger.kernel.org
X-Gm-Message-State: AOJu0YywxheiRjNl4GaSK9Zsa9CEa8wGEIxAI7D93FCkN6UPgbAn14zb
	n6zFgPZaJ7A/NlpzuiiNE1+s++cFY+thXcDEubpfJWz9m/V/OzAnnZuFTS661C8vo6x6o2uHovi
	hsOBYjA==
X-Google-Smtp-Source: AGHT+IFjMzWsmgpoKD47UCjvnfFv794+YDxXLQNcCuCgExxBvy0QxtFrFU6ExIRDVZTLIlyFyypR9AR8QDM=
X-Received: from pjbmd14.prod.google.com ([2002:a17:90b:23ce:b0:330:793a:2e77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cce:b0:32e:dd8c:dd18
 with SMTP id 98e67ed59e1d1-33bcf8f7617mr777557a91.17.1760635815980; Thu, 16
 Oct 2025 10:30:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:45 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-5-seanjc@google.com>
Subject: [PATCH v13 04/12] KVM: guest_memfd: Add slab-allocated inode cache
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add a dedicated gmem_inode structure and a slab-allocated inode cache for
guest memory backing, similar to how shmem handles inodes.

This adds the necessary allocation/destruction functions and prepares
for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
structure will also allow for additional cleanups, e.g. to track flags in
gmem_inode instead of i_private.

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 77 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ce04fc85e631..88fd812f0f31 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -26,6 +26,15 @@ struct gmem_file {
 	struct list_head entry;
 };
 
+struct gmem_inode {
+	struct inode vfs_inode;
+};
+
+static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
+{
+	return container_of(inode, struct gmem_inode, vfs_inode);
+}
+
 #define kvm_gmem_for_each_file(f, mapping) \
 	list_for_each_entry(f, &(mapping)->i_private_list, entry)
 
@@ -830,13 +839,61 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
 #endif
 
+static struct kmem_cache *kvm_gmem_inode_cachep;
+
+static void kvm_gmem_init_inode_once(void *__gi)
+{
+	struct gmem_inode *gi = __gi;
+
+	/*
+	 * Note!  Don't initialize the inode with anything specific to the
+	 * guest_memfd instance, or that might be specific to how the inode is
+	 * used (from the VFS-layer's perspective).  This hook is called only
+	 * during the initial slab allocation, i.e. only fields/state that are
+	 * idempotent across _all_ use of the inode _object_ can be initialized
+	 * at this time!
+	 */
+	inode_init_once(&gi->vfs_inode);
+}
+
+static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
+{
+	struct gmem_inode *gi;
+
+	gi = alloc_inode_sb(sb, kvm_gmem_inode_cachep, GFP_KERNEL);
+	if (!gi)
+		return NULL;
+
+	return &gi->vfs_inode;
+}
+
+static void kvm_gmem_destroy_inode(struct inode *inode)
+{
+}
+
+static void kvm_gmem_free_inode(struct inode *inode)
+{
+	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
+}
+
+static const struct super_operations kvm_gmem_super_operations = {
+	.statfs		= simple_statfs,
+	.alloc_inode	= kvm_gmem_alloc_inode,
+	.destroy_inode	= kvm_gmem_destroy_inode,
+	.free_inode	= kvm_gmem_free_inode,
+};
+
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
 {
+	struct pseudo_fs_context *ctx;
+
 	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
 		return -ENOMEM;
 
 	fc->s_iflags |= SB_I_NOEXEC;
 	fc->s_iflags |= SB_I_NODEV;
+	ctx = fc->fs_private;
+	ctx->ops = &kvm_gmem_super_operations;
 
 	return 0;
 }
@@ -860,13 +917,31 @@ static int kvm_gmem_init_mount(void)
 
 int kvm_gmem_init(struct module *module)
 {
+	struct kmem_cache_args args = {
+		.align = 0,
+		.ctor = kvm_gmem_init_inode_once,
+	};
+	int ret;
+
 	kvm_gmem_fops.owner = module;
+	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
+						  sizeof(struct gmem_inode),
+						  &args, SLAB_ACCOUNT);
+	if (!kvm_gmem_inode_cachep)
+		return -ENOMEM;
 
-	return kvm_gmem_init_mount();
+	ret = kvm_gmem_init_mount();
+	if (ret) {
+		kmem_cache_destroy(kvm_gmem_inode_cachep);
+		return ret;
+	}
+	return 0;
 }
 
 void kvm_gmem_exit(void)
 {
 	kern_unmount(kvm_gmem_mnt);
 	kvm_gmem_mnt = NULL;
+	rcu_barrier();
+	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
-- 
2.51.0.858.gf9c4a03a3a-goog



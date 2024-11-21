Return-Path: <kvm+bounces-32259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E012D9D4CBF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A10B0282411
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F511D6DA8;
	Thu, 21 Nov 2024 12:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2kAd/9p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EED1D0E11
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732191821; cv=none; b=dKJrzAszSO9kPH/TYdlDAPFrf+fL90UYy2VRt76ZakVXKVCw10C7ugD0vhQQ/yifxDQ9zUMI/pQEdJpNBjCSWu9smZNuavWf46DHKtFX8Evi/IapvlI0GRY5LwtHiJQQPpb2N3xI1w3Ha7mMKh7BjGegJ/+ADs9wX7DO2minPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732191821; c=relaxed/simple;
	bh=G3QTb/yo1GuyOWWj7xTqamoXngMsH5W7sCHHE2I2oxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lr2mZQ+HPYe1UMPb+fh96tI2MyBSuzH8R2Yjn8D/0dZYCdGfsOl8UfzsqHKjpbSd0ZyBM6qVUDljFNLdnR027gHV2ueWWAjvcgE76GbR2oq6jDKHeakBuihPY6gbZzdhXdEJxrzw9YAoMi9Yu7kj4zaJ3w1nxOtde2RDCRFo8FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2kAd/9p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732191817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z6i+4dWSdQLkPEB+Ec8jfbVRCaAInR7wHYj3/psiBHE=;
	b=H2kAd/9pUynFCsT6IqWieFaUyFMOtFAWJSZjFjVclVvIwS0irA7UVUmdmnQWFJzYX1HMC6
	ZEupfQ79tJxIBg8//v4kgXF75UwrKf12YEFJTuM4Ez3zOnVS5dspAHa39VPlckkmhuTTvE
	6/uscnSl1pskZ8secjzC0Fv2JI5va+c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-uWrCnDP5MDChdjC7ZDxE_Q-1; Thu, 21 Nov 2024 07:23:35 -0500
X-MC-Unique: uWrCnDP5MDChdjC7ZDxE_Q-1
X-Mimecast-MFC-AGG-ID: uWrCnDP5MDChdjC7ZDxE_Q
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3822ec50b64so458614f8f.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 04:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732191815; x=1732796615;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z6i+4dWSdQLkPEB+Ec8jfbVRCaAInR7wHYj3/psiBHE=;
        b=GKScY/jY4X1n9goi4DmZ4p4AwxZM5zZe+Sa6xE3kvvuXyUm+6ASkDwjaiVKgf6eWbm
         S5O7wuVSzwScw/BW8uRb1vITTZDo4O6lgB2ql4YihwNhv5v+gXifkFi6/CLAs+xvVBvU
         BqPzcusRf2e66wBMsZJAF5LP6UA6Y6Cs2G34Infqyw+q4QQeTOWZ+uj5ntNuUtjnqd9n
         6m1bdLNtjN8It0SZ3mbTWE0A7N4L5OINlbaaMHt30lYZYL/LcoKhwVEVcsqbemgoHK/s
         xoTBRe+rD2i74Ho/Qx8Xu9KB0+2ukkx5DhwIhHmgnEQ7dgRBcFOQB0C7D5L7xLNiHtek
         ZHGw==
X-Forwarded-Encrypted: i=1; AJvYcCVo2TRsPqoCYLLgd3qAm7qsc9a+njRvb8pmJwDtePlgzqbAZVanuZYVNWAOLGD1Y7+RhjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcaEbkS018PlAa7KMR0NIkGjbl08DzVwjSh4ceLxbRo1O48dgq
	T7siKiQWMJxPOTHoJtBCRMgY9Oly2lzI8VxnNB3TsOeecxj/u1zxDQbI0RrWB+irkZk//XbN9jY
	JeBFymJCCrJnatII63Dxtq7oOu/aYEZAT6/3OVvNDVGntUpOsig==
X-Received: by 2002:a5d:59af:0:b0:382:516e:271b with SMTP id ffacd0b85a97d-38254b26416mr4135002f8f.58.1732191814637;
        Thu, 21 Nov 2024 04:23:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiEJoGXX0H9+YxrkL3w67kPrXj5+nk34QWe8K0VhlUYrcZUZM5ijH4Fehc62MFsG+2wKg9eA==
X-Received: by 2002:a5d:59af:0:b0:382:516e:271b with SMTP id ffacd0b85a97d-38254b26416mr4134959f8f.58.1732191813180;
        Thu, 21 Nov 2024 04:23:33 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:de00:1200:8636:b63b:f43? (p200300cbc70cde0012008636b63b0f43.dip0.t-ipconnect.de. [2003:cb:c70c:de00:1200:8636:b63b:f43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825493ea20sm4910187f8f.93.2024.11.21.04.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 04:23:32 -0800 (PST)
Message-ID: <954bfd5d-49ee-4754-90a6-12b44d8350d5@redhat.com>
Date: Thu, 21 Nov 2024 13:23:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] filemap: Pass address_space mapping to
 ->free_folio()
To: Elliot Berman <quic_eberman@quicinc.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jonathan Corbet <corbet@lwn.net>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: James Gowans <jgowans@amazon.com>, Mike Day <michael.day@amd.com>,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-nfs@vger.kernel.org, devel@lists.orangefs.org,
 linux-arm-kernel@lists.infradead.org
References: <20241120-guestmem-library-v4-0-0c597f733909@quicinc.com>
 <20241120-guestmem-library-v4-1-0c597f733909@quicinc.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241120-guestmem-library-v4-1-0c597f733909@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.11.24 19:12, Elliot Berman wrote:
> When guest_memfd becomes a library, a callback will need to be made to
> the owner (KVM SEV) to update the RMP entry for the page back to shared
> state. This is currently being done as part of .free_folio() operation,
> but this callback shouldn't assume that folio->mapping is set/valid.
> 
> The mapping is well-known to callers of .free_folio(), so pass that
> mapping so the callback can access the mapping's private data.
> 
> Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@redhat.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>   Documentation/filesystems/locking.rst |  2 +-
>   fs/nfs/dir.c                          | 11 ++++++-----
>   fs/orangefs/inode.c                   |  3 ++-
>   include/linux/fs.h                    |  2 +-
>   mm/filemap.c                          |  9 +++++----
>   mm/secretmem.c                        |  3 ++-
>   mm/vmscan.c                           |  4 ++--
>   virt/kvm/guest_memfd.c                |  3 ++-
>   8 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index f5e3676db954b5bce4c23a0bf723a79d66181fcd..f1a20ad5edbee70c1a3c8d8a9bfc0f008a68985b 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -258,7 +258,7 @@ prototypes::
>   	sector_t (*bmap)(struct address_space *, sector_t);
>   	void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>   	bool (*release_folio)(struct folio *, gfp_t);
> -	void (*free_folio)(struct folio *);
> +	void (*free_folio)(struct address_space *, struct folio *);
>   	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>   	int (*migrate_folio)(struct address_space *, struct folio *dst,
>   			struct folio *src, enum migrate_mode);
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 492cffd9d3d845723b5f3d0eea3874b1f1773fe1..54e7069013ef2a63db24491fa65059e5ad68057a 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -55,7 +55,7 @@ static int nfs_closedir(struct inode *, struct file *);
>   static int nfs_readdir(struct file *, struct dir_context *);
>   static int nfs_fsync_dir(struct file *, loff_t, loff_t, int);
>   static loff_t nfs_llseek_dir(struct file *, loff_t, int);
> -static void nfs_readdir_clear_array(struct folio *);
> +static void nfs_readdir_clear_array(struct address_space *, struct folio *);
>   static int nfs_do_create(struct inode *dir, struct dentry *dentry,
>   			 umode_t mode, int open_flags);
>   
> @@ -218,7 +218,8 @@ static void nfs_readdir_folio_init_array(struct folio *folio, u64 last_cookie,
>   /*
>    * we are freeing strings created by nfs_add_to_readdir_array()
>    */
> -static void nfs_readdir_clear_array(struct folio *folio)
> +static void nfs_readdir_clear_array(struct address_space *mapping,
> +				    struct folio *folio)
>   {
>   	struct nfs_cache_array *array;
>   	unsigned int i;
> @@ -233,7 +234,7 @@ static void nfs_readdir_clear_array(struct folio *folio)
>   static void nfs_readdir_folio_reinit_array(struct folio *folio, u64 last_cookie,
>   					   u64 change_attr)
>   {
> -	nfs_readdir_clear_array(folio);
> +	nfs_readdir_clear_array(folio->mapping, folio);
>   	nfs_readdir_folio_init_array(folio, last_cookie, change_attr);
>   }
>   
> @@ -249,7 +250,7 @@ nfs_readdir_folio_array_alloc(u64 last_cookie, gfp_t gfp_flags)
>   static void nfs_readdir_folio_array_free(struct folio *folio)
>   {
>   	if (folio) {
> -		nfs_readdir_clear_array(folio);
> +		nfs_readdir_clear_array(folio->mapping, folio);
>   		folio_put(folio);
>   	}
>   }
> @@ -391,7 +392,7 @@ static void nfs_readdir_folio_init_and_validate(struct folio *folio, u64 cookie,
>   	if (folio_test_uptodate(folio)) {
>   		if (nfs_readdir_folio_validate(folio, cookie, change_attr))
>   			return;
> -		nfs_readdir_clear_array(folio);
> +		nfs_readdir_clear_array(folio->mapping, folio);
>   	}
>   	nfs_readdir_folio_init_array(folio, cookie, change_attr);
>   	folio_mark_uptodate(folio);
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index aae6d2b8767df04714647db5fe1e5ce54c092fce..2d554102ba9ac83acd2b637d4568090717e87f94 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -470,7 +470,8 @@ static bool orangefs_release_folio(struct folio *folio, gfp_t foo)
>   	return !folio_test_private(folio);
>   }
>   
> -static void orangefs_free_folio(struct folio *folio)
> +static void orangefs_free_folio(struct address_space *mapping,
> +				struct folio *folio)
>   {
>   	kfree(folio_detach_private(folio));
>   }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e3c603d01337650d562405500013f5c4cfed8eb6..6e5b5cc99750a685b217cb8273c38e7f6bf5ae86 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -417,7 +417,7 @@ struct address_space_operations {
>   	sector_t (*bmap)(struct address_space *, sector_t);
>   	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>   	bool (*release_folio)(struct folio *, gfp_t);
> -	void (*free_folio)(struct folio *folio);
> +	void (*free_folio)(struct address_space *, struct folio *folio);
>   	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>   	/*
>   	 * migrate the contents of a folio to the specified target. If
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 36d22968be9a1e10da42927dd627d3f22c3a747b..2c8d92dd9d5dd433acbf1b87156eb2e68337332d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -235,12 +235,12 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
>   
>   void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>   {
> -	void (*free_folio)(struct folio *);
> +	void (*free_folio)(struct address_space *, struct folio *);
>   	int refs = 1;
>   
>   	free_folio = mapping->a_ops->free_folio;
>   	if (free_folio)
> -		free_folio(folio);
> +		free_folio(mapping, folio);
>   
>   	if (folio_test_large(folio))
>   		refs = folio_nr_pages(folio);
> @@ -814,7 +814,8 @@ EXPORT_SYMBOL(file_write_and_wait_range);
>   void replace_page_cache_folio(struct folio *old, struct folio *new)
>   {
>   	struct address_space *mapping = old->mapping;
> -	void (*free_folio)(struct folio *) = mapping->a_ops->free_folio;
> +	void (*free_folio)(struct address_space *, struct folio *) =
> +		mapping->a_ops->free_folio;
>   	pgoff_t offset = old->index;
>   	XA_STATE(xas, &mapping->i_pages, offset);
>   
> @@ -843,7 +844,7 @@ void replace_page_cache_folio(struct folio *old, struct folio *new)
>   		__lruvec_stat_add_folio(new, NR_SHMEM);
>   	xas_unlock_irq(&xas);
>   	if (free_folio)
> -		free_folio(old);
> +		free_folio(mapping, old);
>   	folio_put(old);
>   }
>   EXPORT_SYMBOL_GPL(replace_page_cache_folio);
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 3afb5ad701e14ad87b6e5173b2974f1309399b8e..8643d073b8f3554a18d419353fa604864de224c1 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -152,7 +152,8 @@ static int secretmem_migrate_folio(struct address_space *mapping,
>   	return -EBUSY;
>   }
>   
> -static void secretmem_free_folio(struct folio *folio)
> +static void secretmem_free_folio(struct address_space *mapping,
> +				 struct folio *folio)

In the mm world, we're nowadays indenting the second parameter line with 
two tabs. Makes it easier to rename the function without having to 
adjust many lines, and requires less lines in general.

Not sure about rules for FSes (personally, I just do it everywhere like 
this now :) ).

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



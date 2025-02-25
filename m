Return-Path: <kvm+bounces-39176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 927E5A44DDD
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E20D7176E52
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528561ACED7;
	Tue, 25 Feb 2025 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iOGI11ig"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1623190051
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515838; cv=none; b=JdIiD/Ubm4UvtQL1ex8MozytMMRGjodOXRjQHsoimYEL8JL9gF2Xq/k20saMBFs81+g9zL0tLQoVEpFmR+vR5r2ihxI9TfEYS74o3C2/S+pmxpEwRDR2yYq2V9O9dWnNbxq9ZRj8gw7RRZxm2uIDYjPCWi8+ItwV6ynjANI4j5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515838; c=relaxed/simple;
	bh=iANJ7jUuLPOAUdWYvwdIPBdpaK1PGcaz53zJhHH7W28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXcTMa4hGN7Wx9nssZgxPhNsKaYSwqkIvVKZTHOdWEMXa7PioQJ0vzNndhApaiUFewKZjIb4tlaQalTx04RWlKanECTneETz21s/7365ijjOOThNNPmGyyApXbDAdYCODgQjyZBy7CeT6kw0DI1kp0C0JTjuRVGvPknSaN/EC80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iOGI11ig; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740515835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRqlIAwXEZAt9A8J1cznfUQsjJ6aJaejVBOoC9QBm/E=;
	b=iOGI11igcjgJFF8tzY6bS4Ui92NtzARpkbgRR/Y3L9WYW/bxyLdP/62XRU06WZuviYddyb
	YgU+u1PqGQNhL3bIwkXk0ax4YSDHFjJjfZevtAyyIgI1ACd9yKgSadelhIX6zXj7Z/coPK
	fQJ4CZu5vQUVMOf3xyZyob1bTg552RU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-LlABWLjDNOejzDTRhThiYw-1; Tue, 25 Feb 2025 15:37:14 -0500
X-MC-Unique: LlABWLjDNOejzDTRhThiYw-1
X-Mimecast-MFC-AGG-ID: LlABWLjDNOejzDTRhThiYw_1740515833
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-727294aa679so6242907a34.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 12:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740515833; x=1741120633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRqlIAwXEZAt9A8J1cznfUQsjJ6aJaejVBOoC9QBm/E=;
        b=qYRNpv93brgjnDr8E8/5LZEhCQyB1g3DpKMMTQO+lSqCDVz34QR7ZWzXmfmU74grp5
         yicgau1hX5P8CoCZPGcW6Ttmm2UU71NPEHgfHLakBQYs3aNzZNTYiuDfSrcsUu4H1T38
         ZU02uoATFgqIA5+Ywxms4uey/FctsgZjywDoSlqD87PKgn33GRnKHiviizItPp/6akqQ
         prck3ZUwCqEjJa6HdizU11e+UJPnLby5Ejonoj52OLLkOVm1WiRfQoG+M7+5E9T3PCv9
         qgIXxETKDdem+pqp4fg7Ma3d2P3n7mBw3e18VLKrOdju+xTEvQpO5McpjN0QtKz6kwku
         RcKw==
X-Forwarded-Encrypted: i=1; AJvYcCWmSD6TtVsUp3Qx2TA3j9PhvIlf0sSNgzo/9TUbfl4jLfy/Cbo+tvy9QVCGBcmvJJrLjTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPnGO/ULHHyJ7q6J4uqt/yRGDZDORqP7G21FR1jlwMMaPeUOoz
	PNyxj2oxWHlfBo/gUyFsnzynpUOcaGOVJDUHkDyG/PZ4Gkp4mR+KKTBJBYyr2XGn4xhLR7EIaSU
	GZ/fKl/kVdHCEICbici+UfpJ1wF0HeXF6S8ywBtN/SKzgBMuC2A==
X-Gm-Gg: ASbGncvejLGC2TVq7sMut4TbEboxtsqJBFtHo1NPCFzD3FtRcAQjvMOAOAS0T4gXsBx
	TaVmQyUIHI1axyzaC2pUJZmczfnNhZGbZuD0X4DX9YwKf3I1NpKhSgBVLCtGvGIK7eNVsWTvEny
	iuUsxSZLjOJLca6ioi9C6eqBRBycmj9BB2t0qUnsc+BK9WoLzM5b/v1sKYzL9NS9VZiCTlKvzqx
	eujBAF7P6uTR0vd5D+2rh3DAO6UVxJYZ+RCyLtHcWCh93pEjG3S695UCeeqnDmQY6n5KQ==
X-Received: by 2002:a05:6830:6c11:b0:727:25c6:1b60 with SMTP id 46e09a7af769-7274c1840famr14524647a34.5.1740515833596;
        Tue, 25 Feb 2025 12:37:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFotTZ/dQhUmhniqjIu8SiEBEne0EGahBIhmibL4OkgpDX+sNTQXhjiXbEsxwXRiWLeeDe4Vw==
X-Received: by 2002:a05:6830:6c11:b0:727:25c6:1b60 with SMTP id 46e09a7af769-7274c1840famr14524623a34.5.1740515833295;
        Tue, 25 Feb 2025 12:37:13 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7289deed409sm431155a34.40.2025.02.25.12.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:37:12 -0800 (PST)
Date: Tue, 25 Feb 2025 15:37:07 -0500
From: Peter Xu <peterx@redhat.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
	jgg@nvidia.com, david@redhat.com, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	mike.kravetz@oracle.com, erdemaktas@google.com,
	vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
	willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
	bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
	rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
	haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
	maciej.wieczor-retman@intel.com, pgonda@google.com,
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
Message-ID: <Z74p8-l6BhOmR1B_@x1.local>
References: <cover.1726009989.git.ackerleytng@google.com>
 <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:57PM +0000, Ackerley Tng wrote:
> @@ -1079,12 +1152,20 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>  	if (err)
>  		goto out;
>  
> +	err = -ENOMEM;
> +	private = kzalloc(sizeof(*private), GFP_KERNEL);
> +	if (!private)
> +		goto out;
> +
>  	if (flags & KVM_GUEST_MEMFD_HUGETLB) {
> -		err = kvm_gmem_hugetlb_setup(inode, size, flags);
> +		err = kvm_gmem_hugetlb_setup(inode, private, size, flags);
>  		if (err)
> -			goto out;
> +			goto free_private;
>  	}
>  
> +	xa_init(&private->faultability);
> +	inode->i_mapping->i_private_data = private;
> +
>  	inode->i_private = (void *)(unsigned long)flags;

Looks like inode->i_private isn't used before this series; the flags was
always zero before anyway.  Maybe it could keep kvm_gmem_inode_private
instead? Then make the flags be part of the struct.

It avoids two separate places (inode->i_mapping->i_private_data,
inode->i_private) to store gmem private info.

>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
> @@ -1097,6 +1178,8 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>  
>  	return inode;
>  
> +free_private:
> +	kfree(private);
>  out:
>  	iput(inode);
>  
> -- 
> 2.46.0.598.g6f2099f65c-goog
> 

-- 
Peter Xu



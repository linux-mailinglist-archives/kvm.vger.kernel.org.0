Return-Path: <kvm+bounces-36078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF7AA174BC
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 23:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8751C168314
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 22:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893E61F03D7;
	Mon, 20 Jan 2025 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwrvqZqB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106C5537E9
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737412948; cv=none; b=SALiXnM8eSrfc2C5hVkTZkriCik5SivtqkLVa7O6TNqqx5ffk6wQlMCszyVofvieItpeheUW7GuvjqPeVw/MIeEIYIfaFoNBBUygLLmAVrITGz1/xZyOOHtnwksRDSslbIpfSm+D7vZu1QHd0TffIbfLqHjkrV+47k7Zkpig8UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737412948; c=relaxed/simple;
	bh=MI6K6OxxlBfwQa8RksvnhXGgY56IlPTqx9gNhRjrzEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lewUphxAthqntlKR8d4iKq7bmDc/bB4oXgxfXwjY3Wghz9mSxZkT7R1ZBo4Jdy4mwwHsEzflaik14E42L0InGHRlsYox9CblXTte1wr0drbfWXOFuKzOzxOX9L2rKozrJpxPxJyc5nPQ2Io6mERwKvwAYgHqCtLgLgD4SdH8nGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GwrvqZqB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737412946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rr/mJCPPlIoUxh0qeb7nwuTIwN1v1Uw8JIILAMa5xao=;
	b=GwrvqZqBzdnejOk/1z0QBbFz2zjt4JHeqfdwGF3owVo07uwn3Ts37KrsPev9H2r83g5WVB
	DwixF09L0xcUVhzTIEkYnDl00GQUjsnvPdMaUzs/aKknxpJTwxuM/7+k5R6pEz6bc39Qph
	BGeyxk0u9ElNg7bgqFJZMjV1zitDMOY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-UPfjlquiO-eZlQhItAAMeg-1; Mon, 20 Jan 2025 17:42:24 -0500
X-MC-Unique: UPfjlquiO-eZlQhItAAMeg-1
X-Mimecast-MFC-AGG-ID: UPfjlquiO-eZlQhItAAMeg
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b9e433351dso974917385a.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 14:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737412944; x=1738017744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rr/mJCPPlIoUxh0qeb7nwuTIwN1v1Uw8JIILAMa5xao=;
        b=qHoHoKBTQKKT1JvohtyUarB+5DprrGiFuo60YIqjL3Suy8RdXlksfvD2tp3jTFyl+Y
         PCB+U/rjtoPXE0ySgzgVHm5vBhUOapYrsgpovugWUeS93chVA4mvUuaRyUNm9J20gdLN
         QeEkK9a3LtE3Fmm6LUPQgPuhptG9wkiTSbIt048z+eUvxd20RqKqBvFx6xhbppGllyc0
         UwDjUrk0RxYdFEHaKeri4GIKznd0j6z3L+qpQKcUxzgiZrjJXZQFlHRYdjr2FYZXJnPB
         ycqsJd4/6h2iAC3dRDaLUQ8KuHHsZQwO7mXeiAHS6S1jxFr8PyGyloZftwvqwSqwXdpM
         EDIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtPZ5v98uM9n9d3RaNbxEq9yOqrhPfkR4pNihP2Fmvxx6bgG5uwa76GvcKZnO94glEKxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEYgH83QUFbl0UVEDOeM1gqqc9/YbiQKbpy4RMDzxEtrHZkr/T
	NNctb2K+TTmBWKbUAdwuQENq2ynA/VG+ku0vmn8bVfPtDE8oMNLhTzZ3dVDNpJR/s2Opahjll64
	ZeoYg3QcZN047kBiXctu6+PhtC7yw6mvFUS+t0Pv4IxN6G6P8Cw==
X-Gm-Gg: ASbGncvTNGLGDBTYu9Ijmz1T3/UTCvknIjt9mucpd5yrcQ04jhaUBr9l0wUs0YVp8Hg
	g1xUV6ctOHqwYeXaEMGhSf113rYawnH9OABOtxNYlLR/q9yAdkBqOQFhUVs20/wz3ScleTcmyYa
	ZUQsNlx/dW2Uyq+ZVqbr9t8mHJD4I7kCl3GjVLtNmgsXrELmOU+xD1TfcHlcJsW9844hz37hcTw
	4ddk2IU5iH7ILE8EwGcAZK0XRRS0E/6QuXEetgfGHOKRIQSYcgGt5P0jZ8udWqknSPU+ih4Jc+L
	tjUpZiGxm9rM0JhqRU6QlKYzByOifaA=
X-Received: by 2002:a05:620a:1a02:b0:7b6:6a76:3a44 with SMTP id af79cd13be357-7be631f2fe6mr2099332185a.17.1737412944396;
        Mon, 20 Jan 2025 14:42:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEThixwCznyw5iNLbhD2xvehIRrXyI7UvkShNUVV9hD0bz/X+BcgicvUE24wdf1vF932XY0Hw==
X-Received: by 2002:a05:620a:1a02:b0:7b6:6a76:3a44 with SMTP id af79cd13be357-7be631f2fe6mr2099326185a.17.1737412944062;
        Mon, 20 Jan 2025 14:42:24 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d9955sm493015685a.81.2025.01.20.14.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 14:42:22 -0800 (PST)
Date: Mon, 20 Jan 2025 17:42:18 -0500
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
Subject: Re: [RFC PATCH 27/39] KVM: guest_memfd: Allow mmapping guest_memfd
 files
Message-ID: <Z47RSls2rr-xVqNk@x1n>
References: <cover.1726009989.git.ackerleytng@google.com>
 <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:58PM +0000, Ackerley Tng wrote:
> @@ -790,6 +791,9 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> +	/* TODO: Check if even_cows should be 0 or 1 */
> +	unmap_mapping_range(inode->i_mapping, start, len, 0);
> +
>  	list_for_each_entry(gmem, gmem_list, entry)
>  		kvm_gmem_invalidate_begin(gmem, start, end);
>  
> @@ -946,6 +950,9 @@ static void kvm_gmem_hugetlb_teardown(struct inode *inode)
>  {
>  	struct kvm_gmem_hugetlb *hgmem;
>  
> +	/* TODO: Check if even_cows should be 0 or 1 */
> +	unmap_mapping_range(inode->i_mapping, 0, LLONG_MAX, 0);

Setting to 0 is ok in both places: even_cows only applies to MAP_PRIVATE,
which gmemfd doesn't support.  So feel free to drop the two comment lines.

Thanks,

-- 
Peter Xu



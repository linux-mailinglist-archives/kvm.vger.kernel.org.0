Return-Path: <kvm+bounces-59729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 154AABCAEC2
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 23:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 154FB481DA8
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 21:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47473284B42;
	Thu,  9 Oct 2025 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="euQH7L7x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6CD28489A
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045226; cv=none; b=r8wSl+mJB+L5MpweeMRBU2gtKMIX/IZaCjLYnqfzCHJ0MQ5tdIJ6VUTbglJoZcrWlg5x785waWSpDlgevqyn0trf9NleUDqbtMtwd1F0J9zaUCnatFgbOh0bBUuXvtyOi+iGZM+CvGIVqtKg2YJHITiKmkAb6vHaNy07QPnV+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045226; c=relaxed/simple;
	bh=QUyhg2tPz5e6+QEJVc5tbnozxAJnMMfwwidrggXUHNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d8YKHXBLI5wazsqaDGCJY/VWm0zgO6ZE/PEd1s1gNAC6liAt0zedGgDa4xWfrKBM4NjakpYW5QjcTpAIKRyxHJBTJJoOdkzKIwNYGNtWNvVyp7a7OqiG7lWznd1esWJIc3yCFanxyMeW+KMfW0s5aYzjbbWXKIIkz+D45UD9i14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=euQH7L7x; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-783c3400b5dso1372339b3a.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760045224; x=1760650024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyG7Vshnn1y3ko5tY/OsDeeGP+hnaQE19ZgqRlKar30=;
        b=euQH7L7xwI49CNkcocNjnYTGXwNznmWhXcpNLI5tT3lTh4ELiJsBNxA5aL/Jon84CH
         lmL89GYvbGnIKSXW3o7owp4BW2wrFm0UMmLlftPOP5c9FtY85L6p3bQlCPOrIkS5Rj5T
         p+4ndpn6Ta1CeNbORZSWCOJ5p8q+wENbIZDbfIA+KWCfiNrqgEkpvoqVgSJEn2E0edSA
         d9ifZ/JbcUSvm8Hio8UtUKHNSE153jhJ+b40mpoe57hf2CKDucFFArrQs6SCy7mlNe6S
         ST0RfH0/NnPiG5LP3wRzI6pmHJ4Q43SWA6Q5o6pekg59S0blyd1H9wude1FqS9NUKy+q
         2t0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760045224; x=1760650024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VyG7Vshnn1y3ko5tY/OsDeeGP+hnaQE19ZgqRlKar30=;
        b=OrZLrCKYjTGC7Jj9atZoO39P9gAMe+6jbZm0dqLcDJqqz+NYfg6rWCfGsbQlG1U7VA
         BrWZFiqdrvmOmB3gbOfVkpPcFWkSxhramw/6QeUG/rwvhQms1TvCSXXwWVh1uODiW7l+
         NJoyan6BpvM+M6dkQodpST2ykaNCa4M7KChvv9kF7U5PTKQKUuq/nL9cF7AbJ6uHfJHx
         q0XVZUqzfhJD57fIjg8bSszmtN/HpHC/23lEtaftUX+14zYxW7EMx4v5QnFdjSkbnxB6
         JIcxsJ5+JxWCzy6zfB/KXw5UJTO0Iabo/2Go8tvnfnDty865n0Ur1rJzft03w0jdpTKp
         q65A==
X-Forwarded-Encrypted: i=1; AJvYcCV+5/ISLXyB88oshWPEbWj714BCj0oWqqGJSZkSsj7oKqGAcaZvmU5tlbfO9fN84h614nc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKdeyuoRat6KzbCcE7lr/zH8kwYpWSbqQoi1bv7RjEuc50PTJj
	meF4Y8KWOKqCSK458r/j15WshTFU+GDn9Bp5JI0q3qAT0KGz6+ArAqEPBv9VsKkqszxRkwXLWur
	gO2et22XQZCnzzOLlHZJWFa6ReA==
X-Google-Smtp-Source: AGHT+IEXSCT7Ge93/eS1ZLL+wIsHzqCvUWVK2zdip6A/DIomUySbaHDcPWrDH/GuqrKumWfw/V6m+o1hEtdfCxTDkQ==
X-Received: from pjbms8.prod.google.com ([2002:a17:90b:2348:b0:33b:51fe:1a80])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:33a6:b0:32a:6d26:fb5a with SMTP id adf61e73a8af0-32da80b8305mr11558495637.4.1760045224327;
 Thu, 09 Oct 2025 14:27:04 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:27:02 -0700
In-Reply-To: <20251007221420.344669-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-3-seanjc@google.com>
Message-ID: <diqzwm53hil5.fsf@google.com>
Subject: Re: [PATCH v12 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
> iterating over guest_memfd _files_, not guest_memfd instances, as could
> be assumed given the name "gmem_list".
>

Can we also add to .clang-format:

diff --git i/.clang-format w/.clang-format
index 48405c54ef271..e4df86f2d3cf7 100644
--- i/.clang-format
+++ w/.clang-format
@@ -541,6 +541,7 @@ ForEachMacros:
   - 'kvm_for_each_memslot'
   - 'kvm_for_each_memslot_in_gfn_range'
   - 'kvm_for_each_vcpu'
+  - 'kvm_gmem_for_each_file'
   - 'libbpf_nla_for_each_attr'
   - 'list_for_each'
   - 'list_for_each_codec'

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3c57fb42f12c..9b9e239b3073 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -22,6 +22,9 @@ struct gmem_file {
>  	struct list_head entry;
>  };
>  
> +#define kvm_gmem_for_each_file(f, mapping) \
> +	list_for_each_entry(f, &(mapping)->i_private_list, entry)
> +
>  /**
>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -159,13 +162,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
>  				      pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	enum kvm_gfn_range_filter attr_filter;
>  	struct gmem_file *f;
>  
>  	attr_filter = kvm_gmem_get_invalidate_filter(inode);
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
>  }
>  
> @@ -184,10 +186,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
>  				    pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	struct gmem_file *f;
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_end(f, start, end);
>  }
>  
> -- 
> 2.51.0.710.ga91ca5db03-goog


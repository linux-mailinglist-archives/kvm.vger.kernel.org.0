Return-Path: <kvm+bounces-40979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBCEA600CD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 676867A80D3
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210CB1F1526;
	Thu, 13 Mar 2025 19:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zns42GGc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A631F0E40
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741893185; cv=none; b=Jem+IKC5owXqjKTxMNKhC57FXi/gBSEg9FNeP+rdElUcRi+vfLCSIJZlBJttT9yS1/CEa89f0H+xLe3RzzoI/853zr5m8eaBxmecByUvmtGhUOXkgde7q/+pwo2VOCE/gVw/tzXP0Ca0Ma0xDrQQCsSZ52lLOE1Nqr0+NZJ70t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741893185; c=relaxed/simple;
	bh=jagCpUiEiGHEWFubbh7emapvGjhnMLj+b75pACy+vZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/dtElRrKyNbc0Q+DG3tgxNFC+sOdTqFhdGHD3GKB32L7M718OViQuXEPAvOQljGRDPS9qNlfIXcDh7jVl/BMPbMdHuv5c9iFpW4UVH29h78DdBwFYCOjOKxEWJzDspjUAc/YGgGZ5nYTtH6EEUt1/hEaNoqAkRpVmUcGkAh6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zns42GGc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741893182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eu8Zt5JHKLInYlZV//fPfzrbXAHVXgUz1d/jNhTgXBA=;
	b=Zns42GGcbV3I41IBIis6ej85HVfer7HcrdlpoPY04CJKqvz4WlJ6zqhu6scvndChuLPYa3
	LIdY6u31TaEEM/QeUEiKc8djcC4QR5/aSn7Z2dcZARfeXzgIeDHoDX++RirLM1bvVSxuZb
	ULLSAU790kU1RCkTTF5rb9QOO7mkLnw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-wLSYzuHvPO6DTsUqFYjEcw-1; Thu, 13 Mar 2025 15:12:16 -0400
X-MC-Unique: wLSYzuHvPO6DTsUqFYjEcw-1
X-Mimecast-MFC-AGG-ID: wLSYzuHvPO6DTsUqFYjEcw_1741893136
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c0a89afcaaso258831385a.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 12:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741893136; x=1742497936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eu8Zt5JHKLInYlZV//fPfzrbXAHVXgUz1d/jNhTgXBA=;
        b=hO2upGk1kh3IBiCr5M1QCtgFLIyquiMhrjVAN5pgOHSrkxCOwPT16GwqOdMUZyzMz+
         saQBzoplj2Vfh4jjHbIt7WI5+51Kna52RyW7AWZfZOZj258KM3ZlX4sQPgd7TGftyKBZ
         USDp3SmCuofy15cIcwtBHfLztoPhs5gAz18M3iP0tqIyzxvDJlKuXAKgCJMwVAxEOBqT
         eh8AYFzqKyZK/V+a6nQJf2S+VVJyEGJa3fki/BHpMZgV2Q9DUrFvrL1PkqSpZP+o6CyL
         kYQUf0zm8+Y4TzFC4ps8QA/Y4aPeG5pMhLlWt/UsovwwfHreNfEZ1+bgUdsRnMc7J7hU
         FDhA==
X-Forwarded-Encrypted: i=1; AJvYcCViErukImKxRrf6Fz01MLHKhO3LK/lFbMiN+BY+RVUDw1n9GJ0mSxffJ4Cy7ljjViVyZGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6C7qzrbFxd8y3cTAnxFs7rMcj74z1fAy+L5cvOr0s02HNjNJS
	a+j/yxZAD7VKNPvioinAcxJzilxfMiTeShX4Dv5HknScS7cxKZcrexgxUc+fR9kGwK9MkuTRoMh
	RtEeXyPJfqeSLSK2jW9BfpiUloVMEwgKR3DRl5npLZiquCUJ7NQ==
X-Gm-Gg: ASbGnct4yOm+1CRp6OAPwUrOuPSqLx3DUY1nmSEz/pDTFf/nkWOjuYGiSyd2eZtkwfV
	UgJndTulQDaAevIHA+1SLayHNyyTgPYeCz6a1IUesPrvvAwGk/HPXbTWYrcPMoqzIp9ixwp7Q73
	x9ua26t0iSqbNfpt2VN/DTHUIiX99eGsjOSnj0OyITLTt9a2Q+2IjyOEPCRoMSvrgGnWyvYWGUv
	wBCYrrrPJSvvdTr33tSNdVBZoY1S4PwPG70BFcewuG3Kr0E6CyM3/kpbpHq/S2nI5/JhLcJtEd4
	Pi1UzOE=
X-Received: by 2002:a05:620a:838f:b0:7c3:c13f:5744 with SMTP id af79cd13be357-7c573713527mr744171385a.3.1741893135764;
        Thu, 13 Mar 2025 12:12:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmL8wnHI3XvOc6TmOoi5mIyx1LyijkYTY/k9F1G3PKJ/9z/mlexd/aqNP663C+GN+ActHxCA==
X-Received: by 2002:a05:620a:838f:b0:7c3:c13f:5744 with SMTP id af79cd13be357-7c573713527mr744166785a.3.1741893135438;
        Thu, 13 Mar 2025 12:12:15 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573d89ad6sm130678585a.102.2025.03.13.12.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:12:14 -0700 (PDT)
Date: Thu, 13 Mar 2025 15:12:11 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: James Houghton <jthoughton@google.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z9MuC5NCFUpCZ9l8@x1.local>
References: <Z8YfOVYvbwlZST0J@x1.local>
 <CADrL8HXOQ=RuhjTEmMBJrWYkcBaGrqtXmhzPDAo1BE3EWaBk4g@mail.gmail.com>
 <Z8i0HXen8gzVdgnh@x1.local>
 <fdae95e3-962b-4eaf-9ae7-c6bd1062c518@amazon.com>
 <Z89EFbT_DKqyJUxr@x1.local>
 <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>
 <Z9GsIDVYWoV8d8-C@x1.local>
 <7c304c72-1f9c-4a5a-910b-02d0f1514b01@amazon.com>
 <Z9HhTjEWtM58Zfxf@x1.local>
 <69dc324f-99fb-44ec-8501-086fe7af9d0d@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69dc324f-99fb-44ec-8501-086fe7af9d0d@amazon.com>

On Thu, Mar 13, 2025 at 03:25:16PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 12/03/2025 19:32, Peter Xu wrote:
> > On Wed, Mar 12, 2025 at 05:07:25PM +0000, Nikita Kalyazin wrote:
> > > However if MISSING is not registered, the kernel will auto-populate with a
> > > clear page, ie there is no way to inject custom content from userspace.  To
> > > explain my use case a bit more, the population thread will be trying to copy
> > > all guest memory proactively, but there will inevitably be cases where a
> > > page is accessed through pgtables _before_ it gets populated.  It is not
> > > desirable for such access to result in a clear page provided by the kernel.
> > 
> > IMHO populating with a zero page in the page cache is fine. It needs to
> > make sure all accesses will go via the pgtable, as discussed below in my
> > previous email [1], then nobody will be able to see the zero page, not
> > until someone updates the content then follow up with a CONTINUE to install
> > the pgtable entry.
> > 
> > If there is any way that the page can be accessed without the pgtable
> > installation, minor faults won't work indeed.
> 
> I think I see what you mean now.  I agree, it isn't the end of the world if
> the kernel clears the page and then userspace overwrites it.
> 
> The way I see it is:
> 
> @@ -400,20 +401,26 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>         if (WARN_ON_ONCE(folio_test_large(folio))) {
>                 ret = VM_FAULT_SIGBUS;
>                 goto out_folio;
>         }
> 
>         if (!folio_test_uptodate(folio)) {
>                 clear_highpage(folio_page(folio, 0));
>                 kvm_gmem_mark_prepared(folio);
>         }
> 
> +       if (userfaultfd_minor(vmf->vma)) {
> +               folio_unlock(folio);
> +               filemap_invalidate_unlock_shared(inode->i_mapping);
> +               return handle_userfault(vmf, VM_UFFD_MISSING);
> +       }

I suppose you meant s/MISSING/MINOR/.

> +
>         vmf->page = folio_file_page(folio, vmf->pgoff);
> 
>  out_folio:
>         if (ret != VM_FAULT_LOCKED) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>         }
> 
> On the first fault (cache miss), the kernel will allocate/add/clear the page
> (as there is no MISSING trap now), and once the page is in the cache, a
> MINOR event will be sent for userspace to copy its content. Please let me
> know if this is an acceptable semantics.
> 
> Since userspace is getting notified after KVM calls
> kvm_gmem_mark_prepared(), which removes the page from the direct map [1],
> userspace can't use write() to populate the content because write() relies
> on direct map [2].  However userspace can do a plain memcpy that would use
> user pagetables instead.  This forces userspace to respond to stage-2 and
> VMA faults in guest_memfd differently, via write() and memcpy respectively.
> It doesn't seem like a significant problem though.

It looks ok in general, but could you remind me why you need to stick with
write() syscall?

IOW, if gmemfd will always need mmap() and it's fully accessible from
userspace in your use case, wouldn't mmap()+memcpy() always work already,
and always better than write()?

Thanks,

> 
> I believe, with this approach the original race condition is gone because
> UFFD messages are only sent on cache hit and it is up to userspace to
> serialise writes.  Please correct me if I'm wrong here.
> 
> [1] https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co.uk/T/#mdf41fe2dc33332e9c500febd47e14ae91ad99724
> [2] https://lore.kernel.org/kvm/20241129123929.64790-1-kalyazin@amazon.com/T/#mf5d794aa31d753cbc73e193628f31e418051983d
> 
> > > 
> > > > as long as the content can only be accessed from the pgtable (either via
> > > > mmap() or GUP on top of it), then afaiu it could work similarly like
> > > > MISSING faults, because anything trying to access it will be trapped.
> > 
> > [1]
> > 
> > --
> > Peter Xu
> > 
> 
> 

-- 
Peter Xu



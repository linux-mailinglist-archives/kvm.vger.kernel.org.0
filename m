Return-Path: <kvm+bounces-37249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1A0A277FD
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F12FC188687D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C7A216385;
	Tue,  4 Feb 2025 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUqr4Trz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17924213E9A
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738688984; cv=none; b=DGYBu0zSd9WbL4r7+5WkWAjdOAbt++jvysY0WEE4OQh2jRluCdkhPqDTtRFiDBUZnoH9/nDom9FRh3pH7jLo1clgLtud/qtrrM3tO7Zsnhn8ohwBjmHppxE9JSJtzAzQB/h8Ah0T3tTsFEeVz58d6D3ALut6BKYknoZG3mGUZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738688984; c=relaxed/simple;
	bh=I6UOEzcPxmMR5SA3Jwo/Ivg7oHFWedPCHnCvH98JMQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvJLdTxEkL3DgoP3lsRzd1f/3V9CWxRaulc5Z5L9H//HbUM2oB+LOety+MA5EzkfkU5YZggWJutaDaI/V/62hn1zDd/TkKMHxvfZCAfh6mbfKB1KSpDDxhfSv06E3lOGLHAqxXK9GuVQLrx4WIN4NEnd3GP7njCOzsfnVYHQdnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eUqr4Trz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738688981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MixZuTPd0vMsw7h9RgZuz45+Lso91h1jNJV5awYBfHA=;
	b=eUqr4Trzx/p8eG1NuMxzolCwg++XUAAJJLobUC89az4mCl9liXIbkMvpLVy9mkhw8Qpmz/
	SlW2p8+zC/uoM3vOG7cMdrqaH0/WsfKx9MkvWw6HWG4Fc79ueZDr0FibZTlOm0gJ3j2s2X
	vZWssPYRs6mz/Nbpff2B2C7lJ7ttDZw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-vhsoXP9bNnm_GQT9zkAaTA-1; Tue, 04 Feb 2025 12:09:40 -0500
X-MC-Unique: vhsoXP9bNnm_GQT9zkAaTA-1
X-Mimecast-MFC-AGG-ID: vhsoXP9bNnm_GQT9zkAaTA
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4675c482d6cso108912251cf.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:09:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738688979; x=1739293779;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MixZuTPd0vMsw7h9RgZuz45+Lso91h1jNJV5awYBfHA=;
        b=LpZiirJC99twLfeLGke3DKYNM7yBZ5/A6gGQ8J7oVpjxWZ88JNDgZGbm9czP/A6wtp
         cdvh1INQMtJfFu/4Gxp/jULRqqup3ntpVIvQ+IF6/yoxp6rdHBu5dK7olopDInBbAbeG
         jxCQ/NW/vyDk3uuLJe417S9uBqqSS2fStiHUNUIH23GtIWkG/0RuCuntyTo5gifR6NUQ
         Ptsk1doDEm8Yv2jRrPckcJkqhAYThAiRsKagBu9xD44tM9a51NUDhQ1jLnWuXZDSxouu
         RGTcS78deoc+rNG4S5ZJRtP2sbILwcChwcdyeFVi+eE+JVYPZ9ZAEm4Pyrjk5EX3au0Y
         Vn1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwMuABdxFd98F5xJfVe6kRluB45yw7O8JXZVEgUrlVYWBn/CHqglfqNviNCWjah/zBmQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqQJ1coD7aFsb7ON8YZioJhODQNQM3zMQr9hECY9P7vxpxX9oA
	XhqiwV5LWZiFl0NGdKo6lAipNuusWCgEZPQE84XUB8HS1OjYWvJDImI8xjkKp3UyRgpfGnZ/B7X
	RZRppU60tlXAX+oTz3vN3438RCPbg94gUHIrRM+mt9fs7X4oAcQ==
X-Gm-Gg: ASbGnctOrsA9o6S372xzUQzFFdDFyx5+CGOEq5mrVB5ibwn0dENASHuyXmrYofuTA2J
	fhP3jzUBrjXz42BlB/Au/6tL4mKfSVOIPApwip8S46mv5k1/VkumoRXFcz+xS7WMJnXLflMIqHA
	3IsmaWzUIxJbLGDanWvIilEHQYACzGE9LVJrR9sS5TG/l07JeeImMSjClXmV1fACGGQYENyE2zV
	kEicg1iU2+yuXp2mYvjosaum8fEkJQmb+HlBbkpr/hcJXZG/dzITs5NT1KNf3+8S9D59LCSiBVC
	puKshmBtyg8wNgSB2Gdq8Y8XuwNjDIkoClz8B44Vj9Ga5lc8
X-Received: by 2002:a05:622a:1e8c:b0:466:a308:292c with SMTP id d75a77b69052e-46fd0b6f3dbmr421300221cf.32.1738688979508;
        Tue, 04 Feb 2025 09:09:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXKpGyny5yszYPGxO1L8KpdaLn3zBgJgFYl9aN2bthczbWuJ+WK9AMia+mq+ibrmkoydDEDA==
X-Received: by 2002:a05:622a:1e8c:b0:466:a308:292c with SMTP id d75a77b69052e-46fd0b6f3dbmr421299861cf.32.1738688979137;
        Tue, 04 Feb 2025 09:09:39 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf0a72d4sm60457551cf.13.2025.02.04.09.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 09:09:38 -0800 (PST)
Date: Tue, 4 Feb 2025 12:09:37 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 2/6] system/physmem: poisoned memory discard on reboot
Message-ID: <Z6JJ0fDjkttUcW7n@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-3-william.roche@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250201095726.3768796-3-william.roche@oracle.com>

On Sat, Feb 01, 2025 at 09:57:22AM +0000, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Repair poisoned memory location(s), calling ram_block_discard_range():
> punching a hole in the backend file when necessary and regenerating
> a usable memory.
> If the kernel doesn't support the madvise calls used by this function
> and we are dealing with anonymous memory, fall back to remapping the
> location(s).
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  system/physmem.c | 58 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 3dd2adde73..e8ff930bc9 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2167,6 +2167,23 @@ void qemu_ram_free(RAMBlock *block)
>  }
>  
>  #ifndef _WIN32
> +/* Simply remap the given VM memory location from start to start+length */
> +static int qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
> +{
> +    int flags, prot;
> +    void *area;
> +    void *host_startaddr = block->host + start;
> +
> +    assert(block->fd < 0);
> +    flags = MAP_FIXED | MAP_ANONYMOUS;
> +    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
> +    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
> +    prot = PROT_READ;
> +    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
> +    area = mmap(host_startaddr, length, prot, flags, -1, 0);
> +    return area != host_startaddr ? -errno : 0;
> +}
> +
>  /*
>   * qemu_ram_remap - remap a single RAM page
>   *
> @@ -2184,9 +2201,7 @@ void qemu_ram_remap(ram_addr_t addr)
>  {
>      RAMBlock *block;
>      uint64_t offset;
> -    int flags;
> -    void *area, *vaddr;
> -    int prot;
> +    void *vaddr;
>      size_t page_size;
>  
>      RAMBLOCK_FOREACH(block) {
> @@ -2201,25 +2216,24 @@ void qemu_ram_remap(ram_addr_t addr)
>                  ;
>              } else if (xen_enabled()) {
>                  abort();
> -            } else {

Do we need to keep this line?  Otherwise it looks to me the new code won't
be executed at all in !xen..

> -                flags = MAP_FIXED;
> -                flags |= block->flags & RAM_SHARED ?
> -                         MAP_SHARED : MAP_PRIVATE;
> -                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
> -                prot = PROT_READ;
> -                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
> -                if (block->fd >= 0) {
> -                    area = mmap(vaddr, page_size, prot, flags, block->fd,
> -                                offset + block->fd_offset);
> -                } else {
> -                    flags |= MAP_ANONYMOUS;
> -                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
> -                }
> -                if (area != vaddr) {
> -                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
> -                                 " +%zx", block->idstr, offset,
> -                                 block->fd_offset, page_size);
> -                    exit(1);
> +                if (ram_block_discard_range(block, offset, page_size) != 0) {
> +                    /*
> +                     * Fall back to using mmap() only for anonymous mapping,
> +                     * as if a backing file is associated we may not be able
> +                     * to recover the memory in all cases.
> +                     * So don't take the risk of using only mmap and fail now.
> +                     */
> +                    if (block->fd >= 0) {
> +                        error_report("Could not remap RAM %s:%" PRIx64 "+%"
> +                                     PRIx64 " +%zx", block->idstr, offset,
> +                                     block->fd_offset, page_size);
> +                        exit(1);
> +                    }
> +                    if (qemu_ram_remap_mmap(block, offset, page_size) != 0) {
> +                        error_report("Could not remap RAM %s:%" PRIx64 " +%zx",
> +                                     block->idstr, offset, page_size);
> +                        exit(1);
> +                    }
>                  }
>                  memory_try_enable_merging(vaddr, page_size);
>                  qemu_ram_setup_dump(vaddr, page_size);
> -- 
> 2.43.5
> 

-- 
Peter Xu



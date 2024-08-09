Return-Path: <kvm+bounces-23735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A05FC94D524
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3097B1F21D4C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0A53A1A8;
	Fri,  9 Aug 2024 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3dnOSgN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F43321A3
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222789; cv=none; b=Oz49v2DiAtCcTJLTvjzBPnlL2yYl8h0CsTSwf1Lkhs/IqNL0LQvr5iHe+LeQkSmKxZRwqFwWjcMuIKgSzbpGeq96EoPK8ZROFx2Y7dS50ZQyQyoGjdGyeKyXbKHKQCpVa2GH1NMdAD6xmnX6VtjTHpYyfDa9k5rCZP0B5NBOCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222789; c=relaxed/simple;
	bh=LRmfoQ7bRPL7TE4kwyHxzBUsQnz982hdoFu9pvJtp/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8KAX0ppxqLgj49iooXjP71ym/EJSTAPcH+FtGI03mDo0QzECAfLWSuy3z08juIRLrsPmVWKSBL8UtsnQz+t2Iv/gBSNzKaxFkiijjzbUiWlhu2SD/DdqOREtNNF/gCRDFsyDnzBabPIm/OmKvxjEutbotmv3IijKqenvJ/tDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H3dnOSgN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723222786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vBISjU3wc8bbFt9cGZRVmI4aFRJJnxKYVQ2bi1B1P4=;
	b=H3dnOSgN8i2J+E0H+DdeE3dz0h9otkeLD89l+9za+Y1rhr0+WVZcQ4YPVnKm2yIAe12l5f
	+7xCR672tqqTW/VN1CHxYhGIyhZpSoaA7QQMTzgkt4K6wtL47w7zCzGpDLAPSc8LuTks1+
	R3Pu9OZOMYg16MmeuLPmVJVyKfqsbhI=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-r7du4J1DOR2adn1l0SG66w-1; Fri, 09 Aug 2024 12:59:45 -0400
X-MC-Unique: r7du4J1DOR2adn1l0SG66w-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3db181f240cso197030b6e.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723222784; x=1723827584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vBISjU3wc8bbFt9cGZRVmI4aFRJJnxKYVQ2bi1B1P4=;
        b=Nv3Eyc7ZsYgTUTAlZwEqxMmF4XGbt7Z7bJMrVJYSs/BWeXBvtOsnWLwQKtWCzWqGzr
         p1mCMiXL76e0pdEDyTnX6zyEo2YTC0YiV1XItJKi1tt0p18XCZGAGXhqky+q/NtA3YLk
         ba0OSdMfTTlfnhat1jaqZ3O4cT6b0Xl1oaZG16ZnnPCmAnB06M4WM5HxIiarlgwwydDz
         lAHWzCux0tb9Q593dK8wReFFMGj3A78v6r/pXz3U3mrQwH59K6Oe0CxjWnrtfHIF2t64
         PBBPy+/iqKRse9dh2ntkx5u1jzz8IPY2WZz7lWs4NmT6en/Ku2u8O/BmvXth6TzESKDR
         WR6g==
X-Forwarded-Encrypted: i=1; AJvYcCWqqftF0ePUWKPfDdXXcGtmcjHkKHc4HtCQEi/KRSc8qGopzevflBrmsEPe/8KJbhPZNwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmFKtpY7I3UwvrpZ/iuBLptdCRn0kbKbhi9nosyAamf8tJcxhx
	UHgkI3c0YQdmstr5IrSnEqAO0BNK4VmZAKxR+qRa0co99SRguk8vPCxOWq+HIYC8Dg1JFgLCZoj
	QUab5y5rgkXlXc2YXcrbar1tjnAECfOizr3VXlhnSxLRFECzT1w==
X-Received: by 2002:a05:6358:e498:b0:1ac:ee25:ea01 with SMTP id e5c5f4694b2df-1b176f25c65mr138666555d.2.1723222784506;
        Fri, 09 Aug 2024 09:59:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhzrEIAv0YtSNyCDkni9NvGO/yGcX0KWO+ywGAIyNJzMZXEzyIqhBTcGWxs3CX0V3QMBcTvQ==
X-Received: by 2002:a05:6358:e498:b0:1ac:ee25:ea01 with SMTP id e5c5f4694b2df-1b176f25c65mr138663855d.2.1723222784120;
        Fri, 09 Aug 2024 09:59:44 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c79ba4asm78773856d6.36.2024.08.09.09.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:59:43 -0700 (PDT)
Date: Fri, 9 Aug 2024 12:59:40 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 05/19] mm/gup: Detect huge pfnmap entries in gup-fast
Message-ID: <ZrZK_Pk1fMGUCLUN@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-6-peterx@redhat.com>
 <67d734e4-86ea-462b-b389-6dc14c0b66f9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <67d734e4-86ea-462b-b389-6dc14c0b66f9@redhat.com>

On Fri, Aug 09, 2024 at 06:23:53PM +0200, David Hildenbrand wrote:
> On 09.08.24 18:08, Peter Xu wrote:
> > Since gup-fast doesn't have the vma reference, teach it to detect such huge
> > pfnmaps by checking the special bit for pmd/pud too, just like ptes.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/gup.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index d19884e097fd..a49f67a512ee 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -3038,6 +3038,9 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
> >   		return 0;
> > +	if (pmd_special(orig))
> > +		return 0;
> > +
> >   	if (pmd_devmap(orig)) {
> >   		if (unlikely(flags & FOLL_LONGTERM))
> >   			return 0;
> > @@ -3082,6 +3085,9 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
> >   		return 0;
> > +	if (pud_special(orig))
> > +		return 0;
> > +
> >   	if (pud_devmap(orig)) {
> >   		if (unlikely(flags & FOLL_LONGTERM))
> >   			return 0;
> 
> In gup_fast_pte_range() we check after checking pte_devmap(). Do we want to
> do it in a similar fashion here, or is there a reason to do it differently?

IIUC they should behave the same, as the two should be mutual exclusive so
far.  E.g. see insert_pfn():

	if (pfn_t_devmap(pfn))
		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
	else
		entry = pte_mkspecial(pfn_t_pte(pfn, prot));

It might change for sure if Alistair move on with the devmap work, though..
these two always are processed together now, so I hope that won't add much
burden which series will land first, then we may need some care on merging
them.  I don't expect anything too tricky in merge if that was about
removal of the devmap bits.

> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks, I'll take this one first.

-- 
Peter Xu



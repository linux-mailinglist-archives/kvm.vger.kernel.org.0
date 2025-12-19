Return-Path: <kvm+bounces-66344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6328FCD07C7
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:23:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88195307C6DB
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531E1341046;
	Fri, 19 Dec 2025 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAr0hO7p";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YZMludSz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34EB337686
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766157245; cv=none; b=YqGkTQ6Iso4JqbmWXl9XHgtap1e6anPEVDyqFsA1R1q8gXyR/hk4ioSPW5z5ETTBLEX+vjhTy2Zaon5y4z1oUKxllcQ3eVHUMIE5xcm7s0x2tGgqL81n6FE6LRXv+PHDcaCaHxuB3uIi3ZQuQlObYYaPUB+sRswI0/k0s9XWr/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766157245; c=relaxed/simple;
	bh=oXqoz/X+GrdvsLQwZMjeFUnj5NtqxOmwpdMteHyEekA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nS3ldnsdxArlg4hbEAUSMbDAbvyqaVKtWPskYpXM0ozE2QRiW8saKJMGR6Xdp/N7EzAeZGayURKXmTzvpwqyO7LseFk3bRWe+CkGyW+AOjo7GRdbpggPvqnhBfjUUiBt+9pv43TrIcDNEeKIblDDXz2/ntmgMsnTKxipANFbDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAr0hO7p; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YZMludSz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766157242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
	b=GAr0hO7pbPqB4ImEIFbmk36Ij+4idiQRgm/TUe9aXoKWbnq3dINLLJXd0UX9sS7evIWDE/
	6AjpY65Rzp3ILMyzYL6iUXmD+FLUh8u+wrUITK3mAmOjxkwz8HWq1d8uvjoUrLY/IykT4Q
	+bstjRqgKgGhYG+T0EDTb1IyL8sK3pU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-QH6fGVvwOCmaRq9pwXBEmQ-1; Fri, 19 Dec 2025 10:13:05 -0500
X-MC-Unique: QH6fGVvwOCmaRq9pwXBEmQ-1
X-Mimecast-MFC-AGG-ID: QH6fGVvwOCmaRq9pwXBEmQ_1766157185
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b6963d163eso420292185a.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 07:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766157185; x=1766761985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
        b=YZMludSzcYitr2lKjKzXJI9ZRWILwHpH2GX61hdMYgUUf8k2H3mjFWYGoDB+A3Rzo+
         iJRyg3TqIU5hMNvX1BHipJApkllmLY7kZFgqEDFFo61qAcOMV3K6BJEHB19/OETSbILJ
         smesWM82ybjeZcvWBSM1FzZ749kRZx4tGbMACd9CAvNiXFSxNOT3+j7PLI7jQKBj8JJt
         L+51/rHnlixAZz5t4ozlG+PpgM8aNakmlasKPGt06pfSV5Y8Ao5rWhGl1MZXkiFySgxq
         NxMDsOzAhpBkECZFXdVnqXM5e2Xmia5eT0cUGQlWGJkKI49Kl5807vNLlGkmFiIvn0kq
         GGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766157185; x=1766761985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
        b=s9JiGIeegjNWl7pWRBoG8mw8Y51JG6uUFZaL9EzDkdcMbXQisw8MxUSM9eGLIxEatj
         VjcwEBOP0j0MrrAG6VyksRgUS0Vd4yO4G3DKAauEfJqZIVv1+EPljJC+1GKJHv1lKkPN
         p4juT+ocNpgBIMya4W0EPsmxc7vR9MJfSxhwm8DruNSLKv4oyHQPnpzVGbnPfyKN9mTN
         ZsgfPExgcFlKn6hb8fp7qGZF/Lb9iWxXuWnophoPRZwXT3lNm1YkA5yGb9o1AtV1Nq03
         vs99pHn+0XZ+i9qOXXRCh5lYblFyAfK8h8bDgHZI4JeXfVYkGFRdi6Ieu0idG7w+WkET
         OsYA==
X-Gm-Message-State: AOJu0YxKEjn49q/Ja1rQQOf7KhEHfA1FbLRRfo4lX1sI3u2SDy1Eyy4C
	MDwPGM5yUCzK8e+061gzEe5UzrfR/gxUhq9vJzSGgQ4YHrgQB5KxCvpUzdSYO7geLiAqM4vmpf4
	TeRlwm3ZWoD+BMsAgC3ljchBKcHNOZxDnAhjidDV+O6Y9Ksk0mIJ3DA==
X-Gm-Gg: AY/fxX7ao1rwcWLvy8AKVX3q0EkOUyM/fMRePi4GjzHMeRiBX+hzWVx1w+8YxNBk5zc
	No7FFkA05MT5/CukKp9VwfD4fNV/xND/zWsLEbkngl9dUWwpI3rYymh/X0Oeua4xZZDar57S7Ap
	4D80PxwywKaucU7a86fraQNfilYjIKGr2jsJTmLm+vKxMXTehEnrykpaGYmzbLaSWMO3zhgEUeu
	DsFZB7je95eKnL27CGH3K89Mod1zW5GrzxZ/0/2QQpqBUGydB8bGlHZNxyrFSmewh7HSTqPY/9X
	G3kFytXrIQr4dljPXUog3n333EfMH+oDzDZMSwrN58dbYkz+j2vgsX0XGb9SXBEJwtr1TQuxqV/
	rumo=
X-Received: by 2002:a05:620a:2545:b0:8be:92e3:916a with SMTP id af79cd13be357-8c08fbd08c5mr525924785a.88.1766157184858;
        Fri, 19 Dec 2025 07:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEABygr+TjXx8kPMcVgd88EC2i1KOIT0Poa6j5o9tNZ+dAjo/xEl7EzQTikQ39L491y0GI2Tw==
X-Received: by 2002:a05:620a:2545:b0:8be:92e3:916a with SMTP id af79cd13be357-8c08fbd08c5mr525917085a.88.1766157184316;
        Fri, 19 Dec 2025 07:13:04 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973f28e3sm210526485a.45.2025.12.19.07.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:13:03 -0800 (PST)
Date: Fri, 19 Dec 2025 10:13:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUVrfs1w6Sg0jfRw@x1.local>
References: <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
 <20251219145957.GD254720@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251219145957.GD254720@nvidia.com>

On Fri, Dec 19, 2025 at 10:59:57AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > > let me know; some example would be greatly helpful.
> > > 
> > > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > > for the new op.
> > 
> > When it's "related to PTEs", it's talking about (2) above, so that's really
> > what I want to avoid mentioning.
> 
> You can't avoid it. Drivers must ensure that
> 
>   pgoff % order == physical % order
> 
> And that is something only drivers can do by knowing about this
> requirement.

This is a current limitation that above must be guaranteed, there's not
much the driver can do, IMHO.

If you could remember, that's the only reason why I used to suggest (while
we were discussing this in v1) to make it *pgoff instead of pgoff, so that
drivers can change *pgoff to make it relevant to HPA.

I didn't take that approach as I want to make this simple until it's
justified to be required.

It holds true for vfio-pci, I hope it holds true forever.  If not, this API
will stop working, afaict.

-- 
Peter Xu



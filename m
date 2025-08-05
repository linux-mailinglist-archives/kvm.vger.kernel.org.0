Return-Path: <kvm+bounces-53951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1159EB1ABD7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 02:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E684E7AF4BB
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 00:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9183318A6A5;
	Tue,  5 Aug 2025 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIcRLs7q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FC986328
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 00:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754355194; cv=none; b=lk8Orm+G363HgCEHqwRzVJE17XQVqxzMaOt1lUqTSD877sCTndsurTWb5TdHnT1AlxlcJ+ILRT6xLrkixQkb66121KYm3ooW0Fy4V39DLO/Pw1qG4v1aDFRRbA6mgYHfir2l15pWfrwD5qRLHgL2VqCKWXPAGqE9hpA2ubyhFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754355194; c=relaxed/simple;
	bh=ULbWprUAeDypBWWImqY9zeaREYEjhTsBCADwode3OKs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZI7qPJK767+dvc02uM9Cm7FBir4eGtYGk9RVc3uWDwu+1kgwAyclIvlHZWIC50a6V2BBnRPfQat3+PvhI0DmdDPeUO1B0u9MQarkVV1KEa7DW+qXXugAXgOg2mwMXjIo9q9f9vcLcnd6GGr7DpP4vC5z3gLbsKedhLkuMvYpHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIcRLs7q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754355191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RrkV7nnIz65Rct4AsWHUosFboVNhtBP3xeSz5J6Txf4=;
	b=eIcRLs7qlFBSEfJesq7ifV6zz1y3dKoZF6U76MI4HKN+5sfw52PcK7K3yqFhpxG/I2H/BH
	dXFTYo8P/Du7814JYXoFQb6nbJvsV2Qhmvvmea7YLSmmMxDRSfFIpRZIyyVVV96t/n6uTG
	K2T0uRcX0n9j7JnAkcUeJZp8ZUaewYk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-V5o94n17O_OJYo_gMOnYUw-1; Mon, 04 Aug 2025 20:53:10 -0400
X-MC-Unique: V5o94n17O_OJYo_gMOnYUw-1
X-Mimecast-MFC-AGG-ID: V5o94n17O_OJYo_gMOnYUw_1754355189
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e3d91ee461so9813525ab.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 17:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754355189; x=1754959989;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RrkV7nnIz65Rct4AsWHUosFboVNhtBP3xeSz5J6Txf4=;
        b=q482siiy+hCUfFFIHTwQGd2Gg3dHMPU5hXGed/2N+yIXScenRWpqC7p5hU+8L9g4z+
         RCBOivURpDTnpuN0yO6HXlI26vqv7lYN7v0lLFcdBnv1QcNCCQNtwGgZS67PFrmmdBMf
         qPqOKrZ27fqSYyaNmlPROd5b1v952eQEmlnV9E7GIR1MiqTE1gAr0Oc2M7d07OJ649h3
         d3B3QfA9FqgawRRudzfAfC9ujIxL+Cj0PtHxFJvJubZoE1MqK09sHU6gEK7qKhST1o5y
         cOS0Db0N1PeN/vJL4IV0s4hShaP47Oq3DZU7KUGEHH/ipgHNjCaDVi3PZ/qPUHACl4R1
         lftQ==
X-Gm-Message-State: AOJu0YzEQmu5IuIeJTHTMOKHh1RtrnjMrRWUvQgc85/FBSfg9p1yVoqI
	n2yLW+3MCPKIXAO+demYPKMzbt3p5srvXr6dBHLRTNwJSTGkIco1KjEeejhe5aWqE+r+AANf3V0
	sAeZfAEKrJURsftjY182JJXjVydwt/7oKrLFMPyZgaJ6oxLAA1rrB0w==
X-Gm-Gg: ASbGnctQPRIBYAQ/sL27Gp8HhT8hZLjjmC11l/GQ1f2+/N/rVhZyfv29V3i1/lWmluS
	eBGILVeLuk2Ru9VIQ2tayuiMP1zZf0T99HJFBZpEqivoQvc2eC/EdUM2dqb8AMlb/xN2mmuYy0u
	8RC8+LMVprHm1g7lJXdZpg+g+xJ8eVehAVqfvVWMA7SNYpYx1NloeXF106/KSkMHNK4M2ehKk+K
	hsGSSQkaiY0nMg/EEaNOS6ot86U9vYtZhl+qBLHt6+pxeiUjCXxykwp32uC4OFhlxj4mxB9FpEE
	R+vE08Ve5eziKZHDZFAP6q0e+yGFy6RwMz1J8y1/lwY=
X-Received: by 2002:a05:6e02:3f0b:b0:3e4:535:5961 with SMTP id e9e14a558f8ab-3e4161cb0c6mr53092115ab.6.1754355189513;
        Mon, 04 Aug 2025 17:53:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkV2KGD4nZrnkN12HT0e8+FaVhlp1aAYb4fvL2K+dBsk80LdQ83aqIUQef1e9gI2lUPCQEZA==
X-Received: by 2002:a05:6e02:3f0b:b0:3e4:535:5961 with SMTP id e9e14a558f8ab-3e4161cb0c6mr53092005ab.6.1754355189088;
        Mon, 04 Aug 2025 17:53:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e4029c1613sm45901005ab.21.2025.08.04.17.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 17:53:08 -0700 (PDT)
Date: Mon, 4 Aug 2025 18:53:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>, Jason Gunthorpe
 <jgg@nvidia.com>, David Hildenbrand <david@redhat.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250804185306.6b048e7c.alex.williamson@redhat.com>
In-Reply-To: <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
	<CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 16:55:09 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 4 Aug 2025 at 15:22, Alex Williamson <alex.williamson@redhat.com> wrote:
> >
> > Li Zhe (6):
> >       mm: introduce num_pages_contiguous()  
> 
> WHY?
> 
> There is exactly *ONE* user, why the heck do we introduce this
> completely pointless "helper" function, and put it in a core header
> file like it was worth it?

There was discussion here[1] where David Hildenbrand and Jason
Gunthorpe suggested this should be in common code and I believe there
was some intent that this would get reused.  I took this as
endorsement from mm folks.  This can certainly be pulled back into
subsystem code.

> And it's not like that code is some kind of work of art that we want
> to expose everybody to *anyway*. It's written in a particularly stupid
> way that means that it's *way* more expensive than it needs to be.
> 
> And then it's made "inline" despite the code generation being
> horrible, which makes it all entirely pointless.
> 
> Yes, I'm grumpy. This pull request came in late, I'm already
> traveling, and then I look at it and it just makes me *angry* at how
> bad that code is, and how annoying it is.

Sorry, I usually try to get in later during the first week to let the
dust settle a bit from the bigger subsystems, I guess I'm running a
little behind this cycle.  We'll get it fixed and I'll resend.  Thanks,

Alex

> My builds are already slower than usual because they happen on my
> laptop while traveling, I do *not* need to see this kind of absolutely
> disgusting code that does stupid things that make the build even
> slower.
> 
> So I refuse to pull this kind of crap.
> 
> If you insist on making my build slower and exposing these kinds of
> helper functions, they had better be *good* helper functions.
> 
> Hint: absolutely nobody cares about "the pages crossed a sparsemem
> border. If your driver cares about the number of contiguous pages, it
> might as well say "yeah, they are contiguous, but they are in
> different sparsemem chunks, so we'll break here too".
> 
> And at that point all you care about is 'struct page' being
> contiguous, instead of doing that disgusting 'nth_page'.
> 
> And then - since there is only *one* single user - you don't put it in
> the most central header file that EVERYBODY ELSE cares about.
> 
> And you absolutely don't do it if it generates garbage code for no good reason!
> 
>             Linus
> 

[1]https://lore.kernel.org/all/20250703111216.GG904431@ziepe.ca/



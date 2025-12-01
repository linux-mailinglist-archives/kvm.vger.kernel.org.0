Return-Path: <kvm+bounces-65037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D13C991CF
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 22:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 560C04E4C1C
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 20:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9528127E05E;
	Mon,  1 Dec 2025 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCyeykkI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYy+il8B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5E6283C8E
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 20:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764622689; cv=none; b=pHyJGk6HiKFMjkW2sFr9SZEyhsSuv6SAYS7V6Zwehs886NN/dAEnps5KToIxJ8daciTWAXuzGm+UgR8pS3qyNJKBmUb5trSNae0cR6H6/blY3NIHT1y/08Apr0uQUVdF9KpwL821zjncGXwgOpgSnBcuH9AxsQsWUIqdSyxbruA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764622689; c=relaxed/simple;
	bh=vsZAi3omBycoWUJakELYM68CvQJgslx/EVgOEpPXSrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNxLhkfPgCU/QASNFIeI/JD04XjJVQCED+sQChurHjjEISOvbDXrRvlzteb2rWK5oAFWmTiaS1abqZsPHfUbyxOG5gv39RBVVt5WONB5mqZcTU6RQp8ltQqqDM3r3k4dDkbqhmdrAIhkU4VL1MW9X0Bdbr1LviFLhG6GAUY+g98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YCyeykkI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HYy+il8B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764622684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
	b=YCyeykkIMpbfcmTWVxj/TW9YWcLCrOXVc9o9I1EP9d7pKAwyTe5r1tFzh5W2rViaA63Voy
	yCeSElZVtMlYDtsNGUuGcyXkrFMY5P3h7ZbX2jpt/96hmGhWUOrj9TVNXjsQdxs6uqzMUx
	56kG2gssWVhFa3gLv0dXq6OJ3p0Q+mE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-qwVHpA_HMKORbsriS-G4Jg-1; Mon, 01 Dec 2025 15:57:59 -0500
X-MC-Unique: qwVHpA_HMKORbsriS-G4Jg-1
X-Mimecast-MFC-AGG-ID: qwVHpA_HMKORbsriS-G4Jg_1764622679
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ee25cd2da3so75734601cf.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 12:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764622679; x=1765227479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
        b=HYy+il8BRM6OuS/S6jKN4CsK8hqz7O5fgdFb2ofNZA4F0ycR7LmJJP+1HFCogn1o1x
         8nhCZbC5C7weDoKS+R+o0Dkibzr3FTOjCXvK5ju8UMjo9yPoZlIfTRhsSqWtpJGjSjDK
         74KOjhuZ6l5K1y0wdQfdYDqO7vfoA4GssB6X+TXtc7+HcjJdgnhsUithHBs3i0aGN4zp
         XWFiGmPHHuTc6sESE9l/k2UQn1OELa9mAwuC8iB1R9uaesUDywJ02eNb3DT2EX/fetyI
         2o1LwnLDaKJ5fp+3Wf54SugJCHAjeupMrNsTkzUlXbG79LoIl1H9Y8fRaEIzIQBMNZlS
         HADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764622679; x=1765227479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
        b=uHe8s7bDEE59XPuJ/66IZr7jQ2L8lgQEbx2TmfARZk9QzQtyr/9aRWMXTDNVZTM4q4
         xwlvy/5tR7hfol37M6pbk1n3ApwL7AxZX7VDu/Uxx+BDL7EOrvrvtSymheFs7p8PeYvP
         oQ/wx/QgkU0hArFGestqNLD0Q3sRrAVn7zdeIB1ZKSN+EbdrviMeaO5wxiFy0hDLKlE/
         sDv1rN3oOfKGhAGNkzaRl7p2X4NzeG0brFQCuAfwCM6/wSKi6+v0zT/uGKS7CE3uT5oP
         3sihHfA/uE3OktX6f08lRIChXn1gkkXuRg8GYK5LEr7QF8chu0YTp7hCr0cxHOAEkiyH
         khEw==
X-Forwarded-Encrypted: i=1; AJvYcCVDrF+H165EnJ3BclqvHGzeo+K3rtp7gclnitFqJafTmk1jDpMUN1rpuEuo5GMp9Vc8mkE=@vger.kernel.org
X-Gm-Message-State: AOJu0YznfD1ncbsYUYtCYsp4D6LK73j1goWkPTyn+66qJ6J6O2+HTpsf
	FejssiEx0K4GTSYjT7P156gJSqnSR3JN3a2ymYy20PVC1NqvoScw1gpl8GLVEEiFRvit5rLJjZg
	+kUC9HeyFEkczwU6LXgmK+SNT6V8ttBk/0sgg2AGE9KQg0mwvALBmcQ==
X-Gm-Gg: ASbGncu0r0XddEykR1v0VHL8BdcFultUBdTmtO2G8dlVC2m4l3QvZ6A0GN5NyjbcI43
	P808p9HoW4nq0GJ2BlZlm6rGVwOurvcHJugU8+5Sh7Q2YEkUuOdNkjJCQ0DudmxNqWHqico76Z6
	+OMb2FHAuEtgLgMCJkDRFRAz+Ee++BKX6QW1X7IKOjKt0CY9YpzXwCSWFO4lqPya4D1L3SXVGbc
	KQwSiuqVanzE3oboEhBQT92DoBRyMa0DhGDbkYJpF/JnaP/dq7AHkoNUMH8DokDWLERudbYy28P
	eFlB3QGPj7NPU+LK6FzH07Yyandy2EltcxpbJemyLT1EXfnUjM37041uUZRh5t9NJcvgtWaSV1L
	nDG0=
X-Received: by 2002:a05:622a:88:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-4efbda33ba1mr388432461cf.21.1764622678844;
        Mon, 01 Dec 2025 12:57:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWk8T36NyEMOMD2WZTIhi05/ouYbVdGm/+oj1BADCz5jW4gqg2t7CwJF5ZBQ/vmsijc1KTvQ==
X-Received: by 2002:a05:622a:88:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-4efbda33ba1mr388431931cf.21.1764622678340;
        Mon, 01 Dec 2025 12:57:58 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2fbb8d1sm82384891cf.9.2025.12.01.12.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 12:57:57 -0800 (PST)
Date: Mon, 1 Dec 2025 15:57:56 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aS4BVC42JiUT51rS@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
 <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>

On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 01/12/2025 18:35, Peter Xu wrote:
> > On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
> > > I believe I found the precise point where we convinced ourselves that minor
> > > support was sufficient: [1].  If at this moment we don't find that reasoning
> > > valid anymore, then indeed implementing missing is the only option.
> > > 
> > > [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
> > 
> > Now after I re-read the discussion, I may have made a wrong statement
> > there, sorry.  I could have got slightly confused on when the write()
> > syscall can be involved.
> > 
> > I agree if you want to get an event when cache missed with the current uffd
> > definitions and when pre-population is forbidden, then MISSING trap is
> > required.  That is, with/without the need of UFFDIO_COPY being available.
> > 
> > Do I understand it right that UFFDIO_COPY is not allowed in your case, but
> > only write()?
> 
> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
> whenever we resolve stage-2 faults as they aren't visible to UFFD.  When a
> userfault occurs at an offset that already has a page in the cache, we will
> have to keep using UFFDIO_CONTINUE so it looks like both will be required:
> 
>  - user mapping major fault -> UFFDIO_COPY (fills the cache and sets up
> userspace PT)
>  - user mapping minor fault -> UFFDIO_CONTINUE (only sets up userspace PT)
>  - stage-2 fault -> write() (only fills the cache)

Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's series?

It looks fine indeed, but it looks slightly weird then, as you'll have two
ways to populate the page cache.  Logically here atomicity is indeed not
needed when you trap both MISSING + MINOR.

> 
> > 
> > One way that might work this around, is introducing a new UFFD_FEATURE bit
> > allowing the MINOR registration to trap all pgtable faults, which will
> > change the MINOR fault semantics.
> 
> This would equally work for us.  I suppose this MINOR+MAJOR semantics would
> be more intrusive from the API point of view though.

Yes it is, it's just that I don't know whether it'll be harder when you
want to completely support UFFDIO_COPY here, per previous discussions.

After a 2nd thought, such UFFD_FEATURE is probably not a good design,
because it essentially means that feature bit will functionally overlap
with what MISSING trap was trying to do, however duplicating that concept
in a VMA that was registered as MINOR only.

Maybe it's possible instead if we allow a module to support MISSING trap,
but without supporting UFFDIO_COPY ioctl.

That is, the MISSING events will be properly generated if MISSING traps are
supported, however the module needs to provide its own way to resolve it if
UFFDIO_COPY ioctl isn't available.  Gmem is fine in this case as long as
it'll always be registered with both MISSING+MINOR traps, then resolving
using write()s would work.

Such would be possible when with something like my v3 previously:

https://lore.kernel.org/all/20250926211650.525109-1-peterx@redhat.com/#t

Then gmem needs to declare VM_UFFD_MISSING + VM_UFFD_MINOR in
uffd_features, but _UFFDIO_CONTINUE only (without _UFFDIO_COPY) in
uffd_ioctls.

Since Mike already took this series over, I'll leave that to you all to
decide.

-- 
Peter Xu



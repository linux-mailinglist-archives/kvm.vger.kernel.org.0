Return-Path: <kvm+bounces-70890-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Ch6L0HajGlIuAAAu9opvQ
	(envelope-from <kvm+bounces-70890-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:36:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3040112732F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:36:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0AFE3029E6D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 19:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967CA3542E7;
	Wed, 11 Feb 2026 19:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="baG4KHJq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="awuxn6O/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD9352F92
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770838540; cv=none; b=eUcHF7L2YZjvmo6xKp+ZRWjbw8IUDYC+UgnAmRxJGBNqs91jCjwdPvetqpPEd3WeQNZs5FeItUZJJbkwYCft1LuW3s+BwswExVG9I+rmx9ttVaEhGf5GChWKLqqR2NOl1Qs0nm6OBNBx4eq54PFOgTehNEvUgBcFLKp2jofSLlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770838540; c=relaxed/simple;
	bh=kLqcLZsDQ9l50Dv8gTv/4rexnpIHIVZchPmWgXkcMhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tk8BiTcDtIN97veYqeqkY6Vh5LS3uA4pOTeT8FBKFz0n+JoczZXnNA2fcT7H0nhXpOS1sX4NUWdudQEBK1RinzchapeJvq657YG5rcRDfGVMiPk5TDBl1r+41WMWgxOOYk2xW1eyfW1EzgI78CsJ3ssGu5lN9aZtBSH4sbGdvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=baG4KHJq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=awuxn6O/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770838538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
	b=baG4KHJqInD+sIF+F8t0TEtdyb5leB8tDvQ04fXgR8vMXhpBJMOJssxvE5wVKZanDW4cd4
	ZuZfIpAG0visRLJDTUR1ewemqd04+EUx5DTp2rUZlsv+rW1MfrYbxvwc+S1bSglYY3hI7P
	geBMa+inEvOTAGS8/0kghzqwelX94ls=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-dq1QU_USNyezca_JO2bZ-g-1; Wed, 11 Feb 2026 14:35:37 -0500
X-MC-Unique: dq1QU_USNyezca_JO2bZ-g-1
X-Mimecast-MFC-AGG-ID: dq1QU_USNyezca_JO2bZ-g_1770838536
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89493622b50so38620726d6.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 11:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770838536; x=1771443336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
        b=awuxn6O/CjPTmDjDvH92FtKXOGRayEYOkBFl9fiz7QpuJ7cO/XMCWcVk986cO5L0pU
         F7EY/76ca4QwKcnqsFCzI+LrAY6QKNePLlJ84cCWWxQJrusVjpIlArW8moWPrHhvxiN9
         7sVTvxpAxvCH+0IDv3G0tYJJq1L27n0qchcAXdkmG0C5u4wqyxMDzHCFgJcRvEp9al6Z
         LsbNc8jerjKgmnMqH0pwB3PLz2k+H4D3HVIX4wMhVW9KXDxJQ98RwL4eF9j3HrzFgM22
         bcGv2aqgvBvLeWDQZ5LGA3Y3ZaXblUPsuQUGqTVQLaXWscHpYTO3OANcrsB+Wz/ZoGxS
         tseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838536; x=1771443336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
        b=AcC5ueaFJFd6p5R0JZwJfXSfFoSBiLjhg9oNfIQ8Wa/bGBLSn50PPNzIihl0bgEZP+
         a9ewHhYv8SEHcdt6byBfKzbjAbVogYbqSMmlEzZNsVWZR1/I/dNMb9cZ4n1jhG5LlpAF
         KeIi8ljDkijWFcumrr2O0x4GbEf2nr8GjadyUKx5pqmSxjp1k3n6DJLn/l1whsi7SFWN
         cY2JBGibj9R4xZ6q8a7WBCUFj9fYxu52O7QPsuMcqP7hlGSvztVp6gQmnBN1SXIqIe8W
         Bq8rbUe8rPY+bDSarcinWh4QBSsFVVT9a+lDjOoks1E8K42z1ZPzx+IJKroKgrM3naJ5
         3MTA==
X-Forwarded-Encrypted: i=1; AJvYcCWUmJzIn29ioXTMndNOBco55e0yM8K2SQ3jepGgLiSzXfpm5/qGXsDnTIUZk30EyAvCycY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhrtW2QYjPc4iJNWXS/45wyJ2D5xSnlc/GmQNizCyp/NCgbC6F
	wtcO4FnM+1mQrgDSfQJ4SMFxy0VpecnWqyRfkDf7WtXt2J/7u3EI0PXw/z3TpzpHwGj2jRjLJce
	7h9VOxsqMPWJ7rZbwEV9ybTRO1BC3OU7ECnZ4xzpkrQTVu0i2dlPyCfuHaOIvlA==
X-Gm-Gg: AZuq6aIjSusnGJfju89R9Rt8ktvqqelEbdqtVG4ZpGYdDAj7buFD14Ze0cZiP7lQYqo
	tTiLT+KbbaijU71BdEJ1+9eK/UFXEx6aT4h9xM+txQReTjYxKRnWVdTKJcF2EU0gUlOEOIbQD0H
	IWTTd1+9FdlDtAoXLaAlOFL9/tj9SqVen8x08Fy7KgE5brhy974Q5QvNj/AtZ+AWbIWFhNJfxn4
	pkuCMYi2dmTvJmrrl3h0/isSom/qSBWkhDtumz88jamGFLphyxG/0ZdzlTYBSoS9gn/cJLTjr2C
	3ts4peN8v++M/SL1xueMPeEqDgLH7xdA2QyK8AJQG1w/UnMTnNG7s8PVPuxzn8uLSjnru1AMotv
	/loSK0wp5v+kRjQ==
X-Received: by 2002:a05:6214:e66:b0:896:a692:caba with SMTP id 6a1803df08f44-89727899bdamr10537106d6.31.1770838536106;
        Wed, 11 Feb 2026 11:35:36 -0800 (PST)
X-Received: by 2002:a05:6214:e66:b0:896:a692:caba with SMTP id 6a1803df08f44-89727899bdamr10536576d6.31.1770838535519;
        Wed, 11 Feb 2026 11:35:35 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdb19b6sm22142416d6.40.2026.02.11.11.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:35:35 -0800 (PST)
Date: Wed, 11 Feb 2026 14:35:23 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aYzZ-zBipYQ2OA_n@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
 <aYhh2XzyFsJbohll@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYhh2XzyFsJbohll@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70890-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 3040112732F
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 12:13:45PM +0200, Mike Rapoport wrote:
> Hi Peter,
> 
> On Mon, Feb 02, 2026 at 04:36:40PM -0500, Peter Xu wrote:
> > On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > Current userfaultfd implementation works only with memory managed by
> > > core MM: anonymous, shmem and hugetlb.
> > > 
> > > First, there is no fundamental reason to limit userfaultfd support only
> > > to the core memory types and userfaults can be handled similarly to
> > > regular page faults provided a VMA owner implements appropriate
> > > callbacks.
> > > 
> > > Second, historically various code paths were conditioned on
> > > vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> > > these conditions can be expressed as operations implemented by a
> > > particular memory type.
> > > 
> > > Introduce vm_uffd_ops extension to vm_operations_struct that will
> > > delegate memory type specific operations to a VMA owner.
> > > 
> > > Operations for anonymous memory are handled internally in userfaultfd
> > > using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> > > 
> > > Start with a single operation, ->can_userfault() that will verify that a
> > > VMA meets requirements for userfaultfd support at registration time.
> > > 
> > > Implement that method for anonymous, shmem and hugetlb and move relevant
> > > parts of vma_can_userfault() into the new callbacks.
> > > 
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  include/linux/mm.h            |  5 +++++
> > >  include/linux/userfaultfd_k.h |  6 +++++
> > >  mm/hugetlb.c                  | 21 ++++++++++++++++++
> > >  mm/shmem.c                    | 23 ++++++++++++++++++++
> > >  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
> > >  5 files changed, 81 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 15076261d0c2..3c2caff646c3 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -732,6 +732,8 @@ struct vm_fault {
> > >  					 */
> > >  };
> > >  
> > > +struct vm_uffd_ops;
> > > +
> > >  /*
> > >   * These are the virtual MM functions - opening of an area, closing and
> > >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > > @@ -817,6 +819,9 @@ struct vm_operations_struct {
> > >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> > >  					 unsigned long addr);
> > >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > > +#ifdef CONFIG_USERFAULTFD
> > > +	const struct vm_uffd_ops *uffd_ops;
> > > +#endif
> > >  };
> > >  
> > >  #ifdef CONFIG_NUMA_BALANCING
> > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > index a49cf750e803..56e85ab166c7 100644
> > > --- a/include/linux/userfaultfd_k.h
> > > +++ b/include/linux/userfaultfd_k.h
> > > @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
> > >  
> > >  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> > >  
> > > +/* VMA userfaultfd operations */
> > > +struct vm_uffd_ops {
> > > +	/* Checks if a VMA can support userfaultfd */
> > > +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> > > +};
> > > +
> > >  /* A combined operation mode + behavior flags. */
> > >  typedef unsigned int __bitwise uffd_flags_t;
> > >  
> > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > index 51273baec9e5..909131910c43 100644
> > > --- a/mm/hugetlb.c
> > > +++ b/mm/hugetlb.c
> > > @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
> > >  	return 0;
> > >  }
> > >  
> > > +#ifdef CONFIG_USERFAULTFD
> > > +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> > > +				  vm_flags_t vm_flags)
> > > +{
> > > +	/*
> > > +	 * If user requested uffd-wp but not enabled pte markers for
> > > +	 * uffd-wp, then hugetlb is not supported.
> > > +	 */
> > > +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> > > +		return false;
> > 
> > IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
> > unnecessary to even make driver be aware how pte marker plays the role
> > here, because pte markers are needed for all page cache file systems
> > anyway.  There should have no outliers.  Instead we can just let
> > can_userfault() report whether the driver generically supports userfaultfd,
> > leaving the detail checks for core mm.
> > 
> > I understand you wanted to also make anon to be a driver, so this line
> > won't apply to anon.  However IMHO anon is special enough so we can still
> > make this in the generic path.
> 
> Well, the idea is to drop all vma_is*() in can_userfault(). And maybe
> eventually in entire mm/userfaultfd.c
> 
> If all page cache filesystems need this, something like this should work,
> right?
> 
> 	if (!uffd_supports_wp_marker() && (vma->vm_flags & VM_SHARED) &&
> 	    (vm_flags & VM_UFFD_WP))
> 		return false;

Sorry for a late response.

IIUC we can't check against VM_SHARED, because we need pte markers also for
MAP_PRIVATE on file mappings.

The need of pte markers come from the fact that the vma has a page cache
backing it, rather than whether it's a shared or private mapping.  Consider
if a file mapping vma + MAP_PRIVATE, if we wr-protect the vma with nothing
populated, we want to still get notified whenever there's a write.

So the original check should be good.

I'm fine with most of the rest comments in this series I left and I'm OK if
you prefer settle things down first.  For this one, I still want to see if
we can move this to uffd core code.

The whole point is I want to have zero info leaked about pte marker into
module ops.

For that, IMHO it'll be fine we use one vma_is_anonymous() is uffd core
code once.

Actually, I don't think uffd core can get rid of handling anon specially.
With this series applied, mfill_atomic_pte_copy() will still need to
hard-code anon processing on MAP_PRIVATE and I don't think it can go away..

mfill_atomic_pte_copy():
	if (!(state->vma->vm_flags & VM_SHARED))
		ops = &anon_uffd_ops;

IMHO using vma_is_anonymous() for one more time should be better than
leaking pte marker whole concept to modules. So the driver should only
report if the driver supports UFFD_WP in general.  It shouldn't care about
anything the core mm would already do otherwise, including this one on
"whether system config / arch has globally enabled pte markers" and the
relation between that config and the WP feature impl details.

Thanks,

-- 
Peter Xu



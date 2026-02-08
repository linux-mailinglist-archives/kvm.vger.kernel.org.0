Return-Path: <kvm+bounces-70550-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOZPH/RhiGl/pAQAu9opvQ
	(envelope-from <kvm+bounces-70550-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:14:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10010108551
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C37EB3013A9F
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 10:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A22346798;
	Sun,  8 Feb 2026 10:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDTzP6BP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC438DF9;
	Sun,  8 Feb 2026 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770545637; cv=none; b=eB20qeQxfTY2suReGP38ejPAUS8ZFM1+E19+9peojoz94LH/dM+EUhB/bP89WHErSV8i4KxHZPmVpLJx27jcbF1rBD0UPGBTPJfrDNItlJIdKrOh5yfR2iJugAkH/CZOxKq1w98rHGcvrymShz9gC3alDZb7uFtekze2h3zY7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770545637; c=relaxed/simple;
	bh=rkYW3wffwDllivkQDY/e9E5Dft1p+R5H/xiDfhcNYms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBdA0h7FO9fyszauUonjtrhSoIXpbRmfB5WGdFwksg9REZh+75StXHBTU1+bmHyy4oNSKpB6c4Rn8E2eBn4ZikSfNBhT4Mu4XQFy2Uq3nWdEVyoRZUmW6EiArZJZNadBO7xKfbdOKPlspkrq83kvxwrtz9BTL5lO+5sbKhkaznw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDTzP6BP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452FFC4CEF7;
	Sun,  8 Feb 2026 10:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770545636;
	bh=rkYW3wffwDllivkQDY/e9E5Dft1p+R5H/xiDfhcNYms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oDTzP6BPNWIt4X9LEqYeY++mFhqyUqgyyb3gZTXgf5XK+iESqLl5DDT4GKZafB+38
	 nI8maoISOlRaVMcgVdDWcGeQeMx+m8pKeWkLWyAHsyFIOKjaUDeTY1HwAdf3zxQTBx
	 wJ8t7ZjSHuJwXO82H7aXBzjf3PoUlrM328lMkpsBJ9Qz6BhK484C5xdAwdAxPsAQ0V
	 QkYz/l1Ub/y5po6ywPJBUbtGnLSL57Uai7/HUCoUKq4rKpmcYgYgT6i86PKWN7rNGo
	 3hTCTLLNYKCp+XEyktXyFiIur3gKIhcoT8kKhXz3jfXIoJfvSH9LKIWxBZFiSZoC/+
	 OKvA1YgCjTcCA==
Date: Sun, 8 Feb 2026 12:13:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
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
Message-ID: <aYhh2XzyFsJbohll@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEY6PC0Qfu0m5gu@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70550-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 10010108551
X-Rspamd-Action: no action

Hi Peter,

On Mon, Feb 02, 2026 at 04:36:40PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Current userfaultfd implementation works only with memory managed by
> > core MM: anonymous, shmem and hugetlb.
> > 
> > First, there is no fundamental reason to limit userfaultfd support only
> > to the core memory types and userfaults can be handled similarly to
> > regular page faults provided a VMA owner implements appropriate
> > callbacks.
> > 
> > Second, historically various code paths were conditioned on
> > vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> > these conditions can be expressed as operations implemented by a
> > particular memory type.
> > 
> > Introduce vm_uffd_ops extension to vm_operations_struct that will
> > delegate memory type specific operations to a VMA owner.
> > 
> > Operations for anonymous memory are handled internally in userfaultfd
> > using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> > 
> > Start with a single operation, ->can_userfault() that will verify that a
> > VMA meets requirements for userfaultfd support at registration time.
> > 
> > Implement that method for anonymous, shmem and hugetlb and move relevant
> > parts of vma_can_userfault() into the new callbacks.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/mm.h            |  5 +++++
> >  include/linux/userfaultfd_k.h |  6 +++++
> >  mm/hugetlb.c                  | 21 ++++++++++++++++++
> >  mm/shmem.c                    | 23 ++++++++++++++++++++
> >  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
> >  5 files changed, 81 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 15076261d0c2..3c2caff646c3 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -732,6 +732,8 @@ struct vm_fault {
> >  					 */
> >  };
> >  
> > +struct vm_uffd_ops;
> > +
> >  /*
> >   * These are the virtual MM functions - opening of an area, closing and
> >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > @@ -817,6 +819,9 @@ struct vm_operations_struct {
> >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> >  					 unsigned long addr);
> >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > +#ifdef CONFIG_USERFAULTFD
> > +	const struct vm_uffd_ops *uffd_ops;
> > +#endif
> >  };
> >  
> >  #ifdef CONFIG_NUMA_BALANCING
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index a49cf750e803..56e85ab166c7 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
> >  
> >  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> >  
> > +/* VMA userfaultfd operations */
> > +struct vm_uffd_ops {
> > +	/* Checks if a VMA can support userfaultfd */
> > +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> > +};
> > +
> >  /* A combined operation mode + behavior flags. */
> >  typedef unsigned int __bitwise uffd_flags_t;
> >  
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 51273baec9e5..909131910c43 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_USERFAULTFD
> > +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> > +				  vm_flags_t vm_flags)
> > +{
> > +	/*
> > +	 * If user requested uffd-wp but not enabled pte markers for
> > +	 * uffd-wp, then hugetlb is not supported.
> > +	 */
> > +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> > +		return false;
> 
> IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
> unnecessary to even make driver be aware how pte marker plays the role
> here, because pte markers are needed for all page cache file systems
> anyway.  There should have no outliers.  Instead we can just let
> can_userfault() report whether the driver generically supports userfaultfd,
> leaving the detail checks for core mm.
> 
> I understand you wanted to also make anon to be a driver, so this line
> won't apply to anon.  However IMHO anon is special enough so we can still
> make this in the generic path.

Well, the idea is to drop all vma_is*() in can_userfault(). And maybe
eventually in entire mm/userfaultfd.c

If all page cache filesystems need this, something like this should work,
right?

	if (!uffd_supports_wp_marker() && (vma->vm_flags & VM_SHARED) &&
	    (vm_flags & VM_UFFD_WP))
		return false;


-- 
Sincerely yours,
Mike.


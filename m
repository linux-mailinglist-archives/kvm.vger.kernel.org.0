Return-Path: <kvm+bounces-21275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D8892CBFD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03A491C22FA2
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 07:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5052B84A27;
	Wed, 10 Jul 2024 07:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaDdLIb2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9383A0D;
	Wed, 10 Jul 2024 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720596911; cv=none; b=TMs67JhWLWEczaTrn2ZaU6N0rXIDppc1sXx6hzET6zMk+3SGW/DahdBG7D+H2esDEO7RerkMfojAvKB8TH5qSIH5iEOS72suH5M/mYQK+1q6xjQ/sfw7fV097xiJ4tFpqxsynOOoWveCs0pzSwyCqzAFI3O/PNIbzkcmGWgHhvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720596911; c=relaxed/simple;
	bh=6Bqq4Ewk7zpTLugZf5KjwcAghC3qqCdO74iRTV/2vys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+HPTDLi2khw72jqSRp6DoCy8fMwpZeHawZK5w/LBkSVENX700UudlpsT7rj8mBTjiesL1dwlaongaCm6RWI6bLh/COQzsl+sjOYVoIzV5O04YKETmq0gsOHF/UWkqtBI1Rn/lxDB4O3sdEYC12NQoGKyDY0W36Xz6jLQMmVdpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaDdLIb2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BF2C32781;
	Wed, 10 Jul 2024 07:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720596911;
	bh=6Bqq4Ewk7zpTLugZf5KjwcAghC3qqCdO74iRTV/2vys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gaDdLIb2asilEsYwMYfxjQiXe/jKOTfX6mA6XGwmSm/Trndrk8Y/Zr+WauUC+xHYl
	 zlodR4URQHujRikilL9PJWpYh20D8Z5dtvNEtfyJCO+NGPA9SZoZjVt/ICFnY38znP
	 7rGQVVjjx98NLb9jVEPakhrFX0pk/iYwnJm3opeXZ2MM2vbUCiFdZtpcNxgh5QKIs+
	 EmRap+tWsjTRiV433a8Go5joeXBkKeDnUR3LtH1WQMHWf1TSemnF862L1poQ/dhE5K
	 n7w4E4JgfP7Iqbcqb21fEaTSzp6M6XM7c19v8Q2qX4s5T2BRiewwq+zWTeHG3llGfR
	 eq7jxdjWOwP4w==
Date: Wed, 10 Jul 2024 10:32:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Patrick Roy <roypat@amazon.co.uk>, seanjc@google.com,
	pbonzini@redhat.com, akpm@linux-foundation.org, dwmw@amazon.co.uk,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
	kalyazin@amazon.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	dmatlack@google.com, tabba@google.com, chao.p.peng@linux.intel.com,
	xmarcalx@amazon.co.uk
Subject: Re: [RFC PATCH 7/8] mm: secretmem: use AS_INACCESSIBLE to prohibit
 GUP
Message-ID: <Zo45CQGe_UDUnXXu@kernel.org>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-8-roypat@amazon.co.uk>
 <0dc45181-de7e-4d97-9178-573c6f683f55@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc45181-de7e-4d97-9178-573c6f683f55@redhat.com>

On Tue, Jul 09, 2024 at 11:09:29PM +0200, David Hildenbrand wrote:
> On 09.07.24 15:20, Patrick Roy wrote:
> > Inside of vma_is_secretmem and secretmem_mapping, instead of checking
> > whether a vm_area_struct/address_space has the secretmem ops structure
> > attached to it, check whether the address_space has the AS_INACCESSIBLE
> > bit set. Then set the AS_INACCESSIBLE flag for secretmem's
> > address_space.
> > 
> > This means that get_user_pages and friends are disables for all
> > adress_spaces that set AS_INACCESIBLE. The AS_INACCESSIBLE flag was
> > introduced in commit c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for
> > encrypted/confidential memory") specifically for guest_memfd to indicate
> > that no reads and writes should ever be done to guest_memfd
> > address_spaces. Disallowing gup seems like a reasonable semantic
> > extension, and means that potential future mmaps of guest_memfd cannot
> > be GUP'd.
> > 
> > Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> > ---
> >   include/linux/secretmem.h | 13 +++++++++++--
> >   mm/secretmem.c            |  6 +-----
> >   2 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> > index e918f96881f5..886c8f7eb63e 100644
> > --- a/include/linux/secretmem.h
> > +++ b/include/linux/secretmem.h
> > @@ -8,10 +8,19 @@ extern const struct address_space_operations secretmem_aops;
> >   static inline bool secretmem_mapping(struct address_space *mapping)
> >   {
> > -	return mapping->a_ops == &secretmem_aops;
> > +	return mapping->flags & AS_INACCESSIBLE;
> > +}
> > +
> > +static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> > +{
> > +	struct file *file = vma->vm_file;
> > +
> > +	if (!file)
> > +		return false;
> > +
> > +	return secretmem_mapping(file->f_inode->i_mapping);
> >   }
> 
> That sounds wrong. You should leave *secretmem alone and instead have
> something like inaccessible_mapping that is used where appropriate.
> 
> vma_is_secretmem() should not suddenly succeed on something that is not
> mm/secretmem.c

I'm with David here.
 
> -- 
> Cheers,
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.


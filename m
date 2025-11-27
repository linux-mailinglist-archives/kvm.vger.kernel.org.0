Return-Path: <kvm+bounces-64861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C00C8DCD4
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 11:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF3CF3B05C6
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 10:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D9D32A3C9;
	Thu, 27 Nov 2025 10:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hf1NMK2q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A379DA;
	Thu, 27 Nov 2025 10:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764239789; cv=none; b=pU4QfYT8O2Rgz5zd2M89nvPqAbOsnBjhtsw0NFOUzWqDtbDxZf2GBhfvmfW6rn6AkbAUzAPVAB4WKA0HfMCv+s9bOiTLSvKskpWjAOMJi0PgIQUxjteAbGKDaall+g1i8PZO00a8JkiaaC5AiU2c2C+q2qRUw9w56DzkszVYvBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764239789; c=relaxed/simple;
	bh=EW7fa0YR0eAojjarOFkeA2S1shqTF3govz1KNpd+VNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2eVS1rPGCAdGIlZUwzIzDpNGxplIkU+1nR4xXrDF1VTt+Ax0baUzoDdRBmJSj9nC0Ug4KsSTjp14CtpK5j13ULd0j8mjaltJ+C86J0NZDkiusByBkGkspd9nAonmU4J0sYelyNrsMzLrJ538LNACc6RYzF2k9Zdy42JEb4j0Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hf1NMK2q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E3EC113D0;
	Thu, 27 Nov 2025 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764239789;
	bh=EW7fa0YR0eAojjarOFkeA2S1shqTF3govz1KNpd+VNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hf1NMK2qId4G69jvB9K1jaDpSSbHc9z7L7hEiWYkXA+owEUB5rhk+3dXMbQSrEm2e
	 jTbTzwS/D1rlaSUmsddYIY/nEbhUMvcF54rbGLh7n1gRgiU8ILVbSgj1y1ehcf9VGH
	 qjBQGzgdBbS7Vc2FfR0TFqfMRW24fVG25hOXyZHffhid2u0bPGbZoZljVSsCbOn+Sl
	 glfuRo11li8xf9HdqBwO/vOolcd8estetolotsVKfGGiP0HQ74MWLEgaQWzyz2gbS5
	 3HlD+GwWe7UUm7kOJIqKAC2BV0tU/ddVj5mS7ilS1V4HF9VITB5LacR3Ck+7s2TQSH
	 LNK7x+xRw2xpg==
Date: Thu, 27 Nov 2025 12:36:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aSgpo1_ZSmxf84-p@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
 <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>

On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
> On 25/11/2025 18:38, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > +#ifdef CONFIG_USERFAULTFD
> > +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
> 
> We have to name it differently, otherwise it clashes with the existing one
> in this file.

It's all David's fault! ;-P
How about kvm_gmem_get_prepared_folio() ?

-- 
Sincerely yours,
Mike.


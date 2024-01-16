Return-Path: <kvm+bounces-6353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B761D82F424
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD8791C2389A
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 18:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781B81CF8B;
	Tue, 16 Jan 2024 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iT/Igi1V"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F8E1CF80;
	Tue, 16 Jan 2024 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705429384; cv=none; b=LDkZelu93ZkOr3yvzeuy7LkbqaEMPY3YkAo97Mbhk/DQ4KCK/+2Vqp5vYVukqP4oPfE0bd/+J6NIPW/NlHZald5YQ1SJVXVBiaYBrV9JpaSOtgoyaxWoVkRjAco9I+Gvo00ws9HDSFnmoMvCW2FnGG1d7e7xByfoYcWQ1wXf5nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705429384; c=relaxed/simple;
	bh=vOgqF5Zcc8Ylq6RHqZfJs1o320FusJ0JBsfhr/+0YmU=;
	h=Received:X-Virus-Scanned:Received:DKIM-Signature:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HmPA4ohNw6qHuvujiuWZB4FSGo+W9ae8HDb0VSEfx4n9bRn9GVq59c03u6z1sBoa0IXZn0M8e4zrotK8Kf85EkqQIrWnD1+xW0514YPcXvI+pw3d5B2vAmUo08rtwNrpThfG7ylBNm6itLmX7XtU24ewoML9xEz5kRfig6EbPtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iT/Igi1V; arc=none smtp.client-ip=65.109.113.108
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0579F40E01B2;
	Tue, 16 Jan 2024 18:22:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3FYGSk50diAZ; Tue, 16 Jan 2024 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705429375; bh=UZ6G+J6ye64gzMjmC6lSx1WhjVghiKPeCR0bIv9HV54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iT/Igi1VvZ6a4grjasUBsQ3NdbxVO1LZMf2kXl82VNfinMdUS0Ec9PcrPGaD1XYXR
	 YdA48WrCcriSh2e1xb52ISkIy8H1Rrm524EZxg9aoINEgy9OXUaWhXGJa1lV94hImP
	 YaODpfGf/w+A/eInOmc3DpCH5vcKshzQ9Mg3VBfLUNHhIWpa8jsF9ZzU5wtjD6WPhn
	 DAIloOlghiaeyvEcwwen2OpIDhV0kjqSYj1GWUQm+vN63O24M4KXlaRkaruNlOwWGo
	 h6tUDG57RTqsPMq+wIcj6Z+Z9NZ0DRB624YhMEin4N8pz2z7AbqUUiuXPHv878xWwL
	 xULI9qMNlhWlYjI0zUTMS4dOnss7cKROp32wMTohATsxLHoXcYZR7FvUImvS6ECkrh
	 CHT7ArPtEgM1vD2isJU2OhQk9QnEo9ikZJUhZDBpg2E9bK66pHThR7OpdEhIrDCpy6
	 GthkzXZNIYojH/h4s6yJMI6OwM4NHagRA0EuKgVwLbu2rXVZIybUYjMnw3NLd+1bXM
	 Ujlxrws7Vk6QaiuBPnZ8+jgrI1UrwQm2aN9MZWjwjp8Zd9ZnOKPKTi/CovQK0x5Wu/
	 AuGWt9P+gEXnoQ0GUpRPlDUDUkghNjB1kzTfdx1ZoDopAUpzAca3zMaweDB0gIZUZr
	 sFqXK/o7GqQGyHT5mb3FRkRU=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA5AD40E01A9;
	Tue, 16 Jan 2024 18:22:15 +0000 (UTC)
Date: Tue, 16 Jan 2024 19:22:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
	pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>, rppt@kernel.org
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240116182158.GHZabJRqUMAEidcee1@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
 <20240116161909.msbdwiyux7wsxw2i@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240116161909.msbdwiyux7wsxw2i@amd.com>

On Tue, Jan 16, 2024 at 10:19:09AM -0600, Michael Roth wrote:
> So at the very least, if we went down this path, we would be worth
> investigating the following areas in addition to general perf testing:
> 
>   1) Only splitting directmap regions corresponding to kernel-allocatable
>      *data* (hopefully that's even feasible...)
>   2) Potentially deferring the split until an SNP guest is actually
>      run, so there isn't any impact just from having SNP enabled (though
>      you still take a hit from RMP checks in that case so maybe it's not
>      worthwhile, but that itself has been noted as a concern for users
>      so it would be nice to not make things even worse).

So the gist of this whole explanation why we end up doing what we end up
doing eventually should be in the commit message so that it is clear
*why* we did it. 

> After further discussion I think we'd concluded it wasn't necessary. Maybe
> that's worth revisiting though. If it is necessary, then that would be
> another reason to just pre-split the directmap because the above-mentioned
> lazy acceptance workload/bottleneck would likely get substantially worse.

The reason for that should also be in the commit message.

And to answer:

https://lore.kernel.org/linux-mm/20221219150026.bltiyk72pmdc2ic3@amd.com/

yes, you should add a @npages variant.

See if you could use/extend this, for example:

https://lore.kernel.org/r/20240116022008.1023398-3-mhklinux@outlook.com

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


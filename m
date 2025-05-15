Return-Path: <kvm+bounces-46699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80951AB8B1B
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93C16166151
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F7A21A42D;
	Thu, 15 May 2025 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChdApZhi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8E218827;
	Thu, 15 May 2025 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747323708; cv=none; b=csjoEdbPyQuwaQJ6K0BEsQh3Y/pzo9gNB2oUN67/YeHudw+FvR5NPcLj6IppOtwCuvGVcMSDn3PmKMJHeX73neFgwQ+i0KU7Rfac+GcT9aidCVusmcrxfCO+OxOyjWTazn9I6Bad2wmH2w1jhB2NbLCRZBzmolSzwAqfplzpA54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747323708; c=relaxed/simple;
	bh=wYdVMp02jFRFCymuKpz4xpEe2jFARlX2Pg/ayqcOBsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUL1NQxxZLF+n5Q4dH990M5pjoRgw+GNXTmj5xTSGvz+wXspvVSexReKjr7eBdcK1FtxNFS+V+6szNqfxcHCYNtauna/TFGAWECfu7jHWfiw2QB+HpSYD7M+ckvYCfkWe/dIcS191cMJiMdbWWdxceEpT26/58GdELyCVP/1wNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChdApZhi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755A1C4CEE7;
	Thu, 15 May 2025 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747323706;
	bh=wYdVMp02jFRFCymuKpz4xpEe2jFARlX2Pg/ayqcOBsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ChdApZhiS9VRFyJKnkJC82Ywa8tjngOYFNBdUCx0Kjg4UbtZYRhdHlcafFA98Sy+R
	 eb3BJuuGtXP0CKq3vEvAaDWKvjXFlmS69kUMMPAfiNml+AbE5vQWoAS9c0INzNmkg7
	 GUbAvty0DUD8JVssj1GyzIGbYa7utxmf8biU+VvD2Ul/Smh0zBDb9GP5wGZR9yL39O
	 MAapzbkzKcT92jZOEZq+gqZMLJvr8ynFyJgx7n8HqdehHd3B3JyMqEqHdEs5pEucND
	 Zz2qpNZtAdQa0rFm8MozentCDKrF7dFlwmnV29OyQFVoHL8zRevZbmDjzqeMZ5vMBj
	 XAFq/CvJUjXpw==
Date: Thu, 15 May 2025 17:41:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com,
	xin3.li@intel.com, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
Message-ID: <aCYLMY00dKbiIfsB@gmail.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512085735.564475-1-chao.gao@intel.com>


* Chao Gao <chao.gao@intel.com> wrote:

> Dear maintainers and reviewers,
> 
> I kindly request your consideration for merging this series. Most of 
> patches have received Reviewed-by/Acked-by tags.

I don't see anything objectionable in this series.

The upcoming v6.16 merge window is already quite crowded in terms of 
FPU changes, so I think at this point we are looking at a v6.17 merge, 
done shortly after v6.16-rc1 if everything goes well. Dave, what do you 
think?

Thanks,

	Ingo


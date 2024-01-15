Return-Path: <kvm+bounces-6211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD54782D5B7
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C615281EC9
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353B1CA70;
	Mon, 15 Jan 2024 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkHCl/rH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BA12BAEB;
	Mon, 15 Jan 2024 09:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA1C433C7;
	Mon, 15 Jan 2024 09:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705310227;
	bh=KUG06kyFNhu+8XSLZ1CtZ2XP6hSlyl36SFxCGWaZx1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkHCl/rH63QzKibWmLOv4INzCWKRM+7tTMVIZL+26IaeiqrhOsT/M5wKut2HOTmK+
	 D1U3cwXG8xEeRoTZVpwGVTY3dkBb9Y3WUdjHdWoMpCA8BRJ61XuB32hAD+7/SIcmBW
	 s8JemP6NpC7VzX6M2A8+ydOB4WCzNOR6y/UbO4RTpgtSCMe4kGlaKaAB3G2cul9vyj
	 NdCgq/hNu6lWWle9bUz0FwVpnp4qvnn4614o4m64k5Pe+qiw2Qitr8JbGuDD949P+J
	 nvMtMnR0rmRjnjDEktqE39ymxhsrNd4JFbESpfmw3ii+gMEta3Fx4uAJWD7i4Rp7FM
	 Bp51bk3jpxvmA==
Date: Mon, 15 Jan 2024 11:16:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Vlastimil Babka <vbabka@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
	Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <ZaT3424NIr-BrMr_@kernel.org>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>
 <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>

On Mon, Jan 15, 2024 at 10:06:39AM +0100, Borislav Petkov wrote:
> On Fri, Jan 12, 2024 at 09:27:45PM +0100, Vlastimil Babka wrote:
> > Yeah and last LSF/MM we concluded that it's not as a big disadvantage as we
> > previously thought https://lwn.net/Articles/931406/
> 
> How nice, thanks for that!
> 
> Do you have some refs to Mike's tests so that we could run them here too
> with SNP guests to see how big - if any - the fragmentation has.

I ran several tests from mmtests suite.

The tests results are here:
https://rppt.io/gfp-unmapped-bench/
 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

-- 
Sincerely yours,
Mike.


Return-Path: <kvm+bounces-38329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD50A37BAA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 07:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F3533A7FD1
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 06:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CE818FC74;
	Mon, 17 Feb 2025 06:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqW1KybL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC31531E1
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739774817; cv=none; b=mNwlQsCqTdtKg85oAPtjqBXL3C9SMKlKqB4iNX1D7uI8goiPwoOmpDRJ6R4PZj5tWVqyx93qxJjtERxf7lkmp9AJdeLXUQURXufy46SrKkzOkyHPu165thpLFdyLFJXQDUFnmIDMdp6eHAtV9/0p0QHWU5qc4yPvlrmDD/IMmhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739774817; c=relaxed/simple;
	bh=wGEp05+aP4nRVSEcYNqbBBmVcNgBfNoXnSxpARVudB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaBDk0/g0LRnHMZ3nnb5DLylZeqaMtwxwTclSpDr+oTUBMpRC2vXA1WZ/6E9ckC8LgGHRQOvHPisRrK488267VoDvwyMcnnod7fdpBgHHe+V6yvd8G/GGcLVcsvQbg3VvTdp3Ln6WCexNADxcCkS++sG56AX603YHt6jCq8Szus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqW1KybL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD2BC4CED1;
	Mon, 17 Feb 2025 06:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739774816;
	bh=wGEp05+aP4nRVSEcYNqbBBmVcNgBfNoXnSxpARVudB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqW1KybLXuKVrnFDHFiQ39uSkMrSQZORRAhuHSiVZBF030Qsx+WxRZfbHsWxSnCr1
	 lYXE4MV+3LXcdbe9KSG+s042q9N0Zuk+9yXyhS+3TjCkB2K0VIsa8qNvwe0erUdv9Q
	 C3929Be6vAhdTnetgcUlcKcxdgKNcaCX3VFaqJ+oMuF0I0uX5IcZamIAmlgwIniZh1
	 ExJtlbTAMkIOlUEIs6y6s2q1mV4Q0bp4RZcCKoCCgh9KtCKJrtiFm8usbtKMACjjgZ
	 iEd/F0KTKoG2b6WDv8aSwLQHrHefSYfXkdh8hUymZnLW7SAkvN82MhZW4KC0h2TC7B
	 9AqPlIoo2jDjw==
Date: Mon, 17 Feb 2025 12:13:15 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	"Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
Message-ID: <gxyvqeslwhw6dirfg7jb7wavotlguctnxf5ystqfcnn5mk74qa@nlqbruetef22>
References: <20250207233410.130813-1-kim.phillips@amd.com>
 <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com>
 <Z6vFSTkGkOCy03jN@google.com>
 <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com>
 <Z66UcY8otZosvnxY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z66UcY8otZosvnxY@google.com>

On Thu, Feb 13, 2025 at 04:55:13PM -0800, Sean Christopherson wrote:
> On Thu, Feb 13, 2025, Kim Phillips wrote:
> > On 2/11/25 3:46 PM, Sean Christopherson wrote:
> > > On Mon, Feb 10, 2025, Tom Lendacky wrote:
> > > > On 2/7/25 17:34, Kim Phillips wrote:
> 
> Third, letting userspace opt-in to something doesn't necessarily mean giving
> userspace full control.  Which is the entire reason I asked the question about
> whether or not this can break userspace.  E.g. we can likely get away with only
> making select features opt-in, and enforcing everything else by default.
> 
> I don't think RESTRICTED_INJECTION or ALTERNATE_INJECTION can work without KVM
> cooperation, so enforcing those shouldn't break anything.
> 
> It's still not clear to me that we don't have a bug with DEBUG_SWAP.  AIUI,
> DEBUG_SWAP is allowed by default.  I.e. if ALLOWED_FEATURES is unsupported, then
> the guest can use DEBUG_SWAP via SVM_VMGEXIT_AP_CREATE without KVM's knowledge.

In sev_es_prepare_switch_to_guest(), we save host debug register state 
(DR0-DR3) only if KVM is aware of DEBUG_SWAP being enabled in the guest 
(via vmsa_features). So, from what I can tell, it looks like the guest 
will end up overwriting host state if it enables DEBUG_SWAP without 
KVM's knowledge?

Not sure if that's reason enough to enforce ALLOWED_SEV_FEATURES for 
DEBUG_SWAP :)

If ALLOWED_SEV_FEATURES is not supported, we may still have to 
unconditionally save the host DR0-DR3 registers.


- Naveen



Return-Path: <kvm+bounces-59634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A07E2BC48C3
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0FBF3AB879
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA07F2F6191;
	Wed,  8 Oct 2025 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXpMXE+5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E1F21767A;
	Wed,  8 Oct 2025 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922731; cv=none; b=aC94BmHihw0p3tTH4jvI8Mb6QGwuOZfxc1vxBPIs7Jrea3OZI/fxyWmz8W3rIQW0kMJOlitsd9ljgvXP12t7xGcOK8Tw8zjxIPwmEXV81Gz7VDV4ExqbSnohju1+ljRLcmcH23dI/xx76pvYixwJaMaeFMrojjnBmX1t6V1wGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922731; c=relaxed/simple;
	bh=pn7G8E2ICatiT3xnkU2OqdfZ1nbQjMaJjMGZnW//DMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2G73b8CpZtdfPuiL6rhXhZEAjDTkf0UvJy1vzSIu/cwXuzPD0Ty479Loq7EIpovAgDM6OTjGaMIA/B9tjOsl6ZXkLGXRNd9e8snOog0776YIajgsZDY/SW48OfCLrtS42nvX0UAjJcITxM6rACnOPFZEW7MHiAjvN3BJtjM9wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXpMXE+5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE08AC4CEF4;
	Wed,  8 Oct 2025 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922731;
	bh=pn7G8E2ICatiT3xnkU2OqdfZ1nbQjMaJjMGZnW//DMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXpMXE+5LTR3LkDPPufJ9GDSEakDP3r6u2ZTIrGDFF58z6++EazSLLAQ5f0Ql9G/l
	 C5dhb2CoLT9udyGKfJQY1Y3noSTuAfZUqT02mlYprGgzhzF26q050EB18z1H3WHpz/
	 0CdmGbINcL7I11KrIMbkEJiFph5T0MJtPlVTKpVqLPhRzOSlRb0ZHFBS2AUPNfVKIt
	 krrqMBIpCHNbM6nxIcoG13W7ca6nApWKt7qQdrWMBSgW692qHBJiWm38+r3AR9refZ
	 qY+V20FGpUSaiWLGRKYotd4vbPWOStdCE/wzZme+dm1rSqe0kUsnPqUMw0WFkbWNTE
	 qs6wONDnQjLEg==
Date: Wed, 8 Oct 2025 12:30:05 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 05/12] KVM: x86: Add emulation support for Extented
 LVT registers
Message-ID: <lh5f34wsxn7ntis4j6niirbe6uncz6ucvoljq3qzbxcmekowed@sm4kpwlxvnmh>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052238.209184-1-manali.shukla@amd.com>
 <xnwr5tch7yeme3feo6m4irp46ju5lu6gr4kurn6oxlgoutvabt@3k3xh2pbdbje>
 <9f2b02e2-f3b2-40aa-8e31-e940f4c2b90b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f2b02e2-f3b2-40aa-8e31-e940f4c2b90b@amd.com>

On Wed, Sep 17, 2025 at 06:27:02PM +0530, Manali Shukla wrote:
> On 9/8/2025 7:11 PM, Naveen N Rao wrote:
> > On Mon, Sep 01, 2025 at 10:52:38AM +0530, Manali Shukla wrote:
> >> From: Santosh Shukla <santosh.shukla@amd.com>
> >>
> > I also forgot to add for the previous patch: the feature name needs 
> > to be changed to reflect the true nature of the feature bit.
> 
> Ack, I agree the feature bit name should reflect its true nature.
> Happy to rename it. Any specific suggestion for the name?

How about X86_FEATURE_AVIC_EXTLVT? That should be sufficient to indicate 
that this is an AVIC-specific change for the extended LVT registers.

- Naveen



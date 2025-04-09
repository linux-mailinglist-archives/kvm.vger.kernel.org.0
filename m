Return-Path: <kvm+bounces-43027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A00A8318D
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 786321797C0
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 19:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768A9215781;
	Wed,  9 Apr 2025 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VulSS1Yw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA7214A7F;
	Wed,  9 Apr 2025 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744228451; cv=none; b=WYahd8HijWGGgljQZwVoZI2y9iN7Yu25MdRJayLwzDJ0xXYr3kOsrgEFcbp0MEAI9L7VB/hPe03dIH33eeTOFrVLd7+KKMfihkmPm+KNMgUfyHh7OTG6mrgAfzL9H0JbKZhyMRsUyt6UdfJtcNbIv1IDNz2JS+no33SQ5YUsoyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744228451; c=relaxed/simple;
	bh=q7KvwDfQqFDNGgQf6PyiHomLFAW6NL2n557EpD26id8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oy1/Yaw991znhwp5goXstaqIx3MSAul68EdkULkv06fub7A452cZfm2d1VFeXm8c1Ih6pxf3fij9Zu0Nk0uXQ8nrabO2A8y3aAJxh0RDq+tamaRNUbCt20kGjzAfweWC6OTatmjxnItm2Iu7FiAA/Sp0NrSMhPH5/3GAfhyiNfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VulSS1Yw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260C8C4CEE2;
	Wed,  9 Apr 2025 19:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744228450;
	bh=q7KvwDfQqFDNGgQf6PyiHomLFAW6NL2n557EpD26id8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VulSS1YwlnFjfym00iwjm8nZpYCyp06C0ojMIpSCSHZR4u0kCve/HPOLSpwGvY8u5
	 pBTjBb/9vduXt1yHmPU9a+E8F7KAYhYpWKQEBBPX+/hfy20lXzFqyHyY8B+HK6sZUf
	 xN3fYMEJoURP0ouK4XLhP558hxwDPdlv3j55wiCtlhRPkFu/TgXbgsw4c31dujDZWx
	 WI68CmIsMMEvM72xxyr1xE96ssKn4YT5iCMXcjHWRmRp8UzErdBvMQgGb+caLf69ln
	 4GvtnHjQrXPK2u6hCjNy/AUsgKBW8iPDB+syZsrtkVGFcuJdzKsEe35yQuSR5M6flU
	 mNFGcP/z9LOpg==
Date: Wed, 9 Apr 2025 21:53:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Xin Li <xin@zytor.com>,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	linux-edac@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
	linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
	andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org,
	namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, alexey.amakhalov@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
	pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v1 01/15] x86/msr: Replace __wrmsr() with
 native_wrmsrl()
Message-ID: <Z_bQV2oOnJlwbxnk@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com>
 <Z-pruogreCuU66wm@gmail.com>
 <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>
 <a0254e73-bf7c-4876-b64e-b08e96044666@zytor.com>
 <e5770add-9d18-40e1-929d-df7c40f3c7d1@intel.com>
 <ADCFB190-A89A-460D-81A6-80E20AEFBFBC@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ADCFB190-A89A-460D-81A6-80E20AEFBFBC@zytor.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> On April 2, 2025 8:41:07 AM PDT, Dave Hansen <dave.hansen@intel.com> wrote:
> >On 3/31/25 22:53, Xin Li wrote:
> >> Per "struct msr" defined in arch/x86/include/asm/shared/msr.h:
> >> 
> >> struct msr {
> >>         union {
> >>                 struct {
> >>                         u32 l;
> >>                         u32 h;
> >>                 };
> >>                 u64 q;
> >>         };
> >> };
> >> 
> >> Probably *msrq() is what we want?
> >
> > What would folks think about "wrmsr64()"? It's writing a 64-bit 
> > value to an MSR and there are a lot of functions in the kernel that 
> > are named with the argument width in bits.
> 
> Personally, I hate the extra verbosity, mostly visual, since numerals 
> are nearly as prominent as capital letters they tend to attract the 
> eye. There is a reason why they aren't used this way in assembly 
> languages.

So what's the consensus here? Both work for me, but I have to pick one. :-)

Thanks,

	Ingo


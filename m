Return-Path: <kvm+bounces-43029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34303A831AD
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 865D87AC60E
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D3F213E76;
	Wed,  9 Apr 2025 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D24yujy4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DAB1D5175;
	Wed,  9 Apr 2025 20:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229484; cv=none; b=XKYHXbjmW0wTpoIne58sUZ7hZIsHXXpV1TaL2jNlaELv85V1rUdB/CIuJb8KIRA3PaIrQjW1a6i1yOeJ8/MImn7U4K1tM6SDzGdzgqzrbqU0XX3/vWHelEivhEBKuKiTSCSMRxmZTGLxv2tnqNkc8W7Ja4nqzzy6bPjRSMZWcq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229484; c=relaxed/simple;
	bh=FJm/izdFNTfA1jwBlsdk1jJoTUGHKfakmjnarpokATA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkqwHzSitwgHzAg3RdmX5I0ZpoWLnFGpQdMWs3whkZFM2BjVFHUqKqB6NW6ohlmjucpxOVACfn2iodx5X6y9onAYOQU+3MGcXFquEFjotmfgGT9grYa458Js4Y7xYNahsW0gGaD9ZyD2lVR/YFzeWKreGPJ4OfM73QBNOt5l2lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D24yujy4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71925C4CEE2;
	Wed,  9 Apr 2025 20:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229483;
	bh=FJm/izdFNTfA1jwBlsdk1jJoTUGHKfakmjnarpokATA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D24yujy42QUc8MzaoYIOhqsAt7S0/2X6yekc52w0gwdRwZBMwmU2nUGsZoW5Ns7GD
	 j85elSFL53Wuzj6UvF8uMMGWEYy3lD+JT9cZ0aqP7gtAES0C3utL694NSMXdxOrKJc
	 9kIP4IKosSndbxn+SFfqxSrLVm9pBipvXXrP6J8VxMshOu3nGVg5Xag10MUwIq3jdK
	 Ebzxt4FaeSUl2kGyVYg1LltfzCxBxoV7FKWUvjuBBSV/RcEjM/nammCpLTt/GmU9n5
	 qWMtWEi+RRMn/FMGZcmAdYRRPyz1BTp+SNboYM41JDtFNJnwUWqDkFxGYl1tX5Mz6M
	 qlUYtZ4y1dU2Q==
Date: Wed, 9 Apr 2025 22:11:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
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
Message-ID: <Z_bUX06aq6thJ4Uu@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com>
 <Z-pruogreCuU66wm@gmail.com>
 <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>
 <a0254e73-bf7c-4876-b64e-b08e96044666@zytor.com>
 <e5770add-9d18-40e1-929d-df7c40f3c7d1@intel.com>
 <ADCFB190-A89A-460D-81A6-80E20AEFBFBC@zytor.com>
 <Z_bQV2oOnJlwbxnk@gmail.com>
 <29ad84a6-b40c-456a-9eed-9887c87dfb38@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29ad84a6-b40c-456a-9eed-9887c87dfb38@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> On 4/9/25 12:53, Ingo Molnar wrote:
> >>> What would folks think about "wrmsr64()"? It's writing a 64-bit 
> >>> value to an MSR and there are a lot of functions in the kernel that 
> >>> are named with the argument width in bits.
> >> Personally, I hate the extra verbosity, mostly visual, since numerals 
> >> are nearly as prominent as capital letters they tend to attract the 
> >> eye. There is a reason why they aren't used this way in assembly 
> >> languages.
> > So what's the consensus here? Both work for me, but I have to pick one. 🙂
> 
> I don't feel strongly about it. You're not going to hurt my feelings if
> you pick the "q" one, so go for "q" unless you have a real preference.

Ok, since hpa seems to hate the wrmsr64()/rdmsr64() names due to the 
numeric verbosity, I'll go with wrmsrq()/rdmsrq().

Thanks,

	Ingo



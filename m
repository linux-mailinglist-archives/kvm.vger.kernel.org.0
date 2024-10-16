Return-Path: <kvm+bounces-28985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB44C9A0698
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 12:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DC3A286778
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 10:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553BC2076A7;
	Wed, 16 Oct 2024 10:06:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0F206945;
	Wed, 16 Oct 2024 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729073210; cv=none; b=m6e17QfgXYg2UWccyo9+LdrU+ZOAW9p6/Ulu6kiBJxBiT4dbku9dpULn1S3fBo5GKI5fNCI6KC5f0C7y22jrziFyUbXRfOo5/9ypdPE40AYZ4ALSO4s8jyEs9I4R5BlqoqUMzJRPXllaBJqk0lPJOGnwvOjIGEGG3fRQx0eqmVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729073210; c=relaxed/simple;
	bh=O+4LhBziJWNBn622fUC55FM3wJzmR0RHwoOzyZVZ5GY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcG/KckzyHqhNykqt7ZliEJYXoZbPKLiS7qLj9pkwuQf8Z+2pXzUp2sTGqLTSz0Pzw1LP4EMftrqcwwbaMTG99CTWYZ4BvTWwSXac4gWk2jRFwe4VEQY3o88TYE2HatkMAPQxT/rxrxZPZTlwucdnLhxob8+ZyOsGhyQKSwz/ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D857C4CEC5;
	Wed, 16 Oct 2024 10:06:45 +0000 (UTC)
Date: Wed, 16 Oct 2024 11:06:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
	cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <Zw-QM07-9IdV-yIw@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <87ttddrr1r.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttddrr1r.fsf@oracle.com>

On Tue, Oct 15, 2024 at 02:32:00PM -0700, Ankur Arora wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > I'd say if you want
> > something like this, better introduce a new smp_cond_load_timeout()
> > API. The above looks like a hack that may only work on arm64 when the
> > event stream is enabled.
> 
> I had a preliminary version of smp_cond_load_relaxed_timeout() here:
>  https://lore.kernel.org/lkml/87edae3a1x.fsf@oracle.com/
> 
> Even with an smp_cond_load_timeout(), we would need to fallback to
> something like the above for uarchs without WFxT.

Yes, the default/generic implementation would use cpu_relax(). For the
arm64 one, some combination of __cmpwait() and __delay() with the
fallback to cpu_relax().

-- 
Catalin


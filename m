Return-Path: <kvm+bounces-12157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 855958800E3
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E27E01F23ED2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B597FBAC;
	Tue, 19 Mar 2024 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ar+hWtWW"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8705657BA
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710862992; cv=none; b=Ro6OSVeGdhCcsHO7+GGStgR9CAxuI5O4lLs8B22rAkvYiY+d81bx5wE7R/6Xst2t+IOj8dRFwVlyZqs1qkYK1Oc8ZE/MX8iK3VdTrw+rzR1eQDwXlYjUPUZuRTzGwu77jInqP0HsGvy1mafhoet9dLc4WY88Is7zPSNZTjmeTpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710862992; c=relaxed/simple;
	bh=GtYq4l23iQ2hktSZbBk4e04G3H40bVqFr2I7EJ9PDjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Um6fJnz09zBz5+fL+sJExJ93j8O4+pGxxxHyhF5dd6YZa+2it3WH/lhyVKmW9sGQF+IZbXr5jcELl2i0sJ1MowRGOmKcTBRpFua958dozQCR2JiH1Fno+n3oAMvrmrz5eLaptPj2z2YT+DJaWktYpF9M00IgXzdWwS2wBQJ00i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ar+hWtWW; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 19 Mar 2024 08:42:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710862988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eU6gvO/8PzooX+lMfSz1d3KKVDqSzPhaLg003h4rD94=;
	b=Ar+hWtWW0J92kRp7GaELGJLfXCUf4Q8nmD4y+S/xW1F2YgCSiov55wCk0cpxifHKsU8oZj
	Ievlfsz9YKqO8BbybPYwKQdBsu0Nu7zkFWEIuq2/aBNVGeDcLDhKpHcP9gTHtWp6CfJfBZ
	bvchYNL/LE1Cgpy4h/HKi+iG2yB+srk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/5] KVM: arm64: Add support for PSCI v1.2 and v1.3
Message-ID: <ZfmygicpPdYoA0vL@linux.dev>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
 <20240319130957.1050637-3-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319130957.1050637-3-dwmw2@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 19, 2024 at 12:59:03PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Since the v1.3 specification is still in Alpha, only default to v1.2
> unless userspace explicitly requests v1.3 for now.

The ABI is final the moment we take this, alpha or not. Let's just
advertise v1.3 from the start and only apply the series when things are
ready to go.

-- 
Thanks,
Oliver


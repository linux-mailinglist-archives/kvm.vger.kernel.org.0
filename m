Return-Path: <kvm+bounces-12506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D381887193
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC7F4286F34
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDBC5FDCB;
	Fri, 22 Mar 2024 17:05:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83975FDC4;
	Fri, 22 Mar 2024 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127124; cv=none; b=OJRwkBZ3mmg+dmVXTdXzoCE3KeSEvYAEKs5INFuR3X1FkzsywOtof6pK4KN+bDlzfllAQMq8zFj1Eb0yPR1++q7XyCNIgmP9A690kOkrfoSXCc8NqciBk64EUDAp9laTpxWthO7vtQEN6HAX5ZQmNTdHq/JcD4csgr7F9cR1IYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127124; c=relaxed/simple;
	bh=cKFHXx0uwG7dElAjjFikSr5g3gCGM6PF0iXhuZRVtLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVtA+PavwOPAqehs6rT6xwi/RCMZjFjY54tIG5yYO9LTrceuXxocmDy1QfWacMqz56DqPIkB99PszwXgICI9oDcODRTnD/+z9MTR1pLnyidVBh88u+RiMf1GJx7WiNtz6/xTppE1yrK7gzbtT8IOXlbkUNeVVNSY0QVUDPvk9Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44C32FEC;
	Fri, 22 Mar 2024 10:05:53 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34BE73F67D;
	Fri, 22 Mar 2024 10:05:16 -0700 (PDT)
Date: Fri, 22 Mar 2024 17:05:13 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/5] arm64: Use SYSTEM_OFF2 PSCI call to power off
 for hibernate
Message-ID: <Zf26Sac6qqQpjAzN@bogus>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
 <20240319130957.1050637-6-dwmw2@infradead.org>
 <86jzluz24b.wl-maz@kernel.org>
 <9efb39597fa7b36b6c4202ab73fae6610194e45e.camel@infradead.org>
 <86edc2z0hs.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86edc2z0hs.wl-maz@kernel.org>

On Fri, Mar 22, 2024 at 04:37:19PM +0000, Marc Zyngier wrote:
> On Fri, 22 Mar 2024 16:12:44 +0000,
> David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > On Fri, 2024-03-22 at 16:02 +0000, Marc Zyngier wrote:
> > > On Tue, 19 Mar 2024 12:59:06 +0000,
> > > David Woodhouse <dwmw2@infradead.org> wrote:
> > > 
> > > [...]
> > > 
> > > > +static void __init psci_init_system_off2(void)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       ret = psci_features(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2));
> > > > +
> > > > +       if (ret != PSCI_RET_NOT_SUPPORTED)
> > > > +               psci_system_off2_supported = true;
> > > 
> > > It'd be worth considering the (slightly broken) case where SYSTEM_OFF2
> > > is supported, but HIBERNATE_OFF is not set in the response, as the
> > > spec doesn't say that this bit is mandatory (it seems legal to
> > > implement SYSTEM_OFF2 without any hibernate type, making it similar to
> > > SYSTEM_OFF).
> > 
> > Such is not my understanding. If SYSTEM_OFF2 is supported, then
> > HIBERNATE_OFF *is* mandatory.
> > 
> > The next update to the spec is turning the PSCI_FEATURES response into
> > a *bitmap* of the available features, and I believe it will mandate
> > that bit zero is set.

Correct, but we add a extra check as well to be sure even if it is mandated
unless the spec relaxes in a way that psci_features(SYSTEM_OFF2) need not
return the mandatory types in the bitmask which I doubt.

Something like:
	if (ret != PSCI_RET_NOT_SUPPORTED &&
		(ret & BIT(PSCI_1_3_HIBERNATE_TYPE_OFF)))
		psci_system_off2_supported = true;

This will ensure the firmware will not randomly set bit[0]=0 if in the
future it support some newer types as well.

I understand the kernel is not conformance test for the spec but in
practice especially for such features and PSCI spec in particular, kernel
has become defacto conformance for firmware developers which is sad.
It some feature works in the kernel, the firmware is assumed to be
conformant to the spec w.r.t the feature.

--
Regards,
Sudeep


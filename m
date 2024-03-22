Return-Path: <kvm+bounces-12508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E1B8871A6
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0218C1C2086F
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA9E5FBAA;
	Fri, 22 Mar 2024 17:08:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428D857875;
	Fri, 22 Mar 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127320; cv=none; b=ftHfNboG47kg00f89smO0E7uUA+Zn8fbC/2EOGOwNBMzhXjmSPI4K7LDOsAZMta1LpOZ1bUI8fO5M/goKCYrGoztVx/ku92N2RwuX6yYPRnTCBSmR92NvSuQth2GxzlvL81iVSjO3dD1oIM7lPVxOBf98AL3bCZ1bur0d6jb2tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127320; c=relaxed/simple;
	bh=rUMg9wwIpGTFQYHeRWFvoWGZrl4+3gIHbAdaODaQlcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiUEvTyvYR+nSUNToUsdapfl6NOBVJ6TgG9UFuC88kRbJF+sOXJ38LwFgDBQ9Hhcn32+IfYjN+ml50L7gR8XdKR+9yBAE3fMfn2BEQDzpwWCchXcwcRjWRuJcIvABrbSX5cuEQ5DVaIPnVxNxzDDk8LFrS3oSc4E2vrwjNsukz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7CD7FEC;
	Fri, 22 Mar 2024 10:09:12 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C69BE3F67D;
	Fri, 22 Mar 2024 10:08:35 -0700 (PDT)
Date: Fri, 22 Mar 2024 17:08:33 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
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
Message-ID: <Zf27EW6x5GvKYGjM@bogus>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
 <20240319130957.1050637-6-dwmw2@infradead.org>
 <86jzluz24b.wl-maz@kernel.org>
 <9efb39597fa7b36b6c4202ab73fae6610194e45e.camel@infradead.org>
 <86edc2z0hs.wl-maz@kernel.org>
 <12bc0c787fc20e1a3f5dc2588a2712d996ac6d38.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12bc0c787fc20e1a3f5dc2588a2712d996ac6d38.camel@infradead.org>

On Fri, Mar 22, 2024 at 04:55:04PM +0000, David Woodhouse wrote:
> On Fri, 2024-03-22 at 16:37 +0000, Marc Zyngier wrote:
> > 
> > I agree that nothing really breaks, but I also hold the view that
> > broken firmware implementations should be given the finger, specially
> > given that you have done this work *ahead* of the spec. I would really
> > like this to fail immediately on these and not even try to suspend.
> > 
> > With that in mind, if doesn't really matter whether HIBERNATE_OFF is
> > mandatory or not. We really should check for it and pretend it doesn't
> > exist if the correct flag isn't set.
> 
> Ack.
> 
> I'll rename that variable to 'psci_system_off2_hibernate_supported' then.
> 
> static void __init psci_init_system_off2(void)
> {
> 	int ret;
> 
> 	ret = psci_features(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2));
> 	if (ret < 0)
> 		return;
>
> 	if (ret & (1 << PSCI_1_3_HIBERNATE_TYPE_OFF))
> 		psci_system_off2_hibernate_supported = true;
>

Ah OK, you have already agreed to do this, please ignore my response then.

--
Regards,
Sudeep


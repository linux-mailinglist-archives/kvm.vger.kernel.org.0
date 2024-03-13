Return-Path: <kvm+bounces-11748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 809E987AA7E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7588CB21D2E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F33B47A64;
	Wed, 13 Mar 2024 15:34:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF7346436;
	Wed, 13 Mar 2024 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710344093; cv=none; b=GD/vEGleu00Nec6rQ08gg79XN5c1ddSTDynthzUWnV5l9iBYe9PZIBle4r0PQ91vNaeIQu+2Zx65BYcBAlc8HfkeMUnt7RBg8o79PA6LFzsNFyV0eFSC77hlu6vy49jSPR1xSOH71IHYNSU41qBlyQ4/7ZXPLVp1hcRx18mDV/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710344093; c=relaxed/simple;
	bh=C7nU4SN7cfBWO5pOM0SsB5sh9GBra6/N3Zhn61BhuEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lea6xs6ekQPNdztHYqSibWm716Rm/5J5cCJTt/Hh2/5ZMPcwOjykSXGSH9FqpxMQueIM1uQozOANOcqCB/u6p2LK+AYY7ty7+uhgTvCVmYg4SKwkfbPHVtUy50DSnUO7iCeLqNS8P3av9ihwmr/Xug7403VpdR6kExYlG7MdbBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 354C11007;
	Wed, 13 Mar 2024 08:35:27 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24A883F73F;
	Wed, 13 Mar 2024 08:34:47 -0700 (PDT)
Date: Wed, 13 Mar 2024 15:34:44 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [RFC PATCH 2/2] arm64: Use SYSTEM_OFF2 PSCI call to power off
 for hibernate
Message-ID: <ZfHHlBgSNr8Qm22D@bogus>
References: <20240312135958.727765-1-dwmw2@infradead.org>
 <20240312135958.727765-3-dwmw2@infradead.org>
 <ZfB7c9ifUiZR6gy1@bogus>
 <520ce28050c29cca754493f0595d4a64d45796ee.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520ce28050c29cca754493f0595d4a64d45796ee.camel@infradead.org>

On Tue, Mar 12, 2024 at 04:36:05PM +0000, David Woodhouse wrote:
> On Tue, 2024-03-12 at 15:57 +0000, Sudeep Holla wrote:
> > Looked briefly at register_sys_off_handler and it should be OK to call
> > it from psci_init_system_off2() below. Any particular reason for having
> > separate initcall to do this ? We can even eliminate the need for
> > psci_init_system_off2 if it can be called from there. What am I missing ?
>
> My first attempt did that. I don't think we can kmalloc that early:
>

That was was initial guess. But a quick hack on my setup and running it on
the FVP model didn't complain. I think either I messed up or something else
wrong, I must check on some h/w. Anyways sorry for the noise and thanks for
the response.

-- 
Regards,
Sudeep


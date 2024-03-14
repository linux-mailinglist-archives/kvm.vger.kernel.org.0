Return-Path: <kvm+bounces-11791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8060A87BBB5
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 12:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DA61F220C8
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D3B6EB66;
	Thu, 14 Mar 2024 11:09:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03826D1A1;
	Thu, 14 Mar 2024 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710414561; cv=none; b=WWnP6qTSH4uXXjnn03vWl6l/DXz7vaxNBO3yehMWe0iDBfrW8dlj7nVPP/z18j92d4RrokaxNPCIgkJ0OsFAHI0NprSH5Jq7PEqwHkKX+QakeikO0G2tzBSRj2YzSfOxM6R6zbPAd/IY8cZ4DzejlOXDB66HOA/VNtF/fEKXOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710414561; c=relaxed/simple;
	bh=6BdARhoBU9tqSp7ir1itHAMzpT4LjrEbo4TEjprV4zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQUd8Db7ylpBsc3UWpJAxXmoUXg92DN/DklsRmtmLWP/eKyccjsRawgFsKZ+QE6nYBoKJIjbx6S4ikURXYfu1ESf2jrTLuEk7PQbntIIQhTgIY7Jsbjbzf+kap10Jn8DjLhR0uciiydCl1X83+UC6PR7ZGKyKfmTrgz0H6Ex7G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15778DA7;
	Thu, 14 Mar 2024 04:09:54 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 929A73F73F;
	Thu, 14 Mar 2024 04:09:14 -0700 (PDT)
Date: Thu, 14 Mar 2024 11:09:11 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
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
Message-ID: <ZfLa1_TWArT7tCtb@bogus>
References: <20240312135958.727765-1-dwmw2@infradead.org>
 <20240312135958.727765-3-dwmw2@infradead.org>
 <ZfB7c9ifUiZR6gy1@bogus>
 <520ce28050c29cca754493f0595d4a64d45796ee.camel@infradead.org>
 <ZfHHlBgSNr8Qm22D@bogus>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfHHlBgSNr8Qm22D@bogus>

On Wed, Mar 13, 2024 at 03:34:44PM +0000, Sudeep Holla wrote:
> On Tue, Mar 12, 2024 at 04:36:05PM +0000, David Woodhouse wrote:
> > On Tue, 2024-03-12 at 15:57 +0000, Sudeep Holla wrote:
> > > Looked briefly at register_sys_off_handler and it should be OK to call
> > > it from psci_init_system_off2() below. Any particular reason for having
> > > separate initcall to do this ? We can even eliminate the need for
> > > psci_init_system_off2 if it can be called from there. What am I missing ?
> >
> > My first attempt did that. I don't think we can kmalloc that early:
> >
>
> That was was initial guess. But a quick hack on my setup and running it on
> the FVP model didn't complain. I think either I messed up or something else
> wrong, I must check on some h/w. Anyways sorry for the noise and thanks for
> the response.
>

OK, it was indeed giving -ENOMEM which in my hack didn't get propogated
properly 🙁. I assume you have some configs that is resulting in the
crash instead of -ENOMEM as I see in my setup(FVP as well as hardware).

Sorry for the noise.

--
Regards,
Sudeep


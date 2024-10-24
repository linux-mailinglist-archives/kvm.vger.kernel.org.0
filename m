Return-Path: <kvm+bounces-29635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DA19AE555
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 324D62844E3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0694D1D63CB;
	Thu, 24 Oct 2024 12:46:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331961D5AC8
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729774017; cv=none; b=UP2IwBMMYomY2W3s02aT5gK3zmGhJiEskfaonaqcN1TOAi740HuhVTKVV+CSB4AXt44wbZI1A1KgpQLqE0mSVHakOO067SSx8WJ2deOSBX0EjQMiGmcOvMHrZVnEoV7L291S4SnS7va56ZeSzen02wlZIwqJjY5d4pokS+xiW7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729774017; c=relaxed/simple;
	bh=faGY8SbMfv5UTZZy1gcaiVc0zWchFCtXcnF1CAIOxjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufZATMImCoadAbH5l47ZIp2SbTtze8VgEOCbqZ94MlruRwry3UyNuNyyeoMszbgbgcP/7CR+pPXk+XjuoQbz12kRc4brKXj347vu9HUDSvaz8L0G3jRqim8nphZxzwS6eEDDEaIuGbjVHyQgSsDbdVfryUqtycL1juJRph5hrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D092339;
	Thu, 24 Oct 2024 05:47:24 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 610E83F71E;
	Thu, 24 Oct 2024 05:46:53 -0700 (PDT)
Date: Thu, 24 Oct 2024 13:45:28 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 17/37] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Message-ID: <20241024124528.GA1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-18-maz@kernel.org>
 <33681a4d-2ea4-416e-9e2c-81a89a78c4ed@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33681a4d-2ea4-416e-9e2c-81a89a78c4ed@sirena.org.uk>

On Thu, Oct 24, 2024 at 01:32:09PM +0100, Mark Brown wrote:
> On Wed, Oct 23, 2024 at 03:53:25PM +0100, Marc Zyngier wrote:
> 
> > Add the missing sanitisation of ID_AA64MMFR3_EL1, making sure we
> > solely expose S1PIE and TCRX (we currently don't support anything
> > else).
> 
> >  	case SYS_ID_AA64MMFR3_EL1:
> > -		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE;
> > +
> > +		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
> > +		       ID_AA64MMFR3_EL1_S1PIE;
> 
> The changelog is now out of date, POE has been added.

This will disappear with a rebase won't it? Since you made the same change in 
d4a89e5aee23 ("KVM: arm64: Expose S1PIE to guests"), in Linus' tree.

Thanks,
Joey


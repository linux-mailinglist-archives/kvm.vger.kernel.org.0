Return-Path: <kvm+bounces-17324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A018C434F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C662820C3
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B73F1848;
	Mon, 13 May 2024 14:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCxvi4Vr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B6FA50;
	Mon, 13 May 2024 14:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715610811; cv=none; b=Ht0EeY/L8ESY2gWsYmynQXD38jQjgmt3Z94zAWCclScC4NysWajaHjbfNEVGlGqVxI6RREDj17bMiYLY85Y48l4nsDHHoAmX26VDyM7z0iLWXzET/+XegH4eLi5htM5O0tOXrs+xaZplvoQsBQubg2Lfa8cie/PQxd+YQTBIjmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715610811; c=relaxed/simple;
	bh=9jEc6XmA0JeD1+JytrCC6//7y4ZhOVxPGuwBwfPOHzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjzyJ7SPzisoWNs2zf14w1kll48I/FNErQB5TltZV7NG4/Xl/hr18Qag8OOZ0FRlVWi91M3Esdvv8l2Dffv0sZ+GtysZ40IgAz7nyDhfCmj04n6FBD93bCETS3qNwQ482ITY8dud31j9osdnOW1Y4rOW4qPIGH2eWEjrCtkNxB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCxvi4Vr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA02EC113CC;
	Mon, 13 May 2024 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715610811;
	bh=9jEc6XmA0JeD1+JytrCC6//7y4ZhOVxPGuwBwfPOHzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fCxvi4VrBIynn0VQB9XqYDfNx+t2zPA4u3bbND2INwP6HWYu7HrKY0PLWvDw+xr59
	 YntfxdLievt/TUBO0qYudsP8sbyzeqYJiCPhEtCmFDq8wwIfJYBnxVNj3249vK5rW+
	 3RiyN7VryYl1GIrdtj35TAbae1ix87gL/txem3DgtJBNdueAYS4k6JnoHA3yKo80zR
	 Jle8IQ9mkPMtiLCXiDM4ayD+WY5N/GPtyauvlC88qKyjPW35lmIQP5rG1EoEDsR5FG
	 uZz140esb4qaXe8Yj9qrCDR5Wtb82GvP6Pr3Ce54ZMR67RA5rK9ecAutnKONXQsNlC
	 weIpDhBsXKQrQ==
Date: Mon, 13 May 2024 15:33:26 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 06/12] KVM: arm64: nVHE: gen-hyprel: Skip
 R_AARCH64_ABS32
Message-ID: <20240513143326.GE28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-7-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-7-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:35PM +0100, Pierre-Clément Tosi wrote:
> Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
> the relocation table of the hypervisor. The toolchain might produce them
> when generating function calls with kCFI, to allow type ID resolution
> across compilation units (between the call-site check and the callee's
> prefixed u32) at link time. They are therefore not needed in the final
> (runtime) relocation table.

Hmm. Please can you elaborate a bit more on this? Are these absolute
addresses in the kernel VA space or the hypervisor VA space?

Generally, absolute addressing at EL2 is going to cause problems, so I'm
not keen on waving all R_AARCH64_ABS32 relocs through.

Will


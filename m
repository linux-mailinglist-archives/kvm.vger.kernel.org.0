Return-Path: <kvm+bounces-57815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A54B7D30A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15CAC1881EDB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 06:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A895428934F;
	Wed, 17 Sep 2025 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0QuIRfU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9378285056
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758089375; cv=none; b=bx+xUyAhlFq7H5jwtLSGqM6KTRVwGMKZN15XV6A7snQM/Ig/oc5CFS2VgN1GX9/B6YCr9cpI7ehW6x1chUdrkF5Dt/whwlBKh9WVjLtVArBXZlCpFO3rVVfjYAyzdehfrTQeDNae3f/pXp9K5BaJ5fl+idapuFvQUno5Y4ld+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758089375; c=relaxed/simple;
	bh=XSRSVrrVt6tRErZHncPnme5LE3c3TAeOspXnD5Nklsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Re9oz8xUc1EPaNeOXc027QEayELuM2I8z7OoGHuDfqzhlYy/2SrLkl3M9WqSupK8bagJx86L8U/bhXzoeAjgL7fBHEbai48qveA0qgGyWxNhy6Fc0Dn+KQQ9zH8p3X3beVO1eUC1q7gatBLmU8TRXoSGTf7P5HHKpyaCsVeod9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0QuIRfU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F7C4CEFB;
	Wed, 17 Sep 2025 06:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758089375;
	bh=XSRSVrrVt6tRErZHncPnme5LE3c3TAeOspXnD5Nklsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0QuIRfU/JpBShcX6GhGlRRqEc/sYltHBqkOv1rw7M7nUCPJRXtVQacVS72roLxZw
	 1/gb14l2b9ctXKE31dqoblFym9vZF7ha5QNrUVUeXCmX9j0+Em6i8QDAItXzCjTAkT
	 bu7mMo2QlxifZUNQOi1vfUUniULVhCzP/j+bmQrEKXae87X0EXnyCURGddcAD0JoAM
	 /nd4Etm129xOCM/pdxUpzKF1TVBRDlY66p/EQ1XrzXTx47cUdNU+97rvvVtNW2ZdIJ
	 xQHHMNc6qyBOWwSlYXYRjDCf+k1wMoX+KyOJHiC06VVcRcKA0HjbzR38aaBaNmhVqD
	 0iu/swjtve8mQ==
Date: Wed, 17 Sep 2025 00:23:05 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
Message-ID: <ganorbityq4enbkgjf5xjnitdfs43vgkbplp3s6wwhfj4q355y@dk5fvz2qsqlf>
References: <cover.1756993734.git.naveen@kernel.org>
 <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
 <aMiY3nfsxlJb2TiD@google.com>
 <p4gvfidvfrfpwy6p6cmua3pnm7efigjrbwipsoga7swpz3nmyl@t3ojdu4qx3w6>
 <aMlz5NTt_YA9foOc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMlz5NTt_YA9foOc@google.com>

[Looks like this mail didn't hit the list yesterday, Re-sending...]

On Tue, Sep 16, 2025 at 07:27:48AM -0700, Sean Christopherson wrote:
> On Tue, Sep 16, 2025, Naveen N Rao wrote:
> > On Mon, Sep 15, 2025 at 03:53:18PM -0700, Sean Christopherson wrote:
> > > On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > > > Users who specifically care about AVIC
> > > 
> > > Which we're trying to make "everyone" by enabling AVIC by default (even though
> > > it's conditional).  The only thing that should care about the "auto" behavior is
> > > the code that needs to resolve "auto", everything else should act as if "avic" is
> > > a pure boolean.
> > 
> > This was again about preventing a warning in the default case since 
> > there is nothing that the user can do here.
> 
> Yes, there is.  The user can disable SNP, either in firmware or in their kernel.

Right, that is an option.

I was coming from the perspective that SNP isn't enabled by default (AFAIK).
So, if SNP is enabled on the platform, it implies that the user explicitly
enabled it because they need it. At which point, they may not want to disable
it for AVIC.

> 
> > I think this will trigger on most Zen 4 systems if SNP is enabled.
> 
> Which is working as intended.  Even if the user couldn't resolve the issue (by
> disabling SNP), I would still want KVM to print a message.  My goal isn't to
> provide a pristine kernel log, it's to provide a good experience for end users.
> 
> In my very strong opinion, for this case that means providing the user with as
> much information as possible, at a loglevel that will alert them to an unexpected
> and/or incompatible setup.

Sure, this (SNP enabled) is not a default configuration. I agree that it is
helpful to print a warning here so the user knows why AVIC isn't enabled.


Thanks,
Naveen



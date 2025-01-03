Return-Path: <kvm+bounces-34517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FAE3A0045A
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 07:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 654033A17B3
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 06:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA221BD9C6;
	Fri,  3 Jan 2025 06:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzR20blO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4C31B85FA;
	Fri,  3 Jan 2025 06:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735885602; cv=none; b=uK/0o89KF68cARfY/aK+LX3waaHZ9oHOVbLdxgh0HcLWpISJsqePXadU5RtmsNiZs53miRwfZ8STBm2NPhqjrBQ+IMGMz9Yg6aLIUi6ivjt8uJYNts51uLqRkj3AzjU6RxYHoyT+RcZfLAIPUF1CXq/SsWxk4U0MoKdkn4iYvF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735885602; c=relaxed/simple;
	bh=aF/+aLAuMH/kL/bHHyraAzqvwP02S0rlgq64vO4nxuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aX+HOzEEuGdfJXYP28Clufmh9je28R77MgS8wTDoVCOIiKk8qcKyGojjBPApKSnYMYA7egYNeQ08/P1Dm8lSdsFAnYfFLV1hb2Qb7s7wAcBdiuxQej+XtKFlh3Roi7ekfVkv/AMk+gt94KRpBM8vY5VD/SPbLcCJFcmPEp6BXpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzR20blO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64841C4CECE;
	Fri,  3 Jan 2025 06:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735885601;
	bh=aF/+aLAuMH/kL/bHHyraAzqvwP02S0rlgq64vO4nxuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DzR20blOC5nqMo+VGpx4e2e6Y9gh4AGyzEb3fCxuz1S5zikCiX+Q1UZqBSjIOCoef
	 8gGmwwTDzjq4D4Cph+yT1p3f8CEvnc87aYXXZmVj5kyoS/EVwmn4RE3beTsGZzBRCH
	 nwlMDHXDn4H9ARFRdeDkyVi3vgGMoASANHfaxzmQ=
Date: Fri, 3 Jan 2025 07:26:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, peterx@redhat.com,
	precification@posteo.de, athul.krishna.kr@protonmail.com,
	regressions@lists.linux.dev
Subject: Re: [PATCH] vfio/pci: Fallback huge faults for unaligned pfn
Message-ID: <2025010322-overblown-symptom-d4cd@gregkh>
References: <20250102183416.1841878-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102183416.1841878-1-alex.williamson@redhat.com>

On Thu, Jan 02, 2025 at 11:32:54AM -0700, Alex Williamson wrote:
> The PFN must also be aligned to the fault order to insert a huge
> pfnmap.  Test the alignment and fallback when unaligned.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219619
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: Precific <precification@posteo.de>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You have marked a patch with a "Fixes:" tag for a commit that is in an
  older released kernel, yet you do not have a cc: stable line in the
  signed-off-by area at all, which means that the patch will not be
  applied to any older kernel releases.  To properly fix this, please
  follow the documented rules in the
  Documentation/process/stable-kernel-rules.rst file for how to resolve
  this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot


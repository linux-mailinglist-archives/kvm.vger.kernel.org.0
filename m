Return-Path: <kvm+bounces-9429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C91F98601AE
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67CC31F2733F
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 18:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3926C143C7D;
	Thu, 22 Feb 2024 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XimWD4sc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A65143C70
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708626789; cv=none; b=RGdnUC730ii/VZhtjNKPTdqETKpWdYPNUZcpcwO3/RY5eA+ZM1QVvZ81mJ7DRv5tBRAwmGxK6hqC1Zd36HuI9DpvKYXRtZY1nxMUYPBcoR3P5VUfwn11PWVTk6d1b+B2ABsCfFNKlUjtQv85nwx+cOAETHw15wrBJuprMCPsfHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708626789; c=relaxed/simple;
	bh=V7SjxDZvMzNR4ZyEN08FtuXtrKLpldcOW/wvppjFEbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nq8mxUVrSylH1WLsGD29W6GfvnfvJGn/RUr0qdBGeKa7m08SKCu3t3t6ByJ3jJwo2vgecPzA6KJdwTP4QgjWschLk3vD8uBVMlz4h0KHN4BE3F+DuVUpdiJTeEu4fNuiJ3hwQoapnAoeQpQX70roFFSHRGbE4jdiPhqJWrxMFGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XimWD4sc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C6C433F1;
	Thu, 22 Feb 2024 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708626788;
	bh=V7SjxDZvMzNR4ZyEN08FtuXtrKLpldcOW/wvppjFEbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XimWD4scZoCwdyEkQWCd+Denl+bm6CA2XjJet2vrNHSVz1Q/hHmTiavgqIHd5go8S
	 Odu/ppWgN8kmYxW2GWNEEbYftWIeDx87rXAFlxeVJnWPUis2wbRe81qpML79Aalx+h
	 AfIZ675KV4H8FZsvIvT5iBlWsFT63J6beJdnjs69b2MDFgYJD6HHR0G5FYYrkmdjR9
	 0bgrJFpta75pYs6kKaDaHJVIkK9u3s2m1XQYOEoFy+rkahJXxt40j2CIb2YtnGb6Ly
	 G1qg2xre0QALC9Oqt3oS5cgp4BfyAv/D6ia8Y3D7oVRTss0sG+c2S1qklyTt1NZron
	 PsIiq42LlEHHA==
Date: Thu, 22 Feb 2024 20:33:04 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>,
	"Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Message-ID: <20240222183304.GA54170@unreal>
References: <20240205124828.232701-1-yishaih@nvidia.com>
 <BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
 <1175d7ed-45f3-42d0-a3cb-90ef2df40dbb@nvidia.com>
 <244923bb-7732-4a9b-b5da-6a778ba4dd60@nvidia.com>
 <bdb66db6-cd41-4d0d-bc69-33390953f385@nvidia.com>
 <20240222110405.759b8971.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222110405.759b8971.alex.williamson@redhat.com>

On Thu, Feb 22, 2024 at 11:04:05AM -0700, Alex Williamson wrote:
> On Wed, 21 Feb 2024 09:45:14 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > On 08/02/2024 10:16, Yishai Hadas wrote:
> > > On 06/02/2024 10:06, Yishai Hadas wrote:  
> > >> On 06/02/2024 9:35, Tian, Kevin wrote:  
> > >>>> From: Yishai Hadas <yishaih@nvidia.com>
> > >>>> Sent: Monday, February 5, 2024 8:48 PM
> > >>>>
> > >>>> This series improves the mlx5 driver to better handle some error cases
> > >>>> as of below.
> > >>>>
> > >>>> The first two patches let the driver recognize whether the firmware
> > >>>> moved the tracker object to an error state. In that case, the driver
> > >>>> will skip/block any usage of that object.
> > >>>>
> > >>>> The next two patches (#3, #4), improve the driver to better include the
> > >>>> proper firmware syndrome in dmesg upon a failure in some firmware
> > >>>> commands.
> > >>>>
> > >>>> The last patch follows the device specification to let the firmware 
> > >>>> know
> > >>>> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
> > >>>> migration cancellation, etc.).
> > >>>>
> > >>>> This will let the firmware clean its internal resources that were 
> > >>>> turned
> > >>>> on upon PRE_COPY.
> > >>>>
> > >>>> Note:
> > >>>> As the first patch should go to net/mlx5, we may need to send it as a
> > >>>> pull request format to vfio before acceptance of the series, to avoid
> > >>>> conflicts.
> > >>>>
> > >>>> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
> > >>>> yishaih@nvidia.com/
> > >>>> Patch #2:
> > >>>> - Rename to use 'object changed' in some places to make it clearer.
> > >>>> - Enhance the commit log to better clarify the usage/use case.
> > >>>>
> > >>>> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
> > >>>>  
> > >>>
> > >>> this series looks good to me except a small remark on patch2:  
> > >>
> > >> We should be fine there, see my answer on V0.
> > >>  
> > >>>
> > >>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>  
> > >>
> > >> Thanks Kevin, for your reviewed-by.
> > >>
> > >> Yishai
> > >>  
> > > 
> > > Alex
> > > 
> > > Are we OK here to continue with a PR for the first patch ?
> > > 
> > > It seems that we should be fine here.
> > > 
> > > Thanks,
> > > Yishai
> > >   
> > 
> > Hi Alex,
> > Any update here ?
> 
> Sure, if Leon wants to do a PR for struct
> mlx5_ifc_query_page_track_obj_out_bits, that's fine.  The series looks
> ok to me.  The struct definition is small enough to go through the vfio
> tree with Leon's ack, but I'll leave it to you to do the right thing
> relative to potential conflicts.  Thanks,

Alex, you are right, there is no need to send a PR for the first patch.
Please take it directly through your tree.

We don't have anything in our shared branch this cycle.

Acked-by: Leon Romanovsky <leon@kernel.org>

Thanks

> 
> Alex
> 


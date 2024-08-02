Return-Path: <kvm+bounces-23046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2752B945F56
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB7C81F236ED
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814AB200101;
	Fri,  2 Aug 2024 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApYOQsyx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82EF1E486E
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722608692; cv=none; b=ZL2QN05fLoQ5V5XhczdJUbonPqRRsCf5SvDx1vo7E1uuKFpxNQfw0dY2lRE7u43h9Y6oq02EBWkEkaYATedfkJZlvgC2YgOvLapM+xyNF5p7FLP8892fcqypAVIwaSHMxRaPbW1UFmxj2XuEXIhav4V1zGuGToUjy8dMjEX4uLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722608692; c=relaxed/simple;
	bh=379Wlwv3JNCW6b8cuqyu3kKOn1++1OQZt+E+Z1eV/yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLKjkego+nHrZ3LiRPHAAa0NKGTZ7EYyvqnvjOPSXIvEPgDGWlVs0wIfnGjFkfaBWxR/jBMKFl1H3EMyrhkAXZ8zgMU9ap/9vfY2WI2WJaH5scSVLHaBwi14ITtxcrJtKkpmPqA0iug2VTT9RFJSuQeS2aCmWPyrFaW/d2t9qkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApYOQsyx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C819DC32782;
	Fri,  2 Aug 2024 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722608692;
	bh=379Wlwv3JNCW6b8cuqyu3kKOn1++1OQZt+E+Z1eV/yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ApYOQsyxqbp4XUGGRNdiR3h0B1VJE8Sxgc+SniW2S3sSW/+DT66biKtozf/Z3Tj7y
	 71YLAUCQWPg8d4oPAjZKgDfulti6057quaoy+HYwawx8/kP5T0l41nVUC87Ib4L5Pf
	 aV4ojFHfcP8U1WeZ2iCyIFjvVsebynT7Qb5oriPyE+hC3BT3rdPOo8JT7eZlqfjyEH
	 ouaCCn6tDmo2eCW9oy5vpFvwXAKYSATtuYzwe3V5ipkVISr8bsL6ZMy7udn1WXA9V1
	 AZYmgUZwazI12grQu/RyyB86W0EKKn7kYUWJHVK8lxxxpRgf4PIvztwN9B6EWRKncC
	 Butq9w0rGO6AQ==
Date: Fri, 2 Aug 2024 08:24:49 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Keith Busch <kbusch@meta.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801113344.1d5b5bfe.alex.williamson@redhat.com>

On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> On Thu, 1 Aug 2024 14:13:55 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
>  
> > > We'd populate these new regions only for BARs that support prefetch and
> > > mmap   
> > 
> > That's not the point, prefetch has nothing to do with write combining.
> 
> I was following the original proposal in this thread that added a
> prefetch flag to REGION_INFO and allowed enabling WC only for
> IORESOURCE_PREFETCH.

Which itself follows the existing pattern from
pci_create_resource_files(), which creates a write combine
resource<X>_wc file only when IORESOURCE_PREFETCH is set. But yeah,
prefetch isn't necessary for wc, but it seems to indicate it's safe.


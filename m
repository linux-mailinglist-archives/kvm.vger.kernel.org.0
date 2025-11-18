Return-Path: <kvm+bounces-63441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7E6C66D3C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C36793493ED
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C208D25D216;
	Tue, 18 Nov 2025 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="clOPZIEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E68A41;
	Tue, 18 Nov 2025 01:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763428918; cv=none; b=kJgKGbKP3Do+Y6pcCG0sC50UX6tTUat7C0jQcA5zr2S/vpHMnqzQ6RpqUHDw0w52iVl6zmlVkvgAEgF2RYUMmh7Ekc5iM2GGGNxqBL+83CYZKLZsAJMNx7x3LnW+pEQ9Gp/DbjquMr/ZubCLF9xokPipYkDxPDN/ofD2jJBP/MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763428918; c=relaxed/simple;
	bh=gC0izo8g7qmGTNiJnv07fRED8eg/SxP/5knq30PB2zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lc2KZOSmUjQgiYXurzJx66xSoOkhb9qA0Ah36jFsEbv3th5ngYGilZzE5RY1wkEdxBw6Dxe/rvv3w34gqvJ6SUBjz2Z2LS8Pyk1TOcE+VKmJxLozhGqngo3QZ6+muBxhSmP1pbopT+TVa9YxyO1TF9Gms3wjg39w+5dXYDBRsPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=clOPZIEC; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763428917; x=1794964917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gC0izo8g7qmGTNiJnv07fRED8eg/SxP/5knq30PB2zM=;
  b=clOPZIECgXfZUo/vv1O/Ra7UQINS40713fYxbCNn+y3U5BE0qGBoM1GN
   sPRlLTTdLU3lqd/TloXP/PCy8jaIr9oVr4sCrgbBHISefU6OKjLgEgEH7
   7OkW0Ex/wg144sqsXFbojbTGMRJ1Z0k5PIgZ9iZ867NkR/VXPJjkbQuDZ
   8wvDYAUfVVaaKgQRbye87cSR0J+FgS4HbJqEQFBDogDiJ3QCeiRKydBz7
   SNOwhVBqrT/JCD/PviLgpkfDEA0vfkQK49up/uzkSW314IL82PSuP6G+e
   X/tnoS085f5IQvr3tfHPhqNpNzjWbTOkLMbtasGc57ij4TMaP0oLd3+NE
   A==;
X-CSE-ConnectionGUID: QltTTvd/RvSoqcmayJbQlw==
X-CSE-MsgGUID: hfHOoLz1Sme8V8HnBTZXZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65376493"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="65376493"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:21:56 -0800
X-CSE-ConnectionGUID: fdNxlNY1TEOIV/GNwZacXw==
X-CSE-MsgGUID: vza4yNpCRUWxU8QIhByGHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190282992"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 17 Nov 2025 17:21:52 -0800
Date: Tue, 18 Nov 2025 09:07:08 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 00/26] PCI/TSM: TDX Connect: SPDM Session and IDE
 Establishment
Message-ID: <aRvGvKfoQiNRG9yX@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <64e8f61a-101e-4cfe-8f99-b5f6b9c9afa5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e8f61a-101e-4cfe-8f99-b5f6b9c9afa5@intel.com>

On Mon, Nov 17, 2025 at 03:05:50PM -0800, Dave Hansen wrote:
> On 11/16/25 18:22, Xu Yilun wrote:
> > This is a new version of the RFC [1]. It is based on Dan's
> > "Link" TSM Core infrastructure [2][3] + Sean's VMXON RFC [4]. All
> > together they enable the SPDM Session and IDE Establishment for TDX
> > Connect. This series and its base commits are available in Dan's
> > tsm.git#staging [5].
> 
> What are your expectations from posting this series? You cc'd me on it.
> What would you like me to do with it? Is it ready to be merged? Are you
> looking for reviews?

It is not ready to be merged cause we still have the vmxon dependency,
but I'm still looking for reviews from TDX side so that I can get better
prepared when the dependency solved.

Thanks,
Yilun

> 
> Or, is it just kinda being thrown out here so we can see what you are up to?


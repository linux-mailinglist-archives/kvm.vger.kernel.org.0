Return-Path: <kvm+bounces-11808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CDD87C1BB
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 750311F221CA
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84E77441E;
	Thu, 14 Mar 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RKA3jERa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C36DF53;
	Thu, 14 Mar 2024 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710435661; cv=none; b=mr0VBYDI7AxhVz+m0eNpiitwFWK+fnxrN9ghSsGveiarrR0fteS+HGkPi2BSspg/vWoD+pHMwBqfSYjVPaKvGwXgClJWSuz9skyKXTzY+OF1gkIKYhanj8Fi0SWDl3pVY5XYfG9h+aZljMuQuzap44gUaDeWlAepxdLWOCedW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710435661; c=relaxed/simple;
	bh=50hO5d2Mb/8vWmaOeiJcbg6FUBJ+CEf/cp3Pd+mM7GA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+EkUUWA1LkNeNZnhygxc9ZlpsGsih+oAxQZ9Dm4i7K3ox6w89oClWgMkaE/fSvF5kQyrqJwFNgFD952I5LwUXEVTwrBEfErR+k2mf5xnioA9bqUy9yyXqZpCaXBSPndp4iYDJurfnQ1804e5lDkatK6DXg4aSulagw34niRV4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RKA3jERa; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710435660; x=1741971660;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=50hO5d2Mb/8vWmaOeiJcbg6FUBJ+CEf/cp3Pd+mM7GA=;
  b=RKA3jERaPqLrA1CR3Fo7sCgVa3mjOTXGnfvw5cC/xl+lcvDxEwX02hNC
   AOozvQZV+owcUYFGjdBdc9aJiBjMRlVuHYqQxPKe4I2YYtVPZRR5Whz4b
   TdfAzdg79dUFCYmZ1oGOLZq/ppQ8jZNAfpCMUtRMU4XkZDrreSPozYTAr
   4INpFchDeWyQDlAOnBrIdUizLn5FglU3SC2PdW6PGFF6ORDWRlKVVk+8F
   HsB23KNm+21IZND0cMWOPXH6NduWtbaeL6YqERq8p0ai05yBzxpOZPSGq
   MUAQ5IqmvrnY1OfTxpZ46OBeJZnAh4tkXkDa0qE9dvIZXJo9xKsitMNRj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5470024"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5470024"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 10:00:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="17021417"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 10:00:53 -0700
Date: Thu, 14 Mar 2024 10:00:53 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 033/130] KVM: TDX: Add helper function to read TDX
 metadata in array
Message-ID: <20240314170053.GA1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
 <2ffcdb7b-79c1-4516-b889-55316b480cb0@linux.intel.com>
 <06fab911-2364-4b1d-81f4-1517da334507@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <06fab911-2364-4b1d-81f4-1517da334507@linux.intel.com>

On Thu, Mar 14, 2024 at 10:35:47PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/14/2024 5:17 PM, Binbin Wu wrote:
> > 
> > 
> > On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > To read meta data in series, use table.
> > > Instead of metadata_read(fid0, &data0); metadata_read(...); ...
> > > table = { {fid0, &data0}, ...}; metadata-read(tables).
> > > TODO: Once the TDX host code introduces its framework to read TDX
> > > metadata,
> > > drop this patch and convert the code that uses this.
> > 
> > Do you mean the patch 1-5 included in this patch set.
> > I think the patch 1-5 of this patch set is doing this thing, right?
> > 
> > Since they are already there, I think you can use them directly in this
> > patch set instead of introducing these temp code?
> I may have some mis-understanding, but I think the TODO has been done,
> right?

I meant the following patch series.
https://lore.kernel.org/kvm/cover.1709288433.git.kai.huang@intel.com/

If (the future version of) the patch series doesn't provide a way to read
one metadata with size, we need to keep this patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


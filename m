Return-Path: <kvm+bounces-16068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 727A28B3DB0
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 271471F2341C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3447515CD63;
	Fri, 26 Apr 2024 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGdUqkNM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8515B120;
	Fri, 26 Apr 2024 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151752; cv=none; b=bSqGElZ7Ch6Y+Y79+7BVCPXJoOm6YZlm6YCsSeOYDGlP6sPK6qUylvWkasGVH3312lzrB4QZU5I0/ztiUZDLpe/9hVv0emiioFJPP97wpQwNz2+T4Bh7iHt+XTbWw3ximQLWvHf8c1Uc5mbYHQFeYiLzQiWL4aRHbf93wg8HNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151752; c=relaxed/simple;
	bh=4mGPU/2ttUbb1akTXtb4be4f9oyI2PMbjIcwedTgQJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m17aH/6xPfMRjVSVT8eovHVNhojy8Kv3U3jhNahrTF2555XXiLjlpJQGitV9Bf5QxpiyHlSLWsA7hPltZTHMqFpO2pFiJFUi9Fb+PmqdG2MVyqZmeJ3p/VPX65nP7MlSnM+OQMy3xdqvYdwWuo4+7FdMRkjSe7ADPzd6c+GiNCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGdUqkNM; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714151751; x=1745687751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4mGPU/2ttUbb1akTXtb4be4f9oyI2PMbjIcwedTgQJM=;
  b=RGdUqkNMR4UzTqd4awzccFNJbIa8R9TfnDJPbM0gfoDQ6xDlkcOG26Sy
   Thyj/tgPlZWIqucmgNziOW1a6zooqUxSCzWVNpCV20vFZXTL7GyIZw4Y7
   kQPCNGx8204j3aPGS2Dr9PK0oqmQOZrU4iAsjuAV9oOCOrS/MIMgIh95j
   YduziLT3ctwTDWj5ew99rabr6ypEg4DjX9FbdgIF6AxW4jR4jmmKIfELr
   iR6KwnfxIuI2blvm1rkjb1RE5kEuKj5S/lCT4Obn9qcFDV+UfFcdJocTJ
   /V7DB7rSdISni7+J/tx3rQ87l7GLNOV+ZL5COrz5tKA9IQkw+4YgCS4Zo
   g==;
X-CSE-ConnectionGUID: 0ynKqLBbQvWRTDadmLtSpA==
X-CSE-MsgGUID: lgescHGkRpqF8Agg1FXsrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="21044173"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="21044173"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:15:50 -0700
X-CSE-ConnectionGUID: M64mleqJSvC+pOxFXSFl8g==
X-CSE-MsgGUID: AdDV9kkoQOyTHuDgNG0Faw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="25358639"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:15:47 -0700
Date: Fri, 26 Apr 2024 10:15:46 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.roth@amd.com, isaku.yamahata@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Message-ID: <20240426171546.GR3596705@ls.amr.corp.intel.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com>
 <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com>
 <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com>
 <20240425165144.GQ3596705@ls.amr.corp.intel.com>
 <CABgObfbAzj=OzhfK2zfkQmeJmRUxNqMSHeGgJd+JGjsmwC_f1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbAzj=OzhfK2zfkQmeJmRUxNqMSHeGgJd+JGjsmwC_f1g@mail.gmail.com>

On Fri, Apr 26, 2024 at 07:44:40AM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Thu, Apr 25, 2024 at 6:51 PM Isaku Yamahata <isaku.yamahata@intel.com> wrote:
> > > AFAIK, unwinding on failure is completely uninteresting, and arguably undesirable,
> > > because undoing LAUNCH_UPDATE or PAGE.ADD will affect the measurement, i.e. there
> > > is no scenario where deleting pages from guest_memfd would allow a restart/resume
> > > of the build process to truly succeed.
> >
> >
> > Just for record.  With the following twist to kvm_gmem_populate,
> > KVM_TDX_INIT_MEM_REGION can use kvm_gmem_populate().  For those who are curious,
> > I also append the callback implementation at the end.
> 
> Nice, thank you very much. Since TDX does not need
> HAVE_KVM_GMEM_PREPARE, if I get rid of FGP_CREAT_ONLY it will work for
> you, right?

Yes, that's right.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


Return-Path: <kvm+bounces-34518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7CCA00581
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 09:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C713A3195
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 08:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1321BD014;
	Fri,  3 Jan 2025 08:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y5ZZ6fk0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AC5A93D
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 08:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735891638; cv=none; b=RyLm3HatnahidcjgTuSXfxNoDF55J1/48zCzKzvFssOtUat3slWhb4DeRC3Cyts0mB+4W6tmkxU2s0UNizHahfU1ri55Ikl5x4Zmsw3TyWOBL2n6PmkCUCsSm1S80ucrk3Tj57K3Z5zhD/sowTdAEGh/yIzxeZkviWyIGZd9nhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735891638; c=relaxed/simple;
	bh=V9eWh/15VXEA7gCguj+BFRdYMLZ5oi0QEKqx0Wixdm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbjsEbziUF8Pib7tlSg5R43/aB5a3SA0UxEDRtT/jdYFZ0D1NW3KK/5GwheYDAHEo1qRODvUOZ5rdknScgLUeaCWb6YsP9CleQyfEIJBCvpwidQOpH/t6u9UawSVg5/zCvJemukNHOE7IAZrswV36LKVYJF34E1KzdJ/pdH62ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y5ZZ6fk0; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735891636; x=1767427636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=V9eWh/15VXEA7gCguj+BFRdYMLZ5oi0QEKqx0Wixdm0=;
  b=Y5ZZ6fk0KQ0uvx6xRJn2P6FOsFEC2QNYVit3DkJeWdVjZ5c0o8nMHcob
   BqwW+u7bLSMtHgOm7i/gt/bn3hSBp+eQ2wNOuaxjQtJgf9c51FOyMTCbV
   bGKaES0XmFXUE6o8GSEQ0yip4zSXFj1rR2nD7c2KQVc42yJwvxlyYOirj
   foSGXhAIX1uAdnToUV1xuQS6JmdHZsO7KNOEtonnLLqsrGb5EWZL/Lnno
   qi6HZT+hhje+lK4HFQ5ZtpBHf/yJnBNhuIJuAcDVEkTP6b4coE/vYQUWm
   fzLSvkyVxxWAet3g95acXn/D/0jTPeG4sIZFhTVsjlbG24nL08TX64VYe
   w==;
X-CSE-ConnectionGUID: 0CfYLv1sS1+mId96A8+GmQ==
X-CSE-MsgGUID: wGMEaycZS7e75a6C2efjTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="47127276"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="47127276"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 00:07:16 -0800
X-CSE-ConnectionGUID: GVxnOHgASdqfBFLYpSpnkQ==
X-CSE-MsgGUID: IoJpPDfHRa+7zTghEf19Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="106708690"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 03 Jan 2025 00:07:13 -0800
Date: Fri, 3 Jan 2025 16:25:58 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Rob Herring <robh@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
Message-ID: <Z3efFsigJ6SxhqMf@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
 <44212226-3692-488b-8694-935bd5c3a333@redhat.com>
 <Z2t2DuMBYb2mioB0@intel.com>
 <20250102145708.0000354f@huawei.com>
 <CAL_JsqKeA4dSwO40VgARVAiVM=w1PU8Go8GJYv4v8Wri64UFbw@mail.gmail.com>
 <20250102180141.00000647@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250102180141.00000647@huawei.com>

On Thu, Jan 02, 2025 at 06:01:41PM +0000, Alireza Sanaee wrote:
> Date: Thu, 2 Jan 2025 18:01:41 +0000
> From: Alireza Sanaee <alireza.sanaee@huawei.com>
> Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
> X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
> 
> On Thu, 2 Jan 2025 11:09:51 -0600
> Rob Herring <robh@kernel.org> wrote:
> 
> > On Thu, Jan 2, 2025 at 8:57 AM Alireza Sanaee
> > <alireza.sanaee@huawei.com> wrote:
> > >
> > > On Wed, 25 Dec 2024 11:03:42 +0800
> > > Zhao Liu <zhao1.liu@intel.com> wrote:
> > >  
> > > > > > About smp-cache
> > > > > > ===============
> > > > > >
> > > > > > The API design has been discussed heavily in [3].
> > > > > >
> > > > > > Now, smp-cache is implemented as a array integrated in
> > > > > > -machine. Though -machine currently can't support JSON
> > > > > > format, this is the one of the directions of future.
> > > > > >
> > > > > > An example is as follows:
> > > > > >
> > > > > > smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> > > > > >
> > > > > > "cache" specifies the cache that the properties will be
> > > > > > applied on. This field is the combination of cache level and
> > > > > > cache type. Now it supports "l1d" (L1 data cache), "l1i" (L1
> > > > > > instruction cache), "l2" (L2 unified cache) and "l3" (L3
> > > > > > unified cache).
> > > > > >
> > > > > > "topology" field accepts CPU topology levels including
> > > > > > "thread", "core", "module", "cluster", "die", "socket",
> > > > > > "book", "drawer" and a special value "default".  
> > > > >
> > > > > Looks good; just one thing, does "thread" make sense?  I think
> > > > > that it's almost by definition that threads within a core share
> > > > > all caches, but maybe I'm missing some hardware configurations.
> > > > >  
> > > >
> > > > Hi Paolo, merry Christmas. Yes, AFAIK, there's no hardware has
> > > > thread level cache.  
> > >
> > > Hi Zhao and Paolo,
> > >
> > > While the example looks OK to me, and makes sense. But would be
> > > curious to know more scenarios where I can legitimately see benefit
> > > there.
> > >
> > > I am wrestling with this point on ARM too. If I were to
> > > have device trees describing caches in a way that threads get their
> > > own private caches then this would not be possible to be
> > > described via device tree due to spec limitations (+CCed Rob) if I
> > > understood correctly.  
> > 
> > You asked me for the opposite though, and I described how you can
> > share the cache. If you want a cache per thread, then you probably
> > want a node per thread.
> > 
> > Rob
> > 
> 
> Hi Rob,
> 
> That's right, I made the mistake in my prior message, and you recalled
> correctly. I wanted shared caches between two threads, though I have
> missed your answer before, just found it.
> 

Thank you all!

Alireza, do you know how to configure arm node through QEMU options?

However, IIUC, arm needs more effort to configure cache per thread (by
configuring node topology)...In that case, since no one has explicitly
requested the need for cache per thread, I can disable cache per thread
for now. I can return an error for this scenario during the general
smp-cache option parsing (in the future, if there is a real need, it can
be easily re-enabled).

Will drop cache per thread in the next version.

Thanks,
Zhao



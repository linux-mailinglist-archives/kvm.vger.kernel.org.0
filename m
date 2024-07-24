Return-Path: <kvm+bounces-22168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8862993B332
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 16:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4259A282A24
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 14:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83293158D80;
	Wed, 24 Jul 2024 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNdj92qp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5138383A9
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721832887; cv=none; b=qHRZ/01cRpPEEKSuKppx5w7z5Aa+xiinxrKHbwkqzLle5Ny7aMs4fU5Ogfo0G3Z9vYPXAHNwQpxJRw4C0KrVg4STTqZxi/PF9VasJiQie2T+QcJHRP0lUM3aqMWdt6rQFEPSJ9t1L2Wk/WfFXH0LAgmi1yWajfQazvRP7MtJVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721832887; c=relaxed/simple;
	bh=nhEKDuTNwPMDwruusMMbK1Dm5j0cygvuqJe3rM266dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5H0j7Z6pFo7oA3Pl7/J0cyBF1iNXrt0aZzvBJYVuiUF5+//aqZ0cxmmjhcqz4chcu2Zawq4Livfk8yI4wNHbrn0PjvelBR6yAVeteYTB9gM9z6E0Bs/aLO6VGg02+rAAG6PnQP7XOkjheVAo56ZwC2aVYi8/3z9EvldRpnejQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNdj92qp; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721832886; x=1753368886;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nhEKDuTNwPMDwruusMMbK1Dm5j0cygvuqJe3rM266dI=;
  b=aNdj92qpAupv3/YBg05ZNqjb7gUaw7Bt2wT0a04oaYsxvLnbxUoh7bq9
   jKvAzxBgkKvFybaNhWjot72C5P66dUcUWyNc2oFPFUrPNYJZguNxRR+VW
   +N6jjff3Xyy2AcH2dQTD7IqKHfzDavpA3ZC1Xbz3mrlDLGneOq/6mwdpa
   ANOWMvsaTvrv9q7BdSzTVQSIm1kLxpzuSUf5dmiLVjdeW3SqrBMg6t8rK
   b65mJzPEw2FOEsi+aP6cLYLYpwPDC/T6pIPugnr3VbBAanPFft4rtQUqv
   0+PaJWcpPD6K38m921bOtANi7njmNpGSfh135fLrhkS/iDT2klt6Kuj5w
   Q==;
X-CSE-ConnectionGUID: 2rPOvTDjTsuNQsRxiV7hZA==
X-CSE-MsgGUID: LKIKVICzR5itj4Yy51bXYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="44941947"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="44941947"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 07:54:45 -0700
X-CSE-ConnectionGUID: SQlBHtnfSNazf+k8B1Ve8g==
X-CSE-MsgGUID: gsHTaE3GT0aVEU/MKedVwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="57749094"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 24 Jul 2024 07:54:40 -0700
Date: Wed, 24 Jul 2024 23:10:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ++/vQ==?= <berrange@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <ZqEZYEAkMhqBRtbx@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
 <Zp5tBHBoeXZy44ys@intel.com>
 <87h6cfowei.fsf@pond.sub.org>
 <ZqD31Oj5P0uDMs-I@redhat.com>
 <ZqEJlmR3U6g8zq0z@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqEJlmR3U6g8zq0z@intel.com>

Hi Daniel,

On Wed, Jul 24, 2024 at 10:03:02PM +0800, Zhao Liu wrote:
> Date: Wed, 24 Jul 2024 22:03:02 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> 
> On Wed, Jul 24, 2024 at 01:47:16PM +0100, Daniel P. Berrang? wrote:
> > Date: Wed, 24 Jul 2024 13:47:16 +0100
> > From: "Daniel P. Berrang?" <berrange@redhat.com>
> > Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> > 
> > On Wed, Jul 24, 2024 at 01:35:17PM +0200, Markus Armbruster wrote:
> > > Zhao Liu <zhao1.liu@intel.com> writes:
> > > 
> > > > Hi Markus,
> > > >> SmpCachesProperties and SmpCacheProperties would put the singular
> > > >> vs. plural where it belongs.  Sounds a bit awkward to me, though.
> > > >> Naming is hard.
> > > >
> > > > For SmpCachesProperties, it's easy to overlook the first "s".
> > > >
> > > >> Other ideas, anybody?
> > > >
> > > > Maybe SmpCacheOptions or SmpCachesPropertyWrapper?
> > > 
> > > I wonder why we have a single QOM object to configure all caches, and
> > > not one QOM object per cache.
> > 
> > Previous versions of this series were augmenting the existing
> > -smp command line.
> 
> Ah, yes, since -smp, as a sugar option of -machine, doesn't support
> JSON. In -smp, we need to use keyval's style to configure as:
> 
> -smp caches.0.name=l1i,caches.0.topo=core
> 
> I think JSON is the more elegant way to go, so I chose -object.

I may have to retract this assertion considering more issues, I could
fall back to -smp and support it in keyval format, I think it's also ok
for me if you also like keyval format, sorry for my repetition, we can
discuss this in this thread:

https://lore.kernel.org/qemu-devel/20240704031603.1744546-1-zhao1.liu@intel.com/T/#m8adba8ba14ebac0c9935fbf45983cc71e53ccf45

Thanks,
Zhao




Return-Path: <kvm+bounces-42294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0162BA77540
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 09:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E827188AA54
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094651E5B9F;
	Tue,  1 Apr 2025 07:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bUDuehkk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA6F4ED
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743492820; cv=none; b=EBNSrthgqQuV3A8NHetjS9hvziTpShgE2rI6o9myvL7yJRlOBDeM2W3mHpdSMmf4A20V09wkSNwRe+NK2F1eqvlPpz0DZwzd9aVhQAM7OBslZmDYoQ6QdAG85Tb/J2hdYd63Hbb25psL5UkJFPT0GAV5sDr0HkDl1nnN8M9tkzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743492820; c=relaxed/simple;
	bh=sS4rHhY6syIz0P638wU0Dc52eTVGG8/lD+UZkHM565c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPuM4b7/dyIbBoV0K729fBKC3JUEQX6Bmpgwd4kZNz9l0epXSBgmnPMAXMD4GBveF06jpvp/TxLr9OP3GLDVIDyv5PZrY1tZGsHvajzFjNoEnANPkc/UCRShvSfMedd2BHPsh43CTVv4sCckEq4hmvKO2ioEHqOXzYPLrNjPr/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bUDuehkk; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743492818; x=1775028818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sS4rHhY6syIz0P638wU0Dc52eTVGG8/lD+UZkHM565c=;
  b=bUDuehkkGOkDC/aWVqIUpZd3vs29vA2qhoPDrIRNEWcRHFzuciMHnLiO
   wdzixUdYU5dWQGMuTbD2/JOnWRVkBQFBGmX07lyMHaJCpgrPzzn3p7FI0
   mhImDn/aQks3ASgducS+HoXl6wOul/8ATW6h0ynxMgxBwkgCPwfYRSfpg
   Bo93M3eqhX72DUcvzL+1Hs6SfNaS/CfaYiqvHkSz2seHMxZh0jTISnt0G
   MSF06Yr7VMmXwhn+4xANWZhSF0AgypE+CABIHynX0J1w5DgyqwXz8Blwx
   IkDCS/Wg8GjRcNbERRrZYEYScWF6XnS3mGKVTKWzes5fw72cjJ4brl6fu
   g==;
X-CSE-ConnectionGUID: /PN8HPxHQTGtmBKzO1qvFA==
X-CSE-MsgGUID: vAX57gA2TuGTjGo6bJEX9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44928855"
X-IronPort-AV: E=Sophos;i="6.14,292,1736841600"; 
   d="scan'208";a="44928855"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 00:33:37 -0700
X-CSE-ConnectionGUID: AR3XhP4ATMWtzCG8fT0big==
X-CSE-MsgGUID: 8DDo80f7Tx+XNRe1i+nFEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,292,1736841600"; 
   d="scan'208";a="131023314"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 01 Apr 2025 00:33:33 -0700
Date: Tue, 1 Apr 2025 15:53:53 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ++/vQ==?= <berrange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <Z+ubkUrUMgvo2y/h@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-4-zhao1.liu@intel.com>
 <87zfj01z8x.fsf@pond.sub.org>
 <Z6SG2NLxxhz4adlV@intel.com>
 <Z6SEIqhJEWrMWTU1@redhat.com>
 <878qqjqskm.fsf@pond.sub.org>
 <Z6TFr49Cnhe1s4/5@intel.com>
 <Z6TNMZbonWmsnyM7@intel.com>
 <87o6zdhpk7.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o6zdhpk7.fsf@pond.sub.org>

> > +##
> > +# @KVMPMUX86SelectUmaskEvent:
> > +#
> > +# x86 PMU event encoding with select and umask.  Using the X86_PMU_RAW_EVENT
> > +# macro, the select and umask fields will be encoded into raw foramt and
> > +# delivered to KVM.
> 
> Doc comments are for the QMP reference manual, i.e. for users of QMP.
> Explaining the QMP interface in terms of its implementation in QEMU is
> not nice.

Thank you! I could add doc comments in kvm-pmu.h and delete redundant
comments from QMP reference manual.

Regards,
Zhao



Return-Path: <kvm+bounces-44069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EC6A9A114
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A745A14F1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA981D9A5D;
	Thu, 24 Apr 2025 06:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IsXJoeod"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6FD2701B8
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475149; cv=none; b=Jngg8srYp13FmfStpDkmLPvN0WQgmdwo95rvtvNejlrwTlz983p7RYVb6VJ2WODRdhO8Adxn1Inwxcpie2DQwRFZwtLfx+IguFJF18XaehX0aIPsvkVoyyP2Z3z+j27wO2d0otwNBSwtuzO8NpDXcPonZD6UK3tXtob8tLZv6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475149; c=relaxed/simple;
	bh=+wR3q3TpP6Sy48Z2TnhaEs8cnjRG2sHsyvRLGH/8NIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGYrLSXmXNG3buemFgxGFzBH4fFQyGsiyk0oCrw9WcxNg55lKPYwU3lrJV22y65fcvqf7xPG1GGkZuvLcv2uMZoWSZhI0j84Iigjqtb9hRYLVrOByoWitNrX0OSrChkAZEF6kOs+oh1P/SV2yE7uoOXRsFmfPiZUGBLuwFqWWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IsXJoeod; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745475147; x=1777011147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+wR3q3TpP6Sy48Z2TnhaEs8cnjRG2sHsyvRLGH/8NIU=;
  b=IsXJoeodYX1LXG8pYhSgXHPWO2aFx2ly/QMxfEIJrYv39lqjvycM81AL
   sypUpM8ugZ7vom5mMKj8okrtUoYyNQlyI9ZRYmbloeueKajSjs507EBpo
   saD7gV77fGChCq6hO7n5Q3ln7figOcpqYKdMLjGpAw9lV8VqJq8m5MPo5
   9AxCKimp7i+hHt+IrbKrnNahsYUk7LjANWd1bhqsLFybA+loKZFoNLKFY
   cQOadnJRJxM+BISjnxwvDTxAvt+QSiiZqNqq+AhWPEVhoTUtsPvMOmC0m
   JY+37nOLn0fLCbjRE3nVfFiI5YRq/SHsla+1Tj+vCQiO/95zOpTjYJ008
   A==;
X-CSE-ConnectionGUID: WhGTNvhgTxa9jQE0VWH+aQ==
X-CSE-MsgGUID: Wnso+yyNTlaOiFrNfkmCQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="50915754"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="50915754"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:12:26 -0700
X-CSE-ConnectionGUID: AXBQj+KTTMui2ZOnky74AQ==
X-CSE-MsgGUID: /zjX24e/S2i0kYYfnU6H3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="137696301"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 23 Apr 2025 23:12:22 -0700
Date: Thu, 24 Apr 2025 14:33:18 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <aAnbLhBXMFAxE2vT@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-2-zhao1.liu@intel.com>
 <878qo8yu5u.fsf@pond.sub.org>
 <Z/iUiEXZj52CbduB@intel.com>
 <87frifxqgk.fsf@pond.sub.org>
 <Z/i3+l3uQ3dTjnHT@intel.com>
 <87fri8o70b.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fri8o70b.fsf@pond.sub.org>

Hi Markus,

> > This is for security purposes, and can restrict Guest users from
> > accessing certain sensitive hardware information on the Host via perf or
> > PMU counter.
> >
> > When a PMU event is blocked by KVM, Guest users can't get the
> > corresponding event count via perf/PMU counter.
> >
> > EMM, if ¡®system¡¯ refers to the QEMU part, then QEMU is responsible
> > for checking the format and passing the list to KVM.
> >
> > Thanks,
> > Zhao
> 
> This helped some, thanks.  To make sure I got it:
> 
> KVM can restrict the guest's access to the PMU.  This is either a
> whitelist (guest can access exactly what's on this list), or a blacklist
> (guest can access exactly what's not this list).

Yes! The "action" field controls if it's a "whitelist" (allow) or
"blacklist" (deny).

And "access" means Guest could get the event count, if "no access", then
Guest would get nothing.

For example, if we set a the whitelist ony for the event (select: 0xc4,
umask: 0) in QEMU:

pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"x86-select-umask","select":196,"umask":0}]}'

then in Guest, this command tries to get count of 2 events:

perf stat -e cpu/event=0xc4,name=branches/,cpu/event=0xc5,name=branch-misses/ sleep 1

Since another event (select: 0xc5, umask: 0) is not on whitelist, its
"access" is blocked by KVM, so user would get the result like:

 Performance counter stats for 'sleep 1':

            348709      branches
                 0      branch-misses

       1.015962921 seconds time elapsed

       0.000000000 seconds user
       0.015195000 seconds sys

The "allowed" event has the normal output, and the result of "denied"
event is zero.

> QEMU's kvm-pmu-filter object provides an interface to this KVM feature.

Yes!

> KVM takes "raw" list entries: an entry is a number, and the number's
> meaning depends on the architecture. 

Yes, and meaning also depends on format. masked-entry format has special
meaning (with a flag).

> The kvm-pmu-filter object can take such entries, and passes them to
> straight to KVM.
> 
> On x86, we commonly use two slightly higher level formats: select &
> umask, and masked.  The kvm-pmu-filter object can take entries in either
> format, and maps them to "raw".
>
> Correct?

Yes, Markus, you're right! (And sorry for late reply.)

And "raw" format as a lower level format can be used for other arches
(e.g., ARM).

Thanks,
Zhao



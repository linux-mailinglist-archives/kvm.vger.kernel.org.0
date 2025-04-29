Return-Path: <kvm+bounces-44686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF838AA0252
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E20AD7A5E08
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F12026FA54;
	Tue, 29 Apr 2025 06:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EXCu5sAY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E512741D6
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 06:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906613; cv=none; b=X4Wr4bnDFA5GvAqpQHHVxZR1eZ2k8F5JnXuN0g1jtZy6DkjuRM8jghOlzCFX7bgtpxTYzdOjwEMFGMTVrpToM5hmWQbUrtHMxTAq7VtCPmMnhoLlWZlIdpmRpa9oJUPms5HK5X8CAo6tw2PR9QQuW0VXiTXbsKYz+EUl3oxlSsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906613; c=relaxed/simple;
	bh=Y/6SsQsFPmZzG1yqe9KNbE234gRASllcF7yURiWMsc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hw6I489iLvcxEI9mSWLM0DsDAKq6jqf6uLrvdCXu7Ni7j5XhihKvyXPgLDRrt5SWk3O1nGbyslUYfFxAm177C9QBUqaGxGht6zwXZfFblFm18L1UgIb6uOIkfuF4je/yuHQKy6qk0r69kvuU8QuSfBvf53vaS5ricx+NnAhmkY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EXCu5sAY; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745906612; x=1777442612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y/6SsQsFPmZzG1yqe9KNbE234gRASllcF7yURiWMsc4=;
  b=EXCu5sAYY2yFe+5MbuVMFBZPSfJN1WdpJj4kh/nS/BDvU841LfOFALbB
   9doI9sTYUSRzm1N4Z+uXZJwjmegjB+aJiJIOzosiDgRaVYyghwv4EaSva
   dTBPsffBqsxHajhZ3H127J0fZ9VTrwGa1HWrf6erDfP8LnPSf8N/tZb4i
   SAzVdTY52z2NgzttJ+sw9UwrG1RpQPnF+7LsuQZ3rMRT9A1efr4yd/ea1
   knKv4zBI8yRNc0pnnzEvM8mk2J6RR8VHV1jsAzpIxgkaM9hlPwiWBDk/H
   GQF2Z/6BTqzQXDNLx/BfMm6SlY7K1GIsswlSGII+ZvqP8kSZ/w2VXwVpd
   w==;
X-CSE-ConnectionGUID: uUtVo1QjSNGt4dVssN1erA==
X-CSE-MsgGUID: Jx8KT5dHRMaPuT1XyKZ2iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58881337"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="58881337"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 23:03:31 -0700
X-CSE-ConnectionGUID: +FC4s7NbQ9O8szr9018u1A==
X-CSE-MsgGUID: btLFCSAaS12P/HF88J38mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="164679601"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 28 Apr 2025 23:03:27 -0700
Date: Tue, 29 Apr 2025 14:24:24 +0800
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
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	pierrick.bouvier@linaro.org
Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <aBBwmDnZ5v7tpAkr@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-4-zhao1.liu@intel.com>
 <87frhwfuv1.fsf@pond.sub.org>
 <aA3TeaYG9mNMdEiW@intel.com>
 <87h6283g9g.fsf@pond.sub.org>
 <aA+Ty2IqnE4zQhJv@intel.com>
 <87ldrks17s.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldrks17s.fsf@pond.sub.org>

> > What I'm a bit hesitant about is that, if different arches add similar
> > "conditional" enumerations later, it could cause the enumeration values
> > to change under different compilation conditions (correct? :-)). Although
> > it might not break anything, since we don't rely on the specific numeric
> > values.
> 
> Every binary we create contains target-specific code for at most one
> target.  Therefore, different numerical encodings for different targets
> are fine.
> 
> Same argument for struct members, by the way.  Consider
> 
>     { 'struct': 'CpuModelExpansionInfo',
>       'data': { 'model': 'CpuModelInfo',
>                 'deprecated-props' : { 'type': ['str'],
>                                        'if': 'TARGET_S390X' } },
>       'if': { 'any': [ 'TARGET_S390X',
>                        'TARGET_I386',
>                        'TARGET_ARM',
>                        'TARGET_LOONGARCH64',
>                        'TARGET_RISCV' ] } }
> 
> This generates
> 
>     #if defined(TARGET_S390X) || defined(TARGET_I386) || defined(TARGET_ARM) || defined(TARGET_LOONGARCH64) || defined(TARGET_RISCV)
>     struct CpuModelExpansionInfo {
>         CpuModelInfo *model;
>     #if defined(TARGET_S390X)
>         strList *deprecated_props;
>     #endif /* defined(TARGET_S390X) */
>     };
>     #endif /* defined(TARGET_S390X) || defined(TARGET_I386) || defined(TARGET_ARM) || defined(TARGET_LOONGARCH64) || defined(TARGET_RISCV) */
> 
> The struct's size depends on the target.  If we ever add members after
> @deprecated_props, their offset depends on the target, too.

Thank your for further explanation!

Regards,
Zhao



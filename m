Return-Path: <kvm+bounces-44488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75388A9E04A
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5B2A463FED
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4DE245029;
	Sun, 27 Apr 2025 07:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1P+d4Jj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0171F4E39
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 07:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745737530; cv=none; b=hPJJ9IfLGlXR2148NJl64vekTefmqocSUjazvRqOj0IXOwgZ0yTE8RgYri1cR2W/hVQHxHcwAtCBVawfhgQ7LZabWpnlD8a8a1x48oIUJ6fTh6+YSoHIxGYUlvBoQ9izSz1AA8n4pVm8yMLT9N9hMlkk9VZaUQ9kgAEt339NEEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745737530; c=relaxed/simple;
	bh=/VAXcw1oJpNq80iCbs63zP5UG4yX37TNo7LthnbGVBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYkn0JHrJv4qcgFnlbf1YCZmECmzZeTtm/gf8dEF3d259lNkIpT/u3A52cl1t+oLvQU72Rd4o2wz+FFjoH77jIRtLbdYHOQtKm//KunGkZYaufCgQsZcBJmPLyZs9dg0qASQF0DH2XHM0Oam0pIDgsf/AtcgIWUZ9Ia7v6qK/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1P+d4Jj; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745737529; x=1777273529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/VAXcw1oJpNq80iCbs63zP5UG4yX37TNo7LthnbGVBo=;
  b=e1P+d4Jji5f9mpQzeKl3575fO364ueL0+bDQhwTj28d9ZI7Ltc0PAim2
   mVuBlN5DvRgDFG1IQ6lPe/NZ3ozeTpWyLGj4GsJlekbCVzb+b+eF7H1Ad
   EvbgxH2vk+9j2hith5THLnj0vYhilEr3whgY/7oLDuL6khLNn0P0r+RJl
   kFwml8UAcWfvhIx1xobyzgkkkTZBgoFEGbAgouQHXDePrg7pgaGb9sw2A
   cszBqu5m9dnNniiJmbpheixAS6qvfMoiU8OrJsRHHFD9X3qpwIzV96oij
   5JXl3kcAR2pnaP2qdn4YPrJsNuVSDI62vSaG+WY+VF87FPwWzmGRmFyT2
   g==;
X-CSE-ConnectionGUID: 0zvkVwtCT7C/0MRGaZeeAA==
X-CSE-MsgGUID: IKW5ARPWRKem5jvad5V99Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47255462"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47255462"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 00:05:28 -0700
X-CSE-ConnectionGUID: rVl3Mel3THqiZcQli6WIqg==
X-CSE-MsgGUID: kb1BB0dSQ0S5A+G0fWVAEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="156475720"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 27 Apr 2025 00:05:23 -0700
Date: Sun, 27 Apr 2025 15:26:20 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Markus Armbruster <armbru@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>,
	Alexander Graf <agraf@csgraf.de>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <aA3cHIcKmt3vdkVk@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-2-zhao1.liu@intel.com>
 <878qo8yu5u.fsf@pond.sub.org>
 <Z/iUiEXZj52CbduB@intel.com>
 <87frifxqgk.fsf@pond.sub.org>
 <Z/i3+l3uQ3dTjnHT@intel.com>
 <87fri8o70b.fsf@pond.sub.org>
 <aAnbLhBXMFAxE2vT@intel.com>
 <fa6f20a9-3d7a-4c2d-94e5-c20dbaf4303e@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa6f20a9-3d7a-4c2d-94e5-c20dbaf4303e@linaro.org>

Hi Philip and Markus,

Let's discuss how to handle compilation for different architectures as
well as different accelerators here.

> > And "raw" format as a lower level format can be used for other arches
> > (e.g., ARM).
> 
> Since you provide the ability to use a raw format, are we sure other
> accelerators will never be interested in such PMU filtering?
> 
> I'm pretty sure HVF could benefit of it (whether we implement it there
> is another story).

Nice to know it could benefit more cases.

> What do you think about adding this as a generic accelerator feature.

I can implement pmu-filter directly at the "accel" level.

> If a particular accel doesn't support it and we ask to filter, we simply
> report an error.

One of the main issues is how to organize the QAPI scheme:

First we have a "qapi/accelerator.json" like current implementation to
provide:

##
# = Accelerators
##

Then we should have a "qapi/accelerator-target.json" (which will follows
qapi/accelerator.json in qapi-schema.json, just like machine.json &
machine-target.json), and place all pmu-filter related things in this
file with specify the compilation condition, for example:

{ 'struct': 'KvmPmuFilterProperties',
  'data': { 'action': 'KvmPmuFilterAction',
            '*x86-fixed-counter': 'uint32',
            '*events': ['KvmPmuFilterEvent'] },
  'if': 'CONFIG_KVM' }

In the future, this could be expanded to: 'if': { 'any': [ 'CONFIG_HVF', 'CONFIG_KVM' ] }.

I understand that there is no way to specify the architecture here,
because it is not possible to specify a combination case like
"TARGET_I386 & CONFIG_KVM", "TARGET_ARM & CONFIG_KVM", "TARGET_ARM & CONFIG_HVF"
(please educate me if such "if" condition be implemented in QAPI :-)).

So, I will put the arch-specific format check in pmu-filter.c by adding
arch macros as I mentioned in this reply:

https://lore.kernel.org/qemu-devel/aA3TeaYG9mNMdEiW@intel.com/

And there'll need accel-specific format check (for example, maksed-entry
is KVM specific, and it is not defined in x86 spec). I can check the
accel-specific format in the `check` hook of
object_class_property_add_link(), which links the pmu-filter object to
accelerator.

Do you like this idea?

Thanks,
Zhao




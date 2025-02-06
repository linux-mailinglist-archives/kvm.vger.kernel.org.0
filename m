Return-Path: <kvm+bounces-37470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C35A2A56C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 11:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C84B16865E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0284322A4F5;
	Thu,  6 Feb 2025 10:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RV9aQ9oz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF96C227564
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738836032; cv=none; b=a8yimC6trlNKrlz8s/YYey1elfpdZRGuVTFjXjaQMxp+F2E2aFO1JZRD5JPNl8+Y76jY3AsV+L4lIj+yrGMIkeMH26hUm+c8Ho4lyi3VWDR6LQSrKGbURcc4g03k6KFqO7BphNENYF5RIA2nsBk0vTsDXmOHy6BbY7VCBdZsVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738836032; c=relaxed/simple;
	bh=MU874FEMTTz129Wl0GzXGt5/AqElqEZSPesXYVwITzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHVsLdjtk/Izp5DDVsmjvuKlOJwVPahxzjWDc1w38yaMp1RviZ8/RmMAhopl+jp3S72xjTFNpL3ufA2Bo9xNsxtRLfdUpqdGBDfJXZG/MjxHNgXQA8XqdWDSFW2KGrE8psUEtaG/hTwZjfcXm4NqAooH5najvjh3yJDzY0d8JO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RV9aQ9oz; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738836030; x=1770372030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MU874FEMTTz129Wl0GzXGt5/AqElqEZSPesXYVwITzg=;
  b=RV9aQ9ozqJgIaUzsrvwxePINgVsFGTs03kN8ma/o/dWC+reZKeZ2ms3+
   V5dyB1GB19Xylk1muF1OzyeBM66GtXbqBkZ/zn9NHwFkyfYhYbAetGUEg
   /o+J7gQUiFK64y8GvCqfE08sIVXdBeAJvsjWPV9O/35uGrtNjAgEtDfKK
   lwoFrrICHZt4+RiYiItqSVCB+FSmI+TU0FLatS260geQHR68wojhb2j6V
   d/Wr+1GKvZkRXDEVjSpYAnN2D6kytVlygM1/a5NNrGX0N3Cf1fi2H/FIt
   WXjqirJlFHhQ/kWarx3RIV7J91nEeGXnWwv54cST4aMVETxIacstkfXBh
   g==;
X-CSE-ConnectionGUID: V7qG9SwgRdiS8qpPV9LR3A==
X-CSE-MsgGUID: Hwq6fhx5TBqhKW0z3KNvjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39456942"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="39456942"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 02:00:30 -0800
X-CSE-ConnectionGUID: cx0BQhqjQt27D6NsVtSqcQ==
X-CSE-MsgGUID: QCjIMYF1Qie+rufoFs4vsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="116147595"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 06 Feb 2025 02:00:22 -0800
Date: Thu, 6 Feb 2025 18:19:50 +0800
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
Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <Z6SMxlWhHgronott@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-2-zhao1.liu@intel.com>
 <871pwc3dyw.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871pwc3dyw.fsf@pond.sub.org>

On Wed, Feb 05, 2025 at 11:03:51AM +0100, Markus Armbruster wrote:
> Date: Wed, 05 Feb 2025 11:03:51 +0100
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
> 
> Quick & superficial review for now.

Thanks!

> > diff --git a/qapi/kvm.json b/qapi/kvm.json
> > new file mode 100644
> > index 000000000000..d51aeeba7cd8
> > --- /dev/null
> > +++ b/qapi/kvm.json
> > @@ -0,0 +1,116 @@
> > +# -*- Mode: Python -*-
> > +# vim: filetype=python
> > +
> > +##
> > +# = KVM based feature API
> 
> This is a top-level section.  It ends up between sections "QMP
> introspection" and "QEMU Object Model (QOM)".  Is this what we want?  Or
> should it be a sub-section of something?  Or next to something else?

Do you mean it's not in the right place in the qapi-schema.json?

diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
index b1581988e4eb..742818d16e45 100644
--- a/qapi/qapi-schema.json
+++ b/qapi/qapi-schema.json
@@ -64,6 +64,7 @@
 { 'include': 'compat.json' }
 { 'include': 'control.json' }
 { 'include': 'introspect.json' }
+{ 'include': 'kvm.json' }
 { 'include': 'qom.json' }
 { 'include': 'qdev.json' }
 { 'include': 'machine-common.json' }

Because qom.json includes kvm.json, so I have to place it before
qom.json.

It doesn't have any dependencies itself, so placing it in the previous
position should be fine, where do you prefer?

> > +##
> > +
> > +##
> > +# @KVMPMUFilterAction:
> > +#
> > +# Actions that KVM PMU filter supports.
> > +#
> > +# @deny: disable the PMU event/counter in KVM PMU filter.
> > +#
> > +# @allow: enable the PMU event/counter in KVM PMU filter.
> > +#
> > +# Since 10.0
> > +##
> > +{ 'enum': 'KVMPMUFilterAction',
> > +  'prefix': 'KVM_PMU_FILTER_ACTION',
> > +  'data': ['allow', 'deny'] }
> > +
> > +##
> > +# @KVMPMUEventEncodeFmt:
> 
> Please don't abbreviate Format to Fmt.  We use Format elsewhere, and
> consistency is desirable.

OK, will fix.

> >  ##
> >  # = QEMU Object Model (QOM)
> > @@ -1108,6 +1109,7 @@
> >        'if': 'CONFIG_LINUX' },
> >      'iommufd',
> >      'iothread',
> > +    'kvm-pmu-filter',
> >      'main-loop',
> >      { 'name': 'memory-backend-epc',
> >        'if': 'CONFIG_LINUX' },
> > @@ -1183,6 +1185,7 @@
> >                                        'if': 'CONFIG_LINUX' },
> >        'iommufd':                    'IOMMUFDProperties',
> >        'iothread':                   'IothreadProperties',
> > +      'kvm-pmu-filter':             'KVMPMUFilterPropertyVariant',
> 
> The others are like
> 
>          'mumble': 'MumbleProperties'
> 
> Let's stick to that, and also avoid running together multiple
> capitalized acronyms: KvmPmuFilterProperties.

IIUC, then I should use the name "KvmPmuFilterProperties" (string version
for QAPI), and the name "KvmPmuFilterPropertiesVariant" (numeric version
in codes), do you agree?
 
> >        'main-loop':                  'MainLoopProperties',
> >        'memory-backend-epc':         { 'type': 'MemoryBackendEpcProperties',
> >                                        'if': 'CONFIG_LINUX' },
> 


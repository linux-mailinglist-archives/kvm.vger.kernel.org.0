Return-Path: <kvm+bounces-37486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C35D6A2AB91
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86F483A9CAB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 14:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A0F236438;
	Thu,  6 Feb 2025 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0PnozY4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83952236427
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852696; cv=none; b=R0I7HwPISgN+RECJzzHTjIIZZSOh99/jk98J4ca1wozN4QGvVj6MsyOA9cgmFKFeZPBL/MmERDlEoKCqvA4no81Ds07E2FD+qZN1GeWoMpB2/R5JsgAAwuXWHpKhddOLhoMawNAMxT4hNgPTqV6eRnxiSlHvID7Sk/roHdgXqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852696; c=relaxed/simple;
	bh=jfGStSSlY2W8EaMKPfKJE3V47I6s68bEGdj7zqDZJXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RURr8p8B8kYh6VMTf8JgREzWPOWIvsSdPNk9/bh5DUhXX6evqgghN05GJ8W/LvB98q7Q8q0bbdgzCemrGF1kN3CPsDf3cVuO4eSv3Sm5QRBCrCghvAF/Cp5ykg8f4fIet8YfNyIBkdGSf/R4JJk0a5LCVzzCvBVtf/wCm948uj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0PnozY4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738852695; x=1770388695;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jfGStSSlY2W8EaMKPfKJE3V47I6s68bEGdj7zqDZJXU=;
  b=L0PnozY4TqFq27uMMymknh7yXFj1B5+1rf7dQRA8xk0cwFrNRA6WSovw
   sAZ10ECUBj7iwMw5I1YORJSKcKFbX6rVHhfoUMutRBZM9/JmOslr/cPlT
   KO95fMas5mgScAeP4uVA6Gl2OO0Xzg6NlGJX6978F9SEK6/6d9Ftm9CMW
   pUi/U0oypMHuDtX1nFGnZISy8hvE9UgT9Zm4ty+Wzu3oNDTdnr81FHsby
   QMUQ/6W7t3halL5L72HPNbA0ghZMeXAC/khKaDzVc1rAteKkt6MU0iPwS
   WbrNUgZhCBiGByek2l7dtvl8eLAdpEgZ/hStOtVQwGFe8WJ8McrVvf53L
   g==;
X-CSE-ConnectionGUID: sMUCYuPvS/SynlILt+sP2g==
X-CSE-MsgGUID: KCspJwFXTd6arqAvvjXffA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="43213757"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="43213757"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 06:38:14 -0800
X-CSE-ConnectionGUID: dP1RgmONRgiX4KjojGxDhA==
X-CSE-MsgGUID: eLEb1rSlTJu9e1GKfNwPKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111079245"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 06 Feb 2025 06:35:13 -0800
Date: Thu, 6 Feb 2025 22:54:41 +0800
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
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <Z6TNMZbonWmsnyM7@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-4-zhao1.liu@intel.com>
 <87zfj01z8x.fsf@pond.sub.org>
 <Z6SG2NLxxhz4adlV@intel.com>
 <Z6SEIqhJEWrMWTU1@redhat.com>
 <878qqjqskm.fsf@pond.sub.org>
 <Z6TFr49Cnhe1s4/5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6TFr49Cnhe1s4/5@intel.com>

> > Do users need to know how to compute the raw event value from @select
> > and @umask?
> 
> Yes, because it's also a unified calculation. AMD and Intel have
> differences in bits for supported select field, but this calculation
> (which follows from the KVM code) makes both compatible.
> 
> > If yes, is C code the best way?

Sorry, I missed this line. In this patch, there's macro:

+#define X86_PMU_RAW_EVENT(eventsel, umask) (((eventsel & 0xf00UL) << 24) | \
+                                            ((eventsel) & 0xff) | \
+                                            ((umask) & 0xff) << 8)

So could I said something like the following?

+##
+# @KVMPMUX86SelectUmaskEvent:
+#
+# x86 PMU event encoding with select and umask.  Using the X86_PMU_RAW_EVENT
+# macro, the select and umask fields will be encoded into raw foramt and
+# delivered to KVM.
+#
+# @select: x86 PMU event select field, which is a 12-bit unsigned
+#     number.
+#
+# @umask: x86 PMU event umask field.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUX86DefalutEvent',
+  'data': { 'select': 'uint16',
+            'umask': 'uint8' } }
+

Thanks very much!

> > Here's another way:
> > 
> >     bits  0..7 : bits 0..7 of @select
> >     bits  8..15: @umask
> >     bits 24..27: bits 8..11 of @select
> >     all other bits: zero
> >
> 
> Thank you! This is what I want.
> 
> 
> 


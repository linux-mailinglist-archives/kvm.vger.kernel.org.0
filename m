Return-Path: <kvm+bounces-3635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA66805FBD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ECBF281F44
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA676A028;
	Tue,  5 Dec 2023 20:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m5+Fi2MQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E75018B;
	Tue,  5 Dec 2023 12:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701809388; x=1733345388;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=crEhHO669Ubfvsm02Xa9zCCXAM+Ke0YB3LlSMcphV+g=;
  b=m5+Fi2MQR64TCh6aP3Yr80o9ex+MzfwlazzNX88JtyDbt7Q1AFwNvDAX
   Yd0MTPeghaapCe5iePp7qFsJZ5/qwTlusbq90KfSbfvVvW1IvzDbFg2MD
   L/Q5uKVCATdsVKqCbWM3D5bc+XX4pv746SYCtrGwC8IzU6Hby4RYZa4Mr
   UckI/T2NmAxVMW+kMmeNeDtZa2q9E9G61Gb4lv421+Z/A8ONfzhCR40EY
   u8VYb1MivO17234nmzmzgOnA9ZFSiBQwPJnj844Rl6o3oc+TzrRYsAsgl
   ed/HDItAojOyvovOSlJ7cLoIP+/K8gOqcUcnBKtpDxDZomeQ6/LcLib38
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1023130"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="1023130"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:49:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="747369805"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="747369805"
Received: from mtvento-mobl1.amr.corp.intel.com (HELO [10.209.56.14]) ([10.209.56.14])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:49:47 -0800
Message-ID: <b517f60a-728f-468d-989c-2669c7e71b91@intel.com>
Date: Tue, 5 Dec 2023 12:49:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Brown, Len" <len.brown@intel.com>, "david@redhat.com" <david@redhat.com>,
 "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
 "ak@linux.intel.com" <ak@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Luck, Tony"
 <tony.luck@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "imammedo@redhat.com" <imammedo@redhat.com>,
 "sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "sathyanarayanan.kuppuswamy@linux.intel.com"
 <sathyanarayanan.kuppuswamy@linux.intel.com>,
 "Huang, Ying" <ying.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
 <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
 <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
 <0eca4ddc74bc849b68d2ee93411be9b7d6329f0e.camel@intel.com>
 <20231205204132.GLZW+K/Ix5sngfmcsY@fat_crate.local>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20231205204132.GLZW+K/Ix5sngfmcsY@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 12:41, Borislav Petkov wrote:
> On Tue, Dec 05, 2023 at 08:33:14PM +0000, Huang, Kai wrote:
>> Yes I understand what you said.  My point is X86_FEATURE_TDX doesn't suit
>> because when it is set, the kernel actually hasn't done any enabling work yet
>> thus TDX is not available albeit the X86_FEATURE_TDX is set.
> You define a X86_FEATURE flag. You set it *when* TDX is available and
> enabled. Then you query that flag. This is how synthetic flags work.
> 
> In your patchset, when do you know that TDX is enabled? Point me to the
> code place pls.

TDX can be "ready" in a couple of different ways:

1. The module is there and running SEAMCALLS (tdx_platform_enabled())
2. The module is initialized and ready to run guests.  This happens
   after init_tdmrs() and init_tdx_module() return success.

#1 is known at boot.
#2 doesn't happen until just before KVM runs the first TDX guest.
Here's the patch for #2:

> https://lore.kernel.org/all/566ff8b05090c935d980d5ace3389d31c7cce7df.1699527082.git.kai.huang@intel.com/




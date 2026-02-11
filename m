Return-Path: <kvm+bounces-70823-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO64K6zni2kcdAAAu9opvQ
	(envelope-from <kvm+bounces-70823-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 03:21:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50984120C21
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 03:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 17AD33019E5F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9992E27FD68;
	Wed, 11 Feb 2026 02:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ImUJPUzB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BF012F585;
	Wed, 11 Feb 2026 02:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770776488; cv=fail; b=Y1pB/l4Zmvn7oUW4I8ogY4MDE/L0YhOwq3qf1jfBXjsP/HHGBhWZI2Ts4G43PLhJc0l6CRcymxM+G620bslisayREta31UTaEOQlDXOR3nAixVSw3enE+ssR7Hj/fBrj7PzLiSJSa4u5AmjJt8mRIiBQofDkc5Vtpjt71c594Ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770776488; c=relaxed/simple;
	bh=TAupr00xNbHowBpxB2r/cLgrYFZthBf+7/35dcOBHhI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=loGp1TUrhU6qnrJ6dGAgCrIIeKKDfWP7BZoknXJTaOdZq1ziwEAEIuGeYQA9Q3knLjTJyPJLLvH2t19zzXKfjfG9iJRdY918N9MUiTfSGdQrpDIHXdBva2c7zYMS3kwIs7tXh/HtgDlLQsMiCoDqI5tZaCvq2dxCPqUVF+iIk9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ImUJPUzB; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770776487; x=1802312487;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TAupr00xNbHowBpxB2r/cLgrYFZthBf+7/35dcOBHhI=;
  b=ImUJPUzBByS89OKPRvTVHcomhBM/TUAREToZcy9JtMzFYAagnbigAT8u
   sndTjwZwHmCZhmCbNSXmh5n+4sHGZzjNlfMBUWx1n+GVwrZzWTMzcDHCf
   o/CGPNoF4VD1d/ZxwK+xZM+NYOFErxjbS0mlgDhWLR9G5XPMPtG+lla+M
   dtG/ALwNN/q66u3ylI8n4ApG32e5SerotN0ar8mxaYBkkZr3Iz3/gv4Z8
   AZBV7GtgO6IYsr1PRe5uCTzvlDWUymDYdyPrpJiEiOihxJHQFlB+1qNkB
   3hD4dMVXybJ+wnYqfYcMiNhAwJNBsLyXDQw75vDYY7Ik/aXAAsGXLuCKR
   w==;
X-CSE-ConnectionGUID: mv9HPTUoRAWEOWbbNUth9A==
X-CSE-MsgGUID: RAzPmaLET9m7gdQ3HUvoXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="83287103"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83287103"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 18:21:26 -0800
X-CSE-ConnectionGUID: TMkYfmxXQOGaT/SSD2RGTg==
X-CSE-MsgGUID: xpc68wxfSBu9mQsnkR6a2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211724300"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 18:21:26 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 18:21:25 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 18:21:25 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 18:20:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L/18dw97h/3l/n9KqzMT1Ml1YuJSBTI8w8f++pJIkywE4y0k15v8DcDdNpho4O3XcMYumKGT7SsGHu3ICzdGXtzEKfKKD7nTCf+bxcQWEzjYQUVpZckRGiisXbYi+k7Jc9bkHCqh80c47uiEaUbD7zyDMKzuoabcOaWKP9f5qrMQbkLnjx15AghjodIpMNjbToXB2rAfoyMNZbcdekOLNx30ucMZEJ6akcgr0x+XW0FuDPAQS4ArhmRVStt8/8jPJDAi3dOFPtInmtWWbnu3dmL2D6uRjPE2hyKqzPT9CTVJu3tLTRSEtib5iSATGgoWrpKbGUn/3Rmtas7Ocfmn1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mxtl6wKVsF0aAKC86UNwplhQEZJaAS8p6YJM+zmXWvE=;
 b=wu+79G1u1mVCMjyaMNRpcJLgZoiZ863fSvPfEVvDV++7uKhf8582KYuuWMPOJGk1EfOj7NvyzmiUw7b9+j9al8ld2CVvgI34VJNU3A9I60Qzhy/9GsyoVI4p3fp84SLTkgN3hKr3K82Cm+2VfyUKCYC/M0chgkVWJt2AsqzgvMzRMsO4gOyh08NYllc6Ro6IYuUQd6M4Es5iNcKa9CWw19KSGQc9LaY3z5G7eHYD+O74Zf0cC1HlkB4hsGk5BJ6ris7y1Tz5reTIyWaETFa+mDbCHFzPLhILWMqhX6eW8GT4W2TEJisdeOJGpSuV/LuenduVCRluh5LmUmHOz4O8nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPFA424F92C2.namprd11.prod.outlook.com (2603:10b6:f:fc02::41) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 11 Feb
 2026 02:19:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 02:19:49 +0000
Date: Wed, 11 Feb 2026 10:16:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
Message-ID: <aYvmlBb6oR3lfWn2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
 <aYP_Ko3FGRriGXWR@google.com>
 <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
 <aYUarHf3KEwHGuJe@google.com>
 <aYVPN5M7QQwu/r/n@yzhao56-desk.sh.intel.com>
 <aYYn0nf2cayYu8e7@google.com>
 <aYsOV7Q5FTWo+6/x@yzhao56-desk.sh.intel.com>
 <aYuMaRbVQyUfYJTP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYuMaRbVQyUfYJTP@google.com>
X-ClientProxiedBy: KU0P306CA0060.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPFA424F92C2:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5279a2-b346-43c1-a363-08de69140870
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iBjtcdn+H5NI0skFmiov28Ty5owqhy/sSh2ynXc8bPimHBRXLaiD0DHsFe9p?=
 =?us-ascii?Q?wjXHxDijQC6rZOWDlHcDUJz/9nFQBYsto+lv731PFLnuy6r8n3aFF0FOeOcb?=
 =?us-ascii?Q?XWPYYUvQ8RD2ErCGDnqk7VTeOIewRXX+rM5ltUGioacAm3myRtQ56QhqI6Oc?=
 =?us-ascii?Q?uB0nZsU3hK0N911fsLSOyhjmhPcL/ksT+Mr2yUYzwGPp+ThySNml5XsmI71C?=
 =?us-ascii?Q?+z8z2Rj7+atfPjsx0wB0UkDcTsRPvOJcV0GPNeUSCnGUWT/rmuc+prCfeUlz?=
 =?us-ascii?Q?M1Z8qWYX5H8+IS8xqPDL9F5D3Tdwq1TN+3sMGS00OvM0u9hNtngdbpkXZmHJ?=
 =?us-ascii?Q?VLNr75FN4B9I9Vme9PSOMlgeYK1xdqfpSHMMHuTJ3elBkkPX0cHGvsVqGsSb?=
 =?us-ascii?Q?BFDHeugfGfZMNGYT8QmNjJxi66upQJavROx1X4BjqHJAAwYd4a0Edy2LDuAr?=
 =?us-ascii?Q?e6XMYsIb6pAYoiomkoyYd2ERJJrmrbI6dbFE4QSDeuyQznpVwkxNj31ywv6T?=
 =?us-ascii?Q?aR7Fs8/7ojAsPhxJ6v5SAwkaoe9g/UJF6IOpQnG5Wqe2cej62aXWlUGCGClb?=
 =?us-ascii?Q?cSQuABMhgzwg1v1s71+UKUqWDd8oteRfZsDqOoYvL+Go6ZCousNQEJi2zQtM?=
 =?us-ascii?Q?Om4oGjcQdYL5biutSNm0VluasvC94sPaDxMqC6ICl4E0WW30eEulBvL2buQf?=
 =?us-ascii?Q?3h1Ky+tJw3Uwax9i/RCj+kdwDCXzxPk+fOsX6PqEOcgFTEE0HwtTQQ30/ZD6?=
 =?us-ascii?Q?SEpyX81MXakwmlITkgW47KocZ9fsh8p8QvxbpdVryim/FTX1PzGHFJjTDT7u?=
 =?us-ascii?Q?Tu368x9+QMgDbEdCv8+HCHFc1mRUoQcZUq6jFaUU8QAKa2UWuxQTJjdaz+7L?=
 =?us-ascii?Q?4L10GfsuklGMhrsGhoZ0CQxqOcI3yGY4aaPw2gEgbtX7wKxpRSXkoDhwUloc?=
 =?us-ascii?Q?LuWYczfh2okZzOwmvybUXBJbOyyactUX10GPT97TTymJn2xSHMmQmSwJzmJ2?=
 =?us-ascii?Q?PF7XQOIAb4sNEl7kVqE6/WZnzetESWJKILj2CDyJi3yh7nzy6phGrsNV9LH7?=
 =?us-ascii?Q?pnzAYTN8GGgW0KJDFpzLyFYcOhB7UUSO7c19QkjV2QHbQB7VKyF2bfvoyJw0?=
 =?us-ascii?Q?CjapXUsLLZu7IxSFs/z2h8EuiaEpcpvKcEox99eA4ar+jvK2G2eCKLrbXzaj?=
 =?us-ascii?Q?1/OnyzssgnMc3pDKKQtp/GE7qCAKHpJj7trN7rk8ARZkbPvmu1VhCzD1dL4U?=
 =?us-ascii?Q?SBwLEe3N8Bz9CmC9bFJEO6I/dhIxdBWs2py/RJYSn+H8F4maaV4zvgTCSy6M?=
 =?us-ascii?Q?0mLdTcy/GvtVtZTLXeqJmfay52boOs/qZJKMScD7V6jEDorY9ZA5dew10jiU?=
 =?us-ascii?Q?KVIl6a5Q6spy/3AyGwE4iAIzv9OZqgKPQ6is3o2A8pC6KyWBIti5TpZGohXs?=
 =?us-ascii?Q?cH5ATwxsITdKUB1BCmWh4xjA6AuyRA0xF5/akK0zZOzKvnYX9ntcWFaQXI+Q?=
 =?us-ascii?Q?8lBBsQZtpLQDA/vKT4cf4POIBfgRWrMb45Ki1RtBiCVLYr0ICkZg/odW+Gl5?=
 =?us-ascii?Q?00zpNt9FEu01g1bDbVg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r3LjkSUgrVLgmKFMYQeXmm2qeYERwLWE35FZpvikjr8WhDAHEYVvVPl6DX0V?=
 =?us-ascii?Q?7lMLwpRpDYmuPLB9t7WtEHc0e2PyTr+Vpv36EZKsiM5rkUAwcAxpEfI40yG3?=
 =?us-ascii?Q?XUdt8q3LIFAc1J/X7EAsF1H2IvvFqbROOBiyx/9O+0l91AVIyLLMpzIqkFp3?=
 =?us-ascii?Q?BSpcjczZPla2HEClmwNDRLQRffvR1Jof+QtnAbEXjvXBQ4yFw7uVCQYHGG0q?=
 =?us-ascii?Q?PMgT+PsrcWzAFhl5F8NB321keEL3MN7oaCCMqV7zsQEHNVgtoDLnCYjImQmM?=
 =?us-ascii?Q?VhEKwSlmqUiEnprCfo6DVtNBghZQ4NzutCOn1q8HT13CDvdkybVfI0ksjlqZ?=
 =?us-ascii?Q?uA+sjyeERgnr18NlaoOsJHqiCAXtihLr90IzrE7TYfJZ15oyh7Je9GQDz+vN?=
 =?us-ascii?Q?QXEkfO1kXwITGdkGntQ6HxcEH3v8BnSYbu49OS05SS+8GZ7IEUjwkQFqqaVx?=
 =?us-ascii?Q?8Pt/0p1zRwGomnwi6hts7a5rCrSpjUbLpuD9YnY+EE3hjE8RthPxDlyR3/cu?=
 =?us-ascii?Q?+BNG4xXYFWQiTM6lcVzv5gGlpwITbH/4UoZGUe8Q+cJW3eZiCd8o1u/r9dWe?=
 =?us-ascii?Q?Zl0IPv0+j4OReO+ZGAfx6S3eOVi7/8WVpszV1hMBB2SKMZJ6jyJFVxCb4E0O?=
 =?us-ascii?Q?TrGHP2v1GCtjw7N7HPneWgcSwTuQ2cxyG5wyJ8ta4KdRwvsDPpjMwRkeQaga?=
 =?us-ascii?Q?G/yI9UebmuM6I++owc+/0YSl1sYx0hchIAPPb08bbgHUszBZJ3zcaUnQt1CB?=
 =?us-ascii?Q?L4D9UHQLOJxfN4RRA6PoPItvEWI1XCla8ZwwWd6bhJVxjtTtn4Cyhsx984Xo?=
 =?us-ascii?Q?6+V5w+2dYDZ0oadaNl8NA3dMaVCBd5oXLl+6fEANXMdt3znLoSIE5j2q4fbc?=
 =?us-ascii?Q?JDsLQFN45DNtrn+gMm5N1rTfwDv2ESIr9TAhdVVLbfLwoQHvcqunLpnqJPl3?=
 =?us-ascii?Q?YAdLlfZWQ5/mJ8FUkheRnn6teSafnsZk3zDrdU48l1a3FEpU8JRyaQ4w7fgC?=
 =?us-ascii?Q?KvYUdBjoqHnwewUtccRUqN/TEAZoHlVMS2v/jc+1wuDBKkt+Y3fG1KRJIIln?=
 =?us-ascii?Q?lI/HCKxb7/F5kF1+AwCcyF1xwKHTYCx0hLaVQCwA01ceS4+bkFS0ma2BP5QO?=
 =?us-ascii?Q?io+vpbuUCuuO73mvaH68oFLqRtMrjUq7hNRpQz64TMqyyLcyJQvrTZmoR//I?=
 =?us-ascii?Q?gjpKoXB9iaLvIbHDtKwWYOu6F77WaBgzIn0RT0iW6820U6znRkojrqCnaaEB?=
 =?us-ascii?Q?pkbhI+bGsaziDvjv+NMg1ELkV49LxSDwjdhs9vdxZrYzGG7JFDOgEr55jd2g?=
 =?us-ascii?Q?Jy93LETsgGS0P/wt061kfrtjE+FzOVm5woY4PxvKd3iAlQEgRR6e+bizzOjF?=
 =?us-ascii?Q?Vr77wEvJ3sS8yBNl/jRlJjewFjZpFTnZfZ4SRrZRmKP1BFw8iRgfwp5mcbDI?=
 =?us-ascii?Q?fQbO+hCQ3k8F00PrZNQHqrjdD6RzJyyuX26RA9wU3IQ/Tl4xxqsmoNPhLmKA?=
 =?us-ascii?Q?VRttlRuXf4YSB17YS7fmkb6V8EewQKwMpdB33yrjB3bq3YkYlxVxWtcDezsf?=
 =?us-ascii?Q?9fqDem3ZGx/5fgrf0N+azh//gobka9kYba8espfk322uQn9qd2YBx4Cefg2O?=
 =?us-ascii?Q?o0Nnbi901pAipAGr9csIIqyAu0Y+rRVwKLdHBUTgBQbW17ViWIrWkOCKRMXI?=
 =?us-ascii?Q?d9QqSp8YVEq0p+gM3DVKZql/nS4Oi0oZPgZu5L9TMh3q1gWMKbvdlYncESxZ?=
 =?us-ascii?Q?i7bsoO93iQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5279a2-b346-43c1-a363-08de69140870
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 02:19:49.6332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YROrCFHFQlURWL5Y7xyftSyxZ53lz7HRxgz6Iz+yg0GkCfhY716qkDN1y+GvffgVywRCw838ccnWN5TsvKSFLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA424F92C2
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70823-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 50984120C21
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 11:52:09AM -0800, Sean Christopherson wrote:
> > For TDX's future implementation of set_external_spte() for split splitting,
> > could we add a new param "bool shared" to op set_external_spte() in the
> > future? i.e.,
> > - when tdx_sept_split_private_spte() is invoked under write mmu_lock, it calls
> >   tdh_do_no_vcpus() to retry BUSY error, and TDX_BUG_ON_2() then.
> > - when tdx_sept_split_private_spte() is invoked under read mmu_lock
> >   (in the future when calling tdh_mem_range_block() in unnecessary), it could
> >   directly return BUSY to TDP MMU on contention.
> 
> Yeah, I have no objection to using @shared for things like that.
Great.

> > > +	return 0;
> > > +}
> > > +
> > > +static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > > +				gfn_t gfn, u64 old_spte, u64 new_spte,
> > > +				int level, bool shared)
> > > +{
> > Do we need "WARN_ON_ONCE(is_mirror_sptep(sptep) && shared)" here ? 
> 
> No, because I want to call this code for all paths, including the fault path.
Hmm. IIUC, handle_changed_spte() can't be invoked for mirror root under read
mmu_lock.
For read mmu_lock + mirror scenarios, they need to invoke
tdp_mmu_set_spte_atomic() --> __handle_changed_spte(). 

> > > @@ -663,14 +630,44 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
> > >  
> > >  	lockdep_assert_held_read(&kvm->mmu_lock);
> > >  
> > > -	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
> > >
> > > +	/* KVM should never freeze SPTEs using higher level APIs. */
> > > +	KVM_MMU_WARN_ON(is_frozen_spte(new_spte));
> > What about
> > 	KVM_MMU_WARN_ON(is_frozen_spte(new_spte) ||
> > 			is_frozen_spte(iter->old_spte) || iter->yielded);
> > 
> > > +	/*
> > > +	  * Temporarily freeze the SPTE until the external PTE operation has
> > > +	  * completed (unless the new SPTE itself will be frozen), e.g. so that
> > > +	  * concurrent faults don't attempt to install a child PTE in the
> > > +	  * external page table before the parent PTE has been written, or try
> > > +	  * to re-install a page table before the old one was removed.
> > > +	  */
> > > +	if (is_mirror_sptep(iter->sptep))
> > > +		ret = __tdp_mmu_set_spte_atomic(kvm, iter, FROZEN_SPTE);
> > > +	else
> > > +		ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
> > and invoking open code try_cmpxchg64() directly?
> 
> No, because __tdp_mmu_set_spte_atomic() is still used by kvm_tdp_mmu_age_spte(),
> and the yielded/frozen rules apply there as well.
I see.

> > > +	/*
> > > +	 * Unfreeze the mirror SPTE.  If updating the external SPTE failed,
> > > +	 * restore the old SPTE so that the SPTE isn't frozen in perpetuity,
> > > +	 * otherwise set the mirror SPTE to the new desired value.
> > > +	 */
> > > +	if (is_mirror_sptep(iter->sptep)) {
> > > +		if (ret)
> > > +			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
> > > +		else
> > > +			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
> > > +	} else {
> > > +		/*
> > > +		 * Bug the VM if handling the change failed, as failure is only
> > > +		 * allowed if KVM couldn't update the external SPTE.
> > > +		 */
> > > +		KVM_BUG_ON(ret, kvm);
> > > +	}
> > > +	return ret;
> > >  }
> > One concern for tdp_mmu_set_spte_atomic() to handle mirror SPTEs:
> > - Previously
> >   1. set *iter->sptep to FROZEN_SPTE.
> >   2. kvm_x86_call(set_external_spte)(old_spte, new_spte)
> >   3. set *iter->sptep to new_spte
> > 
> > - Now with this diff
> >   1. set *iter->sptep to FROZEN_SPTE.
> >   2. __handle_changed_spte()
> >      --> kvm_x86_call(set_external_spte)(iter->sptep, old_spte, new_spte)
> 
> Note, iter->sptep isn't passed to set_external_spte(), the invocation for that is:
> 
> 		return kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
> 						       new_spte, level);
Oh, sorry. It should be
2. __handle_changed_spte(iter->sptep, old_spte, new_spte)
   --> kvm_x86_call(set_external_spte)(old_spte, new_spte)

My concern is that what we pass to __handle_changed_spte() here are
"iter->sptep, iter->old_spte, new_spte".

     ret = __handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
                                 iter->old_spte, new_spte, iter->level, true);

i.e., new_spte is the target value which we haven't written it to iter->sptep
yet. We'll write the target value new_spte to iter->sptep after
__handle_changed_spte() succeeds. So, upon invoking __handle_changed_spte() in
tdp_mmu_set_spte_atomic(), iter->sptep just holds value FROZEN_SPTE.

So, re-reading iter->sptep will get a different value (which is FROZEN_SPTE)
from the new_spte passed to __handle_changed_spte().

Besides, __handle_changed_spte() contains code like
"kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);", which may have
incorrectly updated the stats even if kvm_x86_call(set_external_spte)() fails
later and the new_spte is never written to iter->sptep.


> >   3. set *iter->sptep to new_spte 
> > 
> >   what if __handle_changed_spte() reads *iter->sptep in step 2?
> 
> For the most part, "don't do that".  There are an infinite number of "what ifs".
> I agree that re-reading iter->sptep is slightly more likely than other "what ifs",
> but then if we convert to a boolean it creates the "what if we swap the order of
> @as_id and @is_mirror_sp"?  Given that @old_spte is provided, IMO re-reading the
> SPTE from memory will stand out.
As my above concern, re-reading SPTE in __handle_changed_spte() will just get
value FROZEN_SPTE instead of the value of new_spte.

> That said, I think we can have the best of both worlds.  Rather than pass @as_id
> and @sptep, pass the @sp, i.e. the owning kvm_mmu_page.  That would address your
> concern about re-reading the sptep, without needing another boolean.
Hmm, my intention of passing boolean is to avoid re-reading sptep, because
in step 2, we pass new_spte instead of the real value in sptep (which is
FROZEN_SPTE for mirror sp) to __handle_changed_spte().
So, passing @sp may not help?




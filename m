Return-Path: <kvm+bounces-33395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 706B79EAB7E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70FE1168B66
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F412231C88;
	Tue, 10 Dec 2024 09:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YICg/Wgs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D922616F;
	Tue, 10 Dec 2024 09:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733821864; cv=fail; b=SIMx/KDV71LnO9DdzkWbsyWlbbLMZv2Hc5czpFYxfMe8XezA5VhlBc2QUkbjdVS/GaZ0RtpUq4mMNtkHZJm7x2hH9/DuL/cVhzyS0Jaj5MUdBQVy2gRmj0HVz9W2Rw5UKNsYoybStAgxuNzCa8E64RxchMncSXAwkZo7zTycCz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733821864; c=relaxed/simple;
	bh=dR/0QPntq/cHVv89nvEspGz0P/Vumw/kAFG7Wie96+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WozeeTuxmO8q9hftv1JM/0lwvv53i5MaAD7MNPDI4ET+ekHVyj8wvwemkgHbqI1UzZS+KGXM0G+KuNOaFLSfjMOgRKMt/vmOBTTnIobECJK1rQmc59OEPzYZ9MFde9aYwRDXJ2I/ziMQmUFaDCnBkjsQXAsmH6ziodg9axpDbb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YICg/Wgs; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733821862; x=1765357862;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dR/0QPntq/cHVv89nvEspGz0P/Vumw/kAFG7Wie96+o=;
  b=YICg/Wgs13vWk1O9Ic3omi/Mtr7tHWEBsijp3vI2h+E8hPXYx9qepJ7+
   9FXLcOWvdlhegsKNAKMfOwF3Th8whsCLmc4BR22UmHBp2sMCpris3G8hW
   vWiHL9JT5N7NbpkgqGbHUps0j12SIXA3qDPvYhl8o4xlvmfWOFIQ98qI6
   HCkTJOTvAlY59TA1SZy+IUsxa0BFQvcwLMCiwbAJOD6g7wVADeKnmS6gQ
   jomrFcJ6wSzecLjbhTvNr8yKl6SMWaj3qXalT769aeGcx03oGxhc/Py1d
   LpyqnbYtWaHJTA/L26/CN9jlw60oMVvcZBKUiVohvWk/3Yk9CN/x85gFE
   g==;
X-CSE-ConnectionGUID: esmTC6BRT2WImYNiwBfvqw==
X-CSE-MsgGUID: xVa0F/XkSOKYkdf6/CxLKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="45536758"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="45536758"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:10:59 -0800
X-CSE-ConnectionGUID: MM22BCyVQq6XYo3TjlkWZg==
X-CSE-MsgGUID: TuGkEHYlTOmDgrAl/4fVHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="126161611"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 01:10:52 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 01:10:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 01:10:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 01:10:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxfKSE+YIoW3jSAjtK/oyShUhc74CvT3kBq2CHFS3AIpxkaWEnRdoYnVj7uTnlFBTIc1DqkJyIwQqoxT9Fm6ib7+Al0Qmc6V2vIPzTahcy0YRcnc7be3foIkLlFmgUpLG3CGVhmppe2QsHcAFtJghgUBA29qTp9O1ggTpcYcFMyGtbir9cfv6JuFUyfCfsT/E1vSUnIGWrBe8w5yIZGR3/8QOfYPK3ha+Ypcv4N54UyAdoUICBlD1b87vqZxBOuIo/NVcUZnrHkfnnt2F3R3DEkTvDgbL2esh/pNvtCo8vBvyhZj9/BLkK6C9F+SaingE9E88KI056lyRNGEmHtm2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f31S4BCs7a+VutywGbGmfdVowIlOyhJ4ntUZWED69nA=;
 b=fEZAvnio58XaKrvTB5ugW5BYNfdveyHfwhhSARKWIg7CaRwEOhnOWENil+ZUxwt44PQ/Q5/VHaLWy46BQg7fjNuuLKhOQE3eHyv1nRZjBijuyjYMMNGJy2egGJxWLt1yLOBJC/2pz1SJpITre5eaoT9+Mp6PBQtMsLcmdvOTADFmzLyZbMoCJDdlGOzn3GiQv7ahGrs/8PCmJcq3KjtFnPLRe9xxj3Nf8epr/1yqlzv9qCd9fMUlJDPEFoX+JhJkTBBs/rgzaSEPWFTbbY5TFZEFufV8F/fa9Epm/vhKhLDpWdMgR5OT+SVpt6vkZ865R6KiEjieOYHdq9xC/wQkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5073.namprd11.prod.outlook.com (2603:10b6:303:92::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Tue, 10 Dec
 2024 09:10:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 09:10:40 +0000
Date: Tue, 10 Dec 2024 17:10:29 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Message-ID: <Z1gFhU0oTGUNssMP@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <Z1bmUCEdoZ87wIMn@intel.com>
 <e8163ac4-59cd-4beb-bb92-44aa2d7702ab@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8163ac4-59cd-4beb-bb92-44aa2d7702ab@linux.intel.com>
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 4edf53ab-0844-41a3-73ac-08dd18fa84ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?cADGFJyg5lnzijJIWprX1OIUnoa2I3i4lAW84qx+PU1vKbKGZeBzTDXj41?=
 =?iso-8859-1?Q?/LLJcs0Pd76WVE6VqQ9ybgP67dsDbgwUwFJ5a1r8eV349zVI4gNNXKvVaR?=
 =?iso-8859-1?Q?80rxP8JYwq/JCqU9lBzpm5zh7TZObnMkvYwc4Hz0WiqGXFMZ8RoYirYU+i?=
 =?iso-8859-1?Q?kLlB3USFhnXLuAbGScKa37Q9cMR3tWgiqaDMWdAgeY0Y4+rkZE/yEu0CqY?=
 =?iso-8859-1?Q?pwABBg0WhuWigbcW2oOqIMj3NtRyDVoP/SQ3mD1TMfrS61rQto5nQ/nEDu?=
 =?iso-8859-1?Q?jHBXkQeNvgPu0UwwZZXMS5Ml9fdhH58v2IWz51KkQY/SZ2YglUINA/nc1d?=
 =?iso-8859-1?Q?NQ137u7CXhLxwNBStPnm4w/yxVuHycSa1zabtIj8QHG3s1aobVWSHZoeU8?=
 =?iso-8859-1?Q?a/hpPFZXfubHkLKD+WkOsHUG29Llm8sqeoGSB1QtCc+84oG14yMGqO5wla?=
 =?iso-8859-1?Q?SUVQXgF9gkBgLp53zAoUrGIG+CUdeJE4OwrupQJ1MEg+a/VaCsDjl5YCiJ?=
 =?iso-8859-1?Q?NExoN5yfTgu/H8vMzinM8Nf6pyKyIEWUp1yJtxAH6DvCeNxR7GAzLtq+YQ?=
 =?iso-8859-1?Q?Fo2H+V1Oa2N4fmbHH9Com8dSQHJTrJKi3z4a6kwGZkJ/kR0nJnyvqKOSFO?=
 =?iso-8859-1?Q?RCvLNEaKiZdEvs7VmuX+jC77UfORAwX7N0K14lc0AJyXI82O9k7lHMm3uM?=
 =?iso-8859-1?Q?uukJ20r6brortUUT5JK9CheQok1Ia5ogVYAVNmc+ql+vTCu1QMCIbWMIMk?=
 =?iso-8859-1?Q?LsKHrc1Z8FZUKvx2cQPpFP/S2mupKNfW1t17SWneTOItGJLG2y/zhyt+jw?=
 =?iso-8859-1?Q?4u4Rh4W64hA/zERbdu9Anxo6lGL+/kKNWO8mLb2sXx94mJISL3mi9WKgIo?=
 =?iso-8859-1?Q?BhgXf+qfir8s6bhUXC56/sbw3U3mCfGhzhr4dzVnURCGIbL+AIzP0e7CA0?=
 =?iso-8859-1?Q?wqN2Oe+YGV+ZvZP+GbtDtKi8Yn8uWY6IKIFzGMseOppMLko0Dx3xw4bb0h?=
 =?iso-8859-1?Q?m87PZOz4tq4S7tp6oyllVVGkxhM8qqoJnXuh6rFXwG2TDmYfoSCEQv09Uz?=
 =?iso-8859-1?Q?BQFTfn5o4jWx+TQ5+hEG7fVVSEjIzK308p/BBwMkq+TQ9aTfINKG/MMo0L?=
 =?iso-8859-1?Q?pd3JLzAWl62POYFEj6f5SihxKIGcCboQwxs/zma/YI089hrWo10mYopVlv?=
 =?iso-8859-1?Q?l2Viq+6aEYR2Q/Sr+yT5FjiakgK6spYiCmT8pYFLVJVWyUWad5XtsjoHyH?=
 =?iso-8859-1?Q?ZdEb/s+vrIXGMuWRNUl3KZMXvQ+E8umQm0j12wvDLAQmYeXnnsuMmeThe0?=
 =?iso-8859-1?Q?5XLsv5VeMSdq2hCtT8OiD0ZL7kKqDRaQ4Q+qNOU+7TO8ZgKGvSccBNj/0C?=
 =?iso-8859-1?Q?eJhv4BOv1ZhaJ6Kk5twTiCvnMHbrxe2g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fhE5KnRZ7/kYX7no1qYjDlubfa8gX5eXEq6YBAru2EbVejCmYg0hRNnYsO?=
 =?iso-8859-1?Q?gg1a0gkgsfSvBDpSjve+sYH6ByUiuSMxRyRcLroVQylP07iK+eTjkhr2Ae?=
 =?iso-8859-1?Q?EAcFSYX8d3biGb+dfL9+KhFMo98Zfao0WuRmVi/tPinO7ir+ul95eBrMxe?=
 =?iso-8859-1?Q?w0IgN6kw/rpnvg6vUa6Plap3/KYUKKtPyDEYCVbuloYl8z38sQea0mnIQH?=
 =?iso-8859-1?Q?oWfuLZ6RsktmeOgB+NZuGRYLXL6srqpj4XmW/RdZ7QpIKneOSCshUp3nz3?=
 =?iso-8859-1?Q?MGmpAw+I9VWBuT7Fm2YKpsi5S347brr/0t8Gd7HtCsVh588cH06RtG9sjk?=
 =?iso-8859-1?Q?3qjWfAhxyAvpbgjHEo28pz8Hl+A/qiWIxNXcJp2nbGO9VPwVgFFbXXXBJl?=
 =?iso-8859-1?Q?vBEh7grJcHTodFeDhW2nfEMz+DzhIGsTC55KZf6MKXK2GEmcZulYDj+cSa?=
 =?iso-8859-1?Q?HK4hhKxN8CdaZ2evLDBuiCSy9u0Ylv7b+tJS0bB5cJWgTwdmY6ntIDee/i?=
 =?iso-8859-1?Q?XxoBDtUNiXL1fCw8/RClYqhRI7mTaBjrLe8cERdYLqnpth/QjKb2/HerNX?=
 =?iso-8859-1?Q?HU+1gqzLIZ7qUSJekOfK8U0ptQo7dd8LXEFEkUkmS7e9oTjOmKIRvvTQ/M?=
 =?iso-8859-1?Q?Fsu+pqm90eSwU2+iNFPLbdTPHVG4r5aZXG9T2ae+g77/GJELVN/nC/IaSW?=
 =?iso-8859-1?Q?foZGqUSVxBEej5j6QZx1Nwa5h12EZguUttBuyIn4An/Yt66zhkB8XlDsJC?=
 =?iso-8859-1?Q?n9NQ20UMYdTohO8MlLri7YfU98PKj2pvvq0Uqukw7AYlEiRpbPfroe2Uvi?=
 =?iso-8859-1?Q?DMmAT/Ufqt+fbvdXPGZAECdKzWDunVeX5pFSNQl8HiYLiBWtYYTU08Ui4y?=
 =?iso-8859-1?Q?oWM0EBAMVdDV5FPAszJUARdEozjqeiUZoldHn5rtFStbZyLWo7eNTl1yRE?=
 =?iso-8859-1?Q?cArNJxCyuHdZPcf6okVro0cOG7Vc6hvs6TEjHbFxU1QNRcKLj2SOcdu1Th?=
 =?iso-8859-1?Q?+lNRpEEjwgSzHkujpPsWxVlYMtwfXQSCQ62IT3ZJ6oIJSqb5rHqF2VF+3g?=
 =?iso-8859-1?Q?i5/bnV9YrJLBryIWIGehDUNyGi3CzCv2xPQUdfVEO7VyhKAUPUsgwc7tmX?=
 =?iso-8859-1?Q?nh4h/4HuUtZrZ9iLnKATYnUh12e/V/tALRMeuUAKD5u+s9inN0hG5nG3sk?=
 =?iso-8859-1?Q?6w00ebsOOGfBpLjs+A0gmEgQhQp9lzZvt3WzFl8zh1vnZPtpolwm33sNXr?=
 =?iso-8859-1?Q?m4Q9H5m6ysx01LIs28dllFRwOIkWC+aSb/meake2metLrwjk34qJb1vQW9?=
 =?iso-8859-1?Q?V3mZMYByUZVQtsx0jNjSgel+exgwHP3KXplHzpjub7vQcwUV73ueEDMeoM?=
 =?iso-8859-1?Q?htubxxbJqWC5wCzMz61jEIVKY5UY+WZCmjZHYdIICsqQUBKnpu81b5Pd+k?=
 =?iso-8859-1?Q?3hV+UGGLGuzbVZsxbw/2yURBY99TJb2013+axUiBYRrk4fqN9HKkDSpXYS?=
 =?iso-8859-1?Q?MPC5lD/E69Fnl4br3gkS8KjMYAsTXjbXHCzTW+UmPx2IVPUxGaEMs7HjWU?=
 =?iso-8859-1?Q?IwW3d0xO7tyOVWl3SZAp6Gd5hfDvIrvvVsFk1NJqLwcsL2nDbegcT1NebS?=
 =?iso-8859-1?Q?n2xKG7tIQEUCTftjAsUbcnlY50CPUz0HGe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edf53ab-0844-41a3-73ac-08dd18fa84ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 09:10:40.4547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxVUi30GUxn6isl33AoQHtYbWZhk1rz+Uzr2ZZ5rOo8Jl7f+h4qAteW6jD5L/Jo4EOnaNqrHsDoQ0FTDFzLHKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5073
X-OriginatorOrg: intel.com

On Tue, Dec 10, 2024 at 10:51:56AM +0800, Binbin Wu wrote:
>
>
>
>On 12/9/2024 8:45 PM, Chao Gao wrote:
>> > +/*
>> > + * Split into chunks and check interrupt pending between chunks.  This allows
>> > + * for timely injection of interrupts to prevent issues with guest lockup
>> > + * detection.
>> Would it cause any problems if an (intra-host or inter-host) migration happens
>> between chunks?
>> 
>> My understanding is that KVM would lose track of the progress if
>> map_gpa_next/end are not migrated. I'm not sure if KVM should expose the
>> state or prevent migration in the middle. Or, we can let the userspace VMM
>> cut the range into chunks, making it the userspace VMM's responsibility to
>> ensure necessary state is migrated.
>> 
>> I am not asking to fix this issue right now. I just want to ensure this issue
>> can be solved in a clean way when we start to support migration.
>How about:
>Before exiting to userspace, KVM always sets the start GPA to r11 and set
>return code to TDVMCALL_STATUS_RETRY.
>- If userspace finishes the part, the complete_userspace_io() callback will
>  be called and the return code will be set to TDVMCALL_STATUS_SUCCESS.
>- If the live migration interrupts the MapGAP in the userspace, and
>  complete_userspace_io() is not called, when the vCPU resumes from migration,
>  TDX guest will see the return code is TDVMCALL_STATUS_RETRY with the failed
>  GPA, and it can retry the MapGAP with the failed GAP.

Sounds good


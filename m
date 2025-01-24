Return-Path: <kvm+bounces-36462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C59A1AEE7
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 04:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CBC73A437C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 03:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53EEA1D5AB2;
	Fri, 24 Jan 2025 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZsxKfn8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9F184F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 03:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737688171; cv=fail; b=Q6iZk9ZN7lWILr2njAy4SPVG20mJT4t6eEGH+9HQROMFcC3i0PW+y3PcFOYXDunLYUzuBVQPJRUdERv68FEIN5nObmG8foGKdIQ4EqqZT89k+F7s0VaJdeCJYu1UzHdCexrVBmHd4x5rZ7rlSGnEzPIxtdNkL96p4xhk/9hDUyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737688171; c=relaxed/simple;
	bh=KX7jAo5Ui2RCeeGUxP4Q2E/YE6QBe3rbYfYja6KvTz8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qS94Eg5ruArTA3VZTaxDxfj0vspEAAfvN1wbb2vTpv51qRqwmZXcOzdmnGFWxrQw15UCPJZL62uY75O8o+UjlyBN82OIQEPopQTio3vmnQZEb5Cf9iXZKrki2wy8U5bjuqRYTHfb1Wi6QVqtOCnbW+UeHE/rfbtp3TyvcdHdhYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZsxKfn8; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737688169; x=1769224169;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KX7jAo5Ui2RCeeGUxP4Q2E/YE6QBe3rbYfYja6KvTz8=;
  b=WZsxKfn8DTGollGLCN0/2gCDTlDFIbTLeRm+dpDLlXhZAGsSrnrb1Lwl
   HEnk0ESGNzbilN3xtDDsmicr9b2CH0GKIh5Pl/M/Bct4XHJg3fLwLxPJx
   5UwuHqfxohRXzplyCGCC226NR64XBuui+woZ/Ggde7+Jel+Zuv1wo4Va5
   OPzJ9Tc/0IZ3HKLnySNfeZCcc43LAu+OF0tkc69Cbu18bhbizL9c4UD3M
   RahHp+/A4pwDKVdeIJDMFONTbut3O1xVxI9t4O6rUn8C73JbAkUS7evgB
   uE5t8BJE8ogHoX6j6kXs84ZMiBM/mZi+Rk+3wXqGubfz29Cx6CFPOY2pQ
   w==;
X-CSE-ConnectionGUID: xCG/s+utTi6QaZXJja+Zcw==
X-CSE-MsgGUID: 2RE2ovhASqCyy9yLPBL4Dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="49614032"
X-IronPort-AV: E=Sophos;i="6.13,230,1732608000"; 
   d="scan'208";a="49614032"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 19:09:29 -0800
X-CSE-ConnectionGUID: TgDTacHUT56/DiACgdJl0Q==
X-CSE-MsgGUID: z8DAhQP4TDiea72e2vfnJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112786087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 19:09:29 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 19:09:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 19:09:28 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 19:09:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryUX4CglYmLcYbr6zYOaWsgPPEsrmmAZ8vlj76gESqXg31Zr2xtG6RGnrqUP2Ww7mxlm9Y1Ohb61eWq5taUMZAleOy7pCID+GmJaz2AcB9n68afi8/kYpRbOyaw8VJTX6+TAq0EM2dlCM97LIDvQ3+jvlCI5P9GfI73agoWjkpcNQUq3VKRz+jxPn8WULuKLRSGZm3GeZ8f4THfScQvbkrjPn7/mKB3uybIyMWRl7PoyO0hTgW+UXbpHJ2q45n63PF//ME1qQ9QiNCftH27azq+VOiMJuNpFk1oD0wQjLVLPiIYSmb40xhuCvABGdKjZoKlAEPQFavtmIolg92ePAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lghLeCX4OisosFmxNTMaR9JP30fj1quISreNx0NVjXk=;
 b=Dy3PrHQOT2oE9Q4sNJjDOianfhG/Tjf0c/vqB7A90zbc+x5z1TdOgfd16DXBlkock5dFN6I33e26H0y/MzUOruh7mWxhixF0N22X/3hFeypj1BdC6gf9KZNCzsdFq6qpcnh7GX0KzrrgGWP5EG4YMyUo4Y42dJR+L6miwOVXllatxv1/aqxYqrPtBpKMdW2ES7C8DVgagS2kdxWZuop+J1RabRidf632YfmErR6sTprnSaFsiEYtBngGY/1k9kZnfeXLUyrXbMzXq4KO0LkJnMiaqFLlTFbt0qB6i5Xy6ZGHGkQJfeWysRUXpgijQCdZcJ98Uf+USYeD3nJxt+wWZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.17; Fri, 24 Jan 2025 03:09:21 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 03:09:21 +0000
Message-ID: <d54f6f53-3d11-477e-8849-cc3d28a201db@intel.com>
Date: Fri, 24 Jan 2025 11:09:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Peter Xu <peterx@redhat.com>
CC: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com> <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com> <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com> <Z4_MvGSq2B4zptGB@x1n>
 <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
 <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
 <b11f240d-ff8c-4c83-9b33-5e556cde0bce@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <b11f240d-ff8c-4c83-9b33-5e556cde0bce@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0088.apcprd03.prod.outlook.com
 (2603:1096:4:7c::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f434b97-d9e9-4dbd-24e5-08dd3c247f4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aE9GQnZ5cDhkTG82anE4YVo0MVFzMStOeklkaVZ4U2cxN3lXRVpkRG9mZ2d3?=
 =?utf-8?B?U25jdFFhWkFrYlZTbm5DZFN1d0U3N3BvR1p4MEtMaVJQMlgvRk8xRG05dkti?=
 =?utf-8?B?ditpTnZCUHh5MzVHTDVyV0wwV2ExbXp0MktjU3VPbGN3bmxYQ0NTTTBqNWJY?=
 =?utf-8?B?Ujl3RXB3dVhGNlZkcmVzNkliZVVEdHRDWk51Y25aQmkzZStYTXBJMmpRbXZz?=
 =?utf-8?B?K3ppUVVnZWt5ajNhdzZJcUl6bTRjOTBoSkhEM1BvWDhLUm9Bd0o1S0xVUENY?=
 =?utf-8?B?K0crSTBmNFFLZ3MvV1lZZmJ4SjYxcXpuN0RQcXA2ajNvR0R2aXdobEpCWThN?=
 =?utf-8?B?UVljOWlBTUVMZ2pkTEgvQUVXdlRhdlpwcUk5Sk9rK2luK0J3YkNZMFNaVERQ?=
 =?utf-8?B?a2FQdFk1L0FuN1Vkdmtsd3l3RzIrOGhIZmJWbzBqN3NMYXg1SWNjS0VLb1ZM?=
 =?utf-8?B?enEzb3kybld6TDRWV3hHTzluL3IweEMzZEZMQmp4Z1QrVXErZFB5ZG9iUFlB?=
 =?utf-8?B?VXdUY2dQdE9SczJKVjlnMTB0OGtRTG92dDNHQlVWK0pGVHJkcHVqM2NjQmdt?=
 =?utf-8?B?RXFod2YzNVh6NzFDRklCMkhFNU9kZHFQdHdTRnI2cFZXRk1aN0dSN0tLU1dB?=
 =?utf-8?B?MG5RSnBmUzJqWjhTN0UySjNxL09tYWtkR3crZXFDbGIrcGhLRkdNWlhJTmdl?=
 =?utf-8?B?MW11d3ZUcFBJM1ZhQlE3OVVrRERja0hMa2E3eXhuM1hiYWZmS3hHenUveVU0?=
 =?utf-8?B?NEJXR1VXcVFHMkxORGVjc2NrUWpLL1djQ2pGSXVHNWRvcmVWbXRUVTZVL25X?=
 =?utf-8?B?Rms5Y1N6R0prN0d4d2M0MGFmMmVDY1hmUTB2d1ZwTjkyU2xwL3dKVzlmc0Z5?=
 =?utf-8?B?TUxCbnVpUlpNa2hHdURlN3dUSGh5Y2ZPd0dSbkdFaDVOK3puaHZqTVF3RW0r?=
 =?utf-8?B?bUdpZDdhMi9JMHdIalpNbG1LY1VaTzBEaUtLaW5qRWtPYStGNyt4Nk5CUmxx?=
 =?utf-8?B?cHk2RmtSbW5iWDNyaWlmMnJkc1RDcEUyMXZGdDlQRzQvZ21rSExmWkFFUUM5?=
 =?utf-8?B?b2dRb3lpYjd6VWJWcDcrbVB6Y2dseDMrdklsRTJXT2lYU0Y1RFZkbVhTekJn?=
 =?utf-8?B?ZGs2Q2UyWmFiQ3ZEcEJjUUt0NWhVUm1VT0ZKQVJBd0dGV3M0bjhiWGZ3Q3Fu?=
 =?utf-8?B?N2NmcDJUQWJBdjNTZGtXeVhMRkF2T2FIejBnUDRiSzVVU0tmN3QvbmlueDFB?=
 =?utf-8?B?dHNRb0JEa1c3dDR2bHlaSnFwMHdzbkVXWlhqMGcreU8xNnliRkdMSGgvZXlu?=
 =?utf-8?B?NTIyZWYvN2RNNWp6YlJVYzFNenIwMmZ6MHhMWjJwMG1mNmprK09GVWt5K0pV?=
 =?utf-8?B?SEdrNUNlcGQzUVh2NWxlRnRnZ25QSkJ6ek1lcGhBdnFjemQ3aDlpc1U4OHN5?=
 =?utf-8?B?QVNtVXJuQWVXOTNHa01BNnVhZXdjNmNWOTdmajFIbUhBRHFISHd0YTc5WUti?=
 =?utf-8?B?Y1lhZ0F4b2pLUmppRkFrbUdiN0IvM0ZKUU9yNnVBV3JPZ21Zc0pja0dGcHJE?=
 =?utf-8?B?MWRrcDJqLzF4WVNxOUw2QWR2d3poN2NMRlF1MVNuQ0xUcmFCZk9EWDBZMUpw?=
 =?utf-8?B?YURndjZVT3NnVzc2d0t0eEh3UWpwZjJHbkZMbmhrbmJubFlJd2Q4c0ZudmZU?=
 =?utf-8?B?NEpBVFMralNvUzJzbG5CbzNTNnc5WFdZOW9XdkMxVEhkaVJuQlNoeFpEd0hU?=
 =?utf-8?B?UCtmWmRORE1maVAzTnlhNHRiV3FIQm5mRDFucWhGdG9zdmNER3dUM05tOEN6?=
 =?utf-8?B?YU50RDRFazQ2WE1DZTlyUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHdRWUpsQTRIZ1RtNmhGN3U0RlBvUHhKNVVSaHgxeDJpd1orTnhKRGhTcVVY?=
 =?utf-8?B?eHpYY05LMUR3N2l1b2c5OTE0bHIxejhmVXFUaDFXUkJ6eHBVcFcvaFI4aUc4?=
 =?utf-8?B?R2N5Z2ZzWlBZbENNWm5mcE9HOUtwWVErM1hxdHNMVW9tV04wZTc1MWJTWEdq?=
 =?utf-8?B?VFNTMGpwQm96SHRvMWhMWUJCREgvcDN5SXlGTXc0QXBFc2ZSN3VDNERueGcy?=
 =?utf-8?B?cVl3eHRtT0docm1tamZ6OW1SMS9tRlozT1o4Q3BDWGxhTURrTHg0emNjL0pB?=
 =?utf-8?B?Nis3aGMvaGw5YWZPRWJTRGZ2T3ZvYjZkZXJZUE9DcWNnL1VCL2xIa0Q4WC8z?=
 =?utf-8?B?aG4wZ0VOZHlHV2N6S3EvazdLUlFuUVNIL2tmcnR6YjEyWGc1M0hqbDRTWDFm?=
 =?utf-8?B?S2FCVDBjanNXcmNTdzdxY3FBWnlqMHlZOEhCUW93dzBTRmhhaEtHc1pmSXNl?=
 =?utf-8?B?VDFNVG03KzY0RXdSWkg5Qm5kSTBiOFpFaE01eS9TK2tLSmF6b25OT1BwUmpM?=
 =?utf-8?B?RVJodXlncVNETDArKzE5Ui9sMnV0U2xKZ250T1lUOXB3d0lXTTFuTEdWbVpI?=
 =?utf-8?B?My9wWU1CMW15UEFQamJmVjJkdUcwVTNVc25LZlB3ZS9mazROeWxBUzRsVmtn?=
 =?utf-8?B?VGlFMDhUSHAyZkN0bTBTeVBrVzIvbjRtMVpudXU3WlBTK0U0T0dRSHVLWVlU?=
 =?utf-8?B?czBMSjR5Ukc3c0IvRnBCR1hxL0FTcDk2ZzdGVlYyd1RlaDlraDBFZFRMbnJm?=
 =?utf-8?B?UEF6QlNINkVqRWVHSUcra3BabXdKSkdJRkgwZm15UXV5V09oL3hCdm1rdzhC?=
 =?utf-8?B?bmFXbE04QmgvVkp2OEgzTmdYTW5MQW44RVgwb1lIQnBaWEFQK0xHd016a08z?=
 =?utf-8?B?bWIyR3l5V3RDUFBhcDhpUTVNSEJOTUwwRFAvaEpOcFRPaysrcUg0Mnp2RVFi?=
 =?utf-8?B?QnZKZWcyUzhvK0ppU3pzNkNxYTd6bWU5UUVPOGpBWm54bDV1aWRVV3FvQlQ0?=
 =?utf-8?B?UWFXVGdzelpFdm1SNURpZ2l6QUFtc25NTHRnMTgwSlpZdE90UldTKzdEQ0JQ?=
 =?utf-8?B?Rm5RL3pjV3RxVmcrb1JTZGt3cDViSkxvRCtaT01nWXJsTlJyUS9IWG1oVllz?=
 =?utf-8?B?eWR2bEo3NWEzbXlhWGkraTFWdTZ0TEZvVDhMTzRodm5BTGZnOFd5ZmR3VWJM?=
 =?utf-8?B?QllJemZRNEtvN1hmeWxYa21vajE2UXYwUkM5TjlhbUJNdEJOQVJMUi9nSTJ5?=
 =?utf-8?B?VVpMU3VzclRIUEY5RzN5cnVsVVVySzcrWCtwMjhWKzZyVUcrMDJzUmJRTm5J?=
 =?utf-8?B?Ry9QVHpyUVRSbUxNUXFKQXNCbGthUkVRZlVpREd5L0hKRTgwTlhjd0JjUE5z?=
 =?utf-8?B?QWhMY3oyNGducCtVUXZFUCttQmRSK1pSRzU3bE9sWGdkek4wdW8xMCtsUWgx?=
 =?utf-8?B?NjRlWDRJMjM4TERnNUFaMEhKR3J2SVZVQ1ZHN2JRZTJmMk9OeW5sbUd2cWI2?=
 =?utf-8?B?amZjbGtnWTJ1OHk1Q25hUWIySllZejh4dHFVUVh6WWZhZDdZTHp5blZ5dnd1?=
 =?utf-8?B?VEU1clpoZkhoQzN2c3p4RFp4WklLVVliUlppMXZWWGpCeGszeE9MaHowRXo1?=
 =?utf-8?B?VEIvVnpHa2x2ZXhRMUVmZkdHYnY4NVFYT3VzYllaNlIwRFNjR25BN3c0VkpG?=
 =?utf-8?B?bzQ4OEUzQUEvUm1NbXVoVllYR0hqeU9NdjR2R0tERmdOMnlVTm9xUWUyS3g0?=
 =?utf-8?B?a3A2OHIrVFk5Y2xFcVhPSmF4RFFpUHVmS1VXMmdHQmYzd3QvZUpNbHdCNmYz?=
 =?utf-8?B?dkcxdWtGQTg0L1Q4MmFqWjhaVFJYMUVDdit2dVhWM2xZblFUL0tjZXhVc2xq?=
 =?utf-8?B?RGtNRzlCNlVucXJNNEhyNHdWaVdjQjVoR2dzcGFZRUduZmdtM1crUFhEQ3Iw?=
 =?utf-8?B?QUE0aXE4TEZuRVVKQTlYeUdFZnB6aXBlVUx6aE1FczlPZHI2TVMrak9LY0p1?=
 =?utf-8?B?b0k5ZmhKUjhWUzZGSWxQWU1sblhlR0lKTmJNRU9EYmQ1cGc3REdheEFUMm5Q?=
 =?utf-8?B?Ym1nS3FJc3RVQk9yU1hjM1g3cnZKR2xUQkIwWTUvMWpWTHE1a2tza0RwdEsy?=
 =?utf-8?B?bzN4dmYyc1BaNlQ4bkVLU2hxTUxzWXdzZVRscmFoMlpmOWxzY01JVE91cjgx?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f434b97-d9e9-4dbd-24e5-08dd3c247f4c
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 03:09:21.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1kX7QHYrZoVYd47SobzOMANiZEfAKg5WokigoSrHM+XtiAzknRtYI0sxWtagzaIrDlYS31smnGyU81FHhf1Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com



On 1/24/2025 8:15 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 22/1/25 16:38, Xiaoyao Li wrote:
>> On 1/22/2025 11:28 AM, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/22/2025 12:35 AM, Peter Xu wrote:
>>>> On Tue, Jan 21, 2025 at 09:35:26AM +0800, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/21/2025 2:33 AM, Peter Xu wrote:
>>>>>> On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
>>>>>>> On 20.01.25 18:21, Peter Xu wrote:
>>>>>>>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
>>>>>>>>> Sorry, I was traveling end of last week. I wrote a mail on the
>>>>>>>>> train and
>>>>>>>>> apparently it was swallowed somehow ...
>>>>>>>>>
>>>>>>>>>>> Not sure that's the right place. Isn't it the (cc) machine
>>>>>>>>>>> that controls
>>>>>>>>>>> the state?
>>>>>>>>>>
>>>>>>>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
>>>>>>>>>
>>>>>>>>> Right; I consider KVM part of the machine.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> It's not really the memory backend, that's just the memory
>>>>>>>>>>> provider.
>>>>>>>>>>
>>>>>>>>>> Sorry but is not "providing memory" the purpose of "memory
>>>>>>>>>> backend"? :)
>>>>>>>>>
>>>>>>>>> Hehe, what I wanted to say is that a memory backend is just
>>>>>>>>> something to
>>>>>>>>> create a RAMBlock. There are different ways to create a
>>>>>>>>> RAMBlock, even
>>>>>>>>> guest_memfd ones.
>>>>>>>>>
>>>>>>>>> guest_memfd is stored per RAMBlock. I assume the state should
>>>>>>>>> be stored per
>>>>>>>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
>>>>>>>>>
>>>>>>>>> Now, the question is, who is the manager?
>>>>>>>>>
>>>>>>>>> 1) The machine. KVM requests the machine to perform the
>>>>>>>>> transition, and the
>>>>>>>>> machine takes care of updating the guest_memfd state and
>>>>>>>>> notifying any
>>>>>>>>> listeners.
>>>>>>>>>
>>>>>>>>> 2) The RAMBlock. Then we need some other Object to trigger
>>>>>>>>> that. Maybe
>>>>>>>>> RAMBlock would have to become an object, or we allocate
>>>>>>>>> separate objects.
>>>>>>>>>
>>>>>>>>> I'm leaning towards 1), but I might be missing something.
>>>>>>>>
>>>>>>>> A pure question: how do we process the bios gmemfds?  I assume
>>>>>>>> they're
>>>>>>>> shared when VM starts if QEMU needs to load the bios into it,
>>>>>>>> but are they
>>>>>>>> always shared, or can they be converted to private later?
>>>>>>>
>>>>>>> You're probably looking for memory_region_init_ram_guest_memfd().
>>>>>>
>>>>>> Yes, but I didn't see whether such gmemfd needs conversions
>>>>>> there.  I saw
>>>>>> an answer though from Chenyi in another email:
>>>>>>
>>>>>> https://lore.kernel.org/all/fc7194ee-ed21-4f6b-
>>>>>> bf87-147a47f5f074@intel.com/
>>>>>>
>>>>>> So I suppose the BIOS region must support private / share
>>>>>> conversions too,
>>>>>> just like the rest part.
>>>>>
>>>>> Yes, the BIOS region can support conversion as well. I think
>>>>> guest_memfd
>>>>> backed memory regions all follow the same sequence during setup time:
>>>>>
>>>>> guest_memfd is shared when the guest_memfd fd is created by
>>>>> kvm_create_guest_memfd() in ram_block_add(), But it will sooner be
>>>>> converted to private just after kvm_set_user_memory_region() in
>>>>> kvm_set_phys_mem(). So at the boot time of cc VM, the default
>>>>> attribute
>>>>> is private. During runtime, the vBIOS can also do the conversion if it
>>>>> wants.
>>>>
>>>> I see.
>>>>
>>>>>
>>>>>>
>>>>>> Though in that case, I'm not 100% sure whether that could also be
>>>>>> done by
>>>>>> reusing the major guest memfd with some specific offset regions.
>>>>>
>>>>> Not sure if I understand you clearly. guest_memfd is per-Ramblock. It
>>>>> will have its own slot. So the vBIOS can use its own guest_memfd to
>>>>> get
>>>>> the specific offset regions.
>>>>
>>>> Sorry to be confusing, please feel free to ignore my previous comment.
>>>> That came from a very limited mindset that maybe one confidential VM
>>>> should
>>>> only have one gmemfd..
>>>>
>>>> Now I see it looks like it's by design open to multiple gmemfds for
>>>> each
>>>> VM, then it's definitely ok that bios has its own.
>>>>
>>>> Do you know why the bios needs to be convertable?  I wonder whether
>>>> the VM
>>>> can copy it over to a private region and do whatever it wants, e.g. 
>>>> attest
>>>> the bios being valid.  However this is also more of a pure
>>>> question.. and
>>>> it can be offtopic to this series, so feel free to ignore.
>>>
>>> AFAIK, the vBIOS won't do conversion after it is set as private at the
>>> beginning. But in theory, the VM can do the conversion at runtime with
>>> current implementation. As for why make the vBIOS convertable, I'm also
>>> uncertain about it. Maybe convenient for managing the private/shared
>>> status by guest_memfd as it's also converted once at the beginning.
>>
>> The reason is just that we are too lazy to implement a variant of
>> guest memfd for vBIOS that is disallowed to be converted from private
>> to shared.
> 
> What is the point in disallowing such conversion in QEMU? On AMD, a
> malicious HV can try converting at any time and if the guest did not ask
> for it, it will continue accessing those pages as private and trigger an
> RMP fault. But if the guest asked for conversion, then it should be no
> problem to convert to shared. What do I miss about TDX here? Thanks,

Re-read Peter's question, maybe I misunderstood it a little bit.

I thought Peter asked why the vBIOS need to do page conversion since it
would keep private and no need to convert to shared at runtime. So it is
not necessary to manage the vBIOS with guest_memfd-backed memory region
as it only converts to private once during setup stage. Xiaoyao
mentioned no need to implement a variant of guest_memfd to convert from
private to shared. As you said, allowing such conversion won't bring
security issues.

Now, I assume Peter's real question is, if we can copy the vBIOS to a
private region and no need to create a specific guest_memfd-backed
memory region for it?

> 
> 
>>
>>>>
>>>> Thanks,
>>>>
>>>
>>
> 



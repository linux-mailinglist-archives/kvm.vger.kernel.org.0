Return-Path: <kvm+bounces-39622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D43A487E9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FFBB166307
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4F11EB5CB;
	Thu, 27 Feb 2025 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z1NGNcnY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF46B17A303;
	Thu, 27 Feb 2025 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740681475; cv=fail; b=E6thR7lkBQ/XemIP9vanwDN2gnWBmibaBttlFUIFncIpKUvCtmWGm2nNJiwOEdJbYV6e1zRFa2y2MZ/FyG/vcffrFaQsKcGzE1Vik/yLaJxgLbPMmcElQJlWt+AzW2TXRV9AT21R32Lzhw+2ClHSL2HkdNDXlZRjNAN2x62+a54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740681475; c=relaxed/simple;
	bh=n7mj7DkbqlbAZf4IF1GfpacWkQBo3UeJUGraBfCA37c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bSTi34Q2T0iX0I16+2FdFPJDZQ0Yhw8fJ1uMXeJG3W3vRt+MskRZR4TB8SsZbYCD0jh42qSxDXFpDFca3BVn5/us9V3wd5v1/XKASNZr43KZEm4S37j6MSppvVZcRAmZ0ivJqr8Qlg+s70LJfHyAyxTWMWFLWQRvoyPkZ31v5gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z1NGNcnY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740681473; x=1772217473;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n7mj7DkbqlbAZf4IF1GfpacWkQBo3UeJUGraBfCA37c=;
  b=Z1NGNcnYMXRkk5A5LftlfE2l/GaPtP6ADGQCUJf+joohZUTJBg2E/SUm
   Y8nm79uptJp5C5XEDFRv5/bIBHPvQu49e7utNKA9XKKxk/4VsGGJm/JxB
   Ua338TbKM+AATstM4A6qKqblMYZdzq7U0KdaHySxqXEkLWDbg7zfyoT6l
   6TKjqQcaB3XH1Syt3xjfXJZE15D96zMDERk+ctfIO7mAhslA5aaJG25MR
   XNjGklgmd6Loj78xQgCit4VEi6Absk/8EfSeAfJE4EE/RxCO9Bh8w/ZyO
   XQw/DaU9k6qpgxilJL//XXmnMEwRpKa+9jHOOFOhNd8BAlEE24E/BBAni
   Q==;
X-CSE-ConnectionGUID: TI4M/75DTpOMNSPbYHqtEQ==
X-CSE-MsgGUID: bV29r8R5TRWZZ92AAZ1tlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41293862"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="41293862"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 10:37:52 -0800
X-CSE-ConnectionGUID: bb3WuZ6qQDi/R+y2o8e4Hg==
X-CSE-MsgGUID: YD4K7WHBSMGqWcoQZn9voA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="117606241"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 10:37:49 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 10:37:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 10:37:47 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 10:37:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dt3BRPUabFYkNM60bM8FgeNi3T4ylo7z4YmwauIYrZh6eM7ckHZMrr68wHG+er6LSQS/n/chx84oPm1txTsDSDb964ZU6tIL5g8iwuTTXq32XUPhSay4K7oX9wNH7Yq39GdM15JX3txZZz/gjoYvUAIOU+uMuFjsysxO2BZO+UpAxKzq7VpncF6d3F6u00Em2hXi1dfbkPCEvSrImJco32Mio7POB4rutgdtl2Y0zFc8tN6nvl+7Z3pvhIv9k/BQR0rijlpskAhSOHxbRYNgaUvHQEa/kkb8OJetFbIzrTcHyEtl6C90sIJ7C+LH2UMSSxFwjcHEnstpMeOBl2hy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsx3AQ7Q4m7XyM8mClDdMfLdo3JpXjvHFzg3Kin95vk=;
 b=hj/cZB/E1FBnvYZqkOxRXfcot3xNtEgXPhgoRQehty73f0nWRdYxVotvNpYZ+XbjGe9hLJK8u1P1zd1JDIawAoKCw61+QWd8v6pC78gtQyrTecRhbNTyXAs2j5NNH7n/BeQTCeIXRDMo4sL081UX1Zy4UrVH+bvqtnDqkAMA69AiKpFxtfsl2lMmFF2A8dgpKdHPXy0NE41+GoHwL/UdFvMA952g4aEExfnGv6mlP2p6JTrhOLY8PpLf4dFCB4HJis6T7gyrAkjnUAoy7f2dOlRDHJMUcPTS8f/0IXjOhAGJZHwcKhZSUma/M79ejH5J7HNC/hZOLxHvmiFFE9Sr/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by SJ1PR11MB6274.namprd11.prod.outlook.com (2603:10b6:a03:457::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Thu, 27 Feb
 2025 18:37:39 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 18:37:39 +0000
Message-ID: <3e64b29e-34eb-4f9e-b7d1-a7803665ca55@intel.com>
Date: Thu, 27 Feb 2025 20:37:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-6-adrian.hunter@intel.com>
 <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
 <632ea548-0e64-4a62-8126-120e42f4cd64@intel.com>
 <d9924ccd-7322-48aa-93be-82620f72791c@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <d9924ccd-7322-48aa-93be-82620f72791c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0002.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::22) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|SJ1PR11MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: f750eeb2-037c-42b3-7910-08dd575dcfe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWYwanVOVmE2ODBaQUt3VW1EeHJuV0FHMkZUeThUTmpUckF3cW1vVm9PT2pP?=
 =?utf-8?B?bDdwSWxLejRxOVptei8xaStiMk5ueFVwL2s1aVYrdDJPdHc3cVBGeER0b3lL?=
 =?utf-8?B?cDBIWXgxWVlEaGdiOC9GNEEwZUJseGthelgrTmpaNVpsS2E5NldlMnZoUEN2?=
 =?utf-8?B?NjZkTmVzandpSVpYclhaK1E0bzhaMk0wbldhYTVOVWxvNFBOZ2N6OVkyVHdh?=
 =?utf-8?B?dE1zZlJkVnp6VzZ4RGNiT0VpeVBZOWxyQW5od3g4S0hsOVJzNUFlTXJKYW9G?=
 =?utf-8?B?M255d2ltZ21hQjZBYjFRRUg4eWlveWtXOUt2eWNjMkM2SmRLV211ZFJaY3B1?=
 =?utf-8?B?K3M5Q1FhS0dpWDM3STlXU2JUbEYyaHU1Rnp2OGljeUJxcGJabTFSY09FdDVQ?=
 =?utf-8?B?eHZzd2ZQZjZ5dkFPK05uNkFVZU1oVXFYUU1sYzNBdWljUzBRTTh0VGRkQXRD?=
 =?utf-8?B?MTZHWGl4UmhTZG1oaW4zV1NXcU93alVsaVMxcy9qRGIvSFBva1VFMmlTeXVo?=
 =?utf-8?B?WFBWUENjazh3a2hQcUl4RjJscWU2TkNsSVM4TDd1YmZpR1BzdXYwb2NZeHg4?=
 =?utf-8?B?N0NKNkJZSHMxTEZqeVF3UU11S1pIaTZDb1RqZGVteWNleHgxWXBFUUV5UWhZ?=
 =?utf-8?B?b0FuU0pxT09CM0YvUnJQMjIxTnc3ZTk2SHJIZ2E5b1R1V3JPVm8wbEwxbG13?=
 =?utf-8?B?VWp2d0dnUWlYOXplNjNoaWFLSkE5Z0R2aXdGWjBWeUY0VTdKTlB4SEU1VTM1?=
 =?utf-8?B?ekx6QXU5RGZETmxzcnNZN3VzbGVQNlQ1RE1BTWhacnVzanc2YjZEWWI5a1Zk?=
 =?utf-8?B?VzNZVDVhMUdXSVd0blFyVXJ4Umk5clZNOE1qa1psR2cxbjNpcGFqbTBjeXhZ?=
 =?utf-8?B?QUgzblc4dFg3WEtnU2JRcW5IMUVQeFpjcUtCQStYa09SdGlpUUJTSjdGazFJ?=
 =?utf-8?B?YXY5WXJSaWVNYnJkY3N5YkxZSkMzcWNsRE5jQzU0Nk5VZGhmRjFSakhzUkV5?=
 =?utf-8?B?MnlJL2ExMTJoWjE1OGk2TjMzTFZSLzhkakl3anJMMWUxT2djL2VwUGlsdytZ?=
 =?utf-8?B?bVUzZ2RaNXpxVnA1MTlXZW9Zcldsa1g0Wk1oT0hyNmJHR0EyVXFJSndRam1q?=
 =?utf-8?B?Y2xPcWVtQzNweVV6QVVrQkZLYWgzd3ZBQVVJZ2dCaHRJUVY0VC84QTVIWXQ0?=
 =?utf-8?B?TU9wQUo2TTd1aGlobEtPdDZMdTVwRHdpUU1GeE5uc2s1bFVyUjFZVEp3a3R5?=
 =?utf-8?B?dHRMT2pPRWVsUDRpOVVYY3FtUWhrK1NxaEZTMDZ3T2ZndlJZWkJ5RENYbjVK?=
 =?utf-8?B?RDVCcDRJZkpteSs0dzlLem5hcytUSnlic0VNV1o2Yk5lNG8xSHlOL0psWDQ4?=
 =?utf-8?B?N2I3aUNuaDhWOS85MjRGL05DaWxIZjBSQm9Qek84aWE2QXBYaCtnSExXNXZM?=
 =?utf-8?B?VStSL0FpSVJDQ0VVSTBtUmtCSWtIRzNFVEhnK2ZZVk85MGRtdDE2SlkyWDNF?=
 =?utf-8?B?dXVkQkVvblJtdDZrZkEvSFdWOFBOZjhDNk1HdXdNZ2g4dGtoejRaQVNObFV4?=
 =?utf-8?B?UjZZcUFFTFBEb0NDQ3FiRFRJQzJITjVBc0pEd3Q1NXdGZ0x6cVBQYzg2WmxQ?=
 =?utf-8?B?dGFZYU1UeHM0SElNUVJpK1Iyb1RQWTEyWkxXRzNYeHBIL09RY2x5ODZ2WW5m?=
 =?utf-8?B?K2IwK2tSc1dlRWF2eVkzdFJrcmtGWWpXQTZ0bFJ0Tyt3bXF5djNPZ05QQ0tj?=
 =?utf-8?B?V1ZBNHdXUHB5bkNmemNrck4rVTBsUXUySWpPckYvS0hBU3IzczRyWG5HWWMr?=
 =?utf-8?B?TzhlT0twa1Bweit4cnhNQzlCNTREb1ExWGdBYndHSDdmemRieTBlNHFMYXJI?=
 =?utf-8?Q?fYtpAqX6copzD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3NySnQycVZEcW5Bb1UxZnBOeVN2S3lWUklxZ0VGa1FpU0Jpd1N6Wk5tQU00?=
 =?utf-8?B?UGpmYkRYWDBZMm1WWHJkU2haQ09YdnU3aFp1VDJLTklMNDZ4bEVSSTNKTkh2?=
 =?utf-8?B?S1ZQL05Vd3F2cnlZMHd2N05abFd1VzZjNFp2d2tJcFF1eWQxQlNwelFEbHlX?=
 =?utf-8?B?dlA0SnRSakxTa0FwSDhLVkFaT1dlWTN1SVI2SitQVkxVRDMxVVJ3THp1cW42?=
 =?utf-8?B?cDlyenUwSnhzS2d4TFNIMURkSy9VZXBGWVRWUUEwbDIyQzAzSFl4THY5Y1NQ?=
 =?utf-8?B?UTFPNlE4WU9mWUtpQkdkdGVvZzk2WXcvdmNlM1hRcTc1YjUraXZ6cW1PUDhS?=
 =?utf-8?B?K3dRWld1ZGJHdkFhbnFwT25URGU5K1NrdW1EWi9zaXRsL1dqMUg3eE5Kd0k4?=
 =?utf-8?B?eFlqY0pvZU55L0JuWU9tMmdZM25CMTlQb1ZUVXh5TXk4TUNGODZIdTFSelht?=
 =?utf-8?B?bmRJaWlBeE55aVFRdXM3dzkyOEMzL3JURXp4VWRIa0xVeHZKVXJWWHRkWU0z?=
 =?utf-8?B?TTFYY2NiQmdEMEphSTFWQWIxVit6NDBtZCsySWRTTkNHTUhTVHowNW5VeGR4?=
 =?utf-8?B?cm4yR2dxRzlyWVEzRFNUYTNTRkxSOTJ5VGpRb3pxTFBRcTNrMW5wNy9HcUVR?=
 =?utf-8?B?d0FuUGMvRE91SDlqWSsreTZzMWJnVk9HSGVYbkdzUzU3RFA2MVdMVERWdHh1?=
 =?utf-8?B?N3BMME9XdU1EUC9tSGRFRFlnSk1rZm9FeTA1NThvczJjdys1T3BJWitybGJr?=
 =?utf-8?B?RC93NlkzUjdta3lUUkQvYnZvQUovNTR6eTF0L1pjeUFGS0dsZVJBZnNvd01x?=
 =?utf-8?B?SW5JK1BzRldWUmhVeHZqeUVnV0d2YTR6ZDhDM2FJMmlFMjdQaDRkRlBIcGpN?=
 =?utf-8?B?TDJuRTMxSENUdC94TlNyUWJHS2M0VDk0dkx0VUphZDNBWmMySlczREtXa3VE?=
 =?utf-8?B?UHoyekNhaElSOHdoOExYUm1BYjladUVkNzY5eFFJMWhvcWE1UGF2QXVBeDBu?=
 =?utf-8?B?OHFoQXlrRHI5a1EzcFBPSExISmUrRjdOUFkwMWU5NE1jZUR3NW85bE90dEVl?=
 =?utf-8?B?UnNOODE4WTdrbVpwdTVTWWZXbnJBdVRpOWpWUlVaa2l0UHoxY250OU11TkpV?=
 =?utf-8?B?RzYzY2FVTGFrSkRWblNJK3VVVTQ1TU5vd2dIbmkyRnJibk4zRzl4elhMNlRs?=
 =?utf-8?B?WmQ0WUMrdXRjWS9MR2VsdGhpUGJ3R2x1S1d1VFVEYnRlRTR1T2I4cU1keSsx?=
 =?utf-8?B?MkZzWFZ2SWZ5bWRIQXowMXc4aWRQYmxwSnFDTTBiUFhkWEZHZjFyL1BUWCt0?=
 =?utf-8?B?YldlYUYzMjZNYUhQNHlOODhqRnBKZjFkWDN5cGxrQ0R5SFlYVzFEL0lzUXJx?=
 =?utf-8?B?UGdyN09JdUdhSWZieW1yanF2ZDJEQzM4RUxwbXNDcVNsdWJ4ZzA0SXlBTVdL?=
 =?utf-8?B?RlBSc2N3WTJCK2QxUWxBOHJ0Z0tRZ21wRXMzNUNlZ05RQ2UvYVcyUzVidWM0?=
 =?utf-8?B?eHlKbE5DblltQTJRd25oT2V4TUhIOG04YnNVKzNwTU52bjNWZjZQRVh6YmFP?=
 =?utf-8?B?aVVhSDViMytKWkx5OVZpY1B4QVc0U21PT0dnelIraGY4WG00dEFsMXhLTmxW?=
 =?utf-8?B?RjlOQ0hWTVkwVUFuclpOQ1creUpnMmFyR0RPb0FIdUNkTDBEYUF6eFhQY1FK?=
 =?utf-8?B?Nzhzb0tPbDFNV2RIZURmbVl6azJjNUFDWFppVjBLWGQ3VDMrcXJOTnhvalBR?=
 =?utf-8?B?ZmhSUU5DU2xtMXk2a1hjWXdlbng1NzdHU2JhdXdTUnFOZmJNdXhnS01DZVYr?=
 =?utf-8?B?cG8zMVloNE5uMXVxd3luMFBvZGE3RjZGcUh6dHNLSC9EVGg0Yk5JQkEzSytD?=
 =?utf-8?B?dDNiNDhlbkUwZE5kZ015a2dlSkJHVlBKd29zejNBdlRnYXFiQlJaRzNRby90?=
 =?utf-8?B?YjJCVTBhR25UQ1ovalpDK3lrdjAraXJOYThzaEsxRGQyRnRONXcwUFpWbGlO?=
 =?utf-8?B?Z3BVa2ZpeUt4dlE1Qjl2WEZkUEtsQk1ka3dNMEpTcjZ5VThFZi9CWTFHU0Nm?=
 =?utf-8?B?OENnRUoxOWtaTnJUUnhERGNmdUJMSVBiZTROVUhGQU8yc1A1bEw1SWhFcVNT?=
 =?utf-8?B?cTduWGkrcG13akRzNUg2c2RHbHlFQkFpZ2ZXelF1eFRTQ2Vxb2s1ME1SdWNt?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f750eeb2-037c-42b3-7910-08dd575dcfe1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 18:37:39.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TuhLfEyz9PQx6oR55yn3Hb6/IJi/F6UQAjqiNl8tZCvkElLSwWGmHrSG0Cxh8MUlqzaGZQvKk0cOxf8zGcTLEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6274
X-OriginatorOrg: intel.com

On 25/02/25 08:15, Xiaoyao Li wrote:
> On 2/24/2025 8:27 PM, Adrian Hunter wrote:
>> On 20/02/25 15:16, Xiaoyao Li wrote:
>>> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>>>> +#define TDX_REGS_UNSUPPORTED_SET    (BIT(VCPU_EXREG_RFLAGS) |    \
>>>> +                     BIT(VCPU_EXREG_SEGMENTS))
>>>> +
>>>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>>> +{
>>>> +    /*
>>>> +     * force_immediate_exit requires vCPU entering for events injection with
>>>> +     * an immediately exit followed. But The TDX module doesn't guarantee
>>>> +     * entry, it's already possible for KVM to_think_ it completely entry
>>>> +     * to the guest without actually having done so.
>>>> +     * Since KVM never needs to force an immediate exit for TDX, and can't
>>>> +     * do direct injection, just warn on force_immediate_exit.
>>>> +     */
>>>> +    WARN_ON_ONCE(force_immediate_exit);
>>>> +
>>>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>>>> +
>>>> +    tdx_vcpu_enter_exit(vcpu);
>>>> +
>>>> +    vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>>>
>>> I don't understand this. Why only clear RFLAGS and SEGMENTS?
>>>
>>> When creating the vcpu, vcpu->arch.regs_avail = ~0 in kvm_arch_vcpu_create().
>>>
>>> now it only clears RFLAGS and SEGMENTS for TDX vcpu, which leaves other bits set. But I don't see any code that syncs the guest value of into vcpu->arch.regs[reg].
>>
>> TDX guest registers are generally not known but
>> values are placed into vcpu->arch.regs when needed
>> to work with common code.
>>
>> We used to use ~VMX_REGS_LAZY_LOAD_SET and tdx_cache_reg()
>> which has since been removed.
>>
>> tdx_cache_reg() did not support RFLAGS, SEGMENTS,
>> EXIT_INFO_1/EXIT_INFO_2 but EXIT_INFO_1/EXIT_INFO_2 became
>> needed, so that just left RFLAGS, SEGMENTS.
> 
> Quote what Sean said [1]
> 
>   “I'm also not convinced letting KVM read garbage for RIP, RSP, CR3, or
>   PDPTRs is at all reasonable.  CR3 and PDPTRs should be unreachable,
>   and I gotta imagine the same holds true for RSP.  Allow reads/writes
>   to RIP is fine, in that it probably simplifies the overall code.”
> 
> We need to justify why to let KVM read "garbage" of VCPU_REGS_RIP,
> VCPU_EXREG_PDPTR, VCPU_EXREG_CR0, VCPU_EXREG_CR3, VCPU_EXREG_CR4,
> VCPU_EXREG_EXIT_INFO_1, and VCPU_EXREG_EXIT_INFO_2 are neeed.
> 
> The changelog justify nothing for it.

Could add VCPU_REGS_RIP, VCPU_REGS_RSP, VCPU_EXREG_CR3, VCPU_EXREG_PDPTR.
But not VCPU_EXREG_CR0 nor VCPU_EXREG_CR4 since we started using them.

> 
> btw, how EXIT_INFO_1/EXIT_INFO_2 became needed? It seems I cannot find any TDX code use them.

vmx_get_exit_qual() / vmx_get_intr_info() are now used by TDX.

> 
> [1] https://lore.kernel.org/all/Z2GiQS_RmYeHU09L@google.com/
> 
>>>
>>>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>>> +
>>>> +    return EXIT_FASTPATH_NONE;
>>>> +}
>>>
>>
> 



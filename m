Return-Path: <kvm+bounces-43807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E307A9648B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9E423A4693
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F289201262;
	Tue, 22 Apr 2025 09:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3gdB/R9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C701F1509;
	Tue, 22 Apr 2025 09:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745314650; cv=fail; b=oS+SnneydqHkdtPnP8VQVB3CdEvmVAVhdZj1SFSErRXtUp2F912JSsJz0NqLEnGFp9ij755O9oy6AeSqSV7JYfE3Soq34lyMEAyO9dwLyW38pdZn4oBNQCavPLCS8MXSJA7M+ijyGsTDryDdeRI4PIAyIrbvFX4TgIsTbA95ubU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745314650; c=relaxed/simple;
	bh=lH5DhwCHlZQWXITO67LNXZqNZ2/7+w7hgQiUugoPCpU=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FjEN8yQQo1xKhlbInUtf0PiPs552KMDHSo4xfHu8s3b063V9QK37PP+tTlFpt0uEXSiyoo02tLsW70NOeDSZzHlywkhigjW240JwtbE1VfpohkEAvwfbGH37NeUjsU2UuqjPyEMgVpKxxK7Gqj1R6eP6dQOwPS5eB6QUl+17CgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e3gdB/R9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745314649; x=1776850649;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lH5DhwCHlZQWXITO67LNXZqNZ2/7+w7hgQiUugoPCpU=;
  b=e3gdB/R9IrMQDLDMyMkds83VPE2n8e4u7e4OdiHR7RdyJQTDI32yZxjN
   8C8sXIvi0eqXd4heACFgAu37bDW20izaqYmOWfm+ARgf+l9d2lLiL3RhS
   vrubQ8QeT8rTWMIBcrZzuixSo3NPaF0MwIutLfa+rX3JCwPNzLXTmWf5a
   JnHKwWly8uQ3jpttdr/2SrMlnCUpstIMdU7xYwuytpg5kfyOa764lHO+e
   27UyufNFWjYxgpOAkpAOnH3T0sGtrD87HavqHL6TkFij+HxA1EEv1w53W
   hYQqEGZ77W1BtZ4Ej6/ovHx4HE3ywEZkhk4yaP4vEsXoU4OQ2i3z0MRDw
   A==;
X-CSE-ConnectionGUID: XfdFtmZtT1u7A1D8dhmNWA==
X-CSE-MsgGUID: Q6lEu4rRSXKjjxUsLSRqLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="50667895"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="50667895"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 02:37:27 -0700
X-CSE-ConnectionGUID: D7x2Q+9XQ3q7QPmF+WTJ7w==
X-CSE-MsgGUID: mUqc5rmZRs2ltacRdS9jXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="137051099"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 02:37:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 02:37:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 02:37:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 02:37:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0W+ImJHczOpwQmUxY6/Bhu2VLW1bQzbwAIBNS2xOCSNIltvSlMxkMsnGGs4WE7qorTzlTuq21AF/ptBwy3I5lHVvLP+1o5ChSmsM3OFb9DWBklMW4U3IvDLAKzX0OzGN0rsBIFfRI56E5UX1t1PHGa61vMdfeSguxjuVaFvmeW8QgDOiqDlzbFSH/l0/kNNaK3CO72EVn+53F22H2N1DOI9GxQJEaTG6KbD0Tc5xmM9VH4To/VHSSAdvZW9Z7GnzIvM0V774EneuLtzB2v8m2bb324TejoFNm+91qJRO3fIf4o5zQwyItw3yTUgg11FCn5I037ootGB5KDeTpOqAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oatqzS7/LYmRQIRz3ZMB4rIhSQUlFIke/IkuNahpGMc=;
 b=Mb2R9EORrlqNVwJuWc7cbuDaB+Iue9Sp29Yj5DbpDtSCFpdCnhWnE/PPDbOUvzI/PzrOmqssoQWowwLB/3YIFUNttG4lwKmcblHifvszCriMMZ+Fg2XPWukCa7G1YnXDZEh/cehFAAm482VRHvvXFXfGH2DKshcSYrX4qF0qVGjacGhpmSez6sstYtT3IeTvYdzYvvyIGnKQgAEh3in35BXcv0kpRKImyhuOJoy/U1j6sMayynUQ5Bu+6fVeBL5FWtguwcu07Zxjmvl2T714GIVlFjvwUYIP/mckLpMxPuXZAoxcXFRtVIEsZx9rE6iieZ49OuzKipG9cNKGcBOE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
 by BL1PR11MB6004.namprd11.prod.outlook.com (2603:10b6:208:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 22 Apr
 2025 09:37:23 +0000
Received: from PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301]) by PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301%2]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 09:37:23 +0000
Message-ID: <b8d558a9-f9cd-4526-b7be-5844878bd590@intel.com>
Date: Tue, 22 Apr 2025 12:37:13 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Adrian Hunter <adrian.hunter@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250417131945.109053-1-adrian.hunter@intel.com>
 <20250417131945.109053-2-adrian.hunter@intel.com>
 <aAL4dT1pWG5dDDeo@google.com>
 <910152f4-22b4-4b8d-b3e4-8e044a4d73c9@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <910152f4-22b4-4b8d-b3e4-8e044a4d73c9@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR10CA0093.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::22) To PH7PR11MB6054.namprd11.prod.outlook.com
 (2603:10b6:510:1d2::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6054:EE_|BL1PR11MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: ec841806-d325-48ae-ba7c-08dd818148b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T1dBZ3NBN3BsV3RaMFp6RlJGS0NZZ1lYSTgyYVBQcWRNT0hVZm5OME5KalhJ?=
 =?utf-8?B?OHNQbTJFMGtnUUZydGRybGxtYXo4c1JQUDRkQ3lOSG9vQVhZeURiU0xhWjd6?=
 =?utf-8?B?bFh4K3YwVU4yMlh2RXU0VmZOWlNra3BxdStmWjJUK1ExNzJTZUJZUEZ4R0s4?=
 =?utf-8?B?TGJ0ZCs1MzV6NVZuZHM1d1RxbUtmZ2VoUlFOLzRGV3YzTHdSdWplUEJBTjJp?=
 =?utf-8?B?Wm5jSHdmMHhTZ3JtNVoya2s4UkdRN3FDMVo4RitwRlpaUTUrZ29aUW9kTWhL?=
 =?utf-8?B?V3FWRU91QXNiUkVWZFpocFM3azhBSnBEWkZVRVlsenpZU3o3cFV5TE14aVd3?=
 =?utf-8?B?K3J0NGxRUlUxYXVPWEZ4QVVJV0Yyb1dabWFoMDRwbklCNkhKR1JxaCszZy9u?=
 =?utf-8?B?RGVveUcwK2VERSt2VEEzeStseVoxV0xQVkxNK1g1aGg1Q3pxQmtsNms4eHpS?=
 =?utf-8?B?K0lhTklQYkxoV3dvNEM3dzlFWXNyTlhDdi9iY1NqSVpZdUZTNXZ4djRHNmtx?=
 =?utf-8?B?TTYvWVlyV2dvYXZxSFpYNlJDR29RcFExR2EvbHcrTVA4Sm9mUzM2M3FBUHZD?=
 =?utf-8?B?UWd1RDA5aWhzQ1RTcnV1Tkpnam5xRHNUdlp3dTlFQkVtYVArY2dPL24zRlJa?=
 =?utf-8?B?WmFQNVZRbzBrWE4xbmJ4OXBIS1pWeTBJTkQ3a0xGbzVteWxPZzcyWkw1cjZM?=
 =?utf-8?B?T1pLMGNKZm0weWU5Z3ZqOHdSNDNmS083L3BWczF5bEpjL3dLMzV0YWR2K3NU?=
 =?utf-8?B?amFDeGh2WGJXdzlmQUJReFl2QWpIbmtpSTl3NGNSbVRqclcwSXBxVjNjdWt2?=
 =?utf-8?B?ZVd6ZnBwNjVRTTNmNzZrOVMwQnM4M3d5bk9IMkgvdnF3RDRlSUxVRFh3WXR3?=
 =?utf-8?B?NHNra0QyUmVEZWNWVXpYMmFrTmZFWGZFVnRxY1JzbTEwUS9ZbjR1TEtiZHBK?=
 =?utf-8?B?Wlh2Q1ArRGNac3BOTGFROWd1U3BCSnZKS2FmVjFEc3VCbHpTOGJwU2swYkM2?=
 =?utf-8?B?M3IrekJpbkMrQ3YvWDNOVm5rNkZnb1M4UWhScXhocEgzampmWlVadGJGajFj?=
 =?utf-8?B?OUVER2djUDVpRjVDNkV5c05scmdYa0N6SXIwK3FiWUFCUFB6R2V3eTJOelJq?=
 =?utf-8?B?QUlQa0RoRjVOczloc2pSYnVNYjBNRUFSMWU3dWVBNzdzaDkrdXdNcGJpNi9Q?=
 =?utf-8?B?Mkd3U09jT1hYcFZaTXlRWk1NdlErYnc3YXE0K1dwaS9JY1VBck1PTTQrQWJy?=
 =?utf-8?B?cmtpSTdZUUc4cjVDNTFvT3h3VDJoMTdGbnR6QmZDb3I5RWx4M2t0NC8wQnY3?=
 =?utf-8?B?T1ZrQVBzUVVaQ3NVQjVGa0tjODg2ZkNoZlhXeHVFd0p2ZkQ4VDFNdVNqelpu?=
 =?utf-8?B?MmE4QXZUdndheEszdFRKYmp1QmljMjJ4U1dacDl3V0djTFFlM3RyV1NCdXh1?=
 =?utf-8?B?WW1TUnpRWjJsSTEvTXEzc2V1VXhiWVVNc2I2dXQ4bFZQNjArUk9TcnAvelpE?=
 =?utf-8?B?NlpDU3kxT0YzQUphcURLdndDa2JhbXZ6OGs0Zm1qZHlJTG92ZXNNZEpoMElx?=
 =?utf-8?B?MzVCZFdIbWtCS1B6SlJ5NTE4OGtlOE1MRGVuNU92VWFiODlXem9wTklYZW10?=
 =?utf-8?B?bGhjQjhxa3ByNWlKMTZsc01WcVgzZzJsN0pIUnF5S1hWWUl4dFYyNElIckF6?=
 =?utf-8?B?UmQwM0NteUVsOHQvRmNzMFRhMDljWjRsMC9ySG9tQjhxRzc4VU9QSFUrSlVB?=
 =?utf-8?B?Mlo4UDRsMGNwYWFqbllhNUNPbG1ISFF2UmlWU2xEM3N5aGY0eS9QZ2dkVHVn?=
 =?utf-8?B?dU1Mem1WWjloeVIzY3JZL0M3Sm5DcWYzTlR2QjNvbDFnd1FlZGI2RE9GWXVF?=
 =?utf-8?B?S0cyMTB0TTk1Yi8ybGlUQU9LZCtVTlk2SG1VdXhmNUpMbk4rTExVRUlNTTJD?=
 =?utf-8?Q?zxL6XRhFlUM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6054.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2s1VldsUmZLZDN3RVhKQUVuQTFJU3FDL2locjdmWVI3cGZKdEJRdTNVMWhy?=
 =?utf-8?B?U3NiekRKZVdXOE85ZFpRN3c1QWNjNFRCOTNrZm1VY2hld25qbzlLL3oyL3lG?=
 =?utf-8?B?eEVyZEoxYXdYYWlPd1lZYk5Nam9CT0JxbjlPaVFBL1lDczJVcUxFdVIwWkZW?=
 =?utf-8?B?cWlJVmloL0lidWl3Yld4WGVXSHdyU1RKQUZRU2pKalQxWTRlWXlXV2p6VWRB?=
 =?utf-8?B?dk5adWR5OExQMk1VdkltZDhHTWZSS2ljZjJ2WU5ZRnF6cFN2b1I4ODlXL3VR?=
 =?utf-8?B?anhOdmVvbnVRMy9KYkZIb2R0MFFyd2YveDFqQi9hUlZjQk9EN2ZleFd6MjhP?=
 =?utf-8?B?NnVJZGx1NEtUSDhqYnJJTGtNTFB6ZXVNditHVElJV3p0ZjJka1E0cnVMKzlr?=
 =?utf-8?B?VGtsNGxmckwyc05oMXo0TGs0c2FQTkZ4Wk5QR3dEREFtQXhTSzFRWmk5ZzVW?=
 =?utf-8?B?MXlXMXlMQm10allEQkVpQVpvbTcveUhBbFpqeUtSUTZOR2lBOHdHOGJBei92?=
 =?utf-8?B?VGpJRngwY1F5TGVuNnE4TFczdHdOQnhWdDlPQ2dnK0lBcHRDeFBGUGJRVTBr?=
 =?utf-8?B?TlVJbW50U3I3Sk9hRER1NTVhanJIbGdvZVdJZU02SXB3Y2FnY2d2d1kwakV1?=
 =?utf-8?B?bXgxa2puMTBXNERXaDJBK1UyeTR0OUJVNzlYVXVDTkUxajFVYm1WYzRHTzQ3?=
 =?utf-8?B?Z3ZNT1R4VUt0OERZZHZMeTNTVW91ZVVwaElGYXozYTY3T1BlV01MdlJxQ2NI?=
 =?utf-8?B?Y2dFWnNoeWZONmQvTFh0YVE0c1doRWxOT3JBMzFnVjVmYlZ5QUxOT3ZXcG5F?=
 =?utf-8?B?aXNVd3NTWi9iZFI2RVRhMElVTXM0V3VWSjczMXRJKytOK0kxbHlYdnR1alMz?=
 =?utf-8?B?bWswM2Y4T0xnWElSb053Q2trR0s3MEMrZktBTDNTaFprRkpER0lZOVh5bG9a?=
 =?utf-8?B?ZFNlOUFNWStLdzdpc1BQTjV3TGpjeW9ld3Z5VnloeUpyU2krNFhqUkVWUGVw?=
 =?utf-8?B?M21PUldIc0ZQVVZ5YnNobmM0dzNHckU1WkFlbHk2MUgrRjNaVGRlV1BVd25O?=
 =?utf-8?B?YjRRemdEWUhMeHdhUkZib0NXR1hlK1FJdzBwNWV4THZJdmpVQ2dOOVJ1Mng3?=
 =?utf-8?B?elBHZmQraDhlVHZ5MzNxcFZERWxUUDZkbVQwOVRjbUhRclVqd2VtU0pLU0hv?=
 =?utf-8?B?cTR2a1dOc1E2NmhGT3hvY1l3cG0zRDg0R1NBSmthRTBhTmc0RDJqcnR6bHZP?=
 =?utf-8?B?N1NyUnZsS1BmWEJkR2ZheWFXMThzdWVGMXRJVnVBdHJLNzJVdWY2MUFzQTlt?=
 =?utf-8?B?dUlyMnUvNFdteWs3UGZhM3Fza0JQSGE0VklwUldvd05tclo1NENpRXhBT1F3?=
 =?utf-8?B?OExqWFdZQ20reGY1Ym1COXBySitnT2tHU2lOY1BTR2NBQ0FON21mcUdQYStn?=
 =?utf-8?B?R1BWai9iVGpKTjBEWWo2aTBtOWwwVDVFcjZOV1pKeTYrU1FDVTYzdDhZcnc2?=
 =?utf-8?B?SjF5UTcrbnAvNGx3elYvV1oxMFhud082d0hlR0Fqb1ZKd01HSWpFM085dFY0?=
 =?utf-8?B?UGoxUy96Y1FSYWIwQUhDSHhrU0JDN1V6Y0xIajRPZWN2RmRucFFSRUdhajNw?=
 =?utf-8?B?SkNpMjgzOEF6dDlUNEV0OU1IM2hhWUhnTjE3TzdEenkrYmt0ZGVESlkyMXh4?=
 =?utf-8?B?cU0yUVZFOHZwaHJneFE4dG02b2QxZGRXNm5EOXFSL05aM2JvUHFrUXAyNjNY?=
 =?utf-8?B?K2JoLy9IMDI1ZlFlZU9MN3Q5SFFQenB2bVNTd29sM2swMDR3aTJLVjFvNDFu?=
 =?utf-8?B?NHRtREh1cUlUWHBBdHRhcGx0VUVFUEQ0V09TbjJSSTFiRi9MWC9ZTnRBa2JT?=
 =?utf-8?B?N01EbWFVb1lqV3M1UDc2OERUdW91WmxnTFhyclZkdUJTSVBVMFhmN3MzVm5a?=
 =?utf-8?B?TGY2eHVaWjdBaVE5TmdBSmFHWXJQZXlOMTczT0E2MVZ5Z3FhUnAwYW9qamNX?=
 =?utf-8?B?SUVHdGVCTTBrM25qOXNValhqWUJKK1VkN2QybUdPUkJ0L0NkYlhsWmRRN0s2?=
 =?utf-8?B?MmxZUDhCbXh4NXc0aG1IZW9SV0tqS001S29hUzVWM082SWVNQXNXd2k0WW4x?=
 =?utf-8?B?UndsRE9nWjJVVlNWQk5qbnUyYUppU3cySXRNZG01MVFNQWdkd2J5MHJTS1A4?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec841806-d325-48ae-ba7c-08dd818148b5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6054.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 09:37:22.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSpB7OlAjKYyQjj2+idc2eB+iPsKMkt8Nobd7OnjojHRp8KkehJ7CXUGoum11SOtRF9ku/HEE+l29lkCK8vUmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6004
X-OriginatorOrg: intel.com

On 22/04/25 11:13, Adrian Hunter wrote:
> On 19/04/25 04:12, Sean Christopherson wrote:
>> On Thu, Apr 17, 2025, Adrian Hunter wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
>>> which enables more efficient reclaim of private memory.
>>>
>>> Private memory is removed from MMU/TDP when guest_memfds are closed. If
>>> the HKID has not been released, the TDX VM is still in RUNNABLE state,
>>> so pages must be removed using "Dynamic Page Removal" procedure (refer
>>> TDX Module Base spec) which involves a number of steps:
>>> 	Block further address translation
>>> 	Exit each VCPU
>>> 	Clear Secure EPT entry
>>> 	Flush/write-back/invalidate relevant caches
>>>
>>> However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
>>> where all TDX VM pages are effectively unmapped, so pages can be reclaimed
>>> directly.
>>>
>>> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
>>> reclaim time.  For example:
>>>
>>> 	VCPUs	Size (GB)	Before (secs)	After (secs)
>>> 	 4	 18		  72		 24
>>> 	32	107		 517		134
>>> 	64	400		5539		467
>>>
>>> [Adrian: wrote commit message, added KVM_TDX_TERMINATE_VM documentation,
>>>  and moved cpus_read_lock() inside kvm->lock for consistency as reported
>>>  by lockdep]
>>
>> /facepalm
>>
>> I over-thought this.  We've had an long-standing battle with kvm_lock vs.
>> cpus_read_lock(), but this is kvm->lock, not kvm_lock.  /sigh
>>
>>> +static int tdx_terminate_vm(struct kvm *kvm)
>>> +{
>>> +	int r = 0;
>>> +
>>> +	guard(mutex)(&kvm->lock);
>>
>> With kvm->lock taken outside cpus_read_lock(), just handle KVM_TDX_TERMINATE_VM
>> in the switch statement, i.e. let tdx_vm_ioctl() deal with kvm->lock.
> 
> Ok, also cpus_read_lock() can go back where it was in __tdx_release_hkid().
> 
> But also in __tdx_release_hkid(), there is
> 
> 	if (KVM_BUG_ON(refcount_read(&kvm->users_count) && !terminate, kvm))
> 		return;
> 
> However, __tdx_td_init() calls tdx_mmu_release_hkid() on the
> error path so that is not correct.
> 

So it ends up like this:

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c..e5d4d9cf4cf2 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -214,6 +215,21 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+-------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 225a12e0d5d6..a2f973e1d75d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -939,6 +939,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..5161f6f891d7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -500,14 +500,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 */
 	mutex_lock(&tdx_lock);
 
-	/*
-	 * Releasing HKID is in vm_destroy().
-	 * After the above flushing vps, there should be no more vCPU
-	 * associations, as all vCPU fds have been released at this stage.
-	 */
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
-	if (err == TDX_FLUSHVP_NOT_DONE)
-		goto out;
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
@@ -515,6 +508,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -539,7 +533,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
@@ -1789,13 +1783,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		WARN_ON_ONCE(!kvm->vm_dead);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2790,6 +2784,20 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	if (!kvm_trylock_all_vcpus(kvm))
+		return -EBUSY;
+
+	kvm_vm_dead(kvm);
+
+	kvm_unlock_all_vcpus(kvm);
+
+	tdx_mmu_release_hkid(kvm);
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2817,6 +2825,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_TERMINATE_VM:
+		r = tdx_terminate_vm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;



Return-Path: <kvm+bounces-10758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CB486FB02
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E70C01C219C9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0D2168BA;
	Mon,  4 Mar 2024 07:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DBbS5FX6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B470716428;
	Mon,  4 Mar 2024 07:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709537989; cv=fail; b=fEMkjOitU5/XURIXOL440etKCdyu8wbstJf78PocSdcBuC6Uu0QVgjykf7khR/k9cMv5Z8EJM0CehRWF9SjobZ3qTTjTcOHpspkgpsxBR9b3d4x3+Ku55R7LmujjZR02u2WyDpPcVYeVPy4keI131XQVYVC75ro2U1ombfbF0Co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709537989; c=relaxed/simple;
	bh=YG3MGnPPh83p2bgFQhNDhk9Uc0fH2ePddh+mifzvH4o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GqGmqV0eIlVByrJCCqak6PrRYwb0dGdRTpm1QnAPjd9yOBlTse08439ZCyQ5iMe4bClXn3UDpvDtfxm7u3g6c+LfLdxp/L165GqpFikgM+ZEAtgQjEHhSrmfVFHTQjDctm6dcmqw9VipcEmM0NSif5jDwrtGwkwaJKv4oy6NJSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DBbS5FX6; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709537987; x=1741073987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YG3MGnPPh83p2bgFQhNDhk9Uc0fH2ePddh+mifzvH4o=;
  b=DBbS5FX6eVCDs7g3kn0Vh01kgQ9hMHn4HKYyuO9Hz3Qxna03BtGQzgyI
   gL0EWmgmphXGk2+hK8zc0QWh4kV89uhljCmlSIpCEEAXp70BYMT+l5V7B
   yciAPb2HmYOxSGOBmYKtELuCPKZx3ZU+HkYqKxPbC6Cp4OjiWL7QT5V/m
   hix8ZA/EJfLBvu7Q+kzaP/wffthxKt0ta2lFiXw6FSRVcCd5LehjGcGvr
   ONmSMZ0tmApMucCCNu9fbNdaKbWefWVOCbKCb6n/dBMPk8FGYNHL9NjtJ
   l+EObskTf2w1PUhNLfp+ErI7Jc8X1IFM4ifa1fZiU0tHN1aJBA9LbG5N0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4140089"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4140089"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 23:39:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="9093955"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2024 23:39:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 3 Mar 2024 23:39:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 3 Mar 2024 23:39:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 3 Mar 2024 23:39:44 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 3 Mar 2024 23:39:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btj8dVIM0aeBwsuNfw35A6Ffby16jI7p1Lb89mHuE8a0gxQe5k+hve3UU6JOcnil1WlXga+P6PDnafL+U+xqjPJWuOraU8OQ1XRtykTuXRinxdGpTINmQ9aQ5jTvdFe8p2ZRBoXG191GIEOWUxdjGmCngImE4tmQdNP7qmFQOothMmhLgFkFwsA7fg2MqpHyIm81I4RRDnKn6gv8CBO9hL7UMxT1Af6WI+Et5vbqRyWgYNPyPeXff458vxv4SlgPVothKLlSXNUKsV5xkdXUXcwdy+7mi4+MGufE4nbIH1fFHCTuXojtXeqRdPJlcIBEsa78m4Jsa8ieJdEegq2iaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOP2psft5Yyke5ogb6DHBqbcZG1FBDWJmz1jEinhLc4=;
 b=gVBT8yQ7OgjnoqNNItuFGex7lbRjlUJFxR04gaY9llUAd6eL2h8aYAUXtwwhXq0HfATMvF1jXaDJC5tC6WXgY+HrbCjpypwODQP0bxfREFiY2E3GlQ4/ssfn2/zz/ZoaZEwbMKMat/Igl0pthT6J5sJl4VROisSx2+vi+p0yF8KHhPN+mAQis7Cwy8owKmOAHSPds+845O0bJ02EIOIMktCso+fg27okLW2ZPgPTyEE4taf5OfNFeOjtPJe0IcTnJLXm6RVVpx9SqsFUzaZhbiSB2B0depzSg+wFuIkbsFucoRs8Fhi5DjeC33uol4fZ/eMbXT3X14nWS+T18kuvBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8659.namprd11.prod.outlook.com (2603:10b6:610:1cf::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.22; Mon, 4 Mar 2024 07:39:42 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::12da:5f9b:1b90:d23c]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::12da:5f9b:1b90:d23c%4]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 07:39:42 +0000
Message-ID: <e2e14cc2-50f9-408b-8b42-cd32eb9f4b5e@intel.com>
Date: Mon, 4 Mar 2024 15:39:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0208.apcprd06.prod.outlook.com
 (2603:1096:4:68::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e866ee-6a82-433b-aab6-08dc3c1e4135
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RbeYDx35N9PB7l2yn7vPJONCL8/W70B/MXwUxNrLNdFIpRMjD1IZZoCQ9e8sOeC+q38zXX+pkGNtu+NnCmM3tnLVnx2m7mXvYgurPmNJGmyQrct7IydieAirUMp0MMQt9SnQbeZeCe49Wy3/GuMYuz08EjcHnP6PrIpzlTIgRYsdTn1kkNaTNi/hSxg2qyuDFIlRwJU+aP/i9y03TnrkntXEjAOfRtDdvhoTfNTMRhao8vvK+l9df+debe83Q+TvTd9VSiQA0vrjqCkTmfWaUBV984zZiT+r+ocbMC3R/f4rJGfmKpIxTU3Uns/d3EszIYTqOE1yT6DC1hrTSzn7K9adkZNmeS/jcaSL7liqoO4HETHv2/ZX1NDNTBJ9WR5FHLqIII8yHk6uAXit9qD0rCgK5MZSgGJyRYM9gF7/TGd8Aog0clI16EGgOqF/UxwLua184OvV09MgrpnD30IEAQawZ81uwaFbkADdECDEq0EWL0ztTqOQklQWYV5aGFE1p/h17h9xEQ1ybyLapFRDDfloc7di0xBNYBxDQyVtJhDXfREIiSfO3W1ikauxCYhTno8TwbfvubLuwjc1DUJhLPwuKtu8gyb3769OypMsR9RITduDcU0btHZ8BEBQ8mhkZld24dhJpn3LJYMfw4trxL5x1hzxAc7d34P6j7nIO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2JzNlRVY0NGWkhUWU5QWDM4V3I5MGs4QVpLckQwaFJWSFRLVVhPZGtpNGR1?=
 =?utf-8?B?ZlZuLzR1ZFlwZkN5Z2dKczNKVFVJVFBFQ3BwdEFXNGg5NWxya2JNcUQwZWZF?=
 =?utf-8?B?MlB1K0grdHlxSUdiT2EycVZWTUZrNDFXNGp3UGxTemFORE8reUxWakdXVm1n?=
 =?utf-8?B?b2kwZTkyY2xSMjRrMmlzWVhvLzlWWXQ2N3VRV1dnL3htcW11NkppUDRiWVVZ?=
 =?utf-8?B?N0FIZU11dzA3RGFuNUtKaVAxbmFCSHNpWExKR2pwOVRsWHJjNlQ2eDhhWEFr?=
 =?utf-8?B?RndDR1huWWo0SzlRcmgvM2tpWlBqWUJFc2tnZEdwUlAvUUZNRXVoS3g4eUcv?=
 =?utf-8?B?emMvMDZRL1doL29XWHNBc2tnWmNCaHRKMkZjakpWdWpqYlhqdU91UHRZNkw0?=
 =?utf-8?B?Y3hqc2FwWFVLWnFrNTRkYlN1aytRVUtsNTdFMEtxa0dlV1FNS2RkbHlzb0JU?=
 =?utf-8?B?U0lZOEE4cUErU1NvZ1p6M0hnSkV1L0g5N2kxRFFoSmZubjlNeDEzbGM2MklM?=
 =?utf-8?B?QVlPbnAwUGk3bTdTdHpyOTlwUmRkRDhvSFY3Q2gvMHVCSVZuQWY0UlJ3enRp?=
 =?utf-8?B?T2ErMnZsa3pkUlNGbXJ1OUxFb2RBdXFmZlQrUndrRk9Gb1JoL0dxejB0UTFF?=
 =?utf-8?B?L2VuTHltQ2VyampTbC8rOXRDUWxBTjBZSjJaNTFNZitOUTdySzBjRXVDdE9k?=
 =?utf-8?B?WWdsZmFwb2RhK2Zkc1dWZXZ2Vmw0MnE0b3pNKzdONVZJdThDT0xHZnpDRlRR?=
 =?utf-8?B?amJDczIzQnpDdHNZV2E4SnRjZHZrY0dOeTRJZDZiS0xBSzdJQ2ZaTXBHbEtD?=
 =?utf-8?B?RWVFR1ljTnhIN1o5Wm1tY3hmbG9aa0liQkZ2QXJvWHFUeTN2OFFRTDVWdmU4?=
 =?utf-8?B?NDdwRDZmU2NlWnNJVDU3MHBTT2VWOHFwQUR4SVJya0xpcS9ac0dBejJkb2Vo?=
 =?utf-8?B?Yi9mMThUUWx0cHZnMm9vYmExZThESGk1eGhYaEcrY3lZNjhuSngyMm1BdnJR?=
 =?utf-8?B?bWVFKzkycDhSWG1pYU5ubnZLQlBBY3pLRkIxZnRLTDBETGx3UysxeWJjeVlw?=
 =?utf-8?B?eFpYbnZJOVErTmZhYU5WZlQyM1R1aHJFeUthZGs2UUR6TGcyMWlSZmdoMGRK?=
 =?utf-8?B?S1hLT1hDb09KNzlwLytUM09EYnd5YUoxL0dLcUtuOUR4NjNpYUd1eHgvaFpU?=
 =?utf-8?B?S09BckRSeUhNMkJxMng5NFdQVVpQa2UyNzVFWWcxNFZtbDlrTVN6USt0czRI?=
 =?utf-8?B?bVRZUmM4ZjIxUGFtaU40UDBWOWdNSU9RTVJEbFgybVpMWVd0bDh6OXhoWU1L?=
 =?utf-8?B?cG1Vb3VPbkNzS0ROdlQ4UzFyR0lDWm5PbFkzcW92eW84QVQ3QzhXSjd2SXhk?=
 =?utf-8?B?OFplaGN1UWJaVy9sTU9RcVlTVzFCSTk5U1ZKVjFxay9CZjlTSGVxbGJkdDdD?=
 =?utf-8?B?TDBCMjk0d2o5RUtPQ2I2WU0yREpYdTNPSGNNVFFGNnJBNGZFeTRqcUNJZFVt?=
 =?utf-8?B?bkE5ZHlLd0h5QkRzdHFac2p6QVZUYVp2TFUxSUxOU2RmM0p1a3lCMmxFbCsy?=
 =?utf-8?B?eTVMMjFURVovV21pNzFBV1FCV0tMRGkwYTFVWDdsM3l1NGUvam5ubXI1N0dC?=
 =?utf-8?B?cVArZkk2S1R2YUxGT2tSYlUrQXRrd2RXVStMbktmWEplVUYydnFVV09uUnpy?=
 =?utf-8?B?c1pXM2VuN3hxQ2VmMnFEWjJ1RDdCTVcza2t0UlN6dEZRY1FzWWlOSUV4bDY0?=
 =?utf-8?B?UXh3VFNVTnRjbVRqZ1d2MVZkTmNDU09Pc21aSHRSUXk3U1NGcXp5R0loczFv?=
 =?utf-8?B?L2tHU1YzcmlpVFNRMU05ak9PaFZzLzVzZkRTbktlcWszenV6eGVFNzlXbWpX?=
 =?utf-8?B?djJ6Q1NuNHovQXJkNEE1YnhMYXl6OFJna0FoTU9JYVBIaDJmbzNRL0h1Sngz?=
 =?utf-8?B?N0hjbVI3Q1lDeWNINm40MW90NWVyejRldlZ3TFp5c3I0OTl6U0NsV2VQZG5B?=
 =?utf-8?B?cUtabHFiMVJDWHdMSGpqVmdaZWtwMmRkekloZW1Sa05FWms0RFdjalJVQUV0?=
 =?utf-8?B?cWs4andsYlhlblhhY3lSdFRJbURTWTFoenRqb1BKUTRqUVMyaFVjZWpVZWVC?=
 =?utf-8?Q?/XAA9o1LidtfM1Cxl8X+i9Xfl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e866ee-6a82-433b-aab6-08dc3c1e4135
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 07:39:42.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpHarz6YLzcruLAjRlOVsTQDvu6mlyH0kajA82HHO8JDqsb7Jp4C/r7iP6tHR6XqZgN/GFXxKVmkzi+DbXQLNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8659
X-OriginatorOrg: intel.com



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On EPT violation, call a common function, __vmx_handle_ept_violation() to
> trigger x86 MMU code.  On EPT misconfiguration, exit to ring 3 with
> KVM_EXIT_UNKNOWN.  because EPT misconfiguration can't happen as MMIO is
> trigged by TDG.VP.VMCALL. No point to set a misconfiguration value for the

s/trigged/triggered

> fast path.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> v14 -> v15:
> - use PFERR_GUEST_ENC_MASK to tell the fault is private
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

duplicated SOB

> ---
>  arch/x86/kvm/vmx/common.h |  3 +++
>  arch/x86/kvm/vmx/tdx.c    | 49 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 632af7a76d0a..027aa4175d2c 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -87,6 +87,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
>  	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>  
> +	if (kvm_is_private_gpa(vcpu->kvm, gpa))
> +		error_code |= PFERR_GUEST_ENC_MASK;
> +
>  	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2f68e6f2b53a..0db80fa020d2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1285,6 +1285,51 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>  	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
>  }
>  
> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual;
> +
> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
> +		/*
> +		 * Always treat SEPT violations as write faults.  Ignore the
> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
> +		 * TD private pages are always RWX in the SEPT tables,
> +		 * i.e. they're always mapped writable.  Just as importantly,
> +		 * treating SEPT violations as write faults is necessary to
> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
> +		 * due to aliasing a single HPA to multiple GPAs.
> +		 */
> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
> +	} else {
> +		exit_qual = tdexit_exit_qual(vcpu);
> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> +			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
> +				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
> +			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
> +			vcpu->run->ex.exception = PF_VECTOR;
> +			vcpu->run->ex.error_code = exit_qual;
> +			return 0;
> +		}
> +	}
> +
> +	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
> +	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> +}
> +
> +static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
> +{
> +	WARN_ON_ONCE(1);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +	vcpu->run->internal.ndata = 2;
> +	vcpu->run->internal.data[0] = EXIT_REASON_EPT_MISCONFIG;
> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +
> +	return 0;
> +}
> +
>  int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  {
>  	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> @@ -1345,6 +1390,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
>  
>  	switch (exit_reason.basic) {
> +	case EXIT_REASON_EPT_VIOLATION:
> +		return tdx_handle_ept_violation(vcpu);
> +	case EXIT_REASON_EPT_MISCONFIG:
> +		return tdx_handle_ept_misconfig(vcpu);
>  	case EXIT_REASON_OTHER_SMI:
>  		/*
>  		 * If reach here, it's not a Machine Check System Management


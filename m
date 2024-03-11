Return-Path: <kvm+bounces-11601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4092878B7E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 127AEB20DD6
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EBD59B71;
	Mon, 11 Mar 2024 23:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1xoFpj4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9FC59B48;
	Mon, 11 Mar 2024 23:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710199615; cv=fail; b=r5A2d2T338+DxvVc7CLH14OueBdMN4309a2QgKU+ZfNoNFUOOjihf0LV2T9WXqUtAkNBYwaD2w3WNuHCFCGzFDX2ntiMpkzUqRB1gn8+1w8iAph5Y07o5rfpVzIxiaqXrt23xzZYH5BR5NoTV0N3OuoHMP+9CEjsrWemT6tzgTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710199615; c=relaxed/simple;
	bh=HZaN9D9pu7JkfWs/L9/ReRi5OVd+z/JBelkoOM8CBwM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MDGVKrOAPPxNgkK2Uuv4zd2yVaOqaDAvFUt6p5I57aBbDI90qVQ0MscxKAvvUquwUiUVjta4rZOj6yGtxnXxm+VohWnvQelJK3BxdOof1SM66y0275F8M41wwE8LsdbO/uflRiay2dkFQMdaoCboweXlpIRlN1vqmBM19Xes8t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1xoFpj4; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710199614; x=1741735614;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HZaN9D9pu7JkfWs/L9/ReRi5OVd+z/JBelkoOM8CBwM=;
  b=V1xoFpj43OvEB/J5FQp6V0L8clWFlJWG0TSA0uyysw7RKUokZe7NrY6P
   rSc2H3k5Tgh2Xid9za6ULvNoI9tYLHfY6SwY1Z8WpW1aVbeWp8eXZ66V+
   yyVdNb/9RMW0pVvED9HXp990eYx5CRmITmm5PCROl3Z2HL9KnqvN+Ta5h
   qOuy1d/JTyXuAwTV/L4AS2yHwdfOhHAhID0wvcOeOYS063CpUpNSrwDx0
   BOEN4Iyhcccvom1fBRbI+rELirf9QV4J34UVBVdNfAMLl3pTx1K+hDpMr
   i0uMNQYkzNbhPbJ5OBbFMYGHiJmuWMERQsha6m6YbOiif6b2rhH4M4IFh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4747768"
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="4747768"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 16:26:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="11917022"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 16:26:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 16:26:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 16:26:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 16:26:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8ZoHizqDWQbeSyRvny57gdNmF8epEYx29DF4+W45Pp9IR93PnDpcdXAhAm3VVKfOLAbfge6yHUxv2Rm9fonjWwF8sTTGoZ9y5khbk3Ig++/9dgeqnKNjHVN3pqGK/Up24M4BqkDmDcQhGn4Pqba/OxVVVVwR8H9XExC4LhEbiMpqlsvZa/Gqo5T0/6m8BeFMdcA0OHnhG9aJoAQ//tNWKkE+94Z5AFySwR1Oc0q4z2YokbtpD7P427X4B9K2bqIZ/FUGs/diXvaDAlANnoU7EkW6ckFqif5iO/kNoMzIi2O1ZAmvpoG/tTolvnLOTenHenEzOyKk3+7tu7eizIKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzfA+BRPmHj+qO7gyDrnuBV3rXjnaY7y+E8ywSMZ6rc=;
 b=mPWL0FJmLsJQ/ZqE4J5CsWlrOkWvdNytbDkiW0upUT80jXC8GP/SICYeQu6NUocNz7PREgRXqRHOJoblzyUSxqnjCaNjQ0S4OLpIt+/uu0hxeU3niivj8kHiKzskQuNMaPbE/fRrx7BbOJlK91Yi7rSv1vF5zNE9+oWJK8rwPWwfTtbROls6upfVWEsBlks1P8shvv/zZI4Nh8Gc187vwkLMMOLp3430LxOyGUL+sAR5uKNM4aNMd+xkfoN25lNfgwc0cfjVnIP7QK688b8NOsbIJZDEGxHWDVVGJMlaGVyM6qJfbXovbRgDsT56Qa+uDPoqvgRzvB0uRDyLxL9xIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Mon, 11 Mar
 2024 23:26:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Mon, 11 Mar 2024
 23:26:44 +0000
Message-ID: <cfcca607-c070-4bf8-82a9-d4f335d56a51@intel.com>
Date: Tue, 12 Mar 2024 12:26:35 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/21] KVM: x86/mmu: Allow non-zero value for non-present
 SPTE and removed SPTE
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, <michael.roth@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-5-pbonzini@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240227232100.478238-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:303:b9::29) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: def5ea16-e5ff-4f0d-5854-08dc4222b694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zx6eSsfIdBboxg8SCIyBWbFSaAczzmdRuK/gxHiT7N92WGVMc6kM3omzhEAPR6WUQiWcWbquV/CKmIbjyo1/N/DDcKofhJhs6VlVCeFTBngTkdszDIHNk8HEZZ2OGVKwr2rSlIHG4s1p/WHmbghi4w8FrvWdb9v4WjgtrZOGqJDVZHVU5uqejCtryCrUAUeBX0/gzgsHA9EL+a6xmqZH+74TZyoB1flaxKgyxeUnWt5C4VbLKU+ttWctDqg/eXZHcHaYg1RPUuFQvwgGNzPQlblN13vU6y5HctxMTrNLFtl2LegzMUjkP05OpDNpMkS64+1Hnlbra96mYb8c42e/Avxtao9Gfo2tMLSJ1hs++O4LR2W3hrBZ41pV6jaEEFwIJMmvf+q3rDXHSSefJm+C+dGSrfI0kqEuV+NT0VUSypPqn/Av+CwvrB3CJ2F5gDSWCigWrvebqcCCaY/rBpxkok61VeoUIzETGsMNaj8Ag7Mo4YcQU2YF2ItTjvGvUhPxaDY60rgCvaNoixeL8QlWLAB74F/vIW60Q/punxlXEEeopOe4sulYUhXwZlUIag5R3BogUa5Vq7tifdzqF+XzxvUPZ24mOLwIhXLbzXhf2q/1rzyAGNYtJp0MdhLC7A/KRz9giFpn5zyCYlRxCkfpgx8/v+uav98RbK/dKL+kyeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFgwV3JRMGhZV3c3cnhFeG9WMHA5WXBFWXRLK2pBOWU4MFZVT2h4TXN3ZmxN?=
 =?utf-8?B?UUZxbFpjTnRZc0tGU3VadnlXeWJoZHZHb3ZtVEJQdjg5amJIQUsrVmRKQnJy?=
 =?utf-8?B?bDh4RFpXUExJaVphUHVQclB6YzdhTFJjSzhCMjlaczNDZi9OWTkvS3hnbXdY?=
 =?utf-8?B?SWhXejRncWlDQzA1bFFEcUpacUZUcEtQMWF1TEh2UkYva09DWjVISnJhWVpB?=
 =?utf-8?B?SVFvTkJKRVdJK1Y2OHhvbEV6WmZaRFpwbENRV2pDSDZyRnR3eG1CRWF3RFFk?=
 =?utf-8?B?SVlrM2gxMmpIdjBrSFF2dDAzb0M0Sy9DWno4M0gybWh4aDR2QnNHVDYrTWI4?=
 =?utf-8?B?MVlpci9PdlBWcU01ZkNmUktIelFOdEUvYi9EbUk1WXdlR0g0bGw0bTBJY3do?=
 =?utf-8?B?RmtaUTY0UXE1bnJpblgzTmJVMXIySmczZUZuWFZqZlZZWjVRL2Vic0oxbjJz?=
 =?utf-8?B?ZzhpaHduSzBPVWtoZGpYdEszNFVoTXU3UE9QaE15WUFHVHl6c3RWVkhPRGpm?=
 =?utf-8?B?NTlQMDc4YUU2bExlaSs1cHZIMzd3dXZnYkk3anR4WHFOZTlFbnJROG5BM0Nr?=
 =?utf-8?B?ZjRBVEpVdnBqODJ4Tk0zQ2dCblVEYjkwUFFHUjEvOVhNUDhFdnNZYVdCaFp6?=
 =?utf-8?B?bnZrODJLWktUTXJFL1JudkZ6VDFEUzlWc2VYWkxWRXpGRk91dGRtYnh1TFN1?=
 =?utf-8?B?YXNpak0rRlhuM2I5QkpBQUYyRGs4bTQ2cU01VWR3Y0x0MytNeHZEczNNOHo4?=
 =?utf-8?B?aE1QT0VXdnF2RXYrc3pGb0V4SVl1SkxDbzMvanFUVHpwazN2TFRZY2owR2x5?=
 =?utf-8?B?RlJGZk56bVpKODVkbmZKaVFkdFFQZFZjZUptVDd1OHBZWGxOU3pxNU9vR1ZM?=
 =?utf-8?B?MWZYazM3YnV4aTJZdDNwTkpUQkxGeExhV0FmRldMOUxtb2d4OUIvV0Y1eW9j?=
 =?utf-8?B?Qm5uUHQ0OVZkRTAwUVRQWWNlNUhpYWZzcHJIdGpqamdaanRiNUovajBNTmpv?=
 =?utf-8?B?azg4UHhpK05TZExpQ2tybkUxM1NXVnk3d1BaYkJSbERWbFdBdmxETDVOdUN2?=
 =?utf-8?B?RkJFVjE3dWpXRVlUWjdaT3N6TWdoYUhoMXdQZUh5S2xwSC9BMXRWSmhvYUhz?=
 =?utf-8?B?Vi93V1J0c2Q3Z0tJTnpVQ0R2N2xsRFR5bTJzV01EQnMraGp5UmR0NDZBZzBx?=
 =?utf-8?B?MkNibHh6MVlFbGZMN2Zodkt1WHFmd0NwNHByTmtWR3BydWxqTHZvSk4yamRo?=
 =?utf-8?B?cDMzSXRYLzlia3ovdTcyQk0wMW5uaHY5Y0I2cWZ0VS9uT1FKTDMwL3VicmFO?=
 =?utf-8?B?ODJqYmdxSXdjdUZOc0l5dFB6cDhTTHpTaFNYMzd2R3M0Zy9FTlZHSUdPZksv?=
 =?utf-8?B?ZE1sK2xGTU5BNU9oTytJSFFPdEVSNDRwSDhwSmlpcnVVVk5NZ21JL2plQ2ZS?=
 =?utf-8?B?bXBMNTdkNzlSem1WTi9rSEZZSmF1TDZMRXNvY0JIRmQwOThPUFB0WmlZTUUr?=
 =?utf-8?B?ak9ETlBvMFg0N2tyT0trL1pDRGV3V1VyU1czK0hLSGdLMUt0a2s0N2didFg3?=
 =?utf-8?B?NXN0bFExR09Ca2M2c2d3bytNLzV5eDQ0RU9zUEtJWHJmOVE5blVrMkxDM21S?=
 =?utf-8?B?SWx2RUdxMnJHSXZ3a0wxMndrbXhVa01haUtHTmRqQUFsZGNxTXJhRmZhUzFw?=
 =?utf-8?B?Q2FiN2p0NDg0Tzc1SWZha216Nk1mcFZnODZnOWZSNlgxWk9FOUIwaE81L2Fh?=
 =?utf-8?B?QjduMlEvTFBMMFZLYVRhU3JLSjM0YkdTaUhMWkhDcGhPQ3YwRkRqMmxkeEZ3?=
 =?utf-8?B?cUdmQ1RhTEtpQTY4MDRLY25FSlNIbnhvOUZRc08wcVU1ektOOFNiWXNNOUh5?=
 =?utf-8?B?azlHUnRtdXhVQjJWVmV6YUowWHExVndxU2MyT3VORDZvbWcxUFo5SnhjVm5D?=
 =?utf-8?B?eVZpV0ZaMDBtUXZsaVhOVFdLZkwyb1liSHJhci9XWExHRytFNW1iUVc3SFlS?=
 =?utf-8?B?MitNVXNGZ2VRaVV2dEEvYTFJNUpLZVNncGlPU3lwOXcxUjZQTE8xMmRpREkz?=
 =?utf-8?B?eWliRXRueVlyTG1RVWZma1FhZ01qSlpVNFhwcGZ5ckRJZ09uVkk5WlZSMkQ1?=
 =?utf-8?Q?6+R+rf4dPcw6dTPACRAzS43Y8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: def5ea16-e5ff-4f0d-5854-08dc4222b694
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 23:26:44.1267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeP9PhZMu62RymtC4B3j4I25vxdOHGrsLbmtxOw3JiDjwYiVq2UvM6g9+d42ZKz6AK/PDBA3q2anhWj9I11O0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com


>   
> +/*
> + * Non-present SPTE value for both VMX and SVM for TDP MMU.

In the previous patch, SHADOW_NONPRESENT_VALUE is also used in the 
shadow MMU code.  So here when you change SHADOW_NONPRESENT_VALUE to a 
non-zero value, the "for TDP MMU" part doesn't stand.

I am wondering whether we can just avoid using SHADOW_NONPRESENT_VALUE 
in shadow MMU code in the previous patch, and state explicitly that we 
are only going to support TDP MMU for non-zero value for non-present SPTE?

> + * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
> + * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
> + *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
> + * For TDX:
> + *   TDX module sets EPT_VIOLATION_VE for Secure-EPT and conventional EPT
> + */
> +#ifdef CONFIG_X86_64
> +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> +#else
>   #define SHADOW_NONPRESENT_VALUE	0ULL
> +#endif
>   
>   extern u64 __read_mostly shadow_host_writable_mask;
>   extern u64 __read_mostly shadow_mmu_writable_mask;
> @@ -196,7 +209,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>    *
>    * Only used by the TDP MMU.
>    */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)

I kinda prefer moving this chunk to the previous patch, because the 
reason to have SHADOW_NONPRESENT_VALUE is to have a non-zero value for 
non-present SPTEs, which include the REMOVED_SPTE.

But just my 2cents.


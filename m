Return-Path: <kvm+bounces-11201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7780D8741EC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E52FC1F227CD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 21:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CEB1B593;
	Wed,  6 Mar 2024 21:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+X1Nq0H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993F175A5;
	Wed,  6 Mar 2024 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709760241; cv=fail; b=VXlEV90FBoAxRBuGsMz4DlW0gu5OEFovMRFZLbvx/jim+o9HhNjbNoufqA8lWlaN27SNr/oMu8fPzRUUgiFvTtoBKfhzAOt5WVPO1S8wpLCesoXPDxxFlIYfsCtAf5Oehz2IeOljT7Ugx6eAgdIc8KHhBmu9bn2Kykp/ofp3A4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709760241; c=relaxed/simple;
	bh=O6I33MiX9nc8dYgC9fSCircRcMtA59t1vfweSRwmexQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hFbHl+z1uoU13DiuZoMguskTB769YzqCvpyBPUE1wuGpFjeiwp5p08UzkuMdW2XVoOSEbltzFfy2xseKZLYq6C1b9+Zr2Cnu8FcmlRGhLI0IwDqdRGOuAKlUx17rBSf/vqA6h9YpFqXJEbi/FSrxbsn7/l1GtL0WwPvpSd36rL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+X1Nq0H; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709760239; x=1741296239;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O6I33MiX9nc8dYgC9fSCircRcMtA59t1vfweSRwmexQ=;
  b=i+X1Nq0H5u8oUnM/r6j3qgTcdgGn0feSy8ajur8D0fhWqV4VLAAUArwA
   6ocPuQExAP7BFx0WlKM+YMlPdzdidcHPO5DNHJEq3IUrA69uW8NBP+LeO
   DboZcq1wRhbVyatkVcRWQG7WByuXFT4hd6lf0ULN0pKae4Jil5+mVjmMr
   2jVy7QE3rzd8uMPP8CBLgMbP3zvKZAkZnakRHIQSv2zlt52BoIzBdUdEM
   GCEpx92L4NDiQn82FtnkrzO2hMyLbIJ63qyKinnUJeIde679am0SRHhue
   4xfa6Kq5AMcFK/XjrFEHDc1JaTiWJrDHazLLrCK5lNRz2CaoujX04BtTr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21853801"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="21853801"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 13:23:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14451560"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 13:23:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 13:23:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 13:23:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 13:23:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWsUZS95qDGcF5NUt/E3eF35njvPEeeMVD0ORM75im96/0Ia6Mv5BIwLW0qlcky3md5IzXAEnhOISUt+pYGQYNktnre6iTwerO73Ao/GPRewJTRmvbHX8X6+1OBuB9kWLXsFWCastlLVgmC3BrJpKMsnnMJRYTVUUeOfzysE0TGYUPbRzSTuMvI2PaTq4zxqlKwaDcbOeED+YuuEs1Y2fKbCzYWCRoG1ITI4iaPXjLUPobDLV4UnR8oQe0ujuHDVZLWt9eCNGl2oY3mrZlLBS7UiLYFykn8Z/ylAygWGLeoAbszLRuyFCzpTDpjFVMvejawGHEI46BLppsTOXLlkvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RGHJeC7aUwsqioxKzihc5aDQHTOuAoOOeBWmgfex0E=;
 b=OMx/pOgF9ztX1vgP1V5Lo4sBYCRpia+ogE6rDgy+qM/LXdLAcS/1XcBArQL/1cS2JPcXsWBRXOwV4v3yOjHqqaCyWDTAduOBeJL1othfo2h3zlckBUq3fsFqs232z+J4FVueqSTHKRk7ocl+IQOanFXQ3ZWxr3zJpq0Yvm2f0S1A2JQrLrtGz/G+ICLRI0L2seA84uACNkyq5EIgCM57sGM6WiTJwaexN5kOpKoKjL4tpBxGCtRB8jPmqfag22GX/0LksKi05TJEsEZIc6vOMgcafUxCWEb5GZt/0EQAlbcwFV8VpDf9xHb+oGAngPuDUI+CyA+4WwCkyF0BQtF20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7588.namprd11.prod.outlook.com (2603:10b6:510:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.21; Wed, 6 Mar
 2024 21:23:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 21:23:54 +0000
Message-ID: <0a8b2f97-47eb-481b-9373-2f39461713d7@intel.com>
Date: Thu, 7 Mar 2024 10:23:45 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 005/130] x86/virt/tdx: Export global metadata read
 infrastructure
To: Yi Sun <yi.sun@linux.intel.com>, <isaku.yamahata@intel.com>,
	<yi.sun@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>
 <Zegx6R4W3lVd+5tx@ysun46-mobl.sh.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zegx6R4W3lVd+5tx@ysun46-mobl.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::11) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ffe198-f815-45d5-bd29-08dc3e23b9cb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6Ne8aoy6AVmlH73ekMTzRi4rbHUCVFt1oEeLEPUwcqYKeabnK+AXdY2+++th9JI6zI00oxNblNylX/3AXItZcpUbf/2mk9YKKsMv7uqxBywliK3M89iNaAGO4CUwA0r965EJbDdYGwZGTEgIWB5ByGtc224CYvCfIGJbWNnpdwtFE8dnk7ouB08F8e6ewnoRXUUJa2ZzIkIXLzbh/bLjTVwK6PaOcp1O2MsoXAtaOM3Wu0BVQM39VdzYhTBXzXMP2EwAy74HG+vwZB74AX08/QrNXH1eYsutpTafbajbj//09RRyL4otGlH7jJgiqarJfMFgqSHlRXIXm9bEmfR9TYJS0T4Q1ToCeBLBgLuug/V1MdOTWNju4fR5zjhu4ar2AJYVLIlA51EQss+x7/3jUBqx5pNcbXqJyF0IMRZnNeWNxIKubwXZLH3GKt+CR4q+IoSz7s0zxPtG3FmDzk7zpyRQrnVvd5fgePjPOYSNEH0//G2lLN7zInKKuAFAh3mjEA1MpE9Fluhz6dz2CdDTxu6g1PPS1kGxd8dZCwAeyjCGjKDAqUHr41eg6Gl2Cww3nZFwngrZaLjrm0XfFtOlK5SdrbMjGnQZUW9QnC3hsZjS99UgF6cp2J0YYSj+9SXaKcFS3jPFbBLbvfkKjq5WjBlVrYOGp8xCBLSd0P1Sxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnVBT2hFUHFaQ0lWNktkOGJnS2szdDRsQjVPbE1MUWtQWXZBN3AxbWR1R0h0?=
 =?utf-8?B?SG5RbUJXS3dzaG9MR2E3b3lBbC9CaWNhV1l4WXN6Y1lmb3ptekkxY1RPcTRl?=
 =?utf-8?B?M3hHbEpPQi9rR3ZGQ3pqaW0zRWxRVS9BOHpObmtLMXBEVTJNSktuZEEwVjd0?=
 =?utf-8?B?aWhNMlcrLzZUVGdYU2JnWUtpYzBMN0NlVnFhR1hkMDVOc2VCMHhxamliVC92?=
 =?utf-8?B?RUFaSW9KbHBTU0wrQ0Z2VlJHeVNaMHBpNjV6TjFhbUt1aTZvSjc3UTQxTVBk?=
 =?utf-8?B?UXNPOEttNlNMMHcxY3o2NTVnV2NvK0xrSW1mdVpqMlVPUFdyeWprc1d1Q0dp?=
 =?utf-8?B?TWRQUmI4RTRXSlRNd1VGTi9aUU92YUM4a1FmSGhCaDE4cXB1RDJyeTg5djFY?=
 =?utf-8?B?dVlHelIwN3JvdXF3MTBhUmhJWDdsT2NsNUJpV2RvcEpFakF2R3dzcGpSZldM?=
 =?utf-8?B?NERaRDRvcFc3OVJjdTNoUjZCTHVNVzBEQjArMXVoTldkam1taFZvc3NrNkFF?=
 =?utf-8?B?dHlHL3RRd1grWHlkOG1QM0d2bmVpbjlXcXpxclZqSzVTMGgrQ3pCSkZ5T29N?=
 =?utf-8?B?dkpHZzVrLy9LV3BpQUxaNUpCYmRVQjEva3RZaXJ2Z2VHQ00vRXR5WVIrbkdT?=
 =?utf-8?B?MUo4UUgyYW1IRE5NVEdBRytaanhKcmYyNi9KRU4vbVhWK1BJM0kzL09LM09F?=
 =?utf-8?B?eWdBV2IrUFhFak5oYis4MU9DcU5XM1NGeTFySkZGZTdoWTJGOENMZ2x1V0hk?=
 =?utf-8?B?T0M4S2R4S2l2YUZQTmdUN0RtdEFyM3FkYitSNk9TUVNpQjgrd09YUlYyZ3lu?=
 =?utf-8?B?YVl5c3FZMWJoNEZHK1dXQzZFbkd3MUptaE9GajI2RzlxNVE5S2JmOC9OcXlG?=
 =?utf-8?B?S3kwcjh5eDA1d1Y1eUVId28rR3dxU3NuNkxFYkxsVFpnYk0rUlNpNUYvb29E?=
 =?utf-8?B?c1o0V2x6MTBPUFc1MjNPSG85S3NQNzFzcnFVU3dBNVd6bUVqL2JpVHF4NVpz?=
 =?utf-8?B?RkJXbjUyQTdvTmhLbUQyRDhEemV4MlNrSXorcWhoQUNOWFlKNytsZG0wY2FL?=
 =?utf-8?B?cWErZFRxSm5mdmtMMUljWk9vV0tsQVAzdzhla0NCd2dXcHhwK2orR3ppcVBi?=
 =?utf-8?B?RkJKcFA5aGlYK2lFZHFYZlFVSG9WTjNlWkcveERFczhnQWpnSmUwZm5zc2x6?=
 =?utf-8?B?TXZ0eXdxRGp1eFpIQkZmbGF0d3hJWmVOVE1QM1FYMVlPL3gxb3RycVQ0Y0FB?=
 =?utf-8?B?TXRDa3FYZVAvSVN1NmlVR3cxS3VTSWdwOGtVQUYxWVM4M1VtL3BaL3FVeUg4?=
 =?utf-8?B?enE2MmFXNG5CWVZobHpRcHFWUGJNc3hBZXR1KzA2TzhKcEtkbllOZmRjM21R?=
 =?utf-8?B?TXp5ZC80OWdWd1BaNXBBWG03NzF6R0dsaURHQXJpVjE3Yi9aeWp2TXlOeDJ6?=
 =?utf-8?B?Mjk1b3dHYm9UNlpuNlRQV2d3ZXVhOXlDbUNzQnhodWJnbHBHUWQ0QVJPRWlV?=
 =?utf-8?B?anFMSzNmT01ENC92OGcyMzV0SVJUa0s0UXQvZlRYYi93UkxuY2huZmtBcXlK?=
 =?utf-8?B?enB6TVA3Nkp3QXd1UEE4alR5K2xUVGhXdDgwR3ZLQVh5YkhoZVMzWlVHQTZi?=
 =?utf-8?B?THErQ0lWWWgrUENlZlJXTXJ2RXNMRGFBRDlVVHhBaTRRSkRkTDVid3pnakkr?=
 =?utf-8?B?dURCVG84MWZkaEFHaFdtTzl0NXZUMmc0NVRReHk3MDRzd3RIcFJ1L0Vrd01n?=
 =?utf-8?B?YUFMRVJSVlBSdmI3MFY3VG41b2JpcWgyV290Q3JXeHBnWGJzTUovV0RtZXl5?=
 =?utf-8?B?elhUenFLaXljdUVGSjM5djhlc2liNXY5SGJWUDNoblI2Y2JkeFVDUVdOOWFS?=
 =?utf-8?B?SXJZbEhrOWFJRGdkazFXNklJd1lQdXBsQmtDdTRhVzBGSVQ5VHUzUS9uanBD?=
 =?utf-8?B?OCtIZzJCV1Iranpyck1HZUlMTlR3WlcxYnh3L1YxSzZORWxoeWZtSkFEUlFD?=
 =?utf-8?B?K2xXWldrSkUyZThrYTViWXAvTVpXQmFlME9XN095R0ZVRmEwRHhpZVR4a3lu?=
 =?utf-8?B?WDYrMmlFU0kvRHRDakNkRUtqbDUvQ3dxakhXSm1QcWg3NGU5VGJTM09aOVVz?=
 =?utf-8?Q?6YEV62mL8KzNUGv++lIMNMhum?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ffe198-f815-45d5-bd29-08dc3e23b9cb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 21:23:54.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pA+MwAaFxmuckb3QKCt58F/VR6MJADRn3o1H9Zr9V+DSh64zi9lN3EjIx9c4F8cOBS+ASs7Zy2MAQlpZLW3lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7588
X-OriginatorOrg: intel.com


> 
> However, the function cannot be compiled if its definition remains in the
> vmx/tdx/tdx.c file while disabling the CONFIG_TDX_HOST.
> 
> It would be better to move the definition to a shared location,
> allowing the host and guest to share the same code.
> 

No not in this series.  Such change needs to be in your series.

Thanks,
-Kai


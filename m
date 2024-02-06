Return-Path: <kvm+bounces-8157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2DEF84BF67
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA2A6288F74
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BA11BC41;
	Tue,  6 Feb 2024 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M2OkrOpw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64E91C68A;
	Tue,  6 Feb 2024 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255896; cv=fail; b=rbXvnqpoXceSsDaXXdUwC36++gWfGw+61FZOcxpGIFID6VtcioEaY3OTRyAyJYYXxaMmf+yNJo9tdR/CRvo0Nst/+dBsnjBYPOFQe/UlPYskh2WpEiv7C6t5qnxEDDzMdeHv8Be4qoRhYfOnwq3719sB2EGqdRWvgCVDmWRqJ1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255896; c=relaxed/simple;
	bh=W6U7nFcP1bObGkwm6Fmz3nNNovE+YJqYTXY6KsBGkKA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MBT2Qm0Rs7zIlsu/McgKocGU8SC9cEGJlbXFXnqae7lEJ2KV8qteSsSZdROVs2Yjlb2JFUJXyygm3nx8UkrFYFIzqJQv3f/2d7ftmkpYKTvKS821oDK0SiF04QGCVayPY5nouxP77qf8xsSYkQRIcWbyrtUNh8N+Czhw/LbiepY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M2OkrOpw; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707255895; x=1738791895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W6U7nFcP1bObGkwm6Fmz3nNNovE+YJqYTXY6KsBGkKA=;
  b=M2OkrOpwSnN9nDFD6tmydysmVPV0FBhVyQTzKq+eb/MtLadL7J7ABlOK
   bcK3Vu/EqvrUJ6zyHQUaCDWBito4w/GQmjm6kWJUueA5JcvCCvHoL7JMx
   mEhOyvu2BC9pqbtVYL2yp8jkgDI4JYWy1S0jq1U8rsGdw2ZNsW+eNIUX8
   sfHN4I6La+s7YTV/4dAu7FqKV60aoJN9XTyCpPoDQqOszCq6PeUm7AmZx
   /5+1qEDGuzLYSTOLhgj4CKid57I+oM6BMMv93HY/QHEShfq6c2Joc/GDv
   1g2JF5Ojvuc35Essw3IycBLk8tVpWFxtOE1qyl4P/DLnF8WPLrrwXX1si
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11492818"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11492818"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="24387333"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:44:54 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:44:51 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYHPwGM2iAUt4aINlGpUFZ7b/nds16nbSJqh3jHgcKjccPD9UBmF2maZc8rODTyS2pcZ60FBKpLw8bMF++L2rbpFmeHeOGH7mV/wBkwuK8u4z2rKAEtCpQeBd8D+Gs9MbJTxAl0KFdINSsmc1qhDxt1EzvtdyGSdcW/HP3ne1WP/nelq8Cr6BrIAUVnTbp+I8vcs3PEoIPdVG+rjz5deOGbf1MAEa8W+GnaCkW+NIiqp5scP+yJ6Cm5Tz8xyQRi55RQJ5AkAI/t28zDfGSKzXHosu77xgxqT1gIG9mOwWDNrDtQXJ8ZinzyzYUPZWgfbmiVKfA51Dc2+pTis/ObXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j13oytidgim0EgON3hViyYay1aVjSYIhaQuH389X1Bw=;
 b=jkINvXMHar9M8SyBbOBYct1++vnurnwRci6wrUkofmxtvzvr9qU0tJlwsizflf3eoQVhBhQLx4/VDU0GlCVu3oLISrMqnOEtobr7g3/svZvq7O/6G5GXodcpgLNto4aE01xtfEbGbxNitaq0uTCvPa3WQqPpvZW/4Xzl0OuKTkdhnEtYdVdhhpon4C+SsSsTrp8RYTC2d9+AIFs1OMl3uWNX2QXCS0z5QYnZ4535PCk0AWNrU5kD4SMHswuxtwKDs4U9Z6Cj0pxCFFzUNGfIK7BTm30z+RSysXPNEchsdhZNPGej3F+0no5dSE0j8o6XiPexO3ggJ0G7imFsdrkqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7367.namprd11.prod.outlook.com (2603:10b6:208:421::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 21:44:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:44:45 +0000
Message-ID: <47d130f2-7d86-4d08-98f9-186d38ecbdbd@intel.com>
Date: Tue, 6 Feb 2024 13:44:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/17] vfio/pci: Remove interrupt index interpretation
 from wrappers
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <ca249ad459c07a36cd64137ee1cc107dcd8b6f4c.1706849424.git.reinette.chatre@intel.com>
 <20240205153502.051ff2bf.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153502.051ff2bf.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: 87c81db4-5dc5-48a5-d6c9-08dc275cd563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmpLTz89bfXlYrfsb14177PtnNJxKbHfMq4Fp5IN+s586DlE1WoCh9WuVQNRFZRcpq7Rar9pE5yTosTd8Ai3qrQwjVBU1HIBe+77nsm1lk5G1zofETBPT4GMVn9iFY9Hus7QqePGtpEyindPw71zTVq5+lEQI/in4w+FPfjlkN+b5ZHMXBzPD+cXTiiXo88GQ4u7TiRqkCCTpThoMZ78ZSgItjRT2epau12jgOGnXkkI5KTWBhRCBxgp/a0B/Fp6O9sMuW74YIcLPYmYQJEg/n8vxgvbGjhn/TGfunIEDmLNCwLkIhM82Ub68tYtuLdhNaNqW18QCpTTD0ipnuNneTZg+9f6dRndHRn3kWQtZY+CMbqNB2r7Knq4GGEI3btj8bxgCmIonrNgOh2R/QavjRPS/o9K5d/K+t/kQivxGEqoZD83+i1rjFjJtDQqfSgPsSupTvGnWU0T6NCgFcm/5C8I+C6/WOAaBF8lv+eGbEugQA1omK3joQUQEsPv2CUkC1rKU1Xcvw+KWr/nYt8z8fPtRM0CTfCuarx/HHV9MU33x4Y6llLQggjxw/2nvhQiKVdVFKkY85IQcmgW4qbel/sVAZc/Kml467p4zO9HHSOR3bNpW1bnr097oNkyNLhzHyRpXlBc5nQACiO0rCm0TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(366004)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(36756003)(41300700001)(31686004)(66476007)(4326008)(8676002)(316002)(66556008)(6916009)(66946007)(86362001)(5660300002)(8936002)(478600001)(6486002)(82960400001)(44832011)(6506007)(4744005)(2906002)(31696002)(53546011)(38100700002)(26005)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlZLT2ZNZUkxbDFXcmVqRCtmNXM3S0dmdWNUeHhFZ21zUHhnSWtBTTdLaEtB?=
 =?utf-8?B?d3I1VXJRU0tneFEzTXBTeXFDdk9hTVRMZTVoSVQwaXZHUkVaVWx1VXZIVzVJ?=
 =?utf-8?B?alRBL2Y5RU4yN0F3ZXdjSHU2dEUvaVJQaE8xV2xIcTFFd0hOVlQ5MnhqR09r?=
 =?utf-8?B?UFhvNEtVQnRLcHY3c1Vna1d2aG5KYlJ1T0g5NHlseEEwb0I3eTZkUmJ2SmZv?=
 =?utf-8?B?dmZUOUxYS2k3Wjc1eEJsQTcxcDJVWXR3SStjcGRkNHhRaExpQXlERTVXWWtC?=
 =?utf-8?B?Q3pFRC9IdmpURFRpSG9EZXpBRTJ1KzlSMHhBaW4vcXV1RjFlcVd5QlkyaGVM?=
 =?utf-8?B?S2pRSzVFbHhIMzUwN2Y1R1M3Z3VQSTk1Vk9XNDlZazRSeUtxRFFHaE83TkIx?=
 =?utf-8?B?LzF1WFRXd21IaWl4MG1kRW10MTlhTkFvVGFCWVF3MHRqZ2o1Zy9qZ2hNKzMx?=
 =?utf-8?B?c3NuSk0weFBsK2VQcEZnSnNrUnE0QlpBekVpS01kUTN0LzJ2bmRjMGVjVWky?=
 =?utf-8?B?dC9uWnk1bW4vS3NGQzRiU0h0eEcyeUZKVTBvSGZTMTMxSkM0TGVtakkxR2JC?=
 =?utf-8?B?ZEZnWVFnR0FZRzBZV2hTOXJKSHpHZklGUmIrQTc5TDhMVzVkQmQxZW1BZE9B?=
 =?utf-8?B?WFV6YlZjUFNwRFpscTI4c2pxZzl6RkNIcnRVTnZQTXBUdElKeVFhbnRKdFl6?=
 =?utf-8?B?VjFyMGp1SkQ3cS83alRrdDhpVXA0bjYveVFyMVg2dVB3WFM5YXpJTXh0OThx?=
 =?utf-8?B?QjVQZy8xbFdDR2Z4bWczVkQ4Q0NtcVlDcjdNUlRoeEV4cTE1U0VXdmxzTzVy?=
 =?utf-8?B?MGFlaFZxTmtaZ2s0enJ3NGd2YXBHQWxLWVNVQ1hhVTVNUlZEc3d1ZkZzTU5x?=
 =?utf-8?B?WWNod2dFTXNFc3Q2S3YvdkV2SDZDbnpDY25HWU5UTTZGVXBldStLSjlvRVVP?=
 =?utf-8?B?cU90RERwYW5Jc0tzYVFick1PVU1WQ2hoRUZ0bFRIVkFNVXpXdXRNN0NOU1Bw?=
 =?utf-8?B?NGVxMFFGT29UZ3Y3TEJBSUZpcXFsTmNnT1JrYkhEMjRoSDZnLyswSTg3c2tZ?=
 =?utf-8?B?TGtQSkl4V2MzOTBPbENGM2VNYmprVEhUdkZ6ZUJqakFscmhmOUlrMFlpcHhp?=
 =?utf-8?B?MkpGVWJHck1JMkFSb0Fieis5VHNsRGVsWW01dFphWi85RWNkV2FySEZmWG1i?=
 =?utf-8?B?ZE1LSi9IVm1FdE1RQjZKZEIvZS9FRFB0U0VWYWVaZTU2eGtyOTFNSjdjZ3Jw?=
 =?utf-8?B?L2JoMFUyMVBHdzdVTEVDeE4xRDEvY0Q5aklqdGlpK1lsTE1laEMwTXhOL2V1?=
 =?utf-8?B?SDZ1YUlaYkxSMnVaNWhUVTRqRUVKRTA0MnFIR3V4T3pFQk05dkdKYndRbmor?=
 =?utf-8?B?OHNqdzlHaURnV3F2azVqblc2RXdMQzFLWlR2eUg4Y1RwVHVFUmc2dGl2Q0dG?=
 =?utf-8?B?STBpajZCVS9lam9ORlhnWXpWZXVNanB6TGk2QjVpOVVNRTV1Yy8vRndJbUlL?=
 =?utf-8?B?WVIzQjd3UGJaQWxxeVdsNS96QnRFbXlkRThVNDlWUURmS1JTRUtZRkhLeTVZ?=
 =?utf-8?B?bzAvbFg1UElDVU42TXFSMWkvcU92bWo1M1dpUzRTOW9GclorcHllNFR2TUly?=
 =?utf-8?B?MUJGdk4xWDlXQmFiQUgvWTJyR3dkQUJMUU00UVhvTFJPaW9taGpCTGFMaWtl?=
 =?utf-8?B?SXBzNDJYSGJ6SE84UXdKQWtKQzJENHVTV2tDcFJhU1R3SktEcHpiM0Fuc2VR?=
 =?utf-8?B?ckY5OGRaNitEN0s0Q1QvOGkrbEJQMHVDYS9tUWhzdjU1ZU9lRlZLVjVqOWRQ?=
 =?utf-8?B?RWNoYWxVTE05UCtPOWdudzRVWWhva1NtZGFxZ1VUUXlGUWd0THpNL0M5Y011?=
 =?utf-8?B?dzdncGpkU0JUbkplZEw1akhkQVpDSG9uaUZhN1RrYmlkc3oyRlhOVlA0a0VM?=
 =?utf-8?B?aGNWRTljOVBEYjVSUFBRa3dscmVSeEJ0aVVCeG5oM2NpZTduU1RBcE8yek5r?=
 =?utf-8?B?SlFhR3pLZGpXaXlZQWhUME9QeE81bnlJbFp5c2hlbndEVlZuTWVySmQ1VjNU?=
 =?utf-8?B?dkxlN1pCODNyMVlTZm5PSUJBVTcxaDlZTWhEanZmM2gzSlA0Umtmdm9INDRa?=
 =?utf-8?B?QWRGMmViVmVCaVBUWjlSZU8vRHpYdE5sUmp2MVFuN1RvbWp4VTVHWmxOSUQ5?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c81db4-5dc5-48a5-d6c9-08dc275cd563
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:44:45.1346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCfvLwv9DZle/jdvaahCBo3cGYHcQZRfnnvJ4loFcnYRRkhwDxyEb0H56XBmbna73utWQ0Rb/EFl3SBvHIm4Ll6TSfcaP6RmxGbWcmq9m0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7367
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:35 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:57:00 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:

>> @@ -413,8 +415,10 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
>>  }
>>  
>>  static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>> -				      unsigned int vector, int fd, bool msix)
>> +				      unsigned int vector, int fd,
>> +				      unsigned int index)
>>  {
>> +	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
> 
> Cleanup the unnecessary ternary while here, this can just be:
> 
> 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX);
> 

Will do. Thank you.

Reinette


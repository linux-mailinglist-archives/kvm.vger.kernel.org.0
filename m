Return-Path: <kvm+bounces-8289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D7284D694
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 00:30:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57E321F245EA
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 23:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2865535A4;
	Wed,  7 Feb 2024 23:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OpOs2HPC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF120325;
	Wed,  7 Feb 2024 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707348626; cv=fail; b=bbv5CdS8m3+aE28LovtCJN3XCTB7wzqOJJSVUWqgp91SrEnAWnm3WXIHetVTuvUiARPqiC1f4n1nKHK5l2fd+X8O0kMh/ROEEgRc/rzsPGGgqEEYPEC6VaGNbSHE2em0Tt/OV1zaswYG3xx9nt51zxNUovJReTB5ODQpJQS+Ewc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707348626; c=relaxed/simple;
	bh=iC/JKWZde5jNpSSQ/DuorWBJPij+hNrl3B7z/HQa7J4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tMWu+5vVjdRB5bZ6w4i1Q8Z8KDza4FbRGXWhmEqdq+/64+Bo7LJmhjjs6zMCTFfCm3yGjkDXYIAl91+Q1cmOILQfHkir7idiAQpSyZiPQRuQHO+gp2EOyNOvn8OBrNP5ijbUsV1oaQywgXO90NvqhYaktoE8cPN8gaj6V+ywTmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OpOs2HPC; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707348624; x=1738884624;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iC/JKWZde5jNpSSQ/DuorWBJPij+hNrl3B7z/HQa7J4=;
  b=OpOs2HPCZhWMmg4MRs0yq5Wx3RXm6JNpZ7Qi5OxtdK1hsNR3ykxXMXc1
   1A0m9iPZX5GG/CEAByHK2nZsWLY5HZuilH3vpHvP3GAhrxxKwu5G6tPFH
   lkR0x7R9kcCzoA+Lbwm/kjKbGM6ixpVgZE9fTVSF9rO7gtVRdnukkDmPo
   4GvK3W/RkDgZ6O5KfKC9lmog2GknbLOSv4YLaiNeMs8+RpSvgZexuFn69
   MPXIM2tRBv1qU24VPnthdm7oTUw5aCocpPPOtv1Egcnlrt5XOo/hbIL38
   G9QTfGO/itxFranAzBxr3XlsKG4QHzQVmpBHC3DnH6BrZuFPb8WtVKAus
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="977407"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="977407"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 15:30:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="910149758"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="910149758"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 15:30:22 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 15:30:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 15:30:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 15:30:21 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 15:30:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yvoq+s+DdUo91rvHRpcGsBCyLUQexZHnacsu+sYdYooGqd2yyyROof7uCS8wXlqg8rukT+aVEFGmY9WuJIQorzcv7BqSFS3rq6U00IhDyKMOHUIld5kzeKlAhm5Rkfxmc8veg5A7GDJk3iGsllhSeb2vXRlfPEP0XNJTX9HvPim8esgnmaMv9100GZt6dNL9Ra3hCf28UVVicSjDBKy9kPUUdt6rK8Epo/XUysH/fluUEgL0l73GlvUHL31aMW07g3wQpvZv/TUfvA2ZBaInTwn/4iJJb9+BdoD8HVyJz5Zplpa5EjXnr3OZbtO6E6Hp6lEt/sTJdGmY57iEVbYqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVH6b2Yil7UlR7HAOnov10It3tT84Jue2/etDwxrlNc=;
 b=W/pL9h9wt5blD93tdihQymDo8a3rrrKtaqeAbOi9kpE6TjTyxhjtymMXVXqx8JPYhPcrKeyYFTnLpLQpblY6fNafl7AbH0VFxDdFehoaqGez9T7mudxMarJJTe0jQwdQujmS/7d7JGOxKXLJ+KbkctFEuzXLjOi9KbcKGb2k9pSpDxn3Dp4pOnbe40b3/HKCUGEwlgmpUBgAL4pEBWwnwLKSKHr0ifclCCW0cifoS7noXYsCami+QWZwpwJ9hY54+vr+jeoKmLy+JYpMKpPsWkXjamzgUXTWsw/8WLbMdPA81SwVe2lTQuPg78c4LVQzuzBeGCJNwhhZtv0ilcRrxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38; Wed, 7 Feb
 2024 23:30:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Wed, 7 Feb 2024
 23:30:18 +0000
Message-ID: <63ba0079-a035-4595-a40e-8c063b4a59eb@intel.com>
Date: Wed, 7 Feb 2024 15:30:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types
 use same signature
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
 <20240205153542.0883e2ff.alex.williamson@redhat.com>
 <5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
 <20240206150341.798bb9fe.alex.williamson@redhat.com>
 <ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
 <20240206161934.684237d3.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240206161934.684237d3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:907::36)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM8PR11MB5591:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cbf374d-9160-4a47-4e2d-08dc2834beda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1C8SXAggzM0kZfeJ04TFo+1HOeVfVG3cD6mdSfqPqsDJqOm8tX6kc3eurx7cOFi2y0Yw1Ir/kEgxQn4NiliqrxwLqLoN0d5BpdB5Sl2lYjGw9BC3HU8PtEAV9E5/0lRZ3AxP3CCSxQg+WpqNN+9zj5wKSeyw+i6q/F1OZ2njfx4F3RIVlazWffOSrKy24QcKf2VINHXznrHA7KlDa7ldpT6cmoGsidYV6Z8G7TBhLLn8EV7zPaviE9wtTwkmQua0CMYWJDsdNKBdpNMm6luuaN+OoJ1ttpybobxCOh4QV8Fx7qGGFLW0NA31CeORp/9pB2Y2stKZW6tnp2UxKj9pcXRIUYVP+tlW4mtjVeQnb/nNWDleCGlMzl1z/xkAU9M0l1S1xBj/GeWyZCmIbd8oZu6OlgHpesjj2lYLYqtyT0/VbMNFdZ73k1ko/VlZnzm0KUmct0B0F1WzUBDesE0W7mnLLUtDBcEBR7TxFvaQUp0qOsNFrf3zpEP0CVyyItZCywUTJoPJ11jFviGfXIcQeY1x+fs7Jr/HZ4dKah2x204QEY3RLC7mcdvUxycGQor
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(396003)(136003)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82960400001)(31696002)(316002)(6916009)(66556008)(66946007)(66476007)(8936002)(6486002)(86362001)(5660300002)(8676002)(4326008)(44832011)(2906002)(38100700002)(6512007)(2616005)(53546011)(83380400001)(6666004)(6506007)(26005)(478600001)(36756003)(41300700001)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFdoY1NvU2lQL3ZoWFZuNmJraGEzanNZR3U3UStKc0ljUTZyVUN4ZkFtQVJR?=
 =?utf-8?B?Vmxkc21wcCtWRzdIZXhKZUtRTmlMaCtxamxob2VUNXgxb09zblF6MmhzLzZs?=
 =?utf-8?B?NFAwTkc5K1grQW9nbVk1c0R5MjRPVHRsanI0NVh0ajQ3QkRyYzBZMkwwSHNY?=
 =?utf-8?B?U0pFVDgyeUlOMEdpYm1QcE9BWVRUMUh5MHZmTVo2NEJjN3QwcUtVdVQxbyt2?=
 =?utf-8?B?dytyeFBhZDUySHlwbDdMWEh5K3hydjB1UUxYRGc4UFQ4N1cwTFBpcmVyYzdl?=
 =?utf-8?B?U2Vxb0JMdUJUZnhVQ21neWdVZ3lMeUEyRnUza29Cb3hyYzY1OWNidlNETEpT?=
 =?utf-8?B?RFE0RStDOWFlTmNKUmp5OVYwOXd1ZWZzeDlOVTI1NnRlVE9teUJOQ2FGSDgr?=
 =?utf-8?B?aW81QlFPSkpiVlpMR0ZpNzVaOGpXVFVaKzBkYkhpcUZ6QTlVemNMamIzMm1G?=
 =?utf-8?B?S3JVTGVHRFhqZ0hGK09jaVRhUmpLMzVzZXZTZGY5VU5UN2RPaDJBSzNEdDdr?=
 =?utf-8?B?ZzlGTTkzNnk3bFNoRTk1ZjVJdVJySGZzTEtEdUNjcStoUUc1YWhValEyNEhS?=
 =?utf-8?B?aTl2Sjh1UVN6VU0xQkg4clQzR1lzZGNnQzVOUTkwMGFuNkE3QnlMU3VVRGhU?=
 =?utf-8?B?aDJtVE9ZclJDa1dBYlpzTXlYTTkzWkR2U2F2L2dQZFhDWXF5YmxkcVdQMEQw?=
 =?utf-8?B?V2JMWWhmUVBVdTJLak1QYkozTmxsdEJGb0NMcHl2OWlnOG0vQU15bWoyTGxm?=
 =?utf-8?B?U3MyMTVNMlB2MjFTWmIvN0Y2My9BMlNhNU16SWFsK0RjblVTSEM5VGJXZUNN?=
 =?utf-8?B?MkJnNkVXUkJJejF3UysrYXB0TWJraGFxaG1WMURVM1NRZmFMbm1kUDI0eENI?=
 =?utf-8?B?REZZd0NGWkphT0tMUHM5Q28rK1hzN2NEdGpSK2ExbUFYMmtrOGxDRVRMdkJq?=
 =?utf-8?B?NGh4dXZ2aUF2SmZ6S29objAzTzVOTDZiaTFiMFpBWmsvSjU5MFl0NDVDUzdI?=
 =?utf-8?B?ZmR5b3FzZ1IyWUcyTU0wcks3UHpNL3k1cXNjaEsrbWRQdzFBNGxBVnFMbGZW?=
 =?utf-8?B?SGo3c2NvUklCZThmSitXU0k1TjYrME0ySnhDeWJwL0Q4WEd2RW9IN2ppZk1G?=
 =?utf-8?B?dkVTYVZsdFFnL1lGQytJaVV1NWdzTVNFR1hhZlAzbXhtSnlPa3JwMmptWVRi?=
 =?utf-8?B?MWlxNGNWS29TL3U1WXpKNXV6ZnpPZVJVeGpiVXpDSnRST0pqSnphd3ZHYTZ6?=
 =?utf-8?B?K0dJSXhBbnlNMTZiRDF1am8wM0FTdFY1Ung1TnVPSU8zUVVZdlJnWWlyVUk1?=
 =?utf-8?B?c3JBeWlmdXU3ZlVrNTczdTV5eEJqdEpyTlkySlFoRFNINml3NjZKQ09mcStN?=
 =?utf-8?B?ZlVLelhmN1JUOFlUVHhmWnc3cXBlWmVuVjZGZjlxVGJFRXUyNk9OTTJrRm1V?=
 =?utf-8?B?Sjh4Zm9iMkcxS0U0MEdCeEFYQ0RWNE1aS3U3OEp3QWFqbHNiQ2FLcHhyVU83?=
 =?utf-8?B?OE5wSFUvVVVzM0Mvb1dUYURZOHFnTWs0eTVNTVQ1STNZcERTbytac3J0elQy?=
 =?utf-8?B?Y2lFN3luanQ4WmJWWWxTZXZYS3k0eS9LU0tEVU5teUh2SUxDZ3RqeVlvT1dy?=
 =?utf-8?B?NVpaaHlTamJGTWpsdUUrSEt0RGk3MFdLa3E1bmxxWDZDQTlkR3QwU1JnNDVT?=
 =?utf-8?B?Y1NYNzdxRUc4ODVWZ0RvamZGcEZNSHIzSXFwby9rSTQzNWpRc0g5MnFQTTFk?=
 =?utf-8?B?V3NINmMrWUY3SmJQWmFNb2dReGI1YXRWbC9XeHJTYU1lZGtPZ1h6VGJWdnBy?=
 =?utf-8?B?Z3hkaU1OYjlRaTN6L0JPVTlLWlVISElqNUhDZzhuRkZYMS9zT0Q5K1R1YTIv?=
 =?utf-8?B?dGIrdXN3K01pR29tTlBuMzc1bko5SEx2MVl3MDN4R2NVL1JXMmhoRmZaRE5T?=
 =?utf-8?B?Tkc3ZURBRGsxcnFOdTBhOFpZaUNwSXhyTGVvMlFzMjVoc24wSE1PL3BUdUhB?=
 =?utf-8?B?T2pweUN1WkVrUFFHOVdYRlRKK3UyNWZ6RitiZy9TV0ZQOW1XYUM1TEZJenp4?=
 =?utf-8?B?dVI4Z2dDdWdzTmhhbWtzT1BOWWxDU0xtTlNoY0pMbVVZSHh4blpXd3FGbzY3?=
 =?utf-8?B?ZjhyZG5QS2doMkdNUDNLRVNVR1ByYzF1a0ZoQ3RrMWV0MFZwNm9tMjljeDFF?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbf374d-9160-4a47-4e2d-08dc2834beda
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 23:30:18.6546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0TzgEyuPglMm1V9uaGoZXQOFDgSWxT0ymmLLDffaFnGSI1OmY5sBbvmhz2Vmr55ovE0n7F5qkk9IHc1Sjs48yjA/5dY1+45YYulWsJPy8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5591
X-OriginatorOrg: intel.com

Hi Alex,

On 2/6/2024 3:19 PM, Alex Williamson wrote:
> On Tue, 6 Feb 2024 14:22:04 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 2/6/2024 2:03 PM, Alex Williamson wrote:
>>> On Tue, 6 Feb 2024 13:46:37 -0800
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>> On 2/5/2024 2:35 PM, Alex Williamson wrote:  
>>>>> On Thu,  1 Feb 2024 20:57:09 -0800
>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:    
>>>>
>>>> ..
>>>>  
>>>>>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>>>>>>  		if (is_intx(vdev))
>>>>>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
>>>>>>  
>>>>>> -		ret = vfio_intx_enable(vdev);
>>>>>> +		ret = vfio_intx_enable(vdev, start, count, index);    
>>>>>
>>>>> Please trace what happens when a user calls SET_IRQS to setup a trigger
>>>>> eventfd with start = 0, count = 1, followed by any other combination of
>>>>> start and count values once is_intx() is true.  vfio_intx_enable()
>>>>> cannot be the only place we bounds check the user, all of the INTx
>>>>> callbacks should be an error or nop if vector != 0.  Thanks,
>>>>>     
>>>>
>>>> Thank you very much for catching this. I plan to add the vector
>>>> check to the device_name() and request_interrupt() callbacks. I do
>>>> not think it is necessary to add the vector check to disable() since
>>>> it does not operate on a range and from what I can tell it depends on
>>>> a successful enable() that already contains the vector check. Similar,
>>>> free_interrupt() requires a successful request_interrupt() (that will
>>>> have vector check in next version).
>>>> send_eventfd() requires a valid interrupt context that is only
>>>> possible if enable() or request_interrupt() succeeded.  
>>>
>>> Sounds reasonable.
>>>   
>>>> If user space creates an eventfd with start = 0 and count = 1
>>>> and then attempts to trigger the eventfd using another combination then
>>>> the changes in this series will result in a nop while the current
>>>> implementation will result in -EINVAL. Is this acceptable?  
>>>
>>> I think by nop, you mean the ioctl returns success.  Was the call a
>>> success?  Thanks,  
>>
>> Yes, I mean the ioctl returns success without taking any
>> action (nop).
>>
>> It is not obvious to me how to interpret "success" because from what I
>> understand current INTx and MSI/MSI-x are behaving differently when
>> considering this flow. If I understand correctly, INTx will return
>> an error if user space attempts to trigger an eventfd that has not
>> been set up while MSI and MSI-x will return 0.
>>
>> I can restore existing INTx behavior by adding more logic and a return
>> code to the send_eventfd() callback so that the different interrupt types
>> can maintain their existing behavior.
> 
> Ah yes, I see the dilemma now.  INTx always checked start/count were
> valid but MSI/X plowed through regardless, and with this series we've
> standardized the loop around the MSI/X flow.
> 
> Tricky, but probably doesn't really matter.  Unless we break someone.
> 
> I can ignore that INTx can be masked and signaling a masked vector
> doesn't do anything, but signaling an unconfigured vector feels like an
> error condition and trying to create verbiage in the uAPI header to
> weasel out of that error and unconditionally return success makes me
> cringe.
> 
> What if we did this:
> 
>         uint8_t *bools = data;
> 	...
>         for (i = start; i < start + count; i++) {
>                 if ((flags & VFIO_IRQ_SET_DATA_NONE) ||
>                     ((flags & VFIO_IRQ_SET_DATA_BOOL) && bools[i - start])) {
>                         ctx = vfio_irq_ctx_get(vdev, i);
>                         if (!ctx || !ctx->trigger)
>                                 return -EINVAL;
>                         intr_ops[index].send_eventfd(vdev, ctx);
>                 }
>         }
> 

This looks good. Thank you very much. Will do.

I studied the code more and have one more observation related to this portion
of the flow:
From what I can tell this change makes the INTx code more robust. If I
understand current implementation correctly it seems possible to enable
INTx but not have interrupt allocated. In this case the interrupt context
(ctx) will exist but ctx->trigger will be NULL. Current
vfio_pci_set_intx_trigger()->vfio_send_intx_eventfd() only checks if
ctx is valid. It looks like it may call eventfd_signal(NULL) where
pointer is dereferenced.

If this is correct then I think a separate fix that can easily be
backported may be needed. Something like:

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 237beac83809..17ec46d8ab29 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -92,7 +92,7 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		struct vfio_pci_irq_ctx *ctx;
 
 		ctx = vfio_irq_ctx_get(vdev, 0);
-		if (WARN_ON_ONCE(!ctx))
+		if (WARN_ON_ONCE(!ctx || !ctx->trigger))
 			return;
 		eventfd_signal(ctx->trigger);
 	}

> And we note the behavior change for MSI/X in the commit log and if
> someone shouts that we broke them, we can make that an -errno or
> continue based on is_intx().  Sound ok?  Thanks,

I'll be sure to highlight the impact on MSI/MSI-x. Please do expect this
in the final patch "vfio/pci: Remove duplicate interrupt management flow"
though since that is where the different flows are merged.

I am not familiar with how all user space interacts with this flow and if/how
this may break things. I did look at Qemu code and I was not able to find
where it intentionally triggers MSI/MSI-x interrupts, I could only find it
for INTx.

If this does break things I would like to also consider moving the
different behavior into the interrupt type's respective send_eventfd()
callback instead of adding interrupt type specific code (like
is_intx()) into the shared flow.

Thank you.

Reinette


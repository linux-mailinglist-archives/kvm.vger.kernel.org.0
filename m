Return-Path: <kvm+bounces-8156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D189284BF65
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 022D51C233F8
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005701BF3F;
	Tue,  6 Feb 2024 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XKL+OR1p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DCD1BF2A;
	Tue,  6 Feb 2024 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255888; cv=fail; b=Di77qDW/PQfdhIq0yxOnBk1AhTHjh0Pw9Th8b12r+oSLiJGFfvRkCglaWNkOsT6/xE6Pd7hgc03RCCRBnyDlaGIk6vOkertcbREtgVvrcJDJejKVVsKE97ewB7FOAyqKKS0i00AGofnMSazBB/3016bMQb5/AIge91701Jv1814=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255888; c=relaxed/simple;
	bh=pamV2oSPGlFJy6GC+AaxbsFuVTaZVLoR1x0QMsFqV6g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kr/1iNLkXI6gxfYGJfC9E0Voj7C6McJs7cixE8WxvWvRv73vXz6goyNSHLr61V+GAHYX0+IOZUCibLDFNJ1TqPc8oH5yW5o+gYPISocihYF1wBSn2zfriuKNQLE1OvoMYAWbR0VAlBZYhrhYPI3JdnYGg7QzMZC9JR/Wwubek2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XKL+OR1p; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707255886; x=1738791886;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pamV2oSPGlFJy6GC+AaxbsFuVTaZVLoR1x0QMsFqV6g=;
  b=XKL+OR1pKu47C8f/pGX4zGnPTgJRE846f+zvVN4CZeKabvUslp5aw5FR
   IdCj0IAKC8E5qONyJQ3MLy7kCZz/hcUin3SsuP7t9Vzapsv15Ja6UyThX
   i44PbUUg231h3G0pubAGhqr0PKAR7cePeoPrljcQ1ya0fWqo9CgbBzyy7
   vpZjn0b+Jh8eZZEFYJUGQI32FmKKgL8ah/tqdk9Asfsi0tzOmxheUHtpB
   uquvvKOfNKh0YXTZZHh8ZVGoIwbpkpMo9M80GM8prA97CsnZlYIduUDiD
   OGX9OmAFMuJMBT0X9g1dQW8omxZKC6bthFjv9XZfR2MsB2C7SbkcnjJbz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11492780"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11492780"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:44:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="24387312"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:44:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:44:41 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:44:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1ojpy7cfzVoyOVQDMSG3GJylTr6zDOaybcNIuC3v4WI3VTN1BuAvDxzBwBIpbTjR/2xknuUwl7cckoyzn0f5l6BRgRTDKeRySvcru4w0IvlCMy5d2ewnWM3la/QVVo3suHly3BpsyEatsswkz38yqVeHAbW9VMIO3qA+eF6eNq7L8XiOKm/vWQO710hPRyYiJgS/ok0tyBGjueylAEQ6oKyiXlFOSQzMqoX8+ulrYoqt/dbimIvYz8bQOQZD6ftZTiRb5WHLc3X2/XuJoYn/vOBeHgZU9m8av0FltR6r3KlapJw8xKS1JsR8Fh62erJtNe0gKQy7Eb7sCEYeoVrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOQ62r3iItG7p/gqGzU/JXFW1qqV6Kf2LRsx6gGTa3w=;
 b=nsUxR5EeT4kkB78DsxFREclHjD8lwv3wN1rWsg5ZNs6uYonKGevd04LjHpcGxIdDEvpRF0t3CcURnHB+F3WV1IazAghUrp6cUI+2qFdZHfv8xrCpSRLHqm9QzKYwcJhY9ezKwzmbtMKf2e805pFkdKvnvqm6/e+KiaXpie8Zhf+JxKEql5aOHXNkJDoMvO39Ug0pqCsLs7yBeYshtp/+EX5RWO3+shR0KVspFobCg1XdwbSEC9ztRK/+LIfWYcwHjiFNPvWpaj4V3rgUcsglFhigZ4ePM/gzzofKFzt48Vv7aTYeLNYSOHv6bZ4rWoMrmqEPw1fw8KT9ft+DQAIGAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7367.namprd11.prod.outlook.com (2603:10b6:208:421::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 21:44:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:44:34 +0000
Message-ID: <51b8337f-fb7a-49d9-90f5-a357dfe3ac5b@intel.com>
Date: Tue, 6 Feb 2024 13:44:32 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/17] vfio/pci: Consistently acquire mutex for interrupt
 management
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <e7d35d7730f3f83417e757bc264a470f8c2671ed.1706849424.git.reinette.chatre@intel.com>
 <20240205153452.4a9bddfd.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153452.4a9bddfd.alex.williamson@redhat.com>
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
X-MS-Office365-Filtering-Correlation-Id: 928330f8-5e6b-4167-7fea-08dc275ccece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3z+ABrGRjJ/5GF9pBuLMPqliXzu/LD3JnlaX60j+D6B1bzng0mJL6QMmhp67Uz5dfllq4RBJAPBvtVhBLBvdQ98TuLeQp6smcZhYF2Co+3MFhvDWlILx6UXKKx13niQJNX8I5tWcy6JjMifVLQv1x74MYuQ3j1dMrLsjBLH+goalyq1f5WOxbwV1x/t5ULWUvAmQ+VFWReMB3FClw7YzNCBcbYHUfKVBTiBolYYt04Y7V6V/jTXilDx+CmZYgTYL7Mw9GXtcts9mPJ3E7G4PMN8FTIXBBgeTzOrAN1c1/XMvJ2pOhmbnY6xF+P9Wpkd1leG9F3K8X1P59sEMhgUkJOlZpuBr5eJqFQG6wMgQBAcRClPWLpeiweeLTb4hFYE9Rfg69vuLb2imI1Y25a+Ysm17V79tJInSqK666HjnQTwLqv8wh1f/BaL8qA2AJv0oNWLkwE5KJ9PIPVx+UJ30UkAwGGhvxirSh8TxAGILmRzMKERM7zbM/O3+FJuCezjlB/ODv2q4pjAH3qASzh6uodWG1E5rdd380WKmUvNkUaevXo7qmQV2S5ESbPL2qIZwwm90V2uE5//TR8Z0xDEIcUN5jZbtbrpqDMKP5bN8gydfs4I+iWhjwEIzDEGMWHSe4t9lSSzxH1ZWqJFDYvMeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(366004)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(36756003)(41300700001)(31686004)(66476007)(4326008)(8676002)(316002)(66556008)(6916009)(66946007)(86362001)(5660300002)(8936002)(478600001)(6486002)(82960400001)(44832011)(6506007)(2906002)(31696002)(83380400001)(53546011)(38100700002)(26005)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U29DS3pqNm8yb3FVSzR4akVpWWV5TWNzNTFWSmRROHI5Vzd4NFZEaWJqekxw?=
 =?utf-8?B?ci9jVGZaWU9LL3MrMmUzcVV0Z0NPVThWdXFQNEdmRnJ3Y3d0YklIUndWd2h0?=
 =?utf-8?B?OWtzSjJCSitVclpseUIySnBaWUJOdHdBU0d4cDYyc1hTR29GV2JSYkZpWXR3?=
 =?utf-8?B?RFpQd3RsQnRHWDk0TjZRaENTMXZtUjFjK2k0bk5QQmZ4cXYrcHp2TEdlRFZo?=
 =?utf-8?B?VXIvR0hjSHBhelBDUFVwV2djYlV6Zmlzb0FSK0pXbjlFeEdQR1NnOTBCcnpm?=
 =?utf-8?B?WHFuejR4OFFuNDBVMGNlYlgvUkpURWZOekUrUExqYVZNZlNjQ3JZRjYxbUhW?=
 =?utf-8?B?RnB3bXBWTDN1WklHR2hIb1hpaWVaY3NQNUhHSWEwVjV0NGNwYy9YUUkxaFg4?=
 =?utf-8?B?S21RN1FFenRGM3ZUY1dXdXNlS2RZL0JzdXB3aGtlSEY0WkdUQjA4ZkhlL0Np?=
 =?utf-8?B?clNia1NrS3N1MlYwRG80d1BSdE14V0FiZldseHp5UGwwM01QVHAvV3I4SGRV?=
 =?utf-8?B?dDdpWDNnRlM1VmFoQUVpUGpIeTJhVXJ4K2dQWHVWd3EwUWVDMU4zSlBHR3Qw?=
 =?utf-8?B?WEMzRXdIb3d3Tm1iQkVKUlFNTGZYajA1MVpPZEd4U2R2TjVuZW0vRjZOR1Nh?=
 =?utf-8?B?MDJRUjczaG5rb2VzMkhaRUZMVlZuSmN1ZVlrWEFWMWFNeHhpRloyaWYxVmVm?=
 =?utf-8?B?ejRiVkdyOE1ub2g3WjhhZHdwUGpFV0QvRXhaQ0ZyY0FDNHR5b0NING00NXJo?=
 =?utf-8?B?TWNMdUd4WGFMNVFFaTJuekkzVVJrQXRRVk1saldaaWtVK3B6S3BFdkxHazM5?=
 =?utf-8?B?VXQ3dEZhOGNzOWo4NGUxdVVwVEw1VFBsbStZb2ZUS2I0OW9xdVU1OVB2ZlZ3?=
 =?utf-8?B?ZkpRQ0pVYjdtU2sxUUVjQVdsU2pNUFdiZFVKOVlSdzAycXRBRXJ1U2liSDU2?=
 =?utf-8?B?M295VVh5SFNVNjlja0x6WlNORUJ3ODJZTklUcElieDJETitRWGtSMVFMeFd1?=
 =?utf-8?B?MlFZc21ncm5ZbURwSVQzLzJIU2FBNzJRV1l4OEE5YXVoVkFtNEFycVNETHRj?=
 =?utf-8?B?VHZmTXk2RWt6ZnNvbnVZam55M1dZL0dvVWlzRlFSclJIem1tUjViK0JmeHBZ?=
 =?utf-8?B?WmU1aEVZVGppTXJOdk82MUJvbWQ0SzlPdG9rQ3Fka2t2MFRwd2Z2QTd1QmN2?=
 =?utf-8?B?dDdDVjNZZGxmSmlhTFR5UU1yeVg4YWF6RXhsR013d2N0NTBQVlY0WDFGaUo3?=
 =?utf-8?B?RmdhODRwNzNpZGpvQWlDamFHaGUwTEREZGZNMHlDYmc2VC9ORU9yTEFMeSt1?=
 =?utf-8?B?UnNHR0IweGRVbWxRRUZtK29QaHJFQVltam45WDFpOEh1b0s2UG4wSkxiRTk2?=
 =?utf-8?B?aldteDVXZDhVVTZqUlVHd1poU2pLY241UENxdW8zc1I1UEZMZld5bkg3WTB3?=
 =?utf-8?B?bE40eHBmdXllamMzYngxNzc2bEprb21vSDVQSm40ZnRGUXhFUUlHRHYzSTFZ?=
 =?utf-8?B?SmUySFloUzRWY1ZxNkpoeDM0aGhsaDJCOTMyaElMV0xtdjNCbVZwSWVVVUxl?=
 =?utf-8?B?eGNIb1pueHNXQitPclZQVXlpNGdGR3lNWEZiNTAzVGZ4VEMwbTRJRmVxMC83?=
 =?utf-8?B?NS9jM01hTCs0SElPNTlzb3VCaVNvaUNna2E2UUtZUDNsNXQxUkZ6cEkzbW9F?=
 =?utf-8?B?Y1hQMVdXSDZMQ0VPbEFIRXhJbC82cmx6VkVnSHFsVVdvaUhpVEUxQXZ5cldz?=
 =?utf-8?B?KzJsbFRubTY0a2dscDZmV1B1WTdTU3k1RmlaNmE5VHdGZTVRR0pXeE9CMUVZ?=
 =?utf-8?B?VG5RNDcrb2IzNW14L2VkY09nY2dRaEZ2eEpDWVVhaDJEL3pESGdnVFZZdXRn?=
 =?utf-8?B?NUZyWGtydGVLV3B1NkluZUJsSmtrOWwrVG8rdkZpNU82alAzZElyVFJseEdS?=
 =?utf-8?B?RStuaWo2Q2Y5ZlJZeDlzdVBUYkc0UmxEMlQ2dUZYSnBtTFBZbEVtR2tnN1dQ?=
 =?utf-8?B?NVg1VlFHSXAyRllLODBPaW1QQUxidGJpUTFtenRtaGJGSXNHcDJxMVZKR0la?=
 =?utf-8?B?bDhDZVkwRmxtR0cwaDZPd1hUTkxWeGpqbDVudTUvOHZCR1hXZGhLZjZQVGRs?=
 =?utf-8?B?Y01jZjc0RlpXWGlBVFFieUNzK0RxMHZtOUdjRDFkQUtnR1hUOXFJVDEwSHAy?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 928330f8-5e6b-4167-7fea-08dc275ccece
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:44:34.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pv74I5tfLyNM6OTIEtK7H2AZ/gWKiFMexPh2+RhIZJjmy9tJwdQ+Qy4uWGpSEb53UD9eEGaTgrnFqhfV2dMA456xkD4dw2eADbPhVnA51qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7367
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:34 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:56:57 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt management
>> via the VFIO_DEVICE_SET_IRQS ioctl(). The igate mutex is obtained
>> before calling vfio_pci_set_irqs_ioctl() for management of all interrupt
>> types to protect against concurrent changes to the eventfds associated
>> with device request notification and error interrupts.
>>
>> The igate mutex is not acquired consistently. The mutex is always
>> (for all interrupt types) acquired from within vfio_pci_ioctl_set_irqs()
>> before calling vfio_pci_set_irqs_ioctl(), but vfio_pci_set_irqs_ioctl() is
>> called via vfio_pci_core_disable() without the mutex held. The latter
>> is expected to be correct if the code flow can be guaranteed that
>> the provided interrupt type is not a device request notification or error
>> interrupt.
> 
> The latter is correct because it's always a physical interrupt type
> (INTx/MSI/MSIX), vdev->irq_type dictates this, and the interrupt code
> prevents the handler from being called after the interrupt is disabled.

Thank you for confirming. 

> It's intentional that we don't acquire igate here since we only need to
> prevent a race with concurrent user access, which cannot occur in the
> fd release path.  The igate mutex is acquired consistently, where it's
> required. 

Thank you. I do think it will be helpful to document some of this
in the code to help newcomers distinguish the scenarios (more below).

> It would be more forthcoming to describe that potential future emulated
> device interrupts don't make the same guarantees, but if that's true,
> why can't they?

As I understand an emulated interrupt will be triggered by VFIO PCI driver
as a result from, for example, a mmio write from user space. I thus expect
similar locking to existing device request notification and error interrupts.
I would like to focus this series on existing flows though.

>> Move igate mutex acquire and release into vfio_pci_set_irqs_ioctl()
>> to make the locking consistent irrespective of interrupt type.
>> This is one step closer to contain the interrupt management locking
>> internals within the interrupt management code so that the VFIO PCI
>> core can trigger management of the eventfds associated with device
>> request notification and error interrupts without needing to access
>> and manipulate VFIO interrupt management locks and data.
> 
> If all we want to do is move the mutex into vfio_pci_intr.c then we
> could rename to __vfio_pci_set_irqs_ioctl() and create a wrapper around
> it that grabs the mutex.  The disable path could use the lockless
> version and we wouldn't need to clutter the exit path unlocking the
> mutex as done below.  Thanks,

Will do. This creates an opportunity to document the flows involving
the mutex (essentially adding comments that includes your description
above).

Reinette


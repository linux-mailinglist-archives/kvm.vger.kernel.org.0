Return-Path: <kvm+bounces-3327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 853D5803161
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8F5E1C20AB5
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC8222EFE;
	Mon,  4 Dec 2023 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwnbsSjJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEBDA7;
	Mon,  4 Dec 2023 03:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701688745; x=1733224745;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wxePmJy3xQyu05+EaqEBkgpIxb7htKRRL9dvCNNUHm0=;
  b=hwnbsSjJz8P54JOqcPqc6PqCwO1+AySSI1/SEq9w4lrWUcEc0CyYolIJ
   jicGQyo5ryyfqKKbGPzIsWvoMfUGrVEcKhnzSD7gXgfCpxb8aRmzqDKfp
   IDN1HjopiIF4kCYlRUcQ4UafFz6VA/o/czHvEE6Zu/t4hWlSHFUuPN3fJ
   0w7WolXBv15u7v5qWnACXjXX/L9hSGQypMRQaadt1NUGjp74pUF/d7cMu
   qQpU2vzSl5ZBodk7ljFbd794c2gBl5PVZpuYA4dsTcx79oT8Y79ckCAp+
   YOfFttsjM7lwM3jsw+vWxdrlrOjQP4wXNFlfmEouOPVsJrK070SFMJoUM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="373905389"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="373905389"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 03:19:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="861346605"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="861346605"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 03:19:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 03:19:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 03:19:04 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 03:19:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZLHbg5C2sFa87qPNSH1jduPsuWpdDIdYZOrJS+//Kf261dXeNaCxZgXH8WKkkYQ6y2XIMW50613LBRLnlVeWz2BA2S97/y+n5FFJwAfkpeZ376Ya99n3Sk+/HLMO59dz9enNmyjuetpNKZrErCfZfObGr8Bc6oU/xhpeCw2w2KjsWdtTJhiHROtLIxpwWKJ8FHJFM7L1CUVTbTZuJLwaHQczyDdlCDHVP0jVg79yS1/67R8PLYWeIxT/5DIudObA53Mj6O27PKoy6Lc1Q8PWnQ2MUpgleOEPA4Xt7YncwAwho7a4Dcgzq29u1z3qX37WBczM+6fVNjiEKdfaX2s5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRwYBxBYMO6DHq/+SOCmdFUF9UCjv3NCYmmzRNnHdOQ=;
 b=QQAqc3bLJbiWLgZFUcAQd4W+TPBheDKOxdNTJsaC9S5DGR36QKl4gmkDdD1soeZ8cU7V5xhGqBXgOuquL+jle1JP7w2/o5ODg6tQCekPbbKu/NTObkA3KLBmZr/mGG8Ya+w3FEFzeXT9iPldTWgsIpL1LtTa/f3kOv/vx0+lJbqliTfFNN4GOeWyGIhsbF3Wj0WkHhfawoIrI/hWsCDgW4pEypcDwLrrU5SzzBdShMd/EY0MaeEntt5PSm3NTEJ2J7P/bVruD1++pKzXCSGsciqaPm78qoi8HQ+AlvFp5v5EZQ2C98nR38P6oiGtPemNDTGsOZx9rUHDUp5f8T1cJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 11:19:02 +0000
Received: from IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::cbb6:48f6:d69d:f657]) by IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::cbb6:48f6:d69d:f657%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 11:19:02 +0000
Message-ID: <3b2a26f8-fced-49e3-b129-d742ee49874b@intel.com>
Date: Mon, 4 Dec 2023 19:18:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iwl-next v4 00/12] Add E800 live migration driver
From: "Cao, Yahui" <yahui.cao@intel.com>
To: <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <lingyu.liu@intel.com>,
	<kevin.tian@intel.com>, <madhu.chittim@intel.com>,
	<sridhar.samudrala@intel.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <brett.creeley@amd.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>
References: <20231121025111.257597-1-yahui.cao@intel.com>
Content-Language: en-US
In-Reply-To: <20231121025111.257597-1-yahui.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To IA0PR11MB7838.namprd11.prod.outlook.com
 (2603:10b6:208:402::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB7838:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b4803f-738b-4b69-17d5-08dbf4bad179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsEm9VW1wFwWXHZGhfvu6QyZDWH2y10qbWqPsrixPItlHkOtFprQYaxm3ub+/SVqv37iTMz66TcYKhyyEQQlnQU+cTNr0EpiAEIgzY7zwhZbvqZ/U4DBuqHruR/7qorja8hq6ZWbVVIqll0JJjGr/Gyt1gmi5WtfCQDvBYStWmSYZ/pa3DeeSZTg3dMsZD+6pPD2LT1BOtMQeplYYF5zuhzxCqhEXKopFdCzrFR3LIveTEJaQhfherq0+N/Fz06JTXcTqsjq8678HXl6r9I6feFDeaEPpfU0J4g0Xo96T+/9qfObfRLtPTxSdNX+Pcwt21m+O598fcLv10ZfJlQZgoE3HsrZiackNBNRCALN0JqNwR8K+p3Pg+kFwvfibroGxM65vCZU0ylBjmiMsynrCZ+a4ZAB+u1zr70V+w7oi4BaDRkyRFQ/cJ1yZU4p5YMErQunamgusjzq5O8Ujx2iY8tBlzZ1m3/zucJP1GP9EzS11hzFZbMid/tq83fQRCKab71ZTmzty0v3Zz7xyeU6Vab/H3lup1DbTNYszGhGZ5F1Ws2qDirthYfEJF0UKJ0LM+FosqWOgGJBOYS2M7DL40Mu3O58iUg/Zhgh5jiFABnfg/Px28Wh5E1mCCKk/FYKdTivegQ2Z8NXN+/AmiQgX6QJ0gaYXljkQxJ1ApAoBaKJ8AheBGXk0bELohHBCF48YzhVybycrMgzhZ7k61sAYDG0gBleeKkED/uyc9+oMU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7838.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(136003)(346002)(396003)(230173577357003)(230273577357003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(66946007)(66556008)(66476007)(316002)(478600001)(966005)(6486002)(41300700001)(6666004)(36756003)(5660300002)(2906002)(7416002)(8936002)(4326008)(8676002)(86362001)(2616005)(83380400001)(82960400001)(38100700002)(26005)(31696002)(6506007)(31686004)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWRoeEttc1ZmSE9TbjlpQ3hxSGQ4bmg5d1ZFdWx3SnFtbmp4c2JtRGZLencv?=
 =?utf-8?B?dXRKS3FUV0RrM0F0NGliQjBYNmNneFI2MktQQ3FHa1Ntd3lWTTJIUktJNURI?=
 =?utf-8?B?L2ZYcUZUWkpTUHZhZnlIcytiKzFDU0tBMUlNZTRidjBpYTZqQXFPY3VqVzRh?=
 =?utf-8?B?c0prR0p0RFp2ejY1VHBYZG1xeno0MVhsZGhJeWRGbWpWblJZSkRqKzBWWkRY?=
 =?utf-8?B?aDVlYjNCSldJeWxVbFNDUnQ5ZXA1ekN3MTA1WmtxNjBiRjhXMDcwVWVFbHRa?=
 =?utf-8?B?VWhDRzFBRE5kN2pLT3dsTU52TjZDc3JZSFE3bEppUFhzSkFScUhBNzNCRngr?=
 =?utf-8?B?YisySFF0aTlXNis2bTdRTlZXN2xEZU82ZXVrZ09Yc0NVQzk3MzRVdTFRZXRt?=
 =?utf-8?B?eksvNU4vUlFCc1JObmtxT2FOQm14cjZhelVzL205a0RsSkNtV2hjcG5sS2Jq?=
 =?utf-8?B?NXMyOUJRVzhvcjBqVk1JekU3aGxBOFFiNGFaV0NzUWNBYmQ3d1BYTytEdWdS?=
 =?utf-8?B?MWhRMVZTZE1CSXczOVU3UENFRG5zZTM4cW0xVzZmNkRjWldJRTZmMUtKTjFq?=
 =?utf-8?B?ckVYd1JQL09QOFpkUVM1dk5OSjB5NkJPd05TRmd3WVV1ZGs3bTVndm9Vd0NP?=
 =?utf-8?B?N09BMHNzazdadTQ1U3hkQ0t2Sm5tMjBJQXovZzhXWVI0WmIvMWE5cWhFSWRB?=
 =?utf-8?B?RDkreDVLSDNjZFBRaGwzdmFFSmx1V0JyZDBnQnpnTmFEdnFwbVRoRjJLeU1V?=
 =?utf-8?B?T0x3cUpTUlp0TEZGb0NNdXhva2N3MGk3bnN5dXJ4UFo0cGpKby81cnd0cHFN?=
 =?utf-8?B?YzBqQkh6OHZNS0Nqd0pHTXlNVXhZdTRuVXRSWGtyZ1FESlh1UjZKOXJMU3gx?=
 =?utf-8?B?a0tMQmZnbTVEdCtaWTEwTGM2K28ydzhDdlVzb0UyY1piVDdpbkxQeTlvc2Rq?=
 =?utf-8?B?TEptWVVXb0dXMDhadlBUbzVPM0ZDaVFLNVdSbzduSkVSSWpSMHFnZFdzb3Bl?=
 =?utf-8?B?RVFaNDFJUmpUOFBrYithb1E5aFFwRlJjM2VQdU9NRkxHVmJ1dDFCVEYxdjZz?=
 =?utf-8?B?cThZZWZuR0dHdkp2WVRqN1JvYlRrakI5V3pqWXI4dlZxSnU2OGM0dDRGemlF?=
 =?utf-8?B?b2l6bkJWYjM1cU9PK2xBNnY5azQ3TVlWT1lvUk9lNnpNZTFncnBVSmFzUnpM?=
 =?utf-8?B?SUJTT1pYMS9SY3ZuYWZ3YUhDQzdsS1R1SWtLT0FnWGI2Tm5sVGJoMGFkWDlj?=
 =?utf-8?B?SWhCWWVBYXltc282WW5hOUFIZDhSZ3ZocVlkZzhYNUZraTVoS2drcDZiOU5K?=
 =?utf-8?B?YnNXOGNyV2RTazhOY1pGZy95VURZYWE0dytYeVkveVZDakVMZWJuQkZUR1BE?=
 =?utf-8?B?bSt3SVllcGtPcDBlVXVWd29qU21rK2FJWFFzOHQzVkZZVWg1Z1JidS96ZFNk?=
 =?utf-8?B?YkVGbkdxZkFSSlpWVDVDUVJLbDFUWmhnUDlhc0lBbnVJZm8xcGorNFpxTVJJ?=
 =?utf-8?B?QWJ2TXkyTEUvbmdwdHJFQ0xzZk5aWFpoZkZYcjRyU25EQ25vSFQwdytHcHJw?=
 =?utf-8?B?WFUwNFM0SHpXcEtsOThhaVhVLzlGQ3l2RGd6NHRrRUlQZXlOOXdmU2M1Yk05?=
 =?utf-8?B?dEpGZjg1VVZmVVUvSnUvbnZTY2ZtQ0JMa3BOeE9Sa1h3TjRIUjljRlNqTDdC?=
 =?utf-8?B?di8ya2Z0ellXdHl3eEpHcE5OM3BzbTNPZUFlelNEK29ZYkVlZVpPckE3dkJn?=
 =?utf-8?B?d1dXVktiN2c5OFFyQnc5QllabEFiUWcwVnAzcGhsK2drY0UwNmNqZ2VWazdJ?=
 =?utf-8?B?OVFmU3BGNjNLTWNGUWNPRHdwVjhLL0JoVDIzdmFRc3hBajBaWVFGOUZtTldB?=
 =?utf-8?B?QXVkVTUvbWpiUUVVQ2s1MG5IOUl0NGJjZHVESnlURjZuRFdEbm10ZWVzZmZE?=
 =?utf-8?B?SlFUNjdhclIyRGxLTlBrUjc3MVBjcnpQU092MHkxdWJ5K2gxcGVEb1VFQm13?=
 =?utf-8?B?MDBJTDdkdzZJYUpmM3ZuUDNnclJHekVwbmVFQU1ZM2VoZkVmTWJaVGRPUDM1?=
 =?utf-8?B?V2grVklVeVYzRlZJVDBqaUJIOFJGU05IdDlHWHVVT3JMMjBUMmJoZGYrTHd4?=
 =?utf-8?Q?bDdRmI7mw+uorWwa4BaTHe3Ml?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b4803f-738b-4b69-17d5-08dbf4bad179
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7838.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 11:19:02.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9Ca+rekURGDc7ALehkcL3Vc4tGn4MrcJLbUTTNS3gMlK2ksVj3t9TDNtwQage32VFOB3h3dHMg2ujYl8X1a1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
X-OriginatorOrg: intel.com



On 11/21/2023 10:50 AM, Yahui Cao wrote:
> This series adds vfio live migration support for Intel E810 VF devices
> based on the v2 migration protocol definition series discussed here[0].
> 
> Steps to test:
> 1. Bind one or more E810 VF devices to the module ice-vfio-pci.ko
> 2. Assign the VFs to the virtual machine and enable device live migration
> 3. Run a workload using IAVF inside the VM, for example, iperf.
> 4. Migrate the VM from the source node to a destination node.
> 
> The series is also available for review here[1].
> 
> Thanks,
> Yahui
> [0] https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux.git/log/?h=ice_live_migration
> 
> Change log:
> 
> v4:
>   - Remove unnecessary iomap from vfio variant driver
>   - Change Kconfig to select VFIO_PCI_CORE for ICE_VFIO_PCI module (Alex)
>   - Replace restore state with load state for naming convention
>   - Remove RXDID Patch
>   - Fix missed comments in Patch03
>   - Remove "so" at the beginning of the sentence and fix other grammar issue.
>   - Remove double init and change return logic for Patch 10
>   - Change ice_migration_unlog_vf_msg comments for Patch04
>   - Add r-b from Michal to Patch04 of v4
>   - Change ice_migration_is_loggable_msg return value type into bool type for Patch05
>   - Change naming from dirtied to dirty for Patch11
>   - Use total_length to pass parameter to save/load function instead of macro for Patch12
>   - Refactor timeout logic for Patch09
>   - Change migration_enabled from bool into u8:1 type for Patch04
>   - Fix 80 max line length limit issue and compilation warning
>   - Add r-b from Igor to all the patches of v4
>   - Fix incorrect type in assignment of __le16/32 for Patch06
>   - Change product name to from E800 to E810
> 
> v3: https://lore.kernel.org/intel-wired-lan/20230918062546.40419-1-yahui.cao@intel.com/
>   - Add P2P support in vfio driver (Jason)
>   - Remove source/destination check in vfio driver (Jason)
>   - Restructure PF exported API with proper types and layering (Jason)
>   - Change patchset email sender.
>   - Reword commit message and comments to be more reviewer-friendly (Kevin)
>   - Add s-o-b for Patch01 (Kevin)
>   - Merge Patch08 into Patch04 and merge Patch13 into Patch06 (Kevin)
>   - Remove uninit() in VF destroy stage for Patch 05 (Kevin)
>   - change migration_active to migration_enabled (Kevin)
>   - Add total_size in devstate to greatly simplify the various checks for
>     Patch07 (Kevin)
>   - Add magic and version in device state for Patch07 (Kevin)
>   - Fix rx head init issue in Patch10 (Kevin)
>   - Remove DMA access for Guest Memory at device resume stage and deprecate
>     the approach to restore TX head in VF space, instead restore TX head in
>     PF space and then switch context back to VF space which is transparent
>     to Guest for Patch11 (Jason, Kevin)
>   - Use non-interrupt mode instead of VF MSIX vector to restore TX head for
>     Patch11 (Kevin)
>   - Move VF pci mmio save/restore from vfio driver into PF driver
>   - Add configuration match check at device resume stage (Kevin)
>   - Remove sleep before stopping queue at device suspend stage (Kevin)
>   - Let PF respond failure to VF if virtual channel messages logging failed (Kevin)
>   - Add migration setup and description in cover letter
> 
> v2: https://lore.kernel.org/intel-wired-lan/20230621091112.44945-1-lingyu.liu@intel.com/
>   - clarified comments and commit message
> 
> v1: https://lore.kernel.org/intel-wired-lan/20230620100001.5331-1-lingyu.liu@intel.com/
> 
> ---
> 
> 
> Lingyu Liu (9):
>    ice: Introduce VF state ICE_VF_STATE_REPLAYING_VC for migration
>    ice: Add fundamental migration init and exit function
>    ice: Log virtual channel messages in PF
>    ice: Add device state save/load function for migration
>    ice: Fix VSI id in virtual channel message for migration
>    ice: Save and load RX Queue head
>    ice: Save and load TX Queue head
>    ice: Add device suspend function for migration
>    vfio/ice: Implement vfio_pci driver for E800 devices
> 
> Yahui Cao (3):
>    ice: Add function to get RX queue context
>    ice: Add function to get and set TX queue context
>    ice: Save and load mmio registers
> 
>   MAINTAINERS                                   |    7 +
>   drivers/net/ethernet/intel/ice/Makefile       |    1 +
>   drivers/net/ethernet/intel/ice/ice.h          |    3 +
>   drivers/net/ethernet/intel/ice/ice_common.c   |  484 +++++-
>   drivers/net/ethernet/intel/ice/ice_common.h   |   11 +
>   .../net/ethernet/intel/ice/ice_hw_autogen.h   |   23 +
>   .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    3 +
>   drivers/net/ethernet/intel/ice/ice_main.c     |   15 +
>   .../net/ethernet/intel/ice/ice_migration.c    | 1378 +++++++++++++++++
>   .../intel/ice/ice_migration_private.h         |   49 +
>   drivers/net/ethernet/intel/ice/ice_vf_lib.c   |    4 +
>   drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   11 +
>   drivers/net/ethernet/intel/ice/ice_virtchnl.c |  256 ++-
>   drivers/net/ethernet/intel/ice/ice_virtchnl.h |   15 +-
>   .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   28 +-
>   drivers/vfio/pci/Kconfig                      |    2 +
>   drivers/vfio/pci/Makefile                     |    2 +
>   drivers/vfio/pci/ice/Kconfig                  |   10 +
>   drivers/vfio/pci/ice/Makefile                 |    4 +
>   drivers/vfio/pci/ice/ice_vfio_pci.c           |  707 +++++++++
>   include/linux/net/intel/ice_migration.h       |   48 +
>   21 files changed, 2962 insertions(+), 99 deletions(-)
>   create mode 100644 drivers/net/ethernet/intel/ice/ice_migration.c
>   create mode 100644 drivers/net/ethernet/intel/ice/ice_migration_private.h
>   create mode 100644 drivers/vfio/pci/ice/Kconfig
>   create mode 100644 drivers/vfio/pci/ice/Makefile
>   create mode 100644 drivers/vfio/pci/ice/ice_vfio_pci.c
>   create mode 100644 include/linux/net/intel/ice_migration.h
> 

Hey Jason & Alex,

     Did you have any chance to review this v4 patchset ?

     The branch is published as 
https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux.git/log/?h=ice_live_migration 
as requested.

     These patches are based on top of commit b85ea95d0864 ("Linux 
6.7-rc1") and being sent as a whole for ease of review. A branch/shared 
pull request for the networking portion of these patches (1-11) will be 
sent when review is complete.

Thanks.
Yahui.


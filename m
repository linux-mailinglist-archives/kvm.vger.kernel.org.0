Return-Path: <kvm+bounces-1219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 482207E5BBC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB2F4B20F95
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD91C199C7;
	Wed,  8 Nov 2023 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nolsnOZB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC51179BE
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:52:33 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FB81FD7;
	Wed,  8 Nov 2023 08:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699462353; x=1730998353;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BfCOQnVlJLxhKMrJbEelzNyotO5JWFunITrlDt2JgqQ=;
  b=nolsnOZBd33bTVmvsLLOAmRXRuyxOOUMo0/5dPI2Tghwvry36iy24lJ2
   A4rl3YCBlvZqkI3Y8+JcA4yqwYudDlq/BSA+0wFl39FfIMHeaU1+HMa5N
   9ncvJN57EAPJuxLZrBuKEjsy3YOwfJFsi0rfGigh35HhStIXqhqrENlEV
   VN0yAKj8AyXO+ReO24HKcR5N/cr9j+fexKyLwodtCfSrf7spAbQribpK7
   lrMJw6vir+g66nu3hMaxH040Mv5tbJ/M7u/W2Zaf0qZqkHCu48L+OD76c
   bVod9iP0xxLGUaZwqvxaJXBocTv2T/9+RvgftJqNCzruvpP0VwEdZmym1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="386977909"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="386977909"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 08:52:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="1094559463"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="1094559463"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2023 08:52:32 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 08:52:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 08:52:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 8 Nov 2023 08:52:30 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 8 Nov 2023 08:52:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cO7kOENloNz0z8fOV29xLbEsIeCw/kme8eWOOH3+m+mq/qgeiurRn1f1O2jh+AG/9nSs6QAWm2lPmSU/Yg7Y/S9aYbQBCv6HlU5AAzpUAWHJMRmgfpSQwNODhQK04dJcQeOWyEN5jVEnx4VpqdPOhhyyty5RU6ZdZvOjATnIjG6qbtgdDeODs3HTZyMHcXCp3/p+/DdLjJhrwLWX+yG1nSp8CnFl1QrNOscQEsPHJ0z4GUzoB7mQiwdkqJDDx9A5t0Aq4WohRlrGteOUA4ulx/uGQdLrFOILEwUxcrb/QHYXCKuPZrzUAqZryezZAzj1ZIohW6Q3W7pjEsO414DpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QL+vHeFtzdzUFtJbbcpk1sR6tCJby6STy48qBG4MxY=;
 b=MLkB7+eskmMaVb062/AxggfjLk4m+Xu7V2LfJrkeSDrLwUEKycgfR3CKis3RZz92svYuvrpizYg/HLE30t6VrkiBRInATdWwU+BOAhNATHGa252OCAsBlfQQq8k1boNEa6YI4BqRtB8M4NRTjUq6Ro5MNWXznYwMv1ztdU5nukJOnwfQfdDUwEta9do7eJ8+ky+BnN1yjN1CeGh56uzHcaLAk9hyxLerJ0IoUkBxu2XnbGlE9GoM0Dbw3n/xO7eBC3IPnZe14g89R9dF5u8CXdkvJ5igzOb2plxgfK4HWL68Y3AHZCAO4QRVuekirmq4Mjk2biQvTEG0XRCQIY/M7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Wed, 8 Nov
 2023 16:52:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5%5]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 16:52:28 +0000
Message-ID: <48b8a6ae-6275-40ca-9db0-86b96cb002de@intel.com>
Date: Wed, 8 Nov 2023 08:52:25 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
	<jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
	<tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <cover.1698422237.git.reinette.chatre@intel.com>
 <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com>
 <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231102151352.1731de78.alex.williamson@redhat.com>
 <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231103095119.63aa796f.alex.williamson@redhat.com>
 <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7f8b89c7-7ae0-4f2d-9e46-e15a6db7f6d9@intel.com>
 <20231107160641.45aee2e0.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20231107160641.45aee2e0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fad20df-0d59-401a-6951-08dbe07b1733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYKZ/yQ+6md0LmH6pjwPARyWgxkRxtPKOFmngs+40koGy6VSorbtp+Zmz/asUV3W/H4pizEvj4VmyPPJR5holX+vx+AY2SQt2dYRQJd0D4aq7QKeVGUi8tsunWeec9QTfA2kKosDlE9uZtn1wLgubXirHnkLUgQWbK8N8PSPgYnqZXMMVqfhgKMsNYYEApsWLYGxuyByUhPzYcbetNFx06bdlIxaeiPa89gq2AOc6ArPnuxM9thHlRG49y6w8VYI7U7NQW+u4MuGvDsEDEyY5OmNSenq5miKxWzAn3qeXkIwg4gMkPNzKPf2PxQT2CbzD0dwBGgcSZqVjqaxzaQVU22O1UK7zsp3QmqYKiNK9t6XZs3P+XT9qITGtU3MZGEmJHUe9f1u0TGhyuDicHW/yxrDJ0YRpJxZtQ3Yxpan0/Pezj1zRl1EDV1+s7PbinOfEfz5uSZivRpgPSePdMTEhud/zQGN6w6GWRQoUSylZWcsqKkf8Tmm0kUvpqUNUMYbB9b+gq4DTENoFSV1bHEXcwe5fwMPTFNeCaaWQqG0675bt9Ei8mUPiJBPQvUUpuqRKbgOFma3IqS71PdhdAaVceLtX6vL2+wAVkyvyRRpcT+EiEzBm6yQZBoTdfDTLtif0kspclLqi/LGhl/g3F9S1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(346002)(136003)(376002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(2616005)(6666004)(6506007)(53546011)(82960400001)(26005)(6512007)(6486002)(478600001)(31686004)(38100700002)(4326008)(8676002)(66946007)(6916009)(66476007)(54906003)(316002)(66556008)(44832011)(31696002)(5660300002)(86362001)(2906002)(41300700001)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzVGTFI3ejNTVHpPRmhRVFNTMGlvRU1zaG9Zd3ZtdTZCUHMvQWRGdnlaRnRy?=
 =?utf-8?B?Yy9HeWptbTkvWnoyZVJkc2RTMCtROUhySXdkR2JNLzRNZ3huWGc0YXdZMXZF?=
 =?utf-8?B?K0l4eWFQUXVzTHVSZzN4eWsxRmdJZnlOOWREWU9qY2RYNHA1aTlPWjAraWpj?=
 =?utf-8?B?UFVxK1EwcU1QYWUvbEQrY2w0K3R6MWNCZ215TU9sbjRLdThzenc1aTlHVThl?=
 =?utf-8?B?YUk3MEV3amJBOSt6RWZMdE1UNFJHVDBxNlU5N3F0aHM0QksvRk9DclFZNkk2?=
 =?utf-8?B?RWFEUnBHbFIzV25aUWNZVG5JT0pucUVwVU0xekVQdjFucFAxcDZOU0pGRjZM?=
 =?utf-8?B?TEdvWEdCNDZrRG5tR0JTR29adk5qTjM2Q2U0VHBKaWtoc3d1VEErWjRvZWhB?=
 =?utf-8?B?QjJOalNUVnQvUGRFZHd6Ykg3ZjBDQUtRMHdudDMxcGJKQTkzQ09ic2QyeFZ2?=
 =?utf-8?B?RGUyN2NxSmxvVW9JNlBram8va2ZzTDMzd0FjemYyZzlQTHRoUUp5MFREb2F3?=
 =?utf-8?B?QnBPZjlDS2FQRzdSZVVsMmxTOEhqaWxNV0tjVFVIT2tvbXM0NjI0VnR1Zy8z?=
 =?utf-8?B?MWZvQk5Td2c5M3NMcVFoUlFqV05sRkl6ZlJqdHE4NFpwSFF3aTJRNmFGcHVT?=
 =?utf-8?B?dDF6ME1oZHh6SkJUb3o1ZDN2SmQ5OGpBZmZhLzRKUXVrT1RWeFFWL0ZTaVNG?=
 =?utf-8?B?eXpjY0EwNnZFUXY0VlgwMlpQait6dWdTM2loS25DeFRGK1JLSU84Wkowa3FK?=
 =?utf-8?B?K3F1MXE4NDZ2d0h6MGY2L29rRXZpOEFnMUJOVXErL05LRkxxVjZ4aEsxem9x?=
 =?utf-8?B?WFpkTHIzYUFtMnl3VjRENlk2aW9aQy9INU1TS1dKQWt3TmpvYnJ2SEVSRGgv?=
 =?utf-8?B?ZVNHTUNpc3ZDZjFXcjRlWWRlYWVQcE1HalRtY0JCTGx1VnlrRUtzRjQvNkM1?=
 =?utf-8?B?d0FLR05GV2Y0aGlKUUtmRUpsWFYxMjlveUpiNjVHbTNlaFF3SnM3RzFiSU80?=
 =?utf-8?B?QUlqSC9wSy9rUVZsaitXTXN2a20yUFM1RExieGtjVGxueXg2YzBmSEFWZFM4?=
 =?utf-8?B?WEQ2enQ1TXdzK3dnWEZvRjBHd2U2YXcyOGpLVFE2c3FyTURDN054SHZGS3Zi?=
 =?utf-8?B?SlJORldOUEgzWmFEUGtDdHRYSEJPK3JCeWZaYmJUanVZckJ6VGEzcmpldUVQ?=
 =?utf-8?B?TVZPUjA4ZWZMSXJBVXBjK0ZueDVzTnAzNlFnMEJUYzgrV2NLR1c2c3Z5YVh1?=
 =?utf-8?B?NStjYWV5YWRrVjhRV0RWSHZJOW55MmVRYytET1BISTZHMUJjcXFIS3F5Rkpv?=
 =?utf-8?B?Q3NUVm5oNHNIcDdaZytYSUtkdkZoSTJvM254UHVUUEFlTGFXN0dSMDNueHlw?=
 =?utf-8?B?dU1aWWFBY1NVS1dON1JteVBYOFZETE9US0tLYXdaV043OGJVdEE4ejMzYWdK?=
 =?utf-8?B?b0RWMSszVkxUaGNCbzVGMlBKTWxQN0Q1OEdmbTNYMTZac3VLRVg2Tit0dlpR?=
 =?utf-8?B?bWYvUUhTck56aW03VEYwVXdpNGQ0S2VSR0dtTHV1blB6Zno5b0tMUzdIS05x?=
 =?utf-8?B?cUl2WmN5ZWFrUjZrRUg5Mk1UUDl5NjU3SFFEWE9IVXpEZGRjQi80czUvZ0xB?=
 =?utf-8?B?bCs2c2Vna25wQSt6K1plQ0pqRktkTW1yNEEzVVY5bnUyMU5UT1dqdDVsdE00?=
 =?utf-8?B?M2lhdU15bktKRDlYM2lnMHZEVEIyZW5RUkVJQjNUR3NHT3BsenNNWEMwR1lw?=
 =?utf-8?B?b0pqZldySkdsSHVtZkx1WGZlU3lEdjhxNzhQaDBPODAxOFdFYVlXa1czTTFE?=
 =?utf-8?B?bmkvWVdVazF0MkNUblBmSEFnQUIwMDF5NGJNYUxRRWhkUHpJSjRkWFFhbW9x?=
 =?utf-8?B?N3MrVXBpT0grSzAwbGJTTlBBMFhaV0Y5Mnhwa1UzNEs5TFhFL3ZXUlBXVUtZ?=
 =?utf-8?B?SldDMjY2UlJLcXR1NEw5QkhpMStUcEV3VU0zNTdGeGszNEhYZTIveHlqdnV4?=
 =?utf-8?B?bTR3WVZkSTdBWmRldjNQcTY0SFZGd3FicURuR2dBY01yV1FSQktXbUgvZHRk?=
 =?utf-8?B?dnpqL2NYWVlDeDgyY1BpTjdmbzk0UDk2Y1h0ZFNzN2VNc1pBMHlXUjVMODlC?=
 =?utf-8?B?SFJrbXZ6TjdCYU1EbDFxNEV6NG4wQXV3cjhTOHZldWY2YTFXVDZKaUFITE1h?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fad20df-0d59-401a-6951-08dbe07b1733
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 16:52:27.9841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsGm2nKvPcQ+CVyYreJg4NYawjQBWTr3/zDQia9kaV26NcfXa+OReCaqcuhP6zdYLSiT3U3DKylQEd1t8diuOCT8yFh6kMf3o7ZNRazMdFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

Hi Alex,

On 11/7/2023 3:06 PM, Alex Williamson wrote:
> That also sort of illustrates the point though that this series is
> taking a pretty broad approach to slicing up vfio-pci-core's SET_IRQS
> ioctl code path, enabling support for IMS backed interrupts, but in
> effect complicating the whole thing without any actual consumer to
> justify the complication.  Meanwhile I think the goal is to reduce
> complication to a driver that doesn't exist yet.  So it currently seems
> like a poor trade-off.
> 
> This driver that doesn't exist yet could implement its own SET_IRQS
> ioctl that backs MSI-X with IMS as a starting point.  Presumably we
> expect multiple drivers to require this behavior, so common code makes
> sense, but the rest of us in the community can't really evaluate how
> much it makes sense to slice the common code without seeing that
> implementation and how it might leverage, if not directly use, the
> existing core code.

I understand. I'm hearing the same from you and Jason. I plan to
work on addressing your feedback but will only share it when it can be
accompanied by a draft of the IDXD VDCM driver. Please let me know
if you prefer a different approach.

Reinette


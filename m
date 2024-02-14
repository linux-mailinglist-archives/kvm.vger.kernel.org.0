Return-Path: <kvm+bounces-8707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E81E855347
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 20:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C612C2824FB
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 19:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C563213B7B0;
	Wed, 14 Feb 2024 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EDaXEJ2x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C164B138488;
	Wed, 14 Feb 2024 19:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707939433; cv=fail; b=YV/D+9Z/oaMoNWux4R0FA83iFlJWI3cVcNyrj0YPnpnyyolS4mpS6Wn9PRk8DnLxvntxddKpmnboJ5ra6YVA6cUniYNJDnTxfgIPMAxGKDVLlds+Hakxd6JrkuGmJ/iCgfXD75UDQkFBxtc+PLyNWTRKuxpOwQ+hj11pc9lbveA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707939433; c=relaxed/simple;
	bh=D6fCW5xDkKDvWGnWxXUnd5KBj6ZuYpZ9Kfrhr6VTrGA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jyy4xQh8bUYSDWsajxglkUSamMJjYXBFeJWOTl2teEEyEkVgaXqRDZGG+JQ+cTTnLl2aM9MyVtyk8wLLfg5jnD4sloOp3S0MJpYfzcXLlcXHCU249Y733jRuh31BR7DjV5EBN9/zMDqFsMVxQbJfCi15T0PN0bADXlSWFzHdMtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EDaXEJ2x; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707939432; x=1739475432;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D6fCW5xDkKDvWGnWxXUnd5KBj6ZuYpZ9Kfrhr6VTrGA=;
  b=EDaXEJ2xJ1KnMPczyhWfggSlSuSM/bjj1Yx1/BFYbzZAXtb745AQN5a6
   6IbJeP60dTbQWWybEvEBfPVI6urhjZt8kOhuqU+za0Aot+QxLlSIMuSz2
   L9ZPUtmzB58Pyk4N445vWSzUBRN1earUkfBPPFqlJjpBcy5lNHX0N6ngM
   NkcOEQ9qwpIX8ux4IIK65Ea4c/8V42ySpFJT0h7lPRO1XD1YmIZA6f9qR
   kbxdyL1bbdsATRZECLPiH6bh89iU11c62O1A3UiJEko/NXvyay1eWLqDC
   hBrwJuZc2cS2+f3VPLYeM5xCRXSggOF6wMxam0oyAS89A1cvzxiBbdsLt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="2145790"
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="2145790"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 11:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="3574960"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Feb 2024 11:37:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 14 Feb 2024 11:37:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 14 Feb 2024 11:37:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 14 Feb 2024 11:37:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 14 Feb 2024 11:37:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNM7ZZaAVC8POCmryiI5cFUCTDc+0dLrNfibPQcSj1K+JmfciRkifrqkKi6rtSJbyURapiE2QI45ixaQBf1TJYIgqMveZRaW98996mT2DFUVW5DUUP02qOeow+HLP5Dmgc17kz3JW56SVZD30GiSf9x0AhEUIgUmJWQ5I9Bkp6t8I3RQamLVyXei9aOmrYJcxNrHN0JafYeYbZrcyfWXZVBn356V2RqkHn7emsGP9yOSX/E91YxodL2Tv+Dtm9tX/t6bPLNv0owDpyNWXF97StKT5rpDEQNsDZjlUmY4/uAEwhB3SrKf6ChhfEyoP8hLAw9zoxfRSy0IRb/cVcc3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYTNKBilL0/KYOUuDQnC7ckj9RgEa2hnWSW8z48jjL8=;
 b=hZQi7FZgeJXf1aVRf9VEl60QC717EpsBkmUK/kdxFtDdioHVvxqAHtsXDduLUaBGWYtcW5ChidO2bx6VtBESdhOrStGokAUKDf+8Zrz1h0s7Y0D/gLf0fHFSjKd79hE906o/7rmM2bQaQWvmqbAa17+c6dDzsPQ/VkOPgsN3ujsz4Opmyxp6Kyf1NKFNkn3detYgXxT5m19Hpt+V5g7zHz3xCzyU1aZWkH1dlzRURWBmNfk7iYJxn3fTvUKNiPGf5sfmbTcHDMNDyHg+C1WR+fqrYBnfakCOPImtNdLNQNN9ub8ABskZzrhPZljks9HXYfd5FZFQedc7ABd0XT17LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8156.namprd11.prod.outlook.com (2603:10b6:610:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Wed, 14 Feb
 2024 19:37:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7270.031; Wed, 14 Feb 2024
 19:37:07 +0000
Message-ID: <51e67264-27f5-4b66-8a08-eda47000bf9b@intel.com>
Date: Wed, 14 Feb 2024 11:37:05 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types
 use same signature
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
 <63ba0079-a035-4595-a40e-8c063b4a59eb@intel.com>
 <20240208140836.76a212d3.alex.williamson@redhat.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240208140836.76a212d3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:303:8f::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8156:EE_
X-MS-Office365-Filtering-Correlation-Id: 740fd5a0-7f2d-4efb-9447-08dc2d94547a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouCjqNNlBkoi0vnMRv+JuiuzisZRdriwnLWuSpTD04LQN69lvuuuhrX+hZ6GlQ9Bl/DAk9U1DtfdFz4BmgJ7pDVlNKbXhvPKbPmCx2o9bocZnffmpqwaZbvfxdzGclzSKasDatzlz77EqQx5Lp1zKZwGJj4fgTjYQFOJc3X3aSp4gel5DxvzcAOfHYmKFqoCau+Ibn4QzQGAzgGjXw/bcQwigQ2xbJMW9ZJhxrrjb52XCjkH3+9eea9BQsc7pF8lA91+6CFLUA/Td3oXcxZT7pxjHi9Rh5lapD26mZzSWEzJ7m4raQnkfriCruY865Ps9dfU04FACS8nDCIeFkvbYhfIbly7509U0/oxv3FlHB0W99zQd1Cp8LehNDXeurYDIwGP0SqcvbZy3UewO4svzwNIgtPcKzsVbU8LlE7U+fdTBmCVAdwL/y7I6i4NrXmCU6uGb+lYUPQd4CSVjLzpe3s4zrFsPQ6Vglm7LUb+akFZNVoLpew98x+xoMvR9VTQl6Y4s3opoY9E8BxZ8rWPDRd6nsgfKwleQuY0e8ZSqsnTYL9CjOwJx2w8i/4pmOS9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(31686004)(6512007)(6486002)(478600001)(41300700001)(44832011)(4326008)(8676002)(8936002)(2906002)(5660300002)(6506007)(53546011)(6916009)(66476007)(66556008)(66946007)(316002)(2616005)(83380400001)(31696002)(82960400001)(86362001)(26005)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXpYRURYenVzZGdmeURsSDVjTG9GWVZOcTUwU29hdkc2Q3ZLQUtmZU1Gd2tw?=
 =?utf-8?B?MHpGamFyUXRJMVloZEZ3bVRWUHhBa1JaUk9XMXM1MzQyMjUyb1puVVVTdGVO?=
 =?utf-8?B?UEYvQUh4Nnc1cUFOVnNwZ1gvVCtscXgxS2NMRm9lWGZVdEdDdlhkNk1yYXNj?=
 =?utf-8?B?NFY4TnBVTFBTUXdYVTZWYkJPV2Z4NE13REFKbUFRVDR0b0k4VlZNNlg5d21I?=
 =?utf-8?B?NjFVb1BkZ2thdVc1Z2prVUs2aTRYQk5IT2tIcjVHTDRLaDdFMEVXTTUyNjM2?=
 =?utf-8?B?MWFKN2YzSFFIajJiRVgyRXI5R0Y0Rm5nQnRVNElZNDJWazZHMzVXOFJZemZS?=
 =?utf-8?B?bGpBY05DY2tqOWZ4K0NGYUNETU9uejlrSTA1cHJUV1VVQktvTG5PaWlvUERJ?=
 =?utf-8?B?NktjMU9qdVhGRkZpZys3bzlnVzdRNFV4VEhNYzVKYWVacnVZYjM0U2NDNFh6?=
 =?utf-8?B?UXNzekhENW9jbGN3bktCeE1DYmlQR1Zsa043MHk3R3V6K0hlOEpVR1ZPYUlv?=
 =?utf-8?B?Qmh4ak5xdk9JNjBKM1M5R1lhY0hvM3hkaG5acUpBdW43MytBenJJa0hzbXlS?=
 =?utf-8?B?ZzB1Q0ZiUmFxd0V4UkVHQ2xPZXAvZ3dkSDgzQWtYenI2ZU1vVXE4c3JLaExS?=
 =?utf-8?B?bjJNSnhtT0hSRDhYQnFCSUFWU2Zhb1o1UUJDdG9lMEVEZUI4a3hldWtOdWdK?=
 =?utf-8?B?NDZLakVOaXpOM1dhZFhveWJrdmtGME85RzAxdGx4NEs3K0JOK0dRNXBwVDUr?=
 =?utf-8?B?aGVna3NITGdBelFZMy9DejRvUHdpSE5yZG1KbC9jVXkvTUdUM3hWdjZ0NnJT?=
 =?utf-8?B?TDNBVTF2c2lMNW0valR5Q1Zia2dxdWViUWd4L0ZlekVpSzdENmhwMkl0MTJF?=
 =?utf-8?B?SHJUb1lERWR1WmI1azMyQm5lcENxUlMwOXFSV3lYbExDdFd1QnF5YktQQjYv?=
 =?utf-8?B?UVpiZExtNStuK0phL3pRM2tCZ3hRS0hpVmtrVTVXYUNmejk4R2UzQjg1Y3M0?=
 =?utf-8?B?MlZQU2N2VnZXZXhJdDFzcVFZUDRrSFFwNTkwUU16Y2FOQUwrSmliZ2l2SENp?=
 =?utf-8?B?NmlxYUJIK1FuZkRLM0w5aGNzSjk0UGNoLzdHNHFaL2E1ekZEYTZSUkRiSHdo?=
 =?utf-8?B?cGw2WWJubDY0UC9ORW8yeWdxVUJIT09GK2JlbDR3WkZrQVlnV0F1TTZXbEFU?=
 =?utf-8?B?Q3VoM0Vkd05iMXdVSVRkUUZKS0NmRVNCVnMxN1I2L0dhckFUc0pUMGtjM2w4?=
 =?utf-8?B?TzJCa1pRODBBQzFRRWFKT0lqSC9SNjNGMEREREE1K0ZyZFJpM0I0ZjE0YlpX?=
 =?utf-8?B?YlNkcGNKUGRMOWlMOCt4ekJxek5uZGgvMWNTaFFPQlVKUUpJY3ZEVEJyTEpK?=
 =?utf-8?B?L0NnTGJ5VlhtRHdKY0dnNmhaZUdGV3pLRXA0TjRPTmwyZFFPRENxbnArVFF4?=
 =?utf-8?B?ejdDdEFtT0s5TEkrblk4eXVSOGVIY3plOHhSekF0YzVmMThHVkpXNk94bnV4?=
 =?utf-8?B?OGhWMDhNYlV6UENzbzBYVjNPd3ROTHAvZ2kyMGhweXRQTTA1enQ1eEt4Y1c4?=
 =?utf-8?B?OHNJT3UxSjl6NXUwWWNjVVpKL3ZScytKeXgxMWZTNVpVb0wxYmYvNHc1RzVz?=
 =?utf-8?B?N2Y1c0JFekpIeUhKdkJXalpQUjRPbk9RZzBrenQ2VG5sQXVHMTEwSTZLRWIx?=
 =?utf-8?B?UklvZTlwSUt6ZG5QSE1RWmhndFBHVW5hYm9udU9Cck82M29DdVl5OHBTTzBF?=
 =?utf-8?B?c0labVRLeWVvakY3aXlOTHpVR2VJUUtuQkorOCsyaWRPdmFabExMNHJQYmRE?=
 =?utf-8?B?dWNHZ2s2VGxQYXpHTCtzdFBhdmRPSFlXWUpBMXkwYitNQXQ1a2lXcU1IK0Rm?=
 =?utf-8?B?MmxUTWVPTGZ3S1FQWGhEZ2JqYkFrQnRNSlZJN25YeGx1SENFU0FPKyt4NEtG?=
 =?utf-8?B?LzcvcDlkL3BjUEFXVERQQXhjOGFsQlJyOTFvWWIxOXZQODRCSDR2UXlTRFN0?=
 =?utf-8?B?eHRYVzhhYW5aNGRxNUoxOWlNdjlpWWFtdFBvNGRPWW1KWlZGQzJ0a0g2UFVx?=
 =?utf-8?B?TTAxSHVRSTA1Ymc5Vmg5ZjNZWG1sdWIyaXRCMEJYRkxvTlNlVUViaFhzWkNx?=
 =?utf-8?B?aUdyN0hEZHl2M1hOSldDcEY2ZVZBcUpqeU85TnV4UTBCSmZnUmxmcmFTcmM1?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 740fd5a0-7f2d-4efb-9447-08dc2d94547a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2024 19:37:07.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtPPnoVZYHhQWg3Gj5LEEv/hLoI4P+j99xrV7T8fnJZfeASK9P5v5wMUfuEjebI8cGGfTDcHgCXszUtO2qFCxtK0g7WhVqCiyIrvEHhCSkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8156
X-OriginatorOrg: intel.com

Hi Alex,

Apologies for the delay. This was due to two parts:
* I studied these code paths more and I think there may be one more
  flow that can be made more robust (more later),
* I spent a lot of time trying to trigger all the affected code paths but
  here I did not have much luck. I would prefer to run tests that trigger
  these flows so that I can get some help from the kernel lock debugging.
  From what I can tell the irqfd flows can be triggered with the help of the
  kernel-irqchip option to Qemu but on the hardware I have access to I
  could only try kernel-irqchip=auto and that did not trigger the flows
  (the irqfd is set up but the eventfd is never signaled).
  I am not familiar with this area, do you perhaps have guidance on how
  I can test these flows or do you perhaps have access to needed environments
  to test this?

On 2/8/2024 1:08 PM, Alex Williamson wrote:
> On Wed, 7 Feb 2024 15:30:15 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:

>> I studied the code more and have one more observation related to this portion
>> of the flow:
>> From what I can tell this change makes the INTx code more robust. If I
>> understand current implementation correctly it seems possible to enable
>> INTx but not have interrupt allocated. In this case the interrupt context
>> (ctx) will exist but ctx->trigger will be NULL. Current
>> vfio_pci_set_intx_trigger()->vfio_send_intx_eventfd() only checks if
>> ctx is valid. It looks like it may call eventfd_signal(NULL) where
>> pointer is dereferenced.
>>
>> If this is correct then I think a separate fix that can easily be
>> backported may be needed. Something like:
> 
> Good find.  I think it's a bit more complicated though.  There are
> several paths to vfio_send_intx_eventfd:
> 
>  - vfio_intx_handler
> 
> 	This can only be called between request_irq() and free_irq()
> 	where trigger is always valid.  igate is not held.
> 
>  - vfio_pci_intx_unmask
> 
> 	Callers hold igate, additional test of ctx->trigger makes this
> 	safe.

Two callers of vfio_pci_intx_unmask() do not seem to hold igate:
vfio_basic_config_write() and vfio_pci_core_runtime_resume().

Considering this I wonder if we could add something like below to the
solution you propose. On a high level the outside callers (VFIO PCI core)
will keep using vfio_pci_intx_unmask() that will now take igate while
the interrupt management code gets a new internal __vfio_pci_intx_unmask()
that should be called with igate held. This results in:

@@ -215,12 +223,20 @@ static int vfio_pci_intx_unmask_handler_virqfd(void *opaque, void *unused)
 	return ret;
 }
 
-void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+static void __vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
+	lockdep_assert_held(&vdev->igate);
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
 		vfio_send_intx_eventfd(vdev, NULL);
 }
 
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+{
+	mutex_lock(&vdev->igate);
+	__vfio_pci_intx_unmask(vdev);
+	mutex_unlock(&vdev->igate);
+}
+
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_core_device *vdev = dev_id;
@@ -581,11 +597,11 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_pci_intx_unmask(vdev);
+		__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t unmask = *(uint8_t *)data;
 		if (unmask)
-			vfio_pci_intx_unmask(vdev);
+			__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
 		int32_t fd = *(int32_t *)data;

> 
>  - vfio_pci_set_intx_trigger
> 
> 	Same as above.
> 
>  - Through unmask eventfd (virqfd)
> 
> 	Here be dragons.
> 
> In the virqfd case, a write to the eventfd calls virqfd_wakeup() where
> we'll call the handler, vfio_pci_intx_unmask_handler(), and based on
> the result schedule the thread, vfio_send_intx_eventfd().  Both of
> these look suspicious.  They're not called under igate, so testing
> ctx->trigger doesn't resolve the race.
> 
> I think an option is to wrap the virqfd entry points in igate where we
> can then do something similar to your suggestion.  I don't think we
> want to WARN_ON(!ctx->trigger) because that's then a user reachable
> condition.  Instead we can just quietly follow the same exit paths.
> 
> I think that means we end up with something like this:
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 237beac83809..ace7e1dbc607 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -92,12 +92,21 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
>  		struct vfio_pci_irq_ctx *ctx;
>  
>  		ctx = vfio_irq_ctx_get(vdev, 0);
> -		if (WARN_ON_ONCE(!ctx))
> +		if (WARN_ON_ONCE(!ctx) || !ctx->trigger)
>  			return;
>  		eventfd_signal(ctx->trigger);
>  	}
>  }
>  
> +static void vfio_send_intx_eventfd_virqfd(void *opaque, void *unused)
> +{
> +	struct vfio_pci_core_device *vdev = opaque;
> +
> +	mutex_lock(&vdev->igate);
> +	vfio_send_intx_eventfd(opaque, unused);
> +	mutex_unlock(&vdev->igate);
> +}
> +
>  /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
>  bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>  {
> @@ -170,7 +179,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
>  	}
>  
>  	ctx = vfio_irq_ctx_get(vdev, 0);
> -	if (WARN_ON_ONCE(!ctx))
> +	if (WARN_ON_ONCE(!ctx) || !ctx->trigger)
>  		goto out_unlock;
>  
>  	if (ctx->masked && !vdev->virq_disabled) {
> @@ -194,6 +203,18 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
>  	return ret;
>  }
>  
> +static int vfio_pci_intx_unmask_handler_virqfd(void *opaque, void *unused)
> +{
> +	struct vfio_pci_core_device *vdev = opaque;
> +	int ret;
> +
> +	mutex_lock(&vdev->igate);
> +	ret = vfio_pci_intx_unmask_handler(opaque, unused);
> +	mutex_unlock(&vdev->igate);
> +
> +	return ret;
> +}
> +
>  void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
>  {
>  	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
> @@ -572,10 +593,10 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
>  		if (WARN_ON_ONCE(!ctx))
>  			return -EINVAL;
>  		if (fd >= 0)
> -			return vfio_virqfd_enable((void *) vdev,
> -						  vfio_pci_intx_unmask_handler,
> -						  vfio_send_intx_eventfd, NULL,
> -						  &ctx->unmask, fd);
> +			return vfio_virqfd_enable((void *)vdev,
> +					vfio_pci_intx_unmask_handler_virqfd,
> +					vfio_send_intx_eventfd_virqfd, NULL,
> +					&ctx->unmask, fd);
>  
>  		vfio_virqfd_disable(&ctx->unmask);
>  	}
> 
> 
> WDYT?

This looks good to me. Thank you very much for taking the time to
write it.

Reinette


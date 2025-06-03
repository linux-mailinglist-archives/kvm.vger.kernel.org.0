Return-Path: <kvm+bounces-48242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD7EACBE60
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B0831890195
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63661474B8;
	Tue,  3 Jun 2025 01:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NN/NtM27"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C972609
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 01:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748915940; cv=fail; b=rm5cf+1mTw7poiICwyo8evtOCBzGxs0SJfHTx2qL3o8R5EZ3GALVxzUlk1HGmRV9VZUR+w5I7PxtfbUh/xk3jc1VkxUtHLlmWhgyMZxpFHVlcaSdguFCyJcabIzqVUkOpQJJaMSUe4301jjeq6fdPTZbWWuBH/mc6ojRSHnM8x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748915940; c=relaxed/simple;
	bh=30dBsEhi9TbKpxfvwwXvBBJbOV7EJyaBNJRZcRuk1Ds=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EodTYtQto0QuVqAw5Id7tnzNzIsojsSUHyTObBK2F71Z7dwHt3sTuucBabu1sVoGbu0ZIGgr6d9AduTuqvyjej8i19awRDL0BRKilQdc8fPT8zFzywEiIMuraCPtmu2lJkc2QfwfGLAVfXh6PG7O3EeCfVqmxS/AHSBUrUeTMm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NN/NtM27; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748915938; x=1780451938;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=30dBsEhi9TbKpxfvwwXvBBJbOV7EJyaBNJRZcRuk1Ds=;
  b=NN/NtM277/bONMMXhlFPz+O2KXZ1FfoRd4gttItU6IK8d5QjT8AmW3/H
   cdl5bpYtDTWGOPdoV7Ulvl6xi8pRMvihu1XO5jvqi2jTv5EKfOvQ/N2QC
   lXmzfD16WSQWZwzRqKSqcJjgeCnj/iE6r/POFDiAjWMgQAekMpyuoqaWM
   RcFoihlyL93VKn8RHNY+5IoJhcHyHdiGxF3dwbKXfWaA3xa5k9fEygPR/
   s87YMqQjLA9DEExgbWJsomsPmvu1pFQoh5F8wpkrUV0s2d8g0qtp/g5C6
   ed667ePIRx6Ml2t5EieeJH2meDx+kIQSniDT3X5TpDU4kz6AucdINcUTg
   g==;
X-CSE-ConnectionGUID: ORuCYt87SoyhjpRZrFiTlw==
X-CSE-MsgGUID: X3jHevyHTuqf/yRfGHgQrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="51084683"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="51084683"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:58:51 -0700
X-CSE-ConnectionGUID: oNEl/rQDTgSS+2dt4GCiMg==
X-CSE-MsgGUID: rHqH8kzMQVqsBXS2lRmr5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145044085"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:58:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 18:58:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 18:58:26 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.66)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 18:58:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MjNzI7HXQ5pJOUSU6VP1XTyRq2ns25FRQaFJCw25uDX56VItLT98lgJNSvbZo0InzA5on8nAyTpi04yl1/ExwCnCDz3aXlOCHcOu/PORZDwIPDWRw31sWlZkRHC3dVqw1G7ni9Gn9o8NpLyP1KIR4nvE0c76GBkzVEhOEXsQxndjRCgfW7QjI5tm8iE2on8DBkNImIhTJ/XvjP0P0kjJ3+ZpSe72lkTcSF18tuLn4SqQE4O5ewgWAW2eBEZZdfJsMGkk4xnmYBAaYxHGqyzn6abdGtPeeOACrvfibvV6koV9ct/5nzR/vrqpdhSI1TNnw+bbj6VwD1i1jWrCsv7ccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmQjCHi5T87pdCHEvLg3VKVBwmYSbERubxn4UUEpHG0=;
 b=h1bgW6+oF6J9vCEIhmJ5eNak265hcc3F9CrPhOBeRriIOFZmgn9NbmHNUQ+3WFx32bcZQKZEBsS9STMhbD976ORRD/sjnWSiN+HrEkS/sHJirjfV+3D3wMDFZt8nj9KjU/TsYKGmb3DHH+mfXpOR0UTItCp1ApK17ah7Ya702XK+ku0PMQjhcHau/emhKlF5QF6rzm2EwTpSu77+LFyYBZcOTVPUeCTdrregDb1gHZr3KrYb5ysdDTiCye67Qj4ZG/QXuCw8+JTpSDEFY+6jdozaZbMKbzWCDZ9wjlwPtHhrgO6s1hGC/KDyiWZUOg/1udBrchBJlMKpeh4BlPjt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH8PR11MB7072.namprd11.prod.outlook.com (2603:10b6:510:214::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.31; Tue, 3 Jun 2025 01:58:02 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.029; Tue, 3 Jun 2025
 01:58:01 +0000
Message-ID: <1bf4a95d-0400-4b5a-be43-18198c850409@intel.com>
Date: Tue, 3 Jun 2025 09:57:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <2278c8cb-a547-4f8d-a8fb-cce38fa3b5f2@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <2278c8cb-a547-4f8d-a8fb-cce38fa3b5f2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU0P306CA0071.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::10) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH8PR11MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: e33e015f-356f-4a25-a483-08dda2421246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Wi82cXZNMjN1RGE3NE5ocGRpdTk4QUZnVW9qbXZaaCs4UlNHMzl4K01vTzBH?=
 =?utf-8?B?emhVL2N2c1l0RTJZRU52d3plOXp0RWFQQWlIMTArQkVtcFMwd0prZ0VQTzho?=
 =?utf-8?B?MXIvVTgrTkxIL1JLbVN4dVBrYVBMeTh6RURFWjU4blFLZllEUlZRWHVObWh5?=
 =?utf-8?B?WVZCQWJscjQ5N0FLZ2QyNlVRSFhFbjdEdEQ1dStCUWJ2QXp0S1Z1ZmNzQS8v?=
 =?utf-8?B?ellKU2MrbFZHT1EzNnljem1IUFBXZ2l6YjFXVFNYZUd0SStvUTA3RnVDckIz?=
 =?utf-8?B?MDRCanNXZTd3SHkrdE9pWVc4WGljYWhCQ2RaR054ZjlkaHQwVmMvRjR2c1hX?=
 =?utf-8?B?aHpycVlBRHBSbmFSMEZJd2FvelJDckdTU1F5TEhMdDVEWEppUDhhcnpQOE1W?=
 =?utf-8?B?YmtXKzVaZFIzclZBTXI4ZzltUU56eEpWdTU1MkxYY0FYaVNZTENUaG4zemtQ?=
 =?utf-8?B?S1oxdEs3TXkxdG9OcGwxaE12T1NpbEpTWWNIL3E1UE91Q3BXcDM2VGhFN09p?=
 =?utf-8?B?Q2lEbjM2UzVjUXJFekhXRUEzYXZ3RjdIZmgwWjd4WUR1REhpb2FrTTlvV2VP?=
 =?utf-8?B?TytRc05pL1RqelJNR1padnc2VXNzREVxMEQvajhEVUhkdUxwM3dmOC9JMVlv?=
 =?utf-8?B?NWRuQnRjUzRkYlJ0eHZFUGtJRERPMWNHY3ByRmptRzlxbUhTQ0Rnd3VJY1ky?=
 =?utf-8?B?eExhVHRHOVRVTzg1cmVqWk9qTzA2cHRxWE5kbTQ2dDQxcjgwS3IyS3ovZi9t?=
 =?utf-8?B?VDdiK2hXZkxTWVhYRmN1RXlvUU5IVjhGcjlkTUU5NjMxaGsxdVBtRDM4WnZq?=
 =?utf-8?B?MDV0MHYrNzNJRVdEQWw2cEFsK1VKcmh5Zyt4a3lpSFQ4VHFqTy9uYjhWdEJC?=
 =?utf-8?B?bmQrSHc5czZEdWVDNzVPSURiQVp0WUl6TWVkeW5IcEgwRW5NYW9wZENkazlD?=
 =?utf-8?B?TzdBdmRRR0ZESVQ1TVhjNzF5ZlBxOXUrejNLQjg2VUROR3g2eDhmRFdiOVE3?=
 =?utf-8?B?ait5UnlOa0laUDY0NmJNMkswOFlzc3JoQTlHKzFYVzVENHMwdVlsWnFhZmYr?=
 =?utf-8?B?Y1h0bXlWY0dzMzcvaERxN3ZaSDdiWjM5UDZqWUVCZFNMdndsNGpLb0dlTE9M?=
 =?utf-8?B?T0Fubld5TWNLckpETlJCVXFnN2dLNDRONSttUjdhTUdyM2hzc2U5clNiRGM5?=
 =?utf-8?B?VzdUVjIrQXRvMVV4anczekw4TnEya2k2SGFzT3J4V0c3b2ZqakdIY0lHMGdv?=
 =?utf-8?B?OUZUanhXOU1MdHVUakUxaDJrRCtxellZaDBBNEZmWVVVSDRpVGlCblNaUEtP?=
 =?utf-8?B?cmZzZTRLYnBvR29VbmNoU3FjSU5EZ1BLRldyWnllYk5LdTQzaHZwVTBrY0dh?=
 =?utf-8?B?UjBKdDc0T0w1TFpkV2Z1dlkvWi95dXErV3phcHFCb0VlQVhwZEtCODFIcDZ6?=
 =?utf-8?B?T0ZLMUt2NlRMRWdOZGN2bFB4THVlWDI3NzJ2QkQ5UUhIQjVpb2NkeWVQblc3?=
 =?utf-8?B?cDJLMHBLd2RoZ1VIWkluUVdxbVdMdWFzcWpYTlB2U0tMYUM3U1prMmh6OHBB?=
 =?utf-8?B?SGdwc2RRcFJBVDN3NEdXQWRMQjEvL0VvMUZKOFdrdW1vREI5MVFzWGQxUGdr?=
 =?utf-8?B?Q3RqYTE5UnRhSnAwcWZQeXdXNUM0azk4Mk5PTi80ZzNtUkNIclpnZWYxRXNP?=
 =?utf-8?B?WWZXTzF6ZXp2eFhENndsV0xtMGdxYVl3MDVNWmRLQVBIZXVYNWExZU9wbmpB?=
 =?utf-8?B?NEtydVhVUjJwZzFKMFNPWkpVb0JZTC9SN0txbVEzU1dUNnpFWHd4SGx4N0Fk?=
 =?utf-8?B?K2JaSUpOWWVFWSsrOHQvOC9DUk81S3dhbnhKSE81RlpkeE9temV2ZVJ2cGlL?=
 =?utf-8?B?UlczSWFGdWVjenJJUnk0Nit6dHZSZzhvM1EzODh5Vmg0SkppMzNRK2VaV2pR?=
 =?utf-8?Q?lDI/QccivLg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTZXclY5ZHViWWxybHgrM25qWFozMTNISlU5UFRyTWFrQ05RYnJnaEp0S3Rw?=
 =?utf-8?B?bHQvMVpkYm0yUzFmQWZxck1wMFg0OURLa01qTyt6VVIyd2U0VVBKdU42Tm4r?=
 =?utf-8?B?bzF5RzluT21zRkpwRVc3RWxXQytUMnhtb1d4UU5MZ01jOHFQRFk2ODQ4Nkw1?=
 =?utf-8?B?NldFREo5T1owV2JTb2RPelgrd3ZHMXRhTFVkRUpMZXZtbmx1OXZ6cTFrSW5B?=
 =?utf-8?B?NTJLc0cwOXdrRmVCT2RZSGZNWW1WWjMwN1JrRkhESHNJalFCYlMyYjdmVkpk?=
 =?utf-8?B?MmRkUWp2b2pTMEtEUU1iaGxGUnpUMjdrOTQvZ2tlbHRwdFJXNzFkZUgvNnNl?=
 =?utf-8?B?cWFhZ0ZhQnpaNmVXY2FCYVh2NFZuR2JhNG1TN0YzaWRSNGhvNVZBNnpDU3M2?=
 =?utf-8?B?WTlFYWthZHQzVHZmWks1aXRJdVpHazQzL1I4OWtFQXF2OVdwL0ZZbWhVYnVL?=
 =?utf-8?B?bFdkdWREU1JqalkycUtKVk4vUXpIbTh0NmFWUTRuTUVTdEpCU0xveGdPU0Q3?=
 =?utf-8?B?aUpXM1lBRnNUNVJ4UmNVOHdTckd5alBRS2RON2w3NVZBVXpyWUw3S3BRWCtY?=
 =?utf-8?B?STJPREZiVW5HM1NvRXJsU1hXcUVNM3pOWVp5WjAzVStGeTI0ZXJvZ3c4aDJ1?=
 =?utf-8?B?YzIyMmlzMldRL1R1bTJBc2drRUwxdEpDajNtMmZlOWZaYzlNYnJCZjZqZWZO?=
 =?utf-8?B?U3JaOThwZHhjQ2ZTN091c0dUVE8vK25oeE1PdlFMUmV5R2EraXlHLzEvT0RO?=
 =?utf-8?B?blhwVmpjNDlId3dMcnJhMG5NWXcxN25JSllYbGJFc1lMaTQxckNRZWZjN0ha?=
 =?utf-8?B?azd3cnJJOXEveVdmK3ViMUx0aGkrZkJTNWJrOGJvVHg4VDRyZTBGNTlNUEVu?=
 =?utf-8?B?YnlUcHRVekc5M0tmUVhzZUYwZlg5amRzWmZrUlFCWmZxQ0szRUFWK2VWazZO?=
 =?utf-8?B?cXRQVUhYcWlaQzhLOHFTc2c0cXlMVkRqMXZCc1gzNnVTWk84eklDeVRiUTRI?=
 =?utf-8?B?MjFJRjBzSnppOWJ3NW1nN29mRkthQlZsVThodExjT015c2M4NXpZS0VlYWRB?=
 =?utf-8?B?UVJNc0dEN0puYW1tRkZseUhMOHMrdmxQaFpFQmFpdW1HYWxXZ1FKM0JpSXRy?=
 =?utf-8?B?a1kwSGN5YzVzZ1h2YkY0YWw2ZHpOakJWcE9VT2ZOSUN3UDJCekVHb21Yd3lX?=
 =?utf-8?B?TWNSdU0zY3N4WktKMjd0MW1rY0ZlSE80cEdsRFNyWkRqTCsvQkQ5Z3hiM1Rx?=
 =?utf-8?B?dlB2UWRnQkZkeVVHYVduTmpYekVUa1Vta0d4Q21UL2FPa3ZuZkRaS0pCN0NX?=
 =?utf-8?B?NkN2RG9PTXZSR253aVpEaFBPVmdGazU2K2RqaFJBSFk5UjlITlpBdTZiTGpz?=
 =?utf-8?B?aW8rbVNiTHBDQmYvc1lEdzFBNGZRTHJiZlRRSkxMU0xHQXlMdU9ZWWN0S0wz?=
 =?utf-8?B?YmQwL3F2OWtNbmJUdU8vTVgrbUUyTXpnWllvTlA4ZHpMeGVaNStVWks3bVJ2?=
 =?utf-8?B?N1k0TnZ0clpkTC9UcnpuQlhjOVNnZmI1cXUycklQSW5NellFTEpSTURhWWhP?=
 =?utf-8?B?K1lzcTdKVmZ3Zjk3YmQvd0I3OTFNbSsxeEhHN0I5dXJuVU1SbFpBRWlUVG1J?=
 =?utf-8?B?TitmWjNZUm9YYi96UHVvWHNNWGVDaVNOTEZnajhPQVFKOVNjMEdGZmJOaVdT?=
 =?utf-8?B?V3h6b2pDa29YUk1KNmRuZjJhdmQ1SDljeDJhQ0g0VXBSNk1MMDFzTkw0QjZG?=
 =?utf-8?B?K2tZdHZQSWxaRStiS3VVa0c3dkxleGt0VEsxSzB6V2l0UXdUU0YvZ2tyQ3RT?=
 =?utf-8?B?RjR6OXRYaEtzTTl2MjBTdDc5OVVyaFRoV0VHRHRaYU84VFdDWVZwRFJrUTZs?=
 =?utf-8?B?QXQwajVmLzN6MitjemNIbDNuanVUSkswMWh6b29SaUFxcThYQjVMV2NxZWlh?=
 =?utf-8?B?Y1R5OTJaMHhET3N2WWNWcGdQQnlBQWhrby9kNFhoRjJFZWw1ZjBIVDFDSmxq?=
 =?utf-8?B?UE80TXMrdVpESzRjNjVBL3NDUTA0YjVTbnh3OGVSWEJ2ZGRSNHV6OHI5NVFu?=
 =?utf-8?B?a2prMjA2TEdvSndJYXRQK2FIRnMzRlpEMUJzTTRhYUFNSkk1Mzdkd0Z3STEr?=
 =?utf-8?B?Z1ZNa1lnTjJIeXdmY0c5WTRLKytuZ0hoUWYwMTlvZDJHK2tMbERTblR2ZEJX?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e33e015f-356f-4a25-a483-08dda2421246
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 01:58:01.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmcEpm/t6I4WiJ5RWM0QVvJlGqy4Wisno2COVNsk/8VUMiJ20TBFeZL13rc0I80gr7TVdpwb6HV+nv91kf+pcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7072
X-OriginatorOrg: intel.com



On 6/3/2025 5:10 AM, David Hildenbrand wrote:
> On 30.05.25 10:32, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> the stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this and allow shared
>> device assignement, it is crucial to ensure the VFIO system refreshes
>> its IOMMU mappings.
>>
>> RamDiscardManager is an existing interface (used by virtio-mem) to
>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttributes to implement the RamDiscardManager interface. This
>> object can store the guest_memfd information such as bitmap for shared
>> memory and the registered listeners for event notification. In the
>> context of RamDiscardManager, shared state is analogous to populated, and
>> private state is signified as discarded. To notify the conversion events,
>> a new state_change() helper is exported for the users to notify the
>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>> shared mapping.
>>
>> Note that the memory state is tracked at the host page size granularity,
>> as the minimum conversion size can be one page per request and VFIO
>> expects the DMA mapping for a specific iova to be mapped and unmapped
>> with the same granularity. Confidential VMs may perform partial
>> conversions, such as conversions on small regions within larger ones.
>> To prevent such invalid cases and until DMA mapping cut operation
>> support is available, all operations are performed with 4K granularity.
>>
>> In addition, memory conversion failures cause QEMU to quit instead of
>> resuming the guest or retrying the operation at present. It would be
>> future work to add more error handling or rollback mechanisms once
>> conversion failures are allowed. For example, in-place conversion of
>> guest_memfd could retry the unmap operation during the conversion from
>> shared to private. For now, keep the complex error handling out of the
>> picture as it is not required.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v6:
>>      - Change the object type name from RamBlockAttribute to
>>        RamBlockAttributes. (David)
>>      - Save the associated RAMBlock instead MemoryRegion in
>>        RamBlockAttributes. (David)
>>      - Squash the state_change() helper introduction in this commit as
>>        well as the mixture conversion case handling. (David)
>>      - Change the block_size type from int to size_t and some cleanup in
>>        validation check. (Alexey)
>>      - Add a tracepoint to track the state changes. (Alexey)
>>
>> Changes in v5:
>>      - Revert to use RamDiscardManager interface instead of introducing
>>        new hierarchy of class to manage private/shared state, and keep
>>        using the new name of RamBlockAttribute compared with the
>>        MemoryAttributeManager in v3.
>>      - Use *simple* version of object_define and object_declare since the
>>        state_change() function is changed as an exported function instead
>>        of a virtual function in later patch.
>>      - Move the introduction of RamBlockAttribute field to this patch and
>>        rename it to ram_shared. (Alexey)
>>      - call the exit() when register/unregister failed. (Zhao)
>>      - Add the ram-block-attribute.c to Memory API related part in
>>        MAINTAINERS.
>>
>> Changes in v4:
>>      - Change the name from memory-attribute-manager to
>>        ram-block-attribute.
>>      - Implement the newly-introduced PrivateSharedManager instead of
>>        RamDiscardManager and change related commit message.
>>      - Define the new object in ramblock.h instead of adding a new file.
>> ---
>>   MAINTAINERS                   |   1 +
>>   include/system/ramblock.h     |  21 ++
>>   system/meson.build            |   1 +
>>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>>   system/trace-events           |   3 +
>>   5 files changed, 506 insertions(+)
>>   create mode 100644 system/ram-block-attributes.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6dacd6d004..8ec39aa7f8 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>   F: system/memory_mapping.c
>>   F: system/physmem.c
>>   F: system/memory-internal.h
>> +F: system/ram-block-attributes.c
>>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>>     Memory devices
>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>> index d8a116ba99..1bab9e2dac 100644
>> --- a/include/system/ramblock.h
>> +++ b/include/system/ramblock.h
>> @@ -22,6 +22,10 @@
>>   #include "exec/cpu-common.h"
>>   #include "qemu/rcu.h"
>>   #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>     struct RAMBlock {
>>       struct rcu_head rcu;
>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>       ram_addr_t postcopy_length;
>>   };
>>   +struct RamBlockAttributes {
>> +    Object parent;
>> +
>> +    RAMBlock *ram_block;
>> +
>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>> +    unsigned bitmap_size;
>> +    unsigned long *bitmap;
> 
> So, initially, all memory starts out as private, correct?

Yes.

> 
> I guess this mimics what kvm_set_phys_mem() ends up doing, when it does
> the kvm_set_memory_attributes_private() call.
> 
> So there is a short period of inconsistency, between creating the
> RAMBlock and mapping it into the PA space.

I initially had such a patch [1] to describe the inconsistency in RFC
series. The bitmap was a 1-setting private bitmap at that time to keep
consistent with guest_memfd and it required an explicit bitmap_fill().

[1]
https://lore.kernel.org/qemu-devel/20240725072118.358923-6-chenyi.qiang@intel.com/

> 
> It might be wroth spelling that out / documenting it somewhere.

OK. I missed the above commit document after changing the bitmap to
shared. I can add it back if need a new version.

> 



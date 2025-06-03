Return-Path: <kvm+bounces-48333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D35CACCD16
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 20:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C45043A67A3
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FD7288C0C;
	Tue,  3 Jun 2025 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gRlozdbA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953DEBA34;
	Tue,  3 Jun 2025 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975597; cv=fail; b=RMU8zFG6hDGUHjL4jPpMsc/XgGWGXRGxNEcuxuqq31st/xCPapiXIfRG1OzT3I+tVnRpW67cIrOhMdPU+qnhgFxKqZwKNesvFiZF/nZYdF/D8cVYiIqyOOHAM5FJeiarSJdUB9LN4dAlRAa5/gkZrD40dz+JGC5Aozs3FvK27Ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975597; c=relaxed/simple;
	bh=YqfungKu0dqko8TH94ER//s0zFsK6oGW1vrHk3JM9Ow=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LCE3xxEAT/OAqLYtbAn6BI1wRw5xPsDGwWR9B6xZvLD1iKeQMQZ9Dtmb2832xq0Pezdfr9boWyQqXoh9qyo+SQIzcBMuWntYpPxrGfb6DUyVJHUJ0mAShf++TQ/O7PvvJZUMAizy9193qCQ5NqDINtFBy971dDW1pdtJuIP6z/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gRlozdbA; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748975596; x=1780511596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YqfungKu0dqko8TH94ER//s0zFsK6oGW1vrHk3JM9Ow=;
  b=gRlozdbALRs3rUVM0uOQKcc60LzpLM7jdmoTVCe7RmlnCpi2R58K/tFW
   CLX2XFcx11pm4Hva6CUiXrofxs7tjZy3SGLZxk4nbvKk2jV7rKdwl8fPr
   L38nL2aL2xwDgg9msG33Q2ZJdYSinO/jrM07WOvlO24/GLIlhZnigAYm/
   1eSQUK9EYkIY7Y+GcAg5gY82D/gJFtaid2cZMToZ/FSr+wD7qvWKnsBfY
   F2FqhHAF25Cu9zCAiGYdJgp0OSH0zp6nQYVN+QUr00igOGlhStuwZcaR1
   UF7epdfaGGHNspegYjZ9HZW8HlegGvIplbrBGHpUKgBMSYq5EQzbeT8zY
   Q==;
X-CSE-ConnectionGUID: tu/jNhEWSJ2JEjWhIh9rgQ==
X-CSE-MsgGUID: Y75Uh0oITRCuIvF3GZ1w2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="54695020"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="54695020"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 11:33:15 -0700
X-CSE-ConnectionGUID: 2XyBWyD4TkeiL6xxrSSS/Q==
X-CSE-MsgGUID: Z6aiwyEtRu+r/T4HBbyg4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="144832196"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 11:33:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 11:33:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 11:33:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.49)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 11:33:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHIIRoGWcKGxfuv+uPO2yV1222FfnfRiR7HaU2nqHV061LT+1K3hdTxg4Tjiac4M5nwVQ5RQLceU/+PGxm7G+162KZGXLJsSHuZSXK/zeHrpcnpU/hNSQCJbz4W7ycTcBxsHE1hNp5imw/wEdRsu8VVqEM/3zDTaqzhrsqK2IkveNH3t7Skoc399cgpWl8lib7RPQ71eI9MmgGj1K8NRhdtNq/igfgSacbdtq7u0iMcLYodgwuVWbGoyg0/KDuOaUrWn41FZZUgVp0sfLfq/Jd9ZGMnoMcDlzDC22gLgkC274viNdm+t7mBjA9tJDN2SmtlV+p0oBezO9LYxd8jJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlyF62OaPF4ewKL2456NLT4fINBR9lzXrMlHX6acyaQ=;
 b=CtluIVMO3OFTyZ1FPzUqy2oBTveP/w1lPmT3waavgOoAumYGjfXx1gD8pvapBdYgYHvB0+FzPWY4d8GDfgRKOtlwZqk2bXNtQ6l71BX+Sk5WcaKC2SGGPneGdoGKlgzY5FfaiVUhjejaMQCHOv2VMNfq/p4+CMLegt/x1MQLf9R+SWUOm/9jYR0FithMVZm+Q9k3HYPeKMxI1GSOEIlQLzdumnBvRzWTp3xfZDz/ZRfClNRrTlV+M/NFikrWaIBfbFjoscPTBoObxrDN0aO5XWGJncxXdctw3cpl0qQbyRisqHlRwg8knq0EC020gGiqdVIjDHX+sFF3XWdSWTtKGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB7146.namprd11.prod.outlook.com (2603:10b6:510:1ed::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.32; Tue, 3 Jun 2025 18:32:57 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8769.029; Tue, 3 Jun 2025
 18:32:57 +0000
Message-ID: <0d9d3317-ad0f-4080-9b24-230b76006d91@intel.com>
Date: Tue, 3 Jun 2025 11:32:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
To: Chao Gao <chao.gao@intel.com>
CC: Dave Hansen <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers
	<ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Kees Cook <kees@kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, Sohil Mehta
	<sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, "Vignesh
 Balasubramanian" <vigbalas@amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aDCo_SczQOUaB2rS@google.com>
 <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com> <aDWbctO/RfTGiCg3@intel.com>
 <434810d9-1b36-496d-a10d-41c6c068375e@intel.com> <aD6Ukwqz2Q5RKpEm@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aD6Ukwqz2Q5RKpEm@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::29) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB7146:EE_
X-MS-Office365-Filtering-Correlation-Id: ea75db3b-48fa-4b07-fc63-08dda2cd0fba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGlNYkhzVm9Ca2NGd0Q1SzBoM3M2QnVmR2pDSUF5cDdJYUtldTFwd1lkbC9q?=
 =?utf-8?B?aHkwQ3Y3azRIZDdtTnR5c1BDZFJlRGM3aDBQMVlQclRGWVlJcFVJdmlZb3dP?=
 =?utf-8?B?WTdRNmZlVzUxZ3pqeFFBaWU4Mm9LMnUwb0doZkFsU2w5SVhEYzdvbXlyQ0hv?=
 =?utf-8?B?dUYyTEF6c3Vrdlc3VmtoeFBRZXVFamFNWm9IZ0RuanA0MVN6MzN2YkpaWDhC?=
 =?utf-8?B?SXIxd25yV0xtUkJmV1RSYStIV0E2NDNFZHo0YmdIS0xld3BEU2VpOUxOM0l3?=
 =?utf-8?B?aHBQRktWeUF3d0ZBb2xycUpQVGY1c0ZremVqUlpGR2hDbkdUZ3lvbzRneHM2?=
 =?utf-8?B?Rm5YeENqVVF4TjE5ZGRuV1pZS0xRVEE3WVRYSXhZTEVBY0hHL2JWcnFZRzE0?=
 =?utf-8?B?Sk04VGltSm1RQStwaXZFNFNnYXNKcUxVTGIrNlhoODhXWmZjQUcxOUVrZTgv?=
 =?utf-8?B?VVNhOGlpZU1lMEFISHhvTDZzNWFtUWt0Sjl5SDJlTGQzVHV1VUVZQ1A2ZlQ0?=
 =?utf-8?B?L2wxVWlvLy9XdWVWYVJwMmdTRzdDcXhUOG56YmRJYVhnUHVsTWJTK2RYbUlK?=
 =?utf-8?B?S01FRmhZZ2xDUjAvN1ZYYjJLeEdxWVpweGI4bUxBQ3FIM3htcVhPa2d5YUV1?=
 =?utf-8?B?TGcxQWFRM2pIZ0dGQzIxM3o5YzhoeDVRZUsvZThrRG1XZ0tXaFhlVGxVQ05y?=
 =?utf-8?B?T0JnN0xNNkJKbjREN0l3OS84a0tuZjQ5a2hsQ0dJYmJ3aDFXOTJkM2FBSFBU?=
 =?utf-8?B?TzRHM0NacVpIUGh5emFPQ2RqSk1USmJlVVIwUTNuWnlsRk1pSyt5NDByaE9s?=
 =?utf-8?B?a1hpRzBlMmpxUDc3WW52K0ZvZ0F4RXZzNE1hMTJ4RmYzRTkraEoyWU9nVXN0?=
 =?utf-8?B?azFTS1lUcFFWMFk0M3hSamV0ZVI3dVhWcUVSYmc0bk82NzdBdGlWWjJBbndk?=
 =?utf-8?B?SWVwd001ZnBSNEJ5NG94c1JLSmJkeTdhRjJQK056cTUwOEdNVHFPaUJUMTQ0?=
 =?utf-8?B?TVB3VDk4RmVqbG5QclZ0em1RdHZ3bVBaTXFlcEhFc29Ud2xQb3BJaEhzVk5y?=
 =?utf-8?B?UUN5QnMyM0NyeXBWdmpNM1kraW96WFl5bGxrTzUvMGpiNU5adkdoa202UUlq?=
 =?utf-8?B?NlMyS25xak9LaWQ5d1pzeVlSTHJCeFhrbHYraXZWSWlwOG1rcVpId2RtNkRN?=
 =?utf-8?B?TjQ4Um9yVVZsNGpnRGRSYmtxaTA3eERUMFE1QW1zazdzVnl3TEV5NzNsSXpL?=
 =?utf-8?B?bUVjOXlpU2NQTkk1My9ENG4zalFhb3ZveGtUVUk3dU5EeE9vMlYvcWR2TjZn?=
 =?utf-8?B?ZHdQZ0g0bllOeldaZVlReUUvd3d5Qm5OMExWVjBnSlBTeHJxZlZ2NDNJa2tt?=
 =?utf-8?B?TXpLNnFCSUpkR1JyN2I1TDRKQk9WWEhQZ0RxQVdsUm1ZOHNkb0pvM3NUWHpX?=
 =?utf-8?B?dTlLd21YTzJHMVhIY08zd0o5MXlVb0pjT3pZWmlZYlgyZTljVEVKUC9rMmZB?=
 =?utf-8?B?OWU0VEcrODlEREwxYy9wWVZxR0VYTDVPZ2hmZUxSVGVJNUJnUXFSV1F6M3RF?=
 =?utf-8?B?cFoxa0hUUllFSy9XY0hCV0lQSisxV0NFL2s3T1M4OTRCbnVGVTBHaTJ4RURq?=
 =?utf-8?B?QzBvajBqM0Y5TlpESDJUcWUzNlBPRFV4MFlsMWZPUzEwMEFnOE8vRUFnWU1Z?=
 =?utf-8?B?akUxWjZ5ZHZyekVXUkVzUng4Vzd1amlrTUxTcUpEU3pDNDY1Vm00WDk0Mlhv?=
 =?utf-8?B?S0NxTmxKR1cvM1J4ZUx1dG1RTjZqSVNaQlByODFsREhtVEdVMldkeVlRdEl3?=
 =?utf-8?B?SnFkR2Zoc3NlSXlUNlhSREFrUFBaODIxVThoUmZnRFkyTFF5MW1kcENVWXdZ?=
 =?utf-8?B?RDBzemxGdVZER2g3QkpNQ2loRWNOdTZJOGxzelJ4TTlqbVFCZ1dCK2NhWnRr?=
 =?utf-8?Q?nelS/67bkLc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHgvWjNEWjVLUlRzdFhsZEZCVUhiK003dmZ2dFBEN2xvVUh4eU16U0w4YmRU?=
 =?utf-8?B?elNxcDE5SmdRa29XRlRSZzRzTW9Gem5zYXpYTURia284K0IvM0swUkVPU1dT?=
 =?utf-8?B?VXBaSXVlc0FocmZzRUJNSlpsbDFKZFY3Yk1LUGlqOUJQT1N2cjJTdytoNmpz?=
 =?utf-8?B?ZzIxMEtBYjJYZzJXNW9DcUdzc0kyY215azNxRDRKaTBjRFFmVThuTi8wSlNp?=
 =?utf-8?B?ZDdCU1Jxekt6eTNoMFZOVmNXcDFvWUJXYmxrc1VHcmZiaFFTYml0R2htL2FG?=
 =?utf-8?B?OU41MzRKQjJhVWNJYjBvOHdEM3BFZVhLd2k3ZkE3OU9jK1ZZSU9OVU9qRVJK?=
 =?utf-8?B?NzdneHNPVlJwczdvcGRIVlFLckJZMU1Rbmd4ZVRSYXhJRGY4ZjlkVkFoSUVK?=
 =?utf-8?B?RHAzTC9taVpEVUFyR0JURFBtU0pQWEMzdG4rSTdoRlZ1UGIxMm9HZ2Npa1BT?=
 =?utf-8?B?SkJFZi9FRDRKMUo1cVg4ZE9sZ0xIc2VWZDVZRnMrcHAzb3BpQVI3encycmRo?=
 =?utf-8?B?T2IzT2JUL2l2WmJwYis2QnJkdHk5UHZjK2c3ODhJa2Q3b1hzQmtxYTlUZXhB?=
 =?utf-8?B?cWhFM3FWdXhWTjRUVDZGWmxCUzlESkhqVjdha2xtMEpzRjJwalluMmJUbHQx?=
 =?utf-8?B?ZWs4TFFkaGVNTXhyTjVlQkZyV1IvaHQxN0pNcCtiYTZTYXozZm9DTFg4eWFt?=
 =?utf-8?B?SkE4VWJwSllQMjhaRm1GVGs3eGJpZnppc0NYYW9CUWRzdURtUHVsUER6UUp1?=
 =?utf-8?B?WlRRV01YLy9VU0VBMzNrUUhXVkNvWkZmaStOWUFrODA4WFArWWZTN084a0xE?=
 =?utf-8?B?amI2SzQxL3h0elpFK005MVJxd2hFZElxcW9nVFVsek05eFNOT045MDAvQ2V2?=
 =?utf-8?B?YmlTSEFxS29XZFczZ1QzS0M3NHd1WlM5K3phVG5aY0VIL2IxNzJtVmw5WE9E?=
 =?utf-8?B?bUlETEYrWnNlc1FaRi9HOXpUZHFUK1dHRHhnMTV2SGdkb1R4cmRRMTV4NFBy?=
 =?utf-8?B?TlVqeHBGWDdPYTgySndZNWcxcStzbnU1TXBzeHA4QnpGYXFNWjVFQXhBd3U0?=
 =?utf-8?B?Z1BwR0gyM2ZFdWlzQ3crS2psaUxpQjZmQVowNzFjcVEvSkwxNHl5dkNESU9Y?=
 =?utf-8?B?QXliK2k4OHFmMnVkUjFLQkd3TnBsK09qQlBzRTRySnpZLzhyMEh1czlDdEJZ?=
 =?utf-8?B?VGNrRDloSFVNK1NIVUlxNU9WVXpZYlczNnJYaDJGVnVtS3RKbHJ6cTYvaENO?=
 =?utf-8?B?NGVLQ3VGK1JSMXVYWGEzV2hLblhLZE13TkFJUmpqbmgzK0lZQUVyTHdsR0hy?=
 =?utf-8?B?cytpT0hHdHdvcEhmUUNYWVlZcnAvTXYrc1YzRk85RVgzMFZKekNWdk9ESE9o?=
 =?utf-8?B?TlJOSklnRnV2YWtCdVlQRFNtaFQybHBVcHd5NlNEU24zWGhNeGFyTzhYWjNv?=
 =?utf-8?B?K2N0WE1KVmVCeWlpWWhhRFI3N1dDNnV2L0tEUUhTNUNsVmY2TFdNSEVXcTlV?=
 =?utf-8?B?WG1KeU1GaU4zU2JKVzB2aGcwZzJBeFcycVJjQ0pRK1dtcmZtVVpaWXZxdVB3?=
 =?utf-8?B?U1A0UENRcUpHNEl4eFVqZk1PdllnM2JMZW15TmpaMDRyeGNmZnlTWUVXTTJo?=
 =?utf-8?B?eW1tQjRkbXBFSlFQc09SdHYwV2lkbldMcU8xTjZwcnlLUmVpMEIzWm5UWEJE?=
 =?utf-8?B?N1M5R1RGdmFtQlJBTURSVkt6WXFaL25IMWEraUV6MFNzUEtsRUs4d1JyZkE2?=
 =?utf-8?B?RTRHN1dPSEZ0R1hGWHJkdkpDTExkMEIwbU1jeVU4L3pZZlBJZTBkZ3ZuSEpV?=
 =?utf-8?B?SHRid284STFETmt5b2crRk1uVk84R2puSUdSeWdFOU1zb1AwTWFnWS9qY0Jy?=
 =?utf-8?B?OTJtai9Yd1V2Qk5nL3F4azlpN0g1NHhSOThsK2VYckg4MHFhUmVRZmJJeWZ0?=
 =?utf-8?B?aXRhZWFCeTArSDNXbllrdWlzUVYzSmE0bVFJWDNFa2ZVZWdZT3M3U3FqV2Vn?=
 =?utf-8?B?YnUvdkhDZVpudk5IaXo1RzZLd0xUTTFYN2ZIREEvRWdGZjZBaCtrVkhxRGJp?=
 =?utf-8?B?dzVXL1d2TXh2azFDZTN2dUhTbTBLcUZ5WlVjcUhGSzlIOGdKZEhTVHdORXE4?=
 =?utf-8?B?cFEyVWgvaXpYRTFrLzIyU0s4MWExTy9rYjBObFZMcHpIa0VFaVRpWXowR3BK?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea75db3b-48fa-4b07-fc63-08dda2cd0fba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 18:32:57.4833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvpQ+1WYucgKcy4TReZSYUazHnoX3PryzGTW5iShyQa+2VvTQ68sfFw3sw1tzkL8CD5uYyH+g5SiY/VMF6T3BDtHm3oiB1tk6pjkt9yKh+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7146
X-OriginatorOrg: intel.com

On 6/2/2025 11:22 PM, Chao Gao wrote:
> 
> Aside from the splat, task #2 could execute AMX instructions without
> requesting permissions, but its AMX state would be discarded during the
> next FPU switch, as RFBM[18] is cleared when executing XSAVES. And, in the

Right, AMX instructions can be executed when XFD is disarmed. But in 
this case, it's inside a signal handler. On sigreturn, XTILE_DATA will 
be reloaded with the init state, since fpstate::user_xfeatures[18] is zero.

> "flipped" scenario you mentioned, task #2 might receive an extra #NM, after
> which its fpstate would be re-allocated (although the size won't increase
> further).

Yes.

> So, for well-behaved tasks that never use AMX, there is no impact; tasks
> that use AMX may receive extra #NM. There won't be any unexpected #PF,
> memory corruption, or kernel panic.

A signal handler is expected to stay within the bounds of 
async-signal-safe functions, so using AMX in that context is highly 
unlikely in practice. While the issue has existed, its real-world impact 
appears quite minimal in my view.

Thanks,
Chang


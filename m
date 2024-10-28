Return-Path: <kvm+bounces-29899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0A09B3D3D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AC8D1F21B7E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 21:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C1B200BAE;
	Mon, 28 Oct 2024 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOIO3DzU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04772003D1;
	Mon, 28 Oct 2024 21:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730152251; cv=fail; b=XVW3U/X4tEJrAln9YtwvRfiScLmaTQF6+oPDEr/Q6kcfIrEHKnXiFxC0MQZEyvHJK9WiOI98GABjoMJeUg41GfsvF5myvDDp5/PUyw3bVRqFrRDUoBYr2sm8cCpO8idaOocJD2LDN4RdOzxapBQWhLgRgdTljDKfkfKZrK7BfZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730152251; c=relaxed/simple;
	bh=UVzVnIg+xAcTIE+aVG36trTjyFrqURYQYRkKpbMSppg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=utWs98pxU6huCLGW3qknU0w99OXH81J1KrjHixxlA7Jk5qE5ZDsSRbdbIMHldsX3e2HH+z4hiYp//OmA1rd1BbJmWlKMDGVRQP18vX/WMVO0EIa/SmocUmwhH3eHXe0tR1X6gpdYMDCEpyQw3SI5q7xZoh01tp7NBlKkNL92Z+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOIO3DzU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730152250; x=1761688250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVzVnIg+xAcTIE+aVG36trTjyFrqURYQYRkKpbMSppg=;
  b=gOIO3DzUHvntlZv9KEyYFBgtTu6J8crY1NSL+qJqOmYqtDQ2+pxXyZKC
   bDcQtNNbKyNLztD2DnpjKpkFM2vivtC+g6NwMQk5t04vmq2u0JdIW+Rns
   Tzy7YotYacP+FmS9XZ24q6/csKWPk+D4Ttv9s2RHcJ9/mtaQVxHkuSzQ4
   vj8McPxZkyP9w25J3k5uTFnBEgXnojIIXht77N4gIpWIcS4g+PX+GbgdJ
   t+6rHdhA9xw4tNtvbp9mqsI8i2b3lewThMHTkTMKiYoAYU7j+UeQKh9hc
   xipGKrpX+ypjP0ZJBOS3zySIz/rwkYJ/sMUyQ+zcptrKWRapKX1bH8fYM
   A==;
X-CSE-ConnectionGUID: hlY938H7Qi2fAPJql9uD8Q==
X-CSE-MsgGUID: uNKGJO79Sbu+m5O3H3dzVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29630634"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29630634"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:50:49 -0700
X-CSE-ConnectionGUID: /e4+9d2WQHyuqJG8+6k+JQ==
X-CSE-MsgGUID: VSQM1DqcQOqsN5xo7WM3ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="81679010"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:50:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:50:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:50:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:50:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxJ56WuqjPZeAXPfoq+o25toGjuVT/RD5ZKPIR54qfWSPgGhksyZz/vUfijgrpWdmD1LGmP31KAtkO0EGnS1jS2eAB7OBL4xy6bAEWjKtJ/EmRmjjAIUfbMETHy7Xf4CANMp71qoG+tPBAAjBGCDETatcUqLogz0MgURrh6+aTF7ZpDtmO5o65BLgNXU5nkvFgJXZLoAq9o3aPA+7bjrsl7btRDexclSseX2MWfHhIa5ib9GyfslohBJpLp1RLr83JqNJXOnmpZO6e7dwQU6xvGIIDBO9lvzb279+lBP3LJ2IQoRwIsEUimL26WMzgZ+MMrHwE7H49/6utE7O7DflQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjQ28TPUNd6yBO+5fuFyjRSDtIlx+toKpbuZR9E75tE=;
 b=d82VprLBP+k3LAzBwVKYwfx04n+c3Ul2BSmT05C7V0B/QfW4WYWQVCRYS+eHv3LA/6Dp0kFjQ7U8lCZuD8uZ6d71xwl4PkyCD2evqxfESfm3k2f5dh4Dt7Ci6ilcaadmIYwQURfqEJfBHnJF1AvlqmjGVkpBwykd8kC3V1bdLsU3yDyonkKOflhcLnHfWHRqgdFNV/cD+tKA5IUzdzRPmhVgsVUKj2eHjM8s4yRo0mboyp2A4StB7YxYNMu/pq2t2kAKv4jM+mE32yYhiotxA0pGCt7DGFAmZNw3qGneN8p4BWHFi/00oBa6EQ1xAa2cgYMpXWuJAZ/Qv/H2zZrqWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7428.namprd11.prod.outlook.com (2603:10b6:a03:4cf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 21:50:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:50:45 +0000
Message-ID: <0e9bee06-0588-4ffe-b1bf-c5c4a5ee4983@intel.com>
Date: Tue, 29 Oct 2024 10:50:37 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Paolo Bonzini <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <e8677ccc-e25e-46f9-8cf1-e3ff8d28887d@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <e8677ccc-e25e-46f9-8cf1-e3ff8d28887d@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::49) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: ca0729b0-16c4-4f49-7080-08dcf79a937c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eVVxNTJhQzBieUEzK0cwU1ozN1l1SjVZTmYyek9vWFhrcHN2Nm5BVmd0M2pv?=
 =?utf-8?B?VWt2K1FyMEhOQyt5MU13MjQ1dTlCSTVHaEFpTVRLSWh6THVOeUE2MmRoMkFI?=
 =?utf-8?B?US9hZUd4SkZLTko0dU40MzhqWHVYSXlKc2RxOEVzdS85RFhvM0JkWGU2SWo2?=
 =?utf-8?B?cm04QnhFRGxIMEJ3bFZraGJtcVRVTWVRak1mKzFaOG9VUGFyT2hya0JFbFRF?=
 =?utf-8?B?aktRZTI5TjRGZ3V4SjZ2dFFYMSt5MzVLOUhQb1N6N0ZsekJ4VmpWaGt3eHA3?=
 =?utf-8?B?Lzl4N1M2SEpEalRtR1U0L0QyOUwvSDhqUE83d1JMV1JubkhVbDdsK2FBcVdE?=
 =?utf-8?B?Ync5b0gzVlRib3RDcGFqM1FaODZBL2VvR00ydGMrU2RPaU1VTjZ0YVp3Q0tU?=
 =?utf-8?B?OHZjMCsrRzJDV1ZRUmZVVGtJaGZqcTdVSGJBRkNlMUR5cWMvNkZ1S1J2ZHFv?=
 =?utf-8?B?bkEydFlpY2VmZ3VyQTg4aWVyeGpUbVIvQytyNjZMMWNDM2Z3RDJWalh1U2ht?=
 =?utf-8?B?c1pRQmw4UVNtaDZGd2FWSkZQK2FWUW1HUjlBUWxqam5ZVS94dDNVaElIaUt4?=
 =?utf-8?B?MHMzaUtJSlJXZExvZlV4dnA0b3d4WkUvK2NKMXRzS0lndllKS3V3RWVIMFJX?=
 =?utf-8?B?NzVGNGhwbWU2emV6YmgyU1ViWUF1RFY0ak5zRDd6aisrOS9vUXVsT3hPY0lJ?=
 =?utf-8?B?dHprSzFwT2lNZ2JuaHZJLytBYlhuaFVRY1F3NFZiY3hmNVdjMTZoRUl3R2Jl?=
 =?utf-8?B?UURMaXMvVlhFWEEyY0NacWhpUXV1M0lISUpPMmlURE1ENlZyU2R3NHVxZ1BY?=
 =?utf-8?B?RHJjL0hsb21HeTViZEQ0ZjlpRE9weGt0UXlEK2c4TFFIU0c1c2lIa2crUWpt?=
 =?utf-8?B?T3NkaXcvclE0b1lZYTZEWDAyd1hzTXd1S2pqVGlrUjVnaUFxc2xBb3BYdUlh?=
 =?utf-8?B?TFBVN2FxcDRTaWFscU9vdFBOTy93VlBXekhyNVplV0R4MHpVbUZZVmtHRmFw?=
 =?utf-8?B?MmRNOTVaUGhlbHgrNmdWcEFCcHVQS0hFNGY5d3U5RXdvMGxZWlVZRk9ZaTAv?=
 =?utf-8?B?ZFVUVTRlS0N0aEhPSk4yNUFxL1RGT3FJSEJrZ3Q4RjluVFJjeFlhYXRBNHg1?=
 =?utf-8?B?V1J1Sy9EU3UwY0dOODhuRzQ2RnBGNlJqeWFkV3FBa1d1Tkh4Q05FeFVwTlVw?=
 =?utf-8?B?cnVobHU3ZC9Ra1Y3VFB0RXhhVFNDS0VGakVlNWVhSkxpY0x1MlBYcjExYy83?=
 =?utf-8?B?MWF6bmVqUUYzTUs0WVBqQzJrT3Rub1VBdXd6UlZ0ek9mM0g0STh4aU1PcERW?=
 =?utf-8?B?dTVoZnF3alVUTGhraGpSY0R6VzBJWWNtanlYOEg3QW5mQ0w2cVhSUGVvMzhS?=
 =?utf-8?B?bzBpNDhhWWhBN2hHRFduWXBJUW83Yi9zQ1V2RlN1NkNJeVRSL1NLRXFqWFM1?=
 =?utf-8?B?TTdJWUh3dGQ1eGpzaCttSE1EdnB2ZVdsak16YlV1d3pOMURnekhZeUlxUzJ6?=
 =?utf-8?B?V1huWHRWK0FKbkMxT3M3MzNJTlB5U2NVT3ZUbjQvZzh6Q1BDYnFDU3VDV3B0?=
 =?utf-8?B?bnNndHJuSEhLdmJQNDNwTStURmZHNDRHTS90YmF0V0R6Z3FHWURWY0YrZmZy?=
 =?utf-8?B?bkl2M3dYUEpIb3Nvb29aQmd0dHFUSldVRE9QZXFFdy94WFNKcVg1VGpKdkpF?=
 =?utf-8?B?SEUrNG4rRDRGSkdXWEpvSGIzWHBSL0VuRzJJSWhxUitTQVNPZGxLb0NzaEJ3?=
 =?utf-8?B?NWVZeTJKME5uak15bGo1QkcxZ1JEeXR5UEhzVGlOcHdhODBOOThYcnhmbzN5?=
 =?utf-8?Q?hHleE+hFYsg8QoC38/c7x6q2KqHMAdrV2IunI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUdJcHpiS09mU0RLNzlFOTZFSk5lVUlBU0Z3QmtCSUt0N0lRLzNvdEFjVkYx?=
 =?utf-8?B?M2Y3bE5BOXlWQWhTaXZHWnR1V2U0NEtZOGJJdURJbHpSMHIyWGQ0UjRnNzJw?=
 =?utf-8?B?T0o1cDFKZTVQMjR6RHYwM00yTVVpS0Z3b0U5c1FVRWFRblJZaWwza201UnB6?=
 =?utf-8?B?MDJ4S3gyVWpBb3FLQ0JtMmVDUjNDb01CYks3M01KK2IvZTF5Y1pVUGh2K3Nj?=
 =?utf-8?B?ZUgreGpFNUFFVjB5VGhob0ZzeVpWekQ4a0tMSzArRVYzbFVlMmJadW9lMlgr?=
 =?utf-8?B?VlFKOXBWeHFvZlNmRElkb095OC9SUUlBVUZUeTNWbWlqR0ljdXlCajI5ODdy?=
 =?utf-8?B?QmhhR0Y3UUtkMmVNdW9Iai9MTjk3UFJwQTNGWWF6bnA5QTdxNEt0ZHBSeGR5?=
 =?utf-8?B?b254YWVVOFZlWkVaa1owZytvc3pEb1JDR2t2a1lINkhlYXRySkJhN280ZEtu?=
 =?utf-8?B?dnJwRjJ3L0hqN0xBaTZWMVJIU0RTaitKeEZ1eXJBZVIzbXJTeCtzcmQrOWdP?=
 =?utf-8?B?bEVrTk0xVmFjWDY2U096eEJlN1dobmxjVTdEV1FLNGF6cGprUFIxckxNODgy?=
 =?utf-8?B?dTBITnlNeG1yQTRtc1d0M21vQ1VHSGZ0NkdudFNTY3hvOU1xaDI1NXliMGwy?=
 =?utf-8?B?bmpiL0ZLOWxmYVlnUHl2eVRJOWFEVzMxdTdzaCtvKzlYMlpLVk5jTEVHMGE4?=
 =?utf-8?B?S2V2bzRjOS9OdTJ2K0Rib056Y1hBbjgzbTltWmdaRU9MUGdHSkZ4S1lweDNs?=
 =?utf-8?B?LzRtQk1FRmNoYzNVby9QZGpXT2ZVdlk4cmV6STdUbTVlMlY3NUJWS2wwS2Fw?=
 =?utf-8?B?T01yYmw0N0lML291OGJacDhKcTlPaUUvNVV1SDA2Q0hubjlzZVBLbmVhV1Va?=
 =?utf-8?B?YlRkanA3OWZhM0ZvTXFBYld4K0dSQkJ2dVZjUVNXd1o3a1I1RXUrWTFTcG45?=
 =?utf-8?B?MDJzWWpHTzRGZXZ6ek1wR0cvbnI3Qmh6OW1ML2RBNlY2V2Y5VldobTJUUVlZ?=
 =?utf-8?B?YzVlaHQ5Qzh6MllZeWNvUHdXYU9VNklMTmJFOWVUckFYa1lHdEJ4NWFpcUcx?=
 =?utf-8?B?ajZiSEMveHV4bnhsV243RFpOSXVreFNOUjBLRUU1Z1hTTG00TEl5TEczMzhm?=
 =?utf-8?B?SDM4UUd4SThhbVJ5bUhlWHFtbWhRR2hUMHl6ZUNCWTJodDZPVktzczZaQUM3?=
 =?utf-8?B?d2lqZ0dyazd2OTN4bm1COWxXU0NFdlk3VW9BeHYxTG1tWlZ2R1VQRVBDTHhP?=
 =?utf-8?B?K2tOQkdPeXZLQURxdkNYT2NaRFdSRXd6UG1Lekp2YWhMT1BHTmMwOEtXeDc1?=
 =?utf-8?B?bmorWm1pZ1RRTGRLN0dQaGFkUk9OcFE1TFVDVlY3NkJXRXVVNzFBK2srb1pG?=
 =?utf-8?B?eU5WVkY2ZXdHTG1qRTVDUjgyQWRYL1VBZmlUYWhBUXc5eUVFUTd2UnVGUEx0?=
 =?utf-8?B?YTcyOXZLQVY2M216dE1jcUFmODk3aEZwNGNuTzU5MUJaQkJwczIvVkdVU2p4?=
 =?utf-8?B?TlUxWk1JYVFhT0xKOGlndTdDbS9RY3plUC9EU1NmdXJrRDVrT3VwWWo3dnVE?=
 =?utf-8?B?SUliTGtwY2dZY2RlK2k5UW9KRkNwWldqVHF2ZVYxaFcyQy9IczJiVVF2RUZ1?=
 =?utf-8?B?K2JVdVVSNUtxcVlwSkNsYjJGditWRVdySzRnTkdtRXNJZVZIU0c5aU83SzA5?=
 =?utf-8?B?bEZTZk9jR09mREl1WEE1UXFGUm5ERTNNTk1ra0hKRkpsUzNOb3hBVUNTZGRQ?=
 =?utf-8?B?ZzlQbkorQk1leHBaK0gxME5TSWwrUXBqRE5hY25nb3dzMkNRY2J3cDFOdFdw?=
 =?utf-8?B?MFNQckNFeis2d3BNUFM3dEx1bEUvNVlyNTJUdkpkYTJGUTZibGNYc1F4VDFz?=
 =?utf-8?B?K1JTaTdCSU9ML25DOUljRkNtaUl4S0tNbGhidGlsMEV0amQvenVpMWZyRDJX?=
 =?utf-8?B?aU1xQVRWTy9zY3ZLZitKNG04R1QxamcrbEloL1N1dk1GZE9sWVowSkZuT0k0?=
 =?utf-8?B?Q3RtZnRmTjhpTi9Vb0FhZlQySng5VlBCbi9kNGp0MzQ5VEEyWmtTZ2hqUlNK?=
 =?utf-8?B?M2JnbElsdjd6bWVvUGF4ekl0S2xDOHdTWFpYNjZoeUMwQzZyczFwN2NQSmVM?=
 =?utf-8?Q?MVEISTflFVu6GrTgNCG0syNax?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0729b0-16c4-4f49-7080-08dcf79a937c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:50:45.3233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivv2xLpXSxixgwQK7flqImOR9VYGI2uGzl9njx7aVSGdjcbvN70ahl1rGyVbcKdyMnaS7lXDH5VEn9GJvl05HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7428
X-OriginatorOrg: intel.com



On 29/10/2024 6:59 am, Paolo Bonzini wrote:
> On 10/28/24 13:41, Kai Huang wrote:
> 
>> v5 -> v6:
>>   - Change to use a script [*] to auto-generate metadata reading code.
>>
>>    - https://lore.kernel.org/kvm/f25673ea-08c5-474b- 
>> a841-095656820b67@intel.com/
>>    - https://lore.kernel.org/kvm/ 
>> CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/
>>
>>     Per Dave, this patchset doesn't contain a patch to add the script
>>     to the kernel tree but append it in this cover letter in order to
>>     minimize the review effort.
> 
> I think Dave did want to check it in, but not tie it to the build (so 
> that you don't need to have global_metadata.json).
 > > You can add an eleventh patch (or a v7 just for patch 3) that adds 
it in
> scripts/.  Maybe also add a
> 
> print("/* Generated from global_metadata.json by scripts/ 
> tdx_parse_metadata.py */", file=f);
> 
> line to the script, for both hfile and cfile?

Sure I can do.  But IIUC Dave wanted to keep this series simple and we 
can start with appending the script to the coverletter (we had as short 
chat internally).

Hi Dave, what's your preference?

> 
>>   - Change to use auto-generated code to read TDX module version,
>>     supported features and CMRs in one patch, and made that from and
>>     signed by Paolo.
>>   - Couple of new patches due to using the auto-generated code
>>   - Remove the "reading metadata" part (due to they are auto-generated
>>     in one patch now) from the consumer patches.
> 
>>      print(file=file)
>>      for f in fields:
>>          fname = f["Field Name"]
>>          field_id = f["Base FIELD_ID (Hex)"]
>>          num_fields = int(f["Num Fields"])
>>          num_elements = int(f["Num Elements"])
>>          struct_member = fname.lower()
>>          indent = "\t"
>>          if num_fields > 1:
>>              if fname == "CMR_BASE" or fname == "CMR_SIZE":
>>                  limit = "sysinfo_cmr->num_cmrs"
>>              elif fname == "CPUID_CONFIG_LEAVES" or fname == 
>> "CPUID_CONFIG_VALUES":
>>                  limit = "sysinfo_td_conf->num_cpuid_config"
> 
> Thanks Intel for not telling the whole story in the "Num Fields" value 
> of global_metadata.json. :)

Yeah I feel bad about this too.  I asked whether we can use the value 
reported in "Num Fields" as the limit to loop, but I was told we should 
use the value reported in "NUM_CMRS". :-(


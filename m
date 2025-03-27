Return-Path: <kvm+bounces-42108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FED7A72D6D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE14F16B958
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 10:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BEB20E03F;
	Thu, 27 Mar 2025 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FbO2Ik4B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A019158553;
	Thu, 27 Mar 2025 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743070221; cv=fail; b=fE/QNnYkNQ2b7/+jCQUzjRnQEkpS5T2xk96+Op90eqog1Oq0OxNduFD+8R+rh4WT2DbmpC9lT2IpP7jAbI6S1Nr94ZydUyl/QCU+2ZcxbM91uv7kn9L2963qqDrVvmRiCX4L3jjHlq9O+bXQaQnta97Nc59wEEDGhRqVQjX4EdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743070221; c=relaxed/simple;
	bh=MnvPD0TKmA2Ma4BT55tmXEsOlAx3ZSr/v0jqVoHTrNo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uT+vvIy2jBmNTWKYxHETC0mCrFpE/idGW0hlL+LO224MIz6DxBdh7/yjJCDatCNxGgZYmF/uCZU4QdY2tmtMlm67W9vwYm1qg3+nS3qrWA2uOrGonoP+I88liMsiIZyRondplipCP6e6yBv40Dds8FfQGqDk85L+Jf8Rz32cxFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FbO2Ik4B; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743070219; x=1774606219;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MnvPD0TKmA2Ma4BT55tmXEsOlAx3ZSr/v0jqVoHTrNo=;
  b=FbO2Ik4BnOhWFXrQNg1sUblASP7x1VZXVt6HDD2khP/+6UqbZt9lsH3F
   G6U6jcTBRUoT5F15VAvCFGt9xeDfDhRJ8P0fCciHPzDGa1lWRY2G5U8l9
   rnvs52zARyzvDrTAxSdz665I30hF8ZsTUOnVQt7ZWw5iKmInofOsy6k4z
   CTz0BVRUghTp9Y6Sstb7y1vqybwAPfaGNFNmMVJWXF/MDpSzRzUzQWHaM
   eBLi9ZSvwfgMqavJlwNgi4rrmd/phcbH6YD5KUkhnCpp3FwWJhcAB9HHy
   wR0LOnAXS6FnmOAmulxDRUnD49nMUjLnuUiB5Gf0+24nnSg6LBGp+QYsb
   A==;
X-CSE-ConnectionGUID: HvTW+Y7rQcSKSftSZ3RbpA==
X-CSE-MsgGUID: 8Z0sCv9ZQU+X+/iDmuskZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="55760188"
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="55760188"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 03:10:18 -0700
X-CSE-ConnectionGUID: Zs3rboHMQ+Oh/t4SnuAPQA==
X-CSE-MsgGUID: mFQffcG1QzGRQRKba+umgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="129775994"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 03:10:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 03:10:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Mar 2025 03:10:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 03:10:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDahKzURcaklTQFW/8U7A/Uwky6iOv/TlZiSQllxePWyTmTt9cRdtBwumjM668vNwwpCpN8/pQh4YjPdJ9WKFiSbcyi4yTOYIHT8a2ONt/KqM13PIVrGKgM+MmBL2sIo42JabXLccpix9kHjnL/2Ikb4m+CHNiPtLIdWA8kXu8IjdBqs1US/Ueg/nmMpj/DgGcvxIRtm8wxyAxD3HRwJ1ARrBQGAZTT3kQJsNU2WcRyWCDYibRruhNsCBoyuK4rCj5Npgq/ZF6yjQkMF+zD7fw+uqsaOiChghTQHK6X+oC1WVEstpVO2uy8saBXG2XnOIcoa6AJHVao7N/dvYPkQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txdEziHm6ozvuGjYF0cNPyNof8eyrn6TnCs1YgzzECA=;
 b=DjyabrV2i426fQU0mUFdXotkSLOg94crrHGRs124Jr7TBEMhw92PvJfLGYVH0X5LtZq+o6Noo7c0F6ydLcX1wdFva3hJBec6wE2mHXPMy/0YFM9uLCKMaKay+VxO1RAUZLv02T1ClJNKTR3oNlfN0W7cxZZHdgAOAcjz7XpDl4us+q9/C/VlxwNyyMmbmEmB2uczEx9VxROGPEgKGDX298VK2AvWr1WPYshyUo/MrCnaqGZMBbch7RW3at9SDCE/FX2z/F3QB2s01j5f5gOogUnbzZEP1mI2Pp6jgWDiTdhQpvfxWyXQCJje9Yye7fU1NFsfKCPaKe5TbcO8MNltaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by DS0PR11MB7557.namprd11.prod.outlook.com (2603:10b6:8:14d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 10:10:15 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 10:10:15 +0000
Message-ID: <8d0a4585-9e48-4e8d-8acb-7cb99142654c@intel.com>
Date: Thu, 27 Mar 2025 12:10:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <CAGtprH_o_Vbvk=jONSep64wRhAJ+Y51uZfX7-DDS28vh=ALQOA@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH_o_Vbvk=jONSep64wRhAJ+Y51uZfX7-DDS28vh=ALQOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0162.eurprd09.prod.outlook.com
 (2603:10a6:800:120::16) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|DS0PR11MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b159e5-9280-4c9a-1851-08dd6d179190
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SmdBT2xnQjdYTjZJVEltZFFjOVJmSndCTWRabDdPRWgvZkc4MDZJU0FOMGlF?=
 =?utf-8?B?TysyRHd2VUNyeDQrSlpCSDRJSE5GaHFBMU5saWhJdDRXVWFuVTBqSXU2TWxP?=
 =?utf-8?B?aXF4dXlwRUhOMi9pbEdVSzdwbGMyTHd4U001MzlGVldCdlV1YjE0QXppOHU5?=
 =?utf-8?B?d01XYXJOU0ZCK1FUbHJLTzkzdVc3VEYzOFZjRHZNMVFWWGF4VEZlVjJtRVdw?=
 =?utf-8?B?MHI0bkVHbHU2WjFRbncraWd4NVoycU1WdFdOcG1jeTNqNEowamhZa0VtZEpx?=
 =?utf-8?B?OFFFZWtXU2MrK04rQk5BdWJoUHdZYUtSa0NnbVdJVEtseFVmOUQycHZjOTJL?=
 =?utf-8?B?dXdHYTY3SGU2dlpSbXN3akk0T1VsV3pGa2UxTUcvRkpYc2MwL25UYjR2WDgr?=
 =?utf-8?B?NCtzZzhleE5sTUF2U0kyaWEyT1dGSGh5dEs0YVIwSlhIV01rQXBMR0Zla2E5?=
 =?utf-8?B?VnhpZjJlbWxWUHdSRmlBQittcFpVN1QwSVl5TTkzTHo2UE0vdWpMcXNSSnhq?=
 =?utf-8?B?bGdzeThGMkZTZFYzQTU2MCtLaGJzMW9OQzRPTWxZMnJONmNmWHhCS01rZklG?=
 =?utf-8?B?WEwrMFpYbEREKzFjOG52cGZyMytFTEpTR1hHUjRNT2diL0pTUHcreUlaN0dU?=
 =?utf-8?B?S2FNM3U4cU5xVW5PclVPYUNoanV6TnRxYWlVZ1FxYVVJdmxLUEx4UTRlNDVq?=
 =?utf-8?B?dHR4OGpCWUhTcmRFWkI3N1lqZlVHSXh1Sm5xTVc4Y29tVVRrbE5QTmlrSTFw?=
 =?utf-8?B?eEh5SHdlT1ZvNmJKZ3hFSzBBOTVjR3UyVWF2NjdkNDBkZ0p4ZkFYMVZ3NzBK?=
 =?utf-8?B?TVhwZmdteFlMeGVESjJ5TXJpcjJJUE80ellNUFhoUXBseit5S2FseVFJK1Ev?=
 =?utf-8?B?b2lRZVliRldkcGw3NTZlci9aOXRYWXhVOFNGLzRyZG42aHpGSkdEUEt0T3Jm?=
 =?utf-8?B?anp6d3Q5NU56SHd0S0o5bExac2JTSzdsQzdQb2J1eU1GaTA3VjNGb1dWYitR?=
 =?utf-8?B?SGhVNFYwRFc1S2tNVGowK01NNmJ1TEovT05td2lMYlhRN1U2U2NYc2JkVjFE?=
 =?utf-8?B?a2gyL1BPREF0d0JFR0lxNzRrL1hQRVR5S2R6anFSSitmVmpiaHpBblQ1OGp3?=
 =?utf-8?B?dWlDQ0hGdEJWUkJhc3ZhNFlWd2l5eHRxcC9YWkFwMlFDK2NVTWIzVnlYWEtB?=
 =?utf-8?B?MkxldkU3bjdVQ0g2Z1hZVmZEWUFvTExCYXlPcmJkY08zWUtJQitLemcvVzJh?=
 =?utf-8?B?ekUrdkxURTlnYXcySno1Y3V0cFlwdWxMM2NJMmQxcXNjc2RDcmZwSWVmYUlC?=
 =?utf-8?B?aWgrYUt5YjhtNTZzUXlZYnhCb3VSZTFmdjBUMVFSa0VtN2ZUaTJLWmpuNWl3?=
 =?utf-8?B?VVJ4a2pwU0x0R25Vbk1EL2l3eVZZUStVS21uNkMzUFlxMVJPekJOMmx4TDFF?=
 =?utf-8?B?SHJsNUNQclZtbElQOS9EeGJUTFE4MFdlMXJzOVFXenVXSnE3WlVPc3NaOCtC?=
 =?utf-8?B?N3JyVitRZldXZlNvWXJBOXdPUEE1UXNqRHBiS0dEN2lnWXZ5SHQyYlFtZldQ?=
 =?utf-8?B?SDcvRkJ5bGpzRnpwaEpiNllYbUFmajh1NDkxQ1JSV0xDWkFMY0dkVWx2bnV1?=
 =?utf-8?B?T242eTUycHdDT0hGVmtUVEJiRGZVUEZyTXlTT29vZ2c5ZXhLU28yTlhQYUdx?=
 =?utf-8?B?cU9FUVgxSTMxbXdZTVYzS3VBcFJyZ3d2TU00Rk10di8vRmJ5TE1XdkVUL1F2?=
 =?utf-8?B?WThQMnUrL0J1eDgwbzNDRjhmSjlSOHBGa1J4TE1ZbDM0YWJrQjJQaWhtSENr?=
 =?utf-8?B?ODMvQTdrR2xDc3dKNUlodW13Rmo2VTI3YUZNSnhGc1U4ZmpNOEpSNUdiWVhv?=
 =?utf-8?B?WE4xYVV5M2t3YWRtc1d2YjFNWEJEam44VXlQeHBqMnVWSUE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1Y2RzIrQlVCOFcrMzdCNW8yVTRlYnk1clRyVWN5NGtnTkRsUXdNYkNIQldG?=
 =?utf-8?B?L21Ja0pOUHRhUUZ2SGoydmxpWlBhVlU2S0xlaGIxV2k2RGg1Y3dsR3ByYTlq?=
 =?utf-8?B?RmFDMkpCN2RvWXI0cVJFWlY3Y2kxK0cvNlVGNWpwVHI2Wk9rd3ljak05K1Bj?=
 =?utf-8?B?aTBRWFNqQVFQbzdvT2lwLytEd3dKTDJQaThycnY1VDBrdFZvSDBIVkZEZkll?=
 =?utf-8?B?alloMm0ybEhnaXlhWUpmT0c4UG1jZGVVMXR0M3lQRjZpVURMcGt0cWtSTXRT?=
 =?utf-8?B?QjVhQUkvV0RqMjRCcHdZRWc3cGRzWVloVExncm9xdlBFZWhBWk1qNnowQits?=
 =?utf-8?B?ZWU3MkFyZUNCek9NUWJCRi9UUGg1aXhQN1J3VzJSazNwZm5OV3ZaQi8vUXRB?=
 =?utf-8?B?dHZESDduZ1Nmay9ES2kxNFhMOHF4dDZlNmw5N2twRm9CUmJVR0N6VWkyc3Mw?=
 =?utf-8?B?VGQyaTdmTjA4S0dKdnpoTmREc3J3d3dTN3RlSWk3RnYyZGNqNmkxZFlXVDJI?=
 =?utf-8?B?cmdNbnhIY3FXRHlwVlhJeFNGSFRrRFlneUFubjlsdEI0VkFoY29KY1NCU0c3?=
 =?utf-8?B?cnFXK21rdlJGR3pDeWlBa2xTQThqbDRwQjJOTjZFWHl1bDlDbkp0M2pBVjhw?=
 =?utf-8?B?dk5TOTByOUxVbm9UUkM4TXlGN1ZBMmFKc0hNalNwdHh1ZFF2aTBXc0dSMlNy?=
 =?utf-8?B?OGlxR0tSVXc4bDY3UTdIN3A2OUVFbjQ4NlVaN2MyMFZKc1RubFE2bnQzeGVK?=
 =?utf-8?B?RHI2UVNZMDFUWGd1TXpTUDBrY0VaQkFleEx5dmRScnB3Yk43T0owWlFHcElh?=
 =?utf-8?B?MGhpRyszczhTY2JVYW5aQXA0YWU4a0ovSXRKWXdLT1IyRzlPQkh3UzhhbEda?=
 =?utf-8?B?eXl1akRUUXZnNVJraTB5YURadHNLZzJVYzZmeFAzSktPUWwveHdvQ2hudUJk?=
 =?utf-8?B?SXEyU1ZJMW5NTmdNV3ErL2hQenN3M3d0Q0x6Y0YvYkJCdWlZNTE3RGVvcW1G?=
 =?utf-8?B?V1FUUmJTNmJMVkV0MTJPL2JScVQ2MDl5TWJVeFo2Y2sxWDhEajlYdTRHVHJl?=
 =?utf-8?B?cG9Oa2lJRWVxbEJDQU9EdC9NYi96YWEyRXZHdHA4MHFFUkE3aHVUMlF0dzlW?=
 =?utf-8?B?Smg4OWJ4Q1NHVGp2WWMwMUFZS2RLK0RaNlBvYmRkOG9zMXh1YnZYdjd3S0di?=
 =?utf-8?B?NW81YUN1VjJYR21JcTRybHV0OHVrMzBKUUdxaitEM09DVUtzSFZMVEN3REtO?=
 =?utf-8?B?WGRCQ0RlZ3d2Ui9ScFc1R3pnV0cxYjg0TGtKMkgyZ3A3MzdzYlJIa1NZc1k0?=
 =?utf-8?B?Mml0andSQklaTW9vM1hjNjViQ2dINXI3N3M0RkZ1RlBzNUY2WVJTMzZXMkQz?=
 =?utf-8?B?OXpwZVBFeEl3cWxLWHdSSjQ5SG9IWVNtTE9iRHE0UzJ0aHFMRGRVMDVtSzVh?=
 =?utf-8?B?Y1pDaFg1L2xISUNCSDRBb09VSjI4ZzFFRThITC9sTVo3WnJKZitoTHhMdDFL?=
 =?utf-8?B?TTNmME1vc1Y3MnRidXQ5UUZaU3VyMlU2QUhqdjRnMWthdUZuQjR4WDBuVTly?=
 =?utf-8?B?VEZCdFl3SGtmbGFSeFNkZVdUUGp5S2tnalcyVm4rQllTYVFQaWx0OFlVTmxJ?=
 =?utf-8?B?cTVOVTBEUkZUMm8yT0lobXFibW4xMlk1bWRpMzlRbVhubXpId1dPbXA0YTVz?=
 =?utf-8?B?MjhMRXg1aWlsd0JnYzBjcG4xb004U0pFZlpUeC9YWFRveUJ1L20vRnFUaUta?=
 =?utf-8?B?NUNUMUdaSEljTnFiWTVhMCsvTERISVg2UmdsSjdZbnI1cElYZGkwcFNLZDVh?=
 =?utf-8?B?Qi91MTY4TzFqSGtXRnlQWnZUWW41MWRvMXNqR1VSSEIvSEZFTGRjYnhUcWpD?=
 =?utf-8?B?UEFCYlVIcUE5alM5dUpoTm9UWkR4UW9JUVBPeWNCVHc0UVl2eDJ5bnZoVDlZ?=
 =?utf-8?B?aUVpOU45b0p0cGFEeDRXd1YyVzJhQzJhT2dKa0dhRXBDNkRieVgvcGkzOThM?=
 =?utf-8?B?UWEwbkpUaUJBNHRzdXc1ZTIrUzhsa3F4bXVtc0o3TFRhZzJ4WklxclZ0eTlI?=
 =?utf-8?B?OW15ZUFQbEp3U2tHejZMbXBieTl4MmplV3hEYmh4cTNJcVRqckwzYUl5N1Nn?=
 =?utf-8?B?dkRMdUhOOGJWa2ErdW9NZGZpRDFlNG0vaE1BSGhTTmdTcWdDWGdJQzAwU2tv?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b159e5-9280-4c9a-1851-08dd6d179190
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 10:10:15.2324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AV6ZXcKOwQAvJ43IAxmOl0Ii1U7Jl4QgppJTo6HIXiErYj/E5EabNQJfk2vJbDY5RcUD7FiQyGL/iMDnD9lnDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7557
X-OriginatorOrg: intel.com

On 27/03/25 10:14, Vishal Annapurve wrote:
> On Thu, Mar 13, 2025 at 11:17 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>> ...
>> == Problem ==
>>
>> Currently, Dynamic Page Removal is being used when the TD is being
>> shutdown for the sake of having simpler initial code.
>>
>> This happens when guest_memfds are closed, refer kvm_gmem_release().
>> guest_memfds hold a reference to struct kvm, so that VM destruction cannot
>> happen until after they are released, refer kvm_gmem_release().
>>
>> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
>> reclaim time.  For example:
>>
>>         VCPUs   Size (GB)       Before (secs)   After (secs)
>>          4       18              72              24
>>         32      107             517             134
> 
> If the time for reclaim grows linearly with memory size, then this is
> a significantly high value for TD cleanup (~21 minutes for a 1TB VM).
> 
>>
>> Note, the V19 patch set:
>>
>>         https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@intel.com/
>>
>> did not have this issue because the HKID was released early, something that
>> Sean effectively NAK'ed:
>>
>>         "No, the right answer is to not release the HKID until the VM is
>>         destroyed."
>>
>>         https://lore.kernel.org/all/ZN+1QHGa6ltpQxZn@google.com/
> 
> IIUC, Sean is suggesting to treat S-EPT page removal and page reclaim
> separately. Through his proposal:

Thanks for looking at this!

It seems I am using the term "reclaim" wrongly.  Sorry!

I am talking about taking private memory away from the guest,
not what happens to it subsequently.  When the TDX VM is in "Runnable"
state, taking private memory away is slow (slow S-EPT removal).
When the TDX VM is in "Teardown" state, taking private memory away
is faster (a TDX SEAMCALL named TDH.PHYMEM.PAGE.RECLAIM which is where
I picked up the term "reclaim")

Once guest memory is removed from S-EPT, further action is not
needed to reclaim it.  It belongs to KVM at that point.

guest_memfd memory can be added directly to S-EPT.  No intermediate
state or step is used.  Any guest_memfd memory not given to the
MMU (S-EPT), can be freed directly if userspace/KVM wants to.
Again there is no intermediate state or (reclaim) step.

> 1) If userspace drops last reference on gmem inode before/after
> dropping the VM reference
>     -> slow S-EPT removal and slow page reclaim

Currently slow S-EPT removal happens when the file is released.

> 2) If memslots are removed before closing the gmem and dropping the VM reference
>     -> slow S-EPT page removal and no page reclaim until the gmem is around.
> 
> Reclaim should ideally happen when the host wants to use that memory
> i.e. for following scenarios:
> 1) Truncation of private guest_memfd ranges
> 2) Conversion of private guest_memfd ranges to shared when supporting
> in-place conversion (Could be deferred to the faulting in as shared as
> well).
> 
> Would it be possible for you to provide the split of the time spent in
> slow S-EPT page removal vs page reclaim?

Based on what I wrote above, all the time is spent removing pages
from S-EPT.  Greater that 99% of shutdown time is kvm_gmem_release().

> 
> It might be worth exploring the possibility of parallelizing or giving
> userspace the flexibility to parallelize both these operations to
> bring the cleanup time down (to be comparable with non-confidential VM
> cleanup time for example).



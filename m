Return-Path: <kvm+bounces-16689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 969618BC993
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D8F82827AF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AF16BFCC;
	Mon,  6 May 2024 08:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZ/kb9w1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FDF249E5;
	Mon,  6 May 2024 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984318; cv=fail; b=VaLxsuXjxGyRRKCELqprzDaUcOWonXSq5ubk9uQvEZAYTnzcPu18Nasl5+KHJ2JuXwb+JhQ0/f8/Mgl79Ut5UgRm7Mz5FDDGJwIZWBDM0Tgf0DxutPJErQnsaBYw+vrxtaroKAUdkCYD8rDFxEucCQ4TZwWhCCNX+EKU30G2VYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984318; c=relaxed/simple;
	bh=exYIG+2IQfHTgmSDE/bkABtc1AOBHLBmKOquAkrhRPQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CElRnVGtCDlXFnAJYh77JQZuEI2YmE8/zG3SOnzCu/RmeSPYu75/PewJK9A4quqaLqil5Rl/KbsiV/SVY2vWa8wZdafyrbpDmDq+B4WjKDST/5okm4GlZfrr4THVnElW4hFMSb0Dc4dVXptRRQW7TA9I/yuHQzWhG3F5TdHY+jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZ/kb9w1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984317; x=1746520317;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=exYIG+2IQfHTgmSDE/bkABtc1AOBHLBmKOquAkrhRPQ=;
  b=PZ/kb9w1CcAeirDRDp0mlL38cc6wIqYZPkJzW7nh3wIZ9OHt0tueJs6P
   RX/uulLBv9NtXypdXtHZNH1U/ctBk+3I2EWcUJWzUFBFMYYscT3milCwa
   Y5PxymtN8GM9UuLSI09U+00UR3xmWkfcaOyxKkNu3Ospvi3i3afffXM0X
   u4h3B8Imm9gCUGvhv/SBM52i4lZiZPu/FbY4ZRmQVgx4YHyLoc66bHjgl
   tdodZu5WaEkkC7uNn7eDTduM8ooJw7yI9CWY8PL26fGyfM9UI02vZaPZF
   M38bpHc8WePT2ExBn0d33PncfTgpkdbsTopyq36UFg5hOTKp5cXcalqAm
   w==;
X-CSE-ConnectionGUID: yMhQNmrmToOeMVigiPgC0w==
X-CSE-MsgGUID: i0YVj7MGSyePZ9ghXjeZJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10937698"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10937698"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:31:56 -0700
X-CSE-ConnectionGUID: 5Qfa11qpQMCtb/E4EBxguA==
X-CSE-MsgGUID: WpLFCVDWR+6bDXC3c3ob4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28098543"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 01:31:55 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:31:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 01:31:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 01:31:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5KbHdVqzmJXwEsSEvDlQmnkrKFfQJTNkN7hSsiDm2Gj18doRWhOwIvEv+rujz92+WsuTrWoJKNv2TzxZHBaDTIMuCMcLBTN9LVyg7brs0ndAEf7e67r7eHfuiknVFMNmbk9gSM+JtKtZYKtOYXf5GTCSIboztg1xmntLLwd+tjIhuELZxg5/Mazr230stH7gR2ULkMgwqM5ODZiH5v5kTSkdc1GlLdOR6xFnw25LxVs48NPl8+FvawQdIwMgx9ABE/XGkrpugJOwPlot6f7AB58hSSFOG2ska6zExGaoR5h6+40vijfAOBLcBIT/9FRjzQO0p1xY5yB5TfpLnkmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCM+V69hGq3mmCZXi38TFCAQXPtRegf1SvC8SgtzgHM=;
 b=bXC2ole6DgISudJha5dOVyEKn7EiILNYRlM41Ozh43xo+aS8dx4HD+L1Uw9+Mj+mQB8S9Ofgb0jzv7NRtekSfe68QZjGjarXFhgrlfvPDUMtXlGQ7wpmNtqze6I8e0At1+h4fPCB0T+GL+wurYeDBRYItVF5/PU0r8cRJz1hLZWGM5FlRUNJwLER5U1wYgVwgeOrE7IqTEnQTIRommZcLJMpWzIr6xumccHN13lHl8EG4KltyRfo82THS0LlS+VCl8y20Wm7mR1PIgBlkeE4YDf1Bvm8uNZUWf+bF2vJnF+M4VfM1EPHI4OvNPJH4pvOlvHRbiW+AHfRqbwBwgMtVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 08:31:52 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 08:31:52 +0000
Message-ID: <4e034aaf-7a64-4427-b29d-da040ec7b9f0@intel.com>
Date: Mon, 6 May 2024 16:31:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 17/27] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-18-weijiang.yang@intel.com>
 <ZjLE7giCsEI4Sftp@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLE7giCsEI4Sftp@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c3f418-65fe-4588-ba21-08dc6da6fae7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UURPU0h3SEkzMkk2bjhOSHpLZVNJT0hJcWdxZ3UvRkh3bUdkUFppTVdnYTcr?=
 =?utf-8?B?V0NrU0RBV3gvVnR5cjg4aXJsVXpWclZ3WFpLbWtIRkxJZ0RoMFZSUHR6aUJ1?=
 =?utf-8?B?WHFkUGY3S2ZaVG5FVENpb2xQMHNLTWNmYlJtODBVNk53MXNpeFROOTdQbGt0?=
 =?utf-8?B?c3ZycWR4OS9SNkgzd2ZGYUVWSHZFS3ZwOGgvUFZpaHhqR2VXejF5QTZpUUw0?=
 =?utf-8?B?U0xhd1Uwd1pzTTVYcFl5TVFTMnNFSStNd0szWkRsMUdzUkVteVJrQzdhM1VF?=
 =?utf-8?B?cnJ3NzlILzlrUGtCV2lJaGd0SVJWY2p0V3FndXhvQlYyY2JyN2grRDZYSENI?=
 =?utf-8?B?TjB4T3lJWWF3TWwycGtaQ21UakhpQ25tMmhScnRzVjZ4WGc0dXdUVkZ6U2hO?=
 =?utf-8?B?bTkrNGFsUmoxVjV4blBYRUtyRTE5U1NZdENCR1RuWjRNd0w4dlZMaWl5bkkw?=
 =?utf-8?B?WVJzNlZDZjA0WDZRME1kbUc3YXBBSTd1RFQxNFhENElDZTllSGFRU2VqcmZW?=
 =?utf-8?B?bUVyZFcvNEh4ZUxMVEltQldYUHh6cyt4NVhBNG5XakxRMEtxc1ZMbGNhQU9O?=
 =?utf-8?B?NVV3L0lVRlBrUjJhL0dHVEJ1RG1qcUNDTTd4MVEyOUR0dUNldjVOclBxM3gw?=
 =?utf-8?B?VGhSR2U1NjJzYzdoSWp1ZXJBQm5oS1FMdHVCa0lMYkw2Tzg5U1BqNDc2S2hv?=
 =?utf-8?B?UldvR3ZiR1BZK3hqeloyaFh0SGkva0srM1VQdHFNNU9tOUpDQUFLenovZlZD?=
 =?utf-8?B?T0krSDlVMWpTUVYyUXA2VnJLQUs2VldKYU80QnlrZkx1Vndkc0diNjJKeXpG?=
 =?utf-8?B?TUx1ZXIveHhad045UDE5T25obDBRc21LTFU1aWhsbTJCbk40TWdXell1Skhn?=
 =?utf-8?B?dWgxS2RTY3NOMGpuQWF0SHViU0d4T2p0RlpETmdFcmdqRExtL2tUZ0syYW96?=
 =?utf-8?B?SmZGaitldWlPK1B0Y0c3SzhPdW9RVEcyc2RQWG5Ob2Z2V1lpZ1E5VUNBN2lN?=
 =?utf-8?B?aTNrWmNlY2RmMzBjanNWRyt2WFZPQmhKNVJhNHlBeFBUTkxadWtnVFF3c3lZ?=
 =?utf-8?B?eW9xRHNiTWpRZ0hqckZVajVLcFJncDNHQjJNa1RESTdXbGt4WUFSZzJBRERG?=
 =?utf-8?B?SWdyNU9qOHhpVWkyNVRmWGhwbE12SmlXVVk3THFnbkp3a0N0aXM1b2Z2ZHdy?=
 =?utf-8?B?Q2ZTZHZoUSs3alZ4OUhEQ2tEK0pNRW5rYW11LzNVdDIrMmRobFZHalBiWktr?=
 =?utf-8?B?TkJiKzRTOS96WXV1WVJKMFdnWm1UVUt1WmVxakpEZ0pSd05JTGtOTU5iMVBT?=
 =?utf-8?B?VE5DUGh5M1g0UmJJbTlubXJubG9QY0VNdGQ2dkNzSzdIejBPOXZsdUdNbU1G?=
 =?utf-8?B?QWp2a2Rkc1FRb2k2ZTRmV3NTWTVNTWRQaTE1ZXZzcVVOdnQ4Nmw0ZElQV0VR?=
 =?utf-8?B?anREN2ZpemJCRSs0VGZMc0Y0SU9RMXovTk94VytzbE1IK2djaFBHeGNZbDk2?=
 =?utf-8?B?enNXZzFvZ1MvUHl0ejJsTzVIUGsyVWh6RnVQR0xuNkVJMmNiRWJESFNJbU1l?=
 =?utf-8?B?UU90VHBrajJHUDRLRjREMWJWZEttL2pxUVMvWnl1YUpjdTM5ZU1DbGhkNmZm?=
 =?utf-8?Q?XWJL9c70hrcX4J1kla1alTvJAVQd4jfYOEpKrfmkQ4XY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzdMUXp6QnhONkp0RGJtTmlDd1l6TjlkUmZqRklLQ0NsWTd6eWJDekUyM1Jq?=
 =?utf-8?B?UTRQYjh6cS9KeVRaMG5Xb1lab2FQTjFxVkxNaC9YY3EycHFQS1Q3R2lBSEl0?=
 =?utf-8?B?dkNJSnA1SlVyUE0xYTBzUXBXMlBBR0x2akpVL3dPMEZKc1FOUWxUeTVJMyty?=
 =?utf-8?B?WnZ6TFo3RW1xM1RZVnYzakFsQS95N0huZzRqaGVsaEdnY1RvQW1UWGtiODlI?=
 =?utf-8?B?SlBRM1RDN25mYkZOc1dscnFjWEVOcXRrZVg1TnYvL2J0bFpEa1pHc2RmclZ5?=
 =?utf-8?B?VTFjQmU5bEgxeUlNRGErUTJnZHpiTFpDa1pxNUVoazBEa2l4dHY2MU5id1ln?=
 =?utf-8?B?MUx6ZjRMVzlOUUdXWnI0YlZDUzFNV0ZGTTJoYkUyWHpEVURIVUh1d25lelVr?=
 =?utf-8?B?U0lMSVJqeDBFWlROU3I4VDJhZnpHUFU2WWZiaEVkWVZ2YkNmMWpmcCtxUTBI?=
 =?utf-8?B?aVdXYVkydExWOThVdTJXbGZQanZ1Um42Vm93cG1jUGxNNzlwQVJOVXRWQVQw?=
 =?utf-8?B?NTJuWSs5VUh3U0tienlzMzB2KzZsMVY1ZU04SFU2bituc1ZvdzJJdFJjakVl?=
 =?utf-8?B?c3NPTnhnNHRMMjM2dHFTQVVsdzlocEJFYWh4dUljQkNPQnJtZEdhVFRvTzk4?=
 =?utf-8?B?RGVLWm4yclJpUnRUV2hJS01HNU5HcWIwb1ZLMGhaZTcrRllkalNnbXpTNi9J?=
 =?utf-8?B?YjdNemgyajhnWHpKZHprQ2g5VCtLc1BYZUJnQXZKZUhQcHpyc2IwelVPckR6?=
 =?utf-8?B?T3lJbWFDZ09NUG55TGR3b24vbHFiODBMSzFqWWZkMUlJRW51enlKWmJxajNB?=
 =?utf-8?B?UHRld1JxY1d3NDRuTlMwUXNTRDlLd1NpSnA1cVY3NDZWMGJiYVRzMS9iendl?=
 =?utf-8?B?UGVITGZLdnpLMUN3UU12cWJVRG1ybWx5enB3NlZXY3FaZG1nT3U1QVkvc29F?=
 =?utf-8?B?R2NCUHIrUXdKdkdaTDZBcHRCUWk2REpXYmVHRUFDR0pwREEyRFF3VXNKRERK?=
 =?utf-8?B?WEd3RDY2R1B2eUswVVpSUnVneitxdmMycWMrUzQybzZDeUZqaHExbVdiZjZx?=
 =?utf-8?B?UzB5eFdVWHdTRGJ3NTVwVEM0WVUybXpjS0pDaE1zaXhEdmM0aVdPUEpiUWFh?=
 =?utf-8?B?QzJ2b2ZOWFFGbFVwSzJ0TmtMVllEMURmQW4wbEVFMHl0bXc0eS9zdXd4NWJi?=
 =?utf-8?B?L3FxRmk3MXpWUVkva2pwM0pzV0JTM3RrTVFLUEJwQjd0WjV2QXFnRnBKVWhL?=
 =?utf-8?B?aXZ1REZCNUJtV2s1T2F1Snd5Ni9LVUxSZDV4dHIxT08zWDNCU2hlMks5dWFS?=
 =?utf-8?B?OU8xNll4RkxzTHhIVmV5Smc3Y0c5bUZQd0xjYTZtTk9tTStxbG9FUEpmSTQw?=
 =?utf-8?B?NGkyc051NzgvM3U5T0JsYmtORG9BOU84akpDeWFaeURpSnlHWkRpc05aNTZT?=
 =?utf-8?B?MllYcHNkWE5WMVo2Wm9hcDg5bFpvaDEzL2RtQ2RxRi9tM21sRDV5UG5tdG5Y?=
 =?utf-8?B?QnA1UUxBUDZadXp3Q05wdjZOYlBDbEovQW5LdkdiQVZLQno2ZkdqZnE4OTcw?=
 =?utf-8?B?UENMTU0yODRhbFZwS3c2RzM0aDNCY1ZuMHVNYS9NNWQwT0J2Z2h6TTREVVNp?=
 =?utf-8?B?ZUlpTUV0d2tob0FOS2xOdk4rcUE0UDYyc2pQNlZFeFlmZ05wWXEyOTZQZ2hu?=
 =?utf-8?B?bmlrSGU2VzMzVmdFMUYzTzRacDdobi9ObzMyWWZhS2piaVk3aWJMWmNpSURS?=
 =?utf-8?B?dHZ3Nmc0cUVkRUFsS1JGVWY4UENrY2VVM0M3SVlZSGZhcFYwSnhiSThnZGZW?=
 =?utf-8?B?S2tUWTlCWFFwanozZXJkRCtLcGhIa0hFbVpiQy94c0FZMFZRcHB0WkVtd25h?=
 =?utf-8?B?Y1NSangzWG1GYXh4Sk45cThPTEF2d0lxT091a2cvdER4T01PNU16aDcwKzlt?=
 =?utf-8?B?TjRIWEhwdlg3STREVXVnSytQVWVRbWgySzdiZ29QUjR2TjMxT2FodGUrcjM1?=
 =?utf-8?B?cW9YSGl1aFVpNGZobjhRRGpzVlo0cDdhV0xDcGw3UHBBQVdudDdEa1dpMHhy?=
 =?utf-8?B?RitRbGQzemJnYmhjTk1lN1pLQ2lFMyt6eEQycy96aVBNNStFZTVzSHNnM0R3?=
 =?utf-8?B?RWRXQkVxaGsyU0hyWWxzb1JTZW4xZWVOeTdCQVZZdWNNS0ZKRGRadVpDTGF6?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c3f418-65fe-4588-ba21-08dc6da6fae7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 08:31:52.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDQRQFuM09kEXoc70lo9ybF8CAktRoUlWIcghe6CGvlbwKf6bD6FZ3w4b1K+o91YbLdURuwrUpUOIoLDuH0tuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7880
X-OriginatorOrg: intel.com

On 5/2/2024 6:40 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Add CET MSRs to the list of MSRs reported to userspace if the feature,
>> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
>>
>> SSP can only be read via RDSSP. Writing even requires destructive and
>> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
>> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
>> for the GUEST_SSP field of the VMCS.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>>   arch/x86/kvm/vmx/vmx.c               |  2 ++
>>   arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
>>   3 files changed, 21 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 605899594ebb..9d08c0bec477 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -58,6 +58,7 @@
>>   #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>>   #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>>   #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
>> +#define MSR_KVM_SSP	0x4b564d09
> We never resolved the conservation from v6[*], but I still agree with Maxim's
> view that defining a synthetic MSR, which "steals" an MSR from KVM's MSR address
> space, is a bad idea.
>
> And I still also think that KVM_SET_ONE_REG is the best way forward.  Completely
> untested, but I think this is all that is needed to wire up KVM_{G,S}ET_ONE_REG
> to support MSRs, and carve out room for 250+ other register types, plus room for
> more future stuff as needed.

Got your point now.

>
> We'll still need a KVM-defined MSR for SSP, but it can be KVM internal, not uAPI,
> e.g. the "index" exposed to userspace can simply be '0' for a register type of
> KVM_X86_REG_SYNTHETIC_MSR, and then the translated internal index can be any
> value that doesn't conflict.

Let me try to understand it, for your reference code below, id.type is to separate normal
MSR (HW defined) namespace and synthetic MSR namespace, right? For the latter, IIUC
KVM still needs to expose the index within the synthetic namespace so that userspace can
read/write the intended MSRs, of course not expose the synthetic MSR index via existing
uAPI,  But you said the "index" exposed to userspace can simply  be '0' in this case, then
how to distinguish the synthetic MSRs in userspace and KVM? And how userspace can be
aware of the synthetic MSR index allocation in KVM?

Per your comments in [*],  if we can use bits 39:32 to identify MSR classes/types, then under
each class/type or namespace, still need define the relevant index for each synthetic MSR.

[*]: https://lore.kernel.org/all/ZUQ3tcuAxYQ5bWwC@google.com/

>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index ef11aa4cab42..ca2a47a85fa1 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -410,6 +410,16 @@ struct kvm_xcrs {
>          __u64 padding[16];
>   };
>   
> +#define KVM_X86_REG_MSR                        (1 << 2)
> +#define KVM_X86_REG_SYNTHETIC_MSR      (1 << 3)
> +
> +struct kvm_x86_reg_id {
> +       __u32 index;
> +       __u8 type;
> +       __u8 rsvd;
> +       __u16 rsvd16;
> +};
> +
>   #define KVM_SYNC_X86_REGS      (1UL << 0)
>   #define KVM_SYNC_X86_SREGS     (1UL << 1)
>   #define KVM_SYNC_X86_EVENTS    (1UL << 2)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47d9f03b7778..53f2b43b4651 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2244,6 +2244,30 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>          return kvm_set_msr_ignored_check(vcpu, index, *data, true);
>   }
>   
> +static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
> +{
> +       u64 val;
> +
> +       r = do_get_msr(vcpu, reg.index, &val);
> +       if (r)
> +               return r;
> +
> +       if (put_user(val, value);
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
> +{
> +       u64 val;
> +
> +       if (get_user(val, value);
> +               return -EFAULT;
> +
> +       return do_set_msr(vcpu, reg.index, &val);
> +}
> +
>   #ifdef CONFIG_X86_64
>   struct pvclock_clock {
>          int vclock_mode;
> @@ -5976,6 +6000,39 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>                  srcu_read_unlock(&vcpu->kvm->srcu, idx);
>                  break;
>          }
> +       case KVM_GET_ONE_REG:
> +       case KVM_SET_ONE_REG: {
> +               struct kvm_x86_reg_id id;
> +               struct kvm_one_reg reg;
> +               u64 __user *value;
> +
> +               r = -EFAULT;
> +               if (copy_from_user(&reg, argp, sizeof(reg)))
> +                       break;
> +
> +               r = -EINVAL;
> +               id = (struct kvm_x86_reg)reg->id;
> +               if (id.rsvd || id.rsvd16)
> +                       break;
> +
> +               if (id.type != KVM_X86_REG_MSR &&
> +                   id.type != KVM_X86_REG_SYNTHETIC_MSR)
> +                       break;
> +
> +               if (id.type == KVM_X86_REG_SYNTHETIC_MSR) {
> +                       id.type = KVM_X86_REG_MSR;
> +                       r = kvm_translate_synthetic_msr(&id.index);
> +                       if (r)
> +                               break;
> +               }
> +
> +               value = u64_to_user_ptr(reg.addr);
> +               if (ioctl == KVM_GET_ONE_REG)
> +                       r = kvm_get_one_msr(vcpu, id.index, value);
> +               else
> +                       r = kvm_set_one_msr(vcpu, id.index, value);
> +               break;
> +       }
>          case KVM_TPR_ACCESS_REPORTING: {
>                  struct kvm_tpr_access_ctl tac;
>   
>



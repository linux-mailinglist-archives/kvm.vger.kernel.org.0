Return-Path: <kvm+bounces-13941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF5389CF83
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C6811C21F12
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1066B4C69;
	Tue,  9 Apr 2024 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hY50tvdB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E664E15C3;
	Tue,  9 Apr 2024 00:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712623109; cv=fail; b=jeNm9LzCrIa1ZmIZEob/U9iH7J0WgJs/tdguANcJ282WDQKf8n5kVVcBiBhpEj8nokyF2i/HnjChHf4PdA+uJWG2ijv8a2P07u6Z7O8LioQblEQBPBXurWHbdTlTqiv9RDr9UP8sttCZlHp7t+yCiTuLmAa60Xrb1JYW5lNnVvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712623109; c=relaxed/simple;
	bh=QVlT0ajUa+ZGWDnETYlVqAor9SxmQ19q5SOQTOUWodo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u3SZSRkx5hWtT/keHk1BQ6j5UL1qAzUDotuE8fSCrn6cF2/lbaujuMNic9V1TAh5w08xurztzycMutHZVdsEse8injLJRHP2z/eISyllEKDQQ6I3WalHhMu8b+Lwyb3jN7Ymy+O0bpfVuWJs5UnvsS5l2WXSuZQn8+knETN0lq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hY50tvdB; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712623107; x=1744159107;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QVlT0ajUa+ZGWDnETYlVqAor9SxmQ19q5SOQTOUWodo=;
  b=hY50tvdBZ0L+43wFsaqpQskYRpsKxmTzPmZ2Cny6GLNre0egb/b1HWro
   gNQwaS2Qj4T9VxHZRpUEvom/F1O08TI0XeRHkWtmBmMbcS+Kddre6EYsp
   NHwpPoGSPaBRKKEm6EwFRejDdO57JwVrbFIsvXVd/ahjrqo+Y/tOVmUbc
   JRiFdtK81GGIgDLchLC0UH4fhQCSiP3qt2RD3calb94gNbqbxkFKN9W0z
   AWwLnFfxoOcMZoFpuaCHl49vFX+GjIhAOT8uuu8rnmZ0A9a6n1CkJnHw9
   aLoJTk909dBp94sMhea/mUuzv+36Ca/3gbOW8SvaMH78vTZnU6PFwjfuu
   g==;
X-CSE-ConnectionGUID: HgY35GUoQ7CZTKC/uJ3yZQ==
X-CSE-MsgGUID: lq4Ag/UbQBi17icKgRbu/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="8086036"
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="8086036"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 17:37:29 -0700
X-CSE-ConnectionGUID: hy1yBFM8T+CsTlFqnnZeLA==
X-CSE-MsgGUID: G2tbUYMgR2a7hLPW6axraw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="19933432"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 17:37:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 17:37:28 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 17:37:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 17:37:27 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYUhBSBC3uC29DR9d9ZuoDkPjewQu3sX4yLqV9Z1LXSCRzEwyWl2m16rsTmQ4S7w6BKPdmyljdOrfeV3E42hI2tU6HeVFWKxinf4Wi2FdwUEjoM9NzyB7NlZ1ijeDEdSzx9X0eruu551T2C781xKKMGa3JEKYRJ3KY1O4bgpMMc8FC6ydy6erno1nzFxq5kQqLucMJKUf3k4/H9TodcP8eKkjxFrWn4HvtIfrWMQ49Pa5M1ENr61onChKhb7jAMrSVn8+xZ6udMi4ozX+2b2dW44ZoPNVPi+l7OSt4jm+kxuFpl96X7tKu22YFhuBi3yNUCZCerzIsYH5wwlptLMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZcCMwuSOKOPaw+wxDerkSdTmb9EHUQ/ry5SkJCG9Uo=;
 b=i8IqHkGkePqPIAXK83rUONuoixnMAY4PtFFH8dG/r15juXMHMPirvBUmkV/dOcEPHi5q4/D/ugXoMQTlBfNIYS4AjXpSL07MFEaDXvWbkfZwl2hoAZiuHjlkGfTjtHveFYzUi2ApI9OBnuxeZlgKmvUmIcimh+1zSLzQFGPE6Vpnf/4n6ZOfF7haYqWG2BdkRnQCd+nDgwo5rM+SFi802alfRpa0Ac3L3uQhFdzxdYNULoai3e9D6oi1CM3AEKfb2Gjo9dUqxPHlWwjnSJYIGvIAR5nx0p7TxVDcj+UJokCTm8JY65uNoaudqvmcAm6OyPnFoqgLPJx04BLMxUvgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8051.namprd11.prod.outlook.com (2603:10b6:8:121::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Tue, 9 Apr
 2024 00:37:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Tue, 9 Apr 2024
 00:37:24 +0000
Message-ID: <80971062-9827-490e-a8eb-980a4f249e94@intel.com>
Date: Tue, 9 Apr 2024 12:37:14 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0301.namprd03.prod.outlook.com
 (2603:10b6:303:dd::6) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB8051:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YiXNaKr++rOkAQNzCi9soFsU9hriHFNvvdUtihocmvdDxjjuKl9VjYV1Puz81ID+mvat2N8yBPzLvnFhNxkbJbut/HwZ4HaNrHamkG9dz4WcMO3c6ZtiDIZPHt7eYmEpzg1b3MliKSVNqqom3iUF4mCHlncSOV4F2xbwQBcM300vDNANyL/EVRzN7IEmOznBV6IPkWFF9fBP3+wzb+jIHxJCsRrD34mMYTPl6iWf+GKV9ryjqIzBS5QTkrnH6qrFlbYhuqv75kcHiE5QSqvNKwep5tGdCJxxSdmZjYOIslYhK48QH3B6+4133UB82KoaLx32hto54lXLTbHhHjLh8JRiU+/Lq0PSkxr7RmLIAm0ys4/88k7nph6018++QR+cr8ZYulq9pc5sDwbvtRRF3ESKAKECjMb1xWmbWJPh8szkcSXIu7dDqvbC3KkHy1CRCQ2WOn8cMZBH1ipqnjzYh9V4XsCDn2HVjN4z6JAWCAjFPy7HvcnRcKSJNDribwlus4A+U9tu9bWiFadfZ96rhm3O/NkQ8K64iNrvHf0OWCQn9hpF7GP+r3ZMiWdm4TjLgXcC3u+rSagn0wxds1KTg57GJk1laVnFohNIc9zjLXRgwl4ivJzyDHqxWMogHYqJnA4SMcR66Z3CHh58r/CT8mHdf0F9DPMV5EMe3jJ1Snw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFFHN1ZhaVFRRHJZMGUrRnA0RVJkblZ5eUJVNk5GdlJHMXpoOUdmV29XTnh6?=
 =?utf-8?B?S2hJd2kraGh2dXpnOEM2T2U4bUJWU2JUekhMOHZPMEhLOUlCV2d0dy9yUzBI?=
 =?utf-8?B?TFh1SUpBVVNXVTE2VDd1MDVqRnQ3UnZqZW9HbHl5OEk0UGxPY2hjaEdsdVVh?=
 =?utf-8?B?T3lBUDk4cUVQZ2tPVDNhUk54UEg2WFdPK1FWV2FDRXREZWIyYWloSVMvVlNP?=
 =?utf-8?B?U2hDWlhQUlkwcnBYTjdMMG9pL0k2OUx6TlRtL2JLT0xOaHNDUVhWV2RCSFVX?=
 =?utf-8?B?VVRKZFVPR2wvYTFtYzFnUTR6ZjhZS05MSzh0d1FDcGlhVXRVdkhncXlYYmd5?=
 =?utf-8?B?eDNJZUZ6M1ducHpiR1Brbm9QQjJTVCsrSm50VkpTWjZRb3dTUmxvMU42aEhQ?=
 =?utf-8?B?akd4ZlpnVmR1VmtyRkhSaXFHZkhJR0dGTFgxQWFUNEJoVC9DaVJCeis5cTNM?=
 =?utf-8?B?Q1p2S04yNU9SZTlJczNDUnRZdWxrWUE0RlF3NS9tKzliRUpQYndjWC9xc1pv?=
 =?utf-8?B?TFAvTTNiUzhqRWZPaDRNZEFRMHpnQ056ejM3N3FucjNLY3EzMDIxVEdWOHY1?=
 =?utf-8?B?OWY0enFlOGUrVUJISmhxNTR2eEplOHRDNDlvL1h3ZjhOM3pQM3ZpSGs2WGZT?=
 =?utf-8?B?NmlUbm1PbC9KUElWblVtS1R2S3hndytndlJVTnBEbm1mdkhNVlhrQkl3QXpz?=
 =?utf-8?B?Y2N6cFhweFExZ0YxWkR5RVlvVFByM2RyRnBRVTVGcElaYnlzUE9rUEU1T3A1?=
 =?utf-8?B?OGdlVXVnYmlsb1ptT2JuQWVYNmRxeTNhQXRPREVLY1Q0V01STG5sYllYMWkx?=
 =?utf-8?B?NWdJcTh3WEdOcUs3Tlk2eVNsZmZLVnpTYXRsYUpDQlhvaldSSlBhemlJM3dC?=
 =?utf-8?B?SEkrM1lwaWp4SmRESC8wUXd4YWlaVENZdkIrczBSVHkyRW14Z2NDZ2NCd3kw?=
 =?utf-8?B?c2Ntcll2MWRJMmpkaWxvTHpQMzVmeFliQ0t6bkpiT1RYZDFPZnp5YzJzUHNY?=
 =?utf-8?B?djA2RnBGUG1YcldpMlJkNTRFOFN6dkpiaENTeVExUjJnek5uQ2xFR25laEdv?=
 =?utf-8?B?cENHRDNncU5SMEFXejdqSERSN1VhbThuQ2QrZHpGNTJkajVRQTA5Uzg5U2VW?=
 =?utf-8?B?Q1FkL2wza0RiTEt1OXlaWERCaEJTRkNJSEVKRmwwNTllQWwrOEZQLzJKSXpr?=
 =?utf-8?B?cUMzMzZIWjZKWHV4UmpqYkpoNUtMNTVvVnp6REV2Rk5wSThISU5Nd2l6Q0F6?=
 =?utf-8?B?NFltRGlwcWw0VzNOalIrUksxaVlFcnZ2d29UR1BJZGJPVzZrMU5mbWV5UjJu?=
 =?utf-8?B?L2tsVXVDMExpWmZpbFdpVU95WDIrZklUZUZqSzQzZytTbmlHWmNGOW5Pejhn?=
 =?utf-8?B?aTNjTzZmaW5GNkJSM01YSkRQZERxSWNGYzhSNkRhR0dRVEZyVytSZklOSVJT?=
 =?utf-8?B?am1tK2RWN05wQ2tkdDVDa1ZEWkxuU2dJLzArR0djekVmaytDWTNCU0JLS01T?=
 =?utf-8?B?cVB4QjhDaEpwR1BCY2tVUnBuWGN5YXNTbEZtZ1J1azMrTzFOZllPK1pGNUx2?=
 =?utf-8?B?OWplcXNUVUlIOU5tZXFwbUg5VHlTTEY0K2kzU2xSRjJYakMxSmlHM1gwbFE1?=
 =?utf-8?B?S01GWmxJSkt6eStxSjJHdG82cldxeWs4VVoxY1hRU25yUDh4UjFud0tWQzVj?=
 =?utf-8?B?OERValFVUU01VklNenhXUmRoWitGdjY2Y25WYlpYc3RzZzJBZ1Jzcm5mdG1z?=
 =?utf-8?B?RUZSVGtYQTQvU1J2bnpmcStzTGNJL1hRVnducSt0S3ZVTlVQWm0xK3Vzek5W?=
 =?utf-8?B?Y1JvckxqQXA3bmRWM04vRE9US25XbEdobFVrNXdTSG10SHhVYzNjeGQwVDFr?=
 =?utf-8?B?dDNMeTFsM3BuaURiVlNlQWUxUGlxbDBxRXdEb1RsQUd4RXkxM1dyalR6MWlS?=
 =?utf-8?B?dm1HWi93L3J1TXNUNkx2SW9OV0wrbExhUWRhVXdIR0tzZWpoQllIVTIwUnov?=
 =?utf-8?B?UnlIdnhWUGZybnNwd0U0THFuTGVxVVJVclFTRDV2cTVEcExubWJrWDdmK1JB?=
 =?utf-8?B?cnZOSzhJUGIxRzlKQTJJNkZ2L3M2UmhDR3EvdjRPNCtZREhnWmttSnJ2S1dh?=
 =?utf-8?Q?wXbJFSmhBKjTd8ihil1SgvH8s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2db193-1681-421b-f8f7-08dc582d393b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 00:37:23.8941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P68GTJ8UDF7pGJ8am0YWv3zWSfCLNhes7ZcHtn6ZNn0wgXU3EgtT4FmBrK4x5rVZjIUj4AqHbGcihbfRV9phFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8051
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> +struct tdx_enabled {
> +	cpumask_var_t enabled;
> +	atomic_t err;
> +};
> +
> +static void __init tdx_on(void *_enable)
> +{
> +	struct tdx_enabled *enable = _enable;
> +	int r;
> +
> +	r = vmx_hardware_enable();
> +	if (!r) {
> +		cpumask_set_cpu(smp_processor_id(), enable->enabled);
> +		r = tdx_cpu_enable();
> +	}
> +	if (r)
> +		atomic_set(&enable->err, r);
> +}
> +
> +static void __init vmx_off(void *_enabled)
> +{
> +	cpumask_var_t *enabled = (cpumask_var_t *)_enabled;
> +
> +	if (cpumask_test_cpu(smp_processor_id(), *enabled))
> +		vmx_hardware_disable();
> +}
> +
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	struct tdx_enabled enable = {
> +		.err = ATOMIC_INIT(0),
> +	};
> +	int r = 0;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!zalloc_cpumask_var(&enable.enabled, GFP_KERNEL)) {
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> +	cpus_read_lock();
> +	on_each_cpu(tdx_on, &enable, true); /* TDX requires vmxon. */
> +	r = atomic_read(&enable.err);
> +	if (!r)
> +		r = tdx_module_setup();
> +	else
> +		r = -EIO;

I was thinking why do we need to convert to -EIO.

Convert error code to -EIO unconditionally would cause the original 
error code being lost.  Although given tdx_on() is called on all online 
cpus in parallel, the @enable.err could be imprecise anyway, the 
explicit conversion seems not quite reasonable to be done _here_.

I think it would be more reasonable to explicitly set the error code to 
-EIO in tdx_on(), where we _exactly_ know what went wrong and can still 
possibly do something before losing the error code.

E.g., we can dump the error code to the user, but looks both 
vmx_hardware_enable() and tdx_cpu_enable() will do so already so we can 
safely lose the error code there.

We can perhaps add a comment to point this out before losing the error 
code if that's better:

	/*
	 * Both vmx_hardware_enable() and tdx_cpu_enable() print error
	 * message when they fail.  Just convert the error code to -EIO
	 * when multiple cpu fault the @err cannot be used to precisely
	 * record the error code for them anyway.
	 */

> +	on_each_cpu(vmx_off, &enable.enabled, true);
> +	cpus_read_unlock();
> +	free_cpumask_var(enable.enabled);
> +
> +out:
> +	return r;
> +}


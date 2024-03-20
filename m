Return-Path: <kvm+bounces-12340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B765881A1C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 00:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B640B210B4
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7758613B;
	Wed, 20 Mar 2024 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJcFLL0e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A4033062;
	Wed, 20 Mar 2024 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710976216; cv=fail; b=i5kXfvTtBA/J74hz4tbnjnQQHJDDH7ueYeajx6F+gBlw08O1WdyUqjuAF4cjKUWmNxu0nZYwaxa6JG7cT3mUHjL2nR+laQjLyiJb0AZ/y4E0Ere5HATPf/O3uvBkOcQB1sb2Vf+Rtt6UvAVQAIrzdc5lakACn8O+IiDU+/CUSsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710976216; c=relaxed/simple;
	bh=josUrL4x00dCnEpUKCdvf27XMZO6Z/QJibmJOXjO3uQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k282l/9SutbP1wHOrJYotlSFpDmoJRdEjWOsovHiAVMbWed8GWqIYW8h8Kz9szlAcsEfMOBeDzOz++iaceZfsDglcK9KWKSE0oT3JnucoDjOSE4yXu7dNA1JxdZ2ecJMYdwoFkxK+uPzGZA8Sb1cC8iR7zjrU6QOPyd5RUw6Jxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJcFLL0e; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710976213; x=1742512213;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=josUrL4x00dCnEpUKCdvf27XMZO6Z/QJibmJOXjO3uQ=;
  b=JJcFLL0eNSol5qhapm9/Sqj98cvusWxvgquFuHiN2pU1JwGemwcJ/fZ3
   qMFdx3rXfT4Yc0EZo2VeWUnzVZFgN/LS3Dzx9EL+nTJi230qamGnbEq3A
   gQo3WFZufkPxxaKv3HbhIyxInVoG+pmt+PUmkrBc6lMqjCoOj3/PkDa/V
   fEN7m0fX8AzDZSCCT2T2pmcj7Rdc0hX/LI3bni5h5swAq7/z93rwj7AXV
   SNPkyenlJxK/jPYU+zC5M5izruC1+TxEtiuE2eIuswgWf9Qm6vj/XMlKl
   59OFXQ8/5JSLYrywI/3u0mRryTFIvTp/UwzrJrQfIpQcovMKLPnGnRt7o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="9748878"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="9748878"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 16:10:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="45288893"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 16:10:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 16:10:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 16:10:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 16:10:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 16:10:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0sNwIIrqY2JhyOB/d6lwZkBvfeSvb+hSqvwDawTPAuFsubCr+zVS+pGo3wtrP9MZPKSBuuh2uGPQ03HW1w1FYFZSg8slcwbxwmg3ew088Xf1H5a9bY3qoKNmd2sEgnaB9pntqsMSjxRiWqUyPGrIeSJ5XbNYKpkl+N9VCDekQIK5SmlmiNds2Qlg4jSF1qDhynoA0iBRhHa/4arW8b+8aGQRtAZVnFuwWC4mWG1UKa8TtyRJWbtLc/PLr8LSkJSTCAdmGFJjzEYbrKYJfBcEH/Na4omnnPsHnQH7Zg0tXuXxoQ6T+qKXYWmi9hF0HoPXJTr08358bmg9vycxOTccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikjtvuNWog5uq5WO/kYWN+V+/aXQKQzRx/jgkUa4rD4=;
 b=Xc9r0x16mCK6i22Rq7jXDRaUu+ErHn2T/1VKEhiIwOqcf7OOe1/hMTz8qTcQIYARKwIkZQ7mepuHz5Kg34tXAebMXrn91TgsPkz2yuSRRy1tgrgHN0/CGNxzssAgdozy2NLXdTvNellTm5IzP0tm/Ka9cJoEv3oIxOifHoshCTzhplQRPkWglhRmDVAOFMqyp1JcPJFkES18iYcbl66EI3kqiJTuCz2/TEURZtKTsfp2ld0EcdwiJDchb+CYmAN6QSuV/HjVHJmLXUsq6URJ4eej4P0Wa73Cm3v58DZkhQ5AiPGQsH092j2uQYj64EaWNnwXzD+BA5xPP8oW7QIzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7569.namprd11.prod.outlook.com (2603:10b6:510:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 23:10:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 23:10:08 +0000
Message-ID: <76e918cf-44ef-4e9b-9e56-84256b637398@intel.com>
Date: Thu, 21 Mar 2024 12:09:57 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Yuan Yao
	<yuan.yao@intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
 <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>
 <20240320215013.GJ1994522@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240320215013.GJ1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:303:b7::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: 37c759bf-ef82-4434-345e-08dc4932e307
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YZMw8guubsleVFCRtQxtgGXZJxL9T/ZIqur8es0llG4Q/XlvcNQFcouPfkXbW6VXZnXMlEgEJFd7tSHN3Un4joa3bqHBWL66xza9FhAz0/QwU2vXIDPOylYxYpdppalJtHNo3pLGzCPC+m1biT3BANzYznfb4dQ6RSITqBnEAyqlo2mnhrQFflNRVsP2hFr+b0UsJX3fsqNG9cIi7rp9sXxvCKWRB3y/X0P9rD1Uva12ocu4ZGEjVy4UHyeFcKEiqATHoaO959jUY8ngnC3Iko7wBMU4XEB8nSqxCApx0jSp8bmDRem3haBUEBbB4Mar2HZt+363NVTOBzg+c3IYkaos2m4B95fNkir7lFp3MI/tJNJdDW97H7f/VcCICbgUbI7eb8K7fVhjSXWcvYEZNzM+unQc4+CBk9znd7DOullx4sqF5vLCYUL+bf7nz5ahotOq3acxHgDYK5X94waIG+sWlxylfWSl5KRk1nJK7xuw8u/sZHhm5rUO/iS8V44Bi+cQDrX1T9WDmchwPZQ++buAMWxanmRy9FW10oJwK8EiEYgeQJ8RyIw8i0CzmrUzyVYHu0ScK7bEsCEPQjQhT/6qGCxy1O4rE6bcwBTY2ZUPtrgV1hRhYn/xaDoMn5vyXT97EOIfNwD6Bt0SQY8M0O4hSFzBdq8CpYv+QbWqwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enZIZTFKdCt6cXBSZGhyMnpvcWZsN2cvVjRwcTJlY0ZxSkdVWjFBUTF2aHp5?=
 =?utf-8?B?NzlOYjgwWUh2bHdrMmYyeXVuN05UK2FzNDdlejhGVUJja3cxbFNwWkhwYXFj?=
 =?utf-8?B?RVhtU1pJVmUwMXhjRXNqUGw5bVRtYXhLaW9keWtUZ1g3Yk9pMVowMThSV3Nt?=
 =?utf-8?B?V1pmN1FuOFprRVZ0MjNwUzRrbXpJK2s0L2pVNHR2dmVQbnVMcjY2dW1sOGxy?=
 =?utf-8?B?MnVsLzk0ZVZ0WHhnS2xYQVpCeEp1ak5zcEdCQUozM2ppeVZob0VyU3hmckVR?=
 =?utf-8?B?VTZxb0lnOU9FS3dNV2hhR3l3RlVDbWVBWDhicFRmdGNVNFkvRDJPZlJzZnE0?=
 =?utf-8?B?MllPWFJyY29tZlJVcDNaYVk4Nk1VajJ3RkdvOG0zM24yeGZOWktyQWRFcEZF?=
 =?utf-8?B?ZFk5R1RzSndWREdLUjRpNi92UEk1QTU3MFM1YXNORXJBbXRJK3U3M1RlWUdN?=
 =?utf-8?B?YlZvbURhSDkvV2h5dTFKT0dXTEJtMHV5UlRHUzJZZGUzN3F1RWxDdTV2VVFz?=
 =?utf-8?B?OEs3eWRlaHczSVpQbXo1Q2dGbnBnbU1ZUVlGWlFkZ21nRks4OTFKcms3Mlpq?=
 =?utf-8?B?NEZyMjJSNm53TkNsR0d3WGJkV1d5RFRYcUFteThVdWZBSGlwQ0tCdDZXT0N6?=
 =?utf-8?B?SEJZWXFsR3JwS3Zld2pRUzVYWjc0cjVUUXZsR0pkSHlmU3NIR2l0am9MQjhv?=
 =?utf-8?B?ZncvaGJxbTYwUGRienVZcVgwTnFQUS9VeGFxUVhBa24vVXkyZnZEVUhraGtG?=
 =?utf-8?B?c0RxWFZEakhMd1FlWSs0Z1grYzVWQlJDM3ZaMGxMaTJHUitXdFQxNTNiWnFx?=
 =?utf-8?B?blhvT24zNVZ5REZwM1N2QlpNRmxMaUpZWElHRjU5VlBENldQMGRYRW5ZMUlv?=
 =?utf-8?B?NjYveWo4andWcVFVckd3dmVoQ3FUVkorbmVkcU9BSmJ5MWZ4UHhwdElwei9S?=
 =?utf-8?B?cm9oRmQvODVnVzR0ZjV3aFBOT3BXUzh6OXZGVlJhcEs5cCsvR0ZEVFVCc0l0?=
 =?utf-8?B?ZWlSMzJEOGQ0Smx6UHg0bXlsVjJFQ1JvYkpHTERvdk9BNXBLSTZSVjl3aTQ1?=
 =?utf-8?B?Ti94ZEJEOHdZcnFOMmlmUUVXb3g4RktmdEtxalVEb2thTzh6a2ZISUdweTNw?=
 =?utf-8?B?bnY5eC9wT3RCSmExNWNXMjh4d2M5cW9rMUQ0d3pPSzVONEh3VlNzV2dpWXF0?=
 =?utf-8?B?TlNGMUdLVlhGNm1Yb0JJcmlTN3BoSEhrejFiREtiM0VIbTBEb09KUzB0UURD?=
 =?utf-8?B?dEJhVmxpS0xsTnZSMHZnaHZYRndheGt3QXJHMzN5bVlkN1p5elJTZzA2TW5n?=
 =?utf-8?B?K1F5THhzbW4ySHNFcnZaSWMxanBJNW5zcHFzK1dXc2FVQmFpcm5JcThJNmI1?=
 =?utf-8?B?NzNQTEg5UXJxaW5pY1NDVVorYWMwVG5uekRDenRVeVVacWNjcjZtS0hnWkNQ?=
 =?utf-8?B?b3dHMVF3eGVTUXhWYWliUEJJNjhpeDdyaXVLQjFGeGM1TTVOMFRYVVZ5ZTB6?=
 =?utf-8?B?eERRNlZnVWZRbTU3clNpUmI5OFh4RTM5TDB1eHF1WExuUnA2c3lpbDVyd1V2?=
 =?utf-8?B?YzdMZFJjTll2R1ZsWkNHQ2tZcFVGdVFvR20rY3hpeFY0WDBqTVNOUnN1VWZn?=
 =?utf-8?B?T0kxekJBbHdOVEpVTFlLSHZ6M2NYbzNIYlJIdkRhOTVEc0tCU3BXd3pwdUpL?=
 =?utf-8?B?bjdQSEdXL005cXJoOG9pWVJLV3RmNEozUXArWStETDB6US9PTmtmVTcwcE5k?=
 =?utf-8?B?Mm4zZzI1TFE5eXRwZ2JvY1M1akxoMUYvTHcxUGwxVGd5S1VUaURrKzlid1Zw?=
 =?utf-8?B?OGluWGU3UFhIWUtPSWtvK3hheHFtMXl0OUpUMjRTRXMxMkdlUTY2RHhuMk1z?=
 =?utf-8?B?bHliaTNRS2RUcE5oMCt4dlEzOUgzV3BsQ2x3K2hhbjFmN0VkemhBRXgzbHUr?=
 =?utf-8?B?QUJCK0ZRT3ZndGVTYnlWSlRjak92eEd0REx0OWlrUGMweGFxa3B6a2QzYzdM?=
 =?utf-8?B?WnA3K093bE8wczVGL0plZDA4Q2VQRjNyV0Qrb0lNQzhGVzZkN3BzSmFUK0Z2?=
 =?utf-8?B?Y1ZSdmxkUmdEMW8zaXR2NndwMnozYVQ3VlJoblk2Mm12aDBseFZRK0E4cjFn?=
 =?utf-8?Q?t+WqGGxruq8cZG3qGriVkv1ZG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c759bf-ef82-4434-345e-08dc4932e307
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 23:10:08.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yPfPLC3kJi4+lb+mf+F7CYP4+uGJ9AH3Bcx8kMMXgRyTxGxugw9SsQetpONGnd1ZYAzSqsEo4GgzIzSXl1flw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7569
X-OriginatorOrg: intel.com


> Does it make sense?
> 
> void pr_tdx_error(u64 op, u64 error_code)
> {
>          pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
>                             op, error_code);
> }

Should we also have a _ret version?

void pr_seamcall_err(u64 op, u64 err)
{
	/* A comment to explain why using the _ratelimited() version? */
	pr_err_ratelimited(...);
}

void pr_seamcall_err_ret(u64 op, u64 err, struct tdx_module_args *arg)
{
	pr_err_seamcall(op, err);
	
	pr_err_ratelimited(...);
}

(Hmm... if you look at the tdx.c in TDX host, there's similar code 
there, and again, it was a little bit annoying when I did that..)

Again, if we just use seamcall_ret() for ALL SEAMCALLs except VP.ENTER, 
we can simply have one..

> 
> void pr_tdx_sept_error(u64 op, u64 error_code, const union tdx_sept_entry *entry,
> 		       const union tdx_sept_level_state *level_state)
> {
> #define MSG \
>          "SEAMCALL (0x%016llx) failed: 0x%016llx entry 0x%016llx level_state 0x%016llx\n"
>          pr_err_ratelimited(MSG, op, error_code, entry->raw, level_state->raw);
> }

A higher-level wrapper to print SEPT error is fine to me, but do it in a 
separate patch.


Return-Path: <kvm+bounces-11614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B0A878C6B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5236B21786
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F33946C;
	Tue, 12 Mar 2024 01:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNaf+lhO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065B98F40;
	Tue, 12 Mar 2024 01:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710207801; cv=fail; b=c/ak7DBPo9WndebNpH3Wg6HT5e1EpXaZKlZuNNHrHpITsBxk9LFYxIvK3Q5VYLQE1b8iorkhxlcLqVPrjwMhM6fICEkWNfJBhrIWnDMFekQFJm656UBiU0B4Ektqf/AVlrxk4iNqrwsESejF/iWSwBOcrolNMJMQJ66n1KA4tB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710207801; c=relaxed/simple;
	bh=mptOHFwwnX3fO5G/pYc3ZGPzkFSFm4FvmVfyiJJ0mZc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H0IZK6fOURQ+CF5Y1hIsJveFQ6idJm7+P6ReT5k7/d9cEWUsy2432133PkPzIqQtBvhyEdz+NIf4Jk3KcRtj/88bFhTFlTaC/IxZQ0vWQeVQGbwRZXt6kf7t8W6tSuiYtj+wgvSKaY/gLlN4Z1xQITElzJa2MP3o+7Ow7rwJpbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNaf+lhO; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710207800; x=1741743800;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mptOHFwwnX3fO5G/pYc3ZGPzkFSFm4FvmVfyiJJ0mZc=;
  b=UNaf+lhORYb39dbCkBCzO61e04Q7H/7+csxFrwEFaiFeNDVWRP1/5hFs
   Zhb81edxDeW2rmQz/cVAHZ5Qv9zSqgI0W7UOX4LW0f3H5T2w7ccZn8ond
   NgK4qMlYdd6Ok6HPSHeWa/IfseswSk9GSCKisAS/kVXlsOFHcQnDCm6la
   /4XkjqZAvXY4yzYC332WByh0AQBpq7jW+PJwgtQAWrh9xNF3cND1GaU+a
   IZ5DClAHvuefkttkCIpm1YHM+5SpGpQkcWsQrDOiBpgcdPGA+jRv4md2d
   TkRH363cMR7TzCqZmMwVE1CBXqc0oUk/yxeud+1EIfksgDa7ZAX5AefOA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="16340632"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16340632"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:43:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11266590"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 18:43:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 18:43:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 18:43:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 18:43:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 18:43:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGyPckg4vy2ZFOfuynQ0SyNWDhRuu5CWbjIFEkWYUw/pwIp6sfwRpq6hguym6++zywznJ5E5gt7AOH9Km2oY65gk0EDeR265S46VaHG1npNfXEP+Mb1lrmqwAPnVQ7WCc3egvLYPp86UfRY3tUR1oXv3dslPpBUsa32L1XunAuT+DTz7E7YfoclU3x6Fw4BmE/zSSkz4aPY06EXSM2vw0M+tzsCGUidOtkW1g/I2TH0kXgDfDmEGQJFI2Vo5obiShsHaZQ/o079IVy01oskp0L8oNVKEJLLLPZVDVuNhxevDIdXOQFvQWh3lj8MKPDSgjLgTSNZeKKVV2OTqbKgcGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6i9uARQkJcIZn1nsGZV25zLOCfiUu60zXQarHmp6P7g=;
 b=ZTf/AHbAo6kAR3LXI3pojEdYSsZByEIOInR//BmQV1HjMhMGdd8bIJX14W8wOQNoBV11eQHGj8mu5Q1RQoGsR7P9rfWrDEMkx7IxUVT3w6AOAKgbDZV+6DU2ftGGo4+9+lDjUcZ1PdgYGDCerugSMOiSAaZP5c8LCQ7qwe3Z54OHtMsOnl7t2jU/zEmnWqqJGZW5aA00k8iuM+95Q/d4m7hvH9pvsaJksDxpB5iyGWGSz4hiA4A++pe/zMkgndq0MvJYIzzzzW3KZZscAMoDkiX9NaHKPHFI+UPHoVGRNfRwjDclm6pfVzfA2C9V3CWcl1ebV9m9TcroS2vIolQpVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Tue, 12 Mar
 2024 01:43:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 01:43:16 +0000
Message-ID: <b464d076-e146-4bb0-8cf2-3159b9928da3@intel.com>
Date: Tue, 12 Mar 2024 14:43:07 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: VMX: Modify NMI and INTR handlers to take
 intr_info as function argument
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, <michael.roth@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-10-pbonzini@redhat.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240227232100.478238-10-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0283.namprd04.prod.outlook.com
 (2603:10b6:303:89::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: d6fb719b-b4de-49e4-e982-08dc4235c9a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BMMNMhqSzzyVAZfXSofFjNzcly8hZ38tNCmysUo7Ni+5TjX/VqtKEEre966MqOb6k0Tmraz5F6FBU4FVd47rFCx3krhvJe7vJbcZUauS/2JGM9z7VdsZ+pF5CSFPyH8Sc+A4uRGQ4OR+WTqGBVxab0dTmFIMwTV1vIHOEZa73jm+fdXrylAcs3jhJGbpoZfvwD2qmFu2dwUu8HTigxthys96azGskw4KE63650yr5D17fPmM1JnfJ7oTpX5957ybiwpGjCc+xqMdab7+venWJwgRfLnSHl5mAKOUkJ2KBCbLIcS2NYNehrn4E6oRaQ4dThAbDX8dL3nJaWR1u2swlDfqD2BeolKOIBVH7AD0oQ6ywP+rnz4zy7Sj52wRLh8L1bifKTN9AJMMmjD/Y2kCXPVJEV/l/0u9Hs7ahV0Wm6XMU38zHJKV3xeO74i+HauiLDpdYFN39/uqXd9iosDzrXnFpmKgUyxIRaBx20JOOJG7NvUJoHL8y8uiaugl6aVLLRaqtikgoJxPeZxw6KFqKi/I419bNLadCHAnQUfLc9X0Tmz/zLWQJsyl1n3QRhY2/xyLo1SjbWktLIi3MJyAdRkSKrTitVgazZnizr/D5Co6PDGJbGozd9Mj8FzjjZumb9tykSeSgYgLwaGwx0rQLcm2bZVaeViFnGs5zi8CDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3dGSWI0MjBTcS9IMURUdFlBTXZNYXh0ckFwdGhCM1ZjMk5OMmdyeUF1QUEz?=
 =?utf-8?B?WFc4Sm8reitGNHVDMFVrQmgwemlDZ2syUDkybkwvZXdkdzkzMmNDNWpnT3hZ?=
 =?utf-8?B?N0JPcTBQNHl6T2wzQlRJK2pSbUdVNVNmdTJWYWpHMWVDelVjZkk1TGxValo2?=
 =?utf-8?B?QlFQaUxsS3lXOUNrVWpiZDgvRmU3VUtUL1ErVXFRVXl4dXRWL1JZUGoxQVdu?=
 =?utf-8?B?bDBvVHRpbkZxYVdhT3lkUnFlWDB4cHo0WmlkdVpqWTdFb3FqR2NZV3JWR094?=
 =?utf-8?B?d0ZkbnBsWTkyYzR0bVlkZnh0dGVGZzNsWHE5b1p1VEVwK1AxMi9ZZGNIaURK?=
 =?utf-8?B?T0k0bmtLUHo2aXpQeEplaTFFMG56VU1jZ2NrYXlZdWQrUEwzMnpqTUppYWdQ?=
 =?utf-8?B?eVNmeGxuUWhkUlRhL3BHZFFBcHNROGNWbDQyc3FVUjFaM2J1bVdDTVpxN01U?=
 =?utf-8?B?SG1xZjFkNFZHMDhnQ3lwTk44Rkp1MVNUdnpoQ1BZTXNvNUM0VTFkYnVEbnU5?=
 =?utf-8?B?UzhsTFJNRDh5dmV3bGNLMmR2MlpvOUY2RjNEL0owMHBZQVV3T2Mxc3lqZEJK?=
 =?utf-8?B?aEJmK1dLQ2cwZ01WYVJzdU14MVhnVTNvdHAzQ09zMjJvWktEVXVkM0xyNkha?=
 =?utf-8?B?aFg0eUdsUk5mUld2ZXFWWm82TnpJS3RtU3I3QVZEcnBDQzRmOFp6cmJGWUpU?=
 =?utf-8?B?MW1uTEtTM1dBK1NmbTNRNkdScVl6ZXNQaEMwb1pvdEwreHcrdC9nRVFZS1hF?=
 =?utf-8?B?enFkNHdZZHpJWWVIODk3d1FYOEcwNHFVeVZjanBveWwrM3FPLzlkYzFVbG1y?=
 =?utf-8?B?L0FxSUtUN2hZUjZKck1Ic1dYTEhwbGF2WjY5dHlEZlN3a3AwdEFQTWlHZWE4?=
 =?utf-8?B?ZlhRZ3VNTi9iYXZyT3Vqd3dGTG9Hak9lZWFybm9vYVh1REYreGI4dDhVeldX?=
 =?utf-8?B?ZExrRi93Z0FKcXVQYnhLN0ZuTTJ6ektZSW1DODg5WmN5Q04xRDZ1MUZSRlgx?=
 =?utf-8?B?VzRwMDV4U09aelY4b0JkbGxRc3pVS1Q0Y1A5akptN1o2bVFiYkJQbi9OMTdm?=
 =?utf-8?B?RTgxa2YzS00xR2o4MGpXcjZoUkhmM0RKVG04R2JYYmVIM1VSM1BIVXc5cHVw?=
 =?utf-8?B?RlZiRGxsZDRRbFc5ZU1rNWhucUd4WnhwZ2NHdTE3RUJkbDlDUG1hOUhsYjlm?=
 =?utf-8?B?UEFSaWpYUXNyK01DRlRFR1kzTGdmSUJaaEptUUhxZ0ZLQ21hVFM5UU5uNGJq?=
 =?utf-8?B?RkwzUmc0cW9YSWtIdGk0cDJjTEI3bXZmekVvZE9MYThSaksyZXNXMElOTGtV?=
 =?utf-8?B?WlY3UUNPd0x5Tk1LZGhVQkQyTXFWUWVnSmQxdGQ5dUdWWjFOY1NFZDNsbWpO?=
 =?utf-8?B?bUdZK0dHbmdOaEphK3hjS3VPMnFnNXovM0Z6RlQ5WkFJK2RRSGRGcFlENjh1?=
 =?utf-8?B?V3d6Z3BUYkI4eHpIOVlqeE9vc25vQjdiYlJxOWE0cE95WlhrRTJiZlFKV09S?=
 =?utf-8?B?azZ2Y2Zrb2YvcVUzZFA0bUg3T2I1Z2pSdXJaZWJMUEgwek1yNUNFMmdIME9I?=
 =?utf-8?B?OTVRN2s5blBjaENMUi9yajY1bDM5UGZxUXprb3RzRS9nZ0hnZjVOZDFuV3NR?=
 =?utf-8?B?WnFYVWQ0K3JZN2dOd25TM1MyQmhFbW5taXRrb2VoSG1SMG5EYWlxQVlHUHF6?=
 =?utf-8?B?RUFnS1pkTm9xb0U3dnlCMlJHbTgyZEYvdzZRWUZoMFh6TXlmRDdpZUpDMTdp?=
 =?utf-8?B?MlpWMkRuVVM4ek11Zm1oVXF1ZnZmcnJFLzFUb3NnZmdRbWJpWXgwWWhKcjZt?=
 =?utf-8?B?UXcrY2h6RXVQR3NMN2I3a0NFSzk2ZTRuQUVzbTNjMWRhN01yWldpdFhpMCta?=
 =?utf-8?B?MkZNQUNVS0h6alI4M2VoNGtQSUxFai9DRGhPNnpDMXV2bmVpcFlMbGZlUEN6?=
 =?utf-8?B?cU0xdGdCQnZ1UURQL2Iwb2o5OXVOQlFDL2lCaHFOTUdsNEhPME9QdkR5Mzhj?=
 =?utf-8?B?eFkwUzRGbVhoU2V4TlpZVU1ETjRFcXlEZWp2TGVId2R1dDV4UFFXK3FJMmds?=
 =?utf-8?B?MjdvY0pvTVpxWDNrNG55cFd3SitxNFJpcElFUjd2dFR4UTlmVWxna2U3RENl?=
 =?utf-8?Q?Yi/MlXGGTrM8Q5tNNO1dIhLN/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fb719b-b4de-49e4-e982-08dc4235c9a6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 01:43:16.5635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLnVhFDyGji+Ln8XCiGxe13/tM5AGth8nyKG2vmn/QoBxZITvx0A7oS9f5jY2Sgkhu8Ge967xFnGRG5U8i8/4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com



On 28/02/2024 12:20 pm, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> TDX uses different ABI to get information about VM exit.  Pass intr_info to
> the NMI and INTR handlers instead of pulling it from vcpu_vmx in
> preparation for sharing the bulk of the handlers with TDX.
> 
> When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
> exit qualification etc rather than the VMCS fields because VMM doesn't have
> access to the VMCS.  

IMHO this can be simpler:

TDX conveys VM exit information via GPRs while normal VMX does via VMCS 
fields.

The eventual code will be
> 
> VMX:
>    - get exit reason, intr_info, exit_qualification, and etc from VMCS
>    - call NMI/INTR handlers (common code)
> 
> TDX:
>    - get exit reason, intr_info, exit_qualification, and etc from guest
>      registers
>    - call NMI/INTR handlers (common code)

It's kinda nicer to mention why to change handle_exception_irqoff()'s 
first argument from @vmx to @vcpu.

Anyway, doesn't matter ...

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <0396a9ae70d293c9d0b060349dae385a8a4fbcec.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

... Acked-by: Kai Huang <kai.huang@intel.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3d8a7e4c8e37..8aedfe0fd78c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7000,24 +7000,22 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
>   		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   }
>   
> -static void handle_exception_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
> -
>   	/* if exit due to PF check for async PF */
>   	if (is_page_fault(intr_info))
> -		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
>   	/* if exit due to NM, handle before interrupts are enabled */
>   	else if (is_nm_fault(intr_info))
> -		handle_nm_fault_irqoff(&vmx->vcpu);
> +		handle_nm_fault_irqoff(vcpu);
>   	/* Handle machine checks before interrupts are enabled */
>   	else if (is_machine_check(intr_info))
>   		kvm_machine_check();
>   }
>   
> -static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> +static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> +					     u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(vcpu);
>   	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
>   	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
> @@ -7040,9 +7038,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   		return;
>   
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> -		handle_external_interrupt_irqoff(vcpu);
> +		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_irqoff(vmx);
> +		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   }
>   
>   /*


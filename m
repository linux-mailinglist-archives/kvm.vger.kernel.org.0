Return-Path: <kvm+bounces-11338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C059875B67
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 043361F22914
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 00:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B54810;
	Fri,  8 Mar 2024 00:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLfwM69i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BC363;
	Fri,  8 Mar 2024 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709856578; cv=fail; b=H/A0xNoeXIOm9BnTkCkCXLScricwVyiO9MivpooOPen/IWSmWYtDZ7VFyoevIYYYYpOwg4Zskbe7ulUeogGgR02w4TUwMzF+D/iEdaRD0GcCnifcLt1xOc/et0SxJO7ab0my0H10f13s8LthA3uHyW0og6UEAnEQr9VZyq8a+Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709856578; c=relaxed/simple;
	bh=akDMfWKKJOcQl8wG5P5HzyDV2iazyruAuCv3Pt82m1U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OrSpUPznd4CB2dscCt7FxnYyfufBC5VY3BZmjP1wVkCrDe2Re8j+24vmW6mSXqhDliHyllk1dm0j+UMI490NravhuoNLoIp8N2rbmqIVUFLc/wKI9djompCNn6FgObJFu77PPRB4W1mQFzAqercJ3jLfTHn+yHWRatSCZerbBCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLfwM69i; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709856576; x=1741392576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=akDMfWKKJOcQl8wG5P5HzyDV2iazyruAuCv3Pt82m1U=;
  b=GLfwM69iIISFg0zUXrMrCYbclcS/LCMfpRz5xxUMB5eLc6Za59Ar5q22
   Xq6Y2LVZMkU6u4GzRYi1FkdcmbYlNWTrKnd0bxlUF2vEcLfaeJnqeGjIt
   hF6fVyVfpR3d4k9lnMZ0uiHgigbqmEjMjeUof5Y0k2ws/NXtP2gqBwDEZ
   prC9AwYGdymsoKtC8Ulfy/L4XS2a5prNyuQf2rvXZqwsHm7sc+vVPK1As
   I2SNqBuadNfOyl6wYK5ZV1zT7koprcWR4a5iQ5VZcyEQ+8v7iK5ECFqyy
   zuW8OiwvM+6hwYLPuaf5snrGnf5KLivDV008Oo/N37MqeOe5QdPl19isb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4439925"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="4439925"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 16:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="10170960"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 16:09:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 16:09:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 16:09:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 16:09:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8VfQJ+0k+yWXfMINSszEE732MZ7iZjfa0RQptU9hqoFe9OrNXOUGowTzTYaCynnGqz/ylo/05AD9Fhkxs00+yRL79U9/+cWfkijJC46ogAtw/nhSsmqfTbFHqCanzuWqZjPAvLOYWmfP7lGlZIy0DSO7RxJaTeEMcxqMBDley9o2BnspJgKUXB/1DtR83WnMZf+i/rPqKkB4Wcxd93Yw71gbedZc8Sf/Wyl6xABbRWNog6FQjU0px112b8yyc2byeMqgaGm7RkLrL+/ZuYoM7zoZYGdnsJf35WllS3rZIWruMi+kUa9L8+p1RbBU2tglN2zEtM0nlwm9ivpkhXtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb+IgKVOvxzivX17OneIauj1t2E0VvD+CpCkfeZkukE=;
 b=HLnhRvz1hQXvu/6k6MjazAZZwvJH/7Gvr8VP9WM9k8jSeL3Itn/p+xN1xVUcvX0jOqy+QbW/rayuMqctGxIKnGlG6ojCQXPRw6nbxEdhUTcDoBfgpAQtzNutXtbP9CltA/ie7fHjJ86AtcUCaTLZmP/ix2weJ47I23JP1VqcaJ4NAQqDgarqWV/2YC7ipe6pzxfy10oeWbwpCK6jP0c3baM+VHyaGXztmeHqhdTwIckUxgB7342OBtdGHN5pEYAGV8xe+Yl8d6kn7Ey649VTcRHIwR0yLdH6mr7eXXJO+ygjGoQQV84p//ljFvXCjsfQGL67idpQuVgCj+lr+g5YHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5084.namprd11.prod.outlook.com (2603:10b6:806:116::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.9; Fri, 8 Mar
 2024 00:09:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 00:09:32 +0000
Message-ID: <d0390205-e083-44e7-8046-f5754dd3bf06@intel.com>
Date: Fri, 8 Mar 2024 13:09:22 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
	"David Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-12-seanjc@google.com>
 <0a05d5ec-5352-4bab-96ae-2fa35235477c@intel.com>
 <ZejxqaEBi3q0TU_d@google.com>
 <5f230626-2738-41cc-875d-ab1a7ef19f64@intel.com>
 <3acw6nkfyre4t46i5gmd4lzxxlveiaksp55hunidfhi6lr6brh@7oqn63pu3flb>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <3acw6nkfyre4t46i5gmd4lzxxlveiaksp55hunidfhi6lr6brh@7oqn63pu3flb>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA2PR11MB5084:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc8f467-4ada-492a-c9aa-08dc3f040799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bcCjSNdFwXaHxf6p1r68vhTS+i7PJxatHtRNe5JFHn0/VGqegLDvTYl28t6qPBeIumLGYc1ZgxgergmOP13I/xONgf9enlGXc61xSrUL7HXazhno8/AI/1M5ZXaGxFCHfAEVjpnPULjWmD1VDoTpKziY/imKzrmXfYPyxpoa6WceiNURVbdEfcumgy6kGWjljbul7b5V++WNJebVQ8+P7Ad/vRKGBiki5XZwA3Pltw51K6iYrBwumEoKrEfgETMlN1cJ6Grn3kkfy9x29T5ZYmofDhJB5Smki5kp5Rl8sapbrgmEVyIz676U54vryfUEPQA84Kk3/biUuskkieZT2glHyYd02ai5w2TjnDp/+zVnnuls52fhT3J+eqUXTzTgRwyGHojj6XuZdlgXhdyQhHRf/KdObOB48uRapkZsLOkOtE+S4yI9hnCsw/Trq8/x7N0jZNJlRv7h5+1gnuaaCBNvBUSBcBKzUYAeUwzyRMpd2nY2Imejw4Eg5BmFYLvPTRcoK8ATERjt6olFe79Rw0AVH7OmoGVjRc3W7d11et/+j63efPkiKmc/ni31Wq+9DsCHonVLl3e4rKN9eyJM0dhgNnLaBedKqWxnqG4KEdnrhMY88wQ+4laWjBLLMzKv/bH4mSAiJ4qJy3ozj7lJ1nYpE8zXnHkb1ByFM9Cw8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2kzMU1ZMjFXV0x6bXFVQm95SURhQkQrUVZMQUJvRVQ1RFd0TkNwSnRZRG9E?=
 =?utf-8?B?RWdXeiticnV5VldxY3lSQ0F4eXVLVlh0Zi9SSmpBaDdXQ00vdVJBUHhFTXMw?=
 =?utf-8?B?SmRuQXpPTXdNZVdWOUZRTmswd1Z2bzhxNFBZMGhXL09NZ1lPQzFlUFRxakYx?=
 =?utf-8?B?dFl2STVpeGY1cHNsTzc4d3I2T3I1TUErM3Q2em9uTDFvYjBQYWVnMDFlamRL?=
 =?utf-8?B?WWJEOUpjS0lkUGZYa2ZCWEhNUEhQbGRPTlo3NDFEdksxcGNKNm5RRURyS1FM?=
 =?utf-8?B?TlNzSXdlZllaUStMeitoRG1WZzd5d3MwNEtZK002cURmVGNtMkx4UFFzbkNz?=
 =?utf-8?B?NHdoZFJ1Tjc5QTE2Z0krcFBUOW04aUJKZHVqUDRtdW1JbnExcXg5OUlTYjJ0?=
 =?utf-8?B?UXZTWHBLcGdPSktjNnZxQmRnemF5Y3lFemhHZXFjbjN4cDh2N2tkQzBGSXFn?=
 =?utf-8?B?WTlxb2I2TUhteExIYTE1amNXUndnQmhoUzhPdTkybXFKMG5MZm9vQktlQ29m?=
 =?utf-8?B?OTZqMi9LbUtrcWw4S2NhWEhsb05CVHJuZ3d2WDJ1cDlBMUp0ZGF2VGtzWmJZ?=
 =?utf-8?B?dExpbWlGQ2I4UllMZ3RGNXE4eGZSVHR0QWs4SnFDYUNaTVRGREptMHVKNThp?=
 =?utf-8?B?N0VQRkswRmRxTHIxZ0VPWVlhQndibUZPRjJTekxkMzRxdFRrTHZZcVE5Sk4x?=
 =?utf-8?B?bFNHLzJKWTB2dG9SZExYajdzVGhVQlR2akZWcVBIMVZoMXJxZDZ0Q211OVJ5?=
 =?utf-8?B?V3I3U3cyTnRNUzBXa1lTNmZJd005ZktyWE5JajJMSlNKcFVsa0EwdzFZY2Jq?=
 =?utf-8?B?MXFoNlphNVUzVnpBbFkxQlZTMjNVOFNzNXIrZnh0aitMY3VqZk9PRG5udXFT?=
 =?utf-8?B?U3JkUkpaKzVtdGJjUmdSZlZ1Z2RwTlJDMFM0TmZ3YmUrQ3N3YmdYSEhRYzht?=
 =?utf-8?B?TVhCOWZ6WVdsbFJudy9XMmlNQjR6dklqSFBqOFVrb0JHeW9YcFEySDVETVFV?=
 =?utf-8?B?N3RTSUQrNnhibVZVZHJxakdkMit5MDdsdnp5dVRYS0FoNDk5U0RaendmUnBi?=
 =?utf-8?B?bDhROHVnNk9QRnVpa3BRc3kzWXhmV2o2eHpidlRVYlMrbTJIZXRvajBvSzYr?=
 =?utf-8?B?MzZNeHF0WUlPdDcwZE5MZThIdjdoYjhpbDlPMnJFQy9NajJpYkhGc1ZNOGFo?=
 =?utf-8?B?eEZHa0V0NzZZTUs5alB6SVVzSjlzSDBZSjI5cEI0M1UvSlRDOTlZNEpVb2RY?=
 =?utf-8?B?eGE5SHNYNi9FU3RjUzQ4LzRpWWhTZXh4eHhIN0xpWDNYQ3F6ZEVVemxpNkFF?=
 =?utf-8?B?YXJFVzFWQjMwVUJPSnBiSGlobUtQcnNGS3NESUc2aWdRc0ZEWk96bVp4OXpW?=
 =?utf-8?B?ZVVGUWdOeU9yeWdwbDZCc3NjajhhOHhyaVM1NE80b2lKS2MvUC9yMmpmOGlN?=
 =?utf-8?B?RUlrYmpCenl6dFR6MmxJQVZ6TDdBRExhbStzTlRlbFJxalhIalFNWFROUGhy?=
 =?utf-8?B?QUhuSWw3N2dtUGNuN2NMTGZLcnNOVGdRdUlsTE5zVVlIOWRVT1ZQeGQwdEpI?=
 =?utf-8?B?VUVZOTNYS3pEZUFLblZEcXlqUFphUWF5V1BKWjRUa3o2UmVwNDFPbzhDZ0Vz?=
 =?utf-8?B?aEZLYnVTNW1yakRjd3BOTlRGZkdhcERMQ2QySzUvYSs0Ym5nOWJ1eVBIVTU1?=
 =?utf-8?B?Q01XUktKVHM3S0F1WEx6dzlnN0sxQnkyWjRtSWZLb0dUZWRaTDRETGpsTWF6?=
 =?utf-8?B?WU5wbXBOM09tTGdMeUlTdTI4S3QyaTV1RE1TMzFOckhvZ1RNVnJvWWpFK1Vs?=
 =?utf-8?B?Y2tmMWZBeUI0dFNqRE9RZVJJeHlWQURVdlpTamluMm1yOVJmSUVyNm5sTUNT?=
 =?utf-8?B?dnQrR2VjYzAxd2poN01GdVNaSHM3eE1GRHo0eU9GTm5HMWg4OW5USWNYR0xH?=
 =?utf-8?B?NWJPd3dlZDRkRStCUWJBcDBrUXpCZG9mSDUrWFBsVlExSVRkS3YrQWJHa1VQ?=
 =?utf-8?B?STlYQTZOcjZjLzRIMHBjSUtvSCticktEelZ1QjNDSmIySnI4WGlUNGRoS2xT?=
 =?utf-8?B?K2pMcG1LcXpEdlRrV2JEUE42Z3l3Q3JVMnFabGtUS1BDeEovZFk1R2ZyM1Y5?=
 =?utf-8?Q?KTYIJXlbtsb1lmjxjGrRBxuNx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc8f467-4ada-492a-c9aa-08dc3f040799
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 00:09:32.1531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqDFVMyhTEJwJdWBiXclVl9KYY6MZUoToirklfbNdlJwYeyd9Wsbjd59vuoZuF42tSdhkSX7pe/U2ULAybJEyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5084
X-OriginatorOrg: intel.com



On 8/03/2024 6:10 am, Kirill A. Shutemov wrote:
> On Thu, Mar 07, 2024 at 11:49:11AM +1300, Huang, Kai wrote:
>>
>>
>> On 7/03/2024 11:43 am, Sean Christopherson wrote:
>>> On Thu, Mar 07, 2024, Kai Huang wrote:
>>>>
>>>>
>>>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>>>> Explicitly detect and disallow private accesses to emulated MMIO in
>>>>> kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
>>>>> to perform the check.  This will allow the page fault path to go straight
>>>>> to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
>>>>>
>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>> ---
>>>>>     arch/x86/kvm/mmu/mmu.c | 5 +++++
>>>>>     1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>>> index 5c8caab64ba2..ebdb3fcce3dc 100644
>>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>>> @@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>>>>>     {
>>>>>     	gva_t gva = fault->is_tdp ? 0 : fault->addr;
>>>>> +	if (fault->is_private) {
>>>>> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>>>>> +		return -EFAULT;
>>>>> +	}
>>>>> +
>>>>
>>>> As mentioned in another reply in this series, unless I am mistaken, for TDX
>>>> guest the _first_ MMIO access would still cause EPT violation with MMIO GFN
>>>> being private.
>>>>
>>>> Returning to userspace cannot really help here because the MMIO mapping is
>>>> inside the guest.
>>>
>>> That's a guest bug.  The guest *knows* it's a TDX VM, it *has* to know.  Accessing
>>> emulated MMIO and thus taking a #VE before enabling paging is nonsensical.  Either
>>> enable paging and setup MMIO regions as shared, or go straight to TDCALL.
>>
>> +Kirill,
>>
>> I kinda forgot the detail, but what I am afraid is there might be bunch of
>> existing TDX guests (since TDX guest code is upstream-ed) using unmodified
>> drivers, which doesn't map MMIO regions as shared I suppose.
> 
> Unmodified drivers gets their MMIO regions mapped with ioremap() that sets
> shared bit, unless asked explicitly to make it private (encrypted).
> 

Thanks for clarification.  Obviously I had bad memory.


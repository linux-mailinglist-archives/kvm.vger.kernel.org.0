Return-Path: <kvm+bounces-11088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFA4872C0F
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F765B26CF7
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F9BDDA9;
	Wed,  6 Mar 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLfqiew9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123316FAD;
	Wed,  6 Mar 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709688154; cv=fail; b=LGYCOAQUSYdsfIIn5mE/L1F7k6xm/FaT6IdLCWIeRE5j+l775rfMDbCc/H0eqT3m3uo/qE98t4I1QaZDvwAwdoF5KZRoPN9x5Clied2n8TMSLFr/xq4LtHqXZ4aynsRIz6kCjmEQgnR4S4qtHDCrGlG1hWP40KQbwqOHJSj0O3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709688154; c=relaxed/simple;
	bh=3AExEtXeciUBMU1vWXWc7XAIhB30u9K7LIyBEnTls3Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oiFX79U1slBHhmVYwGyzPOLrcAWA8s/YWyg5ITDE8aKbqo441mPGhsQm60SR4ckhgv2ndUgAmRK/Kip8cXnWg3NkTrPbfPsLqZXrcbYv6Jtpk9at68vU6fJE5o0c37u/oFMcELKXVgzRQGO3Wz+5wVuQjiUornwcAHwbHdFJHMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLfqiew9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709688153; x=1741224153;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3AExEtXeciUBMU1vWXWc7XAIhB30u9K7LIyBEnTls3Q=;
  b=RLfqiew93HYccb1wVPBcGmk357V7vg34id7L3LT7/sVU6qJmGMdQp8E5
   H3Wzpeau4nEzUfrFSwvjGYrZcqbrN+4ryZ6wqPjZQwKcF0HB4l1OgVXfp
   PLXyOZU/HA+UmSiqQGCW/9KCWP9Mv4D7lrxgxa2CcPYymH8oWfYuirNOa
   6pNyp+hkMSWyErxtP6d0Z0dItEBt2c4/j61wFE4Pp6BSBHIZ/7JBqqrZH
   alxRVsRVwSXBK1ZHG6/bQ4AeNWZBHGLYsFPUv7tWFhbbkWl77fZQQdxKo
   K+S0QctHoZ4/MEtDSA+o5SQop05CBTbM8CuWUvG68P0lVb2y6JJDfplBo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="8098178"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="8098178"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 17:22:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="40573489"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2024 17:22:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 17:22:30 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 17:22:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Mar 2024 17:22:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Mar 2024 17:22:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJD1cZkVfgJ6tJQpjHLGaJkBQ0XxbVB61AMUBnf8fziUYZ/ep4dh8qtbDl7IWfpAPi2xiq+/tCB5yEZQ7SMGFGTV/bztk3gJmhT7SUy+eiyF4+gwVaTRUixZKD8rMEvUUheJ7XW3/DtlXk8T1uyzwIt4mIryrymPao3I/8DwpBx3VOIRTWt3jX0UpVS9EPgPll6oBomBzwITOD+DPIwQeoV1Wid8K04pVkAMjW0hHyjOrwmWA9OShO0bdgJ0R4G+5SnKiGpYIlok4bZCGRxBmBTdhMQR8y+gZ/bqTTKUvQap4GHSpoWgaRPMPjI42EmRh9USXdMjjwhHdEEWWmgDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yd2D9mNyGBDqPGNenji3SyIHeAR22PYrb5EeRRtDlXA=;
 b=IiKaLyzeTGk2CG8Peux2co1YpnsTEDJtSGdZNWE180j84y6y1Rr7nNiuUB05vZ3DEQaAooIEIG++87bMKrz7BCDqQu2unMsJKfyk0252CeRmGEkvEWBp6cSOn7udWkZ2m/PxtZQuaSxcun5LHI0r/wGgqtxZl4B+Cs1oHViGaMX4DU1Og2vAghzg7H4XW7wmHu5I0JzkIFGuei5poOB1sdDXqF3WEEAmhQC4iEDthHw05ecUkO6Ap9UoHAWH4PgiwlBVpbgclZl/l2KPYubYo0W75X3PCw5JhuVvn/xdDNYD642r8sLxUKBmGdGeoIP+YQr6txgu3pjyKOO2wBXDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6617.namprd11.prod.outlook.com (2603:10b6:303:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Wed, 6 Mar
 2024 01:22:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 01:22:27 +0000
Message-ID: <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com>
Date: Wed, 6 Mar 2024 14:22:17 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>, Yu
 Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
 <Zee7IhqAU_UZFToW@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zee7IhqAU_UZFToW@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW4PR11MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: e85ca6ef-294b-4cbc-77a2-08dc3d7be29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bm6tmES/SiKoK5nfAkhPasASuhH5hmD6jAKQoe5xJbDLMIsTEnZWBaa6uNWsNnPIbuZrlDYTcfEv2Jkdk+ZwCQUnLacR3s8tiwwbkmAYnn+TkIVj/T8KiX+qmXztPSFfsermSDKD/U7aZp2FK5Mp9wJBCqnnIlyhGmifeXTkxh85oB7GY3iF+BGSCprvXH0MhKaiZwF8E95oL6PRpC/iBDdFFNQxxsifW/GXayQM2my5s58BTu0YfmdJ+OSSAyK8i678ktmL9QZQ9n/P2PqhF3kUkS7U3OTDTKnCO7i1bczCpsBa12WGNMYaVYTVqv0awM0spqFGfxFLFo2eUXmvftC0Eds+M5dYALSVqc2eiwOJ6Bj/2d5IVU4bc0iJIkFWhb8lh/4ma4Zv7vf7Z1w1fqL09Mvl956AiWRGDUPiSro2/EUmr3NECQwDYruOx2/UqPDvVfBRB24lSY2S10mIJfDCA3vSbjNQskgWmSt+En9kC/mkeIJpwNSJ9H5G52CyCPYitJSPoThLcdtzfq/Wqo9I/HFkI4cqBp8DgOhjoms6EenyNabCZyVklk9jqCTfAnfSyAEmrYn9HUjtykmoAGwVfFuqYfipqbeUQRpPeV422468BuRoodMf+SbnEA+aoR0ZBv8pKK6VKC1lOODXHg/NuWpNOJEBH93i9hryBcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm5iYmt5TkhuQXUrK1krdGtkV0tkcDErQ3F6UUkxeXpTejNIekloNnhVRXh5?=
 =?utf-8?B?VkVxVEVBMHAwVmNueU4wdzVFNEcvMUZiandrRlVqbWJtS1ZnMlYvNU52UGtJ?=
 =?utf-8?B?S0E0ODlqU1lJdC9VVWhpTTErc1JIc1ZkNWVEN1pHQnVVY2ljVjNPeWMrWnpC?=
 =?utf-8?B?a3V3UzEzNHYzNXY0NWRUb0k1RjlPakhsamlIclozaHA5cFFTdkZjQjZ6YzEy?=
 =?utf-8?B?cmRiQjBRQ1Y4SnhsNG5ra2ZlWkpWL2dSb2RXbUdQaVd0SGIrMStmb0hjVkJ3?=
 =?utf-8?B?bS8wb3RlZG9oeEs0eTIxMU9kMDNtL21HOEE0dXplZ1dPWG84MStTYTJBZ1hE?=
 =?utf-8?B?eFNyQnNjMkg4YkdKQXh3ZkFxMGV1bENRays5V25kekJYaWdNelpkRWZaK1Iy?=
 =?utf-8?B?KzJzU1N6WElUTERXY1g4RmloRFdRRzh6OVpSSVRtUGQ0MEtoTCswSVY2NFZL?=
 =?utf-8?B?VHZBNTJOSGM5c2hiSDFTeGg2Wnc5SWZsK1UzdzhvWmc1V25Nb25RZ1p6MTJC?=
 =?utf-8?B?UERiMXozNkx4Y2o1VWhweHdxQ3lhY2pIUzJiQ2lhWlViZjh2bHQycDJFQ1J6?=
 =?utf-8?B?Wm0rVnF6WHZ2bk9zSlNsbTcrZ0pjZTlmbG9RMzhQdWh1SnhDdnA5dGxIRkgv?=
 =?utf-8?B?VUh0cnpEV2lUajREV0wvRHJiNktHVDVJamhlWXhTUFkxeElaRUtBVytlZ1JW?=
 =?utf-8?B?eXFFMVRvV3VVdCtEdGFUTUltZ3lvS0FpRXU0bnhmaUx0U0xJMmxVNTVVU3Nk?=
 =?utf-8?B?aHNvbmJ5OEsyN0pFeE4yMDZNdVBwbll6cXFRemVuVFJRS09jVG1tUWs4MGk3?=
 =?utf-8?B?OTJVekN1UmpmN3VWeW5DaEFWQUdSTHpNdkZSdE50QzhkenllN05LbUhUQWRE?=
 =?utf-8?B?QWxMZHovdnhjeVZ6aWhqRjdxRXladU9ERnhxdmhYRWF0aTAyUnBMNE5lKzht?=
 =?utf-8?B?VDRJeXlFeXdSNzNkQi9hcm1MdVR5NGFMNTNmSVVCbnpyT3hFaFJoQ3RmQVNH?=
 =?utf-8?B?VXdvYlR4RG00NDlud1g2cTR2OXA4RmRLSFgreG05OWZyV0hNSzZQUTNiaFdw?=
 =?utf-8?B?NXZkcDg5ZDlrZUo3cHlqbFViWjU3NDZiOUU0U0hEdkU5QVZWakRScE1QWGVV?=
 =?utf-8?B?MnhBV2ZQUG0rSmVqckNVMDZ6TjNtWDdiQXhVQVRCV29zSUdpOW1kSzNaTFc4?=
 =?utf-8?B?OFBWWFR4bjRZNloyOWQ0dEVxL09ESVl5TkZqbm5DR2YwUmZCVjZwaVE2Uk9R?=
 =?utf-8?B?ZkIxT1pjUmlNN2w4WGtFc2gyMDdzYmZXajFJdUtyc3lIa1BwZEI0OGVOUHBW?=
 =?utf-8?B?SVduaUNyaU83WmVpNkxYa3NtSEEzc2EwWlRQU2RKbUZPSGtlK2pOQkF4S0Nh?=
 =?utf-8?B?MUswTUhzV2ZUNk1KdnZMdXl2bzN1UEgyZVNuNFBoNWJ0UXR1S29TQzRDU0x5?=
 =?utf-8?B?NmlOZkxTelJuaE5hUXFkRll3WGpHZmlJWWdTeFpyaExPTFk1bWMxeTdENkhr?=
 =?utf-8?B?aXFBZnJYTkNBN1RaMWpLMCtJWThFT3FiWm44SlNaSXJGNUp6Nkh2NGRHTWda?=
 =?utf-8?B?MHo2WlBNRFQ0RnhJdEt6Ty9MM3UxUCttVEFnK0QxOWt3S0NvQytJMjl0RlJa?=
 =?utf-8?B?Q1ZrYzlkOU52RGkyM3FkR1IzMUk1cllIV1owYkhFOXo3eEFpV21WY1Z2ODhI?=
 =?utf-8?B?bUduUnh5YnF6YjhRVit1YXlNbFdvTEFyVTlnUlNlRldFRU1iNEZBQUwxUEEz?=
 =?utf-8?B?ZU15c0tMK2RuRi9RWjdQaUNVL1JnanFXa1ZvZEhWS0RuODh0K1R2Mnk2bVFl?=
 =?utf-8?B?a0N3c3l3eEpUMWFHaHNubm5UWmtCVGRGNGJoMVVqbVgvS0F4blRxbWFYdE53?=
 =?utf-8?B?TWNpUjVtWndNZW4vMk54ZnFSTXlmZTVPSDg4V3Fwb05GMkUvOExpUHhpc1RE?=
 =?utf-8?B?TVpmVVpndkNHK2t3bFhwZVRDK2NnczN1V0xzZ3VWM1lxMlQ5Wlp6QTR0VEpL?=
 =?utf-8?B?OEJIemJURUhBdFZzdVR4MmZSU3RCYmJHRlRGYXZOVkFPbFA2cWNpUFFjMFY1?=
 =?utf-8?B?OFFTUnB4a1BESm1ERHViQVhKUWNMdmhBQUdOazViTUJTZzlVVWg4d0ppMXFv?=
 =?utf-8?Q?hAnkZOfjVQC2eCukOyPEG9b/T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e85ca6ef-294b-4cbc-77a2-08dc3d7be29c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 01:22:27.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6OVmipGxPLWxe60x7BHhREfgRThRku8LNc+1umpLRsCGKcCecdsvRpiDj2SCt4uOYWy/d/T4j4DXQGgu3LZvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6617
X-OriginatorOrg: intel.com



On 6/03/2024 1:38 pm, Sean Christopherson wrote:
> On Wed, Mar 06, 2024, Kai Huang wrote:
>>
>>
>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>> Prioritize private vs. shared gfn attribute checks above slot validity
>>> checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
>>> userspace if there is no memslot, but emulate accesses to the APIC access
>>> page even if the attributes mismatch.
>>
>> IMHO, it would be helpful to explicitly say that, in the later case (emulate
>> APIC access page) we still want to report MEMORY_FAULT error first (so that
>> userspace can have chance to fixup, IIUC) instead of emulating directly,
>> which will unlikely work.
> 
> Hmm, it's not so much that emulating directly won't work, it's that KVM would be
> violating its ABI.  Emulating APIC accesses after userspace converted the APIC
> gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
> is shared-only.

But for (at least) TDX guest I recall we _CAN_ allow guest's MMIO to be 
mapped as private, right?  The guest is supposed to get a #VE anyway?

Perhaps I am missing something -- I apologize if this has already been 
discussed.

> 
> FWIW, I doubt there's a legitmate use case for converting the APIC gfn to private,
> this is purely to ensure KVM has simple, consistent rules for how private vs.
> shared access work.

Again I _think_ for TDX APIC gfn can be private?  IIUC virtualizing APIC 
is done by the TDX module, which injects #VE to guest when emulation is 
required.


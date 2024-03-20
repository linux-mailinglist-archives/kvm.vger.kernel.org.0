Return-Path: <kvm+bounces-12200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D92E880887
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B5761C22775
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B931364;
	Wed, 20 Mar 2024 00:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GvaOwTQM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B85A23;
	Wed, 20 Mar 2024 00:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710894566; cv=fail; b=bBR4kBuHfwTkJ9vtBsnlZXys3URW8PVbODklkH5YgTRRv86Fwv9CzomJp2yK3pdLqSfFHMH7F2OUNGtJ1o+YT5f5OHkinE8LLWtMhIUAsPPxEvJtEPKQP9Gb1zWmuhNWDMbLk8c2U4K3E13LLbdnTNZ2lTwjUebpswP/PDEoDe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710894566; c=relaxed/simple;
	bh=xsqNKbU1VsagMoUkb6NVYNy1khN+H/KL4S9QBLe1KN4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FkAK4EQEQ5GqNf6aveAONZrS61TpVnP+LxMKV3pEs7jJU2St5DdkQWq5PNmfABTnVy3KjivATfI1d2Fi3CQXdjhB0/ni0zZUZUn7hxprxsHA1T+uvXcXhtypOdgfTXpMgOcjq3gPLDr/5B4cHIM2LpFNMtINVKL014rPtqDFTZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GvaOwTQM; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710894564; x=1742430564;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xsqNKbU1VsagMoUkb6NVYNy1khN+H/KL4S9QBLe1KN4=;
  b=GvaOwTQM1nfNnDpugGdgmaHGq9/Wv/MZzNZGMdikmez25UpHP4DPP5JC
   LNQqW2u6moKOINirQ1Q0ZgHhPfvRYAVLx81Njz6rQWJRR/yDw9+eX/hOp
   PZ2X1s++Gqp8zz05xBqvQpNz9h7oKdP9k+mMEhXLp0H2gWvPsZdQ0rBU+
   DArnll2J8BgCDR1b8wqXknfq8lhHjcVtXDyM2g31tfniCVHcnyCMzkTEW
   2fmRCK06mgwXwb/U8Ke9tO/kUj+23ZPZygboCa1HtJ5Y5EUX6ZsWgMUYt
   lhansdyt9LnHGiO5hx/I3crbCU5rsO2d6mZZPdIBMdznGUt6KZacvVHgx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5646752"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="5646752"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:29:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="44948129"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 17:29:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:29:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:29:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 17:29:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 17:29:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab1WDUf7oZf+z4CzmL2LHTPV7r0d3lJtNDYXseO8nAh2FSzk28M9suxzvdWTgPPjeSFQpHkZvqO0cEjbES3hOHUewfuililCAQLveWsxr9Jlu/yVFF7XuJqB5hYkWtj2QUCuOY3M4wXdHRPXMlo7iR+ORZ38qh4XHCZB3KKFgYUil4i02lMpTDtwnsAPVubpEZ6iJGYJB2Y+3Kr+r/d3jrWrmSSVfEAGOJvYXwZeWkjSSs5tawkS4n1lrBg76xp3cqurfz3qmmqYT1G9MVuV4xnaV8W1kGdp+nRG66e8W6AdH7H0x4A67uBpHADdQdY4XvD9HH37Lbha08/I+ORe8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJQdDWE05DQu/DUNH9eWPrFGV4daSgPib3i+sONACpQ=;
 b=Q6ZFgC1wKSwCl1xet4ZlRylOIqp5bJxlSw9bPDBSnfFiM4rldtokKvap+vJMWQwN1RxG2EHmNZFTqmVJvOb7LHD3WpnFojgN16EZ0hagXdqZRrE3XJ/4zLKtLQ08w0/4btxVZTVIDRi4yIOEFRqj2QHVRRlj8IcxfYyE1/SbhAKf91SLyFg8Y29daW+Rk3t51fuTQj6kPWnKGaeOwDbtI6xzQvG/1v7ymLbGSsbB5NKx7Xw47qahpf6wyXg5Sf43c/fBEgnD34gJYgwFADBlc7S+A37nSLEmYyDrLazkap7WGPW6S9XWsQghq577VoDe1FR0bG0TPyZzEMdLYkJdiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6713.namprd11.prod.outlook.com (2603:10b6:303:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 00:29:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 00:29:18 +0000
Message-ID: <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>
Date: Wed, 20 Mar 2024 13:29:07 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Yuan Yao
	<yuan.yao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:907:1::38) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW4PR11MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 53d1c24d-67c5-4916-84ec-08dc4874c7ca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEJihMWfKeXOyZ9yQsmgLR1UweRNP9Dqvfi3tAV2aSZ//eiQMY4a8WyFKKNch4NRAVqr1RyVhlsTgYCa2lYmKiqQaNmx1ht/pPr8Nes8hi1AJBWTzQMzEX2Le1zzOF+paM7NWHZmN9mU92leJw+sekVeBxN6vtC7eXiZWkvdpgSqgcCv0F5w+QDOR5mLUEVvcO5fzUhHseA9dinmsF5f3Pe6ba5tlcOh/s8VsCMQZUY8H7NT+tMEj1leS5retqYPhZaDTPctyJNtPLKdPs/foOnNea2DGeHaNLVSgVlR0Ra/JmWRjU2QW4Stq6PkkN/wnyIQbPy853xQG7B7116RFiuqZQajtew/G+wP9SGOGEIiBQwBCT7VjAMhn5AbbMx5CSPJ2yuPCTnXbgUfo6sT78kOH8DZo9kQilHzr5cY4lT8fn9MkVSVvKCE7st2yq9e/tBh8svI4HE5IDzQtyyj21V+wKIxq8MEtaG1Ccyx2aBSHDgTqaGY5ipKtKRnTzuDVTeQg0wTEI28uttYlDvLCny+gmPorTnA53d/nav4MG/RLaGCqTfR21qFeyla3HzPPbuqR0dXhaXFXF+VkdjIWvhaMqJXw7t1yCC0jEk7d6T8M4CoFASorzdEZ8HGWsorGk89TeFafMlG6di9Ys6357+FU2dG25gpMErZoYTXJps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjNLVy9GU2JVRkl2VjY2eTd3Qm9XeUtlMUh1TnJsbGNUM2R6Y3BzekVYTUdq?=
 =?utf-8?B?QUp6OGludVhzaFQzUm52K1EwK2NpWTBnUTduTFFMNjM0bFFFMzcvNFlWcmNQ?=
 =?utf-8?B?N3NKckZwYWlhTHlFMEE3NmRJN0NSRXBnTW1TUmUyNEJWbjJkRm13MldsZ3pM?=
 =?utf-8?B?SGFKS0c5WmovVHB1NTU3R3RDTXc2cnF4SVBUc2lBcHQxQkMzQW1lNlh4dERy?=
 =?utf-8?B?dE5OalRJZzA1U0NDODAvRVJlbWFucnlWWWlCc1BHTmRoc3JhK2Z1bVozMnlK?=
 =?utf-8?B?L2dJem4zbGVGNlJGanZTTkt0Q0kwYUY2c2h5WmVHLzI4UC8wa3d5ZExJSmRF?=
 =?utf-8?B?TGs5OW9VdnBLNDZvMlJSWmdxRS9lNUszclN0VktwMjdkazRtMng0UHA2bWVo?=
 =?utf-8?B?VjRsdzBUT09BQW9sd2xSSWVoY0ZlSk1PWGxkVm1LV2YzeXAyc0laYll2WTNq?=
 =?utf-8?B?d0ZFT01KTThyb3doODV0NTBZYmptMXF4QWpDeE1xUmFKbDNVaHVua2ovWC9Q?=
 =?utf-8?B?VXNUbXhTT1V2RUlnYlIzcS82MG5PaFVuRGd4YWx3Sm1DVzN6KzkwREhTM0Mx?=
 =?utf-8?B?WElnRDNwTGdoMGt4b2JqT00xemozWlJjQ3dDRi9QMDI1WDdhenBURkh2RWFo?=
 =?utf-8?B?bFJxM1p2T2JhTTZ3MW9jRXR0WkR4OFlMYmZvQUlIYUMrTk5OL1UwckxrOVZ0?=
 =?utf-8?B?U240VWJDV3RzbFhLVVZtbWY2VDhHT2pLTkpOSForVHYzdG81dUFsVGJRQVdV?=
 =?utf-8?B?M0I1MnJUY0hMaFdrU3M0YmhFTG5WK1lHUXJxWTBrWndqYzN5R3hnU1duUHV5?=
 =?utf-8?B?RzZjNnA0b3NxTk5OQXZVWlNRU29YdmY4SU5ETmRIUC9xWWtEYWRycXZaVSt5?=
 =?utf-8?B?V2ZsRm83WDgxd0FDS2ZGOExJbGlUY2xkNzdEMkRkVVlEWG9ocFRwRHlhZGpv?=
 =?utf-8?B?MHZSVm93Q0RidkNMcEo4S1hpSWpEZGVKR21mODVTK0szQm8yMzJEamdiNEQ4?=
 =?utf-8?B?WXd3TzVQYUYzcXFIczdpZzJrRDhXWU02clRoQ1RuMUc0S04yNEludGlKaDkz?=
 =?utf-8?B?SVdMa2dhRGZudk9vOWRicC93ZG1qc1FuY1JRZVNWcE9SUXJLek12R2FSeTMy?=
 =?utf-8?B?cXE3SktKbjNoTXpDbFJaL2NhRjgrak1pdEZDT0lFYXpqMEhKQzkwbFRtRTIx?=
 =?utf-8?B?Z3pOZVFGdm1LMzVRM2FNM1VIWEhXN04wSFB4cGtBcSsrVGpTbkhYY2VDT0x6?=
 =?utf-8?B?SG1tVllHSm1NeG9xRGIxb1lFRXgxRWlhSEdtV2hBcDV1QWIrNHg2N2QrMS9H?=
 =?utf-8?B?YW9oQ3A1NEM2ZmxuekFPUGlHR1hSYlRmVnVGUjJoZURXSWRObmZYa2gwL1BS?=
 =?utf-8?B?NlFrcEVzaFFyZ1lobC9Vd3lOYmowaWNzWjRFdHJiV1FVenNmWEFraWVlVzhR?=
 =?utf-8?B?Zk9vZ1crZVI1Zm4vQVlpRmc0UmxWdXBkUXNaZFJBOEVKaWVaUFRNQ1RNQ0dw?=
 =?utf-8?B?UVZyQTF0MlppczJQb091TFdKWncrd0RjNmR4Q3B2K1NiMjd0VDFONEVxdFlk?=
 =?utf-8?B?UlBOMEt5WGdKWmY2ak9JZlpBWFplK2FhQmwxREdGTHBQSUc3SkR0QjlEZjg3?=
 =?utf-8?B?UzZDQWI0VVNITDRpQ0Y1RldYV043STVxMy8vUlllS3NKUGRnQVpoNDkxVWxX?=
 =?utf-8?B?Y3IzOVVub1ZKdFFMeUNzdHhoTUxUUVAwWDliQ3krVEpZTWwwakgzMXpld3JN?=
 =?utf-8?B?T1hlVHlsaVJXQmhDYXlWbFNaMXdjeHFQeHpSQWRSOWY0UGRqNERaOHVpcE5K?=
 =?utf-8?B?RnIzSXRabGJDRXpIQVFnelY2SEgrOUVadGptTENraEdsSEd2N1lvc0NKQisw?=
 =?utf-8?B?TjR1NEp5VmVYTW1IeFhvY1Y3amVLWVFFTXczM3cvU3JQTHBqMXBpWmljclAx?=
 =?utf-8?B?Zyt5cVJZS1QrdklTMkkvTndMZndLSHVzSUZod1N4bW93UmV5UVp2SytqU3RU?=
 =?utf-8?B?dHYwZTJTUnNYMm1aMlVSMjgrNHdBbnFpRllpSk0xNHJybnF5RzBzdUl4OHM1?=
 =?utf-8?B?Rlc4elR5a3Fvc0Y3TlpYbWhKYk1wRS9lWVNtTHBVTEg2aDVKNTVHUlB6QWtl?=
 =?utf-8?Q?keM4Jxdd/UsqKtdwdkMljko13?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d1c24d-67c5-4916-84ec-08dc4874c7ca
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 00:29:18.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzvL9pqyaWHhevR3/rj+I0cepoxxuk0GsjW+OoHefae/488RWwKwBbnTFHDuYAUS2+6u/osts5JQ2ODiKwN8sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6713
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add helper functions to print out errors from the TDX module in a uniform
> manner.

Likely we need more information here.  See below.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> ---
> v19:
> - dropped unnecessary include <asm/tdx.h>
> 
> v18:
> - Added Reviewed-by Binbin.

The tag doesn't show in the SoB chain.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---

[...]

> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
> +{
> +	if (!out) {
> +		pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
> +				   op, error_code);
> +		return;
> +	}

I think this is the reason you still want the @out in tdx_seamcall()?

But I am not sure either -- even if you want to have @out *here* -- why 
cannot you pass a NULL explicitly when you *know* the concerned SEAMCALL 
doesn't have a valid output?

> +
> +#define MSG	\
> +	"SEAMCALL (0x%016llx) failed: 0x%016llx RCX 0x%016llx RDX 0x%016llx R8 0x%016llx R9 0x%016llx R10 0x%016llx R11 0x%016llx\n"
> +	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
> +			   out->r9, out->r10, out->r11);
> +}

Besides the regs that you are printing, there are more regs (R12-R15, 
RDI, RSI) in the structure.

It's not clear why you only print some, but not all.

AFAICT the VP.ENTER SEAMCALL can have all regs as valid output?

Anyway, that being said, you might need to put more text in 
changelog/comment to make this patch (at least more) reviewable.


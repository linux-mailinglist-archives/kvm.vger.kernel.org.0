Return-Path: <kvm+bounces-5624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE82823C7C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 08:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 769051F25C82
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 07:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FC31EB35;
	Thu,  4 Jan 2024 07:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="esBDILJY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1E21DFE5;
	Thu,  4 Jan 2024 07:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704352319; x=1735888319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AfRA2HL4aQXXNjsZOum+XdfejhXHME693qAT5mUB03w=;
  b=esBDILJYFkXoHCSWs8ezqHKIyJ5+KyO4R3uclgOIfX2L8toLcKP5lX14
   6J5mFyWn/uqO+a1i/5jTifyZ4TB++BdigxE51/w01IBiiRkHxZqqR9zYq
   7p2ko+64iWSzf0mJ+05bmKCF2yCJ6AZO4lB9nVchbXGWYVGGrvbL7cWyG
   y38t6suPUyepOfBrj8csJRDb40YAsNL34Nb5WwrVazoiLLWkpr++cE7s5
   ocCH33rnWZOGvqp2buyCLUjfCVYk1KPYySW4JwFcfuO5RH/XKkyPfs5m/
   BEoo9RlEr1/2KLeYgg3pwwTNZx+74X0xO9f3vyiL8uP1cmrTblKJPVgSs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="396026993"
X-IronPort-AV: E=Sophos;i="6.04,330,1695711600"; 
   d="scan'208";a="396026993"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 23:11:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="953505032"
X-IronPort-AV: E=Sophos;i="6.04,330,1695711600"; 
   d="scan'208";a="953505032"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 23:11:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 23:11:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 23:11:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 23:11:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+X9iWPDBfOpQejI6pRxC79Ngw6GNUtQGqjle23m91Rmjc9jDo/p5b1xtCuPVoxtv+2kbOQAfeLG1ncp9jpEUK5FlwXnlTT8cHA938g60Y0femae1rXgGH8zhihJRbLmxTrZv6vIdsExo12Nk6piwpoFbEQC/jP4lUXxM/p8cbrMnJ1fzHHskB841T+dvXeibP96cjMxfOpl8MoA8gaNbrTTnGxQg7w8dB3kO7rPlQ9jicfq/jbAKTKzM32Xaw1IOJc0lZpWhFpYO/bFSy8Ma7UITkOCPeSIs+UDZRomz7tzgfnT3IHcEFzzR/Xnqgq78QPUQ+ySp7FE3X0rHG6O3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3ggE3NqAc1kLn50amji4oKJPwIcZkIFH1fuJ5Dc5iQ=;
 b=icm71zR9Y17OHvOlXo3dl+4yxz5y7wejnmXjjOcoS3EMmTnBjm+JL/63n1d7JBTet4GAXKNcN18TUTFGf9MWK4FwJZgZaqyB7863cSnBkbqNvk5cwH/43whns6ZDTXzaDXwv/qWv0oQfsjFezQkkQwFy5VVlEYZRn09yNMpNRoKNAPJgGScfut7flxNt5afaC8rE7qvhsLj4TewGM83HIxnrM2twhkHq4Qujdzuz+0Kv0CvtZ51Y4AZ6lZtH4XKnWJm3tLz+V4ht8JzQVl8S8sMiJdBB+aJ58AkTIDDhk1wUHfrf/2OyMWiPpqUaNT70rr1omOcJ2YZ0DqVwzunpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6193.namprd11.prod.outlook.com (2603:10b6:208:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Thu, 4 Jan
 2024 07:11:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 07:11:55 +0000
Message-ID: <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
Date: Thu, 4 Jan 2024 15:11:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da064db-fb74-4e5b-1cc2-08dc0cf46ec9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+pGriNeuv26FW7NZFNi65qpNpTYVF5ygmtDAOWv0yHMHHyd2hOc7BbjnlRKInt9+FxchIFIoGNKQ4tX/FjZaQrvGfyocs8No+7QUno+XQYEqw/s3CeSLrJc7nm3SfQ+9AokQPCfFvm2X2A6oHaYo4VBMs40v63I74k7rWxLtH0PooXw2TJbZWSceruf0v/cUIdTKdcyj8eoyD9i8DJcYAUShJYbym/U3ylGT1WqRbeuVH93J69GweYRU4OscrrDp2pdfiFxmviXopEBp/bcQPGDeESzPyOTkL8Tyb36fzfMw1PtwklXUaXlV/N+8kxyRDthPmJChfh+Vw2w/ZY+Uqzmj18CDBKWqZz5Upb8p0r1cvK8YSu3HaKPXKijDR9/RiNfZ2ffq+h7jJZd1itt3r/c/r1ox46WbxwKvIYQdGwF07/0PpIKKi1jACDT2JX+p4lG2A+mlxMwMR6WCK+v4lrwlJsTcg9rGpQdWfBZYxjbOjJmGfoCbCa3ZfIEHYd2dxPMtUNu1SkcAZOW5AmiOB1UTDwFpaZ7AwBqEZBGl3Bv+ja1QFeZ1fBPhv1LO/zNDhJ0qavK3xoH3PLch/1EMcmUIzBxctSpU0FqkKFgUDrZiO3k5DdeTSGMSM87lt9ozdQlXOcb5tXDqjW5yuRASg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(376002)(39860400002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(53546011)(26005)(36756003)(86362001)(31696002)(82960400001)(5660300002)(8936002)(6636002)(6862004)(6512007)(6506007)(38100700002)(6666004)(2616005)(316002)(54906003)(37006003)(66476007)(66946007)(4326008)(8676002)(66556008)(4001150100001)(478600001)(41300700001)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c040MHBNUC9WbFFSQzZBR2I0L1drTmdjeHN4NkVqTEhyenBjc2JFdDBjajlm?=
 =?utf-8?B?dlZwUUlyTjBYczFUYzR2S2V0dmNhOTNxSzlrcjVrK1MwQ0p1MHV1bGpCaWhY?=
 =?utf-8?B?MnFDbVRPUS9XKy8ycEo0L1RNQzlhUWMwWE0xUXh1eUpncDU3R1pBVitHL1A4?=
 =?utf-8?B?M1hEb3kxTzFGZnpuQWQrbG5FZ0tJd01WQ3RZcnUzMC9SVHdlcmJSSkZTV3Yw?=
 =?utf-8?B?MWdKL3BXVDU3NWVidE81ME52THplNkU2OVVEZnhvOFhEdUFBUWVaRnpoS0Z0?=
 =?utf-8?B?UzBSWWdINEZpcmMrSGRldDAxWnFxVlArM1Y3OTZOVlRKVVFDb1BQM3dUWXpW?=
 =?utf-8?B?OHRiMC9HQUJISTVjbDJqL1NLcURJOFRLSE1tYmZjSVFmRFd3TCtTYXFiRzBG?=
 =?utf-8?B?UFprdnFGUnd4bllGTmlleWhsemp0WmJGS2c0QzcxMEEzaHVUR1VjbmNTTEs5?=
 =?utf-8?B?QkUvcWNDZnlaUU1UL2Jqc2hrcGwyUzhSQzlZemd6YTJoOHIyZ0hnN0ozUHkx?=
 =?utf-8?B?bjdpTGkraUZCVjBwNkJvbjVLZVVEZTdoMXlTVDhqQkVQVis4TVlFWFViZnlv?=
 =?utf-8?B?S2xRa1BTbjMyOVN1cHBjeWp4VWlmRlc3WjZISW5tMTRENmpFbDZvQ3hLSDkz?=
 =?utf-8?B?d0JYR3J4U09CTTZlWkw2bUJSRWZ6eHB4clFRYTFCY3dmVjhobFM0enFydEFs?=
 =?utf-8?B?WENqdi9XOEc5d3hFZTlZRXJaekx0V2I2Y1NnZC9ITnl0ZUlBOGhLT0t1cFlp?=
 =?utf-8?B?Q2Q1d1lxK2hzUkIraERUbGRvUS9sV21GaVA3U0N2TU5Qd0lHeFBmclJCdnYx?=
 =?utf-8?B?SW02UkNrelRKa0k2L2FVcENRYTdvV1lHUUk4UGhkN1VySHhhNTRqTUFWVXNK?=
 =?utf-8?B?K1VTSFdrR1JsT3V6SHE2NFVZWklrSFRiMHpLUlh0MmlCM3ZHQ3Z1K3BtNDVS?=
 =?utf-8?B?c3R0OXQ1SFFzclVmQ1RDOXlsa0tDLzhrUkVZTWFCVlJxcGRIRWN6QmhlTFZS?=
 =?utf-8?B?c2dZbEVjNWtnV09xS1NmZCtOVnJqd0EydlpNalNCSTdPS2l5ZlhmL0ZTMFZo?=
 =?utf-8?B?K21PZTVaUGhudXAxK0ZoUTFIbDJrU3d4OEFlbUptekpPTnB5SHBZcWowQytD?=
 =?utf-8?B?U1kvUzNYZGErQjNSb0lJVlRzeUtkNGY1dlQ1M3hVQUgwQjJvRmQycENseU8x?=
 =?utf-8?B?OEhJemx6TGRoVE81eGZYbXNFMGVETjc3ejJ3RlA2bXlqWHJXRGkrZzhHVFpo?=
 =?utf-8?B?QmxITFR2MEtpdWJZYnNiUnQ5TjBjVjRIekhwQ1NUSStabkhJb1ZmdTN1b0Rv?=
 =?utf-8?B?TU5uSEVReXpPVU1zUWhUWm1mUFZzYitHbTFYVE1jRVdOVzJQNm0rYndwang5?=
 =?utf-8?B?TEdicG5xams5VjJWc3hBd1dhb0Q3WDdISTVRUG1FQUNnUmtuU0pjUDZNVkZJ?=
 =?utf-8?B?Y20xZTIyYUcrUnNIWHN0REp3L1dOU3ZmcjJvcS9JV0Fld0RkTzVUQlh3VHgw?=
 =?utf-8?B?V1MwSDB1RlV2MjR6K3dHQ05wOXcwUklIRnR1SDUyek4xcXRIcHU2Vm9wQ2N6?=
 =?utf-8?B?dkFrVUpCWnc3NEZaVE9jb0Zici9MbU5jRXVvYjljOGpWVUpuRHNCTnJoaHpM?=
 =?utf-8?B?QmtoaXdnRlQ3aE92Z3JzZU5HSHJiUjNhUlpWaVMvaThOM2lxT09wWkFhQU5O?=
 =?utf-8?B?Q3dwcExqR1BXVDNFODhmVmV1NUIweEpTdDZRV29ZYWV6ajBlQnFJUzY3OWwv?=
 =?utf-8?B?ZDFIa1dDa3M0d0tkWldoU2JJZWFrVW5UYytybTVhRkhUZlNycE5td0lPV1lC?=
 =?utf-8?B?YjlaSC9QcmdBa3BFWG9hbXJIMDV5TUNSQ3VKK29XSFIzWXh0SkpieExHdGgz?=
 =?utf-8?B?ckdTaHFwMUFvaUFVZ2RHMEZMTlRMOUZOSWhHNCtxcUFiM2JCNGRONmQ2MU9S?=
 =?utf-8?B?b2cxQ0F2UHc1dnNtdG5vUGRkdW1jL0ZZaUVjMjl3dkxIOXpIQkdTUkZUdWoz?=
 =?utf-8?B?MkNHRjc2MTE4Zkx6eWVUcURtMEtpV3phc05ZdnJFb3NtYkFIZDRvNGtPTHBz?=
 =?utf-8?B?bkg1dzRiT0RJQUlEUEc5NHRVdXBIRE9vbHY1MkZjcllkQWFRaVNCZ2FzR2Nn?=
 =?utf-8?B?RlhMejQ2dGhSdVlIKzNjSUYxbldWSjdGZktCRjUzWjZoQTAyYk5hVTNPZ01m?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da064db-fb74-4e5b-1cc2-08dc0cf46ec9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 07:11:55.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCx/ITAEKisdcFZ7ysLdzD9VvXcW+KL5TzDn9BBuDXZ7+htaCI8dWcqIFWC1vNcXA+hhVHlv5JoMVzZEj8I4uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6193
X-OriginatorOrg: intel.com

On 1/4/2024 2:50 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
>> Control-flow Enforcement Technology (CET) is a kind of CPU feature
>> used
>> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP)
>> attacks.
>> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
>> style control-flow subversion attacks.
>>
>> Shadow Stack (SHSTK):
>>    A shadow stack is a second stack used exclusively for control
>> transfer
>>    operations. The shadow stack is separate from the data/normal stack
>> and
>>    can be enabled individually in user and kernel mode. When shadow
>> stack
>>    is enabled, CALL pushes the return address on both the data and
>> shadow
>>    stack. RET pops the return address from both stacks and compares
>> them.
>>    If the return addresses from the two stacks do not match, the
>> processor
>>    generates a #CP.
>>
>> Indirect Branch Tracking (IBT):
>>    IBT introduces new instruction(ENDBRANCH)to mark valid target
>> addresses of
>>    indirect branches (CALL, JMP etc...). If an indirect branch is
>> executed
>>    and the next instruction is _not_ an ENDBRANCH, the processor
>> generates a
>>    #CP. These instruction behaves as a NOP on platforms that doesn't
>> support
>>    CET.
> What is the design around CET and the KVM emulator?

KVM doesn't emulate CET HW behavior for guest CET, instead it leaves CET related
checks and handling in guest kernel. E.g., if emulated JMP/CALL in emulator triggers
mismatch of data stack and shadow stack contents, #CP is generated in non-root
mode instead of being injected by KVM.  KVM only emulates basic x86 HW behaviors,
e.g., call/jmp/ret/in/out etc.

> My understanding is that the KVM emulator kind of does what it has to
> keep things running, and isn't expected to emulate every possible
> instruction. With CET though, it is changing the behavior of existing
> supported instructions. I could imagine a guest could skip over CET
> enforcement by causing an MMIO exit and racing to overwrite the exit-
> causing instruction from a different vcpu to be an indirect CALL/RET,
> etc.

Can you elaborate the case? I cannot figure out how it works.

> With reasonable assumptions around the threat model in use by the
> guest this is probably not a huge problem. And I guess also reasonable
> assumptions about functional expectations, as a misshandled CALL or RET
> by the emulator would corrupt the shadow stack.

KVM emulates general x86 HW behaviors, if something wrong happens after emulation
then it can happen even on bare metal, i.e., guest SW most likely gets wrong somewhere
and it's expected to trigger CET exceptions in guest kernel.

> But, another thing to do could be to just return X86EMUL_UNHANDLEABLE
> or X86EMUL_RETRY_INSTR when CET is active and RET or CALL are emulated.

IMHO, translating the CET induced exceptions into X86EMUL_UNHANDLEABLE or X86EMUL_RETRY_INSTR would confuse guest kernel or even VMM, I prefer letting guest kernel handle #CP directly.
> And I guess also for all instructions if the TRACKER bit is set. It
> might tie up that loose end without too much trouble.
>
> Anyway, was there a conscious decision to just punt on CET enforcement
> in the emulator?

I don't remember we ever discussed it in community, but since KVM maintainers reviewed
the CET virtualization series for a long time, I assume we're moving on the right way :-)




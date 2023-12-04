Return-Path: <kvm+bounces-3278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3905C802998
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 01:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCCCEB20957
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 00:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2739481E;
	Mon,  4 Dec 2023 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lU0VEcWs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B96DD3;
	Sun,  3 Dec 2023 16:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701650730; x=1733186730;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2suRpfQwO3/LqKLfhhjXvURYc9NnXYulZ9h9SJE7wwA=;
  b=lU0VEcWsKSMViCugQLX6MjFsd5X5wyxwitvYSxQEwe0EgsRpKnajydz5
   NvZ25cxKJw/eEIbZsLh1JjzLsEYQwIU1z8V38/XoKiUll31OCDEcK3+TH
   D/qu1z4cD0P7SqRxTQUfO8vOOUKwFC9mQ15HeqTSblroaZiS1i93UMmG3
   L8l6/A63iBK9PfyKyREjnF3W0OjpzvANTHP4aaabdcYHCZ/Zpn9vPtFcj
   2G6hvT8oqx6ueUHFJqcJXiEU6kY1E0FjqX/wGN8gpQnDyywX6uE/VhnVi
   Az5aYm0ReL3fX0do7ihSR5knwglNhheknaujnr0m+S0OitUr45tMBVmV5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="457993206"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="457993206"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 16:45:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="888357182"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="888357182"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2023 16:45:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Sun, 3 Dec 2023 16:45:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Sun, 3 Dec 2023 16:45:28 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sun, 3 Dec 2023 16:45:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5Z74jg4URrllSNNfFkHB3AoEFFtp5CtlAVq/aFGj0YL8hgzS4Vat67YagKbcz52V/dRurbtnyVnPrv5nwsQ+tXeNgYE+yWNbHV7wjHwjHpNpNccFiQZHR17qAQLZy1FJJJl8C6l7nOoqcLiPxi7hhkfSGAn9CeQiL4LuIxkNuuQXt8+ehGyckB8f2g0181ZOVUkqEKGp2OuxfLM9mDR/gktmW5e7RX8b2p9/zALVHImlGGNb0MjROiNURUCaDZNVcUqQF9P27Gj1SyepFHI7HkaDVJz59/dAZ7KS3tihCPOBqdnJuzpsSjBkNGuHZAD6h0TYRLrZc9mjQ2qoFEPLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TnDqiYVsoDuQqsy8RgyjYOE3amo+sbXQnhlmQ0tuao=;
 b=PIfRWbATbV2tswweVnDN3A433OJUKFvDR8CZ9DIRpJFeSh1gKiqH1zt0y0nh/o3C77NySFJjXqWNZsk42aCciNUqFFFPOBL3G3aukWIGqZZJ4Vglw/bhaa9cAQwAIj04MrAqQx4IGoitCSuBITcxnwTBzcGEhj8LF+qJW8NMzsrMNtP9WmUAkEyuI+uCufWH0MRN9EEQIccVQvL4Bs6X7mP7D5LiH/5XxwKKncU2Z1VF8kPfl16Ca5ZGo7FKgsqzzdjuBKwvt8zNOOu9eR3nP58oDFtHd4Xry2rHd3BZlDmQGd3J7c/3K3szX78c1TJuxWd5sWYgBDklgtwuVYdwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB8087.namprd11.prod.outlook.com (2603:10b6:610:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 00:45:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 00:45:25 +0000
Message-ID: <7531921a-e7b2-4027-86c4-75fc91a45f26@intel.com>
Date: Mon, 4 Dec 2023 08:45:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 21/26] KVM: x86: Save and reload SSP to/from SMRAM
To: Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-22-weijiang.yang@intel.com>
 <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
 <ZWlDhYBYGiX7ir4X@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZWlDhYBYGiX7ir4X@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: 38326acc-39f2-4e3e-3e95-08dbf4624ddf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwfW0YDSJf3wNqhUgNgkVXV0JDCg+KV4CoyE7xfdEo/nfuuq+zzCDEmsYFqUu/mAcgYhNfgIJjlAe26UHzF1sV7x0rhmQEPzHiSa2wupdFyEaiPfifDBGurkJwFU7C/BY6FSI4cEnAuW5UFZCWNfzinyOClrvt1HXp0NerszHMwXKGjtBSvZGz9/iNRxjERf45BZ3uZ1Bi4jGzyUwjaqyzPkIzISLgSoodk9i4I0TegAF+5FE5j+/6XDdG+E/proLo3cFVR0xMJGVnRUxChsawQ/AeYdkJXWzgTatbBCkvPzlI5a23WTk0+qTMNI2+2sUUfZC5GLkubhO/dOsvXI9ku8nqDLUNZsbFWHJfEOEMnqesrlXC9GcexFgVdgLuCcLq/77u27QRW5IQr1OtHgbrIm1w8rc8GA2BupF3bMFXwzqtgP0QesBhWqB0dKGQcjwrIX8Th+cPzMIqEcjGvxZLDUQ/rn2qxYbMKsaJS8Dz7l/51Yy7w8lXtm7KJdMYs7aoBq0hE+lZ3vqX6vRjM7KfZR30nQwI72C6QTF3J2zEsshPw0FzfcrCx65KLO+iHlt6liuQR1MZM2Cw1z72ljXXmEi/cp4/xbQNvGvCQZdRbgiDytr8AQaw1becAHvMMqO6ZkFay6XucWFfwNYmH9Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(396003)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(36756003)(5660300002)(4001150100001)(2906002)(86362001)(31696002)(41300700001)(53546011)(6506007)(6666004)(2616005)(26005)(6512007)(83380400001)(6486002)(82960400001)(478600001)(8936002)(4326008)(8676002)(38100700002)(31686004)(316002)(110136005)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1hUQkFlbWlManhFN2hJa1gzdEpPczYvRmtNbWVLNC9pY2xjRUxpckZGMVYx?=
 =?utf-8?B?NlplZjhTS3ZKWkV3cXFsdDhiQ1RTakdoVUx3azVTbnk3SVpzSzdYS3hYOExP?=
 =?utf-8?B?SXZ4OTdpRGg5L0x3WE9lb3Fkblg4aHdPeDEvdlBheDBRVm5PSGU0OHJqUGZp?=
 =?utf-8?B?cGZCNzgrdkJTNzZvNHcwRmc2WVZmR2tQTGFldjVBUDJva081cjJvcHVob1F0?=
 =?utf-8?B?YUF4ZWt3V1ZZMmZsQ09lOW9kUGpPd3dudWdhTmlhL3lkR0VXNE15ZlpZakpl?=
 =?utf-8?B?TDVSQWlBZVl4dXptdTdZRzZCOW4zSmE4NXBXZTNQSHNnQnVzTE1NazRPeU5J?=
 =?utf-8?B?T0pYRHBRWkxpY2tydEZTY3BDY3dkWVpkVDdkdFRNOXB5UHc2VzFwOVAxV2V2?=
 =?utf-8?B?WmhnYzlUbkE1Q1UwUVlER29HTWR4TU45bWhmSlZKUG1Lcmp5eEN2RGJ2RDND?=
 =?utf-8?B?YnJNT3UybFRNQVZSY1ZDSVYwaGQ0Mlk1WjkwWnVwNXJwTGY1ZkJmK3dxUmpF?=
 =?utf-8?B?RHQ4bjR5WjQ3c0hXTERnbXkzTzczZWtDSWdEUmJpRnBZMWVNL3E1djQ1dUcv?=
 =?utf-8?B?S2Y3c1VIUHJ6dkFLaGFxRDVhNW9uSjJKZUhDVnU0R0tGK2xWUnNYYThCY3ZL?=
 =?utf-8?B?cGJOd2ZWRDdmbUdYZjJOa3gxSlNhOW5uZEhYVUVxdTQrV0V6S1cxMi9hQUNN?=
 =?utf-8?B?UE5xeEZYWkUvSVp1Zi85YmJvSzFyemlGVklldFN1V2ZTTkI0cXlQd0d2Ylhr?=
 =?utf-8?B?NWV1YkRydWE3NE9SclZNeldpZFd5QXZnQnpiTys4dlJVeXdVWkJTRVBza093?=
 =?utf-8?B?VFJWb2liOEJiY0pZWk5NTEZIY0FHblZBZjFCaEkvNDdET2l6TThsRGRCbG9m?=
 =?utf-8?B?d0d4TWl1SUlxT3d1R0pHTGU2bjV0Ynd2WEozNnhTOHE2TFZTc0pTQWNXaCt5?=
 =?utf-8?B?d29NTlc4TmI2TDdaNEdqWFF1bUdKTzQ2TC83dVBuKzFjTmtKaGV2ZzVyTklr?=
 =?utf-8?B?YmdtRTNoZ1M3ZDlkdDBXOFZJMVJSTXJ0MTRzN0M1d3pVWXdLbW45REVkNk5B?=
 =?utf-8?B?TUhkTjZBZlNxak1qSWFON1lsUDZOeVV5SjlvaWRWaHZIL1pYcjA5eFFJZHk2?=
 =?utf-8?B?VmFLUlV2RkE0WXp5Tkw2U2d3bEZ6VHJjUEZPVEo3c01Fd2pHbUtDaVRMODht?=
 =?utf-8?B?UHlDTm9jYTZQNW1GOGR3Y21qdzBXMEpVYzZNblRCdnhPK2ZaYWhwNXU2QVZS?=
 =?utf-8?B?dTQ4SGE1ZWZRRllVb01vaEVzVFZLc3I2c2NKcEEyYjVpV1dHWTdsRFZtZ2pz?=
 =?utf-8?B?YjJjMlUvMU0yeFVvTGRDS3BBdEdzbUwzcEZ3STlkSko4NzNTdGp6N1lPeTcw?=
 =?utf-8?B?azhQQmg1V2FLaHltbGlFMzAybmpMT1IvU1l6QnZueXR3alAreUxDNjFXdGFW?=
 =?utf-8?B?dXB2am8rOG1LaTBBcXlEcmRLYmJ5ZzJhdmt3WFlJeUtLQktITWo3cUxhMFph?=
 =?utf-8?B?WEQwRkovNWttclQzdTdZVmNpb0xKQ2JscHRRUkNFbHV0L255TTVtOTI0bWgx?=
 =?utf-8?B?MUIrSnhtZnBXTFdGNWlja3hpVVJyN0N6dkxTV0xGZzNTNHR0bm9qbVFJNG9H?=
 =?utf-8?B?ME5OUHg2blJINWhYY0ZtQXNoZ1h5UXJzclZscXFQNDBETkI1OTVtWWRFaFIz?=
 =?utf-8?B?cVgwYjdxWkQwbUpiMHU5UmtVTkpGSUptanpKNFE1MjNoR2RhaHVJZmJqTzl6?=
 =?utf-8?B?Q3QzQWZGMHNaSmpyNmcvK3JUWVpxNGRLR3AzQnhBMFRLaGNrZytjU0NTdk1m?=
 =?utf-8?B?cHl3SjBmWk9iMWNFVjd2Uk1YbWVCMDNNV0NnY2JUN204TWYzTmk0SHZLbytI?=
 =?utf-8?B?MXJaUU1XM2pDWmVpa25kRFRKVVJzWUlYWS9EYjFEVm4waVpoWDBmcFBFTzg3?=
 =?utf-8?B?c2FHWlVMSEdOM0REWEEvWmFxM0hkdEhpUjZpOEY2NnVMSmN4N1BMUGJOK01r?=
 =?utf-8?B?U3Y0cUxueHFHanJJbytEdWpGNmJvY0Rta0JxRklpVEVTdExTbzR3WWV1ZFFj?=
 =?utf-8?B?SGhrNmZrR1l6VDBmSGNTQUZORVdRNHVWNHdyS3k1bDdUcVRYbUx0YjJkY2xp?=
 =?utf-8?B?WHVhWE9oVkJOWTJuNkpBdUlIU0d6ZzNaeWVsY1FJMkRpNGc1djh6NjQ5a1dp?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38326acc-39f2-4e3e-3e95-08dbf4624ddf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 00:45:25.7482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbEqhXpgUgQhY5YFGyDc0sXZf3DKGr/XTVPi0O3gLnRrETRkqovzX7VFkL5vvZVrPRelhVskiqiEH3f+d+xlYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8087
X-OriginatorOrg: intel.com

On 12/1/2023 10:23 AM, Chao Gao wrote:
> On Thu, Nov 30, 2023 at 07:42:44PM +0200, Maxim Levitsky wrote:
>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>>> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>>> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>>> one of such registers on 64bit Arch, so add the support for SSP.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>   arch/x86/kvm/smm.c | 8 ++++++++
>>>   arch/x86/kvm/smm.h | 2 +-
>>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>>> index 45c855389ea7..7aac9c54c353 100644
>>> --- a/arch/x86/kvm/smm.c
>>> +++ b/arch/x86/kvm/smm.c
>>> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>>   
>>>   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>>> +
>>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>>> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
>>> +			   vcpu->kvm);
>>>   }
>>>   #endif
>>>   
>>> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>>   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>>   	ctxt->interruptibility = (u8)smstate->int_shadow;
>>>   
>>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>>> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
>>> +			   vcpu->kvm);
>>> +
>>>   	return X86EMUL_CONTINUE;
>>>   }
>>>   #endif
>>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>>> index a1cf2ac5bd78..1e2a3e18207f 100644
>>> --- a/arch/x86/kvm/smm.h
>>> +++ b/arch/x86/kvm/smm.h
>>> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>>>   	u32 smbase;
>>>   	u32 reserved4[5];
>>>   
>>> -	/* ssp and svm_* fields below are not implemented by KVM */
>>>   	u64 ssp;
>>> +	/* svm_* fields below are not implemented by KVM */
>>>   	u64 svm_guest_pat;
>>>   	u64 svm_host_efer;
>>>   	u64 svm_host_cr4;
>>
>> My review feedback from the previous patch series still applies, and I don't
>> know why it was not addressed/replied to:
>>
>> I still think that it is worth it to have a check that CET is not enabled in
>> enter_smm_save_state_32 which is called for pure 32 bit guests (guests that don't
>> have X86_FEATURE_LM enabled)
> can KVM just reject a KVM_SET_CPUID ioctl which attempts to expose shadow stack
> (or even any CET feature) to 32-bit guest in the first place? I think it is simpler.

I favor adding an early defensive check for the issue under discussion if we want to handle the case.
Crashing the VM at runtime when guest SMI is kicked seems not user friendly.



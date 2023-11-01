Return-Path: <kvm+bounces-331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B647DE651
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 20:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9B8C28125E
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 19:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD33119BC0;
	Wed,  1 Nov 2023 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oXhwqt7q"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33118040
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 19:18:40 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECB7111;
	Wed,  1 Nov 2023 12:18:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLz1IFDQnILUF+wYCP8p5yKuggcSGig9rLjAGkpbODrbjkY9o1DS1OJq3khJbSz9OFVPZHolSrOQvGqFqtLBdJCxk3xvEJrtaKpVpfTu29nSnx9euTGp6jkVq3b3pMcbYyeWPkc8rAYAMHmIHxMiCtLAheWDFlxUQb3V61O1gnIyPoAXTOSmqQFsFk1r6V/I2rpA5uy+265gbj0C7JD3fbrlIAU7jWOWS/Vqmsei6DT2gTl+yxf6ZrOi9Z/23pn4ei36tsyA83JXpgP3Tt+E0mTPPEyGpU9y/iyAJlXSGrfrTs7Yi7DhO3a09xGMCNSeEF87iGoMNM28bUSAP3u09g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yaVAK6a08olpCfn/o9qYZVqoBvpiKZFCo/6sa45oFHM=;
 b=WwdU8rR0rIHCldQ+j8To1IAtnub8flat6YhYEw8n5mlggy/iBAE73m36T0ZkGR2PxcI0obMTH+SV/pwCUYHKRaBlN07x8FodLhUEBZwBdWHHA/bjGlsWktjoWOTa7QfiBRRW3lLGP0oXYyS7kjvPYxsC02pOcluLHxHM5V09Fsq8lE/XZdtU1twCtrlGUUmye6jYUMalaRzxopdL5be1MX80BDv8/RPfmnc0ioy/fFQIZrznwAV92FPO+6Z3iRPZ1G+qLlLtI3KR8QznDdUFkxdHD4P9Y7UhSfWxyOrEkiz2+V0IxGHsvLoBTG3gGeCXhiM+RTvB/ZF6rEPDRWJnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yaVAK6a08olpCfn/o9qYZVqoBvpiKZFCo/6sa45oFHM=;
 b=oXhwqt7qCmolTho8pmd1l2i23BvfmrPX78zun1olAQhvG2fgnE3V9CEIuNBYDWRhzg0co4v1z6knY0Oe01Rlm3ZMt0rfBMjZWey+tq0JaBcXqceSQU0qjFxRfF8gg2TphPGnQvQzeHLPAtLHg/0GiPJzZaKNBRcu7F6cuH/hyxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by LV2PR12MB5823.namprd12.prod.outlook.com (2603:10b6:408:178::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Wed, 1 Nov
 2023 19:18:32 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6f:452f:9288:db23]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6f:452f:9288:db23%4]) with mapi id 15.20.6933.028; Wed, 1 Nov 2023
 19:18:32 +0000
Message-ID: <95851979-fa65-7bf8-2d62-ee3f3797a167@amd.com>
Date: Wed, 1 Nov 2023 12:18:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "yishaih@nvidia.com" <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20231027223651.36047-1-brett.creeley@amd.com>
 <20231027223651.36047-2-brett.creeley@amd.com>
 <BN9PR11MB52761611F89F3AF731234E2D8CA0A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52761611F89F3AF731234E2D8CA0A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::29) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|LV2PR12MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ef2485-2ded-4d28-ab7e-08dbdb0f5681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cuxDOGO5NMKjYPuPjdwOwuE2H2ZEMBoUDAUrJGUYBeFLHk/I//VLwkE9Yl/BQVgKUC5GXBIC0+uzFuEv20LeDUPRTfAgDisSyGaqdJ8y4Ed224rU3WM1fXmnuCgQBeFMnHGZaxhvTVLfKoWQ3KWvOH16A+o2OOWye7bGaIv8krQ5qUBTdjmHom2MjGz47WDXE7Jr0puwCE6dYjnFmHETq4rOlntzlo3AiQxVm3iKGtX8HtZLyT1SODWUCWjpFCCV+OkHu2K4VlghkbVAbTdBJ0voJOc2iNT9aghMw2uddFIc6zTSbzvqNV6ZV23AjQZKtftb6nKHXNRTHBYd/bV5Dgl6YlY3e9x/hX8O0JkpALofhybNY4VbLp282wgWoRS0nSxCP0gIqDjnRH+FoNinQpDpSdXKFVxkLSJRaFh6wo81qtgZzDMQEaXm4WlAhAHzV3QT2GKLw5FTXdUCtgJxdiIQM+8HSM9sQCE0zulIIythgClagLUqUv9/OkFGo90WLlNDOtnW/ay4500j7GyTU4SaPbIt56dRBk1PSsoaoa5MLvlNHWiDFdoZIIAA1oy7hCSfkM5ZBadgj8SzDLSkmkbrU5d1h1Si/wUIk7ESClD3dcIRs+Dw5U4uqq786H4hf8r9ek9x8PMu/v/CPlRcLtzw5I2S7143W86E7SwGQkFnPxpOEV1FTctXNZF2dNNt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(136003)(346002)(366004)(230922051799003)(230173577357003)(230273577357003)(451199024)(186009)(64100799003)(1800799009)(2616005)(26005)(6506007)(53546011)(6512007)(36756003)(38100700002)(31696002)(83380400001)(5660300002)(66556008)(110136005)(66476007)(54906003)(66946007)(4326008)(8936002)(8676002)(316002)(41300700001)(6666004)(31686004)(6486002)(478600001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHNlT1ExVGVTT3R3dDdnT2dRRGxRcSszMHM5WVpWLzIrN0hZd3FFdkViRWdU?=
 =?utf-8?B?UElYT21MM01oWnhGQi9tRGNDRmlnOE1FNjQvdit0Q25FZWdTcE1VZnVZTlpG?=
 =?utf-8?B?TUhzYWdEbVMzRG5wTkRBRVRpTE1aR01RRmRBL3hwNFVzL1VuR0pMbTQyZlFG?=
 =?utf-8?B?SnVRM04wWWo0Rm9JZ2l2SGltTEZrcmRkWUhxYklpN1RTUzFyMDZSSVdSWTd0?=
 =?utf-8?B?M3RHZy9yRmNvWGwxRWQ3U3hORVo5eEwza3VqenE4ZmsxbnFYaDNxSlRwRTBY?=
 =?utf-8?B?aTVZQXAvMTVvMzc2czYrTTlxcGxFditvTUlPbHBjWFBKc3c4UXBjRFgwbzU3?=
 =?utf-8?B?UDV5QlVGMmExRllxaGNkT1JyNEVON0Z1d3dDRHorTzcwK3E2ekhkK2tVd1dJ?=
 =?utf-8?B?WTRzdTNJSFhPeStCaXFza3Rxa2QvN09CUTU2SUp1SG02dUpTalZLVEw2Vkxx?=
 =?utf-8?B?K3JsS0sxMVBLMWtUbmxuVE9MTGdZY1JqbmNtanZSK3N5ZjlRb0o3bXhBRG5V?=
 =?utf-8?B?VHlObk1meVZ3djVxdElYTHVJd3JFTXZaVDBLblY0aTVHb0hOSlNTOGtHdHBT?=
 =?utf-8?B?OW4reUlpNUNpcXNmRDJjZzVyOFhENk9sOWhydloxQnJpWGhGcTFLVit2TEp3?=
 =?utf-8?B?OWZhSTN5d0Fjdktzbm5JaXNEYTEweUZTcVBjRXpiV3RaME1uMW9GVzBpT3Nr?=
 =?utf-8?B?bUxLY3JNY0wza3JsUGlJN0NJbm5ycHNieDViSlh1QmhtRmVncnc0a0I4YkN4?=
 =?utf-8?B?Tmd2WUFoQU1QREM3VURQRU9RS2NiTStFNTIrOWphc0dyRnBFSkNKVU4vcnBJ?=
 =?utf-8?B?aXZwZlh4djJyQncwWDd3WG5iNG52dkVCTDRtNXVmNnJaRmxXSVI2VlRab3NX?=
 =?utf-8?B?TGRQY2p0Ni8xQ0ZCY3NsTVYwR2J1eFExb09KZ2ZmcGJRQjY4VFNrS2txYS85?=
 =?utf-8?B?VysyS01lQmNJOG9DMFA3V08xaTkwbVo1YWM5MlJ2Q2p0WFdVcG9GQTYyRkhL?=
 =?utf-8?B?RG1rWlc0VFVmZmt2MlNuem9TTTZCN2ErWkhyVUZ6NlAyZDZvdkZHa0dsenRG?=
 =?utf-8?B?ODJBaWJDNVJDbnV0YXJMRUNGTUFxT2lJcHBrOXRNWEl6TjE3M20xOSs1RDdh?=
 =?utf-8?B?dklCaitQckc4RzZYT1BzK0RLcHBHT2ZrOVpaNlZlRzVZL1ZOblF0WDZjSFM3?=
 =?utf-8?B?N0ZmSjAyTUwzU3FYODY2MVJrSEcxTFZzd0MyTEhrdm1mZU9BM25CUHF2T3Uv?=
 =?utf-8?B?RC9na3ZnY0RmcURxbzFiWVZjd1U3M0VhUlB0Z3JBdWZKK2ZVMmU2cVVDeGho?=
 =?utf-8?B?ajQrMzZEQzN0R3Jkc2xwL2FOT2hPWDY2OEdwZ1B6M3pJY2VNd0F2YWZRaHpu?=
 =?utf-8?B?MVBHTzRJT0l0THdIYXlFMW40ais4ZWswajc2aHd1Q2tUWUNYZEFGczg5ell4?=
 =?utf-8?B?SFAzMVprWGNDNVY3ZTBuU1FUb1ppbk5KSWNtLy94Q2E3TmJWTGVJM0ZiSkdT?=
 =?utf-8?B?Tk8yLzFZbFo4anN3Nk5vUldaT2FnYXRuU3J4SzZMTTF1RnJ4UmcyclBLaWFQ?=
 =?utf-8?B?TmUxTUVwMzByNmlsazRWUW1OcWFhZVY5ZnRBcGFxODNkRWpNaE9kSkpKZ3Jr?=
 =?utf-8?B?T2Y2MmswMnJPazBlZVRaWXJXTTJwSTFTZ3Rnd2Z0YWVTWHA3eGprVWdrVmZ3?=
 =?utf-8?B?UGJWKzl2Uy94Q0hkeWhuaWM5ZGJhc1dSU3NFaFJmeEV3WTd5WjZ4bXVyOGJG?=
 =?utf-8?B?cldzWWQ0dW0rMEloUDlJUytCNWRWZGpCQWtUL1YzQ1J1QzZlUjZ3ZkxkTlZl?=
 =?utf-8?B?ejAzblhFWEU5VkJJTWZXWCtHak1PbFF2YndKbUppS0hseDI4ZW9wQU95S1Uw?=
 =?utf-8?B?TmFHMGRKcllDM2dKblI3ODh2WVhBa0NRSVYyeG94Skh0SkJ3dUpMUUtxdUtX?=
 =?utf-8?B?bW9vSDFLdU5tbHh0MFZmUU9QYXhEWGowRGYxT3VCSDlPUFV4T2M3bkJhNlU0?=
 =?utf-8?B?REsxWGg1ZGF0cVZmQklTRitRTWhtaWpPakQyYlVhUXZ2UFVKMWNaSFVJVXdG?=
 =?utf-8?B?M2cxQXE3c01VYXc2ajkrRUcreXNCb0RtOVJMaForN0NIUDE0WU1lVzhoTjY5?=
 =?utf-8?Q?yEkE1r8D+FV38BlTPLo1LwmiM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ef2485-2ded-4d28-ab7e-08dbdb0f5681
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 19:18:32.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fj8Nlm6B4AjZ4V+wytVWP1gU+Ne0HUWggL7EeRj/uE3abJZ9N1PkBxTzCqL8HXd7DBSqax3fu9AYO5SVqP9j9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5823



On 10/30/2023 11:13 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, October 28, 2023 6:37 AM
>>
>> The following BUG was found when running on a kernel with
>> CONFIG_DEBUG_SPINLOCK=y set:
>>
>> BUG: spinlock bad magic on CPU#2, bash/2481
>>   lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cpu:
>> 0
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x36/0x50
>>   do_raw_spin_lock+0x79/0xc0
>>   pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
>>   pci_reset_function+0x4b/0x70
>>   reset_store+0x5b/0xa0
>>   kernfs_fop_write_iter+0x137/0x1d0
>>   vfs_write+0x2de/0x410
>>   ksys_write+0x5d/0xd0
>>   do_syscall_64+0x3b/0x90
>>   entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>
>> As shown, the .magic: 00000000, does not match the expected value. This
>> is because spin_lock_init() is never called for the reset_lock. Fix
>> this by calling spin_lock_init(&pds_vfio->reset_lock) when initializing
>> the device.
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> is this patch still required with patch3?

Good point. It's not required anymore since there is no spinlock.

Thanks,

Brett


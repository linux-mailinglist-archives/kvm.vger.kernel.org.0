Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365FF79F0B5
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjIMR5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjIMR5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:57:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6D919B1;
        Wed, 13 Sep 2023 10:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENyinK2Z8ZS10c6JLhE6pNK43kMllma0euMxV/f99jtiMKtjAoxtxFqqhjTu9J1DyZpT9yDCb1GpfG+QD+pcbEOx5ofwyRHMnqYU2txuLxcvm6P4Dcc6vEdJ9x+ADD16tQMwxQBC1Ie9F1ADiireoR+PwR0p93SigVC9jrnz0ahDqXTojgtfo4+k/wYlqGoOzEeNyL49Oz4G7ztxo7BL12V0puwRm2ntm09TxMOw8jlKl5+h1aWImJ8oRVZ83Glc9sXYlPX0uR+3r56jZg07Q/9AIqqATus6D+8bNbmnHwjJ29r8D/vWlDcfNOqR9X7wbY6Wf52iDISLqKTO32cDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CL2GJFxNdd880KWYFoOj4E1WgdG7uqLrwvHCcDjqJcA=;
 b=b9lKhHF2QC5uOXgpKbj9OcEAYKPAthGZyTDgszFb/w1KA5oEjThYxC2sxx1tvMlWiFFe8m58XW0uccvqNgRBGSDn+6S3DZBpSefHcRXCge5GbiPXLHsQPVkBG09TgLBehbvxDinkBPKxu9Aj833WcuQa23dv4KOQ55E9OkLoiiHhmQzzAYV3k3T8gtK7gfj80z223NzWrGoyle6R4iZioaUqTRTwNtX9Rgkkoi2yDpXFb4SUFQeokVSjNk1JDgLyHmLme48OOJ60+CgA6YdvV7jkGOERodM3cpbhpoGOUVEb+7zsZjG8DndR578i4RayFBIgI7wCyzqPiI+rczVkeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL2GJFxNdd880KWYFoOj4E1WgdG7uqLrwvHCcDjqJcA=;
 b=leybIL/F82aTQM872VsWhmShJXmDSt3LD69fU5yBgNHCrCOBY2WiULLjhpfafnGLSvxorhHmt2XdnqFFH/STMsp06Nao3zTly0bRnOTFDnMRnyN6UPLU/x6bMmgYkNFgTOZ+a86u+oU+REzQDOAOQKqzEdPJSxvkFevbJrJTIAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH3PR12MB9283.namprd12.prod.outlook.com (2603:10b6:610:1cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Wed, 13 Sep
 2023 17:57:30 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6768.029; Wed, 13 Sep 2023
 17:57:30 +0000
Message-ID: <8749a8f6-d756-dabe-63b1-344221873d99@amd.com>
Date:   Wed, 13 Sep 2023 10:57:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH vfio] pds/vfio: Fix possible sleep while in atomic context
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
References: <20230913174238.72205-1-brett.creeley@amd.com>
 <8fdf4fe3-dd68-4b60-87f3-2607aaa2279c@kadam.mountain>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <8fdf4fe3-dd68-4b60-87f3-2607aaa2279c@kadam.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0044.namprd08.prod.outlook.com
 (2603:10b6:a03:117::21) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH3PR12MB9283:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a481a6e-fffa-418e-be06-08dbb482e627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rra2bWBZOlexMW+MJImsUDZ95v0RTog9zSSV/x1pE+PDISW9mpgp6TuShfs7SS/cxuV3a7xYxxI4KxwiDgNe0DbvxNfe0w635eqVgzrHC1y+s7LYTV6G3PpGxSEjnXeI1ODZdoRjol3RtO+XSuGlMLTQxrK3X6nQv365voYeP60yKmJLaYjX1sZnelzyFEM5qd3Yb/WXWzsYie72GqPfnGTgBTXP54Bv3VH3a/5uNptVJm1Amqw2y8rs2DOAP6wRPx5HIUdEeL1eA9sMXAx5ezwdQ4Yu95G246FFobzSywyC7K2Kw36vF+V9vTtrQdCu0sGGeuBFeeDB+i5F/ncDynBzDGPjZVzzWUVGZnyqsTw4LCOdUhLfFhYBQqukaoZK0DESL6C4kmSMY2ej0FHnScC2EQZivVJHR4+n32Kh1NpOd8klEG7SQQ6FmG7fsDhO/LnxSiEDluAeDAgOTIQ9fyWh465TDmDXFWgbdlheAxTPXbnUeM3viZUKKqhx4rnRZ7FFmZ/P3PvC4oX6G+WJcoMmRqRc63idKl7MVMSfuTuUFtsUhEvWQy5tyiT2G8MieO7r3ffTxjhxA3ucjuCAXD20HaV6U5YjW++iLdbPdzAq52TinAxT0K3pIZbVlNyRvA1oTaU2Mf2b4ftOfLMovQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(376002)(396003)(346002)(1800799009)(186009)(451199024)(66556008)(53546011)(6506007)(6486002)(6512007)(478600001)(83380400001)(5660300002)(110136005)(26005)(2616005)(66476007)(4326008)(66946007)(316002)(8936002)(8676002)(41300700001)(6636002)(2906002)(38100700002)(36756003)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmRRQ0lsWU9OaUV3SzVQVzNOQ2F5eWJYMlQ5TU96ZzJrNitNczFrTEpMZlYw?=
 =?utf-8?B?SGhoNCt3aXJ5YkVTNVBtbEFOamhETzgyZDJEVXVyYmlkRzgyZWdKZ1F5YWtQ?=
 =?utf-8?B?aEwzbGNUdWlOa2Y1YkhoS3plNi95ZXVDWlhuaksvcUlZdDYxT09yVTZKa2Zz?=
 =?utf-8?B?U1dUNnhMcEgrVm5KT2IyUk9kYWxsaEIyL1YxcFQ5RmpmWHpDL0NUQThzVjYx?=
 =?utf-8?B?L2ROMzFlbEVqUG1mVXpCeUwvbk1wbjNmekF5cEtqb3RwWFdlcUhiUVpVdGhQ?=
 =?utf-8?B?ZjF4VklGNlBTRkZGcnJiTUVEc2JzU1N5dDUzdGpTYnJxUmlrWms2ck1RRXU2?=
 =?utf-8?B?YjJIZ3Q0b3FINWxnY1NWS2tWNFhNSkVKeWlpRGUvN1Flelg0NlphTWxZUzFY?=
 =?utf-8?B?WGpjaHJQZTlhT3YxOTdVUzNGckc2UEdHTklxRXdGVjNYMXozTC84OHBUTnZV?=
 =?utf-8?B?RktyNGlUYlNRYmZQNzVQaTJHeEtLTjFIOVRRV1V0OXh6eDJrSUpFeVhBR2o0?=
 =?utf-8?B?L3pTNWlSenYxMzBuQ2hWbjRYOStRb1BnNTYremZ1bC8rZ3hwKzNUZitYakxh?=
 =?utf-8?B?dUJOdS9od01DdFhrRUhaMDdFc2dyU3FaZ25QbkNXaVNtSkIzc01idEtkTXV1?=
 =?utf-8?B?dGVHVjk0UHZTVjFzcmJMUGpwbjdrMEc4V1cxNERoWnkyRU5BR09Pcm9hL3ZS?=
 =?utf-8?B?VXVNWWdkYzEwNE12MkNaVkFWNm14bnNpV0VHSE00alJtVjh4MzNPYkFhSE1a?=
 =?utf-8?B?UFVWMG01Qk5kK2lzTlB3Y2ZpUFgrcWw5YWRtRmdzdTJ3K0pFSXhTWkl0K3R2?=
 =?utf-8?B?RStHOGJQYjFkL1hsNk0wRCsxNmR0bUQ0clFxNENKNEFEVit3eWNUMVp2VHBH?=
 =?utf-8?B?QzN4UVZHRWxVWDFkMndwWlBrYzg0Z3Y3WGNXRTdhd0tyaDVxQ1lEamZLaG9T?=
 =?utf-8?B?enVVZXZCYTBGRXJabi8yMTlYT1E2TGpaRHN5VUFVeTNGYUlkMTFwbmE3VVpu?=
 =?utf-8?B?bWc0amVKaS8waWl4WkVxaVd1SEVDbkdhbzM5bG1DcGY3VUtsaTlyWEdwWVEx?=
 =?utf-8?B?RlFzb21UZ1NvR2c1L2tpVEs2MGNSS1pQM2lkUEU2QTFmdzBPYnRCbWcyVUQ0?=
 =?utf-8?B?N1l6SkNVTjc3UzRHNFFmL1BleHZaTEdzcnN4dzJ3bEhEVitUcUZOdFFpZTMv?=
 =?utf-8?B?eEYvblYvS1JoL3pxcmNjMUJzK2xUMnk5U3d2UHd5NGV0dmwwa3ZiZ015dzBM?=
 =?utf-8?B?L1YvU3RNdDc2Y0NiQ3hCbndwWjJqdmZVMTl1NHZmY3hVQy9ad0ZMTnZVTG1H?=
 =?utf-8?B?OTVLMkxqVnJDeVN0dFU4YWZkSmZBTFRoZWRFYmROM1lSalpxU2RQMDhwVnNO?=
 =?utf-8?B?TGVxZzFHcmRuRUtSTWh3U0ZtUERRQ3BweW5iVjRKM1Q1NXdLZ0VrY0NTSmky?=
 =?utf-8?B?dklWaXJBczRPTlNyblh0cGgxVGt2TEphdmZCNnVmS1g0YUN3ZUIyS1VCUzVn?=
 =?utf-8?B?eUtyZlhaYXFhVGsxclowaG8yTXhsMEVqdmtXWm1icDZFU29XQkhKNmtnNEQv?=
 =?utf-8?B?Q1prMVdjajFNZVI1a1JSZ2doSkQ0WlpuQ3huYnFsSytNOGtlRTh2UHZZOE82?=
 =?utf-8?B?QnFaTDN3dXlhNmN6elJ2VXRVZ3BGeldkNFRMVHBuVzhZa3RiQ05WZXJmWDVC?=
 =?utf-8?B?ZGJoTHBVMThFS2JYNElYbzZRQ0ZtVG4vZkd0SnlNeWlZV21UNWdRRWR4UHJz?=
 =?utf-8?B?MW9UZzhEdkdPZGNWOGErYWlqTVlWNEtHdzNZdGNyVTZhK2FDWElnNlZXUEpH?=
 =?utf-8?B?QzZ5TXY3Qi8zVFhKMVNrWFlGc094U21wZjBvQ09jaThzWnNpNEdTc0NtSk1P?=
 =?utf-8?B?dlRSVEVkdHNJRUhLSUIrSVorYWk1TmFkSmZTTm1ZeExCZUlOeTFxQ1JDQ2JZ?=
 =?utf-8?B?NkowSVRsRjVWQ0hoamp5eWlvRWN5YkNMTkk2TU43UnVvbFZyVm50dFlPNEdn?=
 =?utf-8?B?M21sQm50Z2pMOHBKT1g3RDBiOXV6b1dKdkhhemo5MkljV1FtT3A2MDZyMlJD?=
 =?utf-8?B?bFFsRS91dmVTalFta2FoZG9sZGJpTDBMc0RESUZhWTNGYlVSL2hCdG93RFNY?=
 =?utf-8?Q?jqAmCA62e2/FI3qprTF7+8pz1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a481a6e-fffa-418e-be06-08dbb482e627
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2023 17:57:30.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjFN+vw2d2p0dM7tys4mAcTR1JZNYk3gZ2n1aR+dfIBgpU4DA6MU8To6ks8XZzIK6haPgiZd2iGvZHvFlUd40g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9283
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/2023 10:51 AM, Dan Carpenter wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Sep 13, 2023 at 10:42:38AM -0700, Brett Creeley wrote:
>> The driver could possibly sleep while in atomic context resulting
>> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
>> set:
>>
>> [  675.116953] BUG: spinlock bad magic on CPU#2, bash/2481
>> [  675.116966]  lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>> [  675.116978] CPU: 2 PID: 2481 Comm: bash Tainted: G S                 6.6.0-rc1-next-20230911 #1
>> [  675.116986] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
>> [  675.116991] Call Trace:
>> [  675.116997]  <TASK>
>> [  675.117002]  dump_stack_lvl+0x36/0x50
>> [  675.117014]  do_raw_spin_lock+0x79/0xc0
>> [  675.117032]  pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
>> [  675.117049]  pci_reset_function+0x4b/0x70
>> [  675.117061]  reset_store+0x5b/0xa0
>> [  675.117074]  kernfs_fop_write_iter+0x137/0x1d0
>> [  675.117087]  vfs_write+0x2de/0x410
>> [  675.117101]  ksys_write+0x5d/0xd0
>> [  675.117111]  do_syscall_64+0x3b/0x90
>> [  675.117122]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>> [  675.117135] RIP: 0033:0x7f9ebbd1fa28
>> [  675.117141] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
>> [  675.117148] RSP: 002b:00007ffdff410728 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> [  675.117156] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9ebbd1fa28
>> [  675.117161] RDX: 0000000000000002 RSI: 000055ffc5fdf7c0 RDI: 0000000000000001
>> [  675.117166] RBP: 000055ffc5fdf7c0 R08: 000000000000000a R09: 00007f9ebbd7fae0
>> [  675.117170] R10: 000000000000000a R11: 0000000000000246 R12: 00007f9ebbfc06e0
>> [  675.117174] R13: 0000000000000002 R14: 00007f9ebbfbb860 R15: 0000000000000002
>> [  675.117180]  </TASK>
> 
> This splat doesn't match the sleeping in atomic bug at all.  That
> warning should have said, "BUG: sleeping function called from invalid
> context" and the stack trace would have looked totally different.
> 
> I don't have a problem with the patch itself, that seems reasonable.  I
> really like that you tested it but you're running into a different
> bug here.  Hopefully, you just pasted the wrong splat but otherwise we
> need to investigate this other "bad magic" bug.

Hmm, good catch. Let me double check this and get back to you.

Thanks for the quick response and review.

Brett

> 
> regards,
> dan carpenter
> 

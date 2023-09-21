Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838897A964D
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjIURGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjIURGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:06:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C483AA3;
        Thu, 21 Sep 2023 10:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpsIH/PyJtcpkfTy3EaupRsDiqd4tpFV7adWTZVZSGKBBBsULGXU9d4CfZuX2CqjGig6F4+VB2W4yhk3ptL5w8HKPF2FzrK3exTCCmm2WgNJr6StS2DvuOCMn9L7VvQIuFA2ue5WkdDGiRJM4nBOc/v8bLnqFUf/MZN/9pxeePFcO1X8PUxecBkHgYO+QyouWKjtluUtr8iLP3vwlGX5hRkbY0OYmA3S5Blau+GQT8v4c8ZUT19OAH5CUwspm23i0O7mWZelOziBhaWkN3gXAJjYp3QExyp2Ey0Ec82iCQWnIhfL8kZxBIn2Hpp2BYShanaJZiZh9jhM571rk2y+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cPEHB5LjyA/fSD+lXgZfp1anV7Rsug8ukJ6Kk3FHIs=;
 b=lLw1z//ysSks8+qT8LJUHH7XADkQIq9GFMWAMrQv1JDTAjDimj8ePWErse9eKzGwOxqGOlEX6v7NcUPugCaoITKv3T4xhIzw0Coc3LuceSJrNwh2Ng6TI1PoezANUY6EFMLcUTgkobsHdyuu4PDNhuHCDzAXhj79SfvDKJDZSccpfaA7b1be7vkKdZjAGtrQpqVsTQCgY2bf6ASAoeDpfNXMwc2wxeH05jO2N3aCqqwjp9bWJ3ZFE0JQJXGv6k1h3avLeQ3Fzoe7GiTH0IT4U26ZwAnfD1rMHs7yEsg//ZSWMPbRff0z5LaIUmxDwFXmlW3of6RvZNMA1l4PZ8hhSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cPEHB5LjyA/fSD+lXgZfp1anV7Rsug8ukJ6Kk3FHIs=;
 b=h/B4pKyK0DqFlomSSEGHsv8pcJyUZFhMLJg8g1EM7cK7y/76nTsCUhLVuKLfldhNuj8x/PfLGzPS0utB3AxG9RpYb9PPdLWU40euDpcsAW4PKPte5uA7wkimC1aACYK35yOeyUxk+51QrORKop0VV28StzEaTYkIikpj8jnMZH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB7647.namprd12.prod.outlook.com (2603:10b6:8:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Thu, 21 Sep
 2023 14:49:35 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 14:49:34 +0000
Message-ID: <b1461a22-a919-d6c5-c0c1-07ed69f3c54e@amd.com>
Date:   Thu, 21 Sep 2023 07:49:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        dan.carpenter@linaro.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
References: <20230914191540.54946-1-brett.creeley@amd.com>
 <20230914191540.54946-4-brett.creeley@amd.com>
 <20230914163837.07607d8a.alex.williamson@redhat.com>
 <20230919185938.GU13795@ziepe.ca>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230919185938.GU13795@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR22CA0003.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: d035e5a3-091e-4431-accb-08dbbab1f8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjiO3TRZb+lzi7JmV7xo1fE9LpPmXJnv1WCEWDVHq/U2f6hVb3SSxPGMiiv/qfm9YsXmiw3mo2W/vu52Bs5lTmewuVQv/8TBl9eciPDG7wkdQjQ5DAJFsN3ntJG/qV0Ds9dJrp1Q9DgG0CrmdaXObYQZtJgMVUKXhXVglK/eu+w5gNx4ytgBRrNmVKFVvqd43Ha+WaiPEr2cEHLet+/8eBvXMSiGci6s2k7yhCuzUsT0kx+EIeJkb+w9+7GbnDvGxL8cL1VE0fYW7jLO4JMVvwQAeEo5EyJaC1FzCI+kc1NbTIp3kF1iSfeWE+InaUlHVNs7WG+NVUMAlUoAR3dYjwSBFsB2n5g36D852ZMI9AhQMzsSxjVTtvpIZpu2rMEEKmjccyzCDvYvHwjYeurMWwJeJ9lZhvmDv44ZTmhOBNR48fU5AZBkdOKi0NDVqH9LNU6JBHpjB9ukiU5RAYCJsKTRSwnKmkAD/XCcHzXCVtvQVzUNlcezU53qAm4kkSdBT+Te/e34Oi4bj42f/q6RS15TI65vDQwv1r9EDQc4RtAMgiOf9Bal91ZbuXv/MDlRU107uIRAsoQ3LHmYzOF/n8dSmLWQdpQgfJXuTWFhCp9fILCUgIEwtQ3h7rEYYmTDhEZKbUI+VXOly9ErJBAU/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(1800799009)(186009)(451199024)(66476007)(31696002)(41300700001)(66556008)(316002)(66946007)(8676002)(8936002)(4326008)(6486002)(478600001)(53546011)(6506007)(966005)(6512007)(110136005)(83380400001)(26005)(5660300002)(2616005)(2906002)(38100700002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ulh2K2F2WStNRVl6YlpOME8vcjA4QzgwU1I3Z2RUSTdXNG4yVWVyczFndWtm?=
 =?utf-8?B?ZWlZa1AzNGtEcHJrVlE0OStMbWNOUk5RNC9rSmRmN3k2SVFxWjFLZ3hNRU51?=
 =?utf-8?B?SlVmNTFVdG41UmI5ME5QYmxNM3AwK2YrNXdhQjlEazRhcVc3QnNueFYxK1Rw?=
 =?utf-8?B?aU90bmE2UklFS3BHRHBtTW9tU1NveWZsekRPTnJybzdEcWYrbWtWZ0NCVkhk?=
 =?utf-8?B?NEMvWnhadVZLRi9lc0R2SFNGTzB2OWFTYVRYOTFsa3R5Q3Q2dU1HVHZKZ1oz?=
 =?utf-8?B?Yjkva1FON0kvcmxiL0JqdXBUYXYybUtUa1hEYWJaTUdCNkxvRnZGdTNWN25U?=
 =?utf-8?B?NW9MdEJ1VFBldy8yRmdIZkZ3bXlhaGRUbmE3cVg4U25LZ1krTHZsVEdCWTBB?=
 =?utf-8?B?V3ZLd2tySUxLMXdaOGZLeTNBL1ozaFhPd21GOGd0Z2Y2SzhIR0V0b2pQaVMy?=
 =?utf-8?B?YzdkYnFIWm1hanBtaUU1THlIUklPUDBjTGNEWUtEVnFlM3BhMHcvS3QzM0Vx?=
 =?utf-8?B?S1hDVWQ4TGFRcFcwTUIyZUNqY0tzKzduTy9iazRhZCtuS3JwaFJ6ZDVLM0NT?=
 =?utf-8?B?bTYrallHZmxSUVg3cktpYlQ4UzU0R3Z1VHZqT2V5N2NrSWVlc1RBTmx0dHdn?=
 =?utf-8?B?S3ZGdGVaSVo2aHhGSHdSREI3aFFBWUtBbndZRjhSTXhEQWhTbkZTNTM5Mm94?=
 =?utf-8?B?NnhLZkJVaEd4T3ZQdmMwTmVQRTdrRWhWWTIwUE1PeFVBYzFZcGFVTGlPYVZx?=
 =?utf-8?B?YlgwNWI0aHRDK0RuQmVnMjZCWnkwUzhrSWZLWVdLMFFGMDJlb2FPZ24xYnJI?=
 =?utf-8?B?VlJnTk9qeWhBZlZoNHpjV2JCdUhwNjFmTXNVa2ppbFBJdnhMa3dJbWJYNTU3?=
 =?utf-8?B?b3lJeUFsaXRjYkk1YkpoTHlHcE14dnE0UXBUcXRHU3FHcFdpSmxkbnVQNXZi?=
 =?utf-8?B?RWdCRHQySzFXZ1RjUUczSHhLWU03ZFB1R0ZWb3JpaW1HSEp6Q0I4ZGgzWXNn?=
 =?utf-8?B?V25YZTBVZzlINHpOSS85MnZEc3pHOG9MZnhKSERRZVU5Y1hpZHYrb2ZXcTdt?=
 =?utf-8?B?VGlmcWxZSW9iR3pVelo3QXBPZW00aFY3U0hPbzkwNFZFK2dNTk10OE12QzJq?=
 =?utf-8?B?Q3lFWVZLZEZCdUk5R3dFSHBOYklxRy9tVGE1R0tpN1RnSGt2UGNkdGFqR080?=
 =?utf-8?B?L2JTLzd0SGRUNTR5VlR0bnpGZ1YvOTAwaFd5VC9zWXYxbHFqVGttdnN3VVJt?=
 =?utf-8?B?b1A3VER3aU4rbTBIZjRsSWs0MTlwN1E4eklzaXQrejliQjBnWHEzOXQwbExk?=
 =?utf-8?B?UVlobHcxSnhiQ1lmVkorbERzZ1RKTk9BUjZpdDRza0tTQ3JOT0VNeTlqMmZt?=
 =?utf-8?B?d3E5SjhUTmxZcExCbnh6TzJUUzZmTUtIbHVrSGF0c1pGaU45bFE2QVZVcmpx?=
 =?utf-8?B?ZUJXbGpTRDBNZitOdndjUStrUy9oVEhxQVhDTnh1bEkxa0Y4RWc5WWdSakJL?=
 =?utf-8?B?Qk12bmIvTk94MHJqeVdUVmhaUnFUMVdXMGY2QURiZGJOL3g5cGE1bzVtSUVr?=
 =?utf-8?B?Vk9ocUdQMm9nRkpYaU5vYXk4eUdqVUNabHZ6T1RDWmdKeElWRkVFa1NWY0JQ?=
 =?utf-8?B?Y1gxd2dKdWRMQzFmTGlocE9tY0ozb2pTb0Y1dWw0MGtXVmM4WTBGa0VQeEJJ?=
 =?utf-8?B?Um5Zdkx4aDZJMjdBdTFGb2NOdlVvemIvL3NrWGRpUjAvVTFKUFRVc1hDcDRQ?=
 =?utf-8?B?eTFNeml1cUx3WTFZRURtRVpkbXNoaXN5Yjd5MmJBUVRNZnhCVXdVc1ZZYlFj?=
 =?utf-8?B?U21aTFBFeFFDSlI5UldVYWF5SWMvVjJick9NWkdHQ3VEZTJSUGRBQXdlL3lT?=
 =?utf-8?B?a25CaXpUT2JGaWVGQ2VQa1RwekZtRHNlNW50RHNMdzQ5ZE1WNmN3NjMrOWsv?=
 =?utf-8?B?NUY5cTRRUlZpRWxLSUkzQTJ4RW9VUThRVk5XTWY3dDFMUWVnWGFWbnJ3UXNG?=
 =?utf-8?B?Z09WTExCUlRtcEFPWUhObEpHTzFQVmJEWU1jMG1ia1RCRkpBTkdrOUE2RnZk?=
 =?utf-8?B?WlFaYTZUQXd0bE0wdlN6Q3kveGFFRENCQ1FBUFBDWVpSS0lSZFdSS1JPdzJT?=
 =?utf-8?Q?95OC6xTJ8EmP+8XFPYh+jcQkG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d035e5a3-091e-4431-accb-08dbbab1f8b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 14:49:34.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNcNhlhHse/4EwA33YA1ie00G4SdRRhwhWKjaDC+IejJzhRTYffuevH33RNFvC1QmPWw2E1wb0hKwlWVOY9a4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7647
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/2023 11:59 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Thu, Sep 14, 2023 at 04:38:37PM -0600, Alex Williamson wrote:
>> On Thu, 14 Sep 2023 12:15:40 -0700
>> Brett Creeley <brett.creeley@amd.com> wrote:
>>
>>> The driver could possibly sleep while in atomic context resulting
>>> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
>>> set:
>>>
>>> [  227.229806] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
>>> [  227.229818] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
>>> [  227.229824] preempt_count: 1, expected: 0
>>> [  227.229827] RCU nest depth: 0, expected: 0
>>> [  227.229832] CPU: 5 PID: 2817 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
>>> [  227.229839] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
>>> [  227.229843] Call Trace:
>>> [  227.229848]  <TASK>
>>> [  227.229853]  dump_stack_lvl+0x36/0x50
>>> [  227.229865]  __might_resched+0x123/0x170
>>> [  227.229877]  mutex_lock+0x1e/0x50
>>> [  227.229891]  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
>>> [  227.229909]  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
>>> [  227.229923]  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
>>> [  227.229937]  pci_reset_function+0x4b/0x70
>>> [  227.229948]  reset_store+0x5b/0xa0
>>> [  227.229959]  kernfs_fop_write_iter+0x137/0x1d0
>>> [  227.229972]  vfs_write+0x2de/0x410
>>> [  227.229986]  ksys_write+0x5d/0xd0
>>> [  227.229996]  do_syscall_64+0x3b/0x90
>>> [  227.230004]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>> [  227.230017] RIP: 0033:0x7fb202b1fa28
>>> [  227.230023] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
>>> [  227.230028] RSP: 002b:00007fff6915fbd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>>> [  227.230036] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb202b1fa28
>>> [  227.230040] RDX: 0000000000000002 RSI: 000055f3834d5aa0 RDI: 0000000000000001
>>> [  227.230044] RBP: 000055f3834d5aa0 R08: 000000000000000a R09: 00007fb202b7fae0
>>> [  227.230047] R10: 000000000000000a R11: 0000000000000246 R12: 00007fb202dc06e0
>>> [  227.230050] R13: 0000000000000002 R14: 00007fb202dbb860 R15: 0000000000000002
>>> [  227.230056]  </TASK>
> 
> I usually encourage people to trim the oops, remove the time stamp at least.

Makes sense. I will remember that going forward. Thanks for the suggestion.

Brett

>>>
>>> This can happen if pds_vfio_put_restore_file() and/or
>>> pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
>>> while the spin_lock(&pds_vfio->reset_lock) is held, which can
>>> happen during while calling pds_vfio_state_mutex_unlock().
>>>
>>> Fix this by releasing the spin_unlock(&pds_vfio->reset_lock) before
>>> calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() and
>>> re-acquiring spin_lock(&pds_vfio->reset_lock) after the previously
>>> mentioned functions are called to protect setting the subsequent
>>> state/deferred reset settings.
>>>
>>> The only possible concerns are other threads that may call
>>> pds_vfio_put_restore_file() and/or pds_vfio_put_save_file(). However,
>>> those paths are already protected by the state mutex_lock().
>>
>> Is there another viable solution to change reset_lock to a mutex?
>>
>> I think this is the origin of this algorithm:
>>
>> https://lore.kernel.org/all/20211019191025.GA4072278@nvidia.com/
>>
>> But it's not clear to me why Jason chose an example with a spinlock and
>> if some subtlety here requires it.  Thanks,
> 
> I think there was no specific reason it must be a spinlock
> 
> Certainly I'm not feeling comfortable just unlocking and relocking
> like that. It would need a big explanation why it is safe in a
> comment.

This follows the example in mlx5vf_state_mutex_unlock(), which releases 
the spinlock before calling mlx5vf_disable_fds().

However, there is a small difference where 
pds_vfio->deferred_reset_state could change in the window where the 
reset_lock isn't held. It seems this can be fixed this by a local 
deferred_reset_state in pds_vfio_state_mutex_unlock() that I set before 
unlocking to clear the fds.

Thanks,

Brett
> 
> Jason

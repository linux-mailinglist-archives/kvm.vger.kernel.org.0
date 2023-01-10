Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9655664049
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 13:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjAJMTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 07:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbjAJMSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 07:18:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2135.outbound.protection.outlook.com [40.107.223.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4FE3F
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 04:17:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQoDPbWSR47eqGQZAW9ovY87jMTaKDAV5Ka8AITPXe0qx2P23ae7HAMi3ypBExEqD3nH00wiOY3ilFuQW73J1dBauhkxIKr5CT7y6sxkLsTwwcoAw183S3VPIC2O9msrsruc1o1Ma/63yJ0i74HejI80JwWQdf7P4n7XR41z8wkdjmDIkJwhAColX3YESL1GpyYGFHB5t2+PViYBieHR3SC8gpTOky4qyVnyimKrJ0/kdN4d0c4Tpyz2K/2cFtGmeHesg0EBDBfUGMpNylpvSdsEsxliN2oNWo4IVbe9UNJQt6YnMyXxDdVLGB+qNVgTbyXqGqfC8iiWuQ7YLg9oEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knXql5QwtYBSYDOuXVs+pfF8BJ9eouPjFtqTfHGmE84=;
 b=K3v2ySKo9pO3EzCzr8JnEAiquoAla4fayj1ZrKEfxlwjChUsi1p0knu+b1/XarnwKg5dkkjBLFglXkr9ESafNMRRIV81jhgstW9fmjVCBJoHSYtuLtntQ/CWd5m1keP5POzq/02U49ZDRhbEkF4LoyZ028B93MR4XqtBlb5i1nuRz2wbwDdEtuS0xmctypmKVDtoQoIiZe2w4WT/BXg8qatWVlJ4vDFdymtHaMsgFQca0AzKabijTU4AGuSeaNAjVbj9YRJrjpsvf30s/KiLh9mT/l99DHxDC0yCHJuGHv6So1ITlt0TjEja8I5jmsYE3sBUoDZPjwxVtlx2ZoyP5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knXql5QwtYBSYDOuXVs+pfF8BJ9eouPjFtqTfHGmE84=;
 b=qH/vu41zLsenpy86a1QX+lst1j30UQlAJ9KEVTTEUv//VPpf8DBqWVKeH+zzZsXwR/mtRUqSU2Wgy8b/8U4Xt26TbgYZmrZP4EfTBwwi6ghsw4HkLSI20TQhQrTP5DxxeZg6FdEd5p307f6gym8FIn9TjHi8R0UFuFaDuhCSTIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SJ0PR01MB6333.prod.exchangelabs.com (2603:10b6:a03:293::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 12:17:30 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:17:30 +0000
Message-ID: <6171dc7c-5d83-d378-db9e-d94f27afe43a@os.amperecomputing.com>
Date:   Tue, 10 Jan 2023 17:47:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
Content-Language: en-US
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0085.apcprd03.prod.outlook.com
 (2603:1096:4:7c::13) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SJ0PR01MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f09c2e0-3432-449d-01fa-08daf304a4c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/6niu1WeN1qBoVPD+1V+xkQyLyHmYTMl1vrmuSUdPxB0RX930G6MYBpFAYF2v6Nwiv6Gt/UTx0wOlDMPiWdTS9iId4xlWlD5U7e54BTm16dQXMHjZHTiecuHFC55wHw7Iq+6pMUyRZ/yViJAV2H4fuo5HlTIoDMciwOEpy59rVdPp+KVskNU68wg9BGQ2UolD/AqYoo2dwq3ieDykfEwDRbbA/4SjfK+DDrAh6bqB8ZPzSE0aIt3NIIdt5a+YoeMMYXQjgEnHU5Kvt3MNewSTPuUsWAUwrBNH9a0GmGczmcDtfywB/MWwIa23xS5A+56wmLPPVPyknHTdh3NksqmC4LmiXnX5jtWe+bczfrX0CJBhxrYh+yEvpoSEzSGs4lYY0ukqBvRp6xKLrzpGVM0koC0Sfvz3CklRaTt4VAWUf1ylEviPK3oDbyKc5Zc+wP0A1zXGqLnsAOqgHT1hoHBSA22Psf2RFJPjrZRuPSkB1MkVHyYcWn0ZtfoeVjwfXHtNPPjAp71EOQFZ3q9218MRqTcf0MsYWClR9x2zjLqNS65kOhKdDwQ1iEq15Wc0RlqCS/7MA05Pk5fdQEL7tgCGPsU7H8a+0weIErdPMGjA4SxA8tTEC26PxFJHbg5yJctZ0V/agcEJsGdNA2RcEjGwWgIsEz+XM91plO60aUbxxdXw7JEwq2LHDMBOUoAGLwFFN00EfAvSw3y1PgY+UcZMwTsvHZ7rQQIrZ2U4xThF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(451199015)(83380400001)(41300700001)(66946007)(38100700002)(66476007)(8676002)(66556008)(4326008)(5660300002)(107886003)(8936002)(2616005)(186003)(6512007)(53546011)(478600001)(6506007)(26005)(966005)(6486002)(31696002)(86362001)(6666004)(6916009)(316002)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXMxYjlreityVDhsMVU4OElKMlhNSHp4ckIvYVlIcFd5cnJBSEhrb3hvZkRB?=
 =?utf-8?B?RFowV28xbWxVRmV1QlpRMklHcW0wSUdRdHFsaTNSRnYrdytjMWhuc0dXMGk0?=
 =?utf-8?B?ZkM5ZE42Nld4Q2I2anIvVzhscnZScU9ValhOZVViY3p3QmRCYVc4dWxFM3hW?=
 =?utf-8?B?L0RQeXNqRkxpTE84NVhIZE0vN1VLMlNyclF4MTQ5djRMSnREZys1VFovVnNw?=
 =?utf-8?B?aE95KzZZVldlblV4ZUpHRnNhVGZ6eEZQbEZQYTJ4d21RWTlzQ2hOdEtyMWNR?=
 =?utf-8?B?Z250cGRubzl5dkQxbnFCWHhBWUhKY3lSQ1NBSHZOYW9HZllzMWd4Q3Vabmdr?=
 =?utf-8?B?dFZCelR3TTdrQS95Tms4eU56cXpFdEw4VTFZS1AycDBDZ1BQa3N4OEtlUlpX?=
 =?utf-8?B?YUgyNHNJdHV3ZXg1QnVpL0FYZmVITDgwMTJGYjFPck5CTzVKNUlZWlAyTk5u?=
 =?utf-8?B?bjNjQnNzQndHbk10T1ptTWt0TjQ5QXlDRWRCT09ObG01TlRsSTM0VVJrUjJl?=
 =?utf-8?B?SFNVczBSSWxPOWVLVGtGbWFMNnB3Q0JmUkt1NmxjbTdqQ3ZTTXlEMkp3QXlX?=
 =?utf-8?B?dG13SkxQWTdDSnpTODFPWUNndXh6VmNBWkJYZ0dGa3pYZzlONjFVVmNYaFZl?=
 =?utf-8?B?c3QreGxKUzFhMHNVZzF2SHBGazdkd2p6c1k4bzBhdlJJZVBnN2hEaDYxT1ZM?=
 =?utf-8?B?eXNwS090VFZtQnY1bTBkcjl5aVBsOTNYMWExUkExMlBEbEpUZEZheS94c2wx?=
 =?utf-8?B?dGZSRkdIOXl2RzliSEJBSGJKdUhLaVdoV1hGTDY3UjN4Yk9lRmp4a3Q5dkpG?=
 =?utf-8?B?YXM4SEhpemdHbHk5YnJJT2QxeHdOeWcwNzZPQVg1WWtxWGtuVE15anZ1SUU5?=
 =?utf-8?B?bWNlTDEwQVhCQnBHalpEd01PRWgwTC9pK3hJemtFRUFaWDZzdDlXSlhwSXhU?=
 =?utf-8?B?UXU5Q1ZRKy8zRFk5SCtLSDFjWWI2dkNYeXRHcTdoVkpyeWd0V0wxY1pZc0tC?=
 =?utf-8?B?OEdhVTI5SHV4RTNleEpJMmxiNHhvUm1iN1RUeG8yalpSaGNGWDYzVWhaWGh1?=
 =?utf-8?B?QjAwdTdzb3J5N0Y5WDhucmtRSW8yWitUNFN2MWxMYTZQSC9nZENMK2lFVjIz?=
 =?utf-8?B?Vng1U2NDNGYwZ0hSQld2elpWVnQvZVAyaTBpUmdPaFFNWGkvZUR5UWF2MjJ3?=
 =?utf-8?B?NVpSaGtlQlcxRlhtV1lBVGFZaW91bHkzcm5LazJKUkc5eCtsN1NOVVRhM0li?=
 =?utf-8?B?di9CZXQ2V3RpckswWHU4RmZ4QXJZN2xVTzZITFhMQ2F2V3hFRXdoUkhKMkcr?=
 =?utf-8?B?cWJtd0pua0dTcHhWTU1HWWxjei9mMkR5ZDdzbDREa2RGaTB1emNpZUQvZ3Jl?=
 =?utf-8?B?YmNISy9DSDZ1NkVSa0daajZlTVpoblhPK0FPcS8weGNJMm1FdDBFTGR6Uklp?=
 =?utf-8?B?azBOeDFOd1pzVEw3NGpLekdtc2YwRWhoQURhYktJVnl3QlZnQjA0U1k4Y0Fs?=
 =?utf-8?B?Yk9XVmZQbWJWd3EvT0NEd0UrVjdJYmt4RUV5ZkdDQTFYdGUxdE5tSExUVGhZ?=
 =?utf-8?B?T2RyRkp4dDk1c0RTOXhDOTVBSE9xNkpJU1VFUWJ2Q1M2RjhCMEppcUVRVGdz?=
 =?utf-8?B?N3EzemI2SllJdE8rUmRXckhjLzhPZ3FGZGs4K0h3Z2Zzcm9wd1UrWm9aSW1i?=
 =?utf-8?B?T284cTJjTW9ZWGNrYkcrQnpqY0pQNE81ZXU3cXNFZGFieFQ4UFRYSFZVUys1?=
 =?utf-8?B?T20xbmxwK3VuRERzdVVzUTAycm95THZtQ3krZWs0OGVadTdib0ZpdUpIOU5a?=
 =?utf-8?B?UkpMdkxTKzJuRm5vTzdTdVc1VGE2Mm1HK1JIUllBdG8zM1lCOXlVYVpUVUhX?=
 =?utf-8?B?cTdFVnNPSVhubEN5ZjZBTDdyOVk5eUZ3SkZjczlrR1dqVVNWV2xhQlppY1Y0?=
 =?utf-8?B?eVBnY3plS3YxS0NaczdTS3lkVG84TTI2SjN3MkdaOXNlY2IyeUxwYklwUmVI?=
 =?utf-8?B?dEhUb3FsRUlySTNWME5VclB0cWJKQ0IrV2swcDNMbUFJbjIrTVdOSWdZRXNC?=
 =?utf-8?B?dUVGVmw1U3ZjbTg5ODBuTkovZmplN0ZpQkRqWWNhOU4vQng4ZFZQMVhMV3Nw?=
 =?utf-8?B?L0FBK1pvY2tVc2doMWMzSFZ2TTNXZ3F6bnNsZVFkY2dudXNCaE9MMUt1WnBN?=
 =?utf-8?Q?xU7WdMIAGa3vtXGWKpf9BVtyFXlSbmcXPSoy295KmqUj?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f09c2e0-3432-449d-01fa-08daf304a4c3
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:17:29.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbVGstKdpi/YV/7PMNHEf0kmT8gV3GhuzCYVjKgqcdhZcLByR+2sIeu5yfSt8yrPSlMP3FsDxFRiBgqgXGaxWK2TR7iikBXPfUVZe/ORsnyjPiuaPu2+A7kheqwWVRRC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6333
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 24-08-2022 11:33 am, Ganapatrao Kulkarni wrote:
> This series contains 3 fixes which were found while testing
> ARM64 Nested Virtualization patch series.
> 
> First patch avoids the restart of hrtimer when timer interrupt is
> fired/forwarded to Guest-Hypervisor.
> 
> Second patch fixes the vtimer interrupt drop from the Guest-Hypervisor.
> 
> Third patch fixes the NestedVM boot hang seen when Guest Hypersior
> configured with 64K pagesize where as Host Hypervisor with 4K.
> 
> These patches are rebased on Nested Virtualization V6 patchset[1].

If I boot a Guest Hypervisor with more cores and then booting of a 
NestedVM with equal number of cores or booting multiple 
NestedVMs(simultaneously) with lower number of cores is resulting in 
very slow booting and some time RCU soft-lockup of a NestedVM. This I 
have debugged and turned out to be due to many SGI are getting asserted 
to all vCPUs of a Guest-Hypervisor when Guest-Hypervisor KVM code 
prepares NestedVM for WFI wakeup/return.

When Guest Hypervisor prepares NestedVM while returning/resuming from 
WFI, it is loading guest-context,  vGIC and timer contexts etc.
The function gic_poke_irq (called from irq_set_irqchip_state with 
spinlock held) writes to register GICD_ISACTIVER in Guest-Hypervisor's 
KVM code resulting in mem-abort trap to Host Hypervisor. Host Hypervisor 
as part of handling the guest mem abort, function io_mem_abort is called 
  in turn vgic_mmio_write_sactive, which prepares every vCPU of Guest 
Hypervisor by calling SGI. The number of SGI/IPI calls goes 
exponentially high when more and more cores are used to boot Guest 
Hypervisor.

Code trace:
At Guest-hypervisor: 
kvm_timer_vcpu_load->kvm_timer_vcpu_load_gic->set_timer_irq_phys_active->
irq_set_irqchip_state->gic_poke_irq

At Host-Hypervisor: io_mem_abort-> 
kvm_io_bus_write->__kvm_io_bus_write->dispatch_mmio_write->
vgic_mmio_write_sactive->vgic_access_active_prepare->
kvm_kick_many_cpus->smp_call_function_many

I am currently working around this with "nohlt" kernel param to 
NestedVM. Any suggestions to handle/fix this case/issue and avoid the 
slowness of booting of NestedVM with more cores?

Note: Guest-Hypervisor and NestedVM are using default kernel installed 
using Fedora 36 iso.

> 
> [1] https://www.spinics.net/lists/kvm/msg265656.html
> 
> D Scott Phillips (1):
>    KVM: arm64: nv: only emulate timers that have not yet fired
> 
> Ganapatrao Kulkarni (2):
>    KVM: arm64: nv: Emulate ISTATUS when emulated timers are fired.
>    KVM: arm64: nv: Avoid block mapping if max_map_size is smaller than
>      block size.
> 
>   arch/arm64/kvm/arch_timer.c | 8 +++++++-
>   arch/arm64/kvm/mmu.c        | 2 +-
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 

Thanks,
Ganapat

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE845F281
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhKZQ5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:57:01 -0500
Received: from mail-co1nam11on2125.outbound.protection.outlook.com ([40.107.220.125]:50401
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235015AbhKZQzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 11:55:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKDoYe2sQbVNE8keD/0EhSNmCb+PtDbrKIClye13ohTnzZqIBmNNYl7PVLJYmjD066Ca2R9WSHh+iuLhuFHBQUCL4UOKdvKH2B9TJEwOqeZMBrFrgcmBPXtLwSmWMO7iRXX8lpp8h0o5LnHm/52nEEeG76WbWFo+6Qyu5PA97LmE1kjFTU+ol0a94TqlSGeU+9VKqvDAk8Ooul5jCRgpalrNf07QfJn5hh6QJZTYHkHnxMqgiXmQFj3F/qlYv45t2xQmCTbULdjiLRL5fLEyz3FNlx9nZbZfZdEieqalq7TPZU90/LWqPOHACRdhsOkPygeTesjSm2uhNXs7PSN/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV5tN6AUfcx7qy7UluC2Z5zXYVtzihGr6T4lqYhw5Ew=;
 b=W3ofCDc1IyPYdmJ84YqpIZv4viCqArSXyWp2Mqrgw/IxnYSCFJFLsJrNDmIJ7TKxUgLH84piRAVK3X0gIOJqNVWUR1qheZOQD//nnXJTDfqpxGkYz0m+xiU/utOQJe7K7end9desrPDUcKFCmbBwtZY7+GgEFevmr+AwvzSw7QkhSqQNcqAtYUh1oaugPdw6uDo6ANUDbtSBw5ybLUneYCoTAMbXxub6fLjBwxzyUPZIvCqYDIhKlnlDUAnqiAzuGctFBD91yAAQjzz5JbV8NCk3CRe7XdE8MXtN7yj8bxu5wf5qOaEI9Vb5H1eoBRX6dE495rrsNaKyPXO9oKEsWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV5tN6AUfcx7qy7UluC2Z5zXYVtzihGr6T4lqYhw5Ew=;
 b=Ve8XDJHV9r/HUedIq/PQfUGSiXwK05kH5Q6d4SYyL80StzyqXqM5JMoUoAK4ZcMSxqvINoVSyWoDHHdimOUeKHWT+LP/G+U44TsVP6jfDN2u9Wop8RAuM5cOm1dMHnbF1gmALkmuY41nmPH/NB8rozMvKIAJNbQGeUY+ekoNGZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4010.prod.exchangelabs.com (2603:10b6:5:1d::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Fri, 26 Nov 2021 16:51:40 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 16:51:39 +0000
Message-ID: <73ca09b8-189a-eea7-15d7-b17a8d07cb60@os.amperecomputing.com>
Date:   Fri, 26 Nov 2021 22:21:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] KVM: arm64: Use appropriate mmu pointer in stage2
 page table init.
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        Quentin Perret <qperret@google.com>,
        D Scott Phillips <scott@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
 <20211122095803.28943-2-gankulkarni@os.amperecomputing.com>
 <87bl28cpko.wl-maz@kernel.org>
 <84b7602f-93c1-74e3-bebf-23ed9e795b9b@os.amperecomputing.com>
 <875ysfchrg.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <875ysfchrg.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5P221CA0104.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:9::32) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from [192.168.1.22] (122.177.58.155) by CY5P221CA0104.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Fri, 26 Nov 2021 16:51:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35e52057-4fc1-46dc-d788-08d9b0fd03c9
X-MS-TrafficTypeDiagnostic: DM6PR01MB4010:
X-Microsoft-Antispam-PRVS: <DM6PR01MB4010045DBC0A7E37B2A90A619C639@DM6PR01MB4010.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hA4HP69AykZxlVXRYfWbZUlIIdVILNpUlR7+GdYS5h+5Q828zrbuoA8dC1SZQ9QzJESeWjyNOEBbDmkiTQUySjKbt3mc+GDeNS1weRv63YSirhEjuPqoIQK3Ww8nPguwE7hEjDfLMKfVAdzGIgMPBEHDqVzwTiXKs1amyY7QCl/kYoK/lMLabDFws+sgV8d8c5vbl1dw1z4l/2rsY5UwvEiLmSlTy6iGbRTSqPnDQXDLPbmjEtc71FGrSlTlwFnZgCDdgY+guiNemHTKatLxQV6r2IfBT0O7VEHg+3IDD5adwHZkf5l20nAYE8RZIl/s31gLs5X9phto89DecGZjV/9lczXPH1FRZOk50E4Di7qhnnPf1B0e1r6mYKfLQYcCiAFcOZXZp/Qu+YQfNcNKEdULqob0FHBQVfjyxeR5zkJCOnUwl4JKUlFJDrpr6pjgTJheweoKlyizkK4OnPqRtWpKLUfnnqeUI59fK83MpIPMY01WP64B/JHPwpojFQMvOMBKh/T6mIyTVnjWBad2krHqx16Glg617BYx41ha7QEaYeo6UpTBVK/sv2fWEvY+nYkxwrvzjRbvdq8rarItPqzIfF2edv+9p2fKM8EcmSt55eWtBIlGAfMVIYa7Lblkx49Bl+cj2t38hoPkBx2ef/Da33CaKqSnD4+Po6GWPbVwiHgfXBdotqAuOLRhx4dueJouZginYFPBlRalEA5AC/y0qHdEuQf71nOXdbaGaqrX0o+KzoGkFOBAqaT8aRQebwengiH8YiqjWUVNvC/Xs0ZrtcRyV7W+8r9vcIpEU6QmExG9z/B2rIFyYtsHuixCP3IDq/LDBBxdhq8ZcH0i5yC4T9RjWAwIZmWAq1cqPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55236004)(52116002)(26005)(53546011)(54906003)(38350700002)(16576012)(107886003)(31686004)(2906002)(956004)(6916009)(508600001)(2616005)(6486002)(66476007)(966005)(186003)(5660300002)(86362001)(6666004)(8676002)(316002)(83380400001)(38100700002)(66556008)(8936002)(4326008)(66946007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qkg5R2lEa1UzbDJQQ0JxT2N5WncrZHlZd1djbnhNYmRtcVBSeXBzbFhla1Ay?=
 =?utf-8?B?TzgyTFRmY2xuOEM2V3l5YUtTNU9lN3QwbGJDOHBEMENMVENQek9Od2xEODJL?=
 =?utf-8?B?a3JIK0lEMDNEZXFEMjdnZTNNYyt4N1VQb1N3VzhUQ3RkWVU5b25Vd3RDaGZV?=
 =?utf-8?B?WVdDTHFpd1U1djFyZEJtM0dvS3hVTDZ1Zk5renVNSnFvRUd0OS9UVllwQzc5?=
 =?utf-8?B?RGE2ZVh0UDNDR3JwQnQ1KzZBUmdJeXkyVnFObE9Mbk9OVHpNaTkwVmJzM2dF?=
 =?utf-8?B?Qit2aVJNV0hqN0svNndCWElub1Z4SUVtRDRQdnFZT0JpVnVsQVJlQXdPam90?=
 =?utf-8?B?R2t4ZGVITEhTWldZVDNZb2NqaGFTM0ZLTEo1MDBXb1FBekpud1Btdy9IZzIw?=
 =?utf-8?B?eGQwV2JEWCttUXlQMGNpa2pyK1hrSE1QRnVqSmJ0L0ljTWlPKzNXNnFpMUN6?=
 =?utf-8?B?WXhwUTdTV1Mzb3p0NDBPalEySjVldWRDVnpiYUw3TDBFM25mMmJkR2F4ekZX?=
 =?utf-8?B?eno2R1ovQzNzU01hNkFjb1Z6dXRLYVhubmpyeFNTWlMxeXBMZFp0NzRuTXpX?=
 =?utf-8?B?R0JWUTVGV3hNMHZuaTBtQXFaRVVzbDlsMzJ4a2VudnBFalYwOG9qeVFibSs2?=
 =?utf-8?B?b1p3Vm1oYlM0clBsdmc2ZXgzL28rSkd1a1hKeUppT1grM1h2bjdxMld3MTBi?=
 =?utf-8?B?T0xXREppaXVhWmVoZUpJMExsWXZxZXZVdXAwRUlYSTdaYVJWVVMzQVNzMnA1?=
 =?utf-8?B?NE9mbVY0MFg0STdCV1dxbTNvNGhxSWYzY0pDNzlHVEk4OXEyK3dMaWVEREl4?=
 =?utf-8?B?VVJBaFNiNlVrRUQ1clkwU1ZyY01VTS9qYkh2dmxKSU9QT1FsWEo4QmRuTFlR?=
 =?utf-8?B?aUsxR1pxYTZwcGpxNXpNL3lQa2M5amNBbEEvZHFIMjFwemxoWkJXOTJ1a2Zx?=
 =?utf-8?B?RHJCS3pWbDE2Y1QzRlhmQTZkNUNVKzlDUGVYNGdXamJNNU9IWlZ3YkcxdkZX?=
 =?utf-8?B?MDNjVi9oclpVSlZzUTBka0hqUVlHNDhuejdtYkV1ak1FVDQwQ1plTFVpenk4?=
 =?utf-8?B?d01MRmNhcUJpWXNoL2plZVJNeURxUlYrNWZOVHBXVVUwamtURVdvc3ExVVNV?=
 =?utf-8?B?U211TXd2TEtybVllUHN6Ynd0S1pPVnM3cmtUckcrZzZ5dXQzb21DMVpGR3ps?=
 =?utf-8?B?emo0L0VldE1zV0toWWhCTVdqNitzTVE4bzZuaUd3bnhyU0YrWkxybFo4NDhM?=
 =?utf-8?B?NVJKMTRLd1BLQ0NKMXlKbFNjTC80WkdzWlF4QzI2cTlXbVp4UWZiVlBja2lE?=
 =?utf-8?B?am82Qkp4WmNwQXRPTmZXZXJySzNJOTlyZFdxZExRcW11YmdNMCt3YjJPQVN6?=
 =?utf-8?B?ejMwNHRrUUFuTFl4b1lwS1IvYnNIMlA2L3RmVkZHU3FMNzZ3WnJFSkRQSlBx?=
 =?utf-8?B?czE0NWdvMitTZC9yTitHUG5JUW5LeXBVSzFYa0hjTWRlaVVTUDdQck9YUGVZ?=
 =?utf-8?B?UjVoN295cUpxUWFiVmZqYU9DQUpwRCt4bDhQRlZ4OHRxS3hQUzZBUmlBazh5?=
 =?utf-8?B?VXo4QkVROXBVK1hFSjNKa0YwdTh4ZkdXRkFnUVZvS29pZlh6aXJPcEhhMysz?=
 =?utf-8?B?NnNNOHBlSFIzMzdYVEt1OFZQcDB2dzF3ZnJOR0xaS3NacitQWHErTXI5QzIw?=
 =?utf-8?B?WDBTRTM4MFV2amZPM3hCWkpjV0s0L29nN1RjRHhldHhrUjBXdDNQVkxyNi94?=
 =?utf-8?B?THpjREZ0UnhrZmlHTjQ0Tk40MEZPNEpuSUszWFVrSWRwMFQ5bjNIbGhVUDMx?=
 =?utf-8?B?R0FMRmNNZ0twZExrb05FMVBYRVh4dUcydGsxdDdjREpQazdzaWdXMWNvMmdh?=
 =?utf-8?B?clMvY01BOHliY1BsVGZ4Z1RFOU1QcTJpZUd4TllrbG9oam5TbHp0am1JczRU?=
 =?utf-8?B?bGpYZDZ3alNIeWdycnhQVXd2UnhGMjRlVkx2UWtXa25OV045aXlaMWZaVk5U?=
 =?utf-8?B?UVEzVVVkdmh3a0VBTzV0eHdNc2tLSmg4Qkdnci93UXdMditqeDhRYkY2cUJN?=
 =?utf-8?B?TUNuVVRWVnAzQzROMlJNU1pJTnRhMWdpa2ltTUsxWjQvc0ZXZysxZ2xJQysz?=
 =?utf-8?B?M0x1RUQ3c1NkUFlZcDkyTWYrQnFNRm1SMmZVM09wWW5WekMzbnhuVVR2cXdR?=
 =?utf-8?B?eFBqa2FpS210ODN6UmpXamt3NXBtUERNcUxJbFVTck9zNVUwYTBZMzc2cG14?=
 =?utf-8?B?b0NtTVA0dkc2YWQ5ODQ0Tm5VU2xUQ0tqNEZtNkhOK3JXLy9SOFA1NzVueS9O?=
 =?utf-8?B?UlFYV05ya1lobW43NVFvWUc3M2cvZHRZbEVxMzdmQTdXOW00dVovUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e52057-4fc1-46dc-d788-08d9b0fd03c9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 16:51:38.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJJLYEvrzO0XdTq4FlD3Rvxlvk0VKXMzk0sUvsPWIkrc4IeglDLFCay7B5nsgmf4lzuLaNH4qqe7j2i+zYKsfmxYsHTlO6v0E005QBZVlXOtfhggjV0jXTrqjZV2AZz6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26-11-2021 04:20 pm, Marc Zyngier wrote:
> Hi Ganapatro,
> 
> On Fri, 26 Nov 2021 05:45:26 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> Hi Marc,
>>
>>
>> On 25-11-2021 07:19 pm, Marc Zyngier wrote:
>>> [+ Quentin]
>>>
>>> Hi Ganapatro,
>>>
>>> On Mon, 22 Nov 2021 09:58:02 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> The kvm_pgtable_stage2_init/kvm_pgtable_stage2_init_flags function
>>>> assume arch->mmu is same across all stage 2 mmu and initializes
>>>> the pgt(page table) using arch->mmu.
>>>> Using armc->mmu is not appropriate when nested virtualization is enabled
>>>> since there are multiple stage 2 mmu tables are initialized to manage
>>>> Guest-Hypervisor as well as Nested VM for the same vCPU.
>>>>
>>>> Add a mmu argument to kvm_pgtable_stage2_init that can be used during
>>>> initialization. This patch is a preparatory patch for the
>>>> nested virtualization series and no functional changes.
>>>
>>> Thanks for having had a look, and for the analysis. This is obviously
>>> a result of a hasty conversion to the 'new' page table code, and a
>>> total oversight on my part.
>>>
>>> I'm however not particularly thrilled with the approach you have taken
>>> though, as carrying both the kvm->arch pointer *and* the mmu pointer
>>> seems totally redundant (the mmu structure already has a backpointer
>>> to kvm->arch or its pkvm equivalent). All we need is to rework the
>>> initialisation for this pointer to be correct at the point of where we
>>> follow it first.
>>>
>>> I've pushed out my own version of this[1]. Please have a look.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-5.16-WIP&id=21790a24d88c3ed37989533709dad3d40905f5c3
>>>
>>
>> Thanks for the rework and rebasing to 5.16.
>>
>> I went through the patch, the gist of the patch seems to me same.
>> Please free feel to add,
>> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> 
> Thanks!
> 
>> Looks like kvm-arm64/nv-5.16-WIP branch is broken for NV.
>> I tried booting Guest hypervisor using lkvm and the vcpu init from
>> lkvm is failing(Fatal: Unable to initialise vcpu). Did not dig/debug
>> more in to the issue yet.
> 
> I'm still trying to iron a few issues, but you should be able to boot
> a NV guest. However, the way it is enabled has changed: you need to
> pass 'kvm-arm.mode=nested' to the command line instead of the previous
> 'kvm-arm.nested=1' which I have got rid of. That could well be the
> issue.
> 
> With the current state of the tree (I just pushed another fix), you
> should be able to boot a L1 guest hypervisor and a L2 guest. I'm
> getting a crash at the point where the L2 guest reaches userspace
> though, so something is broken in the PSTATE or ERET tracking, I'd
> expect.

Thanks Marc.
It is booting now, i could boot L1/Guest-Hypervisor and L2(NestedVM) as 
well.
> 
> 	M.
> 

Thanks,
Ganapat

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13512F3D7D
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437973AbhALVhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:37:02 -0500
Received: from mail-dm6nam08on2060.outbound.protection.outlook.com ([40.107.102.60]:61152
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437110AbhALVGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:06:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWzRAHgGurk6Ne8KZwnN8xRssdq1NE9QtcKXdCEtGm+K4CIR4nAdhstNRzoKQZ3QLxtpY9ByayRJQdah4TqNbHpGycsnOFLS6GZ1hCyzQkZidC7oT1df2RgAf1S5deM2ttYvl+pvLsU2vjd4Y+Dh4rqliQreP42ZDCjGAYSd8ePdKF1pfN6FrzhaRxNjlbNJM/CaTMd1SyyX4q5sRQxc0SuCJjWHrsYQzUl5CMjZ9G714IZtpFicysi/wLn45WjGuqYDuhlua6vlWcEK1tWRKwTWj9Qhy6VyPDXkbkVa2kn/9sLimyyvDkZHh6MCmHZ94/idBpDCHJAvgQCEm9Bclg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIfbZYrRA0KxFrf+/H5Bc+F8qZlMtkUEu623dE2wfSo=;
 b=MuFdkg5yB5SHfgIKFnhOiNHoL6XJJqyEnd6FMaSz6ZKrNaIqevDWAy8fp5DT3MvOIi8u+PW1KfS9sENvxn2YGmRz48wZfbgez167mCRjwWWfdSOJYBlV4wyroFWcemqOCDXasN3OwpSLdB+8VZXr3KCrXuSm2PLKAL4FJZsZcQaBfJW+vJK5kyKsDePU1CvCtdg9hC5bF3Uu9GsBeD0Ty26hu0jYRlD3ybzxmY3vDeypiYd9GkswCnX8eWd5tq6cm4A/UGUkTBLYcYMwT+VPa5OXXxlX8GCJkV4n36M8UcF6yoUnDPGQG0bKSCYnTMM1wXJsRumSiZrFyJeOAXKZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIfbZYrRA0KxFrf+/H5Bc+F8qZlMtkUEu623dE2wfSo=;
 b=0Kv49vnTFEhsnVWeCu92Hme1P1zGUaVVLLHuvsoqKI0azYPOrUjiKKV4jJiIJi+Vc+HwA+/h6Ub3HIB368+i+GeByF11i9ci3mPmBgEIpxFbQO6fq0wnZntsUWrQA0KY1J1OsZ33KPIOGHP0W3auFvoFQ3qL57g5aI2apO++azc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MWHPR1201MB0208.namprd12.prod.outlook.com (2603:10b6:301:56::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 21:05:47 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 21:05:47 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <f95acfbbff46109092881874c8c78edcf58a72e8.camel@redhat.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <d6c3f238-9f63-fc80-1866-bbb685ce044a@amd.com>
Date:   Tue, 12 Jan 2021 15:05:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <f95acfbbff46109092881874c8c78edcf58a72e8.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48)
 To MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (70.113.46.183) by SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 21:05:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 509cdcf6-a508-44e2-4251-08d8b73dd597
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0208:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0208EE2115923599E32DDD6ACFAA0@MWHPR1201MB0208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbAB669CubYk32YvxbXUF0lrlF3zd/p/2uuiG8DvbdlpftsHg6tpVGW2qsokGrxSE0lbKG7+k3IVWA3J4Sa8ATAeVjx6Kfz08TeNahCT8vX4cjp5mpE+48P24kbW4/VsSeiKPAYNcQgaA2K1SxltUN+hy+v8z465UK2DDANdZXfXQ+Nhzafhl1cgse/78Ei44GKnhAtJSB/KffUjfC27JpkVBsOkKvA/binF8eoT6zr/d9afj91dmJxPVNMr1MiKeLZVeH1BUie2gCPfMCnurIgeizipTBhmxYMjJJBff1SYhfeJgxMTQp4dcvE0dHK4FncBfRZkNRZNLtLbVyK4RCKgvJ5HCu7sJpBXgsN285qLpK6iDts4ixrQvVlashJtiab0qhvrjmkMqyZD77u3NkzIrtUJPVaeRQnl8fAdni+hg0N1JTT4PL8vv5QS8waA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(376002)(136003)(366004)(16526019)(6486002)(478600001)(53546011)(16576012)(66556008)(26005)(66946007)(2906002)(31696002)(186003)(6666004)(52116002)(8676002)(31686004)(8936002)(316002)(7416002)(956004)(5660300002)(66476007)(2616005)(36756003)(4326008)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YjVSWlRWQ3o1VkF4NVY2elU0ZkNDS21xTHpmbDNrWG1ZTDJibkZmTlJpZXVu?=
 =?utf-8?B?M1BNU1NnYi9tTFFpbFNZa0tWM1doSGk3REdWZjZFYTQxa0RwNDd6YklQcFlC?=
 =?utf-8?B?WFdvS3lPcU9EZXRmZUlFZUJVSDNDcnE5V0REVDlNM1RoTHVWalpTaXA5NHN2?=
 =?utf-8?B?STJuQmpRelRBUHBtQlM4YXRVd00xWmwwZjB0cmN3V0pjUHVLL2NpTUF1T3h1?=
 =?utf-8?B?R2ZMdjBPcTUwSmt6NzJIVWFzemdtbkZPZThlZkJremptRk9EcGNRUEJEdmlE?=
 =?utf-8?B?b29NVExzRnVJbVlRVTBVdnVaWURKdEtkdEc3VmJRK0NuNkFUajJseGoxblJZ?=
 =?utf-8?B?dUxoQ3JNMnhJbERBT1FUc2ZCYTg0MTI0R05FZ3JWcFdHSVcxQ2NvTmlBRXFH?=
 =?utf-8?B?b2xJWjYweFhPQXFhdFF6ZmxlcU5EUGcyS0pSd1ZYRTJlbXYxZHlSK2IyRXhY?=
 =?utf-8?B?WStIT2dkbHVneGxZOWgvTU43ZGV1WGhsbldKVjVKaVNQZ3dTSFRHRm0vSytE?=
 =?utf-8?B?OHhLNXlZZ2lHSGErcmdnWmJqakpPL0lENDFmRDBtVmxOeFZ5V2d5S1RsSmUy?=
 =?utf-8?B?bU4yY0ZuMWdQa3VqVXRTSmZhYnFmQnAwTEZPbTBnbm9ZTVBodE9oWnhQR2g0?=
 =?utf-8?B?Mis2VFRxcUhtNVlTcWdJdm8xRVYycUpYUjNOK3ErV09FMmtCSjIrdUtoTUZ1?=
 =?utf-8?B?c3BGOW5rQjZRNHpGUkNZbjNqR1lYYi9LQU1JQjVMVS9yOXFaOFNGUDVVOCtN?=
 =?utf-8?B?V1Zpb3lidUNURkE3VUJuR2lEWkZINitFVTdOUHlmTzdQWjlyZ2xVZFZ1REhB?=
 =?utf-8?B?cytEeXlTNkUyc2xOYk05ajRFNjJrTmZyVm1mTHV6KzBOeVpqVDF1azdhRGcv?=
 =?utf-8?B?NXduRU15QnBxeHFTOUFSMXd2Ri9nNkt5TGd4d1pFL2xEd2ZJRHR3UDJ3dkZB?=
 =?utf-8?B?U0hVMzZkNFlnekxIbzJZR2ZhVnZRdElVWVlSMmQ4UVNma3lRWWdEYXpIUW9J?=
 =?utf-8?B?aENqbXZrdkJVeUwvcktVQXRqSXlXOUJjTlRPU3FJRm1TOWRpQjV4Z2NUODQw?=
 =?utf-8?B?VllCbm5oOVF6WHIrTEpNeUpYVzRYL0ZrWlBvTVpGRGp6SFpUdXpHNFlaY1NM?=
 =?utf-8?B?ZzNzMmtsMEVCTlRvTXJoOVJSZHlJZE9WRmhSL0ZJak43cDNvaFhkU0RBRkZp?=
 =?utf-8?B?OXNCbDhzd2h0bWdnaGRiQWN4bGpPMG43Ym5FUEJDTzVtK3U3Qk5uSlA5K3cw?=
 =?utf-8?B?ejdZSS9sTUNRQUE2UlJVR2F0Z0RPaWRhNnlPaGI3ZkMrOTVTSGpSYi9ZcFlh?=
 =?utf-8?Q?qg0nIwUJJZpQp9YeJHedmYq7JxfnQKcXZq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 21:05:47.6023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 509cdcf6-a508-44e2-4251-08d8b73dd597
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqvG866VGa/FeWsgOsNKsU6dJSmg5PAv3TM/cFIqnBHmaFaXWTQFj3y592iK22f7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 5:09 AM, Maxim Levitsky wrote:
> On Tue, 2021-01-12 at 00:37 -0600, Wei Huang wrote:
>> From: Bandan Das <bsd@redhat.com>
>>
>> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>> before checking VMCB's instruction intercept. If EAX falls into such
>> memory areas, #GP is triggered before VMEXIT. This causes problem under
>> nested virtualization. To solve this problem, KVM needs to trap #GP and
>> check the instructions triggering #GP. For VM execution instructions,
>> KVM emulates these instructions; otherwise it re-injects #GP back to
>> guest VMs.
>>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> 
> This is the ultimate fix for this bug that I had in mind,
> but I didn't dare to develop it, thinking it won't be accepted
> due to the added complexity.
> 
>  From a cursory look this look all right, and I will review
> and test this either today or tomorrow.

My tests mainly relied on the kvm-unit-test you developed (thanks BTW), 
on machines w/ and w/o CPUID_0x8000000A_EDX[28]=1. Both cases passed.

>

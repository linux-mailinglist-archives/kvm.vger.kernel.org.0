Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3A947B55A
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 22:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhLTVr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 16:47:28 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:35969
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229618AbhLTVr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 16:47:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8Kc56pTxBW7FjaKL0OPIER/LLVgZNAsvlFau3P+vgFe6LkTTxF1M8P1llIOFNjIo7w0j2L+dyb28SliEhVgQ4biwYdrvUloP1RyxFsMcq3uMNS9jVmkUbvn8hRhovFMvRS5Jq4N8U2AfIma5s+9V5hn9lzxGZMWzl1L7tZ0oyNmkwQz3OYX6UbJF3nox50om716j9tyd7Mu4pL+GZNOKdkiwrqzIKkOb13qCCwb22u8f5gj7CgWG91xPNW3vwi6+enFrvVjbfs6UnuZRRCs+r9B7jWF/bjwD8Kj7L+UxOReZeiIdnWF2gSMFf8W+Qi37kKoBzY8uTpOf0Wn+oXXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4X0AmDQLIB7Cwber1PRmFnAEO8IB6AA7evXRXeOsIzE=;
 b=QjpPbGH5xOol7mZxgBHhb1Fd2H0/Ra4omBqXY/+kw4oI8DesgWe9hv3pOjpzf9beqVEJs6RYwVLRNEHnZH3hw3avGJo6J27d3wUbuIfmGehVACBhNpTP6gdfPuE2f8Q5a7u7VIQWsr6UwHU52FK7hOumphoTGQ6uLnQEG/MX/wzcvgahWHp6Mto5MBmc/1YfIVj/kKNKWgKGMtku2+iGF+CRG6y1ATRVxNTUvj+JRmWdgF5UIK4dIWblt95cjWxnwvjifgEajF75d4mcR8MhiGX9nKHRu7WYcdYk1gopWnO3+4QuWBnjsYgUgD6O96I3hawHtePgfzBlzEiChzhKEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X0AmDQLIB7Cwber1PRmFnAEO8IB6AA7evXRXeOsIzE=;
 b=2w7Vgpbv2u+QmZp6A81Mt/yj0yUI0rgOIJO31m1o+gcrgIFyg1Pp3uCqbdiMlmb7YtFcklOusJymUbvGY8dxIdQoCx/g8tYmsXMhnDb2PNaSFURIMp9nJ0W6ZWVUe4WkzDFv1A6XuaBaD7dclgr4vIk47NA7u+4nIq5HbnsrdR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5463.namprd12.prod.outlook.com (2603:10b6:8:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 21:47:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 21:47:24 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <20211217110906.5c38fe7b@redhat.com>
 <d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org>
 <36cc857b-7331-8305-ee25-55f6ba733ca6@amd.com>
 <c1726334d337de7d7a8361be27218b44784887f6.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <02be2ef0-8a18-553f-2bd7-1754c3f53477@amd.com>
Date:   Mon, 20 Dec 2021 15:47:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <c1726334d337de7d7a8361be27218b44784887f6.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:610:e4::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43bbea13-f5c8-43fd-e999-08d9c4024eba
X-MS-TrafficTypeDiagnostic: DM8PR12MB5463:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB546304FED6DC4B057BD59833EC7B9@DM8PR12MB5463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVT2gAlzU8MAjuD8NX7U5Mq22wcTomPi2LvShvMsn+6jUxCq6sL17qeM4I7C7EEmHYrfdyAv86+RqeJYPuysD9KIJ4eigsMVUHBomiL5mBd25nbufGlx+Z+71pqjQCMa1YJX1ULzcNswMDZumjvboPHRUAlI56xJw7i5JjOU5O8YHIys6l4xZ+GCyyGl3tepm5qyRZgP5VQxpFV5hnLDzw7EflPPPLKNZSCoUxbarz+qxabkA+mpmDPpWpN2ZL2juLL++18iYjslFIy1NntWpLzzMn/YOL1AOfZcLqRIPCbKnp+HWawjf5KM1L9RNSHqM8Q1+S4YK7KjPX+7+sWJk+X6aY1KiFGx9G3uzGprcZa1fyYRuovP19T/v4jt51Ifk9d/GRb42QgqwqiZyycVyO0CYkRjNhDtOrJdGp2oq8jxL8nZPMY+74oCx09pGZnSHcIzj4Bkzv4KkdRVSA4ZLXbTCit+InuhYldGvUshpgpUMjgnNwGwBi1r+O6VGBqRh+Yp62nEOyfWqeJU2uN7OsigEzlgPHwYz1DBRDtYV298D4dKc9098X//gNv5loWcQPIQLvr1xfjkZjPeMnLf97Nk/r8OwO7YbigdT5a7On0K2z3D2+tnAFj0+3oxiFL1c4G05ISyvPrrnqMOYf0DbQG/5ERVRCq+7o+B+UVYhqx3AFx0Q6jEODNRXxNrVJMLcU6NLNCQdoH1ABI+tWpPCRMuRcePShjFdFkn8OPM64IO7JeZGJtUdHN1UmEfHGPL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(53546011)(6486002)(186003)(110136005)(7416002)(4001150100001)(36756003)(31686004)(508600001)(5660300002)(66946007)(6666004)(66476007)(86362001)(26005)(38100700002)(31696002)(83380400001)(6512007)(2616005)(8936002)(6506007)(316002)(4744005)(4326008)(66556008)(8676002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHpMMnI0OGZHREhJM3pUUjk3NWcyZ09UTjFyem93MCtXV3NwbGNOWW0rbm9F?=
 =?utf-8?B?YjRwcEdlQ3l2dStaQnRhYlNLZGZPSUJERGZrZzZDRmwvZVdaZXpPQkphUTly?=
 =?utf-8?B?T1FFWjJ3Z2RNVUdnd29Fc0R1VUpvZGlsR1ZhdmpxNDRMZTFpcy9sTG96VlZC?=
 =?utf-8?B?UzZVNFo5ZmRsTnpKYWZ3NjJOODlmU3FKbTdxZzZkNk9ML1JScFZxcVJHdk5F?=
 =?utf-8?B?Nk1yVWpWUmlzRWdqeFM4bFV1SlYxL0RGTEhTZ0xCbTFGcWx1ckgvc3U1eUxO?=
 =?utf-8?B?Y2x1ek9wVUF1QVE4QWs1NW1tRXgzTmZhaVA3YWJndE5mcWNQVzVLT0dXeUIy?=
 =?utf-8?B?a3NJb1V6RmZ3ZWFQTkJXNjZoK1k3NTlNOHIwNW55Z3NMbU5oTVJxQVhaOEFG?=
 =?utf-8?B?N1dUOGpJREE2WG5VcStIaThYNXBWeS92NXRRQ2ZpdXRmeU1Qc0RHVFhyUDZS?=
 =?utf-8?B?SDl1bDlTa09zOXFwYW1TNjVFYjYyU1pXa1hrZVM2dGllRjhDMUFadWMwN3FQ?=
 =?utf-8?B?ZVNGa3RBRVlUVzlDa1ZOUUlUN3ZiVUYxR3FGZzAzNUFYQjlCR1hvMTUvdlBo?=
 =?utf-8?B?NTlPaEoyREZrSVh5VDdRQ3UxMXFNMWlPWC9ZQ0ZDV0VNZU14bkhla0J6TGZK?=
 =?utf-8?B?aGlvU2tGaitta05ZVXovN3J5d2ozTHhabUdxMGl2WThlbktISHZwbGVaRjR2?=
 =?utf-8?B?MVdDbmpyQUxtdjhjOThVVnRpdDF4R2hCK3JDdWFVOWZvVXZNUzltVWsxYTBT?=
 =?utf-8?B?allrREZwVWtYeGxQbTdpTmRZUmhzTHFFZEVzRmdKcWJBaFAzTWIxY05mUVlV?=
 =?utf-8?B?L0M3M3M5L0pVYUh6dTdkNHNuZGpMQ0Z0ZHIvMmQ3dnhQL0oyTGdKOG5palNX?=
 =?utf-8?B?bCs4ZUtwalFGMVplaklKa3MrdEpOcjlISTRMbDdGTzN6OVZnRWxZUG5UOTkw?=
 =?utf-8?B?OHhFTTRCcXcxQThMcnk3bnBHMDFaZmZubi95NmhZeDJzb1pEcEZwQm5icGlm?=
 =?utf-8?B?VkJRUnRlbW1lTTVCQW8vUVZlRzVjQU1PQ1lWRm52eEx5SktjTXVoazQvemFo?=
 =?utf-8?B?dlk4VnluOEpBVmlyczlDZ25RNG5NK2FsUTJHeTBVZk4xMnhua21PYXJ4Wklp?=
 =?utf-8?B?Y2syTlc1Tkc2cG53QnFVSndweGQwa3pHYzVITHBsRWtBczNoTExJdHA3NEQz?=
 =?utf-8?B?NUxXVGVETG42UC81UDczNHZDYm5YKytJVDZYdUtTM05LTzZTQldiK1RHVXdS?=
 =?utf-8?B?MmlSdG1hUXJicTlGdzUrREhiZ0hnaWJOV2hFbnVWd0hreHlzaFEzSFkrOTl5?=
 =?utf-8?B?clhjSVRVZGpnS2IyWEdpaEs2UXZpdE1IWlpNY3BkcXR0a2xoQTFkUUppWTcw?=
 =?utf-8?B?T0FjbDJ3cWN3SWtrUloydXg3KzhwaFRaYTdXamQ5K24zMkJCQVYvcE93WkhI?=
 =?utf-8?B?TFY2Y0pzZVlNSjBKREw0NTJHMGR5d2VvYXE2d25nZVBaTWkvWE5DNmFVZ0ZP?=
 =?utf-8?B?dlN4YTAyMDgxUWZHM292MEE5S3Ird0l1Nm9Ed2tQaWhUOTZJQVNLZk11eDJI?=
 =?utf-8?B?NTcwTktSOWtoc0pwOUNIZ2tZcWtYK1dsUGpUbkdTa3VrM3ZZK2ZwREkzRjc0?=
 =?utf-8?B?NHpzcm9yRytUTVJmTGlWQmljSnlXZGN5TzN3NTJGWEg4eEpUeFd5M1VUQ2dI?=
 =?utf-8?B?MGl2QldDamJvNDV3Z2hEY0xzRHRNTFZnK01xOFdYci92a0VMSkVZeFVQbDcy?=
 =?utf-8?B?bm9sQ0hrNXRrRjRvZXZ5dUVBaUhBc1ozM1ZaSVBBTFRqd2hDTmxHZjJWZzF4?=
 =?utf-8?B?SC9Fd3JNUnk3RmFFOWRCdFVxTGlTcXl6Ym9CN0puMHRUbWZXMDNockNwaFA2?=
 =?utf-8?B?YUJKSkV4ZG5xVm9uZEZmMjQxaUxBM3BUY29pMHlrdElFYllmL2xrU2taYjI0?=
 =?utf-8?B?a3pjZFhoclB4WUk2VnlsWkZYNms1RytCaVlqWlFBN0VnaXprZHEwYU90dk1P?=
 =?utf-8?B?ZDhYKzVJUHNVL1NNQ2pja2dCbS83OHFna3pHMUVJKzVzVWVNcVhqRStEdFRF?=
 =?utf-8?B?T1R0L1g0cWNlaHVtdFdsMk12dm5MY3pXZWJ4UlY4NXRFSjhGTlFIQ0tOOTh6?=
 =?utf-8?B?Z1NFWmIxWHNPaVprQllQZjlvSjd5NUdIQkYyOVZiajF1Q1dWcWQyQmROQ1VU?=
 =?utf-8?Q?Ta4zh4QqlIPjPTxMfQHKUjI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bbea13-f5c8-43fd-e999-08d9c4024eba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 21:47:24.4161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqRIoo+J843ufEfPMny9mvuD9Wa+CMGWJUJEVZB6lIGJy5xU7LEf8zEhfOvsupSvYYR9TezcOlw99Yuq1RaECg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5463
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 3:29 PM, David Woodhouse wrote:
> On Mon, 2021-12-20 at 12:54 -0600, Tom Lendacky wrote:
>> Took the tree back to commit df9726cb7178 and then applied this change.
>> I'm unable to trigger any kind of failure with this change.
> 
> Hm... I fired up an EC2 m6a.48xlarge instance (192 CPUs) to play with.
> 
> I can reproduce your triple-fault on SMP bringup, but only with kexec.
> And I basically can't get *anything* to kexec without that triple-
> fault. Not a clean 5.16-rc2, not the Fedora stock 5.14.10 kernel.
> 
> If I *boot* instead of kexec, I have not yet seen the problem at all.
> This is using Legacy BIOS not UEFI.

Let me try with a legacy BIOS and see if I can repro. Might not be until 
tomorrow, though, since I had to let someone borrow the machine.

Thanks,
Tom

> 
> 

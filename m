Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DEB166A7A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 23:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgBTWn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 17:43:29 -0500
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:26017
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727845AbgBTWn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 17:43:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1MFYRSjuiK/uAsmFbPRgvz8HUBTRgtpUOpB9SHigemsrl84jPshqUTvX1tkZeBS33HvVW71QiLq6hgWv9G5gRShzMFLZpUHpr6mgpEtjMdzg9Z85ZxA+HQsbH9jSxyvPAURGmCGWUGXIJSytICJADKmxSfwvkwDjyu4udf5PqBoKodOD3zk8+SvTUQHshILN4/OPuGJyh7WsObqrD1BEi/l2zY0LXX1vD1cdwHYIQ/EWkxaRr7e0BcaJLfdmSqAE0PtTm7xqYzz8ilGtrTf9cwlusIsPjm20bmavi3XxZdWnP+VJvkZEexir0JdeMMfRB0UH3V8+DfEr1M42/w3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noE/f7Aw1yupon/2r4/lcqnbXq2dMkhqmS9AoHss8qc=;
 b=LETVS8e68fucM43W3IxHFtCoLE6m9n0FBZx8mi019Cj63Nop7HGVeqBWwhgEJheGF93fNPXjM9oLdWEsMIbrLdXf2p48gdD8DNF5zAcxgYA0T2MEsPCdLIHEha/BNaB/yy/1R0841ZBZvE3sDPxL1Y0xAAJzcEgGphqCsMtzSjuLZUs0R5CEUCo793nBwXgoVCihxvLlTJWBXjCZE3E01DTFud+mEZUYKYtF+ERi0oIB1LkhD1s6mxbAW6x25KpdeQxIkdGiidxax/7aIHgg9Z3E5VrqnQfh6xSdFgN1Zqqr8qJQs+RjIs5p1qQTsEeb2ve2ayxDUCK5qdhW5AIkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noE/f7Aw1yupon/2r4/lcqnbXq2dMkhqmS9AoHss8qc=;
 b=0n5lFSg0AFQotw1pg+FDOVd2opJi23+GXj1CBtNO7LokQ297oDeH4PoPO7G48U6R5QadJG1kafHvQRDLUgYfnnIJWeXfFvdGWC7kuIvAcMZrDcsLaH5FXJF91DQNdsavz1YQmKx/6ur/6Fkzg02L+zLVefPfVIt/03t0e3rAk2U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from CY4PR12MB1926.namprd12.prod.outlook.com (10.175.59.139) by
 CY4PR12MB1829.namprd12.prod.outlook.com (10.175.60.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Thu, 20 Feb 2020 22:43:25 +0000
Received: from CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4]) by CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4%12]) with mapi id 15.20.2729.032; Thu, 20 Feb
 2020 22:43:25 +0000
Cc:     brijesh.singh@amd.com, Andy Lutomirski <luto@amacapital.net>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Steve Rutherford <srutherford@google.com>
References: <CABayD+ch3XBvJgJc+uoF6JSP0qZGq2zKHN-hTc0Vode-pi80KA@mail.gmail.com>
 <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net>
 <3de6e962-3277-ddbd-8c78-eaf754973928@amd.com>
 <CABayD+fBpP-W_jfVuy_+shh+Sj_id79+ECG+R5H=W9Jmcii8qg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e5ef78d4-2764-cbbb-d3d6-69621e1d6490@amd.com>
Date:   Thu, 20 Feb 2020 16:43:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <CABayD+fBpP-W_jfVuy_+shh+Sj_id79+ECG+R5H=W9Jmcii8qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:805:f2::38) To CY4PR12MB1926.namprd12.prod.outlook.com
 (2603:10b6:903:11b::11)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SN6PR04CA0097.namprd04.prod.outlook.com (2603:10b6:805:f2::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Thu, 20 Feb 2020 22:43:22 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8eb515c2-2d0c-4152-1f2d-08d7b6564b9e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1829:|CY4PR12MB1829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB18292407A7BE0FF7B2D20A20E5130@CY4PR12MB1829.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 031996B7EF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(16576012)(31696002)(44832011)(8936002)(66476007)(86362001)(54906003)(66556008)(956004)(2616005)(316002)(7416002)(66946007)(478600001)(53546011)(186003)(16526019)(26005)(6916009)(52116002)(5660300002)(36756003)(81156014)(6486002)(81166006)(2906002)(8676002)(31686004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1829;H:CY4PR12MB1926.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8F8MPatHR7XnpwJS9pa0foyhhxIC8fjld1+pT92alD2wzgKkMbbYl2h1X3BOqYouudNd/RMWU+4uPXkuCIvGKZN/wU1aHy2D8yNR7X8e5YuqcZuzb73uv1woy6fr7eUchMQTcHhc7lbFbNJNY+S88hyddCOlEhWUtcjFSaQk2wkZoajSyk5lnLS3mEgCWpalSDNN9vBisrOgS2uSct/dLlCKGJs4+/XP89UfpSLQ3WaORHV4MsPuy0mNOy1aRl1rWIA0hEw6jO5zE9OVQ9usKRTYCSEpVt4eIlA6e+zNUQSz94Qfmcpxn1aZ3mhuDAqV68esLgYtqzdb7pxOMEpRmKX/fwimxn+YUXkaaZe11sG4lt/u/8ezYHDTjUhOEi7cTUprmhBOqRJwVZp9EtX19KNngxw1S3pub/JndFfcLNf8+ng4yeMYEEhhh3spPgny
X-MS-Exchange-AntiSpam-MessageData: RPiabCkvv8ytqLNdaA3Z6Nh5L5As8Ry3XuKTnrY2CaTpaxry0ZmSE2B8l/TOvwVR8JEL3zdZHepPk0zQoRUn3v66scL7/D6fuUL6fbcM+hjb/njnFEH3k0jc1AumFXcP8AFQFqpesP+L5s48oRGy1g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb515c2-2d0c-4152-1f2d-08d7b6564b9e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2020 22:43:25.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iA+tHNq4QBSmQPyGvWs3lmbjGUJKQpJCNYXcLd/Gz2TJyeArmctyyP/ehaedp+Ij8ojt4eBecQ1oge0ppD13g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1829
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/20/20 2:43 PM, Steve Rutherford wrote:
> On Thu, Feb 20, 2020 at 7:55 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>>
>>
>> On 2/19/20 8:12 PM, Andy Lutomirski wrote:
>>>
>>>
>>>> On Feb 19, 2020, at 5:58 PM, Steve Rutherford <srutherford@google.com> wrote:
>>>>
>>>> ﻿On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>>
>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>
>>>>> Invoke a hypercall when a memory region is changed from encrypted ->
>>>>> decrypted and vice versa. Hypervisor need to know the page encryption
>>>>> status during the guest migration.
>>>>
>>>> One messy aspect, which I think is fine in practice, is that this
>>>> presumes that pages are either treated as encrypted or decrypted. If
>>>> also done on SEV, the in-place re-encryption supported by SME would
>>>> break SEV migration. Linux doesn't do this now on SEV, and I don't
>>>> have an intuition for why Linux might want this, but we will need to
>>>> ensure it is never done in order to ensure that migration works down
>>>> the line. I don't believe the AMD manual promises this will work
>>>> anyway.
>>>>
>>>> Something feels a bit wasteful about having all future kernels
>>>> universally announce c-bit status when SEV is enabled, even if KVM
>>>> isn't listening, since it may be too old (or just not want to know).
>>>> Might be worth eliding the hypercalls if you get ENOSYS back? There
>>>> might be a better way of passing paravirt config metadata across than
>>>> just trying and seeing if the hypercall succeeds, but I'm not super
>>>> familiar with it.
>>>
>>> I actually think this should be a hard requirement to merge this. The host needs to tell the guest that it supports this particular migration strategy and the guest needs to tell the host that it is using it.  And the guest needs a way to tell the host that it’s *not* using it right now due to kexec, for example.
>>>
>>> I’m still uneasy about a guest being migrated in the window where the hypercall tracking and the page encryption bit don’t match.  I guess maybe corruption in this window doesn’t matter?
>>>
>>
>> I don't think there is a corruption issue here. Let's consider the below
>> case:
>>
>> 1) A page is transmitted as C=1 (encrypted)
>>
>> 2) During the migration window, the page encryption bit is changed
>>    to C=0 (decrypted)
>>
>> 3) #2 will cause a change in page table memory, thus dirty memory
>>    the tracker will create retransmission of the page table memory.
>>
>> 4) The page itself will not be re-transmitted because there was
>>    no change to the content of the page.
>>
>> On destination, the read from the page will get the ciphertext.
>>
>> The encryption bit change in the page table is used on the next access.
>> The user of the page needs to ensure that data is written with the
>> correct encryption bit before reading.
>>
>> thanks
> 
> 
> I think the issue results from a slightly different perspective than
> the one you are using. I think the situation Andy is interested in is
> when a c-bit change and a write happen close in time. There are five
> events, and the ordering matters:
> 1) Guest dirties the c-bit in the guest
> 2) Guest dirties the page
> 3) Host userspace observes the c-bit logs
> 4) Host userspace observes the page dirty logs
> 5) Host transmits the page
> 
> If these are reordered to:
> 3) Host userspace observes the c-bit logs
> 1) Guest dirties the c-bit in the guest
> 2) Guest dirties the page
> 4) Host userspace observes the page dirty logs
> 5) Host transmits the page (from the wrong c-bit perspective!)
> 
> Then the host will transmit a page with the wrong c-bit status and
> clear the dirty bit for that page. If the guest page is not
> retransmitted incidentally later, then this page will be corrupted.
> 
> If you treat pages with dirty c-bits as dirty pages, then you will
> check the c-bit logs later and observe the dirty c-bit and retransmit.
> There might be some cleverness around enforcing that you always fetch
> the c-bit logs after fetching the dirty logs, but I haven't convinced
> myself that this works yet. I think it might, since then the c-bits
> are at least as fresh as the dirty bits.
> 

Unlike the dirty log, the c-bit log maintains the complete state.
So, I think it is the Host userspace responsibility to ensure that it
either keeps track of any c-bit log changes since it last sync'ed.
During the migration, after pausing the guest it can get the recent
c-bit log and compare if something has changed since it last sync'ed.
If so, then retransmit the page with new c-bit state.

> The main uncertainty that comes to mind for that strategy is if, on
> multi-vCPU VMs, the page dirtying event (from the new c-bit
> perspective) and the c-bit status change hypercall can themselves
> race. If a write from the new c-bit perspective can arrive before the
> c-bit status change arrives in the c-bit logs, we will need to treat
> pages with dirty c-bits as dirty pages.
> 

I believe if host userspace tracks the changes in the c-bit log since
it last synced then this problem can be avoided. Do you think we should
consider tracking the last sync changes in KVM or let the host userspace
handle it.

> Note that I do agree that if the c-bit status flips, and no one writes
> to the page, it doesn't really matter if you retransmit that page. If
> a guest wants to read nonsense, it can.
> 

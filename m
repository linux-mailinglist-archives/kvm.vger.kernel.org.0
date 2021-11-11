Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4C44DCA5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 21:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhKKUs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 15:48:59 -0500
Received: from mail-sn1anam02on2045.outbound.protection.outlook.com ([40.107.96.45]:16622
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232970AbhKKUs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 15:48:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJqatT7CrFiDGTfS76YehnROk9iVLKzrEeqx+XcbNYN7SEid9hMs7LTOPyCkxaENFZm4sReUcN2P+TqiPpFmIRRVy4A19p4PRc1tT/7TiChalUN+cY8Gu9YapYEmGAPsV8OO6ZQfzZxQZGr1tGcZRgvn3q18p4t84Q2lERmokv0Ht4t2YMZoKRE7KmaAZxsXCBHzShO2rX4mQnHFdHWC45EMJQhJD+bb6tXWbfM2EII89aAv5oRtPKpNdObpE+0KMoUx+SmctXBv0sbxeBHMvx6VbIL4VK3WOJtsS56NC5fj73aOPy77YKwz6zdxGLmZBxuHBByZeTaxHd2aYnLu8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaP25I0L9IOWB/Acvuz3bpPifVtu41eMgRXBGfaJh8g=;
 b=jFnSn5hcBJ5avfYM5m/Ri3Sol0igQt9bJW+UQ9xYaoI5+E3nDIMObZgU9eIpH2+D1qglsGp4YLsL/rcQCCKrVAuX/F8axkZvphh3goebsaeeApiHhVWQNbZw0PMUjC+XDq63r/cYvLrt74mJ8arnOtthbpzHdhTP+kS5l4wOpfj+C22r/Z6CnUC8vlkeicXx7WUAquM28xBx/WGu9C/tV6/Jb7EVl9fmNwFkRPtXyCIqoZ9+RGIIa0iLKHrkDjy0+Sss/gQFCbkq8ATXnMCd7akmyANSD4xuySwcX8fqpbYsZmKUnb6ZNKTPNkVR12wFGqNA1eQls/rNZ5Rx5Bst0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaP25I0L9IOWB/Acvuz3bpPifVtu41eMgRXBGfaJh8g=;
 b=qJMJXIJ8zTNasNo1gJbSocGsIxH2wM/qR9+4uhkN6MvZkb7xySuJBgx7AZDWBzhRFl1Zyspbn3yYi4/ld/gAcN7AnLgN8r65szx81dZPBs3EtRxbGKHTFEQ4G8liT+94Io3Wy0xxpNcEhiF7Ux2/NttQbsUDUnd/SLhAsfxsYEc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 20:46:06 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%9]) with mapi id 15.20.4690.020; Thu, 11 Nov 2021
 20:46:06 +0000
Subject: Re: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with
 protected state
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
 <87cztf8h43.fsf@vitty.brq.redhat.com>
 <3b8953c9-0611-27da-f955-c79a6fcef9ce@amd.com>
 <e45669fa-372f-a29d-d9c9-b4747e56b97c@amd.com>
Message-ID: <afaf4683-deb8-ef11-97f0-d52b2b144f0f@amd.com>
Date:   Thu, 11 Nov 2021 14:46:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <e45669fa-372f-a29d-d9c9-b4747e56b97c@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0077.namprd05.prod.outlook.com
 (2603:10b6:803:22::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0501CA0077.namprd05.prod.outlook.com (2603:10b6:803:22::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.10 via Frontend Transport; Thu, 11 Nov 2021 20:46:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e25a1e20-5d18-4c63-aa82-08d9a5544868
X-MS-TrafficTypeDiagnostic: DM6PR12MB5518:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5518AA13E82C01DBA650DC4BEC949@DM6PR12MB5518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDV4m3c09Jk1qzSf8rPCN3pg6H56Mcn97NHTefdCQ9zEiItNQ9uICcMHIdmF6ntY7GPeOpVTB0qh6i0uaOm3Mnvo6pJ0/9CzSF1btF3XYAkEqIWjRL2RShV7kpmZQMjMh8mEvUJgL8mPPISkDhOa6+cXH2H2OiGH93CSOKhg9Ybsk981NIlAi89SUBN6EUD6ZhZVSTayst2Il6zHEEPARwlP+HTNVsk9GY+tBtw+7RsXsv6i/79hgW5dWXFK2GFTPSaOiZAetIhkCRWXSvr31JMjeqL2xXoaFv2qpFDu0B1QBlc9J0PKg6oLj2hgWIe5m91+25UKIj3urE5sptETwwGIHi4dfEaMF6lw0F/v1j8gz/+zl2vMyqCAEYRNIH0ZdWMr3gHnPYMbroBjRFEAL2UCy7ZpZ6dI6WA6c+zW/iPeG6HucRf0XFb4MuFVC1GOp2bBGuum+xu8aE0HNqwSk2QRAkNrHvxskY6pTiIf1q4Bc6V7+fFhz2cQAVt2GVTA8g4739yRGkeUEuIgoTlSbzDuYfjDISFp5A0nS3+aNCvTqqTU+fZnCjLnN6GoAJ1A75zrC6dIftW4tOe21r9OYfoGqABIS50V33zZ/XyglB+LfZmyrlD1qienp4UBV86pxIyQIz861JlggXey6pThh3wHou4h6QO+/yPN7GwCWfNUXdSbFvJ2XlHTqumQeHrz2ohB/kW8AKq68CSSmTVAX1Zx8nh6pSxOMBbesYQU0xcTJWmnle7Xx1ME9+agR8PyvaHUPPy9ZCT7t+mDgqDCrrmqKV9Ra6H8sw+EzOFVkt5k+SKIitOLlinqB4zy4j8AIc/wUA8vplevcaR0BL1s8w6cZQbXBA42IiUZoaaMx4+Lpxyefv4gTcNIUGKYNmV2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66556008)(66476007)(508600001)(53546011)(26005)(8936002)(966005)(66946007)(54906003)(38100700002)(186003)(86362001)(2906002)(5660300002)(2616005)(956004)(6512007)(36756003)(6486002)(7416002)(31686004)(8676002)(83380400001)(6506007)(31696002)(6916009)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm5tUHNOOWUrSXdGaVlQOXhaYUVyNGRMVWt3S3BaQStxaE5XUkMxMkk1N3pv?=
 =?utf-8?B?MkZIMGs0a3k2TjB3YjhCSWtpd0JIM29UVk93RWprc0p0TExSQy92OHlTclJO?=
 =?utf-8?B?M251bG84b1dZK2hkd1h5UnQwNEpxc3F0VW9YblJKMkE1dFNiMkdaQ1dpSWJt?=
 =?utf-8?B?a09qR01lcFBsMHhsejNyZUFNTHNrOWJJdkVyMGNESUkwdFJGSkpQZ05IV2tV?=
 =?utf-8?B?SmxBNlVpMDJ3VUtxY0hHVnRSdFlnemY5Y29VUncxSTBETzVuNnRLZHloU2Z1?=
 =?utf-8?B?WnBHejlybDlidkc0KytZVlFCRWxVT3lOQ294aUltQ0JxWU1ISWxNdFRLcjFv?=
 =?utf-8?B?SWJDSlk5bVVROWRrV01TVnpvODJmMCtsSVdkdzZvMGtOOXJIT2toWXFLWS9Y?=
 =?utf-8?B?czRRbTVlY1ZEOHhCTGlFdU9GS2NOMGEwM01abU5jT2hJUXkyR2I5ZzZXQTRz?=
 =?utf-8?B?WDNMdW1IdS9Ibi9ETDNYQTYyd1JHMEphQzIxK05FQVAraWxGSnRXRXZ6VzdI?=
 =?utf-8?B?ZjdoOWdPL0N6UUtJVU96Y2JTWWdLdWNjZXlFem9TT2NjcnhCNmRhaU13T1Q1?=
 =?utf-8?B?RjUxOVZTRE5QblcxaU00TXl0ZnpKRHBUcTU3Q2w1MU5qSzhXWTRLdVhIamx1?=
 =?utf-8?B?SGt6S29lMk04cHgyN09DR2luWTRsZWZ6MWo1SElGdG5iY1B5aEdKNmVIOE9Y?=
 =?utf-8?B?YTg2MGY2aGl2V0QrR0ZaQ3NIOEtUT0xZWm4yNmNKU0Jxalc5MWxXWUxqRTZI?=
 =?utf-8?B?Ny9vQWp6ZWc0bVFsS2duSmxJK1ZDMG9MOERWbmVLd3h0WjhEWWpUSjhGWW9I?=
 =?utf-8?B?alF2THh6NCs4MHJRdmpIcnlMZTdHMDlvT1UvdFhxcEE2T2ZxZTN0SXZwTFYz?=
 =?utf-8?B?bGZBeGJITWhYbUpjcDZ3UjFzOUdvNjdGaTY3QlZkSTZ2YzBXUVMzSlFKNkVZ?=
 =?utf-8?B?bnBwcGp4TE5tUkN4TWNXYW1tRXk4Q0tNRk96RDF3NUMvS1R0MSsxaldRNUpi?=
 =?utf-8?B?M1JpWmRVazBMenNyQ0JoN2pvUHZOS2NDa1RtazZ4RUUxNFYzVC9tcnV1SDd4?=
 =?utf-8?B?bU1hbnF5T3pQa1hkM0VlcUs0RGdDR3dCTDZ4OERJRkFlNDE3b01kQnVIcGZh?=
 =?utf-8?B?My8wZVZ5RFBJallubk9uY2IyVUFpek5JdDNpSDV2YmxYVGFTK1RKMHkzS3Ri?=
 =?utf-8?B?eTdrc2VoMGNIV1dwMHpveVVXTDV0dUNKQUhiVStXV2ZmMkFwZFRZZnFBRmw0?=
 =?utf-8?B?VWltSUhTZWJaNnA1bHFVWFhML2Q4TXJ3UGZYUlBuU3FKZUc1Qzd5MkF1ams5?=
 =?utf-8?B?ejUyVVpGcmxmWEtFVlhkdkpmcVBJOWs2MEtJZ3JWYzJYNTFkTzJYSXFJZXcw?=
 =?utf-8?B?UHkwZUFDMXdxaUdaUkY0dkNhbmZWS3RsSkVwRDhTVXZ1QmswL3U3dWZ1NG5p?=
 =?utf-8?B?cUNIbmluTEhDcG5XeG1XVHdWSXd1S3hTblMwbm41SUtCc2F0YWs4MGVPczJV?=
 =?utf-8?B?NU9jRnl6REIyQk9kMGM5MzlnbXFUbVdFaUl5THUzWVgwN2JHK2hSYm5PZnNh?=
 =?utf-8?B?S0VITEJZRkhBOHhaVWgwQ2hTMVF3NkhVQkl3K2szZURvR2xzTFRiK1E0Wm1F?=
 =?utf-8?B?TnlRK1kxSGdrV2tEN2g1bDhYL3JYLzlza0tkdlVIMU5TTXVNNTdIQzArVHQy?=
 =?utf-8?B?YVJjT1hrOHlvb0diOGtvbk5jZlNjZ3U4d21JU0E4YjRGSjdjUEdxbVUrdytJ?=
 =?utf-8?B?UVYzMS9XTDBSTHJPVjRSM1dFTUloNEllQkZlZDBiKy8vTURZUExzK0NEeEhU?=
 =?utf-8?B?enIrVi9qSVQwMTZKUlYvcmRZd1ZicU1WakhNdjB3ZnBpKzhTdi9GS3ZoR21I?=
 =?utf-8?B?cStmM09hdG9wRUlaTmJpKzFmaGFpblNrc2ZRS1gvbVFxWnhEOWU5ZzJBSHkr?=
 =?utf-8?B?TllBZ1craDhIYVBObC9jWnk3OEhXU1MxbklHZ3B2MG9OdFBvVVc5YytSMFg2?=
 =?utf-8?B?RnA0QTUzS2pCUlE5SmZTMUhPVWtZYXZjR2Y3OUgzWVNxZ0JRMUZhMHEzYkJn?=
 =?utf-8?B?dFR3N0owQTg4bXBCcUsyaVEzOU43UzR6ZVpOTXJvQUlubjhnNEVLd2hlWTJN?=
 =?utf-8?B?N0s3WitpdTRxZTF0OVFpUktyeEc2d0Rwc091c0psK3ljNGxaNVViOVFVaTdo?=
 =?utf-8?Q?6XkEavX5cOrNR4DlTc5QtEs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25a1e20-5d18-4c63-aa82-08d9a5544868
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 20:46:06.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebjiqRMtVXYXb8dOP2NwBNmuYvrHYsKDxnyuBqEulxxdOdBDH/V8vXf1uau60C3I15wEqNrtlLYxL36etXggTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/21 1:03 PM, Tom Lendacky wrote:
> On 10/1/21 12:06 PM, Tom Lendacky wrote:
>> On 5/25/21 1:25 AM, Vitaly Kuznetsov wrote:
>>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>>>
>>>> When processing a hypercall for a guest with protected state, currently
>>>> SEV-ES guests, the guest CS segment register can't be checked to
>>>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>>>> expected that communication between the guest and the hypervisor is
>>>> performed to shared memory using the GHCB. In order to use the GHCB, the
>>>> guest must have been in long mode, otherwise writes by the guest to the
>>>> GHCB would be encrypted and not be able to be comprehended by the
>>>> hypervisor.
>>>>
>>>> Create a new helper function, is_64_bit_hypercall(), that assumes the
>>>> guest is in 64-bit mode when the guest has protected state, and returns
>>>> true, otherwise invoking is_64_bit_mode() to determine the mode. Update
>>>> the hypercall related routines to use is_64_bit_hypercall() instead of
>>>> is_64_bit_mode().
>>>>
>>>> Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
>>>> this helper function for a guest running with protected state.
>>>>
>>>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support 
>>>> intercepts under SEV-ES")
>>>> Reported-by: Sean Christopherson <seanjc@google.com>
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---

...

>>>
>>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>
>>> Thanks!
>>
>> Paolo,
>>
>> This got lost in my stack of work... any comments?
>>
>> Thanks,
>> Tom
> 
> Ping
> 
> Thanks,
> Tom

Another ping on this.

Paolo, you had replied "queued" on the v1, but came up with a suggestion
for a v2 that might have got lost in the replies because it never got
queued. Here are the threads:

v1: https://lore.kernel.org/kvm/d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com/

v2: https://lore.kernel.org/kvm/e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com/

Thanks,
Tom

> 
>>
>>>

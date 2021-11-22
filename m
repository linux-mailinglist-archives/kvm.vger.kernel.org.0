Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D3459552
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhKVTJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:09:29 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:53793
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239573AbhKVTJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:09:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J072ITe/WUcgNVOTCqGCH/YCyG30kvvhYKtaLhO2Ds7v9iNI5ceu+2jkU6QhSJiZyX+cftp/pCYTJas9uFdzuhx6uqLTkvkqvnCYR/3czMkofL18LvZqaPFnPhKZ+sdOyyXpIPKoWKERTTi+Lp+/A0Yza5m6Ep7mSi1mpg/Aklz/0Pkgr5w3LYqRU4GFuYeEpfIU/sv2x0NAyMWRjZ6BlvzP7/5x1WMJ/qNIJaRTUuOVZZ5E6MWD3GvvJQAQQY+sFuehyVfN/Cey5ZBQXXDk8YhlxLjeZmvx5BPdY8GSJQjyJeRKG6QE50xc/XKIPE8FImtFOw1Sy5nvVjNXl+u6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHuV0m4tLTG5c62yXPPAQmjbSvNAP72mQ1ZsxHiNhlo=;
 b=Ki5whdi08nQXoFdFVgxUAzNv7H8g1OhxbVb2nKCdGFDpvnXDlUBp9Zway+LrfkRWJM3ewSs1t6GHDwkH6vClNMC2iY6+zCNb1tXLhrCils02mcl3I8qzGcVoE0zHquJvXjH+u1La/CBIi/yO2BuJXBjxpBaqpI5nweK7jV8V7RSOeq6Bsez39eNNRuZP9x49lh8DzPIUJn09IJqmw17X5y3XOTsEGSp7jgYj3aNMgtXPkqov1Qsy8kPHYSc89xgTSS9DqSVaMmXPtfIAHOyOunrCwbKxkgpHhktRPojvT9aqUEVIsBMKV080HKrpTDPtbSNpirTKUFHhBDTw0T2ZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHuV0m4tLTG5c62yXPPAQmjbSvNAP72mQ1ZsxHiNhlo=;
 b=r54DqXH4Ae71z7vQIqKw7xF6SNpo7Y4G8Txn/iXcsXn26wq+zkB5zlEve/rbATZB393pxLec529NA9+WkB7fEVUfqe/Y9OOTXs88r17JxX8Jk1xtkhKexJEu//hKJMPIsAhNq/aTTPA14zSM721scrRVhU3CqI0AUQ4jUrSYVwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4559.namprd12.prod.outlook.com (2603:10b6:806:9e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 19:06:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 19:06:15 +0000
Message-ID: <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
Date:   Mon, 22 Nov 2021 13:06:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Mon, 22 Nov 2021 19:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6033cb8c-cd4f-43f4-8a09-08d9adeb280b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4559:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4559C55F265F41A89BC9E8ACE59F9@SA0PR12MB4559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qbA+sef8ORpA8IhrONT3D2Y9V0FOO9ucIjX4iA+uyRswDIFtrtMrwPIc21suLRfldzq+1BD/g9kmhPoyz1AyYLMgkSoSpGrzXz+dh8Qn+g/VyfmN3RFbAF1jPsxm3Tg42L3xcsI5n/fgm3N/C5K41BNtU1tt26ybF6qwnoWCnkIAYTqpIMCckmVMucEO0RfhKZSTPy7rVFJxEfizU8T6HT5I4nEkBTkB+4L4j/kA2uz07bWkVJNtk1a+Va8njtzJHR0fpcBMPMQYY0l+eHDbBg87/jqxHcEJ7wdMughxiUt6dQ/JMEcDeYW913BI/DGZvQB3mWL0R305qunYUUERdrN8MsNdck8j93Qwxr9qgt5pKj9X9OX3+9n/UcQEuuJrNM1tg0H6EJjBl8AdKIvv41Do2C/n+XkOMldkQfc77jmdVExHWwyawRRWdv5IpVXJJuGW7i0KRFPQnAy/n18VGR4EDZhmiRfuvAuFauFjeqQMAHQt/ireefMcboIDb/mBEjhODQMOOqijPFRjFRHhsPMD8uekM1YG4vPAqnggs4KQClMWLWlxppLN+d5Njm6OfN48ePIrF78hP0/pycA8jhEVW8Y4oe+z148wF2rYXsTRDiICQ2OynoSbTTxxoJEybRd2lj/Z9KrF1BNQfCLSvo0H1QR825qk6DKVj9ovHxV9DpCxrKqki2uAW88UZjWqmRsGJwxiWZ8BRaMnusx7+bwZbvtceq50f9eoCK3eznQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7406005)(7416002)(31696002)(956004)(2616005)(4326008)(6486002)(5660300002)(8676002)(186003)(316002)(36756003)(26005)(38100700002)(53546011)(16576012)(44832011)(54906003)(66476007)(2906002)(66556008)(508600001)(86362001)(83380400001)(8936002)(31686004)(110136005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU1QNXdLdFZpR254UENBcXdtenRIaUJMM1lSS3BhS3JHaVZvN3ZDN1A4TitZ?=
 =?utf-8?B?Y0kyUkNjZmE2QUx6Yis1SERrTlRzNG82QmZwVDd2ajNJWnEvbGJwUitLNm5N?=
 =?utf-8?B?MUFRK3M4di9OWmdtejQ4TWc3eUlPNnFqb01uQWNGeEJraThCNHZ6dm8wemVB?=
 =?utf-8?B?REJoR2xEendHd043WEV5bnA1bVdBcExhc3VwdHNGZXdLdVhPbUpmSUc4UDNG?=
 =?utf-8?B?TjhxNkJnRWEybmNKY2s1OTVrbzlmSEpFbHZqYUlBOWpMT1BzVGxzMkJwMWNQ?=
 =?utf-8?B?RjR1Y3hHYU96ekdWZHlEMTJEZWZDdVlwZ1RLNDQ5V0k3SUp1akFJY2hRZFdu?=
 =?utf-8?B?Uy9xVWlSM2lZcGxtbUJHNHBjZGxlcm1tWC9HaldHczIxa0p1ZHE2c01IaDlq?=
 =?utf-8?B?a1ByakpjU1IzTk5sMUxyZERpRkd4akNaMkk4OWlGWkdMZnZqa3VFOFJVMmVu?=
 =?utf-8?B?TW0xODV0Vks1SFBZOWFpUS81VkhOZlZXVmF0Qmc0Z1JNZGV5Skwzb3ExMnM5?=
 =?utf-8?B?SUF2YTA2cFJORG5kUUNCQVNMa1N3Z0YzYmFRbDhwQmRGejJWVUY2SXdqZFlp?=
 =?utf-8?B?cUszdmloS0xmZzl0QkljSENFQ0lSeE05bjhYUFFjdUpCQVFHc0I2WUhqZWZ3?=
 =?utf-8?B?N2Jrek9BVGR0Tm5NenpOSjk0SGRpNE9NLzFraGsxa1N1N3lHRm9CRVB6eHhP?=
 =?utf-8?B?OHZoQXJJSXErU1B2YnJIRm01cEJERzdXQ3p0Y0pEL2NIeFBtRmpFZ0FHeThQ?=
 =?utf-8?B?amR0NFhyT2xKaDhWa1VEWDJobEFUdk01VmNyM21Ec2RpRDVwRUV2TlFLVTV4?=
 =?utf-8?B?RHN1b0EzRGVsUngzbXVQTnhJRHhvWktFd014Y1RuVDZaVTJkZ1JXRXpQR24w?=
 =?utf-8?B?cmFabFIvSk5pcHR4VS9pcnJocm1NZjVwTHNvelhHSXZXU1RFdXJpMGxJcmwx?=
 =?utf-8?B?NGVxdGxaMnBIalpZTEJzWlBpNTNHWXF6WkVhc01PN2N3MDM1R3FsdFM3Z0NH?=
 =?utf-8?B?aExEWWFURXRvaU1kR1ZqSHVVWjF0aWdHa242dVMyeUdZSitjV2JXenBJQ3Vx?=
 =?utf-8?B?a0puUEN1Q0s1UVJ3K2trSlU5NzYweGdOeTVsNzdaUzgrdUdtNXhEMTVVQWNv?=
 =?utf-8?B?alpRaWZEbWZqMHVYb3Qya1N3ZndBYzhaTVFPSFZNM280QmZDZi8xOHhvQ3Vm?=
 =?utf-8?B?aERYZzJEM2I0YmxSelBzNC8zQzlrUEdmdnpjazc4TmwrWXBvUkNPb2JEaGhv?=
 =?utf-8?B?SG96V2o1Z0tud0lZQVh0NHJLTUhCdFVWWDUrZWNBaFFYYXNjSGsyZmFPZllT?=
 =?utf-8?B?TGF1NW41LzR2RGJkUm9VRkJERE9aUXdVdWk1QVRvSnpQblNhYm9VZzVaUHNY?=
 =?utf-8?B?VThieUVxZEFjeEw4a0pzQXhRQ0hkaTEwR1l2YXBpTU5JbUptNm9wT2sxWWg4?=
 =?utf-8?B?UVNKUkhyb3FveW9TemE2SkVleXlWVjJtVmFaS1AvVzBsdEI5aHVkaFVBbm9K?=
 =?utf-8?B?Unc1Wm5nTnFnUWxjeTNPK241d3grZGkrYW03ek9nR1piY1pBcW1Qbkk3R0ZZ?=
 =?utf-8?B?RFEzbHdJaWU4SmxnK1JmbklWZE44U0lWcG1tZkI5RDFWTGNDa1RXSk5DUEl5?=
 =?utf-8?B?SFA1N1c3QVlVaDBFTWw0dDVVQUNXdFZEcy9NV2VsYXMzeVYxdjN0Q0g2cExM?=
 =?utf-8?B?b3hlUURJS0xsWmJ6K3U5MUxlZVNnWGxHNzFDckNrNlNlMGVmOFpqT2FPa0tm?=
 =?utf-8?B?a0NReGorSFVjbVU5SW9OWDJHdS9wS2I3NlRtUUNyT05Dc3ZrZERnNlNjRWph?=
 =?utf-8?B?cncxTlYrTkFTK2ZCWVJxRjUxRE1RdW5lWlhscjRBamRpb2Q1MUZ3bW1hbW9Y?=
 =?utf-8?B?UGJrT2Iway9pclIycS9vQ1ZJeXFEL1FydnVTRFJtRnhiUk1Qb2hSQjNmb0pW?=
 =?utf-8?B?VHlMUXVIN3o5Tmw4S3ZmMi84MGtwcnFNWjhNTWd2YkwvaVJlT3JEOGtXelNl?=
 =?utf-8?B?RjNyNXREbmxqY3Z5Q2d6OXNCQzg4dElLMlJhOEFaSmVzRFhDMFFiejZDS3pz?=
 =?utf-8?B?UnBuTWhVdjV0SWtRcU5Nd0FFeHI1UnVtbkNZbzA3U2dMQzhEZ3dUaUJJSldZ?=
 =?utf-8?B?d0ZGbWUvd2s3QldBeDUybXdPLzhrWDgxUUVKYzVlUWNaTGxKVjVZeGpJZXhY?=
 =?utf-8?Q?9hZPxLIVhp3Zk+SRAkEPSJY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6033cb8c-cd4f-43f4-8a09-08d9adeb280b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 19:06:15.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i669jqUPEJMVh8/cJDFsUnTZQmpJDDBUlB7ABf8xCH/JbJp9gPdlTVS+bfolY8cyYAjo/azhg4GdNKSWez4ETw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4559
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/22/21 12:30 PM, Dave Hansen wrote:
> On 11/22/21 7:23 AM, Brijesh Singh wrote:
>> Thank you for starting the thread; based on the discussion, I am keeping
>> the current implementation as-is and *not* going with the auto
>> conversion from private to shared. To summarize what we are doing in the
>> current SNP series:
>>
>> - If userspace accesses guest private memory, it gets SIGBUS.
>> - If kernel accesses[*] guest private memory, it does panic.
> There's a subtlety here, though.  There are really three *different*
> kinds of kernel accesses that matter:
> 1. Kernel bugs.  Kernel goes off and touches some guest private memory
>    when it didn't mean to.  Say, it runs off the end of a slab page and
>    runs into a guest page.  panic() is expected here.

In current implementation, a write to guest private will trigger a
kernel panic().


> 2. Kernel accesses guest private memory via a userspace mapping, in a
>    place where it is known to be accessing userspace and is prepared to
>    fault.  copy_to_user() is the most straightforward example.  Kernel
>    must *not* panic().  Returning an error to the syscall is a good
>    way to handle these (if in a syscall).

In the current implementation, the copy_to_user() on the guest private
will fails with -EFAULT.


> 3. Kernel accesses guest private memory via a kernel mapping.  This one
>    is tricky.  These probably *do* result in a panic() today, but
>    ideally shouldn't.

KVM has defined some helper functions to maps and unmap the guest pages.
Those helper functions do the GPA to PFN lookup before calling the
kmap(). Those helpers are enhanced such that it check the RMP table
before the kmap() and acquire a lock to prevent a page state change
until the kunmap() is called. So, in the current implementation, we
should *not* see a panic() unless there is a KVM driver bug that didn't
use the helper functions or a bug in the helper function itself.


> Could you explicitly clarify what the current behavior is?

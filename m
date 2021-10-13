Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A853542CE29
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 00:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhJMWdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 18:33:43 -0400
Received: from mail-dm3nam07on2056.outbound.protection.outlook.com ([40.107.95.56]:54528
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231489AbhJMWdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 18:33:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOQDnzAtrYIQGXDj7Wq3h+jMenXly86JDGP5zkD1XdRREdT4QPm6XzZtrA9/e4FTNHbGAFx0ZvXXdRElBsHBPxcDKfPxG2laSbzfYk7w8mmFWz8WE3ul/ywIo7oq6U6tj7v6IJbetRRao/eVC1i6ApC/CNRat7pgwcRXVzFzXL2fZLFT5Yj5by8SmpzJWxgSt6CFynbviTI8siVK2eVURm7NiEAA3iKRMVKgGRpEMKPY2PrEyLLstL+Eme4SXzk1gpiYzeqXjWiX7rWgWGOtMs+KWxzylTcSoZ9eraMPK0mGsw5eTj+GxCbt1P+beJkGmzGKEBMVFDqZ4zwzxJgOdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuXtJ58xY7eoPLXc7vq2FmbOf0YUD8PLdruEEnVeZYI=;
 b=N//20Anz7lpMX3CDYAzcVghMBL61zOYlRpTWysQt7Ld315ZLDQu5qXFnj2oJYa5EOGQIHe9LRmj3GGpuCo1DsnRoKxXDeIZETFpPeD7Php76ZM+nMVX1VJjsxSHR2Nh1B/jEZoRtzvQe5iukVydvgkD/AihvHEqLXRVyjE+TLpmcbPlinIs3U7V0f7SkytuW15xLiLtQ33Ykf5+jms0cJWyqSI+HROFgA0Qeo66X058lAyOBtbF7s8JRpEy+GL1bdswmgqdbVfN9ZVcJkUqt3LJPkYbUZuMELH4RLpJourDna5heaP2OHC7Hg61fzDxhiivwWmTB+7qy4vMqtddJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuXtJ58xY7eoPLXc7vq2FmbOf0YUD8PLdruEEnVeZYI=;
 b=EeVTuvloXxrLk+f0W4q94IeVGIuEqKe2nRn8yPvsD+X5Ae1IWUUinmeNG0hUhc6UoviQTwRrPo1SnC65fh5X5RBqFXLJu1qBEg3bnvKhVspMRlNSbiSYQFhrTtcNFw7RUUy31F9XXNRM4kq4X9HvFyjd5WIPiH09oBtn/r+9AOg=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 22:31:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:31:27 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
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
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com> <YWYm/Gw8PbaAKBF0@google.com>
 <94128da2-c9f7-d990-2508-5a56f6cf16e7@amd.com> <YWc9KL8gghEiI48h@google.com>
 <a7a541ba-129a-1083-3517-c30e9f9cd7c7@amd.com> <YWdZUrpn5/JCz39R@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9ffed063-4322-2213-0f0b-d899eae32ddd@amd.com>
Date:   Wed, 13 Oct 2021 17:31:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWdZUrpn5/JCz39R@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA9PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:806:23::7) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0062.namprd13.prod.outlook.com (2603:10b6:806:23::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 22:31:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3dc6bda-14d8-465b-19dc-08d98e99324e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB272035952D6B45A3BFBAB95BE5B79@SN6PR12MB2720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfjA1JeKw4dxdRNoj/db2oHFl3+VFK6F4U6ftPoxNA8E4vuHjC5mzT2jfE6+Gi0/Bl9K5DULcacA0J+md82mHNUj+qME2imPVUW18nO7Y8ndI3LvFL02g+cvgOuqHzEtV2pD0BRNCVN8RJV0iF13dM41xoyE4Dw2LoMSYUlqTh03f1gxiGNA1TQNgAbObeONtXJ5STR9UUNaEshd89lcQJJww7Na6FqRYX0EG+ZEGFUxkzDAbuU8JaWuE3BYx4dgrQZYrs6IfkFGfnIGK0K3gx0Dufge79HvuZ3BzqYmTShgRRwEXsdFevPDaWihXbuhxiIbHqdQpvKp7IqET1hLdUVXAgr/n3uqrbhfshizwdDTduUxVKmM1Uvcss3mE7JRfLSe+BAlctMT5TG7nh5SJXwCCXR0dJDbRNxc5bRq5vK4lvX61NckbqktpG5ilYEKyTschxbtL+Yx3zaJctNANtuhzUcJUJFgj64opPFV6DtKNmwamQznb0yMTU+xeP9MQUhKwKNzm+Yuo4zMJ1NwEvujPncI8mU6BJfk3zCP1tvJKWtjy5bwo6quZya99vYJ2537uw68ihmgER8tEQVnS9eGDiHjAfKFimvMJcVRava43jHC8A2Ts2KCPvjmzZ0Nu60EElpoLbHFa3abvQINNP7Po60K1xnXwE39THjlqKm20SpwvrKOrlOnbjCcvw5APj2PXZRXi0Kb8WKpn904mjXr9S1M1IS/CEi+EmEZIcF+7NipO61o2EQRQ2mwyBrf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(53546011)(31686004)(6512007)(7416002)(8676002)(54906003)(66556008)(7406005)(956004)(316002)(508600001)(38100700002)(6486002)(2906002)(4744005)(31696002)(5660300002)(6506007)(83380400001)(44832011)(36756003)(86362001)(2616005)(26005)(66946007)(8936002)(66476007)(4326008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akJnTkNZZWtmUWswQVV4RnNDRkJxZVZNZUZtdkdBTnpXUW5VbC9PSDh3UXZn?=
 =?utf-8?B?OXBZRmg2cEJHeVVKTEJuYWQ1R0VPTXphakFKUTI0RkxYNjQyNEpWd0JGajhO?=
 =?utf-8?B?Tk9PcjVoU1dOZmdrdElGdXlZTjZSOGpBd3hidmJzZXFqSjRnc0ZsK3JvdVVl?=
 =?utf-8?B?SHFhelVVeEw1UjBUY0hjdVZ2aHFTQXN5K2g1SjlQSkg1Zy9HRDJOWTVrRDVH?=
 =?utf-8?B?TUVGUnh0NGNsZG9jSGdsRlg1Q3BHcEpVRzJSQWxnV203RFlEYXYxdmt3TDUz?=
 =?utf-8?B?My82cUpIMnJpQ0JNbXpMRGRBbDRHYXBPQ3dvZXllM3FnT1pxcDRJRGgza3Ji?=
 =?utf-8?B?R1BINUxEVVBROS9laFdEZnZ1MVN1Y05CVWlQcGhiVGNUd0tjZ0Y1d3Fwakpo?=
 =?utf-8?B?S013WE5LajUyODRXd3dwcGVQMDhjRkN1OEdRbkJ6MGlld1o2cHBsbkoyN0Q2?=
 =?utf-8?B?VHVvWVhYOVVqUTJIUUU1KzJXdGRSc3JST3Rra0k0b0xQdWNTc0pXcnY0ZU51?=
 =?utf-8?B?NWVKWmgvTXJUanEyOU5QL0UzNjc2SEcvelRhVlFreXRRdUlCbnVSbTZqNzVX?=
 =?utf-8?B?dTJjWmFSLzhDS2VaYzZ4N2tvMW9reFg4ZmFhOXYvMDlHM1pUU0pmUjhXWjJ4?=
 =?utf-8?B?YWdFMk5Zd3VzWjNOSzgzM2RFbWxSSmNNM2VKelN4STdObG5uVU5WU2R1clJo?=
 =?utf-8?B?Z0xmV1dUaGdiZ1JCT1RiZ2ZpMS9GWVpnWUlVKzNaSk9PeTg2R2hJUUVxRjFT?=
 =?utf-8?B?ZCtjNngyZFcrVGlwY0JmNWZrek9uN2UwWmFlU0NvS2FwcHdDZDFGeUx5RXk5?=
 =?utf-8?B?VVNCK3lDeHQ2WWVsM1czWFhZdDIyVlg4ejdJYnRyUWhuRVlEc1c1ZnE4VDhu?=
 =?utf-8?B?ZmF4aWZVelFyckxjMnlKV043ajMxSEFTZWc2MmY2OE9MRGVWRXRSMnZZVzJS?=
 =?utf-8?B?Y2U1NFlEdWtRaTA0VURJUWFIMWxsNmNhc2FPU0Y5SHlGTjE5cEpucFN4Tlh3?=
 =?utf-8?B?ZWNYV2R1WE1iMUFYclZHSFJYV2RNNGtsRnBvbVZ4czJQOEFkTnk1ZFR5ZklC?=
 =?utf-8?B?Z2cvOHZRZFJHOFhBbWtoYXNXY2lqVmg5dUNYZFFIekx3eXplZVVDS293Y0Z0?=
 =?utf-8?B?K2FnT1ZQbHVBeUJ2bDdPNXNPZUpycWtEdmZSb0F6NFVFbkNzcGZmZTN3VHJi?=
 =?utf-8?B?VVJGVlFKcWlvUm5wd1ZKYTFRa09Id05SZk82d3UvNGE0amJVSDZDWXE4MHBD?=
 =?utf-8?B?bWVtMFJXQ2hlTDhZNXBLM0hiNmdYTDFIQ3FGODllOXVxK081MFd6R1pEemRP?=
 =?utf-8?B?YUNmMFlDZ0kyU3YxWXNnVXhlQm5USXVPenBQMG91NVRMckozdURXWUkyOGhw?=
 =?utf-8?B?QUM4UC8zVEgzQkxibTREd2JKZlZOdzkwb2hOeHJoUElTOW4vNUNCQW8zL0pZ?=
 =?utf-8?B?aGlxcklpWFcwaEZPOElhTXFmVGV1K09GeFpkeW1PV1dONngyMmVsQ0Y4NkZR?=
 =?utf-8?B?ZmRkZDVNQzVqR0hOeWhzMm1xYS9jRnNsSGExL1RUUUVkVTFWa2FTVFZaSmwr?=
 =?utf-8?B?ZCsweWMvaEQ4QkJiN0JDSGtWRkd3dTk0bW11Y2ZYSjJmK0NjVzUyRmliOVhP?=
 =?utf-8?B?aEdDalJkUlFXNkYrZURTcjF0SmRMa3VkYkkwa2VicXN6UUxQNkRwa2Y4YlU1?=
 =?utf-8?B?V2t0ZVNCRkF5K1VrVXFVTms1ejdoMm5aNkxCV29Scm1tM011S3dZZ25LcWZE?=
 =?utf-8?Q?DpjEvIHGvdJm6ffy+iyjIFck03jXbYCdICjClm6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3dc6bda-14d8-465b-19dc-08d98e99324e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:31:27.6894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBNoo7e30gRQaCOP1y3pgvmrxBj7wXYQ2LNHX9VvOR0KzGQgyHtNNDK7bPYQFjrCX1yNBNZqsnHonkA2SQAcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 3:10 PM, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Brijesh Singh wrote:
>> On 10/13/21 1:10 PM, Sean Christopherson wrote:
>>> Side topic, what do you think about s/assigned/private for the "public" APIs, as
>>> suggested/implied above?  I actually like the terminology when talking specifically
>>> about the RMP, but it doesn't fit the abstractions that tend to be used when talking
>>> about these things in other contexts, e.g. in KVM.
>> I can float the idea to see if docs folks is okay with the changes but
>> generally speaking we all have been referring the assigned == private in
>> the Linux SNP support patch.
> Oh, I wasn't suggesting anything remotely close to an "official" change, it was
> purely a suggestion for the host-side patches.  It might even be unique to this
> one helper.

Ah, sure I am good with calling a private in the helper.

-Brijesh


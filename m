Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8322FDD7A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 00:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbhATX5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 18:57:02 -0500
Received: from mail-eopbgr680043.outbound.protection.outlook.com ([40.107.68.43]:35825
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730910AbhATVqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 16:46:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xsc9DBlyjkk0XxME3BotsLryxXbX10QnVt7yu8pss9JHbaoRuXF4CczgOfDOfrNUMnVqgzcOGXdlv998KjFjGtlBGHi/+GblYF8cIclyC/LN1ispNGxEurz3FptQDipsb8aJfwCuZaJuR6MezaZY6rt9VYGLaBhedHqDiIUEwhb8MAxBNt+yAd+EtBej+CvB2thgp9Cn0ypWSOJnNMWjFIcNWgsfGqAFIT7Qhrm58RZRLEjxEyeh/u+vuWzDbXKTVHaWHdU+NCo1Pzfn6ZS14z8SrFhbcPB1ActYWVl+x9/MxbaPzaY/VwEdMvlX+syMsSxP/QXEwgAHXesMekdtig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFkQnYDh5fJWVIdIbv81QvxYMFT0CCc2L1CGi7N6Sd4=;
 b=Nhbi5UsPaCJmz1yScTq2s6E/wVsDl83FUiD7+MNe64alE/swDOIvONBFAWo2nkvYOQBCvayibgVzeuMkT7cR+sShL3qTfbOy4sQ4X7dGQUltJbCh6pgU6CuZw8YZBgJ6+YpY74aMnNeFlgn0Cv3FfWIR3NqhJF6ZN0eu74hAxz77YjqHD9I3D60LU5mvDcUwzcxh9ZEDzO+BFnziFXvmISu46nLOO+1Jo9s+YEziVl84Fzh7xDTEvyevxzc5gohidCwd/VgTdvi+cS9+QXrv9uk5GNmzvkeEzRQw2OtNjHh5NcwygxcdKpkuGIP6S17VQ5UXa8eSXgj2gVbRMI6r1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFkQnYDh5fJWVIdIbv81QvxYMFT0CCc2L1CGi7N6Sd4=;
 b=dv++sY0TYjul9NAU2KfQ7PAXVfERqTjWuOQC0hXB811PXZrjE0xtIDxuOpCTOJjMxtH7kVq06eEurzvh2OD9+dzEafpWazPXJoPSgyQWGY8NbFEyRj0hW3hsSvRm5R4KwZbU3iXQe5vQcw4uGKhOW4BhqH+c/BG7z12jb7ccpE8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 20 Jan
 2021 21:45:12 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3784.012; Wed, 20 Jan 2021
 21:45:12 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
 <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
Date:   Wed, 20 Jan 2021 15:45:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0095.namprd05.prod.outlook.com
 (2603:10b6:803:22::33) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0501CA0095.namprd05.prod.outlook.com (2603:10b6:803:22::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Wed, 20 Jan 2021 21:45:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8c3e9df6-d5e5-4f10-e162-08d8bd8caa04
X-MS-TrafficTypeDiagnostic: SA0PR12MB4477:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4477343B570D8E4C5319D38C95A29@SA0PR12MB4477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77rsG1XpHtuLbD36nLqzrdEjERTZUlf4xigt9upvkRLoZLrfT1HOjRPsGzs5r/mxEVU4LwNBeJatKUG3MU12awiPd4iEgY39kw3jGEBAMfT8HpmRyQd61p2bsxGxjMLi0h9osO884DFw0lExqE6DyKBpqToItlAZMPtu30qAV5NQK/p4zrzoSMH3x85RGa6U2DsR0yU/PAsJSxXKTgvpDeLoPcHOKXdDguGSSzLev+0MBbbmtOmxlhU4xUpyCo/N3g/2VWRPLnmPjsJh4oPLAyM3SJBWxehq164xN4yoet1bxwtMJgIuscKDhzG7Z/J7SsKUrqDwTcOuTZZLerTmXBmoJ/mnXcWqaUeXCngqcXpWefCxByl7zPi2r3H82tzYVIwbfDLYFkMS0i3N+o3905n67YSKc3q4lHuePjoRkM9npHG3GHYV8xjEb3HpGSfQXcgd4w0Oh8Dnt1Fsd204q1ritJLA+eGGTex9cUYi+fywP2WtoU1m63gkIuR3Z8qXMwTJ3DkF4OGgAupDIo4GTPzrRfD+bqRKsHDc3lvsLLOctQHQx1rnAmxVh5Dh1SBRhv4m++UzaA/GFJAagisOW72TUFbIrK6AJ1QCCZHGlYfIif1DW58vsu57/nGPJIADXaUJCuweYjQAs/nnTPsfkGmRO8JtmIS1RAVss0INEKAHpMpivUGWRKc7RUrRaG9T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(83380400001)(478600001)(16576012)(26005)(2616005)(966005)(36756003)(31686004)(66476007)(66556008)(16526019)(8676002)(4326008)(86362001)(186003)(53546011)(7416002)(54906003)(6486002)(2906002)(956004)(45080400002)(66946007)(316002)(6916009)(31696002)(52116002)(8936002)(5660300002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXdVMlpCYkFyV2JhQmZaUFNnSnllS2srbko3b21PdEsxN3FQZ1VpZGRjbVlp?=
 =?utf-8?B?VjJwL053SVpUdEw4MktSaUVyQVhuVVRkWUM3bTNsYXgrZi81R21CSml4QjNK?=
 =?utf-8?B?Q1FqUUhuQ0JRNXRKb0hBSWRKKzZ4KzhWN2dOdk9ITmNMQzA2dHFHSkUxN0RD?=
 =?utf-8?B?Vit4SG5ubXUrK0dsYVN0RWhleFdibFIyaDUzekt6MitPOW9FL0pZNW1oNDJw?=
 =?utf-8?B?aEZyY01xcFZ2LzBLdTFTS1U5TC9QVnM3Y2x6WUJtWUoyZDVXUlJqcWhvMzZH?=
 =?utf-8?B?eHVXQ2tzTWVQWnVNSTFKbUI4QkFwNXlmS0IrcWw5NDR4VlVVZkZsSEt1b25O?=
 =?utf-8?B?YzQ1SVNOOWpFVW44K0hIdmtqeGl1aTErbFppVXVIclpUYllQMUMrdU1JeE01?=
 =?utf-8?B?OTRpNG50cHE2SVdNck1Edm12Y2FoNU1hWFI2UzdLV3hiVWtjWlBjWUc1VGJY?=
 =?utf-8?B?RkJRV1BaSndQbFNUVEtuT2N1bnFIeEs0VTVQY2h3dDV1NnJSaTN4YVRtcG5k?=
 =?utf-8?B?ZmZsSzJDMjdVRGdzYkRENE9xeEtDekpGK2d0UUN5YkZDbDBFN2s3bWNsdTdX?=
 =?utf-8?B?QVdPVDYwVXpQYW1RQkMvMmJxbmx5TTgyYWRSMEZLMWU2aDQvWlVWOUJpWUt0?=
 =?utf-8?B?ODVIWElLVFBUendBNEFKV0FpRWhyMEpaenBBQ054aXBFL3FRLzdsMDl6amhM?=
 =?utf-8?B?VzhYM0xLTW1wb24xU0dOcTNEMVI5azB5dDFNMy8yN3FISy9UeWlyeXQvWEZI?=
 =?utf-8?B?U2paalVlNHBtYVdxSXlnWnppd0pvcjl2YkdZNThtU3ZFZXg2MEpGeC9lMU9Q?=
 =?utf-8?B?Q0lqWWdsYVdISEkrc3dPRkc0NnZtdVgwMHpCaVVzbGNDRVNITHBCK0RYMnEr?=
 =?utf-8?B?M0d3NzFuSzhGWWt1TWZBU3V6SE1sL1I0UXNaTFkxRU1PN3MzcTg5c2FxaEM1?=
 =?utf-8?B?S0hvZmFvNEVSZVNZaU5TUXhyeHdURVpMeVpDeFZjekV5SmNIRkMxQzI0QkRt?=
 =?utf-8?B?Q25jWnQ0d08vcWNxLy9pQkVwUVBEUGZwSlVxLzVlNDc2Q2VmMVFjQUdFVy85?=
 =?utf-8?B?VWU1UE5pb0dHV3RtYm12a0FQcG0zTEFkbUpHV2ZEK2tISWFXNkdtbzV6QXRN?=
 =?utf-8?B?MTdpNnRRcjd6OFUxMDZRNGRyVmpSZVE5R0g1Q29GTnVUUkR5MmdOeUFUeFZT?=
 =?utf-8?B?UzROWm1GNk8vSFc0akIyanRoZFNuWmM4TlZjUmQzcDMwNnhJVlM2Z0JSV2I1?=
 =?utf-8?B?Z1hKRHNmenJIbm5aRHBzdjNVMXk5WVlnU2hoRFVEMm5meHVlMG5yT1NLZlZG?=
 =?utf-8?Q?f4O1Ptq9DvORRhtJK3P2p98IzgYlSfM1yP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3e9df6-d5e5-4f10-e162-08d8bd8caa04
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 21:45:12.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jczhzvZtWF//EIvwdgV9nS+0s0DCVutR/S6wVvNbjj1vEJrPTZjpJA+t+Gd446jY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 3:14 PM, Jim Mattson wrote:
> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>>
>>
>> On 1/19/21 5:01 PM, Jim Mattson wrote:
>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
>>>
>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
>>>> as expected.
>>>
>>> Debian 9 does not like this patch set. As a kvm guest, it panics on a
>>> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
>>> please see the attached kernel log snippet. Debian 10 is fine, so I
>>> assume this is a guest bug.
>>>
>>
>> We had an issue with PCID feature earlier. This was showing only with SEV
>> guests. It is resolved recently. Do you think it is not related that?
>> Here are the patch set.
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996.stgit%40bmoger-ubuntu%2F&amp;data=04%7C01%7Cbabu.moger%40amd.com%7C507e52200cc5478e3b9308d8bd8860bc%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637467740754159704%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Nxhg4Atzr6wZ1L7egyxQVZ%2FmVCE473%2F%2F5Fi0savgUfk%3D&amp;reserved=0
> 
> The Debian 9 release we tested is not an SEV guest.
ok. I have not tested Debian 9 before. I will try now. Will let you know
how it goes. thanks

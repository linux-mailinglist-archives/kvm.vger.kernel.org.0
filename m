Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7976735A191
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhDIO4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 10:56:46 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:10592
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233541AbhDIO4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 10:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBzAE6d6MbEmhp5peRdGEeRoo1D8vt/yiwpEOyXag7oL+P+CQyH1EtoN1oXUIbripY+jLtTik2mD5L0p/+0JT+voLJB4SzgzKykDMYFmBu+8eBIKiuWQXHAQUz88Dr5go1/IFCaP8B+k+7eZz+lBiD+y+6X4J6GTVqMQvLmynZ+TzHuH1/r1IXWhqcqihgy/dytbg841rKujQkQoVC2CjE6HwQ75zAJBZUvdE6qtY/sRGWb4rx1L16gHDJOl7qI4fyhKFBsllL1iTOB/FLFQGrd9Y6xuzmGXGAsgsYmlR+b8Vd+7EcmZvXWqW39K7Z+G4qFQ6pyoXj0pAp51DdZEsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/pY+/tCBvLiWQ71K4Teq6i0ic6oIASwz/rXopwEvvM=;
 b=A4o+HLZu/H9kqpRkZpl9XIJvqYJLhrCAPdAZVl0RjkG6EAzJw30LOHHXbYGeqeut794aqtb8z4ZpDjGbF4LAE1ZitvQd77trzRdJsCfTzwfehUWUgBFAMOwq0VWs60KNkC8Le2Nt0M44r6/NBIE8pqF2KdyoifX0GnKnK3h6FWaOottV7wr5nfhWRu0+vu8tA7Hsl0N2419KUL7jfYcB9QNsl3ic/+N+tkCBU1tuJ5R2KuWXfs2YWi/a+tHn9MhlajYJAI1VYtXZVXqMp1MepgI40B9KNF+At4utWAGXVFadmDp3ftJ0kLg1EetS7QHQA9y5G8XFK7td73+oBkb+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/pY+/tCBvLiWQ71K4Teq6i0ic6oIASwz/rXopwEvvM=;
 b=hUeCCFqeqizmntqq04HJPvv+x0W4iRAhfOiLi+PoGqDi5EblVHOk4wlrqVAR9sBtwGPgPyzhWyzbqS31NfvXGWlsPiXcLi4nEG+DYEr8FT+DsPuL+xJdvm2eb0YZQf8YyQ84LuO0Q0HxLOtnMklvm4nUnxBYwWXdJkwHilQip0g=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4941.namprd12.prod.outlook.com (2603:10b6:5:1b8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.21; Fri, 9 Apr 2021 14:56:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4020.021; Fri, 9 Apr 2021
 14:56:29 +0000
Subject: Re: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
 <YG85HxqEAVd9eEu/@google.com> <923548be-db20-7eea-33aa-571347a95526@amd.com>
 <YG8/WHFOPX6H1eJf@google.com> <3c28c9bf-d14e-3f9b-0973-ba4a438aaa33@amd.com>
 <YG9d8aOuZKasgw2j@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <87363a29-fa57-a2b2-4b42-6f2cd5e54dfd@amd.com>
Date:   Fri, 9 Apr 2021 09:56:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YG9d8aOuZKasgw2j@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:806:d2::11) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0066.namprd11.prod.outlook.com (2603:10b6:806:d2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 14:56:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7520f009-d294-4821-401b-08d8fb67a841
X-MS-TrafficTypeDiagnostic: DM6PR12MB4941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4941DEB5A5598E760B9E2539EC739@DM6PR12MB4941.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t34PLXjvt1hc2ZsuCIDvCRn+dcX6mfj1KaJncsZx/U0hM3Pc1P3sHeNsl3tq7x0xjMx2yMjAKRFMTUnwAiZabpuOyc+Mnh/sy6GxOwRUpVgEWzDS5xLlqMMsKHI1I9y6MQel1xXjbULK8P78l1/7pio70u6BeA1lWpAEtBVywf0QgzHHNZjC8c6/e+GeJtaU/PtK4XuqeUo4pyDjO1LekXlrCHb6JvsfZOwO6KdRHTantt9kx5nP7OO8tn914ZJVP1Aswp8fAh+VXFrIpl/lk1jmTD1wA3xYl652iy5XAHRp0k80sgxkL1uSsChQL0crs9jkm+piAzu8zRIT7elFTn7Ey3QAAWwGP0Fbf9cqWmTmhwR/yYb97T9fdcof7+c1eBALAuoX5BajE/8g/qrihAI8v+8XWudr0vYy5K1268tefOx95A85iihMw2SNJCIWHyy2lt9MxDIfZJJE4rKLGjsGpypS6dSHOQxU91gYkuW7Dn5kc+GOagyiYmlOT+5m52Iizq8ykp6Tu/cOb+cEdPMzFObo+y/DdI9/F2HC9n5kGspyO2g176gTo+03hPdTRR6sMDpF9LfP4ixKeWfwjXl8D9OijlFjNHIo3c6P9TW46BvQ48Z/cvtzy4G4zK5JmNuQA+FBr48B3LOeWsWwZlQ8Iltaga1lj7aJMqGfk9v7UGqEi/3/15APHvF0OOsSPBfbKhwfBZRZDDs5TqejpO8fw+Swh7iQthM+wQv2TCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(316002)(8936002)(8676002)(66946007)(6916009)(478600001)(54906003)(31686004)(66476007)(66556008)(5660300002)(4326008)(86362001)(83380400001)(31696002)(186003)(956004)(26005)(38100700001)(2906002)(16526019)(6506007)(7416002)(6486002)(36756003)(2616005)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckR3UHVPZWx1dzNRb1FQa2VsUEQ0V1pkUWphQTh1a0tCcng0NVdoVVZnNTVD?=
 =?utf-8?B?TThENFd3c0hnTkNrVGV0engvOHVUWU4yRVNOQk5meHQyYnR6NURhUnRoMGpp?=
 =?utf-8?B?TWVxRnczb3dxbjROWDczeExObkEyem1GNytXVXIzTG1meUZ6YWxZT3RWc2tt?=
 =?utf-8?B?SnQ5NkF5V1I3dHRqUVM0ak1lRmY2RTU4SHIzL0xaNDRNdVAvRFU5OWtITUFW?=
 =?utf-8?B?M2lVY2NXU3ZMVi95UG9yM21FMnJsOTgxancxa1ZWSytWTmFhcS92WnlLSW5S?=
 =?utf-8?B?dFlQSWxFS0RKaU9XZ1VrZkZiUVVHTmVISHl0WTVtWlFxRVZ6aUFZRDB5aVJp?=
 =?utf-8?B?OU01N085eVp6NURQdlJRbDhCY09CdWQ0WktlTFFWTE9WZktPVkVKS1Zva01Y?=
 =?utf-8?B?NmV3R2xWaDRBbktQV0c2QXhoYVhtRVB4K2QxZ2ZvNlQxSWhCbXdHOVZXenY2?=
 =?utf-8?B?M0NMK0xUeG0yeGV1MzFoRklRMmljUk8vWFowMTdSVFhqU092S05pRkRpK2JG?=
 =?utf-8?B?Mm1TcUpsc1hjZ0pxVERPOVA1ZVVTbXlxNHcvVTBsdmV3blV5VTZmZEJlUE11?=
 =?utf-8?B?TnZaZTYvZW5FYlZISUxrRG9TUkhJVzd5OGN0UysxMlpzWFVLNzFGT2tqNnZq?=
 =?utf-8?B?OFBFVkxCcHdjWGVnNldKL0J3Yk85ZXZlR2dNVmlkVG5pbmZMSWpYUTZVNHNE?=
 =?utf-8?B?LzZEcURlaFhuTUtsN2NhUE9KZCtBQkR3Y0JSU0hjaHhBRVJzQUIzQjNaa25K?=
 =?utf-8?B?Qi8wY3FzdTBlNy9kME8xV25uc2xnM0o0Nk5iK3NvN0NaMzJQLyt6RXlUVXFP?=
 =?utf-8?B?Vjh2TnB4bEhyeFR1R004NzdQdkY0VU5ZK0tYSFNXTCs2SGpGZXBxYUtMVU5W?=
 =?utf-8?B?WG9BNnRBaFUyczlXWXdvd1VoOUVVVnBKanhrVFd1Y0huQUFHMlJWa1RxbGgy?=
 =?utf-8?B?aUU4NGFvS0lPVUZjSlZ2L2RHaGpzVzZOVldlNDV6S2dQL2toVEpaVDM1R1ps?=
 =?utf-8?B?bHYycm8vU1lTKzdxbzZML1NqcTB2SlBTcUo3Rms2TUo3R1ZsM00rNHU0ZXVx?=
 =?utf-8?B?ampGL0pTbXJqVEZJSzBRNlhWZXZRckx1cmlacDRmKzdKVHkyTy9nQXFHTDZK?=
 =?utf-8?B?N1pJdk1WN1JZaGNQMHFCaUJDWE9rdHRRZE5SUGZwVkphblVEWnQwMitwQkpJ?=
 =?utf-8?B?KzZ5SjNVS2ZGVmJPakMrVDBJV21qM0JaWEtHWmxsUkpxUVQ1UWNsektYelJW?=
 =?utf-8?B?SWJJSGlsOTI3ZEdUeUtYaTZObHdvem9kTUhKUFN1dlg0U2lJZk5jZEYwc1k2?=
 =?utf-8?B?K1ZXRWs1d3MxV1IrY2pycUxUNWxDYThSRnRLVExEYjFFdXpWajA1UXRwbE9M?=
 =?utf-8?B?NXJ5TFQvQUVtbmVjam1VRS9PMEpCOXYrdy9jRnA5ekI4ZWVaSFpLUTdadXJy?=
 =?utf-8?B?NGpIN1FhSjZYSWxFNFlpSHdzQ0tKekg5cGtjZW1WTm9DK3VkMisvbmdnRjc1?=
 =?utf-8?B?UFEyUGRoS0E1NGxJUC9xRmx0TXp5S3QrQkNoMERkK2RHQ0VscmFLOXBia20x?=
 =?utf-8?B?OEhUeXlxMzBLS1FRR295MVRaM2pNQ0h6ZkNXdFFNL0VXSGpES1ozUm9WaFJH?=
 =?utf-8?B?U1NWL05ZenYxNXg0bkRST3YwcVM5aGpNYXRoUkJrTXI2bDd2QXBzcmU4LzYz?=
 =?utf-8?B?NmZDdldxWTIwcjdSMUFScm1JeVFYYlgyVFl2YTNlL09WNnVuSEpFM01xUThI?=
 =?utf-8?Q?Fe9UrgsuUrZ6TdV8uDgOwJM8vtARSN8QyvfBIMB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7520f009-d294-4821-401b-08d8fb67a841
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 14:56:29.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFogmrHnRFjMIJcQPi8VKmLOxj3zqi4l0U/ufz4+xtzfubFolVx/5fxr1gBEluKrtmlrraSse+pY7rXZQeMd/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4941
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/21 2:48 PM, Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>>
>>
>> On 4/8/21 12:37 PM, Sean Christopherson wrote:
>>> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>>>> On 4/8/21 12:10 PM, Sean Christopherson wrote:
>>>>> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>> index 83e00e524513..7ac67615c070 100644
>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>>>>>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>>>>>>  	 * non-zero value.
>>>>>>  	 */
>>>>>> +	if (WARN_ON_ONCE(!svm->ghcb))
>>>>>
>>>>> Isn't this guest triggerable?  I.e. send a SIPI without doing the reset hold?
>>>>> If so, this should not WARN.
>>>>
>>>> Yes, it is a guest triggerable event. But a guest shouldn't be doing that,
>>>> so I thought adding the WARN_ON_ONCE() just to detect it wasn't bad.
>>>> Definitely wouldn't want a WARN_ON().
>>>
>>> WARNs are intended only for host issues, e.g. a malicious guest shouldn't be
>>> able to crash the host when running with panic_on_warn.
>>>
>>
>> Ah, yeah, forgot about panic_on_warn. I can go back to the original patch
>> or do a pr_warn_once(), any pref?
> 
> No strong preference.  If you think the print would be helpful for ongoing
> development, then it's probably worth adding.

For development, I'd want to see it all the time. But since it is guest
triggerable, the _once() method is really needed in production. So in the
latest version I just dropped the message/notification.

Thanks,
Tom

> 

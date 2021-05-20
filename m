Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0738B8A6
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhETU66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 16:58:58 -0400
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:2241
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229547AbhETU65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 16:58:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1G8lBtknGgxDXCiK4x79SZ/lI45CccmCXc0yMVY2uA8aIOEBNsetWc58rpp5aijbGi3K+gZHKDPk0ybrxQuan287LQp5NBUklPQPr0uZbFxHksjd6XEMyfa1yzfBZs1EDmqnOi1JTdRu+UD0ecRzrTaE3VaCzrxrh/8f+o82DNGc2Om0X52ciKI5iqQ7QhwCJ+9hdeNfVQbd4/IM6Pb7R66HOne2Jo0Kj7SOU7doZyaUfQZ9LhrXzYfHBJTDDaVBJ7KjOHkJc+L2GaDoxY2xRGvoL4ikmAJrQNIUdARubpsJFyEn5bNiFBn1BOS4sVReOSkmthTtoNLF94U7bKykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruYoICjrffxarbYTI+a0bRBGz1I95bNjeyz6MyCvWrY=;
 b=CE9EQIXfzfUccK9jTzM0zZl/NcSAEv/8AjymtMM3Vw6+1ktsWBYuPDpjHbakUePoXhCZ+RjM91Fn20LN3Mn1dugTk1p2k25bE6gSAln7ynnxwlwCDjA6JIN1I1CEjPPrN7tTYmGcFNRtpVoZoyMw1sbnMrMdEShyM8pp/yXUpyfJ2XQFsqD1cn93VpWBKsya7NC2IIvXieKjosSmXKvs5q/Vadssa4lrmgdYv22HFKtOn0U35+WY2s63UoMlrkvgJWs8HKCQb1DcmqolygSIrS5p9M5abAXbyGK5Ri6bodTb3s0NEi6QDLpcKE/0jaWAujNdTy8wL3+9NS3+GvUdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruYoICjrffxarbYTI+a0bRBGz1I95bNjeyz6MyCvWrY=;
 b=T77aDCBlFItcDBhhRq6zRQZpTllX4E7DqysL2uMlNStLAoC1K6JyRToXwEQhc8FbhbwBfdSoFJBjLUQ7JNnxc7i/QWsnoxgrrnSBILTUIig8XDw4i9B4IWYR6nL34+5L2t/WbLzaUwtZn7QjunRR7EbVKYsB/Q1trA+qurxmPVk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 20 May 2021 20:57:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.033; Thu, 20 May
 2021 20:57:34 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com> <YKa1jduPK9JyjWbx@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <468cee77-aa0a-cf4a-39cf-71b5bfb3575e@amd.com>
Date:   Thu, 20 May 2021 15:57:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YKa1jduPK9JyjWbx@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0185.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::10) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0185.namprd11.prod.outlook.com (2603:10b6:806:1bc::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 20:57:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcc28f46-ccd0-4fee-9b2d-08d91bd1e444
X-MS-TrafficTypeDiagnostic: DM6PR12MB4353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43536D079A0797B7C2BC10BBEC2A9@DM6PR12MB4353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: krooWJEIyk4+dkDJGLw8ICui3aMlJd5HFkhOGRsIRik5Yb1I1m+L1ee2E/9NFoU+9ZvpUj9ZNGpY87kVDayWn3y9beSRG6rCqoNZM6Mx3OGYRNb+K2TPxAriMr3vcZt9kY1JdGO0oWAa2sy6OhJmatNhP4pTSzV94TMsUYZM6zutLQM2XpoPWYeCQye+RCTD2hqU+57aGXLL/aCvP1YjaDsx7iq6jBJoyoZ1hKw9u3fqPiCEpTA20C7h57/TFzoRO44yeAmlfInVgVNSFmx4QA5CIJL2dQEmlmIMij2wbNIS54xJtxR+qo7Nllgn/Goen6QHa6kwHV0Lp4XpzL1+LHzfp2jL8dl/4mw8A0+18Y/btx0Y1+S0fANVFJFr4OIQbOf65IRDoyBtkQonKFD8jwohLZDOVe8A7Wh+Plg0SnbVhiIyvpICC/PYcWzJ7LBdLEiUXSpUGijYK7++Wfq+oxom26v6gjA6GZ/axFoftxIBSd1mS/TLGwWw9hjdfPgKs0A/8++cm+QW54uEokcJHuKxbTdy+kJ6XejZSj4eDzoUMbV9r14ihsfUxu2KapFYLbQu2SJ5LeqDC2rdT1hveBtgnBDVMbrEcUt82bNNE+Gtt9JSw37o+Pi2ihHLrJj5An4Y0UpsacDYkDVnolQ92hcP/Dtohv8s0YmE5mAd7HMi4XjITlzdk3dKWjIvcHRv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(16526019)(86362001)(186003)(6916009)(54906003)(66476007)(31686004)(66556008)(36756003)(478600001)(316002)(38100700002)(956004)(66946007)(2616005)(7416002)(4326008)(53546011)(5660300002)(83380400001)(8936002)(26005)(6512007)(6486002)(31696002)(8676002)(6506007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d1Uwa3VhUUYvTjdTMmFrQXFEUDVvQUxiOTlmOGlBQ3F2cXdSUW1wMnp4RkE1?=
 =?utf-8?B?SjFOck1uemsvREI4Vm5BVUYrMGhKdEhSSDcydWR0dEhIV2hpZUhsM041WENE?=
 =?utf-8?B?UUtNa25ybG4zS1NJcTdSU2VWYmkxaWNKS1pEUDMwZk5sQ0MrSmhZTHVPZFBl?=
 =?utf-8?B?Y01lSzQ3L2Z2OEJLN2ZvY3JMT0dveTQ1M01QOEw2Sm56NU1xK1kyWmQzRFF2?=
 =?utf-8?B?djRDQUhOZ2lsNHMwSUJtcWhuRCtUTGxEYzYwZ2NzaElnSDNaMFJTZ2QxL0ty?=
 =?utf-8?B?azY5MHhmZnpDcktQeGVJbk1wd210WkxNa2pWZ3QzUTlyZi83aXJabjVTK29B?=
 =?utf-8?B?bjVRbW5FbjlDWmZ1a1dRckExcnFaYXBrS2FiQnJDOTFYbzFzN2RDL3NyTzBU?=
 =?utf-8?B?Smxpa29PN1BJNUNlZnpSakFRTFdrbm85Q1lQWS9oQ1c1UVRhWk5OU1dac3R6?=
 =?utf-8?B?NncyaXJXUFU2MXZBcHdtcEs5ODQ1R2YzQ0FzSHkzaXU0eEEvNGlWOXZLdXZT?=
 =?utf-8?B?WEN5bWV6VHBQdVBaQzBNaXlKREd0bjJxK3BzZWV0bmxUTG5nb2lYN1VOT0RH?=
 =?utf-8?B?RC9BOWVEN2gvTU1zN09pb2Y3cHhtVXFTYm80Ky9RVk9KRnpwUzdaWlBXQmdk?=
 =?utf-8?B?MjJqbzJhV0hzQ2V5dExFVXRBS3l2ZHlWV1VUajhzRnRiNWl5MERnQk9WWTlE?=
 =?utf-8?B?OEY5UU5Ea2l4TDF4MEVBS0R6RnVqc1NRQzlJWmN4RXdrUlVHUE9yVWplaXdI?=
 =?utf-8?B?Umw1Rk9OVG01K0NXcFJqTWc3ZUQ4blRYaVEwRTVjL3ZGMzJWeC80ZkFwUkVR?=
 =?utf-8?B?RWhZVjc4Y21lVEdmNlRBSjMvNlU1elIwSndlRVlkcjIwZlZLWWo0eENNQ1NX?=
 =?utf-8?B?eVE1ckFEL1NMOE8ydGVvZks4WldSSmJhdXVybXA1b21CSlEyQStHNUlvT0lu?=
 =?utf-8?B?OExwL3lzMW5uMEltZWZRQ1EraFJ3WWt0WWF3bzFzOUVKTys3bXJjcGJZWjZQ?=
 =?utf-8?B?TkpqbWk5cEFKcTlOcmhOOXRpV1hydjEyM3hxNzlIczkwQWRDOGRzenp6ZVdz?=
 =?utf-8?B?aDZYeTJqZEZGUndmWXFtU2o5ck0zRWM1T00xZDE5Y292WnhsK3MzUXBpelUx?=
 =?utf-8?B?OU9DQmVUMi90MzVGT3ZTdnF5MkFFU2VJcC9ZY2RvV3NWYW9tZDZ3ZGNrMVNM?=
 =?utf-8?B?UHNkTU9ZN1k4VkJVbUZLRUllZFFXQ3pHYXBsaU5qSUYvTCtReXFmYWRqblhv?=
 =?utf-8?B?MVF5b0xZaHZRa21JRlBCU3lZY2lzN1pILzlNM2lhdnlqNU9TSkVQeCtSbWFw?=
 =?utf-8?B?cTdHSUY1K09ZbFhZSkFNUWQ4WkRQTi91bFdUVjYrVDNoa1FDeDBhUDdudUtS?=
 =?utf-8?B?RUVBMUQ1di85TWdSdjRmNHhLamdTL3RnOVRYRjU4NkZBdjlYUkFxNzhkQkVu?=
 =?utf-8?B?ZlNnUkU3QjhXbWJrakFOZzhQb04rK2RUUjFFNWJ3T1pxYkZCakowMm5FNnBZ?=
 =?utf-8?B?MmplTkc5SFc1RUhqa1A3clltVklubnZZeGFQb29FUWxOakNWTzUvUzhINWd3?=
 =?utf-8?B?UDdsc0tQdFpuaW16dXdiQVVGazVac09WbVNLMStTUHhtRVBpOWtWbmxPRFpQ?=
 =?utf-8?B?aisxZ21SQ2FOc1lIeTlGRGJpd0lQdFp3ZWNhN2lBb3Vrb0RWRFdGUVF2N1F5?=
 =?utf-8?B?T3VXZ3lYa0xuOWZ3NUY0SFFhdWxmQUVWSXB1NHV6S3RLaDhFWW1aYk0xYS85?=
 =?utf-8?Q?mi58JxzCJ6E2LKqpAgbeKk0QcE2070AS0o2k4uB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc28f46-ccd0-4fee-9b2d-08d91bd1e444
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 20:57:34.2751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdcJ2evRLLj1efdNDjUDQRwCK4bBqVXevhHoS7U28rsudrWG83gFziNF08E6+hSddjMyowXmzsAb4WZHeK/YBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/21 2:16 PM, Sean Christopherson wrote:
> On Mon, May 17, 2021, Tom Lendacky wrote:
>> On 5/14/21 6:06 PM, Peter Gonda wrote:
>>> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>
>>>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
>>>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
>>>> from userspace, even though userspace (likely) can't update the GHCB,
>>>> don't allow userspace to be able to kill the guest.
>>>>
>>>> Return a #GP request through the GHCB when validation fails, rather than
>>>> terminating the guest.
>>>
>>> Is this a gap in the spec? I don't see anything that details what
>>> should happen if the correct fields for NAE are not set in the first
>>> couple paragraphs of section 4 'GHCB Protocol'.
>>
>> No, I don't think the spec needs to spell out everything like this. The
>> hypervisor is free to determine its course of action in this case.
> 
> The hypervisor can decide whether to inject/return an error or kill the guest,
> but what errors can be returned and how they're returned absolutely needs to be
> ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
> is the logical place to define said ABI.

For now, that is all we have for versions 1 and 2 of the spec. We can
certainly extend it in future versions if that is desired.

I would suggest starting a thread on what we would like to see in the next
version of the GHCB spec on the amd-sev-snp mailing list:

	amd-sev-snp@lists.suse.com

> 
> For example, "injecting" #GP if the guest botched the GHCB on #VMGEXIT(CPUID) is
> completely nonsensical.  As is, a Linux guest appears to blindly forward the #GP,
> which means if something does go awry KVM has just made debugging the guest that
> much harder, e.g. imagine the confusion that will ensue if the end result is a
> SIGBUS to userspace on CPUID.

I see the point you're making, but I would also say that we probably
wouldn't even boot successfully if the kernel can't handle, e.g., a CPUID
#VC properly. A lot of what could go wrong with required inputs, not the
values, but the required state being communicated, should have already
been ironed out during development of whichever OS is providing the SEV-ES
support.

> 
> There needs to be an explicit error code for "you gave me bad data", otherwise
> we're signing ourselves up for future pain.

I'll make note of that for the next update to the spec and we can work on
it further during the spec review.

Thanks,
Tom

> 
>> I suppose the spec could suggest a course of action, but I don't think the
>> spec should require a specific course of action.
>>
>> Thanks,
>> Tom
>>
>>>

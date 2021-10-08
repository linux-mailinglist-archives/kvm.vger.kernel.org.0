Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF7542719B
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbhJHT6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 15:58:03 -0400
Received: from mail-bn1nam07on2051.outbound.protection.outlook.com ([40.107.212.51]:8576
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241573AbhJHT6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 15:58:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Unf+kp0+T5Ddbb6w+JKdmffHBw5UPmeO0/shretdnAEQPp6GpvRG6aPCCMYghK0m082jlqIqQIe0GcOfCCNDmRri7hlOl4nlN6sLHzCm+5wzvtdZWMF8koqQkNHNfohEGEAXFJ/xfMDOnNkgBhyFyVdV0zvvg4JWhHbbQLMVPJW411btiviQi91hsPcm04INXUZY0L2RfokiF/LfteBJhaRp7yXZbH1C3QI3/7Ilba8r7JxVbKGjBYRXKwAX+KeBvlcFWZlnCznzkTIFCL9C/iqGzuHo51nhgLuMmcH6MWAvHMEJ9cqRIMV/vreakNAWUZZwfCt5rslB4/qal293OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unlwVg2LYNrhoGpKttMNF1BZumi/huLhtiOHRSWncmc=;
 b=e3GD2iUQVFI9Z2fLGbJNepAcRYh10gAroj7Aoaoe5bfbbzna1IL9uA2JEliYyJDTyUOif7hCxdtmQKQBViUVHgLGhEsXCiKrt+6Dl/0dTFfvABkPr8J5XVeYrGGxfJtZfDSILMCtdjS9GerxIF+n2n+DldaEtxrlThfcUWKecSGKCccYjJqt8cqidkuyHMWTPruEiC22Ogc3CBsSXIs1/IvrWMd7aTgP9cHzxowOeY07wCaZWaWHfJZZ4WKRvfiU90tzneAW2rsZDNhSHEpWwSoknPq1Oq7SwIL5JRGr5fRDaStOVICZWdJ1beaidsSC6vmZRiZtGtuzU+AD64qDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unlwVg2LYNrhoGpKttMNF1BZumi/huLhtiOHRSWncmc=;
 b=lJu3B8DQq0EjcuVKThxxyHJZp2P7mxJK71Zr1amql+vRk6o519EX/zUuep/99Hcusn8OWpFVSQegzidq53FUbqlKWWwlQOQppN4rPJSZM2iSs1Yqin7g6slfkvbT6hljH5DvZbrlYnOR/bUv7tGgcysUErlsuv8a327TdtFVnME=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (13.101.60.140) by
 DM4PR12MB5213.namprd12.prod.outlook.com (13.101.60.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Fri, 8 Oct 2021 19:56:03 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 19:56:03 +0000
Subject: Re: [PATCH 2/4 V9] KVM: SEV: Add support for SEV-ES intra host
 migration
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20211005141357.2393627-1-pgonda@google.com>
 <20211005141357.2393627-3-pgonda@google.com>
 <5f6e6f61-0d34-e640-caea-ff71ac1563d8@amd.com>
 <CAMkAt6oF52BDB4UX7DhVxQygYANfietT=gqJMQOvKJifHpivTQ@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cbc2a728-8c4d-08f9-4524-d198aba7d369@amd.com>
Date:   Fri, 8 Oct 2021 14:56:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAMkAt6oF52BDB4UX7DhVxQygYANfietT=gqJMQOvKJifHpivTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:802:20::36) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN1PR12CA0065.namprd12.prod.outlook.com (2603:10b6:802:20::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Fri, 8 Oct 2021 19:56:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9afbc02-5876-40dd-cd5d-08d98a95a8b3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB521358773F11C3E67FD3D2BBECB29@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syIugRXfYzTJfBntTed6Arr7JWg8sBlzDlptd66Fl9CTCLN0lEUfJVno10xAyV474qkjJNokHCheunMGMb3sAlKHj0XSgmbKXxNoNMqwqvdy8xwfo4Pk6xGgXZ+5JA5vtZYMU6Q7mA371AM0dDllDcH+BHiF0AzbW8J3R1j4kHRXsYqsOfeA5+jc89c+fLK951ekpFJ3s600IN9VfH7P4tNAesmFJjTo6lmM+NGvnRp1RAhMWzyylzlk/n46C9lTxBhU0jlySdYvzGFu16v/3UGMRe/93NLFoh0zLD3kq+RJBkokjWo1ArugTZFKJBkIJ1M6bUjUVZczRYsNZE7GbGPG5SZA8IqE0Kuf1pTpfJ4kTE6M3hNh9VDspPQS9C7jWbTLpRzUTUixlgaQHBcvt0+beX//S/O4l94W4JtTeLpkwZvrFlmpBONkgMw6KrQPYBsIQJ9WSNoS4MnCkihhD5CxAskWGh45m8Q7t4nXeJaYzb4B+6YLuMbFqcdlxEjkaYTwlzPXjjN7EcHiEoUj/hRizp8YsgjKW11RCZGim/CDhIuzMfE8i4j+HRS8/lQt8GltB0mm//D+ygslfd1nVlZu7GUi+lYsUwg/coPokuo2pPOi2OTX3sdqUBIQd+HnSfIE/11F015eLtn5I8/7jksl0tPuje9hCDueJAVb507UXnfsr1bEfnvASe7gfIWvdqQSkMO+tKg3tZIkr8CPUeLJFg1T0Ecm11RkKgrn+TMRwEk/Y3VCG1yim+2ZRTaC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(36756003)(38100700002)(508600001)(2616005)(31696002)(5660300002)(4326008)(31686004)(8676002)(6916009)(186003)(956004)(54906003)(316002)(6506007)(53546011)(66476007)(6486002)(8936002)(66946007)(7416002)(26005)(86362001)(66556008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDUvbnpwYmZrSll6REowU2R2ZStxeVE4TzJIRlJzQjdSQnNHeWdHUUxmOCtr?=
 =?utf-8?B?SlVZcENTaXRQMnduVmx1YXdDRmMzRnk1aWVVZG1NcU1TUGxmU1FrVzRrdEda?=
 =?utf-8?B?cU1zQTZQQXpQemVvWHIvUGNUb1JJa1luVlVMeGUrUWk0eFdQeWI4YzMwMDhR?=
 =?utf-8?B?UjVRUUkrcUJXdEJ6OVFlaU5NakpEOEVVYlJqMVNUaDIyNjlQaXdHQmtrSENE?=
 =?utf-8?B?aEtucDU0SUE1S1VaMy9QYmRzV1JJM2tmUDN4R2h1cEJQSTlqUUxSdXJaUEw5?=
 =?utf-8?B?cFczRWwrbzI2WStCY1hOQkw5ejEyZEY2cnpRVXFEMlNJNXh3dzdYTjBBRStB?=
 =?utf-8?B?d01tOGtENXZCQUpQU3lIR3h1ODF5Y0JXRHltMG4rNFNKbjJnWXVscVFadHh1?=
 =?utf-8?B?aXBZVE56RFdGb2Vra08zc1JQYVRVME1QVGtrYW9yYisrUmd0ZEtRNmtOUXln?=
 =?utf-8?B?R0hyNzhNY3NacnZHRFdra2JGMmlzYXRzcWVJMlZkdXBWR0dRLzNVaTl2RDhJ?=
 =?utf-8?B?cFpsWHBrcm01enZyc1ZCTkxzUEw2UjhMZWdDcXNVamU0UkM1QWcyQ3JwN3hI?=
 =?utf-8?B?Z0E0UEtveml0OTA1N1lST1JuRTFlNHIwKzNZRnBURi9lR0ZOeXZ1U3lhNWhI?=
 =?utf-8?B?cFpUTGZJQitSc0VZS1JTOUVaT1BxMlhWSG9vc1UxdXY4Q1pvcitiRmJ5YlBy?=
 =?utf-8?B?YjVHRHk5RUFvMEhwZVdDOE9lTktaR3pTLzdzZW5nMXgvem8rUGUyWDA2MmtI?=
 =?utf-8?B?eEhUOUJRK3czVXZHTDhDODd5cm5FaU9IRDRnY0cxdnYrOStxTHExaTl6dDVw?=
 =?utf-8?B?SlpzKzBlK1dZNlA2cUU0WjAzeDFZaldNeEVvOU9Ud3ZoczVIUk5Kc2dGZ0JV?=
 =?utf-8?B?TXl4ODVpbXVJRVJiUytMTDJkYUJxL1lLY0xrQVNHeExTRnkrL0h4aXYySDJa?=
 =?utf-8?B?TnNkRXZPRnRsUExZbFB5M1Yzdm9tNHkzT1IwUWs0aWlDK3pjWjNjMmloWmZV?=
 =?utf-8?B?M29rcXdvR2k3SDQxWGg3bG5oZ3AxY3psNXJyVmRObDNCZUlpSzZ4K2NpM2ZI?=
 =?utf-8?B?NE5VeDc4M1MySitYNkRDSHNzdGtsR05ZR0N5WGRNRTFXYmhJdXpYOUpaUHZM?=
 =?utf-8?B?VzFKOWFuUWpiK3RuR0Ftc2Z0NGpBcmMrV1JnS1EyRXZuNStEWUxEamFRUmRV?=
 =?utf-8?B?NVp4YjZaQlRWc3NhcUdZYndiN3NXaEc5NTZWemp2bEdNSkpaRFhGeFcxYVZs?=
 =?utf-8?B?ejRUUXVNQndRTzJ0Ty9VQ2d2SXNrNmFESzB3TWxrVE9wU2VNYW9ZbWNablZR?=
 =?utf-8?B?b0ovUlBBVlZJdm5FUVVBVi9DMks0SzZnZ1JSanBBZXFsUTNERzI3Ly9TNHVV?=
 =?utf-8?B?Mm5oQjE1K09kdGVnTERZZng5WmNKRUo3bVdRN29RSFVMZ3lPWHRScGxhNC9k?=
 =?utf-8?B?M3pVYnp0aTl4SHA2TithNHVEdGxtZEVkTytvSnQrVm42bkxjalZYb2RmZGpS?=
 =?utf-8?B?b2hwMjRHYmZqemU2WkR0c3RpQnVPQWp5b21UaW83M0IzdGhNTW9rWkU5My9T?=
 =?utf-8?B?Y0NtWFNPNXY4NDlMNGNPUlpmSFNLbTBNanFEZlNxcUs1SklqZ1VjemJGUUJQ?=
 =?utf-8?B?dUc5U21PSlZnYmk5d3huZjI1SUs5ZElVaUNYZ0poRFBVS1lCRDFheTJWb0Fv?=
 =?utf-8?B?VG9mNjFTaGpjME5xdThrS0hudjc1bjdXcllidUJKNU13c1lHaTJkeTdROXZh?=
 =?utf-8?Q?/yF2j5Kp5mMfg4ILyLPf5Q9ePh4tM7FYLMh4Cft?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9afbc02-5876-40dd-cd5d-08d98a95a8b3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 19:56:03.6359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iujexkk0SPMS3cxet/ukMmUHjOXziuhuhUCUlHNSwz3QxbSfuuKLlspqF09QIhJx8Glv73rrQzZJ03XmlveMsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/21 12:26 PM, Peter Gonda wrote:
> On Fri, Oct 8, 2021 at 9:38 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> Would it make sense to have a pre-patch that puts these fields into a
>> struct? Then you can just copy the struct and zero it after. If anything
>> is ever added for any reason, then it could/should be added to the struct
>> and this code wouldn't have to change. It might be more churn than it's
>> worth, just a thought.
>>
> 
> That sounds like a good idea to me. I'll add a new patch to the start
> of the series which adds in something like:
> 
> struct vcpu_sev_es_state {
>    /* SEV-ES support */
>    struct vmcb_save_area *vmsa;
>    struct ghcb *ghcb;
>    struct kvm_host_map ghcb_map;
>    bool received_first_sipi;
>    /* SEV-ES scratch area support */
>    void *ghcb_sa;
>    u64 ghcb_sa_len;
>    bool ghcb_sa_sync;
>    bool ghcb_sa_free;
> };
> 
> struct vcpu_svm {
> ...
> struct vcpu_sev_es_state sev_es_state;
> ...
> };
> 
> I think that will make this less tedious / error prone code. Names
> sound OK or better suggestion?

Those names seem fine to me. If you want to shorten them, you could always 
drop the "_state" portion.

Thanks,
Tom

> 

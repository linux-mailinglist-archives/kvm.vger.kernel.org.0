Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C6E1CFEE4
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgELUE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 16:04:58 -0400
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:12177
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbgELUE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 16:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8YjTLwMongEuNJ2XCAJeERQqLhPVj7Q0PVYtVoWhCNTtegstJJyMXP9eE/8hePKfZhID4GiWCEkc6oXb1i5KRem9UpU6xkkUuhdJXssRz9XhIz68aThAk35CvXy136kXcc5IZ2PSZgNcJjE3QiU8u27xtnIpsKIyDU51HsjyPbOFd1k8D9opqWPY57ueuRzWtK6HBvOqvNH2MTi6vzEpAJCek+ybLVhuqlQlKhglZfvH5PTBpbrtqj+kOtoL4DJoum0uVpJZ704+9fwCQDivmQnDUPJEgrtKWsHiDpnof9YhMjXaHcJuXK/gFUsiUXzdfvvDuemwaKkqIFWGQ/UyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4p2zMGTGdHA0f4iwmc1hdiNbVT7RdFEKHFtr9hn2K0=;
 b=cpLs8UGspfVx6TVxpMM9skZq4DD44m30oTRX/MsCm4xy/lRLpK4qhLS3HQw2Hx+nydUYNhR5PMpI8up2t0Q49JRm6K9A4IYY3/zr7h8BxFqF9b711Qig8ppZK7eVZsHmCl4QT9P1mlSahJB2zGLWqwknHNQoL1ziVawhgctQNmLgC9yIibYPFpi+bfeL1wEXApZxucaUwt+Y8E5j75e2I8/REzf0BWe4ZxQ/UZJV2Mo65HAwZK+fE9Mj/HWUBeHtjtg/DKpw/JEn4L4bLmYc7AyYoiAnlB8QZzBYAwzsNWopgRZYoDTufHf0Qmiid84Ls3FZ5xe0SvdwUXvSIPqTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4p2zMGTGdHA0f4iwmc1hdiNbVT7RdFEKHFtr9hn2K0=;
 b=Mg45D18rP+YuBGnK46H6rlxVwWGq7SmR0JMGLQS8OuJuynErp5HOo8N63SsfvNk205F7PuWb0Ojnt8KCriJluX/Aow10l/0TznZy0HTDGbg4fRt+qZDr0YV6SL2l4oXivJO6ciHTGs91MSot1qcjpsLVWydukHNucTbM1IFv/ck=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2398.namprd12.prod.outlook.com (2603:10b6:802:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 20:04:52 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 20:04:52 +0000
Subject: Re: [PATCH v3 3/3] KVM: x86: Move MPK feature detection to common
 code
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
 <CALMp9eTs4hYpDK+KzXEzaAptcfor+9f7cM9Yd9kvd5v27sdFRw@mail.gmail.com>
 <2fb5fd86-5202-f61b-fd55-b3554c5826da@amd.com>
 <CALMp9eRT69LWGE8dZVuLv2mxgc_R3W1SnPswHkhS8K0ZUX_B-Q@mail.gmail.com>
 <20200512172800.GB12100@linux.intel.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <4a9cc633-f530-8d43-3b8c-b83822597506@amd.com>
Date:   Tue, 12 May 2020 15:04:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200512172800.GB12100@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0014.namprd02.prod.outlook.com
 (2603:10b6:803:2b::24) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN4PR0201CA0014.namprd02.prod.outlook.com (2603:10b6:803:2b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Tue, 12 May 2020 20:04:50 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23731e78-bc0a-4012-af9d-08d7f6afbb7c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2398:
X-Microsoft-Antispam-PRVS: <SN1PR12MB23981299CB204F6A85710F2995BE0@SN1PR12MB2398.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNCRuVFqUc7U3Hmgnp0O4UOdj0SdVqPSKjFe1kTUDkapnKvZeIL/rfsKeDxXjwAGAVYf8+sPCFENQBLCc8skQVK03hF6CzV5NUwPsYe1Pu5uHv1+PmMcAUBIV0p1/nG/iolPW8zBV47R5mUcQz08CbIhf+z2dzp5ZIM4vHLei/Q06/PmYY7mhME9EFNLNY/cBbnAkJ/F5GHWXGH1RwuperowMshgvZYFzSTXQzxnT0uYMwAGcrQKdNODSUMKGeaOV/yovd/A/y4Uabp74B7f5CYRymuvWuXWdzsviSywR7izTAzU+IOiEaz4x1p29M5HvgmAUm7Uh6+mFaENaUlxmWseZ33MvSNBno2F5Ipx810p7tgbkpu81gk6rfJX7t4XSMIiBWSolXL7IHF4Qaeh5JRnQvazAjuxrmwAdj3Psm38vXZJl054qEtC2Ey7u5HTVO2vE68PpJoP15orWjDst+74cA0sR4NXlP2XrKwoEuJL1Di0Rq3ABy8fkKPu3OWCBijJsbhP3+1Rc81jk1H+CFG4b5x/XftnQP3zlKfQX/OyT61Ij5gRjrtuPVSkunVm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(33430700001)(8676002)(44832011)(8936002)(86362001)(5660300002)(7406005)(478600001)(31696002)(52116002)(66476007)(66946007)(16526019)(4326008)(7416002)(53546011)(26005)(186003)(66556008)(6486002)(956004)(31686004)(2616005)(54906003)(316002)(2906002)(16576012)(33440700001)(110136005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FrhxmY84Y9q5lU/xp8KHpZxOnz2prdXLXOA46M29fGYCRljMH8zwqudzW3dlreIGMWE2K/BH0Vl/+ddefjJ1lYHlSuayHhf8Jk3DwslmfLpncA2tAe7RpuUqDSXBCrF1ZkkXxTFyu5n6SJ+OniB9UbBqZDSwcurmQyShqud4yXs8jOX2yQ3VNTM7JOWyUXII2dAFjMfMdD5JwI+akyflF0rAtMPl+tJQogRC+fH4t6jNDNF9L+0nW/qZTPL+KNRypj+mxf9WJcRku12MEvn8yBjSAmAcvRrT2Mgy2v7cLCjaIUV5cATOXz8SaHnmV06ARXyv0Rd/EVImzm2L0hQK1rACvQqU3eK51QilpyoXe+npBTROirXhe8wvN7d9pwP6JeDRUVIp1353kJYkEGmIoVWo66BHq6upfmGyKWYgO2ql0b3tsASTqH1wdNpoDCjg/cTOM9U19MEsA65v2xwxAvOcZbMCpdQHQyIjAFk8ciI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23731e78-bc0a-4012-af9d-08d7f6afbb7c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 20:04:52.6612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hoVZTVZ5kv+BjKxtelWChQd/WawNonz08dED1SR4WhG+hr6kjqfMI2iT26NqU+CD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2398
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/20 12:28 PM, Sean Christopherson wrote:
> On Tue, May 12, 2020 at 09:58:19AM -0700, Jim Mattson wrote:
>> On Tue, May 12, 2020 at 8:12 AM Babu Moger <babu.moger@amd.com> wrote:
>>>
>>>
>>>
>>> On 5/11/20 6:51 PM, Jim Mattson wrote:
>>>> On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>>
>>>>> Both Intel and AMD support (MPK) Memory Protection Key feature.
>>>>> Move the feature detection from VMX to the common code. It should
>>>>> work for both the platforms now.
>>>>>
>>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>>> ---
>>>>>  arch/x86/kvm/cpuid.c   |    4 +++-
>>>>>  arch/x86/kvm/vmx/vmx.c |    4 ----
>>>>>  2 files changed, 3 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>> index 901cd1fdecd9..3da7d6ea7574 100644
>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>> @@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
>>>>>  #ifdef CONFIG_X86_64
>>>>>         unsigned int f_gbpages = F(GBPAGES);
>>>>>         unsigned int f_lm = F(LM);
>>>>> +       /* PKU is not yet implemented for shadow paging. */
>>>>> +       unsigned int f_pku = tdp_enabled ? F(PKU) : 0;
>>>>
>>>> I think we still want to require that OSPKE be set on the host before
>>>> exposing PKU to the guest.
>>>>
>>>
>>> Ok I can add this check.
>>>
>>> +       unsigned int f_pku = tdp_enabled && F(OSPKE)? F(PKU) : 0;
>>
>> That doesn't do what you think it does. F(OSPKE) is a non-zero
>> constant, so that conjunct is always true.
> 
> My vote would be to omit f_pku and adjust the cap directly, e.g.

Sure. I am fine with this. Thanks

> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6828be99b9083..998c902df9e57 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -326,7 +326,7 @@ void kvm_set_cpu_caps(void)
>         );
> 
>         kvm_cpu_cap_mask(CPUID_7_ECX,
> -               F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
> +               F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>                 F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>                 F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>                 F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
> @@ -334,6 +334,8 @@ void kvm_set_cpu_caps(void)
>         /* Set LA57 based on hardware capability. */
>         if (cpuid_ecx(7) & F(LA57))
>                 kvm_cpu_cap_set(X86_FEATURE_LA57);
> +       if (!tdp_enabled || !boot_cpu_has(OSPKE))
> +               kvm_cpu_cap_clear(X86_FEATURE_PKU);
> 
>         kvm_cpu_cap_mask(CPUID_7_EDX,
>                 F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> 

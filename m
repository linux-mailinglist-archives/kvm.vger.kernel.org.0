Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA81CF8B1
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgELPMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:12:50 -0400
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:6079
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbgELPMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:12:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/ZirFTrxPftk5Ig1K1Ox1AQAGOuHydD1XnJf1dlyqVDg8fCm0LJKZiwaF9JfBC0sXuNLDgw4L7j5OSFnLkZvfH4XFsWd4AVMfM2I6H/P26cWMe1cOwvJw2f9ydqwhCyNHUVBqnzZgXgs2mQwDsnTb97yUQ1zcDAMKx7VnB9G4PjTRBFGx+aAuagkEAyFtA/Cj4NvPpOcKCFy5iyShl1hg6xQYPY5RXAD8q4YqaD2srHh4esO9XoR5TlVc/8Hn/QWYL5RAHZiMo5txSq0YH5YHOJDFNI+l92tve/9TQDFlFjGxCls2DWGtuQh/o/XPbFkzQnauSP/dwAMAl90/9u6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grQjHv6v9NgO+7HeEcTRhgwl2zoWSnFEWFFFrjn3M1U=;
 b=PNNpw06DaGBIiVNq7t1CmhyzqjMYzczRh86q00JCeWzdzVhww9M4eaVyH2KCpQCgJ0UrqYxT5cre9nEpipSllloGOV8V4uxE16FPWQEAx4jK5zQ51+zSt8hRlC+unKkwywjI6DeI7iwecVnUQgMTp51neRqQlGx+HXrfeA/PksSfbWOrYPlgC5+AW+1QFx8v6gQcTdgUVAzihJNLl0BYqcmXqLarq61tOV2e9H5g7k3ofUpeU5232au1DCJGAsIAhPW7y+7ygmCkN24BVFdMMK5meH8C9Z3tJUh/K8dZ5coep/DAnTbg6+DaTHE/47XAXeUXUoDwpNvux4z5wfxBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grQjHv6v9NgO+7HeEcTRhgwl2zoWSnFEWFFFrjn3M1U=;
 b=yGVvIKUyGzQ7rXmwUfF2Og+Ojm/JkOnrFceVuu9nhPcJhA0HfCJLbivw0e1b4V+AtIw8QvQ0qp6hNNAK36oKXBAlpch7WFyAxfvRHgCQMvmOJ5XGIPpoWKp8y7SVJjmsaEUTTlvJEJiBo5omVmu1cdFcYoX0H8Gjl7yoFYOZMws=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2383.namprd12.prod.outlook.com (2603:10b6:802:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:12:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:12:45 +0000
Subject: Re: [PATCH v3 3/3] KVM: x86: Move MPK feature detection to common
 code
To:     Jim Mattson <jmattson@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2fb5fd86-5202-f61b-fd55-b3554c5826da@amd.com>
Date:   Tue, 12 May 2020 10:12:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <CALMp9eTs4hYpDK+KzXEzaAptcfor+9f7cM9Yd9kvd5v27sdFRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0129.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by DM6PR02CA0129.namprd02.prod.outlook.com (2603:10b6:5:1b4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30 via Frontend Transport; Tue, 12 May 2020 15:12:38 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d909ab9-ab2f-4d64-d50a-08d7f686ec6f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2383:
X-Microsoft-Antispam-PRVS: <SN1PR12MB23833C84E1001E105F36C3D095BE0@SN1PR12MB2383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJKtsJ2CYHPtmV4I5oJotqNxyBqHtf60HfgWbTpRxp2xoqaB8fQVZ2d9vYlsOjlHybL3q9ZWIw2EoaWBJn0q8YFlOaidsgewX+1/nAxVRF9v48FcFQS/pJEiL9JvpcV7YRnPthq0NVwn4IlhC3nhiGHCjXiIDBA1hL8JlgrleuOnfBSQJlDROHitW9Vr1Uog24ZnXQFqGSHKDToeiGjuTNKe0CQiJfumWlG3imlIUQKGuNNHwqmku3TKfnGe9MkfqSjnc7tZDG/AYLQBtFOPIPnkf5m/nPi7dWENaj9Veq4+Mb2Xv5aimCoYrvD0XcW8ZAtZWPCQ/iOhTemvy6Mvxak6c5R6WTIxuu9Ob4uZECG1ke2ByMo1IR+PfyH2fcuLuxZXTl3ZiD6ES5K5WcS5LE2+Do1GAyqxV3gXTl6D7HXFRJMPiMZAWXvl+SI3rRyI15OEE+R5uRs0dia+0birN7qGYRXVD0b1AZDPfFKRVZRt6mGkowLQlINWH+uQHsxshxNH1V/moMw1khLotOWnRhCAyAIm10nLy7Z5VLOW818qvbrJ3BwbUTaLCO7ORHar
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(33430700001)(4326008)(54906003)(31686004)(86362001)(2906002)(52116002)(26005)(66946007)(36756003)(33440700001)(16526019)(186003)(6486002)(66556008)(66476007)(53546011)(316002)(6916009)(5660300002)(8676002)(8936002)(31696002)(478600001)(44832011)(16576012)(7406005)(956004)(7416002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uI/lB5+wueXlcnly3YUiRrLFvXxdKy5QSSLBNIzgQsc8q9lv3KEDvpaxuqiMDDH9lg4fFYp+m3HuYUlgCSzADaK+sfDv4Lw335xHeOftKmdNWXLW3eA3HbDSmaA8EsGTZqzOE6dSRnoS0vhMzDEXmo4+LOslz5K2YiO2A7AWw5tI7/Ah0dPBJz6nbeWwxNs2DOVW4qzC3Iyu2Nuhc3UQ5LgAMyh7ujKtb+LZfUdu9VgypJavafyIn7oQ0J2rRQNoQQI53mzWhU/m8sVJEa2Ax/ztJbMtoxP0haNcOJdrrMAdXPfGCsJlOH1jOF718kK2PODV9LOE+d8AgyVeaUu6rW7NZ25QAO1HM7OuhU3dMAx/KKCRduSjThUVRuUgrw78mvLQaCF4xLjEuxtpCICkBR/oNMB8Ev8v7fKGF4bm3d8dtpFJQUveMITYTk4y/hDboOfKC45sO7K2nZk/Q4O4PoUJeVUYea2Q6e0YgvpbewU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d909ab9-ab2f-4d64-d50a-08d7f686ec6f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:12:45.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3Iz7cD7D6vvrpallsevlWHLLT1Kt3/gu9MechQ6UgcT6DShvZaPMqRZ9/IzVV2/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2383
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/20 6:51 PM, Jim Mattson wrote:
> On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> Both Intel and AMD support (MPK) Memory Protection Key feature.
>> Move the feature detection from VMX to the common code. It should
>> work for both the platforms now.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/kvm/cpuid.c   |    4 +++-
>>  arch/x86/kvm/vmx/vmx.c |    4 ----
>>  2 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 901cd1fdecd9..3da7d6ea7574 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
>>  #ifdef CONFIG_X86_64
>>         unsigned int f_gbpages = F(GBPAGES);
>>         unsigned int f_lm = F(LM);
>> +       /* PKU is not yet implemented for shadow paging. */
>> +       unsigned int f_pku = tdp_enabled ? F(PKU) : 0;
> 
> I think we still want to require that OSPKE be set on the host before
> exposing PKU to the guest.
> 

Ok I can add this check.

+       unsigned int f_pku = tdp_enabled && F(OSPKE)? F(PKU) : 0;

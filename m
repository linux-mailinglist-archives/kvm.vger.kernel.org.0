Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2E1CDBC0
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgEKNtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 09:49:13 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:30209
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729741AbgEKNtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 09:49:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHuZUG2XqDiAeHEzHG7stEjJ9queoLjmTmJNNsDVzkkW6PzrIkAJBykfQNro4B1CGTwYs44XZEV2QgzNbETin7krautx0qIGn1qElcxNKH87BoIEUkAZJgfJC2t2qq1TEYpNAqBFdpA4/TBKSgHNhmZEuoHMO3IqDCQv/WhPdGejNy8dEVeDQTq/xDObkGHIkM6b1e14dcMrla5olbczX1DJaXhWVZ7+siUq9A5tyjlc0JKLiStrbu1zp78f3bu9+r5H80C5/EzQN0CSkrAAO1psdee0Bb3KIEJIOgGR/pvKQfLrTFQWck3NAKKPkX/7uYVnT0OOq/iS03YSWZvWCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo/7Jq60TiX1A69TavXWGlbg4Qrw0AlJdWNoNLqVvgQ=;
 b=UdCfyBl/LhjTU/PaKsA5TtvnyfGhwhpdAs02bM4FxhuSJ3Qmt6DF7YSj1+ZWu7yjLOt4hnAYixZqvBI4+CcXOJWeVxMt8vw8zbcGMrE6uQ1ez125o8Ls46WUUFbA6kMgRh087fQS0DZGu9hcwV/Zb2Wccb7+fThnVSE17WcvIsTNBdiCvx5c+N2yoD5u+pNi9Qwye4S8LqVSNqbNYcS+DSlXsfBlVcFKJAonPmkiHCatIzuzHXUzYy6fK97TT5dGc71s2b9e9EHOlNOES5xY5OkCNgUOE/3Lr19+b4bGkTC0HUpuC3DI9WBzOTRcdxW9mvTvQJJ28LgBwAp0zRSioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo/7Jq60TiX1A69TavXWGlbg4Qrw0AlJdWNoNLqVvgQ=;
 b=2wMyGPfa+vSJh8OmEp9jeTC0qKEuaWjqKwx22tyw6DOCvyvmnrXCmkB6BOV2M64MO86em3Va9vhg7zjnOlJCa7e+IhEZZbcQ56KO4IXpe7GittCAtPrl91+aLQLzpM4ipRuh0a6vGVHU6itOj7yJYy6DeUZg9KVfIuYz9fUalL8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2558.namprd12.prod.outlook.com (2603:10b6:802:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 13:49:06 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 13:49:06 +0000
Subject: Re: [PATCH v2 2/3] KVM: x86: Move pkru save/restore to x86.c
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
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
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>, arjunroy@google.com,
        logang@deltatee.com, Thomas Hellstrom <thellstrom@vmware.com>,
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
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
 <158897219574.22378.9077333868984828038.stgit@naples-babu.amd.com>
 <CALMp9eQj_aFcqR+v9SvFjKFxVjaHHzU44udcczJVqOR5vLQbWQ@mail.gmail.com>
 <90657d4b-cb2b-0678-fd9c-a281bb85fadf@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <6bdf365d-f283-d26c-2465-2be28d7b55bf@amd.com>
Date:   Mon, 11 May 2020 08:49:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <90657d4b-cb2b-0678-fd9c-a281bb85fadf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0011.namprd08.prod.outlook.com
 (2603:10b6:803:29::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN4PR0801CA0011.namprd08.prod.outlook.com (2603:10b6:803:29::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 13:49:04 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26426fb4-81e4-451b-fbf2-08d7f5b21279
X-MS-TrafficTypeDiagnostic: SN1PR12MB2558:
X-Microsoft-Antispam-PRVS: <SN1PR12MB25586C6D51AA7B297E0D3E1C95A10@SN1PR12MB2558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0q4Khsa0gyZsctNlSgdFblXEQwSVvw+pEXSCB2HgYZ4jJNzi54y1AL/rz9siNJakoTctxBR13Rq/m5MH1FjcnOWuGfeYRi/XXmxc0Ky8whvl1kMiohZpG5jGDl+C0Bky7v0jezGm+eK4y4r0zexcjAIZc6nu8QBhAW8mG3wkdhTg6ahwKHmBEvTKdqctxmL7SnL5bDgzNJkhysb5A73a53f8QSDrer5B7rsAtrBDj4lo/3vTqpn7bbPdDqVf9pw3uvNs+MuCOSlYG9KkrskzmhXQUecp8fP6VE5FkPFc2Z806CnuyFfqR+SlUgjAjzCt3ALdvc2h7aLh5xuwLtbFZ7A3iQZvKzVxXAO8oBWBRMxI6OJxs1rcW5T15O7Ob02krr0cYQMbD6JsCLEXlhUxdJ/eWfQA9244tiDVQoOw6w1i8MvU0Ui5LyXc4lBk6GpS+JL6khLMGJJ/A5nxOf4d8E0EO4Y2cDeWDrOHCrAkgkXj/DV2LkpJ/l4HxsqVXgRfelsaacZfx59FM+YJLjyLWaE9/MWA9w4DP+M3d/3QRdDVKcNqmPbRnMiugNjC/K+4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(33430700001)(4326008)(478600001)(5660300002)(31686004)(2906002)(956004)(44832011)(2616005)(6486002)(33440700001)(8936002)(7416002)(7406005)(8676002)(66946007)(66476007)(66556008)(86362001)(31696002)(36756003)(52116002)(110136005)(186003)(316002)(16576012)(53546011)(54906003)(26005)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7TRexuNWePNl69CPRTLGZWlWACB/bfW8H9JBg6EZ/+TIZ6aPcJtFf57O7+XheQ8wvyRFaJ0LIG1UCwj4GpWmZ9JCiHA4gvEogzfThUDTqhNMoXpFMWjScCSr70dNixY4rkxL5Jpe5N2d1FSDqUpMNwS/9FzMqgCERT1JzracbJFm85bLThY+Hamz7XzwOBGb8sce78MjsPSl510qUKz5WJ8S7YAraW1Is0aAYPelx2ykiuN7HeuYfvgQArhqoZmApOGcdTq9ga17tnk8oXctr0Mgzbe+YNrzkwxXY3u64sk6Qb9/m3q3ffNjB46FWsTch5fi+KEJWcQ7tEaigqNkm1ykCvYpgjNUaPYgSCkz6h5rs87W/uhluvVEfV0VSP19nr86gVMaPW9PQT8IJqnp+DyUwZvLcXRWCdQIyvP8Bcuo7HcPqPoLy6Ppm1vL0DcwIcUJlqyN/XMWQFWjoqF+92yza1Pk++56DqBcgxjlyk8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26426fb4-81e4-451b-fbf2-08d7f5b21279
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 13:49:06.3320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5tsROczz7DxGoVULoFTlsHU7rmiIu5R5sw4k6lI6YQTTHH7AxI7r6AQP1J0HO9K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2558
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/9/20 7:59 AM, Paolo Bonzini wrote:
> On 09/05/20 00:09, Jim Mattson wrote:
>>> +       if (static_cpu_has(X86_FEATURE_PKU) &&
>>> +           kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
>>> +           vcpu->arch.pkru != vcpu->arch.host_pkru)
>>> +               __write_pkru(vcpu->arch.pkru);
>> This doesn't seem quite right to me. Though rdpkru and wrpkru are
>> contingent upon CR4.PKE, the PKRU resource isn't. It can be read with
>> XSAVE and written with XRSTOR. So, if we don't set the guest PKRU
>> value here, the guest can read the host value, which seems dodgy at
>> best.
>>
>> Perhaps the second conjunct should be: (kvm_read_cr4_bits(vcpu,
>> X86_CR4_PKE) || (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)).

Thanks Jim.
> 
> You're right.  The bug was preexistent, but we should fix it in 5.7 and
> stable as well.
Paolo, Do you want me to send this fix separately? Or I will send v3 just
adding this fix. Thanks

> 
>>>  }
>>>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>>
>>>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>>  {
>>> +       /*
>>> +        * eager fpu is enabled if PKEY is supported and CR4 is switched
>>> +        * back on host, so it is safe to read guest PKRU from current
>>> +        * XSAVE.
>>> +        */
>> I don't understand the relevance of this comment to the code below.
>>
> 
> It's probably stale.

Will remove it.
> 
> Paolo
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFF24795A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgHQV4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 17:56:45 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:28385
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729044AbgHQV4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 17:56:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1jI5Xg/H1THE485nYLxfh/HaRDr/rBsgzHlCSj1NG4HhrKjoySra9boHoMIa6HkeB9i9g4judlYHL88wkpcGF+NakzulaUszoNGawurlbVnbX0tY9AbRU3LAAcNmeuha+oPt6qKMk0KAiVjeehJzgUFqUELIR4+3XvUAEptWrOYjTlrvfNLkts+uFmAaS3BUzUCoN84SSzKP7n8zqAfUPtC46qRNuTzkVegT7UzKmoAZgMI1KjWNb5L8thOUrjy2RRYPfOZ7ScN/teTavxpEfoIZLbTNkFOkVBqVampja9Lt/XXW7pkxvPn2U4njYymyQ2zASCGoArxrzC8gKTZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPoQi+9ysdKHHF0b+5LwYxUGgwRkjASCIqQ7mS9L1to=;
 b=RQ996x2icwN3p8VCUvXamX549MmwXqB1/Tbpp1NRMRgKkR+8lHCd3Pe216tBzXC6cieNrMp7HfWOr5GqSeILAMiB2tnltojvDSu/zAwHQ8TCCkdnL2PD4078mFZAYuD4Q0TgQ63iDhrItBoS8ZS/pqFehsAjP9jRGxy6hrs43A8BUvWxBN00H9Juo9jsfieLbr//ZsyqqqhQG3kMKxvA3Jy3kt96gZOky+Aj5NBvuRFvOahVv/aA8XUA6Tb9VSvDbeTJLy6L/tT1mSGznWJ6aZf68UojXLRlwH8WxaBlOF3uUyT4FofNglgVL1MYllPHlCyCivfAQxzC4xpfOFKZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPoQi+9ysdKHHF0b+5LwYxUGgwRkjASCIqQ7mS9L1to=;
 b=KgiUcOJj86gHqr4n4XaYoGV8peXgiDGV40uyeLeyotaMKRDsguZB4YjHv23xjcKJEY8yrqqy4wRAu/A55dBmLoETclKgTtEXjaXWd/8mUShF7MRebawQ8HBSh1C1jRQbXAa5gUQ7n8fb6mQZTWY57TwG0OhOSmN0BrmGRo2HIns=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Mon, 17 Aug
 2020 21:56:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 21:56:35 +0000
Subject: RE: [PATCH v4 00/12] SVM cleanup and INVPCID support for the AMD
 guests
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Moger, Babu" <Babu.Moger@amd.com>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <d8b4b64f-b5d8-6763-0ef9-ac467ff7e47e@amd.com>
Date:   Mon, 17 Aug 2020 16:56:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Mon, 17 Aug 2020 21:56:34 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eab0312a-c589-43f9-3bea-08d842f868b6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB452610D73AFFCC7529190E6C955F0@SA0PR12MB4526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmM/VbHxCEUy46ZXHZMesYx5X5+O5MJ9T9bUH249ceulCcFW7pjK9tbf66nlc8Um7gzcva6MaQsWWoty1J61sLuRSCebzgjaPxouwkIM5WfxvhdG6PLO2zd5PKd8UkA0Oted1MQMVOQi5ZEfcqJURIri6GGT0fvExfiRUdc7JHIP0G0ShUXGI6LzCgyvAKpVfQ32jWBM78nzgRda8d5WiqnWAqOTlWzDyqHVfQTu9qstoyriWpplfDoFv1HzF2sz8Ga8RGUNLPkkvoq0j5I1B70kOh2YIX1LI9HLXyfUWxgJv+d/5SCxqw6NCCXh0zOP9WwQSyMM4VToUXkXdsLQsKQ1SVQ9FlR0Zyg/Ph6OXNJWZ15nN9xTeoZAs9v/oSPyqaOBDktcZhT6g9TIl/VfY9y5cgktjgL5NHcoxzQGCSm15AJb6AwWEbVXmL1w51dj5BnG2Mjp3azkcP0VgPmMhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(2616005)(16576012)(2906002)(956004)(44832011)(66556008)(66476007)(66946007)(110136005)(54906003)(316002)(8676002)(52116002)(5660300002)(83380400001)(31696002)(16526019)(186003)(86362001)(31686004)(7416002)(26005)(53546011)(478600001)(6486002)(4326008)(36756003)(966005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B9xVL8PSHpL76MnIYk0SoMaCJm5XY58lplJ/gz6dRG59hF2YYAcn209DV0+3HWXJ5owx3/bn7dhvXyCJevXZ52IOgamITx0U1Mq3I85nN1rcXUZPDy3DpEw6SXTfLJ0gWv/2w+A29UP36PEZrTf+JGoC3BGtdUGJiH8AAi6lR8ydn8l7JPztl+F9wsl1EdV+lzPQlPaZt51+LjaIHiIOgUQA9uBvQsFNyU8PgYG6XYlUViaHxaV8VSjuAe67HUc9zUltfS2Gp/14dpphhcpmT4MfqzXfL+IcaInDtcROL8WlYd9WtzoTeQa7BHMcaw6bJPIug47wDR14oKPYGn2pdA6tjeDMLvmqmPsWjUGVulX8NapIpCeibrwpBSAh0OcW7vv6Au1wKrqAUnCAKWRMvLDp0dAoos/hS1NNdnXG21OH/6yK9CP0XGU9+XqEKO5Nb+jlEdnUiV3khuB5MUZSFu/D00ngj02mvPz96uiSxFr4TYgCV6jUDrnqn3c9xP4IS3+GGowEBC32aoWFxmQi7pAwgIgQjh/LkxdtoxYt9axg37afxybN1XP+dVziFea1E+F6aDny++WrgpAxbZg8Pv/bbL4p9kQJsqcshk6IQSfVtmL32rRORbPbMsv+G0kYD5sWBMZDK5OofBF1JYRG1A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab0312a-c589-43f9-3bea-08d842f868b6
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 21:56:35.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lf6ltPkRS6filNLI3WVLMu60NjCHlO2shKDtJMn888523wORVIlgM+jSCPg0Er9y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo and others,  Any comments on this series?

> -----Original Message-----
> From: Moger, Babu <Babu.Moger@amd.com>
> Sent: Thursday, August 6, 2020 7:46 PM
> To: pbonzini@redhat.com; vkuznets@redhat.com; wanpengli@tencent.com;
> sean.j.christopherson@intel.com; jmattson@google.com
> Cc: kvm@vger.kernel.org; joro@8bytes.org; x86@kernel.org; linux-
> kernel@vger.kernel.org; mingo@redhat.com; bp@alien8.de;
> hpa@zytor.com; tglx@linutronix.de
> Subject: [PATCH v4 00/12] SVM cleanup and INVPCID support for the AMD
> guests
> 
> The following series adds the support for PCID/INVPCID on AMD guests.
> While doing it re-structured the vmcb_control_area data structure to
> combine all the intercept vectors into one 32 bit array. Makes it easy for
> future additions. Re-arranged few pcid related code to make it common
> between SVM and VMX.
> 
> INVPCID interceptions are added only when the guest is running with
> shadow page table enabled. In this case the hypervisor needs to handle the
> tlbflush based on the type of invpcid instruction.
> 
> For the guests with nested page table (NPT) support, the INVPCID feature
> works as running it natively. KVM does not need to do any special handling.
> 
> AMD documentation for INVPCID feature is available at "AMD64 Architecture
> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev.
> 3.34(or later)"
> 
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> ---
> v4:
>  1. Changed the functions __set_intercept/__clr_intercept/__is_intercept to
>     to vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept by passing
>     vmcb_control_area structure(Suggested by Paolo).
>  2. Rearranged the commit 7a35e515a7055 ("KVM: VMX: Properly handle
> kvm_read/write_guest_virt*())
>     to make it common across both SVM/VMX(Suggested by Jim Mattson).
>  3. Took care of few other comments from Jim Mattson. Dropped
> "Reviewed-by"
>     on few patches which I have changed since v3.
> 
> v3:
> 
> https://lore.kernel.org/lkml/159597929496.12744.14654593948763926416.stgi
> t@bmoger-ubuntu/
>  1. Addressing the comments from Jim Mattson. Follow the v2 link below
>     for the context.
>  2. Introduced the generic __set_intercept, __clr_intercept and is_intercept
>     using native __set_bit, clear_bit and test_bit.
>  3. Combined all the intercepts vectors into single 32 bit array.
>  4. Removed set_intercept_cr, clr_intercept_cr, set_exception_intercepts,
>     clr_exception_intercept etc. Used the generic set_intercept and
>     clr_intercept where applicable.
>  5. Tested both L1 guest and l2 nested guests.
> 
> v2:
> 
> https://lore.kernel.org/lkml/159234483706.6230.13753828995249423191.stgit
> @bmoger-ubuntu/
>   - Taken care of few comments from Jim Mattson.
>   - KVM interceptions added only when tdp is off. No interceptions
>     when tdp is on.
>   - Reverted the fault priority to original order in VMX.
> 
> v1:
> 
> https://lore.kernel.org/lkml/159191202523.31436.11959784252237488867.stgi
> t@bmoger-ubuntu/
> 
> Babu Moger (12):
>       KVM: SVM: Introduce vmcb_set_intercept, vmcb_clr_intercept and
> vmcb_is_intercept
>       KVM: SVM: Change intercept_cr to generic intercepts
>       KVM: SVM: Change intercept_dr to generic intercepts
>       KVM: SVM: Modify intercept_exceptions to generic intercepts
>       KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
>       KVM: SVM: Add new intercept vector in vmcb_control_area
>       KVM: nSVM: Cleanup nested_state data structure
>       KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and
> is_cr_intercept
>       KVM: SVM: Remove set_exception_intercept and
> clr_exception_intercept
>       KVM: X86: Rename and move the function vmx_handle_memory_failure
> to x86.c
>       KVM: X86: Move handling of INVPCID types to x86
>       KVM:SVM: Enable INVPCID feature on AMD
> 
> 
>  arch/x86/include/asm/svm.h      |  117 +++++++++++++++++++++++++-------
> ---
>  arch/x86/include/uapi/asm/svm.h |    2 +
>  arch/x86/kvm/svm/nested.c       |   66 +++++++++-----------
>  arch/x86/kvm/svm/svm.c          |  131 ++++++++++++++++++++++++++-------
> ------
>  arch/x86/kvm/svm/svm.h          |   87 +++++++++-----------------
>  arch/x86/kvm/trace.h            |   21 ++++--
>  arch/x86/kvm/vmx/nested.c       |   12 ++--
>  arch/x86/kvm/vmx/vmx.c          |   95 ----------------------------
>  arch/x86/kvm/vmx/vmx.h          |    2 -
>  arch/x86/kvm/x86.c              |  106 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h              |    3 +
>  11 files changed, 364 insertions(+), 278 deletions(-)
> 
> --

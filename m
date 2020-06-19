Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEA3201D50
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 23:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgFSVwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 17:52:23 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:57312
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbgFSVwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 17:52:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUJ7NXxwr5ZN1V9Ka17Gkw0Gx32KdHb0rSQXM3Q5jRMGWo3C/+RbpTf2YbtwIiJR54MYzdsg/hN4wmJV/DDBFd5keXOGsHqV5vR61a24SL8FxWtCbhXjkOiembrJHeJdmqorCdNDzZWLsfiE2ooYog9RLm0cL6WF3AyBCZ0f+FU8ZwgHCol2IBE9yfoMJPXtFBPyUuh2XfFOtFkQJ4Jtfw4Fi9ZJOJPghF9Rw3cV2Tzbm3/m7aCIIx08E+TXKOlM3pUqG29tAwecgBUE9GPxTNlmgIOAgyQn2ZNXSIAbiir7kk9fEJsvP/rPWjDO6X5Fk8OhyD/HMhnx1qmMz+aYEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQKF0OXw9zzw2Tkmw3Ce+y92nHkRAwZDUzJXpoMQ164=;
 b=OS+w941Xq6cgS7BIdHZbSFxEwA0qhF4VAKvsW2cbFwiRB1ESCFOxivUerZXV4O1bv8c9LzfvIltVmu7iMgK7lL3aDhXRRuCrs1OMrOKYOyykbPZbEd1otjVuyvo7VW24HRQycDMQOfzGipFchXEWlARmreM7ibhkoQge69Px2AQwtXXKmk4UJVlb5gapZL7ZSjW7/ot+fcai6r4cncxx3DakFZUVgkZKo2DO6FHbzA/CZoA9CnjrP0p8e0biEP6ERDhT6oYH0siKc8xTIlmhYjrNdm7LwIAg8+5Rso5ag44LRLBK+d5IxYIFLqvyV+nXy82fBxRWiRZ4AcxSkJDZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQKF0OXw9zzw2Tkmw3Ce+y92nHkRAwZDUzJXpoMQ164=;
 b=KK/eDpTdZ10i0+vfwBDY3nxkX6Xn5GKAWALjCHyt5HnlfD3Ke8GMxjWYR3Z9QAXxJeFnMl+OjNqlTBSvemy+rKFHePJiP4OZCIXYTsnYwzl8tVhY63dOSWJiREiQa+zEvp7B7KJLeOyYRVkhD6/Evq8/clK+XH72NDDv84h1zHc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.21; Fri, 19 Jun 2020 21:52:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.023; Fri, 19 Jun
 2020 21:52:19 +0000
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
Date:   Fri, 19 Jun 2020 16:52:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0093.namprd12.prod.outlook.com
 (2603:10b6:802:21::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0093.namprd12.prod.outlook.com (2603:10b6:802:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 21:52:17 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aec9609a-4c67-4d59-b0c7-08d8149b0992
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116366FFDF7724C6E47E9AD7EC980@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ZO2cebbbkuEE5W6piGxwMGCJ+Bbgj3x1woxwwCjgcxEcMO8WHEQRyEfkwEcjfNbb7D5Ii1YCBgNTR0zkXHH1+J2H3126GjBzi0EugGc+Ej5ojOBU7QkvQk2cCE2uJb1DZjOfOKhUmUkJcknznvQ8GWDUZfoTUTd8kQFBf3+ksnvS3kTGiJUvOSTkMeQDqGBVNeKtliK9ibYck+STW4ZSn1eVIFOCSiC6WpzozzzVxiCrB+sXgqiaUeCUrA/TNOdUyILmzUpIyR0Lzhyny/Xn29UFh2xSVvKXA+oZPgLVsLfzbBBZBwNtacl70D/e+mP3bCYfcWxHF/+8XiQVKkBNfz/o1cFbEawGjHXczqoRDlBn/654NmM89iZ8w2JT+ARjHwVEDAxQ+7avKFaB819xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(31696002)(2906002)(83380400001)(316002)(31686004)(186003)(4326008)(478600001)(16526019)(86362001)(26005)(5660300002)(52116002)(6486002)(36756003)(2616005)(66556008)(66946007)(956004)(66476007)(6512007)(53546011)(6506007)(8676002)(8936002)(60764002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cH3UsAxBKXyCrcbrtHYTn3LD1MAVgUcG5NPyNCfg0wrNFUN9VoWK9eQ7gJd+Dad+eZ8ZUN/2Xv5CkxN5SJ18rvo61Zg0v4osFceEWdQanXJtSlF3MY1MDz95et11m/r2ekmY2V8q81lSk6mq6wmzHmj/x6j12FzquciCzCDBiB5u+GRyRaj89aQ3odW5Rf2wpZsjKuXAQgnthSPIElE4sZ2a6sj9lXI6yckSciEUCIkHep9+xS8sNzAWTIzn6CAjcAfQVFNcQp4rwCzyq5AZonfex7vsuJJiWawG1QFUmfr/Xu4I6j3hkgSu763rCQ8v1p8mx8H+4nd4j03Jb7kUTjB+VvWl8dOKlq2Exvwt/+Cnor2L/SFjf9ldKr3huW7JOp3TOGFirymBE/VMmfgZVYTd1J2BVClxaFBfmy9nAXSOibr/W9/njgJOLOhSuMO3cHvL3NVzNGZ13NQ46D9uHABJ5qYR24n/gEVDSjB71oD4Vs3nCneHS45sAvSECA65
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec9609a-4c67-4d59-b0c7-08d8149b0992
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 21:52:18.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iuk+vmuXK4xxrmHicwnyDH3Jkp1lexWdgoNw56fAKLUkm89Hd/2vgUC7fgMCGTqZ9EeeL4XQGEqCJXNqicXg5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/20 10:39 AM, Mohammed Gamal wrote:
> When EPT/NPT is enabled, KVM does not really look at guest physical
> address size. Address bits above maximum physical memory size are reserved.
> Because KVM does not look at these guest physical addresses, it currently
> effectively supports guest physical address sizes equal to the host.
> 
> This can be problem when having a mixed setup of machines with 5-level page
> tables and machines with 4-level page tables, as live migration can change
> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.
> 
> In this patch series we add checks on guest physical addresses in EPT
> violation/misconfig and NPF vmexits and if needed inject the proper
> page faults in the guest.
> 
> A more subtle issue is when the host MAXPHYADDR is larger than that of the
> guest. Page faults caused by reserved bits on the guest won't cause an EPT
> violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD_MASK
> error code to the page fault if needed.

I'm probably missing something here, but I'm confused by this statement. 
Is this for a case where a page has been marked not present and the guest 
has also set what it believes are reserved bits? Then when the page is 
accessed, the guest sees a page fault without the error code for reserved 
bits? If so, my understanding is that is architecturally correct. P=0 is 
considered higher priority than other page faults, at least on AMD. So if 
you have a P=0 and other issues exist within the PTE, AMD will report the 
P=0 fault and that's it.

The priority of other page fault conditions when P=1 is not defined and I 
don't think we guarantee that you would get all error codes on fault. 
Software is always expected to address the page fault and retry, and it 
may get another page fault when it does, with a different error code. 
Assuming the other errors are addressed, eventually the reserved bits 
would cause an NPF and that could be detected by the HV and handled 
appropriately.

> 
> The last 3 patches (i.e. SVM bits and patch 11) are not intended for
> immediate inclusion and probably need more discussion.
> We've been noticing some unexpected behavior in handling NPF vmexits
> on AMD CPUs (see individual patches for details), and thus we are
> proposing a workaround (see last patch) that adds a capability that
> userspace can use to decide who to deal with hosts that might have
> issues supprting guest MAXPHYADDR < host MAXPHYADDR.

Also, something to consider. On AMD, when memory encryption is enabled 
(via the SYS_CFG MSR), a guest can actually have a larger MAXPHYADDR than 
the host. How do these patches all play into that?

Thanks,
Tom

> 
> 
> Mohammed Gamal (7):
>    KVM: x86: Add helper functions for illegal GPA checking and page fault
>      injection
>    KVM: x86: mmu: Move translate_gpa() to mmu.c
>    KVM: x86: mmu: Add guest physical address check in translate_gpa()
>    KVM: VMX: Add guest physical address check in EPT violation and
>      misconfig
>    KVM: SVM: introduce svm_need_pf_intercept
>    KVM: SVM: Add guest physical address check in NPF/PF interception
>    KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR support
>      configurable
> 
> Paolo Bonzini (4):
>    KVM: x86: rename update_bp_intercept to update_exception_bitmap
>    KVM: x86: update exception bitmap on CPUID changes
>    KVM: VMX: introduce vmx_need_pf_intercept
>    KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
> 
>   arch/x86/include/asm/kvm_host.h | 10 ++------
>   arch/x86/kvm/cpuid.c            |  2 ++
>   arch/x86/kvm/mmu.h              |  6 +++++
>   arch/x86/kvm/mmu/mmu.c          | 12 +++++++++
>   arch/x86/kvm/svm/svm.c          | 41 +++++++++++++++++++++++++++---
>   arch/x86/kvm/svm/svm.h          |  6 +++++
>   arch/x86/kvm/vmx/nested.c       | 28 ++++++++++++--------
>   arch/x86/kvm/vmx/vmx.c          | 45 +++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/vmx.h          |  6 +++++
>   arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++-
>   arch/x86/kvm/x86.h              |  1 +
>   include/uapi/linux/kvm.h        |  1 +
>   12 files changed, 158 insertions(+), 29 deletions(-)
> 

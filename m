Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA33310321
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBEDIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:08:55 -0500
Received: from mail-mw2nam10on2068.outbound.protection.outlook.com ([40.107.94.68]:26720
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229484AbhBEDIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 22:08:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIQFFtx59Mhy5lMNlVEdZ2ldahOXU4lN4xXaG9cKS8agKpVqcUFbETuih4RRwR5C/CVFsDtZ7uUscY4kQGJBiTaFo12qHLOFq8C9CIE8FVwmyyEaR8HQ/EXBFSdQlSXXEqoF8hIY3TGaZadfLZM7ByGrt9439KK0wDGNImkhVK/xocjdThCEj9KujQHkws6eQQSpZqdkUW0sHiRfx78MJ/s2NTTsCY66MBIqGJAHT+ZCl90bIUR+lBoQH2Dpw7a6/EhSA70jfr0SI/pIZtjU+YV4rKcIdvTm3l7hmXjQY2WZ/pP4apiv4GIPIk4wZIJSRE/IdykJ+aCH9epkpfKr9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYVjLq2QTdnEP4KJXH8CMl26CV/mq6ZQ2JE7xo4k2ko=;
 b=lWogMHdijSqorblZ5GqdLp6eaPGmTfUL8Bqcx5YJ787Z3HekAL4V2nSFSiAIQOp6UjUFEC6NS9zPV5a5Z92kL62yNle0EPlY63/Y1QMnsjGxHfyVIvqhtdEuE31u45sCkk2BOyqv+F+nw3JJ3U0OneJG+8lMV35aUN3btCd52vctXKB/vy4FPhgnKCldgXwTw8ikI0G9MRRAv19zEHzoTCdd4CGWB7Dk1UQK8T0GpXsKxnSijX0Fq+qRRUOeKIvzMJjKAvZ9J5P6S8R/v6jeTkINqlF+YPGgvcQWuW6P3X6ZzkqUAm5uPAL96UvYUmSj1wjcEPXujqUQM0vnjpHvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYVjLq2QTdnEP4KJXH8CMl26CV/mq6ZQ2JE7xo4k2ko=;
 b=SNdbUL05WeaL6aIPC968sj+vzBRlahDN1GWBhmX1Agzz6yPLq62SK9jKYNE2qLwgiQe3GuoxFlpnXF4m8B5FzxO7Txk65l+6Vd0+nXi2hWQamsfEs9g9VbBWobjLSA8ykBoIF8HeGMomlFqsFmG35Zo9pKaBLuhwLdXZcE670G8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 03:07:58 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 03:07:58 +0000
Date:   Fri, 5 Feb 2021 03:07:53 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 12/16] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20210205030753.GA26504@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0116.namprd11.prod.outlook.com
 (2603:10b6:806:d1::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0116.namprd11.prod.outlook.com (2603:10b6:806:d1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Fri, 5 Feb 2021 03:07:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e83c0f08-d38d-4207-64dc-08d8c9833d81
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2688E146AA324539A0B3744C8EB29@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nPZaC+Xt8TIFfmON7NJN/RNRzf2A/69qA/c7bACpkX2y2XYGCksWV8GHbPo/TUWw/Vu3qtzcwVhuMahXB0zmLQd6i4GnxMLgM9K5EASBVaAodQ0lpg+C12LHuUhFYVGMZRruuDRabt2Km/cErpp0TbKUDXpw6jMOEyA607nAeLB33LkrMsIfL/O8oJuli+g5nR1PmyF4c6QVGRtASU+I0NzGIBFm+OJEScnpOhVXEGzYukQ19dFoeF742pgm/nbCJqQDi2nkCk9OvyATETaUmuVZDtuHSsh8D1/u1FP2lBcZsvjfZntuzxNSfnEweOyQWcSY1elE5zKM5zudWiFX13qeBvHC3qcOnSYjfQ/tm6M+BDy9d+MqG7cKfqbOY0RoagWR35hA+yKQz9FMt7JkKAJLrDPShMWS5d0ZmCiXNFgifTeQdISypmbCSOFtIqsZfKNKKNrwh6VjZgZFGoH0UmQjabUM25OD837smBos+rNJuW3fpoueNOPfiKZYo8qTOHDsBdidaw3pqWrdRyd0uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(16526019)(8676002)(186003)(7416002)(26005)(66946007)(8936002)(2906002)(5660300002)(6916009)(44832011)(83380400001)(956004)(66476007)(4326008)(1076003)(86362001)(66556008)(33656002)(53546011)(54906003)(6496006)(52116002)(33716001)(6666004)(478600001)(55016002)(316002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D9DM/w5UCyJYwj4I4nzOFCWwyHdejDb0N+wzqNh2LR+BjlIP9n3/YW7yxjKB?=
 =?us-ascii?Q?/l9whZcmuYtH+iA0ZZAc1wnI+pSTNlAeYWrWrek0ijZKOoBF980qP1Hx8PLH?=
 =?us-ascii?Q?WxQ+ey8rAB2iEPEkW2zSwnJs7t6/VQK/TT8ENu/imOJG06UD5TLiKV1Ozb5A?=
 =?us-ascii?Q?XjCsJaqitN3KccBTt0AIRM2AjHEJcmoReG82cofpVrVIC8l3IWcuXnYgMiQT?=
 =?us-ascii?Q?s0U9mqn5L4QDhKakjvHT8R4Xr0dfgiir1KJeN+Cd6v6EHgfvWVBZSiICym4S?=
 =?us-ascii?Q?gfNIS3ciJCmVC4XgXiIjSJUc+8B/htGedZz9EG8CHm33zB8aNnF5YPNU1v04?=
 =?us-ascii?Q?814YUjTPrj7czcTggmtjWx5VfSaOr10dRPKqm135MjfJ8J/P2aErDaHBFW5c?=
 =?us-ascii?Q?q8ObVEIQOh/e0KVZCx7WjM7wv8+jPLyRWJt1LmlND6Byveg97aWsghuTZ6I+?=
 =?us-ascii?Q?0ZsFQUlCM8bf/X8kGyl0qpuQhStrBEZ6EPB/Oycuzb0SKXYUT1z+wf3QuSMh?=
 =?us-ascii?Q?z0za/ePgz/2RYEkHlHwwxOefgc5ySp+u5gqGKdjq9WtTJXpOB0rtVtkUE5ta?=
 =?us-ascii?Q?XSzfwlSyHz51SYGDCVnYMzQAN9E7Zjzq4rKCYblZUcNGK9Y3ouSItnATucPU?=
 =?us-ascii?Q?egwLwoHSpHQshUpsvfxezxZdoiqhe+rJ7FYeWMj9RW3vEVP20R06rZU/5kSk?=
 =?us-ascii?Q?GklVjpdd+5eXhACoaRSNC33LCCxQj+tep0YpetGeY7CQXcK8nAUGxB6axpi8?=
 =?us-ascii?Q?FdqAZouR9a0aP9trSAsnCU0bqZSuGbscleM5ahWdpAs/lByJnc1pE9t+n/qW?=
 =?us-ascii?Q?vjahl+c06Hd/3SYHoI6VwleQpkpL8+JNNRSbQzFLKSrzqzpi7/Iy97n91S4S?=
 =?us-ascii?Q?jb3pyjduAc5DBE3qBV4culd9+HjOuxxvCJCquyAFLtuLxq7RY3w2LZwgfO/7?=
 =?us-ascii?Q?BI8JNbUBvA9xN9m18TdM/eStqy9Y8UHbL/LuDQW5fX7dAHhGUn6vAU9iH+3G?=
 =?us-ascii?Q?MuvhhKH45lvQcXbOfWblAT84nl7JVaNtg5NXrZ0zBUYUAzTh1Nzgem/Vn0K2?=
 =?us-ascii?Q?FAkN4KApcngzrINBl9598+NHHm9L2G3McQtCrxCyG65Tc3LTYlOeTZfDl+Md?=
 =?us-ascii?Q?xEkYXnoFdExIxtCfj63iG/G3xAFuW0ZJ9z0vURDv+ReSD8fByJE1PCH6jYCf?=
 =?us-ascii?Q?Bs/KJX4uuDflimXhVWMC2WZyNZzvXV/15r1Udlz3BIeNSIfOL7mxTtozSupl?=
 =?us-ascii?Q?+ukAJSvYGRglw1BFhTrqSrANbbazeEpJD84P0P8kSWTE1gZctUdpRaSptYaj?=
 =?us-ascii?Q?06CGo1UStDw9lUtITDzWepDS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83c0f08-d38d-4207-64dc-08d8c9833d81
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 03:07:58.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmPraaJp6uOZ6tIk9yEfYOMnkHxxYIbVDAT72vN7qcO66aGS+jgfYhAig89Yda+N3n0vroQBTSx3sZjYjLWc0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > for host-side support for SEV live migration. Also add a new custom
> > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > feature.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> >  arch/x86/kvm/svm/svm.h               |  2 ++
> >  6 files changed, 52 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > index cf62162d4be2..0bdb6cdb12d3 100644
> > --- a/Documentation/virt/kvm/cpuid.rst
> > +++ b/Documentation/virt/kvm/cpuid.rst
> > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> >                                                 before using extended destination
> >                                                 ID bits in MSI address bits 11-5.
> >
> > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > +                                               using the page encryption state
> > +                                               hypercall to notify the page state
> > +                                               change
> > +
> >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> >                                                 per-cpu warps are expected in
> >                                                 kvmclock
> > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > index e37a14c323d2..020245d16087 100644
> > --- a/Documentation/virt/kvm/msr.rst
> > +++ b/Documentation/virt/kvm/msr.rst
> > @@ -376,3 +376,15 @@ data:
> >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> >         and check if there are more notifications pending. The MSR is available
> >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > +
> > +MSR_KVM_SEV_LIVE_MIGRATION:
> > +        0x4b564d08
> > +
> > +       Control SEV Live Migration features.
> > +
> > +data:
> > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > +        in other words, this is guest->host communication that it's properly
> > +        handling the shared pages list.
> > +
> > +        All other bits are reserved.
> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > index 950afebfba88..f6bfa138874f 100644
> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > @@ -33,6 +33,7 @@
> >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> >  #define KVM_FEATURE_ASYNC_PF_INT       14
> >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> >
> >  #define KVM_HINTS_REALTIME      0
> >
> > @@ -54,6 +55,7 @@
> >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> >
> >  struct kvm_steal_time {
> >         __u64 steal;
> > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> >  #define KVM_PV_EOI_DISABLED 0x0
> >
> > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > +
> >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index b0d324aed515..93f42b3d3e33 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >         return ret;
> >  }
> >
> > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +
> > +       if (!sev_guest(kvm))
> > +               return;
> 
> This should assert that userspace wanted the guest to be able to make
> these calls (see more below).
> 
> >
> > +
> > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +}
> > +
> >  int svm_get_shared_pages_list(struct kvm *kvm,
> >                               struct kvm_shared_pages_list *list)
> >  {
> > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> >         if (!sev_guest(kvm))
> >                 return -ENOTTY;
> >
> > +       if (!sev->live_migration_enabled)
> > +               return -EINVAL;
> > +
> >         if (!list->size)
> >                 return -EINVAL;
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 58f89f83caab..43ea5061926f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >                 svm->msr_decfg = data;
> >                 break;
> >         }
> > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > +               sev_update_migration_flags(vcpu->kvm, data);
> > +               break;
> >         case MSR_IA32_APICBASE:
> >                 if (kvm_vcpu_apicv_active(vcpu))
> >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> >         }
> >
> > +       /*
> > +        * If SEV guest then enable the Live migration feature.
> > +        */
> > +       if (sev_guest(vcpu->kvm)) {
> > +               struct kvm_cpuid_entry2 *best;
> > +
> > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > +               if (!best)
> > +                       return;
> > +
> > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > +       }
> > +
> 
> Looking at this, I believe the only way for this bit to get enabled is
> if userspace toggles it. There needs to be a way for userspace to
> identify if the kernel underneath them does, in fact, support SEV LM.
> I'm at risk for having misread these patches (it's a long series), but
> I don't see anything that communicates upwards.
> 
> This could go upward with the other paravirt features flags in
> cpuid.c. It could also be an explicit KVM Capability (checked through
> check_extension).
> 
> Userspace should then have a chance to decide whether or not this
> should be enabled. And when it's not enabled, the host should return a
> GP in response to the hypercall. This could be configured either
> through userspace stripping out the LM feature bit, or by calling a VM
> scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> 
> I believe the typical path for a feature like this to be configured
> would be to use ENABLE_CAP.

I believe we have discussed and reviewed this earlier too. 

To summarize this feature, the host indicates if it supports the Live
Migration feature and the feature and the hypercall are only enabled on
the host when the guest checks for this support and does a wrmsrl() to
enable the feature. Also the guest will not make the hypercall if the
host does not indicate support for it.

And these were your review comments on the above : 
I see I misunderstood how the CPUID bits get passed
through: usermode can still override them. Forgot about the back and
forth for CPUID with usermode. 

So as you mentioned, userspace can still override these and it gets a 
chance to decide whether or not this should be enabled.

Thanks,
Ashish

> >
> >         if (!kvm_vcpu_apicv_active(vcpu))
> >                 return;
> >
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 066ca2a9f1e6..e1bffc11e425 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -79,6 +79,7 @@ struct kvm_sev_info {
> >         unsigned long pages_locked; /* Number of pages locked */
> >         struct list_head regions_list;  /* List of registered regions */
> >         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
> > +       bool live_migration_enabled;
> >         /* List and count of shared pages */
> >         int shared_pages_list_count;
> >         struct list_head shared_pages_list;
> > @@ -592,6 +593,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
> >  void pre_sev_run(struct vcpu_svm *svm, int cpu);
> >  void __init sev_hardware_setup(void);
> >  void sev_hardware_teardown(void);
> > +void sev_update_migration_flags(struct kvm *kvm, u64 data);
> >  void sev_free_vcpu(struct kvm_vcpu *vcpu);
> >  int sev_handle_vmgexit(struct vcpu_svm *svm);
> >  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
> > --
> > 2.17.1
> >

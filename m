Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A64354CB0
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 08:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhDFGXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 02:23:05 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:59906
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232331AbhDFGXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 02:23:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtnG2ygAJ+dM4wW1kB+MqgdYGZMjHVyK6H1fi5PeaJaA0GWgEEHjKieeagLogQnWVWCw77Q2IIfT5T8hK6jHlCUBoa0f8geOi26vRAAeqLxv6JXyKIOSRK3aPrA2u3kAuQVoD16k+qX287zIVaViRrR7cuxcFE3mL9N/1/c4Tr65iTvXn/F7UutbxNKanqtO5B/zA7nOSFXpWkJqV5tXmZnubHiZFYWJZI1lY1VzONURFUdIMi/QPpD7o/bgx7LUsZ0A/crpVRK5PkjOo2CQxgONedtbaEnLHEh7H4WOfomKlzlN9a7sfHCPenDAhaaBfdTmoS5J3rVBPipcdANsMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEWxFyZBMl3vNx3q/J8fUwtlNKkZWgxa+s0JURzH4P4=;
 b=iDaUjluojEhiqHsME2QkTq+QwmPKZrWW9Pcj0Z3k11d1zzd4aXHV7yxNDA8ABg16MbGJBNXhEfXHq+jNqlu7buJOWtCxHnkkjqUmFv5PhEQ8//dNMosKMlg7Jwnpw/KE2JUPrxKgK9DvvFoVqEwMfMX/ueSwDsxLPebMB6n6Hh+A59GR4r8+NIs7L0IlGEVYC+0yvPuRAkSkAr+WzQghn84BobXNpaIu/9lA92HsZbKeMPDdbMiNLoK3e2GUQ8AUmHF9IOOmuZrm6/MNLuNaFoI4ljon+AiSdYXnu/pfd2j/YYok2Xs7CVGjscww5hWFUBV+2xcXzSz8jEorRcGH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEWxFyZBMl3vNx3q/J8fUwtlNKkZWgxa+s0JURzH4P4=;
 b=JzqEYQ9jyTyRrRK60+YE5PbhysJjiDe4YLk+hGO75mfg65XYEYiV+1f1CKJ0mrx8T9ODCW9XauHN3eOC9GCzcvMO1wr2jKSv6+WInjOUf3TmFimi5ZoKXg6cIw+V+sW1/Ge7IoxwgFyiVdLeMMl1t7MTNB9B0dvnZIOGRKeSRFE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 06:22:54 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 06:22:54 +0000
Date:   Tue, 6 Apr 2021 06:22:48 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20210406062248.GA22937@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0106.namprd05.prod.outlook.com
 (2603:10b6:803:42::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0106.namprd05.prod.outlook.com (2603:10b6:803:42::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 06:22:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed23915-c512-464d-9691-08d8f8c469ab
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45106505FA21105E7E30197E8E769@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Su/8P3lq1oAwkbIW+JIs4OQlwiqFXOvHxSkd4FIyFm5UAQYcv6SdcKxah41HTKJIKR9KmxrVTI/twaAT553TZtTC+UVmHJS0AfwQS5XT4JG25tAXt5HoEQqM5Rhmlbi0z3aE350CU2j/jJ4hHjIv5f9fmHkxnkDhoHsC7pYU14zyphS6ssIAxzmTIb55ma9MuM8Rwg/IXosRxIpRBMbPOU7MOSPoJxiLjSChs/FoKzDKWf8KgeHq0gZi5W7C6x8jLWHfAkXBPQnrRIbCGrl9TmX0Moo4FzkHvxTPterBIfBxxKpzzWi3sylJo1VnBhRPRNr0VyPAmVO5fLSdDD2rZHGzCx0sh6zA+4zRl+3cRpKK8WT7M8q5Nq6acAzloMxK3plEiSsr7IDvX6bRSYKQyIMt2mBhIgfnFKHtRQQB5tFy25KBHLNRR3WRmpsugC/Y1zQFstaR6/x7/URuta/P5BsGpJW6MAW3NaOkp1OcmTehl/7Kzz2KguEeXRppTsrMHe2ArqpS6wjJvkgefqHPJFQr0AkJTNV5HRsoZvx26F371wFeZyX7VCMgMjfUwRFdsf1+a/Ib++Jj9LJcveTzhSxuAK3O34XM9HV8GQXSWcklBljwvYlzAXXqRp4Akf+21hMXQ23BQK8jLe523L1RLfhNi2u3lL9LGPVPuXViTKLUgZ4wW9dpsA3m381KqghZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(66946007)(66476007)(1076003)(66556008)(9686003)(86362001)(4326008)(55016002)(2906002)(5660300002)(38350700001)(956004)(8936002)(8676002)(16526019)(186003)(54906003)(7416002)(6666004)(26005)(33656002)(6916009)(53546011)(6496006)(52116002)(478600001)(83380400001)(38100700001)(33716001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CqS038CGe1oUi7hGeTiGHHiFO/MPFbYwWgHSjHwrsDgWrwLW4i3f8Lt5/+ph?=
 =?us-ascii?Q?759r5HtoH/ajy7Vras/sfCfMhk0nM9L3JpTPB/1Xio9ZzbpsbhbLQTrMmqs/?=
 =?us-ascii?Q?qhy7qldiKdIcXs2M369KxCpI6b6j+KuyacJHcnUju2AwL64QhNKNb7EaYX6t?=
 =?us-ascii?Q?c1IAfI+hQ4o9bsc56SBe+cpclS24fxwfQGdi7K9pgcC2lF87bQET+EJc1dfZ?=
 =?us-ascii?Q?h/CfvO7q26ESvAtokB3jSLearnIOdZ7TsffeOmw19GRMjOV93Ef4cS8qMx2B?=
 =?us-ascii?Q?kcC1go84oRNZxzm71W432o5RKHUuoHZsfEcMmDFDvCZZ0eGoaGZvirh1suWa?=
 =?us-ascii?Q?5+DE/jxu5GqQ4BaieDNHqrrcEvmoX7cZiNQEf+qLZU5JOFPrwvOo3Wt82WcI?=
 =?us-ascii?Q?7bIgUYYR4eiebeJ0pdL+a7NUrKveNpBOssUXN16aGf5JSS1lXpcOWr0dwrti?=
 =?us-ascii?Q?dBmVVz/5hdAoRNotYlpkYOuzSA9ixqtEUfXSsvC9oGJWqN3WNSAUPWe70DsM?=
 =?us-ascii?Q?ZUq00HZOd+2J/SLaC2fb1tXocU2i3T9n3fo2xUMzUcFeKkDcG4oI+nj9ZTBO?=
 =?us-ascii?Q?JCa+9SdWt9ZQV2gYSsQtFFIgHglRvfirTQQpTP+XnK+ABUjxpOhN9hVDcOb8?=
 =?us-ascii?Q?ykK1sZcAJCnhAvuvJk5ecYbjrMqULVLqh8h0uiwKwFPWJyNLjE7f1gRRKNAU?=
 =?us-ascii?Q?m99lQmsYjo4TdlyWkSz4ibcTL9U3D4IcYAj1+RSpLM2BxVE+dyaXizY4z1hG?=
 =?us-ascii?Q?RxI7lYScPeat4oCoDiZtWDwBbv7qWgnwC31LgNMcOlllLMKKwENfDlCzAbFQ?=
 =?us-ascii?Q?9FuXAdkKJGg7naxW6ax9kPnoX87TuDNBc2DVCWY26TC1+uIKzVlXy9jpNSVG?=
 =?us-ascii?Q?lozmJQpTgk+rIUmbWnJuNuvMcPK5+kmNu8awAzIkYMeTJMx1ldBcU8L3I8mQ?=
 =?us-ascii?Q?hSOKD4ITrouGnLjCQyeXiQFSaBXYxHzH8r47IyMELInqTX6UFSkZ/TkRiSg+?=
 =?us-ascii?Q?hbydezh0+4hZ2JcZVVsZZFF1q8AkwmQnw8IHhWKamLrh3G2UXnJUmEXh9xQW?=
 =?us-ascii?Q?NkFbPHjKyTWt0YoRY+wpCGvaCiLLUKFys2VIqEF1k7CaRZaoO8rvjVgNpzKE?=
 =?us-ascii?Q?D8gsE19TNCME8md+Q26BlSs3gyAMjV6iMRk0zvzbfq5hd1zXE2RgG+dtOByS?=
 =?us-ascii?Q?Mhm1psn4gWcPNSIvp9cui/47t3V68e+t/pwWanihe1Yp2MotztPZb7d2Evt0?=
 =?us-ascii?Q?YwP4OhyvLCMfe5FNZvSMy2qkw6rLQKOHWqzrtjjmJWiQBwCRR1cQtaxhyyF+?=
 =?us-ascii?Q?nCIfKpIOi+32LwijpMJ6xMAM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed23915-c512-464d-9691-08d8f8c469ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 06:22:54.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APKUGEG86AG9Af4SnZbYGbC0HzOI57x067I4lU7JCEILqzvaz/c45Zyv3Es9pSJY6nGhgnSykXznueZLA5GcgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 05, 2021 at 01:42:42PM -0700, Steve Rutherford wrote:
> On Mon, Apr 5, 2021 at 7:28 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> >
> > The hypercall exits to userspace to manage the guest shared regions and
> > integrate with the userspace VMM's migration code.
> >
> > The patch integrates and extends DMA_SHARE/UNSHARE hypercall to
> > userspace exit functionality (arm64-specific) patch from Marc Zyngier,
> > to avoid arch-specific stuff and have a common interface
> > from the guest back to the VMM and sharing of the host handling of the
> > hypercall to support use case for a guest to share memory with a host.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/api.rst        | 18 ++++++++
> >  Documentation/virt/kvm/hypercalls.rst | 15 +++++++
> >  arch/x86/include/asm/kvm_host.h       |  2 +
> >  arch/x86/kvm/svm/sev.c                | 61 +++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c                |  2 +
> >  arch/x86/kvm/svm/svm.h                |  2 +
> >  arch/x86/kvm/vmx/vmx.c                |  1 +
> >  arch/x86/kvm/x86.c                    | 12 ++++++
> >  include/uapi/linux/kvm.h              |  8 ++++
> >  include/uapi/linux/kvm_para.h         |  1 +
> >  10 files changed, 122 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 307f2fcf1b02..52bd7e475fd6 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5475,6 +5475,24 @@ Valid values for 'type' are:
> >      Userspace is expected to place the hypercall result into the appropriate
> >      field before invoking KVM_RUN again.
> >
> > +::
> > +
> > +               /* KVM_EXIT_DMA_SHARE / KVM_EXIT_DMA_UNSHARE */
> > +               struct {
> > +                       __u64 addr;
> > +                       __u64 len;
> > +                       __u64 ret;
> > +               } dma_sharing;
> > +
> > +This defines a common interface from the guest back to the KVM to support
> > +use case for a guest to share memory with a host.
> > +
> > +The addr and len fields define the starting address and length of the
> > +shared memory region.
> > +
> > +Userspace is expected to place the hypercall result into the "ret" field
> > +before invoking KVM_RUN again.
> > +
> >  ::
> >
> >                 /* Fix the size of the union. */
> > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > index ed4fddd364ea..7aff0cebab7c 100644
> > --- a/Documentation/virt/kvm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/hypercalls.rst
> > @@ -169,3 +169,18 @@ a0: destination APIC ID
> >
> >  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> >                 any of the IPI target vCPUs was preempted.
> > +
> > +
> > +8. KVM_HC_PAGE_ENC_STATUS
> > +-------------------------
> > +:Architecture: x86
> > +:Status: active
> > +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > +
> > +a0: the guest physical address of the start page
> > +a1: the number of pages
> > +a2: encryption attribute
> > +
> > +   Where:
> > +       * 1: Encryption attribute is set
> > +       * 0: Encryption attribute is cleared
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3768819693e5..78284ebbbee7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
> >         int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >
> >         void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > +       int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +                                 unsigned long sz, unsigned long mode);
> >  };
> >
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c9795a22e502..fb3a315e5827 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >         return ret;
> >  }
> >
> > +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> > +{
> > +       vcpu->run->exit_reason = 0;
> I don't believe you need to clear exit_reason: it's universally set on exit.
> 
> > +       kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> > +       ++vcpu->stat.hypercalls;
> > +       return kvm_skip_emulated_instruction(vcpu);
> > +}
> > +
> > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +                          unsigned long npages, unsigned long enc)
> > +{
> > +       kvm_pfn_t pfn_start, pfn_end;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       gfn_t gfn_start, gfn_end;
> > +
> > +       if (!sev_guest(kvm))
> > +               return -EINVAL;
> > +
> > +       if (!npages)
> > +               return 0;
> > +
> > +       gfn_start = gpa_to_gfn(gpa);
> > +       gfn_end = gfn_start + npages;
> > +
> > +       /* out of bound access error check */
> > +       if (gfn_end <= gfn_start)
> > +               return -EINVAL;
> > +
> > +       /* lets make sure that gpa exist in our memslot */
> > +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> > +       pfn_end = gfn_to_pfn(kvm, gfn_end);
> > +
> > +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > +               /*
> > +                * Allow guest MMIO range(s) to be added
> > +                * to the shared pages list.
> > +                */
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +               /*
> > +                * Allow guest MMIO range(s) to be added
> > +                * to the shared pages list.
> > +                */
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (enc)
> > +               vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> > +       else
> > +               vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> > +
> > +       vcpu->run->dma_sharing.addr = gfn_start;
> > +       vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> > +       vcpu->arch.complete_userspace_io =
> > +               sev_complete_userspace_page_enc_status_hc;
> > +
> > +       return 0;
> > +}
> > +
> >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >         struct kvm_sev_cmd sev_cmd;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 58a45bb139f8..3cbf000beff1 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4620,6 +4620,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >         .complete_emulated_msr = svm_complete_emulated_msr,
> >
> >         .vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> > +
> > +       .page_enc_status_hc = svm_page_enc_status_hc,
> >  };
> >
> >  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 39e071fdab0c..9cc16d2c0b8f 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -451,6 +451,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> >                                bool has_error_code, u32 error_code);
> >  int nested_svm_exit_special(struct vcpu_svm *svm);
> >  void sync_nested_vmcb_control(struct vcpu_svm *svm);
> > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +                          unsigned long npages, unsigned long enc);
> >
> >  extern struct kvm_x86_nested_ops svm_nested_ops;
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 32cf8287d4a7..2c98a5ed554b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7748,6 +7748,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> >         .can_emulate_instruction = vmx_can_emulate_instruction,
> >         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >         .migrate_timers = vmx_migrate_timers,
> > +       .page_enc_status_hc = NULL,
> >
> >         .msr_filter_changed = vmx_msr_filter_changed,
> >         .complete_emulated_msr = kvm_complete_insn_gp,
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f7d12fca397b..ef5c77d59651 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >                 kvm_sched_yield(vcpu->kvm, a0);
> >                 ret = 0;
> >                 break;
> > +       case KVM_HC_PAGE_ENC_STATUS: {
> > +               int r;
> > +
> > +               ret = -KVM_ENOSYS;
> > +               if (kvm_x86_ops.page_enc_status_hc) {
> > +                       r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> > +                       if (r >= 0)
> > +                               return r;
> > +                       ret = r;
> Style nit: Why not just set ret, and return ret if ret >=0?
> 

But ret is "unsigned long", if i set ret and return, then i will return to guest
even in case of error above ?

Thanks,
Ashish

> This looks good. I just had a few nitpicks.
> Reviewed-by: Steve Rutherford <srutherford@google.com>

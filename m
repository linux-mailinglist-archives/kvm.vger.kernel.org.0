Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29BC311BA5
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 06:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBFFr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 00:47:27 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:46464
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229514AbhBFFrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 00:47:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTFdADpIpQNUSBOzFqfH19k1bEwVuIjfRuOsSLF5zrZcXUpMhkKJsKIXncwyiIgsSm3oQHuGeOnc89Z2PyXgVmNDq2jdviH2blgweXSSe957aUboeCm+bk6yWovxnjmbjLzm6QlMPQKbTpQWdda2lUe9mMPS/v68X4UEqtrYp9tokr8ukwVV8wm+83QYv0iQki5prTbUPzBMDS1hK8Ng8EWXSbz6CEHeEjjGdYtn1lurF/8dGHlciNn4XZLGFqf6aDvJ1QIcNWOuORtIQrPgUFmdIYpnjUbcoKAqyTz7FgI7K5F8/VvFLX/ZzLCtZy34iR10qXmjse38jC9iCJMNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qw8ZVa/vhN+0dptiquE/IjkGdAKkeZnR0i6P+WqqZ7c=;
 b=juIK838tMn9CarFTMtD96lCPydiaepjKT7T6B6fAG5AIkiHH2+Ftbre84hT/mGVoirSxNbGfI+6oQ8w2CX21bkAI+6hCQoHiPOwM4uigif2O41IFyNGnb/f8TN8OA4N8iab0CoWE0WnTc56tdGj6xYptIeCuXIgr9wFS9hZeX65JaX2HPldfVl6fufz0sIaGf4uWjsBibQz/2StTte6AeYdISQGNbvbbwY/EmoxUFuj3YGbd0KJwXLBCIZu4r1d3yJQFge1S6I+fv6jYQi/gyyWaq9quJwFM2PYs+tqOwanShMmA9I8r054ZK1gmuaUIZVFVW6TvWNem76X+PhjYpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qw8ZVa/vhN+0dptiquE/IjkGdAKkeZnR0i6P+WqqZ7c=;
 b=dLkpr70JmY+KsqKt1CucSh8/uaz5VpwqG6IVwey4VU9kIxx0rgaQmrYLPIb/wTiolPSJ1IAxBZafjP41t/ZQ8klgLY4sldUbc53NsvwLVG61v2IvJqwGk7IbTXyyD3YQz88ebf/kcs0RqZUv2Dgs7eFUlIJ5jl+EtkpOL5jc1GU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Sat, 6 Feb
 2021 05:46:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Sat, 6 Feb 2021
 05:46:22 +0000
Date:   Sat, 6 Feb 2021 05:46:17 +0000
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
Message-ID: <20210206054617.GA19422@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server>
 <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Sat, 6 Feb 2021 05:46:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ff8e8ff-f36d-4f07-cf87-08d8ca628886
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271700E954EF3575F2BD30EF8EB19@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jBUkyPHJOZKRfJH43JzRSr+BBqgmxpmzOj/wr7KhY8nCW8Q40lclBzrSSeoHj7cHizHVg60TfjgUK6m4aWIaOd69DSiETIutFpfV6f8UE/IoQKf++IeTs9EMiJHxlRYRF63JLXNV38kdNHHIgIaxY3UWSguffMTNOkR6ToiVURo8TPDK2SbSaI5cmrfKliCCylYGPRu/7Pbvn/23SdTthmb0IAAh1gclpleWmbryP9RGW9LQ/DHVrMTp9X2a7ssS8j/np8sWLwOVcK6+taFC54lrvWIvgCKnTj1ewJHHDcOuyYgNNOlFNYeCaxMzSQylffi+IJyHmVrba27cHd10MGrE3gXqKwfyk3+vpnTopQ14wHt0qogPPLkHkxinluRmJeZpdVJbB2yhkBD9HEyliGJi1/5+NZeCIBhMhZrdQD0nn/NdPM84sXgy9qRLxL/wwNNoEqDWyd/hm6/lChwSEgZyU/4u7P9XFCBlwDBDW1IvGtGlcPrue/5kKm5jNWAA5DWt5CI1AQ4Yr+jZOm6l7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(366004)(346002)(376002)(30864003)(6666004)(16526019)(66946007)(186003)(8676002)(5660300002)(26005)(2906002)(4326008)(478600001)(55016002)(6916009)(66476007)(86362001)(9686003)(33656002)(316002)(54906003)(83380400001)(956004)(66556008)(1076003)(8936002)(33716001)(52116002)(6496006)(53546011)(44832011)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?To4v9qK57wj21Ne6Px87gWi8UkDI64p/QgfuWCj+G9jor3Co4kkyfhoRdAlU?=
 =?us-ascii?Q?qQ84votfBnRUnFDclJ7A5MsdvZZfDVCUyWcUyBP8FkN8BjLsfSxiB7UN6RbP?=
 =?us-ascii?Q?CWjdUDIBZoLzupuT2XZgQ7xVv4cdANrTbzhXZrIl7KV4Xy+KxIYVGzgWg3u4?=
 =?us-ascii?Q?0YVNnXJ26z2xIp5o3qS3bXACY9AaS2td5v4p3U7wx0HoBXmAGfRzuUcE19xD?=
 =?us-ascii?Q?IcrLBHVah70GLyUkLgA7dE8CjZSR3EvM1/M6M/ydavXRXEjG9k43Zp81q2ob?=
 =?us-ascii?Q?/9BgWVdpnWtDR714eoRdtxCGyNZSWMwkgu9iCIaI4PUIzgn2qmuh/8gMs4Rs?=
 =?us-ascii?Q?O3xTLFw73ZXFiWC7vaDOqknkhuj/UeEdNWLEqsCz062yVpnVzKJOT5SHeqWM?=
 =?us-ascii?Q?drE6mjRr1/zdP/BHEUZbQLpfi2ci2MV9Cy+ghBZxsScXCl3limQftOkM+7Is?=
 =?us-ascii?Q?VunCs2pWJbqLdJFxvBZLqLJsMnJV8PrZY9Ros7QiaXD7YWaFROIxC2jN9c8a?=
 =?us-ascii?Q?d2Er0pC0GyIogiDd5fMkk2DZ9ypmMSBEBmU4S+iCMv4D00hwxL+0rjVpIiBS?=
 =?us-ascii?Q?MCb+agtfo140RtPzTs30V/IrwOJvWraTTR+Zk+YL/nLGQD/2tV/udQPMSEHw?=
 =?us-ascii?Q?y4B3A5DW5dGFpjh9aVDTk4PDAFgf6iA/iPSee+qvagmty9c+LXMPrKKzXblO?=
 =?us-ascii?Q?7CU0zinJ3RX950/Ka/wLzAy4aHmi3IBq4iKuwA0sMk4yCKV9FFPrDWVeoo8p?=
 =?us-ascii?Q?Z1tVCWeXM7/h0rX6CVRJmLVwfTcvC26wArKfK4fZRoKXlTAWWCrRTOrKAz75?=
 =?us-ascii?Q?Fzw8B/gEBCMBZCOgpPwRYmj1Zlt5hRAmkai3aWcho+2XQH6BIEg1WGbh0glG?=
 =?us-ascii?Q?I6NDTOkpQF2RecSzLNXjwj3x/hKFTTfZnCp+edJFPIXzXtprWF1uhbXNv7iv?=
 =?us-ascii?Q?B7Z2T2MvCAt0VXI78k+NF8ctJAArecUnIKjiPKxqxIcFZ0NGvq7TkGWbj+J+?=
 =?us-ascii?Q?S+Kl6epGv7c6qVordIX/lYeWki/PDEIugzGzsN0r8OLmp4f9ErhYOB++36kA?=
 =?us-ascii?Q?PpEe51iCrvveY19QZN2DtVshSsYPIpXi09zUDtYhwcfKu3ZYd4hOj1MXkwMX?=
 =?us-ascii?Q?8YCplPnjoRW8FfuuF9OAZB7e/SnUu3vC1BSQIbFu4R9vvD9i3oCg/0igrXWT?=
 =?us-ascii?Q?5nHUs6etVONP+oFy/LADSVY8fzJQjdu76Ks4XRFWwuSrJ5Pls/yuIO+A65SO?=
 =?us-ascii?Q?otFuV0DVQYSKRYdeG8EJKPeZRiPdD/MQLFpLCaytYycQ3drbyFZWa0edJypE?=
 =?us-ascii?Q?PsjK0jx6zrUWrMo4kMQYGYkk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff8e8ff-f36d-4f07-cf87-08d8ca628886
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2021 05:46:22.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4QNi12GwuIw2eFbDEEDMg1U/VIt3S7/SJTpgolwwss/Pnc7KZzMvM3lRMk0dGp+6x6PwXb9MVuGBUCLD4JBew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

Continued response to your queries, especially related to userspace
control of SEV live migration feature : 

On Fri, Feb 05, 2021 at 06:54:21PM -0800, Steve Rutherford wrote:
> On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > >
> > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > >
> > > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > > for host-side support for SEV live migration. Also add a new custom
> > > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > > feature.
> > > >
> > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > ---
> > > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > > >  6 files changed, 52 insertions(+)
> > > >
> > > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > > --- a/Documentation/virt/kvm/cpuid.rst
> > > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > > >                                                 before using extended destination
> > > >                                                 ID bits in MSI address bits 11-5.
> > > >
> > > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > > +                                               using the page encryption state
> > > > +                                               hypercall to notify the page state
> > > > +                                               change
> > > > +
> > > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > > >                                                 per-cpu warps are expected in
> > > >                                                 kvmclock
> > > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > > index e37a14c323d2..020245d16087 100644
> > > > --- a/Documentation/virt/kvm/msr.rst
> > > > +++ b/Documentation/virt/kvm/msr.rst
> > > > @@ -376,3 +376,15 @@ data:
> > > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > > >         and check if there are more notifications pending. The MSR is available
> > > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > > +
> > > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > > +        0x4b564d08
> > > > +
> > > > +       Control SEV Live Migration features.
> > > > +
> > > > +data:
> > > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > > +        in other words, this is guest->host communication that it's properly
> > > > +        handling the shared pages list.
> > > > +
> > > > +        All other bits are reserved.
> > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > index 950afebfba88..f6bfa138874f 100644
> > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > @@ -33,6 +33,7 @@
> > > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > > >
> > > >  #define KVM_HINTS_REALTIME      0
> > > >
> > > > @@ -54,6 +55,7 @@
> > > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > > >
> > > >  struct kvm_steal_time {
> > > >         __u64 steal;
> > > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > >
> > > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > > +
> > > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index b0d324aed515..93f42b3d3e33 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > > >         return ret;
> > > >  }
> > > >
> > > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > > +{
> > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +
> > > > +       if (!sev_guest(kvm))
> > > > +               return;
> > >
> > > This should assert that userspace wanted the guest to be able to make
> > > these calls (see more below).
> > >
> > > >
> > > > +
> > > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > > +}
> > > > +
> > > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > > >                               struct kvm_shared_pages_list *list)
> > > >  {
> > > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > > >         if (!sev_guest(kvm))
> > > >                 return -ENOTTY;
> > > >
> > > > +       if (!sev->live_migration_enabled)
> > > > +               return -EINVAL;
> 
> This is currently under guest control, so I'm not certain this is
> helpful. If I called this with otherwise valid parameters, and got
> back -EINVAL, I would probably think the bug is on my end. But it
> could be on the guest's end! I would probably drop this, but you could
> have KVM return an empty list of regions when this happens.
> 
> Alternatively, as explained below, this could call guest_pv_has instead.
> 
> >
> > > > +
> > > >         if (!list->size)
> > > >                 return -EINVAL;
> > > >
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 58f89f83caab..43ea5061926f 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > >                 svm->msr_decfg = data;
> > > >                 break;
> > > >         }
> > > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > > +               break;
> > > >         case MSR_IA32_APICBASE:
> > > >                 if (kvm_vcpu_apicv_active(vcpu))
> > > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > > >         }
> > > >
> > > > +       /*
> > > > +        * If SEV guest then enable the Live migration feature.
> > > > +        */
> > > > +       if (sev_guest(vcpu->kvm)) {
> > > > +               struct kvm_cpuid_entry2 *best;
> > > > +
> > > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > > +               if (!best)
> > > > +                       return;
> > > > +
> > > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > > +       }
> > > > +
> > >
> > > Looking at this, I believe the only way for this bit to get enabled is
> > > if userspace toggles it. There needs to be a way for userspace to
> > > identify if the kernel underneath them does, in fact, support SEV LM.
> > > I'm at risk for having misread these patches (it's a long series), but
> > > I don't see anything that communicates upwards.
> > >
> > > This could go upward with the other paravirt features flags in
> > > cpuid.c. It could also be an explicit KVM Capability (checked through
> > > check_extension).
> > >
> > > Userspace should then have a chance to decide whether or not this
> > > should be enabled. And when it's not enabled, the host should return a
> > > GP in response to the hypercall. This could be configured either
> > > through userspace stripping out the LM feature bit, or by calling a VM
> > > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> > >
> > > I believe the typical path for a feature like this to be configured
> > > would be to use ENABLE_CAP.
> >
> > I believe we have discussed and reviewed this earlier too.
> >
> > To summarize this feature, the host indicates if it supports the Live
> > Migration feature and the feature and the hypercall are only enabled on
> > the host when the guest checks for this support and does a wrmsrl() to
> > enable the feature. Also the guest will not make the hypercall if the
> > host does not indicate support for it.
> 
> I've gone through and read this patch a bit more closely, and the
> surrounding code. Previously, I clearly misread this and the
> surrounding space.
> 
> What happens if the guest just writes to the MSR anyway? Even if it
> didn't receive a cue to do so? I believe the hypercall would still get
> invoked here, since the hypercall does not check if SEV live migration
> is enabled. Similarly, the MSR for enabling it is always available,
> even if userspace didn't ask for the cpuid bit to be set. This should
> not happen. Userspace should be in control of a new hypercall rolling
> out.
> 
> I believe my interpretation last time was that the cpuid bit was
> getting surfaced from the host kernel to host userspace, but I don't
> actually see that in this patch series. Another way to ask this
> question would be "How does userspace know the kernel they are on has
> this patch series?". It needs some way of checking whether or not the
> kernel underneath it supports SEV live migration. Technically, I think
> userspace could call get_cpuid, set_cpuid (with the same values), and
> then get_cpuid again, and it would be able to infer by checking the
> SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
> support should be easy.
> 
> An additional question is "how does userspace choose whether live
> migration is advertised to the guest"? I believe userspace's desire
> for a particular value of the paravirt feature flag in CPUID get's
> overridden when they call set cpuid, since the feature flag is set in
> svm_vcpu_after_set_cpuid regardless of what userspace asks for.
> Userspace should have a choice in the matter.
> 

To summarize, KVM (host) enables SEV live migration feature as
following:

static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
{
...
        /*
         * If SEV guest then enable the Live migration feature.
         */
        if (sev_guest(vcpu->kvm)) {
                struct kvm_cpuid_entry2 *best;

                best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
                if (!best)
                        return;

                best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
        }

...
...

Later userspace can call cpuid(KVM_CPUID_FEATURES) and get the cpuid data
and override it, for example, this is how Qemu userspace code currently
fixups/overrides the KVM reported CPUID features : 

target/i386/kvm/kvm.c:

uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
                                      uint32_t index, int reg)
{
...
...

  cpuid = get_supported_cpuid(s);

  struct kvm_cpuid_entry2 *entry = cpuid_find_entry(cpuid, function, index);
  if (entry) {
      ret = cpuid_entry_get_reg(entry, reg);
  }
    
  /* Fixups for the data returned by KVM, below */

  ...
  ...

  } else if (function == KVM_CPUID_FEATURES && reg == R_EAX) {
        /* kvm_pv_unhalt is reported by GET_SUPPORTED_CPUID, but it can't
         * be enabled without the in-kernel irqchip
         */
        if (!kvm_irqchip_in_kernel()) {
            ret &= ~(1U << KVM_FEATURE_PV_UNHALT);
        }
        if (kvm_irqchip_is_split()) {
            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
        }
    } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
        ret |= 1U << KVM_HINTS_REALTIME;
    }
    
    return ret;

So you can use a similar approach to override
KVM_FEATURE_SEV_LIVE_MIGRATION feature.

Thanks,
Ashish

> Looking at similar paravirt-y features, there's precedent for another
> way of doing this (may be preferred over CHECK_EXTENSION/ENABLE_CAP?):
> this could call guest_pv_has before running the hypercall. The feature
> (KVM_FEATURE_SEV_LIVE_MIGRATION) would then need to be exposed with
> the other paravirt features in __do_cpuid_func. The function
> guest_pv_has would represent if userspace has decided to expose SEV
> live migration to the guest, and the sev->live_migration_enabled would
> indicate if the guest responded affirmatively to the CPUID bit.
> 
> The downside of using guest_pv_has is that, if pv enforcement is
> disabled, guest_pv_has will always return true, which seems a bit odd
> for a non-SEV guest. This isn't a deal breaker, but seems a bit odd
> for say, a guest that isn't even running SEV. Using CHECK_EXTENSION
> and ENABLE_CAP sidestep that. I'm also not certain I would call this a
> paravirt feature.
> 
> > And these were your review comments on the above :
> > I see I misunderstood how the CPUID bits get passed
> > through: usermode can still override them. Forgot about the back and
> > forth for CPUID with usermode.
> >
> > So as you mentioned, userspace can still override these and it gets a
> > chance to decide whether or not this should be enabled.
> >
> > Thanks,
> > Ashish
> 
> 
> Thanks,
> Steve

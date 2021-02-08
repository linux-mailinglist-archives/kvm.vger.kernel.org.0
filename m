Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA486312899
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 01:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBHAaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 19:30:02 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:52288
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229537AbhBHA37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 19:29:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvliGbjSKML3hHU1ziZpc87upRsWP20gO/VAFCk2ElhbKpV4UH9ws1yJsJ9RBXMWzgEUYQXC1TQEt4q6aIXgqa/qMcyuzib86T7flU1ZeOnCd4YvYGT4XhO5KhntlGrcxPU5GI0JFk28Fk+2mQUSVKUeXxRNRMBQJHaGOAiJTFJtW9cGDHpoPp0Vnv3lzuNlfcstrumlN8OhqlR/XJeRCt8gFu9rp74Fl0WPT3NVUgmM9jaCHPsZIsBniAu4WrUUFYKb+FNfkrU9WP1BIAYHhYh9Jci1FwhjdBCaX0bUgMEYJlwjJp2WYdoXchiYHaxpQwtgRhcaEJV6CLM4v94lHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcKarMma6MbwIV8q50f3jfXPMoMybq1rogB4UqTMIPQ=;
 b=Gqi6Oa5Ypc9lm0YPqAeIFPrWwnApUfp/ucivyi+jdIS1r/HjM+SLVdvDYMqJ3VW/tECHvOs6jNdzwTYZf3t4alnHUunRLvKu/zMOGaaYeAP91+arVoe1nHk8B7y+Gv9iRluclcIjGs6sQ/2Rfge8Kvv6C6HSZCKvl41mtXhMYquk6v0aQYNkM4WVvuQ8JGEfoGHvttPkSt8xnKVnZR+SWP/hXecHWEuEvRNPIVwQZ9ylFoyUTHpfUmJnpo12oTRNiU6GBMNZHffnTxvG6zhvddx7aCcto5WZhQlHy1n4NSH8p4Ic8xUDFr9TymGbHwwhqBBL4FE/IMORGnawpltGbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcKarMma6MbwIV8q50f3jfXPMoMybq1rogB4UqTMIPQ=;
 b=G5fH+w6BFGL/En++GjajdlOh9oTiaWAzUJAFKNIMb3b9iG4IIotBcmP/NcfckbkfXyvJpFD9MutE0S5EHUrUMjcUo1jk3gT5b5Cuv+DRJSp4uL98qunTtZm6Tq7JKZYVt8DttqiB2ludHiQidhtUGU9jxaQQ3ug+6han2SOKnjA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Mon, 8 Feb
 2021 00:29:03 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 00:29:03 +0000
Date:   Mon, 8 Feb 2021 00:28:58 +0000
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
Message-ID: <20210208002858.GA23612@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server>
 <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
 <20210206054617.GA19422@ashkalra_ubuntu_server>
 <20210206135646.GA21650@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206135646.GA21650@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:130::8) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR13CA0003.namprd13.prod.outlook.com (2603:10b6:806:130::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Mon, 8 Feb 2021 00:29:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52e7a6ad-8d21-4ce0-cf47-08d8cbc88922
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368B19C8FEF9AA26F76D2A38E8F9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9Ax+Xr/b4RWdk9n/Z3FMoSL/8PAmCS9ekgFiB+BPuinyRd1JCR6HW/fEkJyTI0hk7y6sbuMdGQUwDdNrd2bepWwEdXx3GpMSWm16Wzp9Ce07Hzzv30AhcxS7liONurmSHtoQzO6J6UpP5iFnApS1or5vJtXZtacECFO/hqPG0yrsqLngtiY+Kiw57mjUX43YVXzVHn+tPeCzhnPaLrTlHcxEmMiBoMpl7n6mN0tuuZuX+rJFQ9cJ6M9WM+Tj5fjHSUyb3XYFwOL2Q7SyFWdvwXUt16rqiZxDgnHSVXeUL478/uw7s7t48xhSbW3cgMmmoW3Lcvr/fU157eZtkPAMB//lEEcy7x3YOv0ksGlzP8nULsPSvlWsgY8Ekc6NyEx1NKzQ4hGhrlPgyP9Sv1tiQHJfX22D9dqx/BoFHQ2pTLwLey9vN/epi233mugo2tKkgE/DArf942tdEz7nyoRBCUPznI5ratZLhaVXeiw3q5tBeoSWf6op1E1ToUXeWrGyhhY2on0nPEzysSC+laewQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(186003)(66556008)(66946007)(83380400001)(16526019)(86362001)(66476007)(316002)(5660300002)(2906002)(33656002)(7416002)(6916009)(54906003)(53546011)(52116002)(44832011)(8936002)(8676002)(55016002)(30864003)(9686003)(1076003)(33716001)(4326008)(26005)(6666004)(478600001)(6496006)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F7BVnbAzIsDZwTze4gMo0Fmto7k9NybIb75/mHgWfQgTzfQtMatEvP8m9/JR?=
 =?us-ascii?Q?HMVW5AY5t3qHng0qxLc+NP+wDkPUPht+0WjF7fnH53PZOP8WUxpgijDEcOAH?=
 =?us-ascii?Q?ojVPaEu7bxH9+Ug9PkoeFvJmT+NS/66rQwq8k/sZ0L/+ZXFOchRDK4I066P0?=
 =?us-ascii?Q?oiP4i3F9xQleSwk4QuW2PY68hmKg8wJlhbmDWQh/yzVNBuHbdXMZuVhunrTd?=
 =?us-ascii?Q?cJIMrgxLyjX287+3pwrgGPDtCyP/0qRATD4sEc7S42m2zjNDoKs9iV0VeHeo?=
 =?us-ascii?Q?5Ub1USkEomJHmboVZWY+DWiCNOszHccbrQwaiPdr6tqhu3tCYk5AsGekOdng?=
 =?us-ascii?Q?rnpTaGZNnGOuPAO6UNtlD/fPa35DtFMjBH2x1RCmkAoy17BKn5tBeJ3Mx2U4?=
 =?us-ascii?Q?ON5qkj6kLwckJShmdpbX1juVVs8w0/tIGYok4dzLKEPlONpJXQ/KZtCGx0NR?=
 =?us-ascii?Q?453QDuwT4ewtu0/To5Gxp4w2t5tsXUkZSEXGkmlqtcU8Bap0bqfNEVc6damX?=
 =?us-ascii?Q?JvEibyUaqWuUv46Ru/C49L5h6eTE014VuDEMRFmK9TqSFFZTskdU88Xbm8Mk?=
 =?us-ascii?Q?x4dgp4PIbzBP2V3astzvEgEsVTNZribWQ9cX9m7k/XWcRkb8EwV37viV3wHb?=
 =?us-ascii?Q?fCVO59zfOEA9lwPjxSOYg+IA2xzTC40edDoS0PvsCApRHP0KNrxkQINebMzQ?=
 =?us-ascii?Q?E9iyJ+t5M8XhQ54lBuuMGwEAtxVd7CmnD0OK47Qw2MgLQizVBi2j2c+sU7fY?=
 =?us-ascii?Q?zps8jJS6JgqTu6FCyDQiVcWWyVusVNsMz7hheCem7ztvpAgyNq9fmtz3RUy+?=
 =?us-ascii?Q?GY2Fod26mrAUZ7lNcKc1J9p5H4zoXpmwgGBfyhMKP+6k0Xp80zEN5cP94ECm?=
 =?us-ascii?Q?NJIAgkA+Bxz2QIfgIkS/vsM0U44z/kJX63cKNDoMBfW+tTFWcaYBnpnBE0zG?=
 =?us-ascii?Q?fXHV8y8emdlnm4vxl6nzK+8qp/ZYkQiEBRJAymNZzDr/VUdvx43WshvSZr4I?=
 =?us-ascii?Q?LlKPzICZi+lnq0mHTvnXOckhOmnW9D4KI0xyWYmAKUrqZIy64+gh8ONizoj8?=
 =?us-ascii?Q?S/1iIQjTzUsQgQCjG7sxRZ913o0m/3qv9JfSjo6/y8SGWfmf2Fg6dRD0itPI?=
 =?us-ascii?Q?170chN/yLTJH6M/qzEW3WVj94aAqLAzcEWbbR/hKL70pgrKlHwrD04BopSdB?=
 =?us-ascii?Q?VKSp9W8jSWWB3vLdw8jwlqwYHUhwpENtsqqxWwVD9iLN/ZkR/5UXTzA0hTzY?=
 =?us-ascii?Q?44ba3mQZpakSsHw28Xvv8HsH+C8AnpnuxMh1EHIG8lAW5Vmjd2cXmXimVIrl?=
 =?us-ascii?Q?WMgPuBBM6vweTjjfaMTkaOeb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e7a6ad-8d21-4ce0-cf47-08d8cbc88922
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 00:29:03.1040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWPCf6KMpsCE6iJrvi8ZS7ahqLKFU+Iee9drvmGs6KXQ9adYu95E5OPrwdoOYig09iO4mLEEEnnrlbAcorqHOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve, 

On Sat, Feb 06, 2021 at 01:56:46PM +0000, Ashish Kalra wrote:
> Hello Steve,
> 
> On Sat, Feb 06, 2021 at 05:46:17AM +0000, Ashish Kalra wrote:
> > Hello Steve,
> > 
> > Continued response to your queries, especially related to userspace
> > control of SEV live migration feature : 
> > 
> > On Fri, Feb 05, 2021 at 06:54:21PM -0800, Steve Rutherford wrote:
> > > On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > >
> > > > Hello Steve,
> > > >
> > > > On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > > > > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > > >
> > > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > > >
> > > > > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > > > > for host-side support for SEV live migration. Also add a new custom
> > > > > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > > > > feature.
> > > > > >
> > > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > ---
> > > > > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > > > > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > > > > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > > > > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > > > > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > > > > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > > > > >  6 files changed, 52 insertions(+)
> > > > > >
> > > > > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > > > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > > > > --- a/Documentation/virt/kvm/cpuid.rst
> > > > > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > > > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > > > > >                                                 before using extended destination
> > > > > >                                                 ID bits in MSI address bits 11-5.
> > > > > >
> > > > > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > > > > +                                               using the page encryption state
> > > > > > +                                               hypercall to notify the page state
> > > > > > +                                               change
> > > > > > +
> > > > > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > > > > >                                                 per-cpu warps are expected in
> > > > > >                                                 kvmclock
> > > > > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > > > > index e37a14c323d2..020245d16087 100644
> > > > > > --- a/Documentation/virt/kvm/msr.rst
> > > > > > +++ b/Documentation/virt/kvm/msr.rst
> > > > > > @@ -376,3 +376,15 @@ data:
> > > > > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > > > > >         and check if there are more notifications pending. The MSR is available
> > > > > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > > > > +
> > > > > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > +        0x4b564d08
> > > > > > +
> > > > > > +       Control SEV Live Migration features.
> > > > > > +
> > > > > > +data:
> > > > > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > > > > +        in other words, this is guest->host communication that it's properly
> > > > > > +        handling the shared pages list.
> > > > > > +
> > > > > > +        All other bits are reserved.
> > > > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > index 950afebfba88..f6bfa138874f 100644
> > > > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > @@ -33,6 +33,7 @@
> > > > > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > > > > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > > > > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > > > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > > > > >
> > > > > >  #define KVM_HINTS_REALTIME      0
> > > > > >
> > > > > > @@ -54,6 +55,7 @@
> > > > > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > > > > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > > > > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > > > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > > > > >
> > > > > >  struct kvm_steal_time {
> > > > > >         __u64 steal;
> > > > > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > > > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > > > >
> > > > > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > > > > +
> > > > > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > index b0d324aed515..93f42b3d3e33 100644
> > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > > > > >         return ret;
> > > > > >  }
> > > > > >
> > > > > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > > > > +{
> > > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > > +
> > > > > > +       if (!sev_guest(kvm))
> > > > > > +               return;
> > > > >
> > > > > This should assert that userspace wanted the guest to be able to make
> > > > > these calls (see more below).
> > > > >
> > > > > >
> > > > > > +
> > > > > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > > > > +}
> > > > > > +
> > > > > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > >                               struct kvm_shared_pages_list *list)
> > > > > >  {
> > > > > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > >         if (!sev_guest(kvm))
> > > > > >                 return -ENOTTY;
> > > > > >
> > > > > > +       if (!sev->live_migration_enabled)
> > > > > > +               return -EINVAL;
> > > 
> > > This is currently under guest control, so I'm not certain this is
> > > helpful. If I called this with otherwise valid parameters, and got
> > > back -EINVAL, I would probably think the bug is on my end. But it
> > > could be on the guest's end! I would probably drop this, but you could
> > > have KVM return an empty list of regions when this happens.
> > > 
> > > Alternatively, as explained below, this could call guest_pv_has instead.
> > > 
> > > >
> > > > > > +
> > > > > >         if (!list->size)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > > index 58f89f83caab..43ea5061926f 100644
> > > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > > >                 svm->msr_decfg = data;
> > > > > >                 break;
> > > > > >         }
> > > > > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > > > > +               break;
> > > > > >         case MSR_IA32_APICBASE:
> > > > > >                 if (kvm_vcpu_apicv_active(vcpu))
> > > > > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > > > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > > > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > > > > >         }
> > > > > >
> > > > > > +       /*
> > > > > > +        * If SEV guest then enable the Live migration feature.
> > > > > > +        */
> > > > > > +       if (sev_guest(vcpu->kvm)) {
> > > > > > +               struct kvm_cpuid_entry2 *best;
> > > > > > +
> > > > > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > > > > +               if (!best)
> > > > > > +                       return;
> > > > > > +
> > > > > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > > > > +       }
> > > > > > +
> > > > >
> > > > > Looking at this, I believe the only way for this bit to get enabled is
> > > > > if userspace toggles it. There needs to be a way for userspace to
> > > > > identify if the kernel underneath them does, in fact, support SEV LM.
> > > > > I'm at risk for having misread these patches (it's a long series), but
> > > > > I don't see anything that communicates upwards.
> > > > >
> > > > > This could go upward with the other paravirt features flags in
> > > > > cpuid.c. It could also be an explicit KVM Capability (checked through
> > > > > check_extension).
> > > > >
> > > > > Userspace should then have a chance to decide whether or not this
> > > > > should be enabled. And when it's not enabled, the host should return a
> > > > > GP in response to the hypercall. This could be configured either
> > > > > through userspace stripping out the LM feature bit, or by calling a VM
> > > > > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> > > > >
> > > > > I believe the typical path for a feature like this to be configured
> > > > > would be to use ENABLE_CAP.
> > > >
> > > > I believe we have discussed and reviewed this earlier too.
> > > >
> > > > To summarize this feature, the host indicates if it supports the Live
> > > > Migration feature and the feature and the hypercall are only enabled on
> > > > the host when the guest checks for this support and does a wrmsrl() to
> > > > enable the feature. Also the guest will not make the hypercall if the
> > > > host does not indicate support for it.
> > > 
> > > I've gone through and read this patch a bit more closely, and the
> > > surrounding code. Previously, I clearly misread this and the
> > > surrounding space.
> > > 
> > > What happens if the guest just writes to the MSR anyway? Even if it
> > > didn't receive a cue to do so? I believe the hypercall would still get
> > > invoked here, since the hypercall does not check if SEV live migration
> > > is enabled. Similarly, the MSR for enabling it is always available,
> > > even if userspace didn't ask for the cpuid bit to be set. This should
> > > not happen. Userspace should be in control of a new hypercall rolling
> > > out.
> > > 
> > > I believe my interpretation last time was that the cpuid bit was
> > > getting surfaced from the host kernel to host userspace, but I don't
> > > actually see that in this patch series. Another way to ask this
> > > question would be "How does userspace know the kernel they are on has
> > > this patch series?". It needs some way of checking whether or not the
> > > kernel underneath it supports SEV live migration. Technically, I think
> > > userspace could call get_cpuid, set_cpuid (with the same values), and
> > > then get_cpuid again, and it would be able to infer by checking the
> > > SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
> > > support should be easy.
> > > 
> > > An additional question is "how does userspace choose whether live
> > > migration is advertised to the guest"? I believe userspace's desire
> > > for a particular value of the paravirt feature flag in CPUID get's
> > > overridden when they call set cpuid, since the feature flag is set in
> > > svm_vcpu_after_set_cpuid regardless of what userspace asks for.
> > > Userspace should have a choice in the matter.
> > > 
> 
> Actually i did some more analysis of this, and i believe you are right
> about the above, feature flag gets set in svm_vcpu_after_set_cpuid.
> 

As you mentioned above and as i confirmed in my previous email,
calling KVM_SET_CPUID2 vcpu ioctl will always set the live migration
feature flag for the vCPU. 

This is what will be queried by the guest to enable the kernel's
live migration feature and to start making hypercalls.

Now, i want to understand why do you want the userspace to have a 
choice in this matter ?

After all, it is the userspace which actually initiates the live 
migration process, so doesn't it have the final choice in this
matter ?

Even if this feature is reported by host, the guest only uses
it to enable and make page encryption status hypercalls 
and the host's shared pages list gets setup accordingly. 

But unless userspace calls KVM_GET_SHARED_PAGES_LIST ioctl and
initiates live migration process, the above is simply enabling
the guest to make hypercalls whenever a page's encryption 
status is changed.

Thanks,
Ashish

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C10E311D88
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 14:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBFN5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 08:57:50 -0500
Received: from mail-eopbgr690052.outbound.protection.outlook.com ([40.107.69.52]:48877
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229508AbhBFN5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 08:57:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QamuWuWF1Oz++z/zUKcLYv4whe01GzdS+LUIYDRd+ucn0c0HTgrf/dOC2Jw+31tmE0sKJxlC5s7yIOZQxQw93YD0zl1IkuhMacFx6Cnn9PnWkByYxcGOn9RxRiJbu42gDd3MWARiy3JtwzyZTppuxtzAiltjohu7wkCRd5uX6FYXFn0uPSJoUPwePM7PbnYvZa+BanLcIVk8vKLplsPWzcH6jQzLD3CUjOEx2nWlvgLR2UXTvDc5oicQc89AWdS9cZdQvBhA8EupBW3K4PD3LSUz+s00LcRMKFLjrIVuQLsM4aqZFsiNx5np4lKTWYnC9PoKel5dK/+JHuGe2dc/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdz5InBcAYVipxcpe5l1q3ZssyuZMdJm1Hzrhmgu2Mk=;
 b=OhMY4E9P+RZilgy2w6X/xwumQtV+x5JS177gCWP54oagWlP1ZY8Ux7RkUNrwj974+h4bfFo4rMQNKjWn3ooBeiEoI7rDxbxzNlsuL+4Z6hS6G0Ofvz7F8kUuoWdE88RGRZBSg9itqzXVpvgj/355waGaFOf7Gp06yS44kHNl6Z+GvLy9a5T4jlhMUallQMIGCjxktzERBumSVCZyVQg8KKy+Eakt6UlfADeqmoCe+R3OrMpsYfrSTKdmR9xt+OI2o/vKCnfdo7bzdePJ1qHz/p4bUYcloniTs7wawTQOgGGE1xfi7M7tJ9qFNuW/4aWp/MnNP2dnj7c900CsJAfnrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdz5InBcAYVipxcpe5l1q3ZssyuZMdJm1Hzrhmgu2Mk=;
 b=v6swNcowJmGkg6jgVLxJt3DUNBtQxZKB8RfAoyAE/srCiuPhYDBq3pqM3tsQUeLy1fTuBcKyRczPk3M+hYGBUJv5uVZCok3VkqkRjI5b0dhHUDBKj+dzjoaZEv9og5pu+H0u04eLtKZKPqu/Kpkkt8mIRJb2wJI/JEX8t2Uk+J4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BY5PR12MB3667.namprd12.prod.outlook.com (2603:10b6:a03:1a2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sat, 6 Feb
 2021 13:56:53 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::bc18:d462:74e:d379]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::bc18:d462:74e:d379%3]) with mapi id 15.20.3784.019; Sat, 6 Feb 2021
 13:56:53 +0000
Date:   Sat, 6 Feb 2021 13:56:46 +0000
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
Message-ID: <20210206135646.GA21650@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server>
 <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
 <20210206054617.GA19422@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206054617.GA19422@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:806:27::19) To BYAPR12MB2759.namprd12.prod.outlook.com
 (2603:10b6:a03:61::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0134.namprd13.prod.outlook.com (2603:10b6:806:27::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.15 via Frontend Transport; Sat, 6 Feb 2021 13:56:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a35abf44-ef14-4e81-bde2-08d8caa70eb6
X-MS-TrafficTypeDiagnostic: BY5PR12MB3667:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB3667011BF8B0210A324FF56A8EB19@BY5PR12MB3667.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yg1nzcNJ9eMRWL9q7p+HtKDdAVD5uS4XqB0pUc7aop19f0J4N6TXeAZnc1qiSyaHUXZ6enBp07H6wLTV29yX8zbxBCFrjFe/FsZRsJ30PRm8tQzHUCxamgC0h3jsJej/AtKXb9ZjBMGqil+1qON+ydmEkFhXkSKwieGbYX8/tVqLPXXYuT5TzToEGiZBJ6vZSJSYsrriAj/0HZIm8NU+uZrsdaDzrK2CJnisNkiFZzo3opQoVmUwWyIhFiLFOJiTvghX1RkKi2kLmPHLaEkahm56OXxYKnPqapPXqbWEEjL+YL6UFgSeiWBMRH+QbvllWBgexoXKe+j+5fI9T/4WbR5NIsOSbaPRb7KW05bAGQNnnJn+zvGWo30mD5WOSFk1rpIVWr3v77XP5JjcrTl0yvx33IuINZbvzYk0eHWZYb4CUfqosEgU8cB4kqCtTYDi4L6sHG363LNehdGUrSERh082/DgtYN9a+tfpiCSd5qnBh6K/ClJf0vYf/npbEHBO2AH7iEilwZJGAwPKI0f14Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(6916009)(55016002)(9686003)(7416002)(33656002)(86362001)(8676002)(33716001)(2906002)(66946007)(83380400001)(66476007)(53546011)(16526019)(186003)(26005)(956004)(44832011)(4326008)(478600001)(8936002)(6496006)(52116002)(6666004)(66556008)(5660300002)(1076003)(30864003)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cbPai/cLaV+BUpmZA6oXER2wPO9YUEjn1S+bkzjKf+pid1K/tQN+0dJ0eTuc?=
 =?us-ascii?Q?rljHR1Yzb12y3a8D4LDhS0660xM7RNAcjvTqBg+2R7D7AA/GAK4mfJX/sZ3C?=
 =?us-ascii?Q?8DlQ8NkJeUKIK/bmYHRB0NoAZ2DWaCJb2T0c0ra3T3tmPdrLlYV7YIIvNeZA?=
 =?us-ascii?Q?kZjktiAYeslru3CWmZ3q94JMVXWyFNMROkDQu6axnIIYVzKAPUmP/Fxh8MSP?=
 =?us-ascii?Q?0k5EPsbHn8bPAEmS9ovacYKJlH2bstKQhvUWmU2eOOpWOtxZWm+Z0FH4bjCP?=
 =?us-ascii?Q?Pmu7MfHpFHjxNOooWC2f3a1GcsLRNs65I/c2KRyaSLge+yYeVj/EgIffjhbz?=
 =?us-ascii?Q?3oaVkkmv0kNXD+PYrOPtCx5yAop3UdbGvFKYWz9aI0epChCbzIAgLItoLRGG?=
 =?us-ascii?Q?DD6bMI/t/seuhD1AXrj7LZzTJbhd+CimeL8wooE3GsnF4u0aw0rLET/HttoR?=
 =?us-ascii?Q?AaXUjngLJViI10eyQ94/CwcaBo7H87FYEcf3EuRGDTFEbYB6YRL2XWeT5VjR?=
 =?us-ascii?Q?CHKKpDTUz664WCKhp24wwXq57x76y1LNmnRcTMB7PYouKwPxWP0Fvlfw4Wh5?=
 =?us-ascii?Q?bgmtpd3WBbTEddqUzhMxs6Xct3bT8UMOV/tlGWrhg8MsOLcu+kcD43AXwV+N?=
 =?us-ascii?Q?QeElArOiEjvaJtZutkqicba7a5wrUi9Riopp8x/0oILgLHyNwsdoQmzpm9Og?=
 =?us-ascii?Q?zYs7nGSmRlyZK7n8Ivi3GSlyVfFqGn9eke42SJr7uUiYJpNvMCSaKVFKbz+t?=
 =?us-ascii?Q?v5cBG4Ia3zHLUNUAsddBySvYYf6Q5dDzhWSuDCNXsXk8B2J8Qq1cpWuCsCRb?=
 =?us-ascii?Q?NDIp6ACLFahjOTVzWZhc2E4bPdbX0JoubbQ/PrhCQfR3m//v0lDV+z9lSSWi?=
 =?us-ascii?Q?M7bnijPUlmbCryfAJhjEcUlc47RHH5jwYiS/suorNFnweaRB2yuYqE1VwzY7?=
 =?us-ascii?Q?RYA6JeVCdQXC09lneoMiXh93L9026am1T+PvzlQan2W8GJDVhgV5Wy5YM+Ut?=
 =?us-ascii?Q?tyC2FwGuSEKi6wPlRw4Ywu+aS+eDs9Na70+PzVyjv3jo5gRkZMvouvBRFi9P?=
 =?us-ascii?Q?OexkrDqWljq+v6EOmjBaBWnES8tUho7V3P5gxwZT2IlPbc1Ucfb+1purXTrR?=
 =?us-ascii?Q?9AI6ORRiC72bbGpVP/iv0hsTYJtwtVHh3srK7qWL4P2nHz5Sp5I6oHaut1AX?=
 =?us-ascii?Q?nnnEsJ2q557KQ7X6AOL/7XBe5Zyrp8dn7h2sUootkfJLWg8kDYKUzRvgQlp+?=
 =?us-ascii?Q?dPybGZY7beeika0AjQ8YkI3GxplLAB/XoZkbFgwKfC+C2SDR0KXQ4pWdxptG?=
 =?us-ascii?Q?9f1ePird1nnSXBMMIKb/vzGc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35abf44-ef14-4e81-bde2-08d8caa70eb6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2021 13:56:53.5857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Zz/Og2iIC1Doxih/ecQyguWTGG/Ox6yxUxVMUfLh2gPZcy4JSDvZkDX4kkr3Pr2f07EClE86IKP+ASNUmM6xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3667
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Sat, Feb 06, 2021 at 05:46:17AM +0000, Ashish Kalra wrote:
> Hello Steve,
> 
> Continued response to your queries, especially related to userspace
> control of SEV live migration feature : 
> 
> On Fri, Feb 05, 2021 at 06:54:21PM -0800, Steve Rutherford wrote:
> > On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >
> > > Hello Steve,
> > >
> > > On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > > > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > >
> > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > >
> > > > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > > > for host-side support for SEV live migration. Also add a new custom
> > > > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > > > feature.
> > > > >
> > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > ---
> > > > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > > > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > > > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > > > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > > > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > > > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > > > >  6 files changed, 52 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > > > --- a/Documentation/virt/kvm/cpuid.rst
> > > > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > > > >                                                 before using extended destination
> > > > >                                                 ID bits in MSI address bits 11-5.
> > > > >
> > > > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > > > +                                               using the page encryption state
> > > > > +                                               hypercall to notify the page state
> > > > > +                                               change
> > > > > +
> > > > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > > > >                                                 per-cpu warps are expected in
> > > > >                                                 kvmclock
> > > > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > > > index e37a14c323d2..020245d16087 100644
> > > > > --- a/Documentation/virt/kvm/msr.rst
> > > > > +++ b/Documentation/virt/kvm/msr.rst
> > > > > @@ -376,3 +376,15 @@ data:
> > > > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > > > >         and check if there are more notifications pending. The MSR is available
> > > > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > > > +
> > > > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > +        0x4b564d08
> > > > > +
> > > > > +       Control SEV Live Migration features.
> > > > > +
> > > > > +data:
> > > > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > > > +        in other words, this is guest->host communication that it's properly
> > > > > +        handling the shared pages list.
> > > > > +
> > > > > +        All other bits are reserved.
> > > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > index 950afebfba88..f6bfa138874f 100644
> > > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > @@ -33,6 +33,7 @@
> > > > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > > > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > > > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > > > >
> > > > >  #define KVM_HINTS_REALTIME      0
> > > > >
> > > > > @@ -54,6 +55,7 @@
> > > > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > > > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > > > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > > > >
> > > > >  struct kvm_steal_time {
> > > > >         __u64 steal;
> > > > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > > >
> > > > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > > > +
> > > > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index b0d324aed515..93f42b3d3e33 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > > > >         return ret;
> > > > >  }
> > > > >
> > > > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > > > +{
> > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > +
> > > > > +       if (!sev_guest(kvm))
> > > > > +               return;
> > > >
> > > > This should assert that userspace wanted the guest to be able to make
> > > > these calls (see more below).
> > > >
> > > > >
> > > > > +
> > > > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > > > +}
> > > > > +
> > > > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > > > >                               struct kvm_shared_pages_list *list)
> > > > >  {
> > > > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > > > >         if (!sev_guest(kvm))
> > > > >                 return -ENOTTY;
> > > > >
> > > > > +       if (!sev->live_migration_enabled)
> > > > > +               return -EINVAL;
> > 
> > This is currently under guest control, so I'm not certain this is
> > helpful. If I called this with otherwise valid parameters, and got
> > back -EINVAL, I would probably think the bug is on my end. But it
> > could be on the guest's end! I would probably drop this, but you could
> > have KVM return an empty list of regions when this happens.
> > 
> > Alternatively, as explained below, this could call guest_pv_has instead.
> > 
> > >
> > > > > +
> > > > >         if (!list->size)
> > > > >                 return -EINVAL;
> > > > >
> > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > index 58f89f83caab..43ea5061926f 100644
> > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > >                 svm->msr_decfg = data;
> > > > >                 break;
> > > > >         }
> > > > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > > > +               break;
> > > > >         case MSR_IA32_APICBASE:
> > > > >                 if (kvm_vcpu_apicv_active(vcpu))
> > > > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > > > >         }
> > > > >
> > > > > +       /*
> > > > > +        * If SEV guest then enable the Live migration feature.
> > > > > +        */
> > > > > +       if (sev_guest(vcpu->kvm)) {
> > > > > +               struct kvm_cpuid_entry2 *best;
> > > > > +
> > > > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > > > +               if (!best)
> > > > > +                       return;
> > > > > +
> > > > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > > > +       }
> > > > > +
> > > >
> > > > Looking at this, I believe the only way for this bit to get enabled is
> > > > if userspace toggles it. There needs to be a way for userspace to
> > > > identify if the kernel underneath them does, in fact, support SEV LM.
> > > > I'm at risk for having misread these patches (it's a long series), but
> > > > I don't see anything that communicates upwards.
> > > >
> > > > This could go upward with the other paravirt features flags in
> > > > cpuid.c. It could also be an explicit KVM Capability (checked through
> > > > check_extension).
> > > >
> > > > Userspace should then have a chance to decide whether or not this
> > > > should be enabled. And when it's not enabled, the host should return a
> > > > GP in response to the hypercall. This could be configured either
> > > > through userspace stripping out the LM feature bit, or by calling a VM
> > > > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> > > >
> > > > I believe the typical path for a feature like this to be configured
> > > > would be to use ENABLE_CAP.
> > >
> > > I believe we have discussed and reviewed this earlier too.
> > >
> > > To summarize this feature, the host indicates if it supports the Live
> > > Migration feature and the feature and the hypercall are only enabled on
> > > the host when the guest checks for this support and does a wrmsrl() to
> > > enable the feature. Also the guest will not make the hypercall if the
> > > host does not indicate support for it.
> > 
> > I've gone through and read this patch a bit more closely, and the
> > surrounding code. Previously, I clearly misread this and the
> > surrounding space.
> > 
> > What happens if the guest just writes to the MSR anyway? Even if it
> > didn't receive a cue to do so? I believe the hypercall would still get
> > invoked here, since the hypercall does not check if SEV live migration
> > is enabled. Similarly, the MSR for enabling it is always available,
> > even if userspace didn't ask for the cpuid bit to be set. This should
> > not happen. Userspace should be in control of a new hypercall rolling
> > out.
> > 
> > I believe my interpretation last time was that the cpuid bit was
> > getting surfaced from the host kernel to host userspace, but I don't
> > actually see that in this patch series. Another way to ask this
> > question would be "How does userspace know the kernel they are on has
> > this patch series?". It needs some way of checking whether or not the
> > kernel underneath it supports SEV live migration. Technically, I think
> > userspace could call get_cpuid, set_cpuid (with the same values), and
> > then get_cpuid again, and it would be able to infer by checking the
> > SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
> > support should be easy.
> > 
> > An additional question is "how does userspace choose whether live
> > migration is advertised to the guest"? I believe userspace's desire
> > for a particular value of the paravirt feature flag in CPUID get's
> > overridden when they call set cpuid, since the feature flag is set in
> > svm_vcpu_after_set_cpuid regardless of what userspace asks for.
> > Userspace should have a choice in the matter.
> > 

Actually i did some more analysis of this, and i believe you are right
about the above, feature flag gets set in svm_vcpu_after_set_cpuid.

So please ignore my comments below. 

I am still analyzing this further.

Thanks,
Ashish
> 
> To summarize, KVM (host) enables SEV live migration feature as
> following:
> 
> static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> {
> ...
>         /*
>          * If SEV guest then enable the Live migration feature.
>          */
>         if (sev_guest(vcpu->kvm)) {
>                 struct kvm_cpuid_entry2 *best;
> 
>                 best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
>                 if (!best)
>                         return;
> 
>                 best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
>         }
> 
> ...
> ...
> 
> Later userspace can call cpuid(KVM_CPUID_FEATURES) and get the cpuid data
> and override it, for example, this is how Qemu userspace code currently
> fixups/overrides the KVM reported CPUID features : 
> 
> target/i386/kvm/kvm.c:
> 
> uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>                                       uint32_t index, int reg)
> {
> ...
> ...
> 
>   cpuid = get_supported_cpuid(s);
> 
>   struct kvm_cpuid_entry2 *entry = cpuid_find_entry(cpuid, function, index);
>   if (entry) {
>       ret = cpuid_entry_get_reg(entry, reg);
>   }
>     
>   /* Fixups for the data returned by KVM, below */
> 
>   ...
>   ...
> 
>   } else if (function == KVM_CPUID_FEATURES && reg == R_EAX) {
>         /* kvm_pv_unhalt is reported by GET_SUPPORTED_CPUID, but it can't
>          * be enabled without the in-kernel irqchip
>          */
>         if (!kvm_irqchip_in_kernel()) {
>             ret &= ~(1U << KVM_FEATURE_PV_UNHALT);
>         }
>         if (kvm_irqchip_is_split()) {
>             ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
>         }
>     } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
>         ret |= 1U << KVM_HINTS_REALTIME;
>     }
>     
>     return ret;
> 
> So you can use a similar approach to override
> KVM_FEATURE_SEV_LIVE_MIGRATION feature.
> 
> Thanks,
> Ashish
> 
> > Looking at similar paravirt-y features, there's precedent for another
> > way of doing this (may be preferred over CHECK_EXTENSION/ENABLE_CAP?):
> > this could call guest_pv_has before running the hypercall. The feature
> > (KVM_FEATURE_SEV_LIVE_MIGRATION) would then need to be exposed with
> > the other paravirt features in __do_cpuid_func. The function
> > guest_pv_has would represent if userspace has decided to expose SEV
> > live migration to the guest, and the sev->live_migration_enabled would
> > indicate if the guest responded affirmatively to the CPUID bit.
> > 
> > The downside of using guest_pv_has is that, if pv enforcement is
> > disabled, guest_pv_has will always return true, which seems a bit odd
> > for a non-SEV guest. This isn't a deal breaker, but seems a bit odd
> > for say, a guest that isn't even running SEV. Using CHECK_EXTENSION
> > and ENABLE_CAP sidestep that. I'm also not certain I would call this a
> > paravirt feature.
> > 
> > > And these were your review comments on the above :
> > > I see I misunderstood how the CPUID bits get passed
> > > through: usermode can still override them. Forgot about the back and
> > > forth for CPUID with usermode.
> > >
> > > So as you mentioned, userspace can still override these and it gets a
> > > chance to decide whether or not this should be enabled.
> > >
> > > Thanks,
> > > Ashish
> > 
> > 
> > Thanks,
> > Steve

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C379F311B28
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 05:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhBFEwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 23:52:38 -0500
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:20832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231578AbhBFEuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 23:50:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0OQFQ3eClykVW91mgjvWOeqwq8Xl7iF/lAYQax+j8GPGTONM48CPlA9kpLzbS2mrhVZZUnxssCYVTSm2gxVW79BJeAMZxKaiizrBErkGd6mlyFvmQXCUs6GvZnF887cJ0C+N2lggST2pafpnWSyVblrAYP2PvQN8B9FBpinzCSU98lvP1nncLrLsDk443uqGCdVsAssQwBlxpvgmVezXxzoCyr4PpkaJZFjJwtSZsNXXkc4rZCyxNXcCw8nw6rnlvflPQDGdQJj06MAbzUZYI9dOjeWyVE8z/g7HpKF8ApcrH6QtemuWBtr8/HIEdEmhJUf9kNYOgsgGG0y/L+6xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfa8//jJqX/arrxRS3wCbZnagnckWziHvPyUvjAQLjc=;
 b=K8RJdi7sdaCeJwobXPHo7IJFLV8UGbDpZtnFD6tiim2ZLa/pXlJnBs6IZ4zjVALJcAMRKf9qaZ2c7VjT6EvGhhRaKIYoSW9BPlS9xqODT58j2TZpS7vm4ETHZeNbLJbVPG0JZLY6GG6OqF5VFTG9HF2gytEGy8F6x0bG1SrOc1vUZmWa8dGsD9N8mrJ9FLz2ryy04jtO3ZSsMCnr/xWfUM/Y8J/9smsVELb4eCr/2DYUXGVvGeiHs55VsozS1VqEpyETUWCyC13Dt/A3FBsTa8N1HWkXeZrtvgRx7I6sCVhsxBi6tc6REmmHU+35uzPw/qzsQ7IHNDGJOFix1huo1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfa8//jJqX/arrxRS3wCbZnagnckWziHvPyUvjAQLjc=;
 b=VSp4CN9MgdYezNTY2bSU5uJ2NgFRxFyD6X7c4mMjUu5x/7nDSy0HPRbvqyynXcD8glf8s7lPB4T09RsTBv0BKPYDWe1R3h9jhHlHwbvUX2mw3D2oRINWeRcaJiLtiK6LY6q/egWQ4GORb/kvpmcWKFJTbnXu37qgzoD9rqb3eX4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2766.namprd12.prod.outlook.com (2603:10b6:805:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Sat, 6 Feb
 2021 04:49:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Sat, 6 Feb 2021
 04:49:21 +0000
Date:   Sat, 6 Feb 2021 04:49:16 +0000
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
Message-ID: <20210206044916.GA16038@ashkalra_ubuntu_server>
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
X-ClientProxiedBy: SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Sat, 6 Feb 2021 04:49:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fd4fa0fa-7ea6-458f-3c45-08d8ca5a91c6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB276684A452CD728540B14FEE8EB19@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zKEEnoq5c8weyev7VlaCivM6+lkaELrhXLnkzvfBqRe5ucP5P5KBKupzYqdkwHI/YhZ4vluywe7r+UYtvRfp0g+7q97Z/CvD2aaLzIvtQYD4QEQt1LdZntAn6BRPPrH2nL274Mdt8WXktFMm+utM5HSdGGy86T4f7y6omNJcI+iiunbZuFwWPhBXOV13UrDSDeoNbOIxee8sZG/aOOR3AMNdyxCGP73Ic1VpP0pvpE/jLEwHruD3nl6op0+PzalQU9b1th8DTfthHjsLiVyd8SLAJZctgGbsmzuGA57pllaOcy9N5MV0v43BcSXE/8HQ9vNh5zmU0ejvWQbGoKlKFTT/qe+18yPPj3V52kmZOOhcpdBETnOhmRZ3DYTQBR/R07JltAhoY5vY0anTqVHRkK3ErQfufVIT2t+3b5yiEgCPTyrot6HJB8bB+cb1lJWN507lM7FliZ2dDh5lPoBtHyGQG+HHYNTY7mZ8pLY/4V6whUW5yvB8HmelvfmZQx1ppNZGwG5mP3/4JAotw8CQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(136003)(376002)(396003)(54906003)(66556008)(33716001)(66946007)(478600001)(44832011)(9686003)(66476007)(186003)(55016002)(6666004)(316002)(83380400001)(30864003)(956004)(26005)(16526019)(1076003)(4326008)(5660300002)(8936002)(6496006)(33656002)(86362001)(7416002)(2906002)(6916009)(53546011)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?arvudiCgpL6Lxk07kJQVblNWLDK3M1manLjnoiPVruq3f5V6Z01N1+NT29qA?=
 =?us-ascii?Q?St3S12cfKQPW207eFOrvqqdAgqF6nNwzIlHPlvWD2tANaDeozV0rEMyP3g8P?=
 =?us-ascii?Q?P3vE1tvxw1+mL3Ch5WbmkSVjH7VlTPeNMOIMds57jqGhKQT0yy8QrUmUDq0/?=
 =?us-ascii?Q?tf9upFNOiDQM2hubC2++ML1kEj2TKCvQpHZHmcQOTFfLDiybkiwNpHq8qEab?=
 =?us-ascii?Q?71Kb5fUgtdHySD1tTrxBPHwo3a/t+M97f1nK7dm5ZzoE2xz/GQq2KjVMX+lP?=
 =?us-ascii?Q?GNLRvEFl/raYkS9a3rBVkVCATdHM4QseGCzpX4qaloSp256qXsxLssRxuL6B?=
 =?us-ascii?Q?tFwI3lT5Ls6FZx+0QJH/m0aLWbuKFtS4tB5r+BL4nx1MOmXZKpDJUSz8DN98?=
 =?us-ascii?Q?qhJDmN7ghz0VNhk5YHkxI/aMmc1LiNCAvO43+t3SMl/9ZWP7L5jJzYUDGpX6?=
 =?us-ascii?Q?SZ5DsLYyhOSLbWvGc9VUMQFLVQwSxpo5n26PyVjw6B/goGgsBVZZdt34zUZk?=
 =?us-ascii?Q?rQH/XZ2BWwYDbMe+JqgmnH0ghNaeFChyc+S2Mlx8jf9m5smL1mvP9pLbDppw?=
 =?us-ascii?Q?2P6bdSpKoyPIR+5xJ/Aty9VhsxHtF92gvPDPtt/uwtkzWe9TOs/kr27DrhUr?=
 =?us-ascii?Q?eZQgdbCG42otJBG2KT8jVD/ug7I7XHox4sEtRum2tkPSvHExiKzUuHjOWfRm?=
 =?us-ascii?Q?5na7HSyl/jHlrX/NWPOyTbZVlpONlRf/2ChmQ6lmEz0o8KhwCYLtwqOI2yRQ?=
 =?us-ascii?Q?2UaSTq0snROKe7ZOkUkr3YizcF6w4IOKtqDvFET4MQ2few0mZy1yUWbvteWD?=
 =?us-ascii?Q?/pUHEIB9URA42S+vSSOWyJ9SGl86t+qlRMvAi/wrXZHEITMxajPJpMrAZxPP?=
 =?us-ascii?Q?u6g0jZvIKfn+Npl7JoBEsGk62KDOkFndIkR/lMYX319EIu9QXNTccWEHqTC0?=
 =?us-ascii?Q?IucDFQkz60XgUNFVmbMRSRn68BMY3WDmZCcpgBInv5vu3HKnb0xxAwXYeg+o?=
 =?us-ascii?Q?WyP1noirNubkt5Okg9rFl1jiLGS7q658la8umK1eN4idwXWfEC9wkV7xZn15?=
 =?us-ascii?Q?b3B92b5en2Ni8P1RQXDcaMYUNiI5JbfRkIuHOwJsIsrCT0Qp9N7gLpp91orH?=
 =?us-ascii?Q?UNV/bxzFIfbaC4/mHuHZnu1gWQds5VdQThvvNwkAGw1+qhdXAW/mhleRbo3a?=
 =?us-ascii?Q?tFJ2lX3KZwXXuRxniSdz46upEwEGEC9X6gHpQLY4Y5nNSOmjWUrEMN7K8rIC?=
 =?us-ascii?Q?CoHk7X6RriQKxuvi2/4anCD5xgoGiANCcca+/pT9ihkytzBUr85uuVQ5WNrN?=
 =?us-ascii?Q?BSTY3vxfOzVwn0ZprHasjeFB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4fa0fa-7ea6-458f-3c45-08d8ca5a91c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2021 04:49:21.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 037JvnWgYr1aa0qx20frwukUTFDLyDnTzpURcLqLczENMm0OAU04UXqEUl9dMLm92kTgUGQyiY7PNvTqgFLLTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

Let me first answer those queries which i can do immediately ...

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

You will get -EINVAL till the guest kernel has booted to a specific
point, because live migration is enabled when guest kernel has checked
for host support for live migration and also OVMF/UEFI support for
live migration, as per this guest kernel code below :

arch/x86/kernel/kvm.c:

kvm_init_platform() -> check_kvm_sev_migration()
..

arch/x86/mm/mem_encrypt.c:

void __init check_kvm_sev_migration(void)
{
        if (sev_active() &&
            kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
                unsigned long nr_pages;

                pr_info("KVM enable live migration\n");
                sev_live_migration_enabled = true;

                /*
                 * Ensure that _bss_decrypted section is marked as decrypted in the
                 * shared pages list.
                 */
                nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
                                        PAGE_SIZE);
                early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
                                                nr_pages, 0);

                /*
                 * If not booted using EFI, enable Live migration support.
                 */
                if (!efi_enabled(EFI_BOOT))
                        wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
                               KVM_SEV_LIVE_MIGRATION_ENABLED);
	} else {
                        pr_info("KVM enable live migration feature unsupported\n");
                }       

Later, setup_kvm_sev_migration() invoked via a late initcall, checks for
live migration supported(setup above) and UEFI/OVMF support for live
migration and then enables live migration on the host via the wrmrsl() :

static int __init setup_kvm_sev_migration(void)
{       
        efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
        efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
        efi_status_t status;
        unsigned long size;
        bool enabled;
        
        /*
         * check_kvm_sev_migration() invoked via kvm_init_platform() before
         * this callback would have setup the indicator that live migration
         * feature is supported/enabled.
         */
        if (!sev_live_migration_enabled)
                return 0;
        
        if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
                pr_info("%s : EFI runtime services are not enabled\n", __func__);
                return 0;
        }

        size = sizeof(enabled);

        /* Get variable contents into buffer */
        status = efi.get_variable(efi_sev_live_migration_enabled,
                                  &efi_variable_guid, NULL, &size, &enabled);
                                  
        if (status == EFI_NOT_FOUND) {
                pr_info("%s : EFI live migration variable not found\n", __func__);
                return 0;
        }
        
        if (status != EFI_SUCCESS) {
                pr_info("%s : EFI variable retrieval failed\n", __func__);
                return 0;
        }
        
        if (enabled == 0) {
                pr_info("%s: live migration disabled in EFI\n", __func__);
                return 0;
	}

	pr_info("%s : live migration enabled in EFI\n", __func__);
        wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION, KVM_SEV_LIVE_MIGRATION_ENABLED);

        return true;

This ensures that host/guest live migration negotation is completed only
when both host and guest have support for it and also UEFI/OVMF supports
it. 

Please note, that live migration cannot be initiated before this
negotation is complete, which makes sense, as we don't want to enable it
till the host/guest negotation is complete and UEFI/OVMF support for it
is checked.

So there is this window, till guest is booting and till the late
initcall is invoked that live migration cannot be initiated, and 
KVM_GET_SHARED_PAGES ioctl will return -EINVAL till then.
               
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

No, the guest will not invoke hypercall until live migration support
has been enabled on the guest as i described above. The hypercall 
invocation code does this check as shown below: 

static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
                                        bool enc)
{
        unsigned long sz = npages << PAGE_SHIFT;
        unsigned long vaddr_end, vaddr_next;

        if (!sev_live_migration_enabled)
                return;
...
...

Thanks,
Ashish

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

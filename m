Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C5355509
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 15:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhDFN1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 09:27:15 -0400
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:5568
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231861AbhDFN1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 09:27:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrWpbhHvPcMn5MNsIZx9ISzc3hZweXR8oQN7Ul4LKtPZusMGVaBljwSsp1YRwEGRF1QD0od99g3LONMusqVRC+asCOpIl6ME01v63mlPP7grExZypsmQ3IByClaSPSd2CgOpwJ9z/d63Icf7C5HXzOFDwsJyr3elU3QuWt10fyd9VqIv+kGPB3INqM4c/KG9gUjIdXRZDCHaDN2OzV46zkehd5dYKZoYbq4sHU5uMfs19GmPd9OhPP+j5CTMf386kwKH8aV0F00Q//q0u8AjvR/vH8LVocvd5bckgCgXHM0pUx+lraWQrNHQdFars2TavOkw88uMGnoOfX5J1FuHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4s7kIV3hJg7eXJkTixQCtrSVXkTwGRLs2dozcRGTZ8=;
 b=KM7s2RrVBmR7gY/jRrfhPahR9GzajGtr5p574/XPyGSjPA/49NDfmLGIkqjTrEG2mGLrkX4EAZf2+NArkWYv2UQeMrWgayuavrHCFPCjb/tOtvHqFFXDkTk8L2N+7onQR/l2B2nbiQfix4yAUjSMH4E1lvwdc8tDwZ2EmxYYWqB2OtcSE3S4/TZo9zeT6redwL019QnGTLWzJ/Sc719wKCVs5F3ySplySyXNjIk5kYJgnaHRlg/lnkMZdTYASs8fqi9WuDJH9soO42yN2yWYXyhpLG6jPzoHo0r9u9yzT+Oh0FzygHR77FtTCHbrcYeb16lpE1OUmLNlXsrBGkqeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4s7kIV3hJg7eXJkTixQCtrSVXkTwGRLs2dozcRGTZ8=;
 b=GF8/SkDwkkY0lcnBw+MA7kmHpxNv2GmjU/bHvIfHoaulQMfpZsFz78ub+X4TT4VBNIFhoNXG3smjK8wdX94gB9WnunIGl9rbLFaoCw8k5pRY/Rn0L01Paxp0SLh209iXu4AFs0PDEAZUwzvjGk/7KXdFILTveI5VpAFCVKcO9qw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 6 Apr
 2021 13:27:04 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 13:27:04 +0000
Date:   Tue, 6 Apr 2021 13:26:58 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v11 10/13] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20210406132658.GA23267@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <69dd6d5c4f467e6c8a0f4f1065f7f2a3d25f37f8.1617302792.git.ashish.kalra@amd.com>
 <CABayD+f3RhXUTnsGRYEnkiJ7Ncr0whqowqujvU+VJiSJx0xrtg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+f3RhXUTnsGRYEnkiJ7Ncr0whqowqujvU+VJiSJx0xrtg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 13:27:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 060848f2-620b-470c-5904-08d8f8ffaaf5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24146F26176EFDDB0318E94C8E769@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UN5eBsZxUSgPMOggpkXzbTOpjzYhAkUJCRU1He9FUtJ9Vp/nv/EmCnWiJ1dQ0ukHpBgo2OUMU38GnCUyYIjxjMg1ZShgb7IdnpYbQn/j0S2fE+pdwe80ivut8AyqM7ZGyYH8JLGkKQi6UcaG7PMt/A7RmneeV5sUw4g6LwHCOb7hTcOk4fFB5mjAYoXDwoezfrj7GeYrpqPJzMXG7E1e0HJxeHhEGba6Vtsdt+siTaiJgcUJKVZMKqC74HvHT4iTCdB6DWITt9Z4msmgWAUc8tvd6oHYhPPcv/lPvjuT7ESa7mCAr76TChZD43UtaGYe3aLOors7VwJQGGohKaHuH+sXEhQJXKYOrkqDgI4ze4G1FYLEjwc/mz16oCJSIlCSV/OJxzHyMTJeH0QlMNm2SgfDeX49ENFtQ4iY0/bfe9U5OiIN4OOcQmVVRPuOGuN5uCZizqHhhTgzAESyC5BAYtdyqW8BZAPCC6DnDTTJJoerDrb1veZhVHT06YkhKWbjYLGiOSRHiimQESUVDOGlEfbGcNI93xBXXdMlMEawXLIdBHK2pkXEyW4KUDryC6/+QwqZAggK5BUUtGVotkYghu2cVyASN7W+W32tgAJnsMDJ9zl3zmnCZDQto+ao+mR405Q9ACV/HiP7rQSWeehq9YoPMexRPNXnmRb464+g+yXhCtuUZ1HPsdAwap08ZtC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(8936002)(5660300002)(55016002)(9686003)(8676002)(86362001)(16526019)(1076003)(52116002)(53546011)(66556008)(66476007)(66946007)(54906003)(4326008)(7416002)(38350700001)(33716001)(26005)(186003)(2906002)(316002)(83380400001)(956004)(38100700001)(6666004)(6496006)(44832011)(6916009)(33656002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?saak+xMKh6MU5bzNy6Iwca093TNpbXf0jgc3xTLBdlg6UBQHN0uYlbj/6Pnv?=
 =?us-ascii?Q?VEiqP498BFVS5AlhxHp+zbmz4sRm6RqlmEaXCyrQPJSYFjjAi4iAMu7NS5/B?=
 =?us-ascii?Q?9spLSpJHTBjaDijJU/bQh2rf2kWzUaRVkkVQXVjiZS7/JUK1Tq0ckrEychqB?=
 =?us-ascii?Q?9jeh+yg2Tlb1paRWkbgRV3oAxnpXL91OoT41jeRZ7LUZ6vml8ge8/MoQ2c3g?=
 =?us-ascii?Q?SY5mlKXt6/WBt8MDsrsuIDKfFS2e9P9EhK+S7ptuqO0//kNmaK4u5tLwVvit?=
 =?us-ascii?Q?+xDG2rTUku942JnTATHDiqUAUljpVWXByWJGAZLXIUn1NBjV2TrXEmm6uee2?=
 =?us-ascii?Q?kPSTzrj+3EDmLGD55iSVJLgulsWfgTKTeB8oBgaoeGTtyVaGfeXKjKF5vh9X?=
 =?us-ascii?Q?5x9IvDMqW0edpP6xyPeeL0/kn1hNFt2pV6shw6lbGYijGWmf3l8/VcfQCeQG?=
 =?us-ascii?Q?6NdVV8dIsMZRJC9inMwqXX/H9oCCvlziLxj5p6npWRWXsPkyzrOEFH5lsvWb?=
 =?us-ascii?Q?QztiGgLsqKcK7ycRgS5zmlfh1hiLg6rM0VQexdg8W9jPbiiyofyVGt/p92s2?=
 =?us-ascii?Q?TlvlV0A3pNAEU6q1Kgztk6fXmRHOGN5paYL+nhHt/AidLz7oGQ1K88OapK+q?=
 =?us-ascii?Q?z5q9tRO+g9HJiA45VBf5wdo+NOpj88zEDiftSPzQojhNb/5vholnZ9sM8yoM?=
 =?us-ascii?Q?uUCeBWqN3Q4Mh066IyfNoQ4XQxWT64B6GJnKuNVs2VOSr5zn+/b6NetS5iAX?=
 =?us-ascii?Q?1KJEt/9TPxIG+oDYpokM7YdyzWsLVpXYGCt8PtUsEriTxkk4L8qHnOmGiKGs?=
 =?us-ascii?Q?VsuLNFk8Q8DMxmkLGLCc/AnyaqQKbIhL3LUYIXeChKTVJf45GMzWJ+BId2+S?=
 =?us-ascii?Q?z0jZu8ZOvgDVS2Ce/4/NdMP0hyrz1vbajHHYBgQAaJHrrcgjM4SiCeIVn27Y?=
 =?us-ascii?Q?cXE0bJwHaikGTFtfRBQ89xj2+jL/c4YpldlgrPw76M9zE53sg3ERDlmNFXae?=
 =?us-ascii?Q?+G1grCDluk1qWUfV2zZniCXM1t2iNtTkhNzzWAe1DYeRlP8OIOkmOrGAxVSO?=
 =?us-ascii?Q?oyPbg1826D452Bu9Dg9KzsmMHMVNZjM4kwdSsKraXs0TrPpHnAEt+3PcaNeD?=
 =?us-ascii?Q?2YaQlntksUJp7vL5pLs9oFWVM8irGhXZX4US//un0VC2dVG25ipQO4AJKhhA?=
 =?us-ascii?Q?q3hk58yibJ8871sYI8ArCchRCBGcbee9ONxF69yEq+eb4/eeYvonQ4YwCsZW?=
 =?us-ascii?Q?lsE5GZh/FOVSvVl95dP0gM55C53oRu54Z/hFUwxF89fbx/UINdSFfOKtZRCw?=
 =?us-ascii?Q?6fHjklSAH+j70MNSTZ63b5GV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060848f2-620b-470c-5904-08d8f8ffaaf5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 13:27:04.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9X3uaBaiTT3yVlqsdYCmhOxFY9Am4ZHakhRDukRMZ3u/bqVrT8yZhW/FnSmPMl80umTszyNpPBKmbVPzBb1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Mon, Apr 05, 2021 at 06:39:03PM -0700, Steve Rutherford wrote:
> On Mon, Apr 5, 2021 at 7:30 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > for host-side support for SEV live migration. Also add a new custom
> > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > feature.
> >
> > MSR is handled by userspace using MSR filters.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> >  arch/x86/kvm/cpuid.c                 |  3 ++-
> >  arch/x86/kvm/svm/svm.c               | 22 ++++++++++++++++++++++
> >  5 files changed, 45 insertions(+), 1 deletion(-)
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
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 6bd2f8b830e4..4e2e69a692aa 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >                              (1 << KVM_FEATURE_PV_SEND_IPI) |
> >                              (1 << KVM_FEATURE_POLL_CONTROL) |
> >                              (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> > -                            (1 << KVM_FEATURE_ASYNC_PF_INT);
> > +                            (1 << KVM_FEATURE_ASYNC_PF_INT) |
> > +                            (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> >
> >                 if (sched_info_on())
> >                         entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 3cbf000beff1..1ac79e2f2a6c 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2800,6 +2800,17 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >         case MSR_F10H_DECFG:
> >                 msr_info->data = svm->msr_decfg;
> >                 break;
> > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > +               if (!sev_guest(vcpu->kvm))
> > +                       return 1;
> > +
> > +               if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
> > +                       return 1;
> > +
> > +               /*
> > +                * Let userspace handle the MSR using MSR filters.
> > +                */
> > +               return KVM_MSR_RET_FILTERED;
> >         default:
> >                 return kvm_get_msr_common(vcpu, msr_info);
> >         }
> > @@ -2996,6 +3007,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >                 svm->msr_decfg = data;
> >                 break;
> >         }
> > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > +               if (!sev_guest(vcpu->kvm))
> > +                       return 1;
> > +
> > +               if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
> > +                       return 1;
> > +
> > +               /*
> > +                * Let userspace handle the MSR using MSR filters.
> > +                */
> > +               return KVM_MSR_RET_FILTERED;
> 
> It's a little unintuitive to see KVM_MSR_RET_FILTERED here, since
> userspace can make this happen on its own without having an entry in
> this switch statement (by setting it in the msr filter bitmaps). When
> using MSR filters, I would only expect to get MSR filter exits for
> MSRs I specifically asked for.
> 
> Not a huge deal, just a little unintuitive. I'm not sure other options
> are much better (you could put KVM_MSR_RET_INVALID, or you could just
> not have these entries in svm_{get,set}_msr).
> 

Actually KVM_MSR_RET_FILTERED seems more logical to use, especially in
comparison with KVM_MSR_RET_INVALID. 

Also, hooking this msr in svm_{get,set}_msr allows some in-kernel error
pre-processsing before doing the pass-through to userspace.

Thanks,
Ashish

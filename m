Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617E831717D
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 21:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhBJUiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 15:38:14 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:38176
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232164AbhBJUiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 15:38:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOdbO3M9Xu16mzeFTwEe2fw3rdfANb6uC9a7jcxNH7JupkqxO1s3DjBp7BOEG/TgV/5ozlyP+vjIUO0PyNjmL9CZsqO9d0piT4SWvAef7rdWuDNRmLJD/p3jhG2P7BhTlPKLBlcM7nZTWBjE3QQBe/anaxP/u7QxrsCCfW0XQDNe7+BOJf14hWRsaBm29SYrKrPfx2LMAmg0EtwOwGxAfp9iOxJQUK7AX8qkn6FzupfbCpdJi4NaujkTwxPzplmiQqIj6/kB9rpXAFAEysIiNRlj/CYOR8VEwJsZmBA2Sl9t59qvx+hyyjRNptGL/RvpRWIuSec5EEQPfR8XXz3rNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlsM6H2fb5dByuBfW5SqJADFPP61XZS2jSMbmMezXj4=;
 b=JsaQLnZy3GMx/KRTUBAWCpE3aqobHFLD+0KbN+I/JZOLZI9Hx7Gzg8F+bZsyqElor3RO9fIryuP34YnrCHTLtnT9g+PmPlCnEn1QXT7ta6+yR5uB8Ax0pNmqOJqT41irA3Hn3zjz4dN+1V7NdPRMCK+SnaLZWdC/EH1gx6Mf5Tjfl4ayMb9WVRwYFV3cIiTr9tRP4Z5enYdiaABG06p77A6akQEBj8O6X0yLwEDUeqb5kV4majcw4pL9tAtgbj8VUlu+/P+2Q3L36YrHVAELAlBGzVruU0G23derQ8E1yK4kUK7DDVg6TpABTkRMGy9AZbpw91aSSYiMioI4uoFZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlsM6H2fb5dByuBfW5SqJADFPP61XZS2jSMbmMezXj4=;
 b=1NhU7oE2YVz9OqFmdvuuz6gFRUL/Wc7Co8k+3Q1YCHf5tblMPUJnegSBUymoN3bzlADzUsjQqj9enM0dEzO4apVJdMevLlIEYGcW7ei2QnHSlS2htnudyjSkjRhGEBgA0usJMnMsgxRFWJR5AJwyZX0jpJ4IwwxVDtl59UdTe7U=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 20:37:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 20:37:09 +0000
Date:   Wed, 10 Feb 2021 20:36:06 +0000
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
Message-ID: <20210210203606.GA30775@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server>
 <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
 <20210206054617.GA19422@ashkalra_ubuntu_server>
 <20210206135646.GA21650@ashkalra_ubuntu_server>
 <20210208002858.GA23612@ashkalra_ubuntu_server>
 <CABayD+dB3fJ-YmZZ2qsP7ud-E+R8McjVmVXB4ER4Dmk18cAvoA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+dB3fJ-YmZZ2qsP7ud-E+R8McjVmVXB4ER4Dmk18cAvoA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0140.namprd05.prod.outlook.com
 (2603:10b6:803:2c::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0140.namprd05.prod.outlook.com (2603:10b6:803:2c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Wed, 10 Feb 2021 20:37:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 373af146-b0ac-4be3-eaf4-08d8ce03a2bf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB251121A837C51C614BDCB9E08E8D9@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvQVL0Ihfxu+IA8UKFfhaaxLPYhRsDy47uBBgCWXC9K9gY77lMnr40wt5t82dWhd8PN+pRTgoyRjSGPScPNlEubhuiCGyN3wRaU/OpewMQUJn40esDUWE0W5lyYtwR4n+TtVGm48fmaYLZTpzjy/81FqR+iJtHjazua0FEKqZ5j6iYahtC8fL66KPcGYNoUtqb+utwVO2twot2XQ9orCTgzgR4GDK/qcx7gKAel3RvEomw0RRogSttLRj4htPgMZnNtR0cX04eMaoAOwMYpUk+V/0xdtH8Jc1CpHWgOijUjrhPlUbF4YpjWrRz3vlR1iCUCoJmBjeVd8y4UqsKRABudUWwRzId00wPbJ0ej+LcN1lcbwFe5XUalNvaXVLYU/5eRhblmL+oOjQA6JXFDMZdUreMPxw2IvI97g91YW4kcRo0W7anNDiXXb4dAk3RGfNUSDJvY5zKwEcok0fzFwXsxxKP5olFhHI3RtDnojFYsGMbt9ZHl7Lnw3emy8XioBD69aXy+9XyJnzGDfgymcLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(366004)(346002)(376002)(66946007)(33716001)(4326008)(52116002)(316002)(66476007)(66556008)(53546011)(6496006)(5660300002)(83380400001)(33656002)(44832011)(2906002)(8676002)(54906003)(6916009)(8936002)(30864003)(9686003)(478600001)(86362001)(55016002)(7416002)(26005)(186003)(1076003)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Se7BlQtpIGOeB2BWp3UQroHG0KWC8qWaByFIYkX3bb0k3L2Ejy7xkQziwu49?=
 =?us-ascii?Q?wU4D/jvGyNTwrhzmJxoAI5oJAwD/im9Tlx4TClgFdv8e/Szn0wIn6H6oIKxI?=
 =?us-ascii?Q?56K26iIn5c2YEaFXg3rqgSFJ/B7NQaGoMZkoGVC3EEe+Yf2OsJkNmKsuvaFP?=
 =?us-ascii?Q?ixjOurGQUTm11mtt4PTPZJvjfSKTL9Vo6lVAfXYgrM9HZFecMvCrsRsAmXxl?=
 =?us-ascii?Q?P5cCqfYxwryVQD7ws16x/B7El6ZEUnh6gLjEULCYSfFpA9yFfKO56JS7uCb9?=
 =?us-ascii?Q?TjTOcJHe75KtDnPuQ0mVyb+vrsUvs7Nk+h1KYdlVFB10/3ZMoUcp8hmzv3LG?=
 =?us-ascii?Q?pz/waUSQwzCcPUpXeL6B2RpUzK+y2izldVU6y5R8G+gwCiYNa/p7FpM6CzK9?=
 =?us-ascii?Q?EKFQEy3oZkefxRRzj4iWt6TSsmPcCt8EFKHAkFQQyizTgT0dW95qT8L/d186?=
 =?us-ascii?Q?lRLuJca+fgrjQCdVSWIp4PSmLK5ZlyCpJMpfru1B69ma/hwPwq13NsR1R3GV?=
 =?us-ascii?Q?1ELwDaWDffKOmbfkIQ433F21nOupgT2RO6uAo8tBLyKVcepE4kzjLdSnjSVt?=
 =?us-ascii?Q?ZGazpFKhzOHOGR/fR+uSJ6wwuYgMSoE4lXhiN22PLPH2tJ73sdVI5HZ0HIOO?=
 =?us-ascii?Q?ZgbMkY9O4kt5cJlDt+MZz1U3c7EpS35FjE6U+2t9XmB0l40eCO0OXtpp1LIq?=
 =?us-ascii?Q?zAaLaSAjH95BodSgjl2RSI0/VGjlYfauCf+q0u9gt1FeUAiWkXfPFw+pttQ2?=
 =?us-ascii?Q?v/z3s2JiVA4Vr+LzqhCGCFztprSnp5BummDuBs95xJZANwwsm++eDgilxcfS?=
 =?us-ascii?Q?OupBD/hzW+jF0I3GSGiLwcIzyTI+o4yl3DwToiLvaL4ZF6UtgXSBulKlloQ5?=
 =?us-ascii?Q?BDYswQ8NE03AHFIdn3RmocyHFICxjPxPN/uasxfUgORP+GMV6LH8zzJGxv/c?=
 =?us-ascii?Q?Ql4SipP68F2nL9Ngzrd2OddhKCSmyfM7GOEoSaMnJHaR9aEwFUzTLPVjg5/A?=
 =?us-ascii?Q?KwbuP0/RbQ4nhUdcIoAcc2+fyYzlo7EzRmv5i95ESNaRTHC3L8ZNbZSBxgKW?=
 =?us-ascii?Q?KzEHuGcGT+DukoD94rgyR4hJdmX+flLbdqbvETLsTf0hXP80N58uXb6+cSE/?=
 =?us-ascii?Q?8pmwN4duVd6Z7SNZ6Fi1nYv0dqSbcs+XNv+1G9UKmYqNEtohRrlzkb9b1WWs?=
 =?us-ascii?Q?L9d+yaBqLR9pwym1vkj4BKAgPYNd+ept7UASXWS3DF9KUUfSr4eSpCz6KeHx?=
 =?us-ascii?Q?zDxT1T4V8Co3+ZPEdgS3u+TM0Mn4W0Wb5m6ahqg6r6SMiovjTLi+XkS+Ifk4?=
 =?us-ascii?Q?PDTkgos/iG9l6KAbssifkgvi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373af146-b0ac-4be3-eaf4-08d8ce03a2bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 20:37:09.0381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyJCr836eLSGlX2X48HH+ZTw1w+vRTMl/LW9t7hY1DmYOpmlFNqW9159GdH5ycayku4ZNNgxKTnqjKIoGWPeNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Mon, Feb 08, 2021 at 02:50:14PM -0800, Steve Rutherford wrote:
> Hi Ashish,
> 
> On Sun, Feb 7, 2021 at 4:29 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > On Sat, Feb 06, 2021 at 01:56:46PM +0000, Ashish Kalra wrote:
> > > Hello Steve,
> > >
> > > On Sat, Feb 06, 2021 at 05:46:17AM +0000, Ashish Kalra wrote:
> > > > Hello Steve,
> > > >
> > > > Continued response to your queries, especially related to userspace
> > > > control of SEV live migration feature :
> > > >
> > > > On Fri, Feb 05, 2021 at 06:54:21PM -0800, Steve Rutherford wrote:
> > > > > On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > >
> > > > > > Hello Steve,
> > > > > >
> > > > > > On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > > > > > > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > > > > >
> > > > > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > > >
> > > > > > > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > > > > > > for host-side support for SEV live migration. Also add a new custom
> > > > > > > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > > > > > > feature.
> > > > > > > >
> > > > > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > > > ---
> > > > > > > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > > > > > > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > > > > > > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > > > > > > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > > > > > > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > > > > > > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > > > > > > >  6 files changed, 52 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > > > > > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > > > > > > --- a/Documentation/virt/kvm/cpuid.rst
> > > > > > > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > > > > > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > > > > > > >                                                 before using extended destination
> > > > > > > >                                                 ID bits in MSI address bits 11-5.
> > > > > > > >
> > > > > > > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > > > > > > +                                               using the page encryption state
> > > > > > > > +                                               hypercall to notify the page state
> > > > > > > > +                                               change
> > > > > > > > +
> > > > > > > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > > > > > > >                                                 per-cpu warps are expected in
> > > > > > > >                                                 kvmclock
> > > > > > > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > > > > > > index e37a14c323d2..020245d16087 100644
> > > > > > > > --- a/Documentation/virt/kvm/msr.rst
> > > > > > > > +++ b/Documentation/virt/kvm/msr.rst
> > > > > > > > @@ -376,3 +376,15 @@ data:
> > > > > > > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > > > > > > >         and check if there are more notifications pending. The MSR is available
> > > > > > > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > > > > > > +
> > > > > > > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > > > +        0x4b564d08
> > > > > > > > +
> > > > > > > > +       Control SEV Live Migration features.
> > > > > > > > +
> > > > > > > > +data:
> > > > > > > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > > > > > > +        in other words, this is guest->host communication that it's properly
> > > > > > > > +        handling the shared pages list.
> > > > > > > > +
> > > > > > > > +        All other bits are reserved.
> > > > > > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > > index 950afebfba88..f6bfa138874f 100644
> > > > > > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > > @@ -33,6 +33,7 @@
> > > > > > > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > > > > > > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > > > > > > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > > > > > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > > > > > > >
> > > > > > > >  #define KVM_HINTS_REALTIME      0
> > > > > > > >
> > > > > > > > @@ -54,6 +55,7 @@
> > > > > > > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > > > > > > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > > > > > > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > > > > > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > > > > > > >
> > > > > > > >  struct kvm_steal_time {
> > > > > > > >         __u64 steal;
> > > > > > > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > > > > > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > > > > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > > > > > >
> > > > > > > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > > > > > > +
> > > > > > > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > > index b0d324aed515..93f42b3d3e33 100644
> > > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > > > > > > >         return ret;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > > > > > > +{
> > > > > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > > > > +
> > > > > > > > +       if (!sev_guest(kvm))
> > > > > > > > +               return;
> > > > > > >
> > > > > > > This should assert that userspace wanted the guest to be able to make
> > > > > > > these calls (see more below).
> > > > > > >
> > > > > > > >
> > > > > > > > +
> > > > > > > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > > > >                               struct kvm_shared_pages_list *list)
> > > > > > > >  {
> > > > > > > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > > > >         if (!sev_guest(kvm))
> > > > > > > >                 return -ENOTTY;
> > > > > > > >
> > > > > > > > +       if (!sev->live_migration_enabled)
> > > > > > > > +               return -EINVAL;
> > > > >
> > > > > This is currently under guest control, so I'm not certain this is
> > > > > helpful. If I called this with otherwise valid parameters, and got
> > > > > back -EINVAL, I would probably think the bug is on my end. But it
> > > > > could be on the guest's end! I would probably drop this, but you could
> > > > > have KVM return an empty list of regions when this happens.
> > > > >
> > > > > Alternatively, as explained below, this could call guest_pv_has instead.
> > > > >
> > > > > >
> > > > > > > > +
> > > > > > > >         if (!list->size)
> > > > > > > >                 return -EINVAL;
> > > > > > > >
> > > > > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > > > > index 58f89f83caab..43ea5061926f 100644
> > > > > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > > > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > > > > >                 svm->msr_decfg = data;
> > > > > > > >                 break;
> > > > > > > >         }
> > > > > > > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > > > > > > +               break;
> > > > > > > >         case MSR_IA32_APICBASE:
> > > > > > > >                 if (kvm_vcpu_apicv_active(vcpu))
> > > > > > > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > > > > > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > > > > > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > > > > > > >         }
> > > > > > > >
> > > > > > > > +       /*
> > > > > > > > +        * If SEV guest then enable the Live migration feature.
> > > > > > > > +        */
> > > > > > > > +       if (sev_guest(vcpu->kvm)) {
> > > > > > > > +               struct kvm_cpuid_entry2 *best;
> > > > > > > > +
> > > > > > > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > > > > > > +               if (!best)
> > > > > > > > +                       return;
> > > > > > > > +
> > > > > > > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > > > > > > +       }
> > > > > > > > +
> > > > > > >
> > > > > > > Looking at this, I believe the only way for this bit to get enabled is
> > > > > > > if userspace toggles it. There needs to be a way for userspace to
> > > > > > > identify if the kernel underneath them does, in fact, support SEV LM.
> > > > > > > I'm at risk for having misread these patches (it's a long series), but
> > > > > > > I don't see anything that communicates upwards.
> > > > > > >
> > > > > > > This could go upward with the other paravirt features flags in
> > > > > > > cpuid.c. It could also be an explicit KVM Capability (checked through
> > > > > > > check_extension).
> > > > > > >
> > > > > > > Userspace should then have a chance to decide whether or not this
> > > > > > > should be enabled. And when it's not enabled, the host should return a
> > > > > > > GP in response to the hypercall. This could be configured either
> > > > > > > through userspace stripping out the LM feature bit, or by calling a VM
> > > > > > > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> > > > > > >
> > > > > > > I believe the typical path for a feature like this to be configured
> > > > > > > would be to use ENABLE_CAP.
> > > > > >
> > > > > > I believe we have discussed and reviewed this earlier too.
> > > > > >
> > > > > > To summarize this feature, the host indicates if it supports the Live
> > > > > > Migration feature and the feature and the hypercall are only enabled on
> > > > > > the host when the guest checks for this support and does a wrmsrl() to
> > > > > > enable the feature. Also the guest will not make the hypercall if the
> > > > > > host does not indicate support for it.
> > > > >
> > > > > I've gone through and read this patch a bit more closely, and the
> > > > > surrounding code. Previously, I clearly misread this and the
> > > > > surrounding space.
> > > > >
> > > > > What happens if the guest just writes to the MSR anyway? Even if it
> > > > > didn't receive a cue to do so? I believe the hypercall would still get
> > > > > invoked here, since the hypercall does not check if SEV live migration
> > > > > is enabled. Similarly, the MSR for enabling it is always available,
> > > > > even if userspace didn't ask for the cpuid bit to be set. This should
> > > > > not happen. Userspace should be in control of a new hypercall rolling
> > > > > out.
> > > > >
> > > > > I believe my interpretation last time was that the cpuid bit was
> > > > > getting surfaced from the host kernel to host userspace, but I don't
> > > > > actually see that in this patch series. Another way to ask this
> > > > > question would be "How does userspace know the kernel they are on has
> > > > > this patch series?". It needs some way of checking whether or not the
> > > > > kernel underneath it supports SEV live migration. Technically, I think
> > > > > userspace could call get_cpuid, set_cpuid (with the same values), and
> > > > > then get_cpuid again, and it would be able to infer by checking the
> > > > > SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
> > > > > support should be easy.
> > > > >
> > > > > An additional question is "how does userspace choose whether live
> > > > > migration is advertised to the guest"? I believe userspace's desire
> > > > > for a particular value of the paravirt feature flag in CPUID get's
> > > > > overridden when they call set cpuid, since the feature flag is set in
> > > > > svm_vcpu_after_set_cpuid regardless of what userspace asks for.
> > > > > Userspace should have a choice in the matter.
> > > > >
> > >
> > > Actually i did some more analysis of this, and i believe you are right
> > > about the above, feature flag gets set in svm_vcpu_after_set_cpuid.
> > >
> >
> > As you mentioned above and as i confirmed in my previous email,
> > calling KVM_SET_CPUID2 vcpu ioctl will always set the live migration
> > feature flag for the vCPU.
> >
> > This is what will be queried by the guest to enable the kernel's
> > live migration feature and to start making hypercalls.
> >
> > Now, i want to understand why do you want the userspace to have a
> > choice in this matter ?
> Kernel rollout risk is a pretty big factor:
> 1) Feature flagging is a pretty common risk mitigation for new features.
> 2) Without userspace being able to intervene, the kernel rollout
> becomes a feature rollout.
> 
> IIUC, as soon as new VMs started running on this host kernel, they
> would immediately start calling the hypercall if they had the guest
> patches, even if they did not do so on older versions of the host
> kernel.
> 
> >
> > After all, it is the userspace which actually initiates the live
> > migration process, so doesn't it have the final choice in this
> > matter ?
> With the current implementation, userspace has the final say in the
> migration, but not the final say in whether or not that particular
> hypercall is used by the guest. If a customer showed up, and said
> "don't have my guest migrate", there is no way for the host to tell
> the guest "hey, we're not even listening to what you're sending over
> the hypercall". IIRC, there is an SEV Policy bit for migration
> enablement, but even if it were set to false, that guest would still
> update the host about its unencrypted regions.
> 
> Right now, the host can't even remove the feature bit from CPUID
> (since its desire would be overridden post-set), so it doesn't have
> the ability to tell the guest to hang up the phone. And even if we
> could tell the guest through CPUID, if the guest ignored what we told
> it, it could still send data down anyway! If there were a bug in this
> implementation that we missed, the only way to avoid it would be to
> roll out a new kernel, which is pretty heavy handed. If you could just
> disable the feature (or never enable it in the first place), that
> would be much less costly.
>

We can remove the implicit enabling of this live migration feature
from svm_vcpu_after_set_cpuid() callback invoked afer KVM_SET_CPUID2
ioctl, and let this feature flag be controlled by the userspace 
VMM/qemu. 

Userspace can set this feature flag explicitly by calling the 
KVM_SET_CPUID2 ioctl and enable this feature whenever it is ready to
do so.

I have tested this as part of Qemu code : 

int kvm_arch_init_vcpu(CPUState *cs)
{
...
...
        c->function = KVM_CPUID_FEATURES | kvm_base;
        c->eax = env->features[FEAT_KVM];
        c->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
...
...
	
    r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);
...

Let me know if this addresses your concerns.

Thanks,
Ashish

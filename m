Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260141E8E08
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 07:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgE3FtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 01:49:21 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:59872
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725814AbgE3FtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 01:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yuukc6VxNppMoQ1HM3KVvHxDlS/aGTNOTfNbohQSFcXxZXmUa8lBRm9hv0gcEFJzHt5VNr06I3odIZRT+ruo/lgukIt5kg93UyB/3MkzwuS6aCErWxp9sborPjOsMceCKjZgAhRICaC5/3ZhcyTyVAJSF3Wfqpo1itPOD81G9yiwwqlK31wWZowVT1z9Q4w/AJRmoEtGZb7waOnCDq1GFwA4fGvH7cQ6hpnT4CYQGXmOuemlE3HjBP8bC1S5HtrcE8GZwJgizdWehnj0E8j/8T+TEwK78ZLBLadN9xq6l/65SwYOWWAEJwiGNllxTHrR5RfUkCM0W48IgXpN+TaZOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1I5Uw9pbF5QJAbpd6mdsNyB5hjb9CACu7x8GCHRtRak=;
 b=DEnr7IHTKcRbrZMFModAbN0nidvtF7dmN9L8LtF05Hqgy+KjbBJjHCknQMvaX0Dvmh0jj2phclnz4o3yNCs8PgDpdfkV2fYk8MREI0RPLRSShuBqLmUfZj7+hMb8dIFXSl0KnVOkIWLFyvAheFDtp1v9Ai3MZFJHA8jZLqtDM4TmRurCchC+653xKfjmF+8Nf9AXwMWhEzcxSTCmFmiNRbk2hXFrPrAxfJULlfQ7g5BcY8S4c5ec4zkwmcbR/w6yCQ0RSuXCMhJJ+4KLAGGrek6PI5BQ9Xcx6kQI4b+1iJdCYyAXqyNhsRDGSg40Ic5KusgEHHPJ7LwzPn5/pRQL/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1I5Uw9pbF5QJAbpd6mdsNyB5hjb9CACu7x8GCHRtRak=;
 b=EnqQU45GX0Qczc8i1uU0WOeO/WgH8QQBgB6N9BAP1pZf8D+SxT2DaxNzq7IfeokMkvY46+2b6SysCPCkbSjXF6OtWzYtD8wwJeO+IaLzogyzjE++xOj55Ux2DIL+Y33gx/QAN9DKZu/NIYXrrS6JRgz3XcfkcxHYgmHLBpUWSIM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1275.namprd12.prod.outlook.com (2603:10b6:3:75::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Sat, 30 May 2020 05:49:16 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 05:49:16 +0000
Date:   Sat, 30 May 2020 05:49:11 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of
 unified Page Encryption Bitmap.
Message-ID: <20200530054911.GA29246@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
 <CABayD+f0XbhgKKe45Dwk5=-4d68iEn8HZsLCKrPaygxkkUWUCw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+f0XbhgKKe45Dwk5=-4d68iEn8HZsLCKrPaygxkkUWUCw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:5:134::38) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR13CA0061.namprd13.prod.outlook.com (2603:10b6:5:134::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 05:49:15 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98a5e173-26cc-4a2b-f9e1-08d8045d3066
X-MS-TrafficTypeDiagnostic: DM5PR12MB1275:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12759363CD7129E8EF3A47558E8C0@DM5PR12MB1275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssWIiUCh50UprJDp8XpSWkhj2REKoi3C5lpJ8Pkf3Oiw5XGjbea6EMu6aaZ39YxePKDmES9Hp9grN8x7Q9wt2Y/VOla96Cf/6RT4Y0uiFvrYtNMGsenoiF6iN30bI7Ps5EbPeg1ust08ODY/D0HGDLbIfl7u8OHp/HqvKTAUNedf8505SnwTDkKlLO7ZeULkEp1h98W7h+MyJzqR9ysAYnQh+i3vFih0me7WBsk9wQNXtdXeB173tMZdqqog6lnAtESxx/o0+K/eKGwqtFsJycTwfw7a0PjzBEWJSW4h5YxFo2VjIiaTfsMyc6pTK3ep/BecLBNDEYdrqko1bZKoBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(55016002)(6916009)(316002)(5660300002)(52116002)(66946007)(54906003)(33716001)(16526019)(186003)(6496006)(9686003)(44832011)(6666004)(26005)(86362001)(1076003)(956004)(66556008)(83380400001)(2906002)(7416002)(8676002)(478600001)(66476007)(4326008)(53546011)(8936002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YImLEUjHKGEKggImjSTEPOvcvuRJRLLLPC3xXLYntCaV+qVInMi5LxBqkQRoMCzhcMiM1WnsvIOGvlRdYh2/0VIQ4lK+og7LFxnWamZ9agEDzS9KahksYtXxbpQ2PL7z3wFOWxjZxWTZj6X8fTze85rN5J2D4ZhaSBVFO3om53m0tZ2W+LAh3glGe7iyndbS62kM3It/1LWM49gzWaky0+lPy3dBDjCmAFN6ERVMMkengRUFBoIxepiyv0pqYh82J9MjuWhN7KCLLG0p+kjFjG8kNTXsHrVD5u9JtlHRgY8MRSgWGDlgzSo6xVa/a/9mHUEeTkCxom/y+S5gwFROIM8NRngngAxJwmPmrOUwEYe70Z1mz+XK6EAmXK+HjiC01T2aZ+Fxswf8gRNXvUUMtKoWEfSB5DGaEUbe07H+mh250f2/JshvFuSh2ybbLuw5ed6KRfeULyHEbL3T0Og2CRQWfqbzgHfpPev5/UPAGk4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a5e173-26cc-4a2b-f9e1-08d8045d3066
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 05:49:16.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MHvx2w4l1yg5rdBDJkCe7uzSra0X3ovfzcIQDai7cPaEj9ysLD7h1ioV9kI7tijclfZIeW27dVU6J1eNYekmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1275
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Fri, May 29, 2020 at 07:07:33PM -0700, Steve Rutherford wrote:
> On Tue, May 5, 2020 at 2:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Add support for static allocation of the unified Page encryption bitmap by
> > extending kvm_arch_commit_memory_region() callack to add svm specific x86_ops
> > which can read the userspace provided memory region/memslots and calculate
> > the amount of guest RAM managed by the KVM and grow the bitmap based
> > on that information, i.e. the highest guest PA that is mapped by a memslot.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm/sev.c          | 35 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c          |  1 +
> >  arch/x86/kvm/svm/svm.h          |  1 +
> >  arch/x86/kvm/x86.c              |  5 +++++
> >  5 files changed, 43 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index fc74144d5ab0..b573ea85b57e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1254,6 +1254,7 @@ struct kvm_x86_ops {
> >
> >         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> >         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > +       void (*commit_memory_region)(struct kvm *kvm, enum kvm_mr_change change);
> >         int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> >                                   unsigned long sz, unsigned long mode);
> >         int (*get_page_enc_bitmap)(struct kvm *kvm,
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 30efc1068707..c0d7043a0627 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1377,6 +1377,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> >         return 0;
> >  }
> >
> > +void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change)
> > +{
> > +       struct kvm_memslots *slots;
> > +       struct kvm_memory_slot *memslot;
> > +       gfn_t start, end = 0;
> > +
> > +       spin_lock(&kvm->mmu_lock);
> > +       if (change == KVM_MR_CREATE) {
> > +               slots = kvm_memslots(kvm);
> > +               kvm_for_each_memslot(memslot, slots) {
> > +                       start = memslot->base_gfn;
> > +                       end = memslot->base_gfn + memslot->npages;
> > +                       /*
> > +                        * KVM memslots is a sorted list, starting with
> > +                        * the highest mapped guest PA, so pick the topmost
> > +                        * valid guest PA.
> > +                        */
> > +                       if (memslot->npages)
> > +                               break;
> > +               }
> > +       }
> > +       spin_unlock(&kvm->mmu_lock);
> > +
> > +       if (end) {
> > +               /*
> > +                * NORE: This callback is invoked in vm ioctl
> > +                * set_user_memory_region, hence we can use a
> > +                * mutex here.
> > +                */
> > +               mutex_lock(&kvm->lock);
> > +               sev_resize_page_enc_bitmap(kvm, end);
> > +               mutex_unlock(&kvm->lock);
> > +       }
> > +}
> > +
> >  int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >                                   unsigned long npages, unsigned long enc)
> >  {
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 501e82f5593c..442adbbb0641 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4015,6 +4015,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >
> >         .check_nested_events = svm_check_nested_events,
> >
> > +       .commit_memory_region = svm_commit_memory_region,
> >         .page_enc_status_hc = svm_page_enc_status_hc,
> >         .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >         .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 2ebdcce50312..fd99e0a5417a 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -406,6 +406,7 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >                                   unsigned long npages, unsigned long enc);
> >  int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
> >  int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
> > +void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change);
> >
> >  /* avic.c */
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c4166d7a0493..8938de868d42 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10133,6 +10133,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >                 kvm_mmu_change_mmu_pages(kvm,
> >                                 kvm_mmu_calculate_default_mmu_pages(kvm));
> >
> > +       if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
> > +               if (kvm_x86_ops.commit_memory_region)
> > +                       kvm_x86_ops.commit_memory_region(kvm, change);
> Why not just call this every time (if it exists) and have the
> kvm_x86_op determine if it should do anything?
> 
> It seems like it's a nop anyway unless you are doing a create.
> 

Yes, this makes sense. 

I will call it unconditionally it it exits and let the callback
determine what to do eventually with it.

Thanks,
Ashish

> > +       }
> > +
> >         /*
> >          * Dirty logging tracks sptes in 4k granularity, meaning that large
> >          * sptes have to be split.  If live migration is successful, the guest
> > --
> > 2.17.1
> >

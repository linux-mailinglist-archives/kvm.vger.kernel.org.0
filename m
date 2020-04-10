Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8411A3DB9
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 03:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgDJBXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 21:23:53 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:8483
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbgDJBXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 21:23:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCNJr1/x/RHrJlAfquJd57sNGqLbst15kNTlfqEsUv48LS0QDeb6jKOHBISoPNUy4LVh5ABTxivyN1d/6kDDlQ1bhqAx4nQWtqUpdnLE8tgtdUZuciqiNdzZTEVClCz8Qwn73R1iGk6TJ5ZGwvNW109giOZU15BwVwK87xm6EwiWR3C6o1b5DkagjCAYjSikuqhYXR1fZiwR+bCmi/x6kxvt27Sj0ViwRuiBc8+A9mWPvn1PHaNSN06c1MTKBQhqAoxb7kn3uBwZTq3oRUw0vnXslD+75ZayFSIxhdiUweyfs4uF0fENOlHtnMrV2wY9wQP3tUHpRpQEbBqQTnPIrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxnAxCy0q9N/L77RqvW39ee4E5U03mInhjrSyHSjgDs=;
 b=j+V8Y+ZoODGd9XwN+yJPS2Bx7yw/6MjbcjWX58EVGjd8esm2jRtDW3bZqr7a7DqdAMrGawJM7ulBKOmek0XkqIVfXq0fJ7ZIZqGf801Mqd3+MCJtRMjBl72WomCYG+VX5eBB9Pq0zy04KlGEvO+PAUvZutSf27tLZJLAfagLzP5zSm8Pw+DTngs6l9XxoYAdtB471yG5DTx7hsvlZfcT2DaTb/dJGZuuHIlVJApLle2LrvtV8JQAqGWgA1r+zlMmez8+ix+2Diuezw1M2RlEojXNKTUhzMjUbuIJtTYGAs0OJOzI5sgeEzUSYpa+mK/U0AMrDW8SlmN1zLLcjzQEUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxnAxCy0q9N/L77RqvW39ee4E5U03mInhjrSyHSjgDs=;
 b=Exhwxq3Dz7hQf+Ky2NvQW+T1XZFG0LXFoAHVkZkKBvj6agTy9sWB7CajUDEYESlPfoM9XFe590ouz9U1f+Pfa0MaVUEsi4qhyKcZLDJiLv/yMumka6YrSanhMyvXY46LnEBv7QMNuiybHuq4J7n9884zNJBq2p8PwjkWmS9Hj+U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1947.namprd12.prod.outlook.com (2603:10b6:3:111::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Fri, 10 Apr 2020 01:23:50 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Fri, 10 Apr 2020
 01:23:50 +0000
Date:   Fri, 10 Apr 2020 01:23:44 +0000
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
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20200410012344.GA19168@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
 <CABayD+eOCpTGjvxwhtP85j98BKvCxtG8QDBYSC0E08GnaA12jw@mail.gmail.com>
 <20200408014852.GA27608@ashkalra_ubuntu_server>
 <CABayD+eaeLZ++Hh8RC=5gWehgJs+tN3Ad39Nx7bF4foEido7jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABayD+eaeLZ++Hh8RC=5gWehgJs+tN3Ad39Nx7bF4foEido7jw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::37) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR17CA0024.namprd17.prod.outlook.com (2603:10b6:5:1b3::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 01:23:49 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1eca525-1701-43c2-b342-08d7dcedd2e1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1947:|DM5PR12MB1947:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB19476DACA23CA5F6C1B9E64C8EDE0@DM5PR12MB1947.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(54906003)(81156014)(9686003)(6916009)(478600001)(316002)(5660300002)(52116002)(4326008)(2906002)(8676002)(53546011)(26005)(7416002)(33656002)(86362001)(44832011)(956004)(186003)(6496006)(8936002)(81166007)(16526019)(66476007)(55016002)(1076003)(6666004)(66556008)(66946007)(33716001)(66574012);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWO+SC+AEcb1o54U+NK11SmVLvB47v6uhTRsXlpQLmJZjFbtG+Pom/XfWBkp76Dej/V7kjZSq3GXBlVX03x2UB/VX7bnrrLrOe6XCONmeKryS47sRflQrtExYTmR2bz9qDXdBlZpJGFpepQTdyLDSXBlysQxhLbxXSwknR746RfxqfHpzYUb6Gqsh8BUAT4tFH1zuDe/G0BvNxddRfBGSNBIrCQaCvQosIrrgromlef8pf27drZTeN9dj6XjTAern3PIdhYIuej//CDTT2ZVVSKviFXaU3fNqD/kUgZHnaXfJ550WQzDabD0cYOgHOX5EzvvYqU6c8YF9XNljz5sj/1p/CSu+u6oWrPaXVfRJd34tY8frj2F4JDV57H1LnENXPNve4SSmeXqVolH+bbCmGuczFpUQMSYZ4Ytqeyboy2ZzfKpFTvRKtd4zwQUuPGz
X-MS-Exchange-AntiSpam-MessageData: io+l+ZnR3Rpgwl+z937eLSbmcm3XNSI3Rn0mDBxyfYqMm4yPALWNuYzOyQ3e9WIC9JfpLHDwbGpMtrt1hLGYbSW8Bjpa/w+GGs+zezaVq8pxe+fORHg2c1SunFgDxZI/uCyrLomKWllMz6c+jApQXA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1eca525-1701-43c2-b342-08d7dcedd2e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 01:23:50.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yuhdF3OQjQh8s4wqBiCMVxza6kGJ3VZLIlIM9YcKYW8luIc8M+WXqEP+HFaabElX5NVYBVTACiQpFyWE83Srow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1947
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Apr 09, 2020 at 05:06:21PM -0700, Steve Rutherford wrote:
> On Tue, Apr 7, 2020 at 6:49 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > On Tue, Apr 07, 2020 at 05:26:33PM -0700, Steve Rutherford wrote:
> > > On Sun, Mar 29, 2020 at 11:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > >
> > > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > >
> > > > The ioctl can be used to set page encryption bitmap for an
> > > > incoming guest.
> > > >
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Ingo Molnar <mingo@redhat.com>
> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > Cc: Borislav Petkov <bp@suse.de>
> > > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > > Cc: x86@kernel.org
> > > > Cc: kvm@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > ---
> > > >  Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
> > > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > > >  arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
> > > >  arch/x86/kvm/x86.c              | 12 ++++++++++
> > > >  include/uapi/linux/kvm.h        |  1 +
> > > >  5 files changed, 79 insertions(+)
> > > >
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > index 8ad800ebb54f..4d1004a154f6 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during the guest migration, if the page
> > > >  is private then userspace need to use SEV migration commands to transmit
> > > >  the page.
> > > >
> > > > +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> > > > +---------------------------------------
> > > > +
> > > > +:Capability: basic
> > > > +:Architectures: x86
> > > > +:Type: vm ioctl
> > > > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > > > +:Returns: 0 on success, -1 on error
> > > > +
> > > > +/* for KVM_SET_PAGE_ENC_BITMAP */
> > > > +struct kvm_page_enc_bitmap {
> > > > +       __u64 start_gfn;
> > > > +       __u64 num_pages;
> > > > +       union {
> > > > +               void __user *enc_bitmap; /* one bit per page */
> > > > +               __u64 padding2;
> > > > +       };
> > > > +};
> > > > +
> > > > +During the guest live migration the outgoing guest exports its page encryption
> > > > +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > > > +bitmap for an incoming guest.
> > > >
> > > >  5. The kvm_run structure
> > > >  ========================
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 27e43e3ec9d8..d30f770aaaea 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
> > > >                                   unsigned long sz, unsigned long mode);
> > > >         int (*get_page_enc_bitmap)(struct kvm *kvm,
> > > >                                 struct kvm_page_enc_bitmap *bmap);
> > > > +       int (*set_page_enc_bitmap)(struct kvm *kvm,
> > > > +                               struct kvm_page_enc_bitmap *bmap);
> > > >  };
> > > >
> > > >  struct kvm_arch_async_pf {
> > > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > > index bae783cd396a..313343a43045 100644
> > > > --- a/arch/x86/kvm/svm.c
> > > > +++ b/arch/x86/kvm/svm.c
> > > > @@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
> > > >         return ret;
> > > >  }
> > > >
> > > > +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > > > +                                  struct kvm_page_enc_bitmap *bmap)
> > > > +{
> > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +       unsigned long gfn_start, gfn_end;
> > > > +       unsigned long *bitmap;
> > > > +       unsigned long sz, i;
> > > > +       int ret;
> > > > +
> > > > +       if (!sev_guest(kvm))
> > > > +               return -ENOTTY;
> > > > +
> > > > +       gfn_start = bmap->start_gfn;
> > > > +       gfn_end = gfn_start + bmap->num_pages;
> > > > +
> > > > +       sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> > > > +       bitmap = kmalloc(sz, GFP_KERNEL);
> > > > +       if (!bitmap)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       ret = -EFAULT;
> > > > +       if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
> > > > +               goto out;
> > > > +
> > > > +       mutex_lock(&kvm->lock);
> > > > +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> > > I realize now that usermode could use this for initializing the
> > > minimum size of the enc bitmap, which probably solves my issue from
> > > the other thread.
> > > > +       if (ret)
> > > > +               goto unlock;
> > > > +
> > > > +       i = gfn_start;
> > > > +       for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
> > > > +               clear_bit(i + gfn_start, sev->page_enc_bmap);
> > > This API seems a bit strange, since it can only clear bits. I would
> > > expect "set" to force the values to match the values passed down,
> > > instead of only ensuring that cleared bits in the input are also
> > > cleared in the kernel.
> > >
> >
> > The sev_resize_page_enc_bitmap() will allocate a new bitmap and
> > set it to all 0xFF's, therefore, the code here simply clears the bits
> > in the bitmap as per the cleared bits in the input.
> 
> If I'm not mistaken, resize only reinitializes the newly extended part
> of the buffer, and copies the old values for the rest.
> With the API you proposed you could probably reimplement a normal set
> call by calling get, then reset, and then set, but this feels
> cumbersome.
> 

As i mentioned earlier, the set api is basically meant for the incoming
VM, the resize will initialize the incoming VM's bitmap to all 0xFF's
and as there won't be any bitmap allocated initially on the incoming VM,
therefore, the bitmap copy will not do anything and the clear_bit later
will clear the incoming VM's bits as per the input.

Thanks,
Ashish

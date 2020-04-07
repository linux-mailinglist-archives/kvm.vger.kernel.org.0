Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D31A0689
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 07:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgDGF1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 01:27:53 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:5806
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbgDGF1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 01:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRBSY9aoWhqIhyxBPNngJeFyDw2oExsC3QeWgRVIBV7c7hxvC8PMo/bZsKO/zWdxrH8GSspeQ5SVfKXLd5VZgJxYc5FYN+y+yMmj8qf6HwJ1LyVSqmFO6Ied92FYYmcmVciqPTtiQu5avDQVBDFuMBtyrqQrKYsXWssgm+r+U7MLi0735uDTkxE95b3Fli8/BVItJFli6JH98mwhvPpOV71KMGjlNE1rtocmFsD1rCKUgD0RNGQoFnP0uO/TB2Ide6j0v9n/BfA/1PK3KyAKgosWj4uPjLax3bZ9gVOWUDq1c+hFfKcI9SoHikKePf36xV1ZROViPT6UF/8emqNQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbt5nzMrwUJIULLEcZ4pcrcORVx2yKkFJ7HGk6hU4BQ=;
 b=Zry+AKUHV42qQHSH1ca8uEgw2v2VvuthuqmV+U7jgr8+PIdUhgS7gnmTweusOJVoi5s8RwvM5pfaqusPTB0jQvML23y47bS1Ci0FHHxONl6n1znsD0GfUHvKLeXlVutZj19slK1H+rSrxejH2PFNwjmGciIZkJ4fk6nKOB5hbOK8DP4zQcO/SEbssyBuibJuhTfgxxYI7M/RgqcFjhyAdPHYCFbbpxDRIkDTgJkXda227x2q0HxA87w7L6BNLZUNtQEdk8KkBhxKxgQbFQYrzXjmHqKOk1V2CzKZbylHz6f+7AYFHuu3QSvqO26/HXxbS1ex035FEnzsDA5QXjPZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbt5nzMrwUJIULLEcZ4pcrcORVx2yKkFJ7HGk6hU4BQ=;
 b=1hQovGVnMulUHMTTe/aiorn6G/1gJ6PVzd3MlJG5W9tm9UWjPQmgYH/xAD0hV2pNVj6tAW37NyCoNxA9dhk4m0N1TN0tVcMBfhms6FH2s7Cd1lKsWIr1rJf05ITBxL87usJl8fK35cLwzvsbfRyjAF/Pm/1J5JDMdk4uCXTx+A4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1162.namprd12.prod.outlook.com (2603:10b6:3:72::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.19; Tue, 7 Apr 2020 05:27:45 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Tue, 7 Apr 2020
 05:27:45 +0000
Date:   Tue, 7 Apr 2020 05:27:40 +0000
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
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20200407052740.GA31821@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:3:c0::15) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR16CA0005.namprd16.prod.outlook.com (2603:10b6:3:c0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Tue, 7 Apr 2020 05:27:44 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe1879cf-db01-4600-11f2-08d7dab466f8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1162:|DM5PR12MB1162:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1162D1E48B4EF65BF9971B808EC30@DM5PR12MB1162.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(55016002)(44832011)(81156014)(8676002)(81166006)(478600001)(8936002)(956004)(26005)(86362001)(316002)(4326008)(186003)(54906003)(16526019)(33716001)(6916009)(66946007)(66556008)(6496006)(2906002)(6666004)(53546011)(66476007)(9686003)(33656002)(7416002)(1076003)(5660300002)(66574012)(52116002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIryq6bKZ7mSTz5G48zAlkrH36yRMK50/LKFFT/TpiraT8x9192KFzLRqBsabSEe6ptFfNBC5gSzF6zocx8stOqXquQdWjW6MHdGbuqNHvf4GMA3EGzCg4t4EDnXTGN2UI9eFNtPAAagpFufr/pvsXaaHziN6Y0o6wgIuV5asN62mxuIBLA+H59FDI5UPrCasyjfvgX5Jpd/7A6QkvHWJfwwK7+L3oioGAZNOOgAtaS+iwbhcuH+fRNhvTW0hqStidM3xTftuh7/u6uKDVBHkN+cPk9FJFVHeV4S+2tvTDcu0UcKaqKW+UVaczUJl1c5/dtIx9K/4CM0yP/RrtLXJ6t8a5uVFxAnkjmsZ3WPRz0mtOBGi+4Ehn382SWJTP0f+YezUfwceh+Ko+cDooaeJVc327ZBXKQMT1MdZI5NQ66GKQnFPYvhTEEGkaKr4nDi
X-MS-Exchange-AntiSpam-MessageData: YQUyYMZoaOX9ppAX2jR15AqZjzRw1znbuvNv+9ExtX+OBZLYU9fG0iP1jxU8kWxWW9NLhFIcNnp/UP/gIeFUmCxukyRK3DQEEFJSHMyMsueVhLM2V6YRneqRhdAJLuairtTICDwJALdRFLny0E8E9w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1879cf-db01-4600-11f2-08d7dab466f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 05:27:45.5405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjJl6ZLrvSzGvxphTmqxuIoqY2yiVy3wstdsaTmkqvQhcKcvkc0PzwFcC9wgk+i7O1Y6utbDb+VNj0gy8fD/Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wrote:
> On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> >
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> >  arch/x86/include/asm/kvm_host.h       |  2 +
> >  arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c                |  1 +
> >  arch/x86/kvm/x86.c                    |  6 ++
> >  include/uapi/linux/kvm_para.h         |  1 +
> >  6 files changed, 120 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > index dbaf207e560d..ff5287e68e81 100644
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
> > index 98959e8cd448..90718fa3db47 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> >
> >         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> >         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > +                                 unsigned long sz, unsigned long mode);
> Nit: spell out size instead of sz.
> >  };
> >
> >  struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 7c2721e18b06..1d8beaf1bceb 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -136,6 +136,8 @@ struct kvm_sev_info {
> >         int fd;                 /* SEV device fd */
> >         unsigned long pages_locked; /* Number of pages locked */
> >         struct list_head regions_list;  /* List of registered regions */
> > +       unsigned long *page_enc_bmap;
> > +       unsigned long page_enc_bmap_size;
> >  };
> >
> >  struct kvm_svm {
> > @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
> >
> >         sev_unbind_asid(kvm, sev->handle);
> >         sev_asid_free(sev->asid);
> > +
> > +       kvfree(sev->page_enc_bmap);
> > +       sev->page_enc_bmap = NULL;
> >  }
> >
> >  static void avic_vm_destroy(struct kvm *kvm)
> > @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >         return ret;
> >  }
> >
> > +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +       unsigned long *map;
> > +       unsigned long sz;
> > +
> > +       if (sev->page_enc_bmap_size >= new_size)
> > +               return 0;
> > +
> > +       sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> > +
> > +       map = vmalloc(sz);
> > +       if (!map) {
> > +               pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> > +                               sz);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       /* mark the page encrypted (by default) */
> > +       memset(map, 0xff, sz);
> > +
> > +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> > +       kvfree(sev->page_enc_bmap);
> > +
> > +       sev->page_enc_bmap = map;
> > +       sev->page_enc_bmap_size = new_size;
> > +
> > +       return 0;
> > +}
> > +
> > +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > +                                 unsigned long npages, unsigned long enc)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +       kvm_pfn_t pfn_start, pfn_end;
> > +       gfn_t gfn_start, gfn_end;
> > +       int ret;
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
> > +                * to the page encryption bitmap.
> > +                */
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +               /*
> > +                * Allow guest MMIO range(s) to be added
> > +                * to the page encryption bitmap.
> > +                */
> > +               return -EINVAL;
> > +       }
> > +
> > +       mutex_lock(&kvm->lock);
> > +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> > +       if (ret)
> > +               goto unlock;
> > +
> > +       if (enc)
> > +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> > +                               gfn_end - gfn_start);
> > +       else
> > +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
> > +                               gfn_end - gfn_start);
> > +
> > +unlock:
> > +       mutex_unlock(&kvm->lock);
> > +       return ret;
> > +}
> > +
> >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >         struct kvm_sev_cmd sev_cmd;
> > @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> >
> >         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > +
> > +       .page_enc_status_hc = svm_page_enc_status_hc,
> >  };
> >
> >  static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 079d9fbf278e..f68e76ee7f9c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >         .nested_get_evmcs_version = NULL,
> >         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> >         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> > +       .page_enc_status_hc = NULL,
> >  };
> >
> >  static void vmx_cleanup_l1d_flush(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index cf95c36cb4f4..68428eef2dde 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >                 kvm_sched_yield(vcpu->kvm, a0);
> >                 ret = 0;
> >                 break;
> > +       case KVM_HC_PAGE_ENC_STATUS:
> > +               ret = -KVM_ENOSYS;
> > +               if (kvm_x86_ops->page_enc_status_hc)
> > +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> > +                                       a0, a1, a2);
> > +               break;
> >         default:
> >                 ret = -KVM_ENOSYS;
> >                 break;
> > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > index 8b86609849b9..847b83b75dc8 100644
> > --- a/include/uapi/linux/kvm_para.h
> > +++ b/include/uapi/linux/kvm_para.h
> > @@ -29,6 +29,7 @@
> >  #define KVM_HC_CLOCK_PAIRING           9
> >  #define KVM_HC_SEND_IPI                10
> >  #define KVM_HC_SCHED_YIELD             11
> > +#define KVM_HC_PAGE_ENC_STATUS         12
> >
> >  /*
> >   * hypercalls use architecture specific
> > --
> > 2.17.1
> >
> 
> I'm still not excited by the dynamic resizing. I believe the guest
> hypercall can be called in atomic contexts, which makes me
> particularly unexcited to see a potentially large vmalloc on the host
> followed by filling the buffer. Particularly when the buffer might be
> non-trivial in size (~1MB per 32GB, per some back of the envelope
> math).
>

I think looking at more practical situations, most hypercalls will 
happen during the boot stage, when device specific initializations are
happening, so typically the maximum page encryption bitmap size would
be allocated early enough.

In fact, initial hypercalls made by OVMF will probably allocate the
maximum page bitmap size even before the kernel comes up, especially
as they will be setting up page enc/dec status for MMIO, ROM, ACPI
regions, PCI device memory, etc., and most importantly for
"non-existent" high memory range (which will probably be the
maximum size page encryption bitmap allocated/resized).

Let me know if you have different thoughts on this ?

> I'd like to see an enable cap for preallocating this. Yes, the first
> call might not be the right value because of hotplug, but won't the
> VMM know when hotplug is happening? If the VMM asks for the wrong
> size, and does not update the size correctly before granting the VM
> access to more RAM, that seems like the VMM's fault.o

Thanks,
Ashish

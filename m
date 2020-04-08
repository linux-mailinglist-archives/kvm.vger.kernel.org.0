Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E31A1A40
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 05:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDHDTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 23:19:06 -0400
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:37344
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbgDHDTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 23:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oV1vqLjz0vuXnxLWH/JLxM3rnB+UkQI3sn1WFB0Ok+GjimLYCCiJNy6dQsyEBysXauYbiIbT+DOvJ5XYReA99+QsNCb15kSFJ33R+pU47lcITP/RmxBV0Tn2438qfqM9MQoMF6mV2kDM4q5pQn2ioBbRvsG/H4dzZAloJ4zaVFgzxqqTi3P0RRYg8A9mOgYmcXkAxvPQdsH4Ml959tH8Ruht+JCudxmY/LenkfzRCYyz6JWaMfSc9RrZ4vM+x7vdaD9RpwEDtUKiYsdM5X+2gHsBHIOWODvF0TwsfhO6H712hpVzmFmFf7ZXe9N+o78R4TsYNOGRJXjokqmS4Z4loQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPppgCJeClCXnwkffLsOJDEVXvtdmXJKyxEtVUuIlMU=;
 b=VZYFlwsbfxai4qRCjWn6ZfzuxaPNFXHErWWkOy9h6OE+yA3Nvdp/mwBEGtOftiTK9tVj9yaXKpRzlErgjPXGpHeXoEdR2/HgeoEYzzoGLbMzITbxSs7+wVpTVJhe3/m1O//nnYIE32jzlVUB7SuTyX55VbCtv/0OUMtU0KKVpxPNCLbhBC13lMpmitmOWrVyP6Sp2S0Fq5Ku8gTP+Q4fWtfLF/GCH97k/i2jHXUJ59g5RvSfOh+gbQfBDT0ndZknFbCc8djzvf4AieKvt2tCLHComy32bAt4sCbE9RorqNg5L5kQD5naX8X/NvtXgFl4cejyfjX1mutqqUIcem6ZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPppgCJeClCXnwkffLsOJDEVXvtdmXJKyxEtVUuIlMU=;
 b=WsZ1iQaaA5i28vVkN0x/EZTsHN1nEdoTLJj9LjaDHP+FzjpEqsnSJY8C0g1D5BaorjYmrCMAUTL0gkNSsP4BujQoSTDzHOAuKji1v2Oh0kBPIk379EAlQuRSIfj79KKXHjiugbtJKY6jsLjBmvCX3LD3jL/rFTZr92qreOonItY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2501.namprd12.prod.outlook.com (2603:10b6:4:b4::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Wed, 8 Apr 2020 03:18:24 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 03:18:24 +0000
Date:   Wed, 8 Apr 2020 03:18:18 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20200408031818.GA27654@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
 <20200407052740.GA31821@ashkalra_ubuntu_server>
 <CABayD+cNdEJxoSHee3s0toy6-nO6Bm4-OsrbBdS8mCWoMBSqLQ@mail.gmail.com>
 <d67a104e-6a01-a766-63b2-3f8b6026ca4c@amd.com>
 <CABayD+ehZZabp2tA8K-ViB0BXPyjpz-XpXPXoD7MUH0OLz_Z-g@mail.gmail.com>
 <20200408011726.GA3684@ashkalra_ubuntu_server>
 <CABayD+et6p8UAr1jTFMK2SbYvihveLH6kp=RRqzBxvaU-HPy2Q@mail.gmail.com>
 <42597534-b8c6-4c73-9b12-ddbde079fc7c@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42597534-b8c6-4c73-9b12-ddbde079fc7c@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN6PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:805:ca::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR16CA0052.namprd16.prod.outlook.com (2603:10b6:805:ca::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Wed, 8 Apr 2020 03:18:23 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b0c5023-657f-4234-3596-08d7db6b7f68
X-MS-TrafficTypeDiagnostic: DM5PR12MB2501:|DM5PR12MB2501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2501A536F63C1F197A8C12E88EC00@DM5PR12MB2501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(33656002)(44832011)(956004)(478600001)(55016002)(30864003)(16526019)(966005)(2906002)(66574012)(6862004)(81166007)(86362001)(186003)(54906003)(9686003)(4326008)(316002)(6496006)(6636002)(53546011)(66946007)(5660300002)(1076003)(8676002)(81156014)(26005)(66556008)(66476007)(6666004)(52116002)(7416002)(8936002)(33716001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RD6c33EzNQFvP5FgEQD2WwhS+7/gm5maZmnHwW1s4jT2P9b9qw6C8HUWguQC8tZl7SJaxGGPX4xczDfPm0Bcuo5U5gvYIoR+6KVb9DwEvFvdQmphYrT7saWntn2e2rapUUfcF6M4tiOW1balMZrl4AJvy8N+BNg15NWxTmxFqMZywM6VdfD0mChHWdUTglnitc+9qwH44T/Kt1froLCniC9S0idgFenWvTsmR3udS7PDdAkdTQn8RrrfGWOTB9Ire9cBpX6eBOTr4c+Vfdzq/yvhHcM5c5ejTE7UoRvxC6EYfVHacDjof8JZ6Es3gtnwyKMf2NsqRc3b4AaisLGkDTuKEaBH0txGOO2xSXQ74FAdudiOH2vcgN7sG+GcRrxx0xenbtQYG+TBk/bYQD8Dyc3YCT5f8Xfs2cSlBqsqgFGU8ZQbCx9sSULdGSliWi0W1sa/JjhPz8yya4TZfB62k8YlJw/eyoY5wvixOzUxhrtYF0hjp0XEFgt7za5157P3YIsh4tiFtU5g0xWje7Xj+w==
X-MS-Exchange-AntiSpam-MessageData: cm+/ehII8WLQDg1pFSoPMfjRjGbGUwhtc/lR3ReEEtogONqJmofgVn/YU5ertpb6pr2q7LQ6h31FGWsjOgtgc43aCRuSrIy+xsOQmh79FVfj2zFlEQHX1N+H0H5Dpl/2+9lHzfEYxv8oIIC5iVl4ww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0c5023-657f-4234-3596-08d7db6b7f68
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 03:18:24.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LfsziM/Q574a/qy7yyObs6NmQJVOMhwrApjv1W8qeV3SIBzoUBzS5ezViffdC9nvR7OP7exP5fTy8Uq9Z3wXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2501
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,

On Tue, Apr 07, 2020 at 09:34:15PM -0500, Brijesh Singh wrote:
> 
> On 4/7/20 8:38 PM, Steve Rutherford wrote:
> > On Tue, Apr 7, 2020 at 6:17 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >> Hello Steve, Brijesh,
> >>
> >> On Tue, Apr 07, 2020 at 05:35:57PM -0700, Steve Rutherford wrote:
> >>> On Tue, Apr 7, 2020 at 5:29 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
> >>>>
> >>>> On 4/7/20 7:01 PM, Steve Rutherford wrote:
> >>>>> On Mon, Apr 6, 2020 at 10:27 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >>>>>> Hello Steve,
> >>>>>>
> >>>>>> On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wrote:
> >>>>>>> On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >>>>>>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
> >>>>>>>>
> >>>>>>>> This hypercall is used by the SEV guest to notify a change in the page
> >>>>>>>> encryption status to the hypervisor. The hypercall should be invoked
> >>>>>>>> only when the encryption attribute is changed from encrypted -> decrypted
> >>>>>>>> and vice versa. By default all guest pages are considered encrypted.
> >>>>>>>>
> >>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>>>>>> Cc: Ingo Molnar <mingo@redhat.com>
> >>>>>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>>>>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>>>>>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> >>>>>>>> Cc: Joerg Roedel <joro@8bytes.org>
> >>>>>>>> Cc: Borislav Petkov <bp@suse.de>
> >>>>>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>>>>>>> Cc: x86@kernel.org
> >>>>>>>> Cc: kvm@vger.kernel.org
> >>>>>>>> Cc: linux-kernel@vger.kernel.org
> >>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>>>>>>> ---
> >>>>>>>>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> >>>>>>>>  arch/x86/include/asm/kvm_host.h       |  2 +
> >>>>>>>>  arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
> >>>>>>>>  arch/x86/kvm/vmx/vmx.c                |  1 +
> >>>>>>>>  arch/x86/kvm/x86.c                    |  6 ++
> >>>>>>>>  include/uapi/linux/kvm_para.h         |  1 +
> >>>>>>>>  6 files changed, 120 insertions(+)
> >>>>>>>>
> >>>>>>>> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> >>>>>>>> index dbaf207e560d..ff5287e68e81 100644
> >>>>>>>> --- a/Documentation/virt/kvm/hypercalls.rst
> >>>>>>>> +++ b/Documentation/virt/kvm/hypercalls.rst
> >>>>>>>> @@ -169,3 +169,18 @@ a0: destination APIC ID
> >>>>>>>>
> >>>>>>>>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> >>>>>>>>                 any of the IPI target vCPUs was preempted.
> >>>>>>>> +
> >>>>>>>> +
> >>>>>>>> +8. KVM_HC_PAGE_ENC_STATUS
> >>>>>>>> +-------------------------
> >>>>>>>> +:Architecture: x86
> >>>>>>>> +:Status: active
> >>>>>>>> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> >>>>>>>> +
> >>>>>>>> +a0: the guest physical address of the start page
> >>>>>>>> +a1: the number of pages
> >>>>>>>> +a2: encryption attribute
> >>>>>>>> +
> >>>>>>>> +   Where:
> >>>>>>>> +       * 1: Encryption attribute is set
> >>>>>>>> +       * 0: Encryption attribute is cleared
> >>>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>>>>>> index 98959e8cd448..90718fa3db47 100644
> >>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>>>>>> @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> >>>>>>>>
> >>>>>>>>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> >>>>>>>>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> >>>>>>>> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> >>>>>>>> +                                 unsigned long sz, unsigned long mode);
> >>>>>>> Nit: spell out size instead of sz.
> >>>>>>>>  };
> >>>>>>>>
> >>>>>>>>  struct kvm_arch_async_pf {
> >>>>>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>>>>>>> index 7c2721e18b06..1d8beaf1bceb 100644
> >>>>>>>> --- a/arch/x86/kvm/svm.c
> >>>>>>>> +++ b/arch/x86/kvm/svm.c
> >>>>>>>> @@ -136,6 +136,8 @@ struct kvm_sev_info {
> >>>>>>>>         int fd;                 /* SEV device fd */
> >>>>>>>>         unsigned long pages_locked; /* Number of pages locked */
> >>>>>>>>         struct list_head regions_list;  /* List of registered regions */
> >>>>>>>> +       unsigned long *page_enc_bmap;
> >>>>>>>> +       unsigned long page_enc_bmap_size;
> >>>>>>>>  };
> >>>>>>>>
> >>>>>>>>  struct kvm_svm {
> >>>>>>>> @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
> >>>>>>>>
> >>>>>>>>         sev_unbind_asid(kvm, sev->handle);
> >>>>>>>>         sev_asid_free(sev->asid);
> >>>>>>>> +
> >>>>>>>> +       kvfree(sev->page_enc_bmap);
> >>>>>>>> +       sev->page_enc_bmap = NULL;
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>>  static void avic_vm_destroy(struct kvm *kvm)
> >>>>>>>> @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>>>>>         return ret;
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> >>>>>>>> +{
> >>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>>>>>>> +       unsigned long *map;
> >>>>>>>> +       unsigned long sz;
> >>>>>>>> +
> >>>>>>>> +       if (sev->page_enc_bmap_size >= new_size)
> >>>>>>>> +               return 0;
> >>>>>>>> +
> >>>>>>>> +       sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> >>>>>>>> +
> >>>>>>>> +       map = vmalloc(sz);
> >>>>>>>> +       if (!map) {
> >>>>>>>> +               pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> >>>>>>>> +                               sz);
> >>>>>>>> +               return -ENOMEM;
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>> +       /* mark the page encrypted (by default) */
> >>>>>>>> +       memset(map, 0xff, sz);
> >>>>>>>> +
> >>>>>>>> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> >>>>>>>> +       kvfree(sev->page_enc_bmap);
> >>>>>>>> +
> >>>>>>>> +       sev->page_enc_bmap = map;
> >>>>>>>> +       sev->page_enc_bmap_size = new_size;
> >>>>>>>> +
> >>>>>>>> +       return 0;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >>>>>>>> +                                 unsigned long npages, unsigned long enc)
> >>>>>>>> +{
> >>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>>>>>>> +       kvm_pfn_t pfn_start, pfn_end;
> >>>>>>>> +       gfn_t gfn_start, gfn_end;
> >>>>>>>> +       int ret;
> >>>>>>>> +
> >>>>>>>> +       if (!sev_guest(kvm))
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +
> >>>>>>>> +       if (!npages)
> >>>>>>>> +               return 0;
> >>>>>>>> +
> >>>>>>>> +       gfn_start = gpa_to_gfn(gpa);
> >>>>>>>> +       gfn_end = gfn_start + npages;
> >>>>>>>> +
> >>>>>>>> +       /* out of bound access error check */
> >>>>>>>> +       if (gfn_end <= gfn_start)
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +
> >>>>>>>> +       /* lets make sure that gpa exist in our memslot */
> >>>>>>>> +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> >>>>>>>> +       pfn_end = gfn_to_pfn(kvm, gfn_end);
> >>>>>>>> +
> >>>>>>>> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> >>>>>>>> +               /*
> >>>>>>>> +                * Allow guest MMIO range(s) to be added
> >>>>>>>> +                * to the page encryption bitmap.
> >>>>>>>> +                */
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> >>>>>>>> +               /*
> >>>>>>>> +                * Allow guest MMIO range(s) to be added
> >>>>>>>> +                * to the page encryption bitmap.
> >>>>>>>> +                */
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>> +       mutex_lock(&kvm->lock);
> >>>>>>>> +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> >>>>>>>> +       if (ret)
> >>>>>>>> +               goto unlock;
> >>>>>>>> +
> >>>>>>>> +       if (enc)
> >>>>>>>> +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> >>>>>>>> +                               gfn_end - gfn_start);
> >>>>>>>> +       else
> >>>>>>>> +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
> >>>>>>>> +                               gfn_end - gfn_start);
> >>>>>>>> +
> >>>>>>>> +unlock:
> >>>>>>>> +       mutex_unlock(&kvm->lock);
> >>>>>>>> +       return ret;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>>>>>>>  {
> >>>>>>>>         struct kvm_sev_cmd sev_cmd;
> >>>>>>>> @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >>>>>>>>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> >>>>>>>>
> >>>>>>>>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> >>>>>>>> +
> >>>>>>>> +       .page_enc_status_hc = svm_page_enc_status_hc,
> >>>>>>>>  };
> >>>>>>>>
> >>>>>>>>  static int __init svm_init(void)
> >>>>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>>>>>>> index 079d9fbf278e..f68e76ee7f9c 100644
> >>>>>>>> --- a/arch/x86/kvm/vmx/vmx.c
> >>>>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>>>>>>> @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >>>>>>>>         .nested_get_evmcs_version = NULL,
> >>>>>>>>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> >>>>>>>>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >>>>>>>> +       .page_enc_status_hc = NULL,
> >>>>>>>>  };
> >>>>>>>>
> >>>>>>>>  static void vmx_cleanup_l1d_flush(void)
> >>>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>>>>>>> index cf95c36cb4f4..68428eef2dde 100644
> >>>>>>>> --- a/arch/x86/kvm/x86.c
> >>>>>>>> +++ b/arch/x86/kvm/x86.c
> >>>>>>>> @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >>>>>>>>                 kvm_sched_yield(vcpu->kvm, a0);
> >>>>>>>>                 ret = 0;
> >>>>>>>>                 break;
> >>>>>>>> +       case KVM_HC_PAGE_ENC_STATUS:
> >>>>>>>> +               ret = -KVM_ENOSYS;
> >>>>>>>> +               if (kvm_x86_ops->page_enc_status_hc)
> >>>>>>>> +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> >>>>>>>> +                                       a0, a1, a2);
> >>>>>>>> +               break;
> >>>>>>>>         default:
> >>>>>>>>                 ret = -KVM_ENOSYS;
> >>>>>>>>                 break;
> >>>>>>>> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> >>>>>>>> index 8b86609849b9..847b83b75dc8 100644
> >>>>>>>> --- a/include/uapi/linux/kvm_para.h
> >>>>>>>> +++ b/include/uapi/linux/kvm_para.h
> >>>>>>>> @@ -29,6 +29,7 @@
> >>>>>>>>  #define KVM_HC_CLOCK_PAIRING           9
> >>>>>>>>  #define KVM_HC_SEND_IPI                10
> >>>>>>>>  #define KVM_HC_SCHED_YIELD             11
> >>>>>>>> +#define KVM_HC_PAGE_ENC_STATUS         12
> >>>>>>>>
> >>>>>>>>  /*
> >>>>>>>>   * hypercalls use architecture specific
> >>>>>>>> --
> >>>>>>>> 2.17.1
> >>>>>>>>
> >>>>>>> I'm still not excited by the dynamic resizing. I believe the guest
> >>>>>>> hypercall can be called in atomic contexts, which makes me
> >>>>>>> particularly unexcited to see a potentially large vmalloc on the host
> >>>>>>> followed by filling the buffer. Particularly when the buffer might be
> >>>>>>> non-trivial in size (~1MB per 32GB, per some back of the envelope
> >>>>>>> math).
> >>>>>>>
> >>>>>> I think looking at more practical situations, most hypercalls will
> >>>>>> happen during the boot stage, when device specific initializations are
> >>>>>> happening, so typically the maximum page encryption bitmap size would
> >>>>>> be allocated early enough.
> >>>>>>
> >>>>>> In fact, initial hypercalls made by OVMF will probably allocate the
> >>>>>> maximum page bitmap size even before the kernel comes up, especially
> >>>>>> as they will be setting up page enc/dec status for MMIO, ROM, ACPI
> >>>>>> regions, PCI device memory, etc., and most importantly for
> >>>>>> "non-existent" high memory range (which will probably be the
> >>>>>> maximum size page encryption bitmap allocated/resized).
> >>>>>>
> >>>>>> Let me know if you have different thoughts on this ?
> >>>>> Hi Ashish,
> >>>>>
> >>>>> If this is not an issue in practice, we can just move past this. If we
> >>>>> are basically guaranteed that OVMF will trigger hypercalls that expand
> >>>>> the bitmap beyond the top of memory, then, yes, that should work. That
> >>>>> leaves me slightly nervous that OVMF might regress since it's not
> >>>>> obvious that calling a hypercall beyond the top of memory would be
> >>>>> "required" for avoiding a somewhat indirectly related issue in guest
> >>>>> kernels.
> >>>>
> >>>> If possible then we should try to avoid growing/shrinking the bitmap .
> >>>> Today OVMF may not be accessing beyond memory but a malicious guest
> >>>> could send a hypercall down which can trigger a huge memory allocation
> >>>> on the host side and may eventually cause denial of service for other.
> >>> Nice catch! Was just writing up an email about this.
> >>>> I am in favor if we can find some solution to handle this case. How
> >>>> about Steve's suggestion about VMM making a call down to the kernel to
> >>>> tell how big the bitmap should be? Initially it should be equal to the
> >>>> guest RAM and if VMM ever did the memory expansion then it can send down
> >>>> another notification to increase the bitmap ?
> >>>>
> >>>> Optionally, instead of adding a new ioctl, I was wondering if we can
> >>>> extend the kvm_arch_prepare_memory_region() to make svm specific x86_ops
> >>>> which can take read the userspace provided memory region and calculate
> >>>> the amount of guest RAM managed by the KVM and grow/shrink the bitmap
> >>>> based on that information. I have not looked deep enough to see if its
> >>>> doable but if it can work then we can avoid adding yet another ioctl.
> >>> We also have the set bitmap ioctl in a later patch in this series. We
> >>> could also use the set ioctl for initialization (it's a little
> >>> excessive for initialization since there will be an additional
> >>> ephemeral allocation and a few additional buffer copies, but that's
> >>> probably fine). An enable_cap has the added benefit of probably being
> >>> necessary anyway so usermode can disable the migration feature flag.
> >>>
> >>> In general, userspace is going to have to be in direct control of the
> >>> buffer and its size.
> >> My only practical concern about setting a static bitmap size based on guest
> >> memory is about the hypercalls being made initially by OVMF to set page
> >> enc/dec status for ROM, ACPI regions and especially the non-existent
> >> high memory range. The new ioctl will statically setup bitmap size to
> >> whatever guest RAM is specified, say 4G, 8G, etc., but the OVMF
> >> hypercall for non-existent memory will try to do a hypercall for guest
> >> physical memory range like ~6G->64G (for 4G guest RAM setup), this
> >> hypercall will basically have to just return doing nothing, because
> >> the allocated bitmap won't have this guest physical range available ?
> 
> 
> IMO, Ovmf issuing a hypercall beyond the guest RAM is simple wrong, it
> should *not* do that.  There was a feature request I submitted sometime
> back to Tianocore https://bugzilla.tianocore.org/show_bug.cgi?id=623 as
> I saw this coming in future. I tried highlighting the problem in the
> MdeModulePkg that it does not provide a notifier to tell OVMF when core
> creates the MMIO holes etc. It was not a big problem with the SEV
> initially because we were never getting down to hypervisor to do
> something about those non-existent regions. But with the migration its
> now important that we should restart the discussion with UEFI folks and
> see what can be done. In the kernel patches we should do what is right
> for the kernel and not workaround the Ovmf limitation.

Ok, this makes sense. I will start exploring
kvm_arch_prepare_memory_region() to see if it can assist in computing
the guest RAM or otherwise i will look at adding a new ioctl interface
for the same.

Thanks,
Ashish

> 
> 
> >> Also, hypercalls for ROM, ACPI, device regions and any memory holes within
> >> the static bitmap setup as per guest RAM config will work, but what
> >> about hypercalls for any device regions beyond the guest RAM config ?
> >>
> >> Thanks,
> >> Ashish
> > I'm not super familiar with what the address beyond the top of ram is
> > used for. If the memory is not backed by RAM, will it even matter for
> > migration? Sounds like the encryption for SEV won't even apply to it.
> > If we don't need to know what the c-bit state of an address is, we
> > don't need to track it. It doesn't hurt to track it (which is why I'm
> > not super concerned about tracking the memory holes).

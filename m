Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672FA1A37E0
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgDIQSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 12:18:23 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:20840
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgDIQSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 12:18:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC3H+HOJdoUhMPWbAPvzRxCUMsscW/osH0ZNgq9wcstEqFDKaFwugqPycwDyeGHh1iXkxGhF3o+wxmLPY7erCH4mnUtP2qSG2fMxdo7qoy4ihqdV0Lqf+TbZQHzKCe0LmYPy96oxEL0bTAAeaBEOiJcPkzWoH4K8Wn91YJgqxMpylJXZVG6EzALyu4wNnQITnXZ8RnvgEYSxQGPWkTWVS/0P6NjpvHjEzhQHCk9YUQfRJMDqXoo0TEdVU5KhEiTrPzlv9ivfUrghhheLqh//Yg0eQnDGOvOTRunWkS3X8VqYd5IGNp6lm/GFeiQMXiKe62iNF+6S6f8qc3A6rurHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0t2jWSkLjRwUVfnuwielhDMVN0uFyw9Lfh6/GX0uv0=;
 b=XwjkS6jYeuyTL6pBJ8lkz1BjAVHt3bXteBf/3UKnJU+6qhEcXHIDfRo7H/AT+lhTqO11Tk4YDyNGNkxQg3yxMKNyKtaVg5NirGWZez+P81GPU4ZIexnnlWYfufOXmDnbl92W2a2Kn6g0KaO431nBlbNKvnAbO0dj/ZS/dZwWaaGg4C1jaPZLNlMv18ebK6aXkRFDYuyMfjTdutGkcCQycQLE6vX1fC+HKgIZndPdK46RS8HXgelsU5bAGSGI5r7YqCV0iMIoUtG39g36q9IaJUsJftwHQ8A305dTN0U4rGmbkTpnrIzsyqvl7HXcMMMr3qklGDfLq8mYEHzv7RtVqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0t2jWSkLjRwUVfnuwielhDMVN0uFyw9Lfh6/GX0uv0=;
 b=bynYT+LpBZAH8ZYknUiycUfePtB4gJNNtF172o3XrAXXvsO6T3IfUICTL0a4D87/g89L2cGe2U6whJfhbFJHaVSR/zo1jU5QFyHh1C4rQed9GdbmL6r09rdmgJSMx9E5e+UcnApPXgLch7aUxmtR5BHgdWrGzUOVig6XyhLE37c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1660.namprd12.prod.outlook.com (2603:10b6:4:9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Thu, 9 Apr 2020 16:18:18 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 16:18:18 +0000
Date:   Thu, 9 Apr 2020 16:18:12 +0000
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
Message-ID: <20200409161812.GA18882@ashkalra_ubuntu_server>
References: <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
 <20200407052740.GA31821@ashkalra_ubuntu_server>
 <CABayD+cNdEJxoSHee3s0toy6-nO6Bm4-OsrbBdS8mCWoMBSqLQ@mail.gmail.com>
 <d67a104e-6a01-a766-63b2-3f8b6026ca4c@amd.com>
 <CABayD+ehZZabp2tA8K-ViB0BXPyjpz-XpXPXoD7MUH0OLz_Z-g@mail.gmail.com>
 <20200408011726.GA3684@ashkalra_ubuntu_server>
 <CABayD+et6p8UAr1jTFMK2SbYvihveLH6kp=RRqzBxvaU-HPy2Q@mail.gmail.com>
 <42597534-b8c6-4c73-9b12-ddbde079fc7c@amd.com>
 <20200408031818.GA27654@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200408031818.GA27654@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR21CA0054.namprd21.prod.outlook.com
 (2603:10b6:3:129::16) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR21CA0054.namprd21.prod.outlook.com (2603:10b6:3:129::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.6 via Frontend Transport; Thu, 9 Apr 2020 16:18:16 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50909678-b8d3-4013-345d-08d7dca19cea
X-MS-TrafficTypeDiagnostic: DM5PR12MB1660:|DM5PR12MB1660:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1660053D8666767C7B077EFB8EC10@DM5PR12MB1660.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0368E78B5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(55016002)(186003)(33716001)(26005)(66556008)(316002)(66476007)(478600001)(16526019)(66946007)(81166007)(6862004)(6666004)(5660300002)(44832011)(86362001)(66574012)(53546011)(6636002)(52116002)(1076003)(956004)(8936002)(966005)(4326008)(33656002)(8676002)(2906002)(9686003)(81156014)(54906003)(6496006)(30864003)(7416002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yCn6WVxljAPETd6tUjDqSGpqObao1cYDXsBslP7WawGmDnHFdjAYVfdYHWkr5zs1yzk5QzjxCnmj3oSvJ1qkRXCKvsvAKWfGbMQ4I69osZVIUyKwkntxR4Lqbhr3Fk3hu3Ci6nnaT2mmitqH3qBP5/Mn8EOH8Oru7zpFzW0vkT7M8Ikp0UaLDPdkeb7WRQD3FcH6BlVx0mlrAZqt0AOVkEUKBQZNDiGfFP3aRRhGAMmLzjJiH8I9wjF3aRNZs1Al2oQZQemoITvUy2E/Klwc9/Uqahyb2Bd3iM6iZ3IOUnmzcjs2US2tb48Dn6ETw1OHm2ac1/vQsWmKyIMDefwHQ8G5XiXWnDu+e0PZimWiMlObDWTobQd7N+zT1Ii/5QtEHNZdwXc6GHgqkw9iSb17qLdS9ZHgyC01gGM8lXExQGZLatgwJyYHBmO760ZOxlYFF+QsjXz+VORhNo/+043pMtEe9Qch9p8R+jleS9dMohFHPD+1LhaDxZPSevgn29/0/u6hAVDdFXvZnQ3bPDUX1Q==
X-MS-Exchange-AntiSpam-MessageData: fJYF/U9ljLGPzvLKlp5P60sSzfxM9zk4ofxscNOpQ5zHwLZvXxxSXaQQe3iPqLWtCk0vjVj7lXL+J1G9Bk+tvwdSWdSPm7A+gyyK16A68VvR+WF6gpQnZwol0gIbhmBoOj7upLz/E7iq0Ad3U/BneA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50909678-b8d3-4013-345d-08d7dca19cea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2020 16:18:18.1042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8shW5tNGLoGQLdH81GfLqaX2AO3aDPvnK4riBeJsK9ZbolvSFh2D9z146Yavt4p+3ckZrpJZZH6+sbqyECKWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1660
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh, Steve,

On Wed, Apr 08, 2020 at 03:18:18AM +0000, Ashish Kalra wrote:
> Hello Brijesh,
> 
> On Tue, Apr 07, 2020 at 09:34:15PM -0500, Brijesh Singh wrote:
> > 
> > On 4/7/20 8:38 PM, Steve Rutherford wrote:
> > > On Tue, Apr 7, 2020 at 6:17 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >> Hello Steve, Brijesh,
> > >>
> > >> On Tue, Apr 07, 2020 at 05:35:57PM -0700, Steve Rutherford wrote:
> > >>> On Tue, Apr 7, 2020 at 5:29 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
> > >>>>
> > >>>> On 4/7/20 7:01 PM, Steve Rutherford wrote:
> > >>>>> On Mon, Apr 6, 2020 at 10:27 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >>>>>> Hello Steve,
> > >>>>>>
> > >>>>>> On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wrote:
> > >>>>>>> On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >>>>>>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
> > >>>>>>>>
> > >>>>>>>> This hypercall is used by the SEV guest to notify a change in the page
> > >>>>>>>> encryption status to the hypervisor. The hypercall should be invoked
> > >>>>>>>> only when the encryption attribute is changed from encrypted -> decrypted
> > >>>>>>>> and vice versa. By default all guest pages are considered encrypted.
> > >>>>>>>>
> > >>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> > >>>>>>>> Cc: Ingo Molnar <mingo@redhat.com>
> > >>>>>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> > >>>>>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > >>>>>>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > >>>>>>>> Cc: Joerg Roedel <joro@8bytes.org>
> > >>>>>>>> Cc: Borislav Petkov <bp@suse.de>
> > >>>>>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > >>>>>>>> Cc: x86@kernel.org
> > >>>>>>>> Cc: kvm@vger.kernel.org
> > >>>>>>>> Cc: linux-kernel@vger.kernel.org
> > >>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > >>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > >>>>>>>> ---
> > >>>>>>>>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> > >>>>>>>>  arch/x86/include/asm/kvm_host.h       |  2 +
> > >>>>>>>>  arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
> > >>>>>>>>  arch/x86/kvm/vmx/vmx.c                |  1 +
> > >>>>>>>>  arch/x86/kvm/x86.c                    |  6 ++
> > >>>>>>>>  include/uapi/linux/kvm_para.h         |  1 +
> > >>>>>>>>  6 files changed, 120 insertions(+)
> > >>>>>>>>
> > >>>>>>>> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > >>>>>>>> index dbaf207e560d..ff5287e68e81 100644
> > >>>>>>>> --- a/Documentation/virt/kvm/hypercalls.rst
> > >>>>>>>> +++ b/Documentation/virt/kvm/hypercalls.rst
> > >>>>>>>> @@ -169,3 +169,18 @@ a0: destination APIC ID
> > >>>>>>>>
> > >>>>>>>>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> > >>>>>>>>                 any of the IPI target vCPUs was preempted.
> > >>>>>>>> +
> > >>>>>>>> +
> > >>>>>>>> +8. KVM_HC_PAGE_ENC_STATUS
> > >>>>>>>> +-------------------------
> > >>>>>>>> +:Architecture: x86
> > >>>>>>>> +:Status: active
> > >>>>>>>> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > >>>>>>>> +
> > >>>>>>>> +a0: the guest physical address of the start page
> > >>>>>>>> +a1: the number of pages
> > >>>>>>>> +a2: encryption attribute
> > >>>>>>>> +
> > >>>>>>>> +   Where:
> > >>>>>>>> +       * 1: Encryption attribute is set
> > >>>>>>>> +       * 0: Encryption attribute is cleared
> > >>>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > >>>>>>>> index 98959e8cd448..90718fa3db47 100644
> > >>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
> > >>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
> > >>>>>>>> @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> > >>>>>>>>
> > >>>>>>>>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> > >>>>>>>>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > >>>>>>>> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > >>>>>>>> +                                 unsigned long sz, unsigned long mode);
> > >>>>>>> Nit: spell out size instead of sz.
> > >>>>>>>>  };
> > >>>>>>>>
> > >>>>>>>>  struct kvm_arch_async_pf {
> > >>>>>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > >>>>>>>> index 7c2721e18b06..1d8beaf1bceb 100644
> > >>>>>>>> --- a/arch/x86/kvm/svm.c
> > >>>>>>>> +++ b/arch/x86/kvm/svm.c
> > >>>>>>>> @@ -136,6 +136,8 @@ struct kvm_sev_info {
> > >>>>>>>>         int fd;                 /* SEV device fd */
> > >>>>>>>>         unsigned long pages_locked; /* Number of pages locked */
> > >>>>>>>>         struct list_head regions_list;  /* List of registered regions */
> > >>>>>>>> +       unsigned long *page_enc_bmap;
> > >>>>>>>> +       unsigned long page_enc_bmap_size;
> > >>>>>>>>  };
> > >>>>>>>>
> > >>>>>>>>  struct kvm_svm {
> > >>>>>>>> @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
> > >>>>>>>>
> > >>>>>>>>         sev_unbind_asid(kvm, sev->handle);
> > >>>>>>>>         sev_asid_free(sev->asid);
> > >>>>>>>> +
> > >>>>>>>> +       kvfree(sev->page_enc_bmap);
> > >>>>>>>> +       sev->page_enc_bmap = NULL;
> > >>>>>>>>  }
> > >>>>>>>>
> > >>>>>>>>  static void avic_vm_destroy(struct kvm *kvm)
> > >>>>>>>> @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >>>>>>>>         return ret;
> > >>>>>>>>  }
> > >>>>>>>>
> > >>>>>>>> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> > >>>>>>>> +{
> > >>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > >>>>>>>> +       unsigned long *map;
> > >>>>>>>> +       unsigned long sz;
> > >>>>>>>> +
> > >>>>>>>> +       if (sev->page_enc_bmap_size >= new_size)
> > >>>>>>>> +               return 0;
> > >>>>>>>> +
> > >>>>>>>> +       sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> > >>>>>>>> +
> > >>>>>>>> +       map = vmalloc(sz);
> > >>>>>>>> +       if (!map) {
> > >>>>>>>> +               pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> > >>>>>>>> +                               sz);
> > >>>>>>>> +               return -ENOMEM;
> > >>>>>>>> +       }
> > >>>>>>>> +
> > >>>>>>>> +       /* mark the page encrypted (by default) */
> > >>>>>>>> +       memset(map, 0xff, sz);
> > >>>>>>>> +
> > >>>>>>>> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> > >>>>>>>> +       kvfree(sev->page_enc_bmap);
> > >>>>>>>> +
> > >>>>>>>> +       sev->page_enc_bmap = map;
> > >>>>>>>> +       sev->page_enc_bmap_size = new_size;
> > >>>>>>>> +
> > >>>>>>>> +       return 0;
> > >>>>>>>> +}
> > >>>>>>>> +
> > >>>>>>>> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > >>>>>>>> +                                 unsigned long npages, unsigned long enc)
> > >>>>>>>> +{
> > >>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > >>>>>>>> +       kvm_pfn_t pfn_start, pfn_end;
> > >>>>>>>> +       gfn_t gfn_start, gfn_end;
> > >>>>>>>> +       int ret;
> > >>>>>>>> +
> > >>>>>>>> +       if (!sev_guest(kvm))
> > >>>>>>>> +               return -EINVAL;
> > >>>>>>>> +
> > >>>>>>>> +       if (!npages)
> > >>>>>>>> +               return 0;
> > >>>>>>>> +
> > >>>>>>>> +       gfn_start = gpa_to_gfn(gpa);
> > >>>>>>>> +       gfn_end = gfn_start + npages;
> > >>>>>>>> +
> > >>>>>>>> +       /* out of bound access error check */
> > >>>>>>>> +       if (gfn_end <= gfn_start)
> > >>>>>>>> +               return -EINVAL;
> > >>>>>>>> +
> > >>>>>>>> +       /* lets make sure that gpa exist in our memslot */
> > >>>>>>>> +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> > >>>>>>>> +       pfn_end = gfn_to_pfn(kvm, gfn_end);
> > >>>>>>>> +
> > >>>>>>>> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > >>>>>>>> +               /*
> > >>>>>>>> +                * Allow guest MMIO range(s) to be added
> > >>>>>>>> +                * to the page encryption bitmap.
> > >>>>>>>> +                */
> > >>>>>>>> +               return -EINVAL;
> > >>>>>>>> +       }
> > >>>>>>>> +
> > >>>>>>>> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > >>>>>>>> +               /*
> > >>>>>>>> +                * Allow guest MMIO range(s) to be added
> > >>>>>>>> +                * to the page encryption bitmap.
> > >>>>>>>> +                */
> > >>>>>>>> +               return -EINVAL;
> > >>>>>>>> +       }
> > >>>>>>>> +
> > >>>>>>>> +       mutex_lock(&kvm->lock);
> > >>>>>>>> +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> > >>>>>>>> +       if (ret)
> > >>>>>>>> +               goto unlock;
> > >>>>>>>> +
> > >>>>>>>> +       if (enc)
> > >>>>>>>> +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> > >>>>>>>> +                               gfn_end - gfn_start);
> > >>>>>>>> +       else
> > >>>>>>>> +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
> > >>>>>>>> +                               gfn_end - gfn_start);
> > >>>>>>>> +
> > >>>>>>>> +unlock:
> > >>>>>>>> +       mutex_unlock(&kvm->lock);
> > >>>>>>>> +       return ret;
> > >>>>>>>> +}
> > >>>>>>>> +
> > >>>>>>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >>>>>>>>  {
> > >>>>>>>>         struct kvm_sev_cmd sev_cmd;
> > >>>>>>>> @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > >>>>>>>>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> > >>>>>>>>
> > >>>>>>>>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > >>>>>>>> +
> > >>>>>>>> +       .page_enc_status_hc = svm_page_enc_status_hc,
> > >>>>>>>>  };
> > >>>>>>>>
> > >>>>>>>>  static int __init svm_init(void)
> > >>>>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > >>>>>>>> index 079d9fbf278e..f68e76ee7f9c 100644
> > >>>>>>>> --- a/arch/x86/kvm/vmx/vmx.c
> > >>>>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
> > >>>>>>>> @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> > >>>>>>>>         .nested_get_evmcs_version = NULL,
> > >>>>>>>>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> > >>>>>>>>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> > >>>>>>>> +       .page_enc_status_hc = NULL,
> > >>>>>>>>  };
> > >>>>>>>>
> > >>>>>>>>  static void vmx_cleanup_l1d_flush(void)
> > >>>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >>>>>>>> index cf95c36cb4f4..68428eef2dde 100644
> > >>>>>>>> --- a/arch/x86/kvm/x86.c
> > >>>>>>>> +++ b/arch/x86/kvm/x86.c
> > >>>>>>>> @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >>>>>>>>                 kvm_sched_yield(vcpu->kvm, a0);
> > >>>>>>>>                 ret = 0;
> > >>>>>>>>                 break;
> > >>>>>>>> +       case KVM_HC_PAGE_ENC_STATUS:
> > >>>>>>>> +               ret = -KVM_ENOSYS;
> > >>>>>>>> +               if (kvm_x86_ops->page_enc_status_hc)
> > >>>>>>>> +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> > >>>>>>>> +                                       a0, a1, a2);
> > >>>>>>>> +               break;
> > >>>>>>>>         default:
> > >>>>>>>>                 ret = -KVM_ENOSYS;
> > >>>>>>>>                 break;
> > >>>>>>>> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > >>>>>>>> index 8b86609849b9..847b83b75dc8 100644
> > >>>>>>>> --- a/include/uapi/linux/kvm_para.h
> > >>>>>>>> +++ b/include/uapi/linux/kvm_para.h
> > >>>>>>>> @@ -29,6 +29,7 @@
> > >>>>>>>>  #define KVM_HC_CLOCK_PAIRING           9
> > >>>>>>>>  #define KVM_HC_SEND_IPI                10
> > >>>>>>>>  #define KVM_HC_SCHED_YIELD             11
> > >>>>>>>> +#define KVM_HC_PAGE_ENC_STATUS         12
> > >>>>>>>>
> > >>>>>>>>  /*
> > >>>>>>>>   * hypercalls use architecture specific
> > >>>>>>>> --
> > >>>>>>>> 2.17.1
> > >>>>>>>>
> > >>>>>>> I'm still not excited by the dynamic resizing. I believe the guest
> > >>>>>>> hypercall can be called in atomic contexts, which makes me
> > >>>>>>> particularly unexcited to see a potentially large vmalloc on the host
> > >>>>>>> followed by filling the buffer. Particularly when the buffer might be
> > >>>>>>> non-trivial in size (~1MB per 32GB, per some back of the envelope
> > >>>>>>> math).
> > >>>>>>>
> > >>>>>> I think looking at more practical situations, most hypercalls will
> > >>>>>> happen during the boot stage, when device specific initializations are
> > >>>>>> happening, so typically the maximum page encryption bitmap size would
> > >>>>>> be allocated early enough.
> > >>>>>>
> > >>>>>> In fact, initial hypercalls made by OVMF will probably allocate the
> > >>>>>> maximum page bitmap size even before the kernel comes up, especially
> > >>>>>> as they will be setting up page enc/dec status for MMIO, ROM, ACPI
> > >>>>>> regions, PCI device memory, etc., and most importantly for
> > >>>>>> "non-existent" high memory range (which will probably be the
> > >>>>>> maximum size page encryption bitmap allocated/resized).
> > >>>>>>
> > >>>>>> Let me know if you have different thoughts on this ?
> > >>>>> Hi Ashish,
> > >>>>>
> > >>>>> If this is not an issue in practice, we can just move past this. If we
> > >>>>> are basically guaranteed that OVMF will trigger hypercalls that expand
> > >>>>> the bitmap beyond the top of memory, then, yes, that should work. That
> > >>>>> leaves me slightly nervous that OVMF might regress since it's not
> > >>>>> obvious that calling a hypercall beyond the top of memory would be
> > >>>>> "required" for avoiding a somewhat indirectly related issue in guest
> > >>>>> kernels.
> > >>>>
> > >>>> If possible then we should try to avoid growing/shrinking the bitmap .
> > >>>> Today OVMF may not be accessing beyond memory but a malicious guest
> > >>>> could send a hypercall down which can trigger a huge memory allocation
> > >>>> on the host side and may eventually cause denial of service for other.
> > >>> Nice catch! Was just writing up an email about this.
> > >>>> I am in favor if we can find some solution to handle this case. How
> > >>>> about Steve's suggestion about VMM making a call down to the kernel to
> > >>>> tell how big the bitmap should be? Initially it should be equal to the
> > >>>> guest RAM and if VMM ever did the memory expansion then it can send down
> > >>>> another notification to increase the bitmap ?
> > >>>>
> > >>>> Optionally, instead of adding a new ioctl, I was wondering if we can
> > >>>> extend the kvm_arch_prepare_memory_region() to make svm specific x86_ops
> > >>>> which can take read the userspace provided memory region and calculate
> > >>>> the amount of guest RAM managed by the KVM and grow/shrink the bitmap
> > >>>> based on that information. I have not looked deep enough to see if its
> > >>>> doable but if it can work then we can avoid adding yet another ioctl.
> > >>> We also have the set bitmap ioctl in a later patch in this series. We
> > >>> could also use the set ioctl for initialization (it's a little
> > >>> excessive for initialization since there will be an additional
> > >>> ephemeral allocation and a few additional buffer copies, but that's
> > >>> probably fine). An enable_cap has the added benefit of probably being
> > >>> necessary anyway so usermode can disable the migration feature flag.
> > >>>
> > >>> In general, userspace is going to have to be in direct control of the
> > >>> buffer and its size.
> > >> My only practical concern about setting a static bitmap size based on guest
> > >> memory is about the hypercalls being made initially by OVMF to set page
> > >> enc/dec status for ROM, ACPI regions and especially the non-existent
> > >> high memory range. The new ioctl will statically setup bitmap size to
> > >> whatever guest RAM is specified, say 4G, 8G, etc., but the OVMF
> > >> hypercall for non-existent memory will try to do a hypercall for guest
> > >> physical memory range like ~6G->64G (for 4G guest RAM setup), this
> > >> hypercall will basically have to just return doing nothing, because
> > >> the allocated bitmap won't have this guest physical range available ?
> > 
> > 
> > IMO, Ovmf issuing a hypercall beyond the guest RAM is simple wrong, it
> > should *not* do that.  There was a feature request I submitted sometime
> > back to Tianocore https://bugzilla.tianocore.org/show_bug.cgi?id=623 as
> > I saw this coming in future. I tried highlighting the problem in the
> > MdeModulePkg that it does not provide a notifier to tell OVMF when core
> > creates the MMIO holes etc. It was not a big problem with the SEV
> > initially because we were never getting down to hypervisor to do
> > something about those non-existent regions. But with the migration its
> > now important that we should restart the discussion with UEFI folks and
> > see what can be done. In the kernel patches we should do what is right
> > for the kernel and not workaround the Ovmf limitation.
> 
> Ok, this makes sense. I will start exploring
> kvm_arch_prepare_memory_region() to see if it can assist in computing
> the guest RAM or otherwise i will look at adding a new ioctl interface
> for the same.
> 

I looked at kvm_arch_prepare_memory_region() and
kvm_arch_commit_memory_region() and kvm_arch_commit_memory_region()
looks to be ideal to use for this.

I walked the kvm_memslots in this function and i can compute the
approximate guest RAM mapped by KVM, though, i get the guest RAM size as
"twice" the configured size because of the two address spaces on x86 KVM,
i believe there is one additional address space for SMM/SMRAM use.

I don't think we have a use case of migrating a SEV guest with SMM
support ?

Considering that, i believe that i can just compute the guest RAM size
using memslots for address space #0 and use that to grow/shrink the bitmap. 

As you mentioned i will need to add a new SVM specific x86_ops to
callback as part of kvm_arch_commit_memory_region() which will in-turn
call sev_resize_page_enc_bitmap().

Thanks,
Ashish

> > 
> > 
> > >> Also, hypercalls for ROM, ACPI, device regions and any memory holes within
> > >> the static bitmap setup as per guest RAM config will work, but what
> > >> about hypercalls for any device regions beyond the guest RAM config ?
> > >>
> > >> Thanks,
> > >> Ashish
> > > I'm not super familiar with what the address beyond the top of ram is
> > > used for. If the memory is not backed by RAM, will it even matter for
> > > migration? Sounds like the encryption for SEV won't even apply to it.
> > > If we don't need to know what the c-bit state of an address is, we
> > > don't need to track it. It doesn't hurt to track it (which is why I'm
> > > not super concerned about tracking the memory holes).

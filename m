Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78E1A3DC9
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 03:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDJBe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 21:34:26 -0400
Received: from mail-eopbgr760051.outbound.protection.outlook.com ([40.107.76.51]:45457
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbgDJBe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 21:34:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i21dkomPYHnGznuS6iIbto3QRZ9Oa3SKOnRvmzQNAQ+Jdj1EE7xuYqm8dLeR8bIp852zpX3jhjpNoqAsR4TkOYdSvF4d9n+P8pM7qYkcBDX0b+M2VJXKTIZV2qQ1SAY1juBUuheCTdKseigyoHBxVwXXhYe9eorh6bS05BlGFgCYC9Q6Kjc8hGZT3mrM1ToloxwrQYZF14y1O1CqCdSEzhwEXSuVfACs8fwU6iIA3NGv0QA30IbyrTRpg1OpgIcx1DEAgcR9VLJl4YkdkN6lAH5+4Ap4OhehfQ7CiDOeqII90tIk9byUHcZNSmGG/zVPCn6KJTH5+OMoEkZuyWSJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwYd+cV6j2MCMM/l2pxr2G/fQl20hcsjD4B2UKFSfHE=;
 b=Vql2pWKYDnSYU5LMZz84UWFfW1ArWdVehoZQ8psDwBEx8SwIx5ojesWssUiAsKaX2dq64mjt8H58LlVqECDh8kFCWDrbIUL71l4FlvgsdgjiHCnuXuoUIkwx8mRrBRq5DD6Wu0DzeWsr0SVKQTpXVnBXu7x8b50OqZdjvmDT/u5Cvvp0havBJjd9ybH2yr6GFtpyTqBMTkQ6g08KyJzUrianVwKTgwAbYIPseqA4cM0wnp3VVqcqOmLarmtMDGzzHzEiKxSflojolrJIdCY1KznGyaM4/ic6gqgut7VJYpC+sDMUh39sgE1KYbwwYPXlNXRS5hZfPmviY0b6I9ol9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwYd+cV6j2MCMM/l2pxr2G/fQl20hcsjD4B2UKFSfHE=;
 b=krSP9dJj8oy5kaK7mhKTiRB8dMNzp8fVAPatdX7SsvkifBQBZoTAV9ObfI8mObfNISfqMkmaQAxfn/FCi+FndQONfo2rXCGWfd7PZ+VD/bf2HQ4O1g1ecr/VMCsnxV32UR3Cjf11oaEE7EezAcLOl4ZcMTrwmqJ4tkqVuM4cu/k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1627.namprd12.prod.outlook.com (2603:10b6:4:10::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Fri, 10 Apr 2020 01:34:21 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Fri, 10 Apr 2020
 01:34:21 +0000
Date:   Fri, 10 Apr 2020 01:34:18 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200410013418.GB19168@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
 <20200403214559.GB28747@ashkalra_ubuntu_server>
 <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
 <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0501CA0091.namprd05.prod.outlook.com
 (2603:10b6:803:22::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0091.namprd05.prod.outlook.com (2603:10b6:803:22::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.6 via Frontend Transport; Fri, 10 Apr 2020 01:34:20 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8406f565-f10b-4b20-e179-08d7dcef4b3e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1627:|DM5PR12MB1627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1627C2375A04DA5F7FE15B548EDE0@DM5PR12MB1627.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(33716001)(81156014)(1076003)(53546011)(2906002)(8676002)(9686003)(316002)(5660300002)(66556008)(54906003)(6916009)(33656002)(66946007)(66476007)(4326008)(16526019)(956004)(81166007)(6496006)(86362001)(44832011)(52116002)(478600001)(55016002)(186003)(26005)(7416002)(8936002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7xljJ39npfQWCzqPt/n0exWdh99qFCzncBvriPMvUOkxifECS6Wiyc3wDtFCI8qzSCQi8vRqu2qHF2uzsbwe5GBZezdvOB1bt4Amxq7bH/c1qsET9WDOWpc1PbV1G45UEzSGg6kFpgYPWDKHPRgLd8jaHuR2PCoc0+ix9V7NmFNJIOSxkhX0F4WzLqKbPvcITkrBhYf/h8+8cb2tC7rPhhFcZHI6CuncUnrSo4TV9HPHjh7UVT0KCpRCDeisS2fTSIhHIg4Rspa2Ym1CEYsURh1v4KZQNwl1ihllXSXXwOn9APvMNFlIN6TbSgab7VxS45mKGXfO4ARTlrwaRkBJdAF6zhgPBz1v0pNfTjjTay9vqVxA/hrYRzxYNS2jCPJArzu1jB3xw8wfSilaccXfPVWjQnnteMQX0dYLPAzgzDig6acFmGeqcwSbbijzoQsI
X-MS-Exchange-AntiSpam-MessageData: zEve+eUG2z9MILlFvimnqZHPeUpUeq/qYTljxbn/xI0E9NZX3RdVh01oQ3l8ySbEXSzWIMrHZX+ReKtsWAtyeQpcQnSFNN7nKG5sHN8dlMVqPi/xVhJvdbqSisQ/GrQTkBTeTXxQVvIQolSHLdPPoQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8406f565-f10b-4b20-e179-08d7dcef4b3e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 01:34:21.5610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDWE+DOoORt4SUY/4ptSXwk4AwFkzkPf9x6k3h/6yM8z6Rd4CDB7dq/zWwXIMltqHfluf4Mx/xI+2/xaOEBdxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1627
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Apr 09, 2020 at 05:59:56PM -0700, Steve Rutherford wrote:
> On Tue, Apr 7, 2020 at 6:52 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
> > > On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan
> > > <krish.sadhukhan@oracle.com> wrote:
> > > >
> > > >
> > > > On 4/3/20 2:45 PM, Ashish Kalra wrote:
> > > > > On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> > > > >> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > > > >>> From: Ashish Kalra <ashish.kalra@amd.com>
> > > > >>>
> > > > >>> This ioctl can be used by the application to reset the page
> > > > >>> encryption bitmap managed by the KVM driver. A typical usage
> > > > >>> for this ioctl is on VM reboot, on reboot, we must reinitialize
> > > > >>> the bitmap.
> > > > >>>
> > > > >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > >>> ---
> > > > >>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> > > > >>>    arch/x86/include/asm/kvm_host.h |  1 +
> > > > >>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> > > > >>>    arch/x86/kvm/x86.c              |  6 ++++++
> > > > >>>    include/uapi/linux/kvm.h        |  1 +
> > > > >>>    5 files changed, 37 insertions(+)
> > > > >>>
> > > > >>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > >>> index 4d1004a154f6..a11326ccc51d 100644
> > > > >>> --- a/Documentation/virt/kvm/api.rst
> > > > >>> +++ b/Documentation/virt/kvm/api.rst
> > > > >>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> > > > >>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > > > >>>    bitmap for an incoming guest.
> > > > >>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> > > > >>> +-----------------------------------------
> > > > >>> +
> > > > >>> +:Capability: basic
> > > > >>> +:Architectures: x86
> > > > >>> +:Type: vm ioctl
> > > > >>> +:Parameters: none
> > > > >>> +:Returns: 0 on success, -1 on error
> > > > >>> +
> > > > >>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> > > > >>> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> > > > >>> +
> > > > >>> +
> > > > >>>    5. The kvm_run structure
> > > > >>>    ========================
> > > > >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > >>> index d30f770aaaea..a96ef6338cd2 100644
> > > > >>> --- a/arch/x86/include/asm/kvm_host.h
> > > > >>> +++ b/arch/x86/include/asm/kvm_host.h
> > > > >>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> > > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > > >>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
> > > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > > >>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
> > > > >>>    };
> > > > >>>    struct kvm_arch_async_pf {
> > > > >>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > > >>> index 313343a43045..c99b0207a443 100644
> > > > >>> --- a/arch/x86/kvm/svm.c
> > > > >>> +++ b/arch/x86/kvm/svm.c
> > > > >>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > > > >>>     return ret;
> > > > >>>    }
> > > > >>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> > > > >>> +{
> > > > >>> +   struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > >>> +
> > > > >>> +   if (!sev_guest(kvm))
> > > > >>> +           return -ENOTTY;
> > > > >>> +
> > > > >>> +   mutex_lock(&kvm->lock);
> > > > >>> +   /* by default all pages should be marked encrypted */
> > > > >>> +   if (sev->page_enc_bmap_size)
> > > > >>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> > > > >>> +   mutex_unlock(&kvm->lock);
> > > > >>> +   return 0;
> > > > >>> +}
> > > > >>> +
> > > > >>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > > > >>>    {
> > > > >>>     struct kvm_sev_cmd sev_cmd;
> > > > >>> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > > > >>>     .page_enc_status_hc = svm_page_enc_status_hc,
> > > > >>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > > > >>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > > > >>> +   .reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
> > > > >>
> > > > >> We don't need to initialize the intel ops to NULL ? It's not initialized in
> > > > >> the previous patch either.
> > > > >>
> > > > >>>    };
> > > > > This struct is declared as "static storage", so won't the non-initialized
> > > > > members be 0 ?
> > > >
> > > >
> > > > Correct. Although, I see that 'nested_enable_evmcs' is explicitly
> > > > initialized. We should maintain the convention, perhaps.
> > > >
> > > > >
> > > > >>>    static int __init svm_init(void)
> > > > >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > >>> index 05e953b2ec61..2127ed937f53 100644
> > > > >>> --- a/arch/x86/kvm/x86.c
> > > > >>> +++ b/arch/x86/kvm/x86.c
> > > > >>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > > > >>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> > > > >>>             break;
> > > > >>>     }
> > > > >>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
> > > > >>> +           r = -ENOTTY;
> > > > >>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
> > > > >>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> > > > >>> +           break;
> > > > >>> +   }
> > > > >>>     default:
> > > > >>>             r = -ENOTTY;
> > > > >>>     }
> > > > >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > >>> index b4b01d47e568..0884a581fc37 100644
> > > > >>> --- a/include/uapi/linux/kvm.h
> > > > >>> +++ b/include/uapi/linux/kvm.h
> > > > >>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> > > > >>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > > > >>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> > > > >>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
> > > > >>>    /* Secure Encrypted Virtualization command */
> > > > >>>    enum sev_cmd_id {
> > > > >> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > >
> > >
> > > Doesn't this overlap with the set ioctl? Yes, obviously, you have to
> > > copy the new value down and do a bit more work, but I don't think
> > > resetting the bitmap is going to be the bottleneck on reboot. Seems
> > > excessive to add another ioctl for this.
> >
> > The set ioctl is generally available/provided for the incoming VM to setup
> > the page encryption bitmap, this reset ioctl is meant for the source VM
> > as a simple interface to reset the whole page encryption bitmap.
> >
> > Thanks,
> > Ashish
> 
> 
> Hey Ashish,
> 
> These seem very overlapping. I think this API should be refactored a bit.
> 
> 1) Use kvm_vm_ioctl_enable_cap to control whether or not this
> hypercall (and related feature bit) is offered to the VM, and also the
> size of the buffer.

If you look at patch 13/14, i have added a new kvm para feature called
"KVM_FEATURE_SEV_LIVE_MIGRATION" which indicates host support for SEV
Live Migration and a new Custom MSR which the guest does a wrmsr to
enable the Live Migration feature, so this is like the enable cap
support.

There are further extensions to this support i am adding, so patch 13/14
of this patch-set is still being enhanced and will have full support
when i repost next.

> 2) Use set for manipulating values in the bitmap, including resetting
> the bitmap. Set the bitmap pointer to null if you want to reset to all
> 0xFFs. When the bitmap pointer is set, it should set the values to
> exactly what is pointed at, instead of only clearing bits, as is done
> currently.

As i mentioned in my earlier email, the set api is supposed to be for
the incoming VM, but if you really need to use it for the outgoing VM
then it can be modified. 

> 3) Use get for fetching values from the kernel. Personally, I'd
> require alignment of the base GFN to a multiple of 8 (but the number
> of pages could be whatever), so you can just use a memcpy. Optionally,
> you may want some way to tell userspace the size of the existing
> buffer, so it can ensure that it can ask for the entire buffer without
> having to track the size in usermode (not strictly necessary, but nice
> to have since it ensures that there is only one place that has to
> manage this value).
> 
> If you want to expand or contract the bitmap, you can use enable cap
> to adjust the size.

As being discussed on the earlier mail thread, we are doing this
dynamically now by computing the guest RAM size when the
set_user_memory_region ioctl is invoked. I believe that should handle
the hot-plug and hot-unplug events too, as any hot memory updates will
need KVM memslots to be updated. 

> If you don't want to offer the hypercall to the guest, don't call the
> enable cap.
> This API avoids using up another ioctl. Ioctl space is somewhat
> scarce. It also gives userspace fine grained control over the buffer,
> so it can support both hot-plug and hot-unplug (or at the very least
> it is not obviously incompatible with those). It also gives userspace
> control over whether or not the feature is offered. The hypercall
> isn't free, and being able to tell guests to not call when the host
> wasn't going to migrate it anyway will be useful.
> 

As i mentioned above, now the host indicates if it supports the Live
Migration feature and the feature and the hypercall are only enabled on
the host when the guest checks for this support and does a wrmsr() to
enable the feature. Also the guest will not make the hypercall if the
host does not indicate support for it.

Thanks,
Ashish

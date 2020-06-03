Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3B1ED876
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 00:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgFCWOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 18:14:40 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:13404
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbgFCWOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 18:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aP13VSG40gJZ97WlmZe55rNL/IscvurwZgbETd1EzH9UaKReZLxDamlHz22jw19qHHHGsVlPgV+uNyDKMOksCWRFsEnsx9bjMGsFxAEq+i2HNxy6v6JYtx+Al0OM56lrCxRj++rEqFjO78PCDRv1RWBYF+MR798Vt6t9I40kSD++0hntgWS/muCfVJ/bXD5qKbqmn1AdDqPT7HSry1tndOMDLkvOV89dom4nfgE0SR2IxyM92rAmSmrvDgYcHxA4KfWuYt+71GdN7M1MDFU5IwNcm3z/adOGgTKU0xAhvaeXEHEs6jCuwgmK9CbyDp3NpGsRdUbxHH5K3BftOgy53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JG7j9slTEUsLyU7zZ8AD1t8p3OzP/GanNURKylK4NE=;
 b=AJlMpSkVa05w3W4S9cN2EvtQrFd28JXj3EWvJ1M2adNIg8qnwM4f64syj621DibaiGniOrGP2kaPYfiLLgU7kVENlKWkU7RTmWQTy4fUvUWn7xSg49bzY6fQLNhYLJQ+T+AyfTK4PZcVJlvQJoeNCgvXTAWWadWpEGluc2XtrIfw4fn6Sf3a+UPQ0WpERSptjFMN/50gCl+76nshFE1Icsq/4BS3u7Rp8wcKAOlXs6Rj3E4NsFVNchAfRyMZFTY9E1NVb5h0ZKROp504mhXm8X5C4i99qG0IdQpPBBBp8Nx4meDLNZ3MRUtLTkqKKePPSRpu2sYkAwX9QyV7mMeHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JG7j9slTEUsLyU7zZ8AD1t8p3OzP/GanNURKylK4NE=;
 b=MBt7r6PsAtUwuw00Mc64ITWojB3lJxLlAivR8opVNITlHatvhEhP7Nbj8DyLT1oLRbN0WLjlhOtlY8mRmDi0Qus26GKpUkAQvxrKOlUDB2cOKkK5tBNb9juIs6ivGptXLaX+1YbSA5A2/7M1aJbzEv/h+baQcvE0DpqbT1xqezE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Wed, 3 Jun 2020 22:14:34 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 22:14:33 +0000
Date:   Wed, 3 Jun 2020 22:14:28 +0000
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
Subject: Re: [PATCH v8 00/18] Add AMD SEV guest live migration support
Message-ID: <20200603221428.GA6511@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <20200518190708.GA7929@ashkalra_ubuntu_server>
 <CABayD+eJm43rc0Db1aATXut_kpRwKjsOCkZ_Q+NteFnP7d25hg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+eJm43rc0Db1aATXut_kpRwKjsOCkZ_Q+NteFnP7d25hg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR22CA0009.namprd22.prod.outlook.com
 (2603:10b6:3:101::19) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR22CA0009.namprd22.prod.outlook.com (2603:10b6:3:101::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 22:14:32 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15959cfd-d761-4ecd-e6a1-08d8080b7ea8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14347BD1405C616D71E9D8258E880@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2TJlBK091J9G/h9yB8acoBbhAXy3uZ/CnjxJU0smhmtxnujl8E9PnDht+vch+e32UEhti8C+Zsz1qXAbDeqIVXkHsiwbQZm5oRDJmw+HrP58H9UYC60HWCgKsw4FAEcjpbiq1KYIOdCaIHKILmG4JJgt7xofZU5UoRTZaJ79eMzZV9YUhu9Na/UqBS2mD897bDayKTXv6tmeKboF8nN5sXnDPsB2+SRweoDSMjN1sagL5A+7BPYAgqvWxpV2WtRIUpcL6I+q3KQqn4QfSQMVkJqbP/iqDD7x5/8Zli5yw4v4fQV5UEzAvb63CILtuJiH3ttL8to5+uigxV0Wp003/NCsu9RqrQcAjHoDmnbphrNppY+rs9sJa3dPSNJa188Lc0bSb4B1qQQnvM1YTOixA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(26005)(53546011)(956004)(6666004)(4326008)(316002)(33716001)(45080400002)(83380400001)(8676002)(7416002)(66946007)(6496006)(6916009)(54906003)(1076003)(33656002)(55016002)(44832011)(8936002)(5660300002)(66476007)(966005)(9686003)(186003)(52116002)(86362001)(30864003)(478600001)(16526019)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 28UTLQs+iMCZTiWvS3WMhGGBA/v0w1rTDQTHmMaqnCQGmbxbV9FZ1PAPw3qRUEcBtOiZsVGVHAzhgAGidP7nro6IkhuqCbhGfYpsVDGHg9iTtTf16uJ+mkdD4bG6jdZUdTZZ/Z+GPAW73NmMVA4fWRnBqgJhc0XIuMgRuWJkiBdb0b4akhjlrCW8nPFgihxNEPTbKY8J6s5yaGu+QCb/JKTaAWsECq74vFmGePXZ2r8Y2WqKFVErPG9lhYDcbQAGfeLbtMHX3UjtwR2VxokGSchYK5c+145iEIbmedNr0bNT/q1ydSqi7eZwQT2b4X+7+dVoHeeHpbO6uCAEi28DkWzrQ0+zZYUlfsYaCTHe5u/Sqm+kDIuT8xu5PxsZhoDVNo3DzGos3OfHP7IG3nudKb6fyNdtUKDuGBK03Y4jzTt5x/3/uX1wQnHPqtvPyC8BH1I15HVagTdx9KI2o951aYcgEAu6ZhWZEvxMXJYdnYU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15959cfd-d761-4ecd-e6a1-08d8080b7ea8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 22:14:33.8294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTdYv+D1oPtvRTqd0nJQniSGHEdWiHh4Y99nxzluWO1JVoda/8pmMxdffEUW4RyBd3GUy3ylUiVuxCfR2IG1mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Mon, Jun 01, 2020 at 01:02:23PM -0700, Steve Rutherford wrote:
> On Mon, May 18, 2020 at 12:07 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello All,
> >
> > Any other feedback, review or comments on this patch-set ?
> >
> > Thanks,
> > Ashish
> >
> > On Tue, May 05, 2020 at 09:13:49PM +0000, Ashish Kalra wrote:
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > The series add support for AMD SEV guest live migration commands. To protect the
> > > confidentiality of an SEV protected guest memory while in transit we need to
> > > use the SEV commands defined in SEV API spec [1].
> > >
> > > SEV guest VMs have the concept of private and shared memory. Private memory
> > > is encrypted with the guest-specific key, while shared memory may be encrypted
> > > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > > for the private memory only. The patch series introduces a new hypercall.
> > > The guest OS can use this hypercall to notify the page encryption status.
> > > If the page is encrypted with guest specific-key then we use SEV command during
> > > the migration. If page is not encrypted then fallback to default.
> > >
> > > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> > > by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> > > during the migration to know whether the page is encrypted.
> > >
> > > This section descibes how the SEV live migration feature is negotiated
> > > between the host and guest, the host indicates this feature support via
> > > KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> > > sets a UEFI enviroment variable indicating OVMF support for live
> > > migration, the guest kernel also detects the host support for this
> > > feature via cpuid and in case of an EFI boot verifies if OVMF also
> > > supports this feature by getting the UEFI enviroment variable and if it
> > > set then enables live migration feature on host by writing to a custom
> > > MSR, if not booted under EFI, then it simply enables the feature by
> > > again writing to the custom MSR. The host returns error as part of
> > > SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.
> > >
> > > A branch containing these patches is available here:
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Flinux%2Ftree%2Fsev-migration-v8&amp;data=02%7C01%7Cashish.kalra%40amd.com%7Cb7da54c6f7784a548ed208d80666c99b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637266386411473155&amp;sdata=igztZXTZl1i18e5T4DTlNJw07h6z3aBNCAD6%2BE7r9Ik%3D&amp;reserved=0
> > >
> > > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=02%7C01%7Cashish.kalra%40amd.com%7Cb7da54c6f7784a548ed208d80666c99b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637266386411473155&amp;sdata=GBgV6HAd2AXZzjK3hp%2F396tDaHlYtN%2FL3Zfny3GaSoU%3D&amp;reserved=0
> > >
> > > Changes since v7:
> > > - Removed the hypervisor specific hypercall/paravirt callback for
> > >   SEV live migration and moved back to calling kvm_sev_hypercall3
> > >   directly.
> > > - Fix build errors as
> > >   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
> > >   build error when CONFIG_HYPERVISOR_GUEST=y and
> > >   CONFIG_AMD_MEM_ENCRYPT=n.
> > > - Implicitly enabled live migration for incoming VM(s) to handle
> > >   A->B->C->... VM migrations.
> > > - Fixed Documentation as per comments on v6 patches.
> > > - Fixed error return path in sev_send_update_data() as per comments
> > >   on v6 patches.
> > >
> > > Changes since v6:
> > > - Rebasing to mainline and refactoring to the new split SVM
> > >   infrastructre.
> > > - Move to static allocation of the unified Page Encryption bitmap
> > >   instead of the dynamic resizing of the bitmap, the static allocation
> > >   is done implicitly by extending kvm_arch_commit_memory_region() callack
> > >   to add svm specific x86_ops which can read the userspace provided memory
> > >   region/memslots and calculate the amount of guest RAM managed by the KVM
> > >   and grow the bitmap.
> > > - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
> > >   of simply clearing specific bits.
> > > - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
> > >   KVM_SET_PAGE_ENC_BITMAP.
> > > - Extended guest support for enabling Live Migration feature by adding a
> > >   check for UEFI environment variable indicating OVMF support for Live
> > >   Migration feature and additionally checking for KVM capability for the
> > >   same feature. If not booted under EFI, then we simply check for KVM
> > >   capability.
> > > - Add hypervisor specific hypercall for SEV live migration by adding
> > >   a new paravirt callback as part of x86_hyper_runtime.
> > >   (x86 hypervisor specific runtime callbacks)
> > > - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
> > >   and adding check for SEV live migration enabled by guest in the
> > >   KVM_GET_PAGE_ENC_BITMAP ioctl.
> > > - Instead of the complete __bss_decrypted section, only specific variables
> > >   such as hv_clock_boot and wall_clock are marked as decrypted in the
> > >   page encryption bitmap
> > >
> > > Changes since v5:
> > > - Fix build errors as
> > >   Reported-by: kbuild test robot <lkp@intel.com>
> > >
> > > Changes since v4:
> > > - Host support has been added to extend KVM capabilities/feature bits to
> > >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> > >   query for host-side support for SEV live migration and a new custom MSR
> > >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> > >   migration feature.
> > > - Ensure that _bss_decrypted section is marked as decrypted in the
> > >   page encryption bitmap.
> > > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> > >   as per the number of pages being requested by the user. Ensure that
> > >   we only copy bmap->num_pages bytes in the userspace buffer, if
> > >   bmap->num_pages is not byte aligned we read the trailing bits
> > >   from the userspace and copy those bits as is. This fixes guest
> > >   page(s) corruption issues observed after migration completion.
> > > - Add kexec support for SEV Live Migration to reset the host's
> > >   page encryption bitmap related to kernel specific page encryption
> > >   status settings before we load a new kernel by kexec. We cannot
> > >   reset the complete page encryption bitmap here as we need to
> > >   retain the UEFI/OVMF firmware specific settings.
> > >
> > > Changes since v3:
> > > - Rebasing to mainline and testing.
> > > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
> > >   page encryption bitmap on a guest reboot event.
> > > - Adding a more reliable sanity check for GPA range being passed to
> > >   the hypercall to ensure that guest MMIO ranges are also marked
> > >   in the page encryption bitmap.
> > >
> > > Changes since v2:
> > >  - reset the page encryption bitmap on vcpu reboot
> > >
> > > Changes since v1:
> > >  - Add support to share the page encryption between the source and target
> > >    machine.
> > >  - Fix review feedbacks from Tom Lendacky.
> > >  - Add check to limit the session blob length.
> > >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
> > >    the memory slot when querying the bitmap.
> > >
> > > Ashish Kalra (7):
> > >   KVM: SVM: Add support for static allocation of unified Page Encryption
> > >     Bitmap.
> > >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> > >     Custom MSR.
> > >   EFI: Introduce the new AMD Memory Encryption GUID.
> > >   KVM: x86: Add guest support for detecting and enabling SEV Live
> > >     Migration feature.
> > >   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
> > >     encryption bitmap.
> > >   KVM: x86: Add kexec support for SEV Live Migration.
> > >   KVM: SVM: Enable SEV live migration feature implicitly on Incoming
> > >     VM(s).
> > >
> > > Brijesh Singh (11):
> > >   KVM: SVM: Add KVM_SEV SEND_START command
> > >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> > >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> > >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > >   KVM: x86: Add AMD SEV specific Hypercall3
> > >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> > >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> > >   mm: x86: Invoke hypercall when page encryption status is changed
> > >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> > >
> > >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> > >  Documentation/virt/kvm/api.rst                |  71 ++
> > >  Documentation/virt/kvm/cpuid.rst              |   5 +
> > >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> > >  Documentation/virt/kvm/msr.rst                |  10 +
> > >  arch/x86/include/asm/kvm_host.h               |   7 +
> > >  arch/x86/include/asm/kvm_para.h               |  12 +
> > >  arch/x86/include/asm/mem_encrypt.h            |  11 +
> > >  arch/x86/include/asm/paravirt.h               |  10 +
> > >  arch/x86/include/asm/paravirt_types.h         |   2 +
> > >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> > >  arch/x86/kernel/kvm.c                         |  90 +++
> > >  arch/x86/kernel/kvmclock.c                    |  12 +
> > >  arch/x86/kernel/paravirt.c                    |   1 +
> > >  arch/x86/kvm/svm/sev.c                        | 732 +++++++++++++++++-
> > >  arch/x86/kvm/svm/svm.c                        |  21 +
> > >  arch/x86/kvm/svm/svm.h                        |   9 +
> > >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> > >  arch/x86/kvm/x86.c                            |  35 +
> > >  arch/x86/mm/mem_encrypt.c                     |  68 +-
> > >  arch/x86/mm/pat/set_memory.c                  |   7 +
> > >  include/linux/efi.h                           |   1 +
> > >  include/linux/psp-sev.h                       |   8 +-
> > >  include/uapi/linux/kvm.h                      |  52 ++
> > >  include/uapi/linux/kvm_para.h                 |   1 +
> > >  25 files changed, 1297 insertions(+), 9 deletions(-)
> > >
> > > --
> > > 2.17.1
> > >
> 
> Hey all,
> These patches look pretty reasonable at this point. What's the next
> step for getting them merged?

I believe i have incorporated all your main comments and feedback, for
example, no more dynamic resizing of the page encryption bitmap and
static allocation of the same, fixing SET_PAGE_ENC_BITMAP ioctl to set
the whole bitmap and also merging RESET_PAGE_ENC_BITMAP ioctl into it
and other stuff like kexec support, etc.

I know you have some additional comments and i am waiting for some more
feedback and comments from others on the mailing list.

But otherwise i believe these patches are fully ready to be merged at
this point and i am looking forward to the same.

Thanks,
Ashish

> Thanks,
> Steve

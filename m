Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAB176E23
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCCEoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:44:30 -0500
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:6181
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbgCCEoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:44:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDH6T9mHD03JYQ7kvSRdp77ESeJpXhQtqcdu0XGnQfVHGwc7Iboox3bE8KgewdJdwxbzOo8aY6/iaDuhwcogFTrlt3hYSebHETIoeYY7D10eBkiAD/ZRyzqbbMsQ7m1cuJjdi0Mbgbm36/A3iZJiChZ6CirjKc4dRmgQeQm1BGA2zJzssBR7zgt2vrZ46TV2SVzb8z9ltGx0j+HtJQBLtR5Z4xdAo++Hh6LrCixOO7wvw+5DHd1N2T7rJCrHsDJyb9iVz/qhMw6F1Vc1/ywPIfCoJUAexrGBI5w9x2w+38tou98wnkmuYxk1FVOcfFA4+uUo1Tac5iEG4OD4VkTUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE5R2lMFhZ8iXNGQ946y18Dn0fQALIo0xlGuMTTMYgI=;
 b=NwqODKCjtLwPAuL57YxKoa3dncHd5cxCJeJg8jY6ohP9gAlhh7ob8XiR0RK+7Z/B+TwAgvUn3ztALQWiee4mE5x/9toTb2X/Q6L6epqKePdNWJ9XeUUa2FkTgCkezr50dvHMGACw0E89QubAp90ORySOpYgXN+EOW1SOgNwFE+TVyibxyAfXsoF3KWfAwC2XNArYj6LLhLRbZ1TT4WsxGA5FAMB8eobKgivnJFwkp3nYQc63fojB2Fkt69kckSxG8Fy2thqiiS9otaClmYJoPjLx42zyHpcE2zJchUSPGfRjrCkSvJE01YL0/if1TkxKajhd3MrfaMGIo2U42edbfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE5R2lMFhZ8iXNGQ946y18Dn0fQALIo0xlGuMTTMYgI=;
 b=i/XtqTcRGu/OUDWU6GE4wffe1zwQMYs127My5K5IkwIIe8h2BI4Yc2vQH7VjhCN4hGn6e059hW5D3dCRwY7A+dpiLMf6y/FQnAZjwmi+d4dRvlfUwv2Blw0FhhEALJzSzreitrv1vkrMbdIrSxDv6WkGhHx9J0JD2DOYq70gcbs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Tue, 3 Mar
 2020 04:42:47 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::7015:3d60:8f9b:5dad]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::7015:3d60:8f9b:5dad%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 04:42:47 +0000
Date:   Tue, 3 Mar 2020 04:42:41 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
Message-ID: <20200303044241.GA2578@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
 <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
 <20200217194959.GA14833@ashkalra_ubuntu_server>
 <CABayD+dVEMBhva5DOtBph+Ms559q014pbjP9=6ycJ5KpiiJzVg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+dVEMBhva5DOtBph+Ms559q014pbjP9=6ycJ5KpiiJzVg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0501CA0066.namprd05.prod.outlook.com
 (2603:10b6:803:41::43) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0066.namprd05.prod.outlook.com (2603:10b6:803:41::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.5 via Frontend Transport; Tue, 3 Mar 2020 04:42:46 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56ea632c-36c6-4684-c32e-08d7bf2d520f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:|SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2511A3399238A01B73D589658EE40@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(189003)(199004)(66946007)(66476007)(33656002)(66556008)(316002)(54906003)(956004)(1076003)(2906002)(6916009)(5660300002)(7416002)(53546011)(9686003)(8676002)(33716001)(55016002)(4326008)(478600001)(26005)(8936002)(44832011)(86362001)(6666004)(81156014)(6496006)(52116002)(16526019)(81166006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2511;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I1QcbbsGG8k5LgWW649WVpr2llkYbflzCZQdqxgsFBIJ6HfN7xM+ln70lRyc8XGf0h9Ru5jlu8uhrMDeXOfzmgFldhxZfXoTfZlp0d+XooG3GbnEQ9wwqFkE2DHx15Iv8zk3dfkuASTSz1uAT5AUZfb0Dz1PjEncDA5YzzfWHFk4xEaN8Fo2JI2waLJ+7pXdAyvPp+/xPFkz8hdmi+NIWeQ5FL1VX/u0C4w2eX2DaDO5gR8y0QfMKWGFsiQScdyrTqTj/UhcigaYnruPNrVcfbQ5NJWOqlJLpoaKH6vCz8KJrBY/6uo3+G2fGkw7+Vf3GNgVKhoyvkId6FUwL7KCBrVOEXKV4VJzYb4cUiXx3qHuc+3TYGAfLRs38RnCOJGd9z7m0XWhpDtC0qdCohOiptezGLBFJy3wcYfITI+Du4w/gqMCJ8ePUM5XUDAwv+Mh
X-MS-Exchange-AntiSpam-MessageData: v591p+YEWeWOppKyqkjZQLlu96bFThZ7wjdh1/ET4zKLFAEwZ9xjm6IJEOAe56G04t0PAwRr0wRB9yeIXfpE28sPUvtWUDRL7mwzbtFtzzwrW6cRFzI9e0R92qj3ynVtKXxfqWNjm84LP+SdYWOKJg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ea632c-36c6-4684-c32e-08d7bf2d520f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 04:42:47.5947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgXLosfuvzbSb8H6kZhljebazb06Y224ePoQzL0+XmQF2mWCPoHhXdCDbniu03/gV/jA/d31IBg72UTmGGqTHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 05:05:29PM -0800, Steve Rutherford wrote:
> I think this patch series might be incompatible with kexec, but I'm
> not sure since I'm really not familiar with that subsystem. It seems
> like you need to explicitly mark all shared pages as encrypted again
> before rebooting into the new kernel. If you don't do this, and the
> newly booted kernel believes RAM is encrypted and has always been, you
> won't flip formerly decrypted shared device pages back to encrypted.
> For example, if the swiotlb moves, you need to tell KVM that the old
> swiotlb pages are now encrypted.
> 
> I could imagine this being handled implicitly by the way kexec handles
> freeing memory, but I would find this surprising. I only see
> enlightenment for handling SME's interaction with the initial image in
> the kexec implementation.
> 

I believe that there already is enlightenment for SEV handling in kexec
implementation, but you are right as there is no support currently for 
resetting the page encryption bitmap in the SEV handling code in kexec,
similar to what we do for a guest reboot event.

This support probably needs to be added as part of the
arch_kexec_{post,pre}_{alloc,free}_pages() interface.

Thanks,
Ashish

> On Mon, Feb 17, 2020 at 11:50 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Fri, Feb 14, 2020 at 10:58:46AM -0800, Andy Lutomirski wrote:
> > > On Thu, Feb 13, 2020 at 3:09 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > >
> > > > On Wed, Feb 12, 2020 at 09:43:41PM -0800, Andy Lutomirski wrote:
> > > > > On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > > >
> > > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > > >
> > > > > > This patchset adds support for SEV Live Migration on KVM/QEMU.
> > > > >
> > > > > I skimmed this all and I don't see any description of how this all works.
> > > > >
> > > > > Does any of this address the mess in svm_register_enc_region()?  Right
> > > > > now, when QEMU (or a QEMU alternative) wants to allocate some memory
> > > > > to be used for guest encrypted pages, it mmap()s some memory and the
> > > > > kernel does get_user_pages_fast() on it.  The pages are kept pinned
> > > > > for the lifetime of the mapping.  This is not at all okay.  Let's see:
> > > > >
> > > > >  - The memory is pinned and it doesn't play well with the Linux memory
> > > > > management code.  You just wrote a big patch set to migrate the pages
> > > > > to a whole different machines, but we apparently can't even migrate
> > > > > them to a different NUMA node or even just a different address.  And
> > > > > good luck swapping it out.
> > > > >
> > > > >  - The memory is still mapped in the QEMU process, and that mapping is
> > > > > incoherent with actual guest access to the memory.  It's nice that KVM
> > > > > clflushes it so that, in principle, everything might actually work,
> > > > > but this is gross.  We should not be exposing incoherent mappings to
> > > > > userspace.
> > > > >
> > > > > Perhaps all this fancy infrastructure you're writing for migration and
> > > > > all this new API surface could also teach the kernel how to migrate
> > > > > pages from a guest *to the same guest* so we don't need to pin pages
> > > > > forever.  And perhaps you could put some thought into how to improve
> > > > > the API so that it doesn't involve nonsensical incoherent mappings.o
> > > >
> > > > As a different key is used to encrypt memory in each VM, the hypervisor
> > > > can't simply copy the the ciphertext from one VM to another to migrate
> > > > the VM.  Therefore, the AMD SEV Key Management API provides a new sets
> > > > of function which the hypervisor can use to package a guest page for
> > > > migration, while maintaining the confidentiality provided by AMD SEV.
> > > >
> > > > There is a new page encryption bitmap created in the kernel which
> > > > keeps tracks of encrypted/decrypted state of guest's pages and this
> > > > bitmap is updated by a new hypercall interface provided to the guest
> > > > kernel and firmware.
> > > >
> > > > KVM_GET_PAGE_ENC_BITMAP ioctl can be used to get the guest page encryption
> > > > bitmap. The bitmap can be used to check if the given guest page is
> > > > private or shared.
> > > >
> > > > During the migration flow, the SEND_START is called on the source hypervisor
> > > > to create an outgoing encryption context. The SEV guest policy dictates whether
> > > > the certificate passed through the migrate-set-parameters command will be
> > > > validated. SEND_UPDATE_DATA is called to encrypt the guest private pages.
> > > > After migration is completed, SEND_FINISH is called to destroy the encryption
> > > > context and make the VM non-runnable to protect it against cloning.
> > > >
> > > > On the target machine, RECEIVE_START is called first to create an
> > > > incoming encryption context. The RECEIVE_UPDATE_DATA is called to copy
> > > > the received encrypted page into guest memory. After migration has
> > > > completed, RECEIVE_FINISH is called to make the VM runnable.
> > > >
> > >
> > > Thanks!  This belongs somewhere in the patch set.
> > >
> > > You still haven't answered my questions about the existing coherency
> > > issues and whether the same infrastructure can be used to migrate
> > > guest pages within the same machine.
> >
> > Page Migration and Live Migration are separate features and one of my
> > colleagues is currently working on making page migration possible and removing
> > SEV Guest pinning requirements.
> > >
> > > Also, you're making guest-side and host-side changes.  What ensures
> > > that you don't try to migrate a guest that doesn't support the
> > > hypercall for encryption state tracking?
> >
> > This is a good question and it is still an open-ended question. There
> > are two possibilities here: guest does not have any unencrypted pages
> > (for e.g booting 32-bit) and so it does not make any hypercalls, and
> > the other possibility is that the guest does not have support for
> > the newer hypercall.
> >
> > In the first case, all the guest pages are then assumed to be
> > encrypted and live migration happens as such.
> >
> > For the second case, we have been discussing this internally,
> > and one option is to extend the KVM capabilites/feature bits to check for this ?
> >
> > Thanks,
> > Ashish

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C777915F642
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387720AbgBNS7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgBNS7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 13:59:02 -0500
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A36524684
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581706741;
        bh=sDuNfKWoPpSrN5oPOUrwlTFcBuhLYXcdRqnE84ZHMxI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dBvKkrbN2zjKd1UtcXTrhOUf9txYmtN0gkqLua8TatxLDTKDhnFRk10uGFH4s/WXt
         IBc0zPL4OqPZ/9WlXc2HcUXR7nlTjCWoNDOEEiYDf4x8oeRqZ4V5akhtz7mhTCGD3F
         nYSXryAUaoB6HbO7V4V529hFJYgfz3F3t1+QvK28=
Received: by mail-wr1-f44.google.com with SMTP id m16so12086840wrx.11
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 10:59:01 -0800 (PST)
X-Gm-Message-State: APjAAAV7KeoRA2GTnGRML7qPQDSnHzTsC2xkhgFQWVOHiOC13aGXu3eu
        cEVBTMFr7b6aHq34wxV0ez6blzxGFnKCeeNd5nFsTw==
X-Google-Smtp-Source: APXvYqwjzgYrmhHLu5TEIGRVZ7CWlT5Ssetb8QK0esyZiXxWwEmJYOpZXgV19RAPW2gMZRaV7w98pJpEKU/JOguli74=
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr5361655wrt.70.1581706739323;
 Fri, 14 Feb 2020 10:58:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
In-Reply-To: <20200213230916.GB8784@ashkalra_ubuntu_server>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 14 Feb 2020 10:58:46 -0800
X-Gmail-Original-Message-ID: <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
Message-ID: <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <ashish.kalra@amd.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 3:09 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Wed, Feb 12, 2020 at 09:43:41PM -0800, Andy Lutomirski wrote:
> > On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > This patchset adds support for SEV Live Migration on KVM/QEMU.
> >
> > I skimmed this all and I don't see any description of how this all works.
> >
> > Does any of this address the mess in svm_register_enc_region()?  Right
> > now, when QEMU (or a QEMU alternative) wants to allocate some memory
> > to be used for guest encrypted pages, it mmap()s some memory and the
> > kernel does get_user_pages_fast() on it.  The pages are kept pinned
> > for the lifetime of the mapping.  This is not at all okay.  Let's see:
> >
> >  - The memory is pinned and it doesn't play well with the Linux memory
> > management code.  You just wrote a big patch set to migrate the pages
> > to a whole different machines, but we apparently can't even migrate
> > them to a different NUMA node or even just a different address.  And
> > good luck swapping it out.
> >
> >  - The memory is still mapped in the QEMU process, and that mapping is
> > incoherent with actual guest access to the memory.  It's nice that KVM
> > clflushes it so that, in principle, everything might actually work,
> > but this is gross.  We should not be exposing incoherent mappings to
> > userspace.
> >
> > Perhaps all this fancy infrastructure you're writing for migration and
> > all this new API surface could also teach the kernel how to migrate
> > pages from a guest *to the same guest* so we don't need to pin pages
> > forever.  And perhaps you could put some thought into how to improve
> > the API so that it doesn't involve nonsensical incoherent mappings.o
>
> As a different key is used to encrypt memory in each VM, the hypervisor
> can't simply copy the the ciphertext from one VM to another to migrate
> the VM.  Therefore, the AMD SEV Key Management API provides a new sets
> of function which the hypervisor can use to package a guest page for
> migration, while maintaining the confidentiality provided by AMD SEV.
>
> There is a new page encryption bitmap created in the kernel which
> keeps tracks of encrypted/decrypted state of guest's pages and this
> bitmap is updated by a new hypercall interface provided to the guest
> kernel and firmware.
>
> KVM_GET_PAGE_ENC_BITMAP ioctl can be used to get the guest page encryption
> bitmap. The bitmap can be used to check if the given guest page is
> private or shared.
>
> During the migration flow, the SEND_START is called on the source hypervisor
> to create an outgoing encryption context. The SEV guest policy dictates whether
> the certificate passed through the migrate-set-parameters command will be
> validated. SEND_UPDATE_DATA is called to encrypt the guest private pages.
> After migration is completed, SEND_FINISH is called to destroy the encryption
> context and make the VM non-runnable to protect it against cloning.
>
> On the target machine, RECEIVE_START is called first to create an
> incoming encryption context. The RECEIVE_UPDATE_DATA is called to copy
> the received encrypted page into guest memory. After migration has
> completed, RECEIVE_FINISH is called to make the VM runnable.
>

Thanks!  This belongs somewhere in the patch set.

You still haven't answered my questions about the existing coherency
issues and whether the same infrastructure can be used to migrate
guest pages within the same machine.

Also, you're making guest-side and host-side changes.  What ensures
that you don't try to migrate a guest that doesn't support the
hypercall for encryption state tracking?

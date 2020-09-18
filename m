Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BBF26F9C6
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRKBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 06:01:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgIRKBD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 06:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600423261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r7yUYpuITHC5Su1wU3hYRlt79FNThRuFOtvq9DQtmqk=;
        b=VAqSjcaYtpeikbl3DtCDIbloyluue9pqXwA54czO5mHUujOYDBQ6Nr/goh29eeCKYidkLI
        MR0zTERLiGYxH3s4Xbn0TwyX9ig2nv28flDW4IHyKaobhTRoSu+DhFOL46sPtebBEL+/ZQ
        kmr5DM3V/2taJjUYoWazQVGKp0r0Joc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-O0rHDWwxO8mSoj-FoASJmg-1; Fri, 18 Sep 2020 06:00:57 -0400
X-MC-Unique: O0rHDWwxO8mSoj-FoASJmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E760100855A;
        Fri, 18 Sep 2020 10:00:56 +0000 (UTC)
Received: from work-vm (ovpn-114-196.ams2.redhat.com [10.36.114.196])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA1D378802;
        Fri, 18 Sep 2020 10:00:50 +0000 (UTC)
Date:   Fri, 18 Sep 2020 11:00:48 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 0/5] Qemu SEV-ES guest support
Message-ID: <20200918100048.GF2816@work-vm>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <20200917172802.GS2793@work-vm>
 <de0e9c27-8954-3a77-21db-cad84f334277@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de0e9c27-8954-3a77-21db-cad84f334277@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> On 9/17/20 12:28 PM, Dr. David Alan Gilbert wrote:
> > * Tom Lendacky (thomas.lendacky@amd.com) wrote:
> > > From: Tom Lendacky <thomas.lendacky@amd.com>
> > > 
> > > This patch series provides support for launching an SEV-ES guest.
> > > 
> > > Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
> > > SEV support to protect the guest register state from the hypervisor. See
> > > "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
> > > section "15.35 Encrypted State (SEV-ES)" [1].
> > > 
> > > In order to allow a hypervisor to perform functions on behalf of a guest,
> > > there is architectural support for notifying a guest's operating system
> > > when certain types of VMEXITs are about to occur. This allows the guest to
> > > selectively share information with the hypervisor to satisfy the requested
> > > function. The notification is performed using a new exception, the VMM
> > > Communication exception (#VC). The information is shared through the
> > > Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
> > > The GHCB format and the protocol for using it is documented in "SEV-ES
> > > Guest-Hypervisor Communication Block Standardization" [2].
> > > 
> > > The main areas of the Qemu code that are updated to support SEV-ES are
> > > around the SEV guest launch process and AP booting in order to support
> > > booting multiple vCPUs.
> > > 
> > > There are no new command line switches required. Instead, the desire for
> > > SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
> > > object indicates that SEV-ES is required.
> > > 
> > > The SEV launch process is updated in two ways. The first is that a the
> > > KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
> > > standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
> > > measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
> > > each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
> > > invoked, no direct changes to the guest register state can be made.
> > > 
> > > AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
> > > is typically used to boot the APs. However, the hypervisor is not allowed
> > > to update the guest registers. For the APs, the reset vector must be known
> > > in advance. An OVMF method to provide a known reset vector address exists
> > > by providing an SEV information block, identified by UUID, near the end of
> > > the firmware [3]. OVMF will program the jump to the actual reset vector in
> > > this area of memory. Since the memory location is known in advance, an AP
> > > can be created with the known reset vector address as its starting CS:IP.
> > > The GHCB document [2] talks about how SMP booting under SEV-ES is
> > > performed. SEV-ES also requires the use of the in-kernel irqchip support
> > > in order to minimize the changes required to Qemu to support AP booting.
> > 
> > Some random thoughts:
> >    a) Is there something that explicitly disallows SMM?
> 
> There isn't currently. Is there a way to know early on that SMM is enabled?
> Could I just call x86_machine_is_smm_enabled() to check that?
> 
> >    b) I think all the interfaces you're using are already defined in
> > Linux header files - even if the code to implement them isn't actually
> > upstream in the kernel yet (the launch_update in particular) - we
> > normally wait for the kernel interface to be accepted before taking the
> > QEMU patches, but if the constants are in the headers already I'm not
> > sure what the rule is.
> 
> Correct, everything was already present from a Linux header perspective.
> 
> >    c) What happens if QEMU reads the register values from the state if
> > the guest is paused - does it just see junk?  I'm just wondering if you
> > need to add checks in places it might try to.
> 
> I thought about what to do about calls to read the registers once the guest
> state has become encrypted. I think it would take a lot of changes to make
> Qemu "protected state aware" for what I see as little gain. Qemu is likely
> to see a lot of zeroes or actual register values from the GHCB protocol for
> previous VMGEXITs that took place.

Yep, that's fair enough - I was curious if we'll hit anything
accidentally still reading it.

How does SEV-ES interact with the 'NODBG' flag of the guest policy - if
that's 0, and 'debugging of the guest' is allowed, what can you actually
do?

Dave

> Thanks,
> Tom
> 
> > 
> > Dave
> > 
> > > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292398926&amp;sdata=B2naGIEXuhD7a%2Fi4NDsRzeHwvDvNJ%2FP7nf5HmAzk9CU%3D&amp;reserved=0
> > > [2] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F56421.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292398926&amp;sdata=0HrHZxdTEK%2FWM1KxxasMAghpzTNGvuKKSlg6nBgPjJY%3D&amp;reserved=0
> > > [3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
> > >      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Ftianocore%2Fedk2%2Fcommit%2F30937f2f98c42496f2f143fe8374ae7f7e684847&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292408916&amp;sdata=ISAjIahZH4izDHnXgdWDX0GK61kwgtTw%2BEE%2BS8FBls0%3D&amp;reserved=0
> > > 
> > > ---
> > > 
> > > These patches are based on commit:
> > > d0ed6a69d3 ("Update version for v5.1.0 release")
> > > 
> > > (I tried basing on the latest Qemu commit, but I was having build issues
> > > that level)
> > > 
> > > A version of the tree can be found at:
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Fqemu%2Ftree%2Fsev-es-v11&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292408916&amp;sdata=pWd8HAZkAILIMRb1i5TNz9XoHyrhCgRu%2Bq%2BXN2NJ4ag%3D&amp;reserved=0
> > > 
> > > Changes since v2:
> > > - Add in-kernel irqchip requirement for SEV-ES guests
> > > 
> > > Changes since v1:
> > > - Fixed checkpatch.pl errors/warnings
> > > 
> > > Tom Lendacky (5):
> > >    sev/i386: Add initial support for SEV-ES
> > >    sev/i386: Require in-kernel irqchip support for SEV-ES guests
> > >    sev/i386: Allow AP booting under SEV-ES
> > >    sev/i386: Don't allow a system reset under an SEV-ES guest
> > >    sev/i386: Enable an SEV-ES guest based on SEV policy
> > > 
> > >   accel/kvm/kvm-all.c       |  73 ++++++++++++++++++++++++++
> > >   accel/stubs/kvm-stub.c    |   5 ++
> > >   hw/i386/pc_sysfw.c        |  10 +++-
> > >   include/sysemu/cpus.h     |   2 +
> > >   include/sysemu/hw_accel.h |   5 ++
> > >   include/sysemu/kvm.h      |  18 +++++++
> > >   include/sysemu/sev.h      |   3 ++
> > >   softmmu/cpus.c            |   5 ++
> > >   softmmu/vl.c              |   5 +-
> > >   target/i386/cpu.c         |   1 +
> > >   target/i386/kvm.c         |   2 +
> > >   target/i386/sev-stub.c    |   5 ++
> > >   target/i386/sev.c         | 105 +++++++++++++++++++++++++++++++++++++-
> > >   target/i386/sev_i386.h    |   1 +
> > >   14 files changed, 236 insertions(+), 4 deletions(-)
> > > 
> > > -- 
> > > 2.28.0
> > > 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


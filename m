Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E711D782F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 14:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgERMMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 08:12:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726557AbgERMMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 08:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589803935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/EWbjFmwbmvg4uq23X0Lczc3hPOEd517yRWe/yPnXY=;
        b=fb8jC7BEgi3vH7lNzEYY6p4nttT0HIPHJiq1fhfJ6BrqN9UUbSVIUcB1uA6aXHTaUh0N9M
        A3V+LG60f43UTpWhC0uuhsmlCuBob0xPUqAqeGxCrUK31pF/lGkYt9LqLbfexKDzuAeFqy
        IqPe3UEVGssdjBQ+WnjPNau7d7D5ttk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-JFMSKqioPeSueabZHReEjA-1; Mon, 18 May 2020 08:12:14 -0400
X-MC-Unique: JFMSKqioPeSueabZHReEjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68107BFC0;
        Mon, 18 May 2020 12:12:11 +0000 (UTC)
Received: from starship (unknown [10.35.206.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E5A6100239B;
        Mon, 18 May 2020 12:12:05 +0000 (UTC)
Message-ID: <2b5bbfd9b6e4a82262de75be8a1c93a02be127b3.camel@redhat.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Anastassios Nanos <ananos@nubificus.co.uk>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date:   Mon, 18 May 2020 15:12:04 +0300
In-Reply-To: <f077234c-ea74-faaf-422a-fd5d2c1c6923@redhat.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
         <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
         <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
         <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
         <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
         <f077234c-ea74-faaf-422a-fd5d2c1c6923@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-05-18 at 13:51 +0200, Paolo Bonzini wrote:
> On 18/05/20 13:34, Maxim Levitsky wrote:
> > > In high-performance configurations, most of the time virtio devices are
> > > processed in another thread that polls on the virtio rings.  In this
> > > setup, the rings are configured to not cause a vmexit at all; this has
> > > much smaller latency than even a lightweight (kernel-only) vmexit,
> > > basically corresponding to writing an L1 cache line back to L2.
> > 
> > This can be used to run kernel drivers inside a very thin VM IMHO to break up the stigma,
> > that kernel driver is always a bad thing to and should be by all means replaced by a userspace driver,
> > something I see a lot lately, and what was the ground for rejection of my nvme-mdev proposal.
> 
> It's a tought design decision between speeding up a kernel driver with
> something like eBPF or wanting to move everything to userspace.
> 
> Networking has moved more towards the first because there are many more
> opportunities for NIC-based acceleration, while storage has moved
> towards the latter with things such as io_uring.  That said, I don't see
> why in-kernel NVMeoF drivers would be acceptable for anything but Fibre
> Channel (and that's only because FC HBAs try hard to hide most of the
> SAN layers).
> 
> Paolo
> 

Note that these days storage is as fast or even faster that many types of networking,
and that there also are opportunities for acceleration (like p2p pci dma) that also are more
natural to do in the kernel.

io-uring is actually not about moving everything to userspace IMHO, but rather the opposite,
it allows the userspace to access the kernel block subsystem in very efficent way which
is the right thing to do.

Sadly it doesn't help much with fast NVME virtualization because the bottleneck moves
to the communication with the guest.

I guess this is getting offtopic, so I won't continue this discussion here,
I just wanted to voice my opinion on this manner.

Another thing that comes to my mind (not that it has to be done in the kernel),
is that AMD's AVIC allows peer to peer interrupts between guests, and that
can in theory allow to run a 'driver' in a special guest and let it communicate
with a normal guest using interrupts bi-directionally which can finally solve the
need to waste a core in a busy wait loop.

The only catch is that the 'special guest' has to run 100% of the time,
thus it can't still share a core with other kernel/usespace tasks, but at least it can be in sleeping
state most of the time, and it can itsel run various tasks that serve various needs.

In other words, I don't have any objection to allowing part of the host kernel to run in VMX/SVM
guest mode. This can be a very intersting thing.

Best regards,
	Maxim Levitsky


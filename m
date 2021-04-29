Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086DE36F0B1
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 22:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhD2TsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 15:48:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234113AbhD2TsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 15:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619725643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+M4to1dcOs700isxx4oGCjHBz32mVchtGZDofF69pWA=;
        b=GCaohZ0xibePeliaUTQfHi46ufhAlbmYkz87Ln3FhwAtMPy9natGkRhHmHBNwjGRxIaByy
        71KdGSYVMDzu6NO9Af9kKmqu5XqFEocZsrqCGA/qDZwa0FOoRzAuIowSVdYn9GJmUKaJo6
        IL3XWW8fvtF3XtbcAprHsjjR4Eyv4bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-KamNEiW9NsGsTkhGWHaQ0w-1; Thu, 29 Apr 2021 15:47:02 -0400
X-MC-Unique: KamNEiW9NsGsTkhGWHaQ0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E7048189C6;
        Thu, 29 Apr 2021 19:47:00 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2AFF69513;
        Thu, 29 Apr 2021 19:46:59 +0000 (UTC)
Date:   Thu, 29 Apr 2021 13:46:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shanker R Donthineni <sdonthineni@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210429134659.321a5c3c@redhat.com>
In-Reply-To: <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
        <20210429122840.4f98f78e@redhat.com>
        <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Apr 2021 14:14:50 -0500
Shanker R Donthineni <sdonthineni@nvidia.com> wrote:

> Thanks Alex for quick reply.
>=20
> On 4/29/21 1:28 PM, Alex Williamson wrote:
> > If this were a valid thing to do, it should be done for all
> > architectures, not just ARM64.  However, a prefetchable range only
> > necessarily allows merged writes, which seems like a subset of the
> > semantics implied by a WC attribute, therefore this doesn't seem
> > universally valid.
> >
> > I'm also a bit confused by your problem statement that indicates that
> > without WC you're seeing unaligned accesses, does this suggest that
> > your driver is actually relying on WC semantics to perform merging to
> > achieve alignment?  That seems rather like a driver bug, I'd expect UC
> > vs WC is largely a difference in performance, not a means to enforce
> > proper driver access patterns.  Per the PCI spec, the bridge itself can
> > merge writes to prefetchable areas, presumably regardless of this
> > processor attribute, perhaps that's the feature your driver is relying
> > on that might be missing here.  Thanks, =20
> The driver uses WC semantics, It's mapping PCI prefetchable BARS
> using ioremap_wc().=C2=A0 We don't see any issue for x86 architecture,
> driver works fine in the host and guest kernel. The same driver works
> on ARM64 kernel but crashes inside VM. GPU driver uses the
> architecture agnostic function ioremap_wc() like other drivers. This
> limitation applies to all the drivers if they use WC memory and
> follow ARM64 NORMAL-NC access rules.

x86 KVM works for other reasons, KVM will trust the vCPU attributes for
the memory range rather than relying only on the host mapping.

> On ARM64, ioremap_wc() is mapped to non-cacheable memory-type, no
> side effects on reads and unaligned accesses are allowed as per
> ARM-ARM architecture. The driver behavior is different in host vs
> guest on ARM64.=C2=A0

Per the PCI spec, prefetchable memory only necessarily allows the bridge
to merge writes.  I believe this is only a subset of what WC mappings
allow, therefore I expect this is incompatible with drivers that do not
use WC mappings.
=20
> ARM CPU generating alignment faults before transaction reaches the
> PCI-RC/switch/end-point-device.

If an alignment fault is fixed by configuring a WC mapping, doesn't
that suggest that the driver performed an unaligned access itself and
is relying on write combining by the processor to correct that error?
That's wrong.  Fix the driver or please offer another explanation of
how the WC mapping resolves this.  I suspect you could enable tracing
in QEMU, disable MMIO mmaps on the vfio-pci device and find the invalid
access.

> We've two concerns here:
> =C2=A0=C2=A0 - Performance impacts for pass-through devices.
> =C2=A0=C2=A0 - The definition of ioremap_wc() function doesn't match the =
host
> kernel on ARM64

Performance I can understand, but I think you're also using it to mask
a driver bug which should be resolved first.  Thanks,

Alex


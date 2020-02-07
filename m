Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A97A155AF3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgBGPrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:47:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726867AbgBGPrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 10:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581090422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HsGfQdrJfMM61646b/7UeyauAxITJvOdYxWOBu30cVs=;
        b=b22Rz1nt9t/06/8WK90rc/sNfyTf5cws8zkngOHNrZrUvGiEkJgZJrK72Gy/Y2ElYISDo5
        b4JAZr1NF/Wt8k1wyLuwi39NgwkRfjDEZu1yN1IR7J7ycjEWuuge6QnUqXxo6t9vtO964p
        GWDRjmcse7Si5c9RDp07RgPFIrvpSUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-1-6dHYJcMOSaN6AIrqWfcw-1; Fri, 07 Feb 2020 10:47:00 -0500
X-MC-Unique: 1-6dHYJcMOSaN6AIrqWfcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29DE018A6EC0
        for <kvm@vger.kernel.org>; Fri,  7 Feb 2020 15:47:00 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D23E8EA1C;
        Fri,  7 Feb 2020 15:46:56 +0000 (UTC)
Date:   Fri, 7 Feb 2020 16:46:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kashyap Chamarthy <kchamart@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH] docs/virt/kvm: Document running nested guests
Message-ID: <20200207164653.28849ef0.cohuck@redhat.com>
In-Reply-To: <20200207153002.16081-1-kchamart@redhat.com>
References: <20200207153002.16081-1-kchamart@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 16:30:02 +0100
Kashyap Chamarthy <kchamart@redhat.com> wrote:

> This is a rewrite of the Wiki page:
>=20
>     https://www.linux-kvm.org/page/Nested_Guests

Thanks for doing that!

>=20
> Signed-off-by: Kashyap Chamarthy <kchamart@redhat.com>
> ---
> Question: is the live migration of L1-with-L2-running-in-it fixed for
> *all* architectures, including s390x?
> ---
>  .../virt/kvm/running-nested-guests.rst        | 171 ++++++++++++++++++
>  1 file changed, 171 insertions(+)
>  create mode 100644 Documentation/virt/kvm/running-nested-guests.rst

FWIW, there's currently a series converting this subdirectory to rst
on-list.

>=20
> diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documenta=
tion/virt/kvm/running-nested-guests.rst
> new file mode 100644
> index 0000000000000000000000000000000000000000..e94ab665c71a36b7718aebae9=
02af16b792f6dd3
> --- /dev/null
> +++ b/Documentation/virt/kvm/running-nested-guests.rst
> @@ -0,0 +1,171 @@
> +Running nested guests with KVM
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

I think the common style is to also have a "=3D=3D=3D..." line on top.

> +
> +A nested guest is a KVM guest that in turn runs on a KVM guest::
> +
> +              .----------------.  .----------------.
> +              |                |  |                |
> +              |      L2        |  |      L2        |
> +              | (Nested Guest) |  | (Nested Guest) |
> +              |                |  |                |
> +              |----------------'--'----------------|
> +              |                                    |
> +              |       L1 (Guest Hypervisor)        |
> +              |          KVM (/dev/kvm)            |
> +              |                                    |
> +      .------------------------------------------------------.
> +      |                 L0 (Host Hypervisor)                 |
> +      |                    KVM (/dev/kvm)                    |
> +      |------------------------------------------------------|
> +      |                  x86 Hardware (VMX)                  |

Just 'Hardware'? I don't think you want to make this x86-specific?

> +      '------------------------------------------------------'
> +
> +
> +Terminology:
> +
> +  - L0 =E2=80=93 level-0; the bare metal host, running KVM
> +
> +  - L1 =E2=80=93 level-1 guest; a VM running on L0; also called the "gue=
st
> +    hypervisor", as it itself is capable of running KVM.
> +
> +  - L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "nested =
guest"
> +
> +
> +Use Cases
> +---------
> +
> +An additional layer of virtualization sometimes can .  You

Something seems to be missing here?

> +might have access to a large virtual machine in a cloud environment that
> +you want to compartmentalize into multiple workloads.  You might be
> +running a lab environment in a training session.
> +
> +There are several scenarios where nested KVM can be Useful:

s/Useful/useful/

> +
> +  - As a developer, you want to test your software on different OSes.
> +    Instead of renting multiple VMs from a Cloud Provider, using nested
> +    KVM lets you rent a large enough "guest hypervisor" (level-1 guest).
> +    This in turn allows you to create multiple nested guests (level-2
> +    guests), running different OSes, on which you can develop and test
> +    your software.
> +
> +  - Live migration of "guest hypervisors" and their nested guests, for
> +    load balancing, disaster recovery, etc.
> +
> +  - Using VMs for isolation (as in Kata Containers, and before it Clear
> +    Containers https://lwn.net/Articles/644675/) if you're running on a
> +    cloud provider that is already using virtual machines
> +
> +
> +Procedure to enable nesting on the bare metal host
> +--------------------------------------------------
> +
> +The KVM kernel modules do not enable nesting by default (though your
> +distribution may override this default).  To enable nesting, set the
> +``nested`` module parameter to ``Y`` or ``1``. You may set this
> +parameter persistently in a file in ``/etc/modprobe.d`` in the L0 host:
> +
> +1. On the bare metal host (L0), list the kernel modules, and ensure that
> +   the KVM modules::
> +
> +    $ lsmod | grep -i kvm
> +    kvm_intel             133627  0
> +    kvm                   435079  1 kvm_intel
> +
> +2. Show information for ``kvm_intel`` module::
> +
> +    $ modinfo kvm_intel | grep -i nested
> +    parm:           nested:boolkvm                   435079  1 kvm_intel
> +
> +3. To make nested KVM configuration persistent across reboots, place the
> +   below entry in a config attribute::
> +
> +    $ cat /etc/modprobe.d/kvm_intel.conf
> +    options kvm-intel nested=3Dy
> +
> +4. Unload and re-load the KVM Intel module::
> +
> +    $ sudo rmmod kvm-intel
> +    $ sudo modprobe kvm-intel
> +
> +5. Verify if the ``nested`` parameter for KVM is enabled::
> +
> +    $ cat /sys/module/kvm_intel/parameters/nested
> +    Y
> +
> +For AMD hosts, the process is the same as above, except that the module
> +name is ``kvm-amd``.

This looks x86-specific. Don't know about others, but s390 has one
module, also a 'nested' parameter, which is mutually exclusive with a
'hpage' parameter.

> +
> +Once your bare metal host (L0) is configured for nesting, you should be
> +able to start an L1 guest with ``qemu-kvm -cpu host`` (which passes
> +through the host CPU's capabilities as-is to the guest); or for better
> +live migration compatibility, use a named CPU model supported by QEMU,
> +e.g.: ``-cpu Haswell-noTSX-IBRS,vmx=3Don`` and the guest will subsequent=
ly
> +be capable of running an L2 guest with accelerated KVM.

That's probably more something that should go into a section that gives
an example how to start a nested guest with QEMU? Cpu models also look
different between architectures.

> +
> +Additional nested-related kernel parameters
> +-------------------------------------------
> +
> +If your hardware is sufficiently advanced (Intel Haswell processor or
> +above which has newer hardware virt extensions), you might want to
> +enable additional features: "Shadow VMCS (Virtual Machine Control
> +Structure)", APIC Virtualization on your bare metal host (L0).
> +Parameters for Intel hosts::
> +
> +    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
> +    Y
> +
> +    $ cat /sys/module/kvm_intel/parameters/enable_apicv
> +    N
> +
> +    $ cat /sys/module/kvm_intel/parameters/ept
> +    Y
> +
> +Again, to persist the above values across reboot, append them to
> +``/etc/modprobe.d/kvm_intel.conf``::
> +
> +    options kvm-intel nested=3Dy
> +    options kvm-intel enable_shadow_vmcs=3Dy
> +    options kvm-intel enable_apivc=3Dy
> +    options kvm-intel ept=3Dy

x86 specific -- maybe reorganize this document by starting with a
general setup section and then giving some architecture-specific
information?

> +
> +
> +Live migration with nested KVM
> +------------------------------
> +
> +The below live migration scenarios should work as of Linux kernel 5.3
> +and QEMU 4.2.0.  In all the below cases, L1 exposes ``/dev/kvm`` in
> +it, i.e. the L2 guest is a "KVM-accelerated guest", not a "plain
> +emulated guest" (as done by QEMU's TCG).
> +
> +- Migrating a nested guest (L2) to another L1 guest on the *same* bare
> +  metal host.
> +
> +- Migrating a nested guest (L2) to another L1 guest on a *different*
> +  bare metal host.
> +
> +- Migrating an L1 guest, with an *offline* nested guest in it, to
> +  another bare metal host.
> +
> +- Migrating an L1 guest, with a  *live* nested guest in it, to another
> +  bare metal host.
> +
> +
> +Limitations on Linux kernel versions older than 5.3
> +---------------------------------------------------
> +
> +On Linux kernel versions older than 5.3, once an L1 guest has started an
> +L2 guest, the L1 guest would no longer capable of being migrated, saved,
> +or loaded (refer to QEMU documentation on "save"/"load") until the L2
> +guest shuts down.  [FIXME: Is this limitation fixed for *all*
> +architectures, including s390x?]

I don't think we ever had that limitation on s390x, since the whole way
control blocks etc. are handled is different there. David (H), do you
remember?

> +
> +Attempting to migrate or save & load an L1 guest while an L2 guest is
> +running will result in undefined behavior.  You might see a ``kernel
> +BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> +Such a migrated or loaded L1 guest can no longer be considered stable or
> +secure, and must be restarted.
> +
> +Migrating an L1 guest merely configured to support nesting, while not
> +actually running L2 guests, is expected to function normally.
> +Live-migrating an L2 guest from one L1 guest to another is also expected
> +to succeed.


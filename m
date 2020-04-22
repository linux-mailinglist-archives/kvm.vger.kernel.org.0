Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC71B3A9E
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDVI4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 04:56:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725786AbgDVI4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 04:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587545788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9HgKg6CG3H2vb1nMCNFXUuJLGQOJ24KS/7vP7eM2t8o=;
        b=cy6xRsDW47+0AMddKCOhJ/m+He+6QWVOYmea3VoG3k9MkTLRqNK/Qe36O4ra/ytJzxjIkI
        ASSp990qgtZNWIR/b4KP10mLkano5u2zUsmD8xS+DOmN7L2D0gZYrF3bFdXgZEOrpXgLJi
        aiD2X9W5E8aGqewl0peFDNauiqr3yAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-bVQfQHnPOXSzLpP8Zg6Zdg-1; Wed, 22 Apr 2020 04:56:23 -0400
X-MC-Unique: bVQfQHnPOXSzLpP8Zg6Zdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8206DB64
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 08:56:22 +0000 (UTC)
Received: from gondolin (ovpn-112-195.ams2.redhat.com [10.36.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9589B100034E;
        Wed, 22 Apr 2020 08:56:21 +0000 (UTC)
Date:   Wed, 22 Apr 2020 10:56:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kashyap Chamarthy <kchamart@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH v2] docs/virt/kvm: Document running nested guests
Message-ID: <20200422105618.22260edb.cohuck@redhat.com>
In-Reply-To: <20200420111755.2926-1-kchamart@redhat.com>
References: <20200420111755.2926-1-kchamart@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Apr 2020 13:17:55 +0200
Kashyap Chamarthy <kchamart@redhat.com> wrote:

> This is a rewrite of this[1] Wiki page with further enhancements.  The
> doc also includes a section on debugging problems in nested
> environments.
>=20
> [1] https://www.linux-kvm.org/page/Nested_Guests
>=20
> Signed-off-by: Kashyap Chamarthy <kchamart@redhat.com>
> ---
> v1 is here: https://marc.info/?l=3Dkvm&m=3D158108941605311&w=3D2
>=20
> In v2:
>   - Address Cornelia's feedback v1:
>     https://marc.info/?l=3Dkvm&m=3D158109042605606&w=3D2
>   - Address Dave's feedback from v1:
>     https://marc.info/?l=3Dkvm&m=3D158109134905930&w=3D2
> ---
>  .../virt/kvm/running-nested-guests.rst        | 275 ++++++++++++++++++
>  1 file changed, 275 insertions(+)
>  create mode 100644 Documentation/virt/kvm/running-nested-guests.rst
>=20
> diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documenta=
tion/virt/kvm/running-nested-guests.rst
> new file mode 100644
> index 0000000000000000000000000000000000000000..c6c9ccfa0c00e3cbfd65782ce=
ae962b7ef52b34b
> --- /dev/null
> +++ b/Documentation/virt/kvm/running-nested-guests.rst
> @@ -0,0 +1,275 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +Running nested guests with KVM
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +
> +A nested guest is the ability to run a guest inside another guest (it
> +can be KVM-based or a different hypervisor).  The straightforward
> +example is a KVM guest that in turn runs on KVM a guest (the rest of

s/on KVM a guest/on a KVM guest/

> +this document is built on this example)::
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
> +      |        Hardware (with virtualization extensions)     |
> +      '------------------------------------------------------'
> +
> +Terminology:
> +
> +- L0 =E2=80=93 level-0; the bare metal host, running KVM
> +
> +- L1 =E2=80=93 level-1 guest; a VM running on L0; also called the "guest
> +  hypervisor", as it itself is capable of running KVM.
> +
> +- L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "nested gu=
est"
> +
> +.. note:: The above diagram is modelled after x86 architecture; s390x,

s/x86 architecture/the x86 architecture/

> +          ppc64 and other architectures are likely to have different

s/to have/to have a/

> +          design for nesting.
> +
> +          For example, s390x has an additional layer, called "LPAR
> +          hypervisor" (Logical PARtition) on the baremetal, resulting in
> +          "four levels" in a nested setup =E2=80=94 L0 (bare metal, runn=
ing the
> +          LPAR hypervisor), L1 (host hypervisor), L2 (guest hypervisor),
> +          L3 (nested guest).

What about:

"For example, s390x always has an LPAR (LogicalPARtition) hypervisor
running on bare metal, adding another layer and resulting in at least
four levels in a nested setup..."

> +
> +          This document will stick with the three-level terminology (L0,
> +          L1, and L2) for all architectures; and will largely focus on
> +          x86.
> +
> +

(...)

> +Enabling "nested" (s390x)
> +-------------------------
> +
> +1. On the host hypervisor (L0), enable the ``nested`` parameter on
> +   s390x::
> +
> +    $ rmmod kvm
> +    $ modprobe kvm nested=3D1
> +
> +.. note:: On s390x, the kernel parameter ``hpage`` parameter is mutually

Drop one of the "parameter"?

> +          exclusive with the ``nested`` paramter; i.e. to have
> +          ``nested`` enabled you _must_ disable the ``hpage`` parameter.

"i.e., in order to be able to enable ``nested``, the ``hpage``
parameter _must_ be disabled."

?

> +
> +2. The guest hypervisor (L1) must be allowed to have ``sie`` CPU

"must be provided with" ?

> +   feature =E2=80=94 with QEMU, this is possible by using "host passthro=
ugh"

s/this is possible by/this can be done by e.g./ ?

> +   (via the command-line ``-cpu host``).
> +
> +3. Now the KVM module can be enabled in the L1 (guest hypervisor)::

s/enabled/loaded/

> +
> +    $ modprobe kvm
> +
> +
> +Live migration with nested KVM
> +------------------------------
> +
> +The below live migration scenarios should work as of Linux kernel 5.3
> +and QEMU 4.2.0.  In all the below cases, L1 exposes ``/dev/kvm`` in
> +it, i.e. the L2 guest is a "KVM-accelerated guest", not a "plain
> +emulated guest" (as done by QEMU's TCG).

The 5.3/4.2 versions likely apply to x86? Should work for s390x as well
as of these version, but should have worked earlier already :)

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
> +Limitations on Linux kernel versions older than 5.3
> +---------------------------------------------------
> +
> +On x86 systems-only (as this does *not* apply for s390x):

Add a "x86" marker? Or better yet, group all the x86 stuff in an x86
section?

> +
> +On Linux kernel versions older than 5.3, once an L1 guest has started an
> +L2 guest, the L1 guest would no longer capable of being migrated, saved,
> +or loaded (refer to QEMU documentation on "save"/"load") until the L2
> +guest shuts down.
> +
> +Attempting to migrate or save-and-load an L1 guest while an L2 guest is
> +running will result in undefined behavior.  You might see a ``kernel
> +BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> +Such a migrated or loaded L1 guest can no longer be considered stable or
> +secure, and must be restarted.
> +
> +Migrating an L1 guest merely configured to support nesting, while not
> +actually running L2 guests, is expected to function normally.
> +Live-migrating an L2 guest from one L1 guest to another is also expected
> +to succeed.
> +
> +Reporting bugs from "nested" setups
> +-----------------------------------
> +
> +(This is written with x86 terminology in mind, but similar should apply
> +for other architectures.)

Better to reorder it a bit (see below).

> +
> +Debugging "nested" problems can involve sifting through log files across
> +L0, L1 and L2; this can result in tedious back-n-forth between the bug
> +reporter and the bug fixer.
> +
> +- Mention that you are in a "nested" setup.  If you are running any kind
> +  of "nesting" at all, say so.  Unfortunately, this needs to be called
> +  out because when reporting bugs, people tend to forget to even
> +  *mention* that they're using nested virtualization.
> +
> +- Ensure you are actually running KVM on KVM.  Sometimes people do not
> +  have KVM enabled for their guest hypervisor (L1), which results in
> +  them running with pure emulation or what QEMU calls it as "TCG", but
> +  they think they're running nested KVM.  Thus confusing "nested Virt"
> +  (which could also mean, QEMU on KVM) with "nested KVM" (KVM on KVM).
> +
> +- What information to collect?  The following; it's not an exhaustive
> +  list, but a very good starting point:
> +
> +  - Kernel, libvirt, and QEMU version from L0
> +
> +  - Kernel, libvirt and QEMU version from L1
> +
> +  - QEMU command-line of L1 -- preferably full log from
> +    ``/var/log/libvirt/qemu/instance.log``

(if you are running libvirt)

> +
> +  - QEMU command-line of L2 -- preferably full log from
> +    ``/var/log/libvirt/qemu/instance.log``

(if you are running libvirt)

> +
> +  - Full ``dmesg`` output from L0
> +
> +  - Full ``dmesg`` output from L1
> +
> +  - Output of: ``x86info -a`` (& ``lscpu``) from L0
> +
> +  - Output of: ``x86info -a`` (& ``lscpu``) from L1

lscpu makes sense for other architectures as well.

> +
> +  - Output of: ``dmidecode`` from L0
> +
> +  - Output of: ``dmidecode`` from L1

This looks x86 specific? Maybe have a list of things that make sense
everywhere, and list architecture-specific stuff in specific
subsections?


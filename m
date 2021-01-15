Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A495F2F7FE8
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbhAOPno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:43:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbhAOPno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 10:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610725337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0Ml8GeSPx6eTfDk4Qrq1C0++fo/oGqMTB9cMjB7X6E=;
        b=dCgjqsMVcOVbsCSDwoD1w6jMqinfHDi8QXjBkjciCrUukAcuOgdf0lW1GxD+kocCMAlI7F
        AC5eQ3VNzM2KjIrQhoDPtwFwtpwkVve/p7kAxW3CCEu6YIYWMS0N5jnnowoQyD2309oWmf
        AWSPXOJtTo0okLr56eceBl648KyUuSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-QWWsuQnJPcqYM9v2kjrjNg-1; Fri, 15 Jan 2021 10:42:13 -0500
X-MC-Unique: QWWsuQnJPcqYM9v2kjrjNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA16D806662;
        Fri, 15 Jan 2021 15:42:10 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32A2A60BF3;
        Fri, 15 Jan 2021 15:41:54 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:41:51 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 10/13] spapr: Add PEF based confidential guest
 support
Message-ID: <20210115164151.087826c5.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-11-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-11-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:08 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Some upcoming POWER machines have a system called PEF (Protected
> Execution Facility) which uses a small ultravisor to allow guests to
> run in a way that they can't be eavesdropped by the hypervisor.  The
> effect is roughly similar to AMD SEV, although the mechanisms are
> quite different.
> 
> Most of the work of this is done between the guest, KVM and the
> ultravisor, with little need for involvement by qemu.  However qemu
> does need to tell KVM to allow secure VMs.
> 
> Because the availability of secure mode is a guest visible difference
> which depends on having the right hardware and firmware, we don't
> enable this by default.  In order to run a secure guest you need to
> create a "pef-guest" object and set the confidential-guest-support
> property to point to it.
> 
> Note that this just *allows* secure guests, the architecture of PEF is
> such that the guest still needs to talk to the ultravisor to enter
> secure mode.  Qemu has no directl way of knowing if the guest is in
> secure mode, and certainly can't know until well after machine
> creation time.
> 
> To start a PEF-capable guest, use the command line options:
>     -object pef-guest,id=pef0 -machine confidential-guest-support=pef0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |   3 +
>  docs/papr-pef.txt                   |  30 +++++++
>  hw/ppc/meson.build                  |   1 +
>  hw/ppc/pef.c                        | 119 ++++++++++++++++++++++++++++
>  hw/ppc/spapr.c                      |   6 ++
>  include/hw/ppc/pef.h                |  25 ++++++
>  target/ppc/kvm.c                    |  18 -----
>  target/ppc/kvm_ppc.h                |   6 --
>  8 files changed, 184 insertions(+), 24 deletions(-)
>  create mode 100644 docs/papr-pef.txt
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/hw/ppc/pef.h
> 
> diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
> index 2790425b38..f0801814ff 100644
> --- a/docs/confidential-guest-support.txt
> +++ b/docs/confidential-guest-support.txt
> @@ -40,4 +40,7 @@ Currently supported confidential guest mechanisms are:
>  AMD Secure Encrypted Virtualization (SEV)
>      docs/amd-memory-encryption.txt
>  
> +POWER Protected Execution Facility (PEF)
> +    docs/papr-pef.txt
> +
>  Other mechanisms may be supported in future.
> diff --git a/docs/papr-pef.txt b/docs/papr-pef.txt
> new file mode 100644
> index 0000000000..6419e995cf
> --- /dev/null
> +++ b/docs/papr-pef.txt

Same here, make this .rst and add it to the system guide?

> @@ -0,0 +1,30 @@
> +POWER (PAPR) Protected Execution Facility (PEF)
> +===============================================
> +
> +Protected Execution Facility (PEF), also known as Secure Guest support
> +is a feature found on IBM POWER9 and POWER10 processors.
> +
> +If a suitable firmware including an Ultravisor is installed, it adds
> +an extra memory protection mode to the CPU.  The ultravisor manages a
> +pool of secure memory which cannot be accessed by the hypervisor.
> +
> +When this feature is enabled in qemu, a guest can use ultracalls to

s/qemu/QEMU/

> +enter "secure mode".  This transfers most of its memory to secure
> +memory, where it cannot be eavesdropped by a compromised hypervisor.
> +
> +Launching
> +---------
> +
> +To launch a guest which will be permitted to enter PEF secure mode:
> +
> +# ${QEMU} \
> +    -object pef-guest,id=pef0 \
> +    -machine confidential-guest-support=pef0 \
> +    ...
> +
> +Live Migration
> +----------------
> +
> +Live migration is not yet implemented for PEF guests.  For
> +consistency, we currently prevent migration if the PEF feature is
> +enabled, whether or not the guest has actually entered secure mode.
> diff --git a/hw/ppc/meson.build b/hw/ppc/meson.build
> index ffa2ec37fa..218631c883 100644
> --- a/hw/ppc/meson.build
> +++ b/hw/ppc/meson.build
> @@ -27,6 +27,7 @@ ppc_ss.add(when: 'CONFIG_PSERIES', if_true: files(
>    'spapr_nvdimm.c',
>    'spapr_rtas_ddw.c',
>    'spapr_numa.c',
> +  'pef.c',
>  ))
>  ppc_ss.add(when: 'CONFIG_SPAPR_RNG', if_true: files('spapr_rng.c'))
>  ppc_ss.add(when: ['CONFIG_PSERIES', 'CONFIG_LINUX'], if_true: files(
> diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> new file mode 100644
> index 0000000000..02b9b3b460
> --- /dev/null
> +++ b/hw/ppc/pef.c
> @@ -0,0 +1,119 @@
> +/*
> + * PEF (Protected Execution Facility) for POWER support
> + *
> + * Copyright David Gibson, Redhat Inc. 2020

2021?

> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +


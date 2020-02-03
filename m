Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B1B150E6E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 18:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgBCRMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 12:12:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgBCRMw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 12:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580749970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCimoT7vPuapUWMTalWFNqWDzb69UF8BoVS/mAn8gMw=;
        b=aBWrfiX6sIQyrT6v9F2eXhknFOS+vLYTEwcifZIh8yCN+NyyL0euf48oyyIBHw6KGWRyGb
        mAVIumEY+SC81zu2S8S1DlFT0x9kO/mhIpyjdBf/Xi980sOlm8mDM6ZlqxulJ/uXY5CvWi
        8GaSLaRkYB3K4QVH/D1CFrpWm8EEQrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-4cQJuupUPSe6mP1qzFCgMg-1; Mon, 03 Feb 2020 12:12:46 -0500
X-MC-Unique: 4cQJuupUPSe6mP1qzFCgMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 606381800D41;
        Mon,  3 Feb 2020 17:12:45 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FC6E60BE2;
        Mon,  3 Feb 2020 17:12:41 +0000 (UTC)
Date:   Mon, 3 Feb 2020 18:12:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 02/37] s390/protvirt: introduce host side setup
Message-ID: <20200203181238.7c7ea03b.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-3-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-3-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:22 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> protected virtual machines hosting support code.

Hm... I seem to remember that you wanted to drop this config option and
always build the code, in order to reduce complexity. Have you
reconsidered this?

> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 20 +++++++-
>  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
>  arch/s390/kvm/Kconfig                         | 19 ++++++++
>  8 files changed, 136 insertions(+), 9 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c

(...)

> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> new file mode 100644
> index 000000000000..35ce89695509
> --- /dev/null
> +++ b/arch/s390/kernel/uv.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Common Ultravisor functions and initialization
> + *
> + * Copyright IBM Corp. 2019

Happy new year?

> + */
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <linux/memblock.h>
> +#include <asm/facility.h>
> +#include <asm/sections.h>
> +#include <asm/uv.h>
> +
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +int __bootdata_preserved(prot_virt_guest);

Confused. You have this and uv_info below both in this file and in
boot/uv.c. Is there some magic happening in __bootdata_preserved()?

> +#endif
> +
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +int prot_virt_host;
> +EXPORT_SYMBOL(prot_virt_host);
> +struct uv_info __bootdata_preserved(uv_info);
> +EXPORT_SYMBOL(uv_info);
> +
> +static int __init prot_virt_setup(char *val)
> +{
> +	bool enabled;
> +	int rc;
> +
> +	rc = kstrtobool(val, &enabled);
> +	if (!rc && enabled)
> +		prot_virt_host = 1;
> +
> +	if (is_prot_virt_guest() && prot_virt_host) {
> +		prot_virt_host = 0;
> +		pr_info("Running as protected virtualization guest.");

Trying to disentangle that a bit in my mind...

If we don't have facility 158, is_prot_virt_guest() will return 0. If
protected host support has been requested, we'll print a message below
(and turn it off).

If the hardware provides the facilities for running as a protected virt
guest, we turn off protected virt host support if requested and print a
messages that we're a guest.

Two questions:
- Can the hardware ever provide both host and guest interfaces at the
  same time? I guess not; maybe add a comment?
- Do we also want to print a message that we're running as a guest if
  the user didn't enable host support? If not, maybe prefix the message
  with "Cannot enable support for protected virtualization host:" or
  so? (Maybe also a good idea for the message below.)

> +	}
> +
> +	if (prot_virt_host && !test_facility(158)) {
> +		prot_virt_host = 0;
> +		pr_info("The ultravisor call facility is not available.");
> +	}
> +
> +	return rc;
> +}
> +early_param("prot_virt", prot_virt_setup);
> +#endif

(...)


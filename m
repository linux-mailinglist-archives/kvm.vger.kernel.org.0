Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A362D5A98
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 13:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgLJMep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 07:34:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727647AbgLJMeo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 07:34:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607603598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+KcZJva1JHnm2VE0m2PQnQTxCgdEEnkxtAmetNWcaI=;
        b=OSBu7q1i2jRRukxQPZKvvtpVfhbDRZDcFg4GtXwp2Y9AFspmUOZuXrytYRt62fapKsgKXo
        wgpNTzZdPKIvtFB/BgM2ZXVsKGFgNjrdV2hUjiuf96NKeaDc6/tzbgZNZ5y/zDvfsuCDMz
        tqDgj9m9U2jnbzcmGZn33Y8U/WL5Jvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-SEh5N4KeNU66XMmL6OwI1g-1; Thu, 10 Dec 2020 07:33:16 -0500
X-MC-Unique: SEh5N4KeNU66XMmL6OwI1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E56410A0F44;
        Thu, 10 Dec 2020 12:33:15 +0000 (UTC)
Received: from gondolin (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55D316F965;
        Thu, 10 Dec 2020 12:33:09 +0000 (UTC)
Date:   Thu, 10 Dec 2020 13:33:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Message-ID: <20201210133306.70d1a556.cohuck@redhat.com>
In-Reply-To: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  9 Dec 2020 15:27:46 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Today, ISM devices are completely disallowed for vfio-pci passthrough as
> QEMU will reject the device due to an (inappropriate) MSI-X check.
> However, in an effort to enable ISM device passthrough, I realized that the
> manner in which ISM performs block write operations is highly incompatible
> with the way that QEMU s390 PCI instruction interception and
> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
> devices have particular requirements in regards to the alignment, size and
> order of writes performed.  Furthermore, they require that legacy/non-MIO
> s390 PCI instructions are used, which is also not guaranteed when the I/O
> is passed through the typical userspace channels.

The part about the non-MIO instructions confuses me. How can MIO
instructions be generated with the current code, and why does changing
the write pattern help?

> 
> As a result, this patchset proposes a new VFIO region to allow a guest to
> pass certain PCI instruction intercepts directly to the s390 host kernel
> PCI layer for exeuction, pinning the guest buffer in memory briefly in
> order to execute the requested PCI instruction.
> 
> Matthew Rosato (4):
>   s390/pci: track alignment/length strictness for zpci_dev
>   vfio-pci/zdev: Pass the relaxed alignment flag
>   s390/pci: Get hardware-reported max store block length
>   vfio-pci/zdev: Introduce the zPCI I/O vfio region
> 
>  arch/s390/include/asm/pci.h         |   4 +-
>  arch/s390/include/asm/pci_clp.h     |   7 +-
>  arch/s390/pci/pci_clp.c             |   2 +
>  drivers/vfio/pci/vfio_pci.c         |   8 ++
>  drivers/vfio/pci/vfio_pci_private.h |   6 ++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 160 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h           |   4 +
>  include/uapi/linux/vfio_zdev.h      |  33 ++++++++
>  8 files changed, 221 insertions(+), 3 deletions(-)
> 


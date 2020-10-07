Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E29928686E
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgJGTju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbgJGTju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 15:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602099589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOqgbm6jLuc+pkMp+rGK/onrrL4PUBHXfHnkokJUxJA=;
        b=OcoYS8paXU3moy937yqrGGvlxJWj2UIpbK5S3j4BgDAAWz+LlOUExEJf3YhkLZcvCqwtbE
        5ZCP8aRAPWz1pYT07EM1XHSRPRGXQE6afEuubCDPajY7POuO0QiCvoYQc8xK+tjgLAZyIQ
        2ZFa2g9+6CLk1woiIBwktKrAMMdUNmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-bi3W629PPgyimimEII7m_w-1; Wed, 07 Oct 2020 15:39:47 -0400
X-MC-Unique: bi3W629PPgyimimEII7m_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D51B31007464;
        Wed,  7 Oct 2020 19:39:45 +0000 (UTC)
Received: from w520.home (ovpn-113-244.phx2.redhat.com [10.3.113.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AC12702E7;
        Wed,  7 Oct 2020 19:39:45 +0000 (UTC)
Date:   Wed, 7 Oct 2020 13:39:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Pass zPCI hardware information via VFIO
Message-ID: <20201007133944.52782a7e@w520.home>
In-Reply-To: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 14:56:19 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> This patchset provides a means by which hardware information about the
> underlying PCI device can be passed up to userspace (ie, QEMU) so that
> this hardware information can be used rather than previously hard-coded
> assumptions. The VFIO_DEVICE_GET_INFO ioctl is extended to allow capability
> chains and zPCI devices provide the hardware information via capabilities.
> 
> A form of these patches saw some rounds last year but has been back-
> tabled for a while.  The original work for this feature was done by Pierre
> Morel. I'd like to refresh the discussion on this and get this finished up
> so that we can move forward with better-supporting additional types of
> PCI-attached devices.  
> 
> This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry. 
> 
> Changes since v2:
> - Added ACKs (thanks!)
> - Patch 3+4: Re-write to use VFIO_DEVICE_GET_INFO capabilities rather than
>   a vfio device region.

Looks good to me, I'll let Connie and others double check and throw in
their reviews, but I'll plan to include this for v5.10.  Thanks,

Alex
 
> Matthew Rosato (5):
>   s390/pci: stash version in the zpci_dev
>   s390/pci: track whether util_str is valid in the zpci_dev
>   vfio: Introduce capability definitions for VFIO_DEVICE_GET_INFO
>   vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO
>   MAINTAINERS: Add entry for s390 vfio-pci
> 
>  MAINTAINERS                         |   8 ++
>  arch/s390/include/asm/pci.h         |   4 +-
>  arch/s390/pci/pci_clp.c             |   2 +
>  drivers/vfio/pci/Kconfig            |  13 ++++
>  drivers/vfio/pci/Makefile           |   1 +
>  drivers/vfio/pci/vfio_pci.c         |  37 ++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  12 +++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 143 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h           |  11 +++
>  include/uapi/linux/vfio_zdev.h      |  78 ++++++++++++++++++++
>  10 files changed, 308 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>  create mode 100644 include/uapi/linux/vfio_zdev.h
> 


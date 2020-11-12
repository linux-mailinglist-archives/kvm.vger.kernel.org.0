Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8E32B0CDA
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgKLSk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:40:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726295AbgKLSk0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605206424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eU0sx65Xhrwpk0w9nqSXAGfCb3bS7nAytTmglkTYuU0=;
        b=OEKbOkM5O4OYHTAxjDVgCQs6QNSZ/uLTFrTtL4zlc85kZLm668ZBegtyvonluth7uu+TC1
        ZK63lrQUs3sozZp0aW/XPQpMRh43bdVafND5HHFMGPvwVZxlq5Pgy2GF/2I0xYPRBNE0Sx
        FrIw9zDb3h/Vlgl8D0J8zcnCCc6VLno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-ex_GIJXzO4eFUW8k1i1C_A-1; Thu, 12 Nov 2020 13:40:23 -0500
X-MC-Unique: ex_GIJXzO4eFUW8k1i1C_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0373101F00C;
        Thu, 12 Nov 2020 18:40:21 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFAA5C1A3;
        Thu, 12 Nov 2020 18:40:16 +0000 (UTC)
Subject: Re: [RFC, v1 0/3] msi support for platform devices
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <96436cba-88e3-ddb6-36d6-000929b86979@redhat.com>
Date:   Thu, 12 Nov 2020 19:40:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201112175852.21572-1-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 11/12/20 6:58 PM, Vikas Gupta wrote:
> This RFC adds support for MSI for platform devices.
> a) MSI(s) is/are added in addition to the normal interrupts.
> b) The vendor specific MSI configuration can be done using
>    callbacks which is implemented as msi module.
> c) Adds a msi handling module for the Broadcom platform devices.
> 
> Changes from:
> -------------
>  v0 to v1:
>    i)  Removed MSI device flag VFIO_DEVICE_FLAGS_MSI.
>    ii) Add MSI(s) at the end of the irq list of platform IRQs.
>        MSI(s) with first entry of MSI block has count and flag
>        information.
>        IRQ list: Allocation for IRQs + MSIs are allocated as below
>        Example: if there are 'n' IRQs and 'k' MSIs
>        -------------------------------------------------------
>        |IRQ-0|IRQ-1|....|IRQ-n|MSI-0|MSI-1|MSI-2|......|MSI-k|
>        -------------------------------------------------------
I have not taken time yet to look at your series, but to me you should have
|IRQ-0|IRQ-1|....|IRQ-n|MSI|MSIX
then for setting a given MSIX (i) you would select the MSIx index and
then set start=i count=1.
to me individual MSIs are encoded in the subindex and not in the index.
The index just selects the "type" of interrupt.

For PCI you just have:
        VFIO_PCI_INTX_IRQ_INDEX,
        VFIO_PCI_MSI_IRQ_INDEX, -> MSI index and then you play with
start/count
        VFIO_PCI_MSIX_IRQ_INDEX,
        VFIO_PCI_ERR_IRQ_INDEX,
        VFIO_PCI_REQ_IRQ_INDEX,

(include/uapi/linux/vfio.h)

Thanks

Eric
>        MSI-0 will have count=k set and flags set accordingly.
> 
> Vikas Gupta (3):
>   vfio/platform: add support for msi
>   vfio/platform: change cleanup order
>   vfio/platform: add Broadcom msi module
> 
>  drivers/vfio/platform/Kconfig                 |   1 +
>  drivers/vfio/platform/Makefile                |   1 +
>  drivers/vfio/platform/msi/Kconfig             |   9 +
>  drivers/vfio/platform/msi/Makefile            |   2 +
>  .../vfio/platform/msi/vfio_platform_bcmplt.c  |  74 ++++++
>  drivers/vfio/platform/vfio_platform_common.c  |  86 ++++++-
>  drivers/vfio/platform/vfio_platform_irq.c     | 238 +++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |  23 ++
>  8 files changed, 419 insertions(+), 15 deletions(-)
>  create mode 100644 drivers/vfio/platform/msi/Kconfig
>  create mode 100644 drivers/vfio/platform/msi/Makefile
>  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
> 


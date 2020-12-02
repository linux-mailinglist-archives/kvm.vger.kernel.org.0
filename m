Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC43D2CBFFB
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgLBOpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:45:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727629AbgLBOpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 09:45:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606920232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RHOXBai2aXl+BJUkU+hHPDcfzmvzCGJQbdCtsegApQ=;
        b=MGLyOFEDUel7Hz0ijhJhVM+YkeJf5nf7OvGSwfYKi6bFW9w4lCZLEZq8Qu6/EftzfwgzPe
        58c93A93q9c+qttNQwgB8u7fzt8A5y6AxfPsTD+nN5Ukd9BOV/qjiOJv8QrtuBe0FwaBcD
        oRCMHqGloWKO0G/jHP0Qz/fiwJ4ArVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-UAGzf-2OPx6KI2tflVxAnA-1; Wed, 02 Dec 2020 09:43:50 -0500
X-MC-Unique: UAGzf-2OPx6KI2tflVxAnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C1A88049CD;
        Wed,  2 Dec 2020 14:43:49 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17AD960854;
        Wed,  2 Dec 2020 14:43:36 +0000 (UTC)
Subject: Re: [RFC, v2 0/1] msi support for platform devices
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-1-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <014f8357-29ad-3e5a-9a34-0ee7cb9bf71c@redhat.com>
Date:   Wed, 2 Dec 2020 15:43:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201124161646.41191-1-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,
On 11/24/20 5:16 PM, Vikas Gupta wrote:
> This RFC adds support for MSI for platform devices.
> MSI block is added as an ext irq along with the existing
> wired interrupt implementation.
> 
> Changes from:
> -------------
>  v1 to v2:
> 	1) IRQ allocation has been implemented as below:
> 	       ----------------------------
> 	       |IRQ-0|IRQ-1|....|IRQ-n|MSI|
>        	       ----------------------------
> 		MSI block has msi contexts and its implemneted
it is implemented
> 		as ext irq.
> 
> 	2) Removed vendor specific module for msi handling so
> 	   previously patch2 and patch3 are not required.
> 
> 	3) MSI related data is exported to userspace using 'caps'.
> 	 Please note VFIO_IRQ_INFO_CAP_TYPE in include/uapi/linux/vfio.h implementation
> 	is taken from the Eric`s patch
>         https://patchwork.kernel.org/project/kvm/patch/20201116110030.32335-8-eric.auger@redhat.com/
So do you mean that by exposing the vectors, now you do not need the msi
module anymore?


Thanks

Eric
> 
> 
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
>        MSI-0 will have count=k set and flags set accordingly.
> 
> Vikas Gupta (1):
>   vfio/platform: add support for msi
> 
>  drivers/vfio/platform/vfio_platform_common.c  |  99 ++++++-
>  drivers/vfio/platform/vfio_platform_irq.c     | 260 +++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |  16 ++
>  include/uapi/linux/vfio.h                     |  43 +++
>  4 files changed, 401 insertions(+), 17 deletions(-)
> 


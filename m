Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC162621B9
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 23:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIHVK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 17:10:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55466 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728617AbgIHVKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 17:10:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599599414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3qjPuLO4+xc8/Vzemw4EOYS+UYAR8BKMfifYECLYS4=;
        b=R0t9P8fLOAJkXCjv5H2Up+f6hcLVdGD0h0HnCHPKAEt4X8R5Ay6KRGvh818HUSuX+3PyCS
        0P0Kr9EZ8i6dPMG3iHpxRUu3Z8yjV+EvPN6FPotjt3qYDpN3nSS5zWFDUBDSuwXZcJw+n7
        NL+Lr4JrLkPOI9fAR4M4Vanl49CedMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-e9gPun-IPwaPvPqs0LQ-NA-1; Tue, 08 Sep 2020 17:10:10 -0400
X-MC-Unique: e9gPun-IPwaPvPqs0LQ-NA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61F178018A1;
        Tue,  8 Sep 2020 21:10:08 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE4505D9F3;
        Tue,  8 Sep 2020 21:10:02 +0000 (UTC)
Date:   Tue, 8 Sep 2020 15:10:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     mdf@kernel.org, kwankhede@nvidia.com, linux-fpga@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH 3/3] Documentation: fpga: dfl: Add description for VFIO
 Mdev support
Message-ID: <20200908151002.553ed7ae@w520.home>
In-Reply-To: <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
        <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Sep 2020 15:13:32 +0800
Xu Yilun <yilun.xu@intel.com> wrote:

> This patch adds description for VFIO Mdev support for dfl devices on
> dfl bus.
> 
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
> ---
>  Documentation/fpga/dfl.rst | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
> index 0404fe6..f077754 100644
> --- a/Documentation/fpga/dfl.rst
> +++ b/Documentation/fpga/dfl.rst
> @@ -502,6 +502,26 @@ FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
>  could be a reference.
>  
>  
> +VFIO Mdev support for DFL devices
> +=================================
> +As we introduced a dfl bus for private features, they could be added to dfl bus
> +as independent dfl devices. There is a requirement to handle these devices
> +either by kernel drivers or by direct access from userspace. Usually we bind
> +the kernel drivers to devices which provide board management functions, and
> +gives user direct access to devices which cooperate closely with user
> +controlled Accelerated Function Unit (AFU). We realize this with a VFIO Mdev
> +implementation. When we bind the vfio-mdev-dfl driver to a dfl device, it
> +realizes a group of callbacks and registers to the Mdev framework as a
> +parent (physical) device. It could then create one (available_instances == 1)
> +mdev device.
> +Since dfl devices are sub devices of FPGA DFL physical devices (e.g. PCIE
> +device), which provide no DMA isolation for each sub device, this may leads to
> +DMA isolation problem if a private feature is designed to be capable of DMA.
> +The AFU user could potentially access the whole device addressing space and
> +impact the private feature. So now the general HW design rule is, no DMA
> +capability for private features. It eliminates the DMA isolation problem.

What's the advantage of entangling mdev/vfio in this approach versus
simply exposing the MMIO region of the device via sysfs (similar to a
resource file in pci-sysfs)?  This implementation doesn't support
interrupts, it doesn't support multiplexing of a device, it doesn't
perform any degree of mediation, it seems to simply say "please don't
do DMA".  I don't think that's acceptable for an mdev driver.  If you
want to play loose with isolation, do it somewhere else.  Thanks,

Alex


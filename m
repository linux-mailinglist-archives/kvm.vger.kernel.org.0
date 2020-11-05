Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34F02A77BC
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 08:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKEHIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 02:08:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726371AbgKEHIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 02:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604560096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvkuQPSDCN6FYaBMhi9QfR8XY+glajAyMRxV78sAHp8=;
        b=DaKOFf/ijQf8tLGf897YVM1E5qQM49mFvGFdaxuZVb4eSLtS12c41I3PXaHqqIh4YkA9FG
        yzg4Jtu7Rw+8d2F36f0P4HxxnatQk3FCC53nYF22BMxg9majPOO5JAgXuJsb8HVvxdVRHO
        NGPVEItEMhlz4VWEF2DmEfeCwlUjK7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-24oP9kIaO0WULtCF9hmyQw-1; Thu, 05 Nov 2020 02:08:12 -0500
X-MC-Unique: 24oP9kIaO0WULtCF9hmyQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1552A804762;
        Thu,  5 Nov 2020 07:08:11 +0000 (UTC)
Received: from x1.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BA3D5DA33;
        Thu,  5 Nov 2020 07:08:06 +0000 (UTC)
Date:   Thu, 5 Nov 2020 00:08:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     eric.auger@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vikram.prakash@broadcom.com
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
Message-ID: <20201105000806.1df16656@x1.home>
In-Reply-To: <20201105060257.35269-2-vikas.gupta@broadcom.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
        <20201105060257.35269-2-vikas.gupta@broadcom.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Nov 2020 11:32:55 +0530
Vikas Gupta <vikas.gupta@broadcom.com> wrote:

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2f313a238a8f..aab051e8338d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -203,6 +203,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
>  #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
> +#define VFIO_DEVICE_FLAGS_MSI	(1 << 8)	/* Device supports msi */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */

This doesn't make any sense to me, MSIs are just edge triggered
interrupts to userspace, so why isn't this fully described via
VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it,
this seems incomplete, which indexes are MSI (IRQ_INFO can describe
that)?  We also already support MSI with vfio-pci, so a global flag for
the device advertising this still seems wrong.  Thanks,

Alex


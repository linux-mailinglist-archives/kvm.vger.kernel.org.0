Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580FE18BE9A
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgCSRpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:45:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58700 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728592AbgCSRpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584639907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLqi3G1ZNiVSz9AxSij/CsrdtEjTvKCYJQbBAfaLPXI=;
        b=iEg1va88zu+bOeshirTQwrUlQoUgAdTHZcXOAkZVmpKGErfXlmnQLC6mHxpV+r0Ki51UIR
        edVzLDDHtpxi5rxYikGKdMlN7qAnzTzSA5/XmwdKncnLLyrZR2LKJotB9Bni0dOAUgB7t3
        Ic6XYtD15EEdanjL3fll1AaGnC9GRfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-83yFdhWHOJS1GmZTPPDHxg-1; Thu, 19 Mar 2020 13:45:03 -0400
X-MC-Unique: 83yFdhWHOJS1GmZTPPDHxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BB6C800D53;
        Thu, 19 Mar 2020 17:45:01 +0000 (UTC)
Received: from gondolin (ovpn-113-188.ams2.redhat.com [10.36.113.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1022A5C21B;
        Thu, 19 Mar 2020 17:44:56 +0000 (UTC)
Date:   Thu, 19 Mar 2020 18:44:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, kevin.tian@intel.com
Subject: Re: [PATCH v3 5/7] vfio/pci: Add sriov_configure support
Message-ID: <20200319184453.39713aab.cohuck@redhat.com>
In-Reply-To: <158396395214.5601.11207416598267070486.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
        <158396395214.5601.11207416598267070486.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 15:59:12 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> With the VF Token interface we can now expect that a vfio userspace
> driver must be in collaboration with the PF driver, an unwitting
> userspace driver will not be able to get past the GET_DEVICE_FD step
> in accessing the device.  We can now move on to actually allowing
> SR-IOV to be enabled by vfio-pci on the PF.  Support for this is not
> enabled by default in this commit, but it does provide a module option
> for this to be enabled (enable_sriov=1).  Enabling VFs is rather
> straightforward, except we don't want to risk that a VF might get
> autoprobed and bound to other drivers, so a bus notifier is used to
> "capture" VFs to vfio-pci using the driver_override support.  We
> assume any later action to bind the device to other drivers is
> condoned by the system admin and allow it with a log warning.
> 
> vfio-pci will disable SR-IOV on a PF before releasing the device,
> allowing a VF driver to be assured other drivers cannot take over the
> PF and that any other userspace driver must know the shared VF token.
> This support also does not provide a mechanism for the PF userspace
> driver itself to manipulate SR-IOV through the vfio API.  With this
> patch SR-IOV can only be enabled via the host sysfs interface and the
> PF driver user cannot create or remove VFs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         |  106 +++++++++++++++++++++++++++++++----
>  drivers/vfio/pci/vfio_pci_private.h |    2 +
>  2 files changed, 97 insertions(+), 11 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


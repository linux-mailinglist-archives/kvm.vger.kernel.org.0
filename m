Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CD2516D4
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgHYKps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:45:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729861AbgHYKps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 06:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598352346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zqomz7pBodrPJvyElkg6GCnIebmEo0ZuVsFwZptpcLA=;
        b=d5+h2MR8SdrT9nDvHmmK7Uz6B+dZntYDf6wV/D16Nyuw4Hg511m/0RbgyWxmoETEIRUsJ9
        GJ9UZpb4A0OIo+vpi2PVe0CQtDILH2cT26CvoHVQgtNhzMnE8zAoqvrcRkLcYlgTkboLhT
        GdmTRENOsSW5yJi6fpc7hU/sCm5vLaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-G_MjPm9LOrG-Ln1KLW4msQ-1; Tue, 25 Aug 2020 06:45:42 -0400
X-MC-Unique: G_MjPm9LOrG-Ln1KLW4msQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B7FE81F01A;
        Tue, 25 Aug 2020 10:45:40 +0000 (UTC)
Received: from gondolin (ovpn-112-248.ams2.redhat.com [10.36.112.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BCB160C0F;
        Tue, 25 Aug 2020 10:45:32 +0000 (UTC)
Date:   Tue, 25 Aug 2020 12:45:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 16/16] s390/vfio-ap: update docs to include dynamic
 config support
Message-ID: <20200825124529.7b51d825.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-17-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-17-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:16 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Update the documentation in vfio-ap.rst to include information about the
> AP dynamic configuration support (i.e., hot plug of adapters, domains
> and control domains via the matrix mediated device's sysfs assignment
> attributes).
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  Documentation/s390/vfio-ap.rst | 362 ++++++++++++++++++++++++++-------
>  1 file changed, 285 insertions(+), 77 deletions(-)
> 
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
> index e15436599086..8907aeca8fb7 100644
> --- a/Documentation/s390/vfio-ap.rst
> +++ b/Documentation/s390/vfio-ap.rst
> @@ -253,7 +253,7 @@ The process for reserving an AP queue for use by a KVM guest is:
>  1. The administrator loads the vfio_ap device driver
>  2. The vfio-ap driver during its initialization will register a single 'matrix'
>     device with the device core. This will serve as the parent device for
> -   all mediated matrix devices used to configure an AP matrix for a guest.
> +   all matrix mediated devices used to configure an AP matrix for a guest.

This (and many other changes here) seems to be unrelated to the new
feature. Split that out into a separate patch that can be applied right
away? That would make this patch smaller and easier to review; it's
hard to figure out which parts deal with the new feature, and which parts
simply got an update.

Also, do you want to do similar wording changes in the QEMU
documentation for vfio-ap?

>  3. The /sys/devices/vfio_ap/matrix device is created by the device core
>  4. The vfio_ap device driver will register with the AP bus for AP queue devices
>     of type 10 and higher (CEX4 and newer). The driver will provide the vfio_ap

(...)

> @@ -435,6 +481,10 @@ available to a KVM guest via the following CPU model features:
>     can be made available to the guest only if it is available on the host (i.e.,
>     facility bit 12 is set).
>  
> +4. apqi: Indicates AP queue interrupts are available on the guest. This facility
> +   can be made available to the guest only if it is available on the host (i.e.,
> +   facility bit 65 is set).
> +
>  Note: If the user chooses to specify a CPU model different than the 'host'
>  model to QEMU, the CPU model features and facilities need to be turned on
>  explicitly; for example::
> @@ -444,7 +494,7 @@ explicitly; for example::
>  A guest can be precluded from using AP features/facilities by turning them off
>  explicitly; for example::
>  
> -     /usr/bin/qemu-system-s390x ... -cpu host,ap=off,apqci=off,apft=off
> +     /usr/bin/qemu-system-s390x ... -cpu host,ap=off,apqci=off,apft=off,apqi=off

Isn't that an already existing facility that was simply lacking
documentation? If yes, split it off?

>  
>  Note: If the APFT facility is turned off (apft=off) for the guest, the guest
>  will not see any AP devices. The zcrypt device drivers that register for type 10

(...)


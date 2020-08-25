Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952AF25163B
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgHYKEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:04:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbgHYKEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 06:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598349888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1guKzsu1f7vE3cUpyLB5EkhBDdCRY0IBR0GpJ2ik82Y=;
        b=XLdbJh5/XPCWJj2RZyEQvVL4DJNrQSeE/TdfsihjM1mvxWojbcFVdF2lErDOVfvzuB1xtw
        QOlJCxhUqZqm4t/tI6n2RCpChgQ/iNTsOVHm+njKgpfBz7bxYN/sPr3xwq1q0lTC5QVNlo
        yQucMC9kDgOlhxNiEhE2D8+Phjq289c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-gjMOj3BUPVuF33NDiuVR3w-1; Tue, 25 Aug 2020 06:04:46 -0400
X-MC-Unique: gjMOj3BUPVuF33NDiuVR3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 732A2800050;
        Tue, 25 Aug 2020 10:04:44 +0000 (UTC)
Received: from gondolin (ovpn-112-248.ams2.redhat.com [10.36.112.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8F1D5C1CF;
        Tue, 25 Aug 2020 10:04:34 +0000 (UTC)
Date:   Tue, 25 Aug 2020 12:04:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 01/16] s390/vfio-ap: add version vfio_ap module
Message-ID: <20200825120432.13a1b444.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-2-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-2-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:01 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's set a version for the vfio_ap module so that automated regression
> tests can determine whether dynamic configuration tests can be run or
> not.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..f4ceb380dd61 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -17,10 +17,12 @@
>  
>  #define VFIO_AP_ROOT_NAME "vfio_ap"
>  #define VFIO_AP_DEV_NAME "matrix"
> +#define VFIO_AP_MODULE_VERSION "1.2.0"
>  
>  MODULE_AUTHOR("IBM Corporation");
>  MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
>  MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(VFIO_AP_MODULE_VERSION);
>  
>  static struct ap_driver vfio_ap_drv;
>  

Setting a version manually has some drawbacks:
- tools wanting to check for capabilities need to keep track which
  versions support which features
- you need to remember to actually bump the version when adding a new,
  visible feature
(- selective downstream backports may get into a pickle, but that's
arguably not your problem)

Is there no way for a tool to figure out whether this is supported?
E.g., via existence of a sysfs file, or via a known error that will
occur. If not, it's maybe better to expose known capabilities via a
generic interface.


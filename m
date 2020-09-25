Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD6C27843A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgIYJlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:41:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbgIYJlY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:41:24 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601026884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uG3mT3mIsHXGo/NZ/lagLrVrCF3W5tB7wbo/eGmR8/8=;
        b=PmpgyupSu35N1SPu+dkogfunpTlIr1cwLyQLjxU46G7c9t8XDtKJOJro4kJyh0P5l+2qoS
        KhnPzN9sHVvnmBt9B4OFXj8tDJ2TpX8K4KTQnFUX1L4hEilIUaaWVFUIMUMBHOJS0vL61+
        lYgMA0e55MZUfqWYgkcsfUAyMtjgAwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-tQR-5GWWO-Cpe9fjmIx9og-1; Fri, 25 Sep 2020 05:41:22 -0400
X-MC-Unique: tQR-5GWWO-Cpe9fjmIx9og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95BA1186DD46;
        Fri, 25 Sep 2020 09:41:20 +0000 (UTC)
Received: from gondolin (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AD8755786;
        Fri, 25 Sep 2020 09:41:08 +0000 (UTC)
Date:   Fri, 25 Sep 2020 11:41:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 4/7] s390x/pci: use a PCI Group structure
Message-ID: <20200925114105.439c1c7d.cohuck@redhat.com>
In-Reply-To: <1600529672-10243-5-git-send-email-mjrosato@linux.ibm.com>
References: <1600529672-10243-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529672-10243-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Sep 2020 11:34:29 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> We use a S390PCIGroup structure to hold the information related to a
> zPCI Function group.
> 
> This allows us to be ready to support multiple groups and to retrieve
> the group information from the host.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-bus.h  | 10 ++++++++++
>  hw/s390x/s390-pci-inst.c | 22 +++++++++++++---------
>  3 files changed, 65 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 92146a2..3015d86 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -737,6 +737,46 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
>      object_unref(OBJECT(iommu));
>  }
>  
> +static S390PCIGroup *s390_grp_create(int ug)

I think you made the identifiers a bit too compact :)
s390_group_create() is not that long, and I have no idea what the 'ug'
(ugh :) parameter is supposed to mean.

> +{
> +    S390PCIGroup *grp;

group?

> +    S390pciState *s = s390_get_phb();
> +
> +    grp = g_new0(S390PCIGroup, 1);
> +    grp->ug = ug;
> +    QTAILQ_INSERT_TAIL(&s->zpci_grps, grp, link);

zpci_groups? I think you get the idea :)

> +    return grp;
> +}

(...)

No objection to the patch in general.


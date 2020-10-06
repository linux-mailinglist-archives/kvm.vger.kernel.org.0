Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3DC284F24
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFPm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJFPm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vO2eVO19u7tlXrnhV/2icdRGgCFWbaM14dT3Ql8zZo=;
        b=Igpi3lhVMNncHcpjayGcarg2mzW1oS+zai83QGAck4Y4/KT8DvyN5Z1uwdO4YKRP4frh0g
        LlNms0O2VQVJAW8Xgy58iDjZwJDJAp1Ar6PuxtQNzgBdSOfnAZ05HnCBhJ7KVAeuYSxKtE
        aKLBeGdD4gg6TTa4jgjEWJ0e3wGxOjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-nnxOiGPMNaKPSScMZnMUIQ-1; Tue, 06 Oct 2020 11:42:23 -0400
X-MC-Unique: nnxOiGPMNaKPSScMZnMUIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D0708015C7;
        Tue,  6 Oct 2020 15:42:22 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03D35D9CD;
        Tue,  6 Oct 2020 15:42:10 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:42:08 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 5/9] s390x/pci: create a header dedicated to PCI CLP
Message-ID: <20201006174208.1623ded9.cohuck@redhat.com>
In-Reply-To: <1601669191-6731-6-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
        <1601669191-6731-6-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:06:27 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> To have a clean separation between s390-pci-bus.h and s390-pci-inst.h
> headers we export the PCI CLP instructions in a dedicated header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  include/hw/s390x/s390-pci-bus.h  |   1 +
>  include/hw/s390x/s390-pci-clp.h  | 211 +++++++++++++++++++++++++++++++++++++++
>  include/hw/s390x/s390-pci-inst.h | 196 ------------------------------------
>  3 files changed, 212 insertions(+), 196 deletions(-)
>  create mode 100644 include/hw/s390x/s390-pci-clp.h 

(...)

> diff --git a/include/hw/s390x/s390-pci-clp.h b/include/hw/s390x/s390-pci-clp.h
> new file mode 100644
> index 0000000..e442307
> --- /dev/null
> +++ b/include/hw/s390x/s390-pci-clp.h
> @@ -0,0 +1,211 @@
> +/*
> + * s390 CLPinstruction definitions

s/CLPinstruction/CLP instruction/ ?

> + *
> + * Copyright 2019 IBM Corp.
> + * Author(s): Pierre Morel <pmorel@de.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


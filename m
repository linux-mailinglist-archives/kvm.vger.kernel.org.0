Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108861FAEF7
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFPLPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:15:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25286 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727969AbgFPLPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 07:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592306137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYSKsXL+pnx61xyecaq/GtOTccglyqOTBFHHIKn9p34=;
        b=NTunt4L/YOxkWV5D+M7EWtLmBkoBqy9LKPpryS9xxvkAN6neuYL87XbloPavNFCaAQxxeC
        su79pZ7RdDrPqQquW83L5A287KTvjtEl1C1VJsLxoRI26ceIfZ06EjF9fxrOblL4+Z6aQT
        TKG+8eYvOL6LgdqNLpP1KAk6FNMAWSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-GIrWrF5nNIy0nLIXdanXcw-1; Tue, 16 Jun 2020 07:15:36 -0400
X-MC-Unique: GIrWrF5nNIy0nLIXdanXcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC1C100A8F0;
        Tue, 16 Jun 2020 11:15:34 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B87C66ED96;
        Tue, 16 Jun 2020 11:15:22 +0000 (UTC)
Date:   Tue, 16 Jun 2020 13:15:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v4 02/21] vfio: Convert to ram_block_discard_disable()
Message-ID: <20200616131520.3eb92b8c.cohuck@redhat.com>
In-Reply-To: <20200610115419.51688-3-david@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
        <20200610115419.51688-3-david@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jun 2020 13:54:00 +0200
David Hildenbrand <david@redhat.com> wrote:

> VFIO is (except devices without a physical IOMMU or some mediated devices)
> incompatible with discarding of RAM. The kernel will pin basically all VM
> memory. Let's convert to ram_block_discard_disable(), which can now
> fail, in contrast to qemu_balloon_inhibit().
> 
> Leave "x-balloon-allowed" named as it is for now.
> 
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/vfio/ap.c                  | 10 +++----
>  hw/vfio/ccw.c                 | 11 ++++----
>  hw/vfio/common.c              | 53 +++++++++++++++++++----------------
>  hw/vfio/pci.c                 |  6 ++--
>  include/hw/vfio/vfio-common.h |  4 +--
>  5 files changed, 45 insertions(+), 39 deletions(-)

Did not have time to review in detail, but looks sane.

Acked-by: Cornelia Huck <cohuck@redhat.com>


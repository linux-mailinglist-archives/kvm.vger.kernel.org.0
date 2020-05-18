Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB281D74B7
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgERKGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:06:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgERKGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 06:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589796363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fz4ynS03WvX/2AkHFduj5e1SKrcKdNWHwhW4rgU70Y8=;
        b=HqTBlMrIpf7koKkLUj1CxDIzXAE9AJ8qxU75tkn6i6EDPLbyl6hBkHwHeGPB+GKRrVfsFJ
        Sf/iBShZM4JjYXEx5hDQmqDAvoLWTXmSAbtUzR6mLs2URBIDt4UpU6A+ubVrG4q924wmCP
        rxmfTJB5/vKKGgh90H1x/LmoElajlFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-I5e74_0KOEemx_ybx5rwHA-1; Mon, 18 May 2020 06:05:59 -0400
X-MC-Unique: I5e74_0KOEemx_ybx5rwHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B9ED835B8E;
        Mon, 18 May 2020 10:05:58 +0000 (UTC)
Received: from gondolin (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E7F45C1B2;
        Mon, 18 May 2020 10:05:57 +0000 (UTC)
Date:   Mon, 18 May 2020 12:05:54 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v4 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
Message-ID: <20200518120554.6b7b04cd.cohuck@redhat.com>
In-Reply-To: <20200505122745.53208-1-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 14:27:37 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Here is a new pass at the channel-path handling code for vfio-ccw.
> Changes from previous versions are recorded in git notes for each patch.
> Patches 5 through 7 got swizzled a little bit, in order to better
> compartmentalize the code they define. Basically, the IRQ definitions
> were moved from patch 7 to 5, and then patch 6 was placed ahead of
> patch 5.
> 
> I have put Conny's r-b's on patches 1, 3, 4, (new) 5, and 8, and believe
> I have addressed all comments from v3, with two exceptions:
> 
> > I'm wondering if we should make this [vfio_ccw_schib_region_{write,release}]
> > callback optional (not in this patch).  
> 
> I have that implemented on top of this series, and will send later as part
> of a larger cleanup series.
> 
> > One thing though that keeps coming up: do we need any kind of
> > serialization? Can there be any confusion from concurrent reads from
> > userspace, or are we sure that we always provide consistent data?  
> 
> I _think_ this is in good shape, though as suggested another set of
> eyeballs would be nice. There is still a problem on the main
> interrupt/FSM path, which I'm not attempting to address here.
> 
> With this code plus the corresponding QEMU series (posted momentarily)
> applied I am able to configure off/on a CHPID (for example, by issuing
> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
> events and reflect the updated path masks in its structures.
> 
> v3: https://lore.kernel.org/kvm/20200417023001.65006-1-farman@linux.ibm.com/
> v2: https://lore.kernel.org/kvm/20200206213825.11444-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/kvm/20191115025620.19593-1-farman@linux.ibm.com/
> 
> Eric Farman (3):
>   vfio-ccw: Refactor the unregister of the async regions
>   vfio-ccw: Refactor IRQ handlers
>   vfio-ccw: Add trace for CRW event
> 
> Farhan Ali (5):
>   vfio-ccw: Introduce new helper functions to free/destroy regions
>   vfio-ccw: Register a chp_event callback for vfio-ccw
>   vfio-ccw: Introduce a new schib region
>   vfio-ccw: Introduce a new CRW region
>   vfio-ccw: Wire up the CRW irq and CRW region
> 
>  Documentation/s390/vfio-ccw.rst     |  38 ++++++-
>  drivers/s390/cio/Makefile           |   2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 148 +++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 165 ++++++++++++++++++++++++++--
>  drivers/s390/cio/vfio_ccw_ops.c     |  65 ++++++++---
>  drivers/s390/cio/vfio_ccw_private.h |  16 +++
>  drivers/s390/cio/vfio_ccw_trace.c   |   1 +
>  drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
>  include/uapi/linux/vfio.h           |   3 +
>  include/uapi/linux/vfio_ccw.h       |  18 +++
>  10 files changed, 458 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
> 

Thanks, applied.

The documentation needed a bit of fiddling (please double-check), and I
think we want to document error codes for the schib/crw regions as
well. I can do that if I find time, but I'd also happily merge a patch.


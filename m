Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150A51C719C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgEFNYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:24:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728403AbgEFNYq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 09:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588771485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bQkhiRh6aOKR7Lu8ovPSdtiaKPC6f+b7Lgs40OlTFYA=;
        b=NbeW+4yS/NDAAiKEobTr+3UN31/rADg+N2cID+eHF+V2d0s1e0/TrrZR8XYBTQoqoEsC44
        J2H+Mm4Cc0zFXAMrsXvuB/F731dRmtINbUPe9OaNDbPx2l2KnQvlrzhdaEASf3FJGgWDlY
        k8j9TLFEywEVYibKDOeMPqlZHWe8PUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-Gh9zm_Q1PsujibftHx90iA-1; Wed, 06 May 2020 09:24:43 -0400
X-MC-Unique: Gh9zm_Q1PsujibftHx90iA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28A7F1009600;
        Wed,  6 May 2020 13:24:42 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA26526552;
        Wed,  6 May 2020 13:24:40 +0000 (UTC)
Date:   Wed, 6 May 2020 15:24:38 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v4 6/8] vfio-ccw: Introduce a new CRW region
Message-ID: <20200506152438.27bb3d39.cohuck@redhat.com>
In-Reply-To: <20200505122745.53208-7-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
        <20200505122745.53208-7-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 14:27:43 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> This region provides a mechanism to pass a Channel Report Word
> that affect vfio-ccw devices, and needs to be passed to the guest
> for its awareness and/or processing.
> 
> The base driver (see crw_collect_info()) provides space for two
> CRWs, as a subchannel event may have two CRWs chained together
> (one for the ssid, one for the subchannel).  As vfio-ccw will
> deal with everything at the subchannel level, provide space
> for a single CRW to be transferred in one shot.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v3->v4:
>      - Move crw_trigger and CRW_IRQ from later patch to here [EF]
>      - Cleanup descriptions of sizeof CRW region in doc, commentary,
>        and commit description [CH]
>      - Clear crw when finished [CH]
>     
>     v2->v3:
>      - Remove "if list-empty" check, since there's no list yet [EF]
>      - Reduce the CRW region to one fullword, instead of two [CH]
>     
>     v1->v2:
>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>      - Add a block comment to struct ccw_crw_region [CH]
>     
>     v0->v1: [EF]
>      - Clean up checkpatch (whitespace) errors
>      - Add ret=-ENOMEM in error path for new region
>      - Add io_mutex for region read (originally in last patch)
>      - Change crw1/crw2 to crw0/crw1
>      - Reorder cleanup of regions
> 
>  Documentation/s390/vfio-ccw.rst     | 19 ++++++++++
>  drivers/s390/cio/vfio_ccw_chp.c     | 55 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     |  8 +++++
>  drivers/s390/cio/vfio_ccw_private.h |  4 +++
>  include/uapi/linux/vfio.h           |  2 ++
>  include/uapi/linux/vfio_ccw.h       |  8 +++++
>  7 files changed, 116 insertions(+)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


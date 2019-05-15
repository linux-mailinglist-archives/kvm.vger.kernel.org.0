Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33A1F4B1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 14:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfEOMpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 08:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43963 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfEOMpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 08:45:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1582C057F40;
        Wed, 15 May 2019 12:45:33 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE3160BE5;
        Wed, 15 May 2019 12:45:32 +0000 (UTC)
Date:   Wed, 15 May 2019 14:45:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] s390: vfio-ccw fixes
Message-ID: <20190515144530.5603097b.cohuck@redhat.com>
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 15 May 2019 12:45:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 01:42:41 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The attached are a few fixes to the vfio-ccw kernel code for potential
> errors or architecture anomalies.  Under normal usage, and even most
> abnormal usage, they don't expose any problems to a well-behaved guest
> and its devices.  But, they are deficiencies just the same and could
> cause some weird behavior if they ever popped up in real life.
> 
> I have tried to arrange these patches in a "solves a noticeable problem
> with existing workloads" to "solves a theoretical problem with
> hypothetical workloads" order.  This way, the bigger ones at the end
> can be discussed without impeding the smaller and more impactful ones
> at the start.
> 
> Per the conversations on patch 7, the last several patches remain
> unchanged.  They continue to buid an IDAL for each CCW, and only pin
> guest pages and assign the resulting addresses to IDAWs if they are
> expected to cause a data transfer.  This will avoid sending an
> unmodified guest address, which may be invalid but anyway is not mapped
> to the same host address, in the IDAL sent to the channel subsystem and
> any unexpected behavior that may result.
> 
> They are based on 5.1.0, not Conny's vfio-ccw tree even though there are
> some good fixes pending for 5.2 there.  I've run this series both with
> and without that code, but couldn't decide which base would provide an
> easier time applying patches.  "I think" they should apply fine to both,
> but I apologize in advance if I guessed wrong!  :)

They also should apply on current master, no? My 5.2 branch should be
all merged by now :)

Nothing really jumped out at me; I'm happy to queue the patches if I
get some more feedback.

> 
> 
> Changelog:
>  v1 -> v2:
>   - Patch 1:
>      - [Cornelia] Added a code comment about why we update the SCSW when
>        we've gone past the end of the chain for normal, successful, I/O
>   - Patch 2:
>      - [Cornelia] Cleaned up the cc info in the commit message
>      - [Pierre] Added r-b
>   - Patch 3:
>      - [Cornelia] Update the return code information in prologue of
>        pfn_array_pin(), and then only call vfio_unpin_pages() if we
>        pinned anything, rather than silently creating an error
>        (this last bit was mentioned on patch 6, but applied here)
>      - [Eric] Clean up the error exit in pfn_array_pin()
>   - Patch 4-7 unchanged
> 
> Eric Farman (7):
>   s390/cio: Update SCSW if it points to the end of the chain
>   s390/cio: Set vfio-ccw FSM state before ioeventfd
>   s390/cio: Split pfn_array_alloc_pin into pieces
>   s390/cio: Initialize the host addresses in pfn_array
>   s390/cio: Allow zero-length CCWs in vfio-ccw
>   s390/cio: Don't pin vfio pages for empty transfers
>   s390/cio: Remove vfio-ccw checks of command codes
> 
>  drivers/s390/cio/vfio_ccw_cp.c  | 159 +++++++++++++++++++++++---------
>  drivers/s390/cio/vfio_ccw_drv.c |   6 +-
>  2 files changed, 119 insertions(+), 46 deletions(-)
> 


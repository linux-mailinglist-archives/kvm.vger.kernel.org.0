Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD16B48403
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFQNcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 09:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfFQNcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 09:32:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86B9730B9DE7;
        Mon, 17 Jun 2019 13:32:31 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A2893781;
        Mon, 17 Jun 2019 13:32:30 +0000 (UTC)
Date:   Mon, 17 Jun 2019 15:32:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/9] s390: vfio-ccw code rework
Message-ID: <20190617153228.0c5dca9f.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 17 Jun 2019 13:32:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:22 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Now that we've gotten a lot of other series either merged or
> pending for the next merge window, I'd like to revisit some
> code simplification that I started many moons ago.
> 
> In that first series, a couple of fixes got merged into 4.20,
> a couple more got some "seems okay" acks/reviews, and the rest
> were nearly forgotten about.  I dusted them off and did quite a
> bit of rework to make things a little more sequential and
> providing a better narrative (I think) based on the lessons we
> learned in my earlier changes.  Because of this rework, the
> acks/reviews on the first version didn't really translate to the
> code that exists here (patch 1 being the closest exception), so
> I didn't apply any of them here.  The end result is mostly the
> same as before, but now looks like this:
> 
> Patch summary:
> 1:   Squash duplicate code
> 2-4: Remove duplicate code in CCW processor
> 5-7: Remove one layer of nested arrays
> 8-9: Combine direct/indirect addressing CCW processors
> 
> Using 5.2.0-rc3 as a base plus the vfio-ccw branch of recent fixes,
> we shrink the code quite a bit (8.7% according to the bloat-o-meter),
> and we remove one set of mallocs/frees on the I/O path by removing
> one layer of the nested arrays.  There are no functional/behavioral
> changes with this series; all the tests that I would run previously
> continue to pass/fail as they today.
> 
> Changelog:
>  v1/RFC->v2:
>   - [Eric] Dropped first two patches, as they have been merged
>   - [Eric] Shuffling of patches for readability/understandability
>   - [Halil] Actually added meaningful comments/commit messages
>     in the patches
>  v1/RFC: https://patchwork.kernel.org/cover/10675251/
> 
> Eric Farman (9):
>   s390/cio: Squash cp_free() and cp_unpin_free()
>   s390/cio: Refactor the routine that handles TIC CCWs
>   s390/cio: Generalize the TIC handler
>   s390/cio: Use generalized CCW handler in cp_init()
>   vfio-ccw: Rearrange pfn_array and pfn_array_table arrays
>   vfio-ccw: Adjust the first IDAW outside of the nested loops
>   vfio-ccw: Remove pfn_array_table
>   vfio-ccw: Rearrange IDAL allocation in direct CCW
>   s390/cio: Combine direct and indirect CCW paths
> 
>  drivers/s390/cio/vfio_ccw_cp.c | 313 +++++++++++----------------------
>  1 file changed, 102 insertions(+), 211 deletions(-)
> 

Thanks, applied.

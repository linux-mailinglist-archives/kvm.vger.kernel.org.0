Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4F4401A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbfFMQDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389378AbfFMQCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:02:36 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2536D301E111;
        Thu, 13 Jun 2019 16:02:36 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33DED5E7A2;
        Thu, 13 Jun 2019 16:02:35 +0000 (UTC)
Date:   Thu, 13 Jun 2019 18:02:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 5/9] vfio-ccw: Rearrange pfn_array and
 pfn_array_table arrays
Message-ID: <20190613180232.3cbea661.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-6-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-6-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 13 Jun 2019 16:02:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:27 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> While processing a channel program, we currently have two nested
> arrays that carry a slightly different structure.  The direct CCW
> path creates this:
> 
>   ccwchain->pfn_array_table[1]->pfn_array[#pages]
> 
> while an IDA CCW creates:
> 
>   ccwchain->pfn_array_table[#idaws]->pfn_array[1]
> 
> The distinction appears to state that each pfn_array_table entry
> points to an array of contiguous pages, represented by a pfn_array,
> um, array.  Since the direct-addressed scenario can ONLY represent
> contiguous pages, it makes the intermediate array necessary but
> difficult to recognize.  Meanwhile, since an IDAL can contain
> non-contiguous pages and there is no logic in vfio-ccw to detect
> adjacent IDAWs, it is the second array that is necessary but appearing
> to be superfluous.
> 
> I am not aware of any documentation that states the pfn_array[] needs
> to be of contiguous pages; it is just what the code does today.
> I don't see any reason for this either, let's just flip the IDA
> codepath around so that it generates:
> 
>   ch_pat->pfn_array_table[1]->pfn_array[#idaws]
> 
> This will bring it in line with the direct-addressed codepath,
> so that we can understand the behavior of this memory regardless
> of what type of CCW is being processed.  And it means the casual
> observer does not need to know/care whether the pfn_array[]
> represents contiguous pages or not.
> 
> NB: The existing vfio-ccw code only supports 4K-block Format-2 IDAs,
> so that "#pages" == "#idaws" in this area.  This means that we will
> have difficulty with this overlap in terminology if support for
> Format-1 or 2K-block Format-2 IDAs is ever added.  I don't think that
> this patch changes our ability to make that distinction.

I agree; and knowing that later patches will simplify things further, I
think it will even be easier to do than on the current code base.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

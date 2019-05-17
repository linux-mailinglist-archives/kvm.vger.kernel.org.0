Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063ED215EC
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 11:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbfEQJGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 05:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfEQJGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 05:06:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0604B83F42;
        Fri, 17 May 2019 09:06:39 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C64D45C26A;
        Fri, 17 May 2019 09:06:37 +0000 (UTC)
Date:   Fri, 17 May 2019 11:06:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] s390/cio: Don't pin vfio pages for empty
 transfers
Message-ID: <20190517110635.5204a9e8.cohuck@redhat.com>
In-Reply-To: <20190516161403.79053-2-farman@linux.ibm.com>
References: <20190516161403.79053-1-farman@linux.ibm.com>
        <20190516161403.79053-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 17 May 2019 09:06:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 18:14:01 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The skip flag of a CCW offers the possibility of data not being
> transferred, but is only meaningful for certain commands.
> Specifically, it is only applicable for a read, read backward, sense,
> or sense ID CCW and will be ignored for any other command code
> (SA22-7832-11 page 15-64, and figure 15-30 on page 15-75).
> 
> (A sense ID is xE4, while a sense is x04 with possible modifiers in the
> upper four bits.  So we will cover the whole "family" of sense CCWs.)
> 
> For those scenarios, since there is no requirement for the target
> address to be valid, we should skip the call to vfio_pin_pages() and
> rely on the IDAL address we have allocated/built for the channel
> program.  The fact that the individual IDAWs within the IDAL are
> invalid is fine, since they aren't actually checked in these cases.
> 
> Set pa_nr to zero when skipping the pfn_array_pin() call, since it is
> defined as the number of pages pinned and is used to determine
> whether to call vfio_unpin_pages() upon cleanup.
> 
> As we do this, since the pfn_array_pin() routine returns the number of
> pages pinned, and we might not be doing that, the logic for converting
> a CCW from direct-addressed to IDAL needs to ensure there is room for
> one IDAW in the IDAL being built since a zero-length IDAL isn't great.

I have now read this sentence several times and that this and that
confuses me :) What are we doing, and what is the thing that we might
not be doing?

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 55 ++++++++++++++++++++++++++++++----
>  1 file changed, 50 insertions(+), 5 deletions(-)

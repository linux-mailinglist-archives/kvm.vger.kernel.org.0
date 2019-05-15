Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DB71F4A1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 14:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfEOMnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 08:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEOMnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 08:43:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62B448046F;
        Wed, 15 May 2019 12:43:08 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F51060166;
        Wed, 15 May 2019 12:43:07 +0000 (UTC)
Date:   Wed, 15 May 2019 14:43:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/7] s390/cio: Remove vfio-ccw checks of command
 codes
Message-ID: <20190515144305.46a2ecb1.cohuck@redhat.com>
In-Reply-To: <20190514234248.36203-8-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
        <20190514234248.36203-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 15 May 2019 12:43:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 01:42:48 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> If the CCW being processed is a No-Operation, then by definition no
> data is being transferred.  Let's fold those checks into the normal
> CCW processors, rather than skipping out early.
> 
> Likewise, if the CCW being processed is a "test" (an invented
> definition to simply mean it ends in a zero), let's permit that to go
> through to the hardware.  There's nothing inherently unique about
> those command codes versus one that ends in an eight [1], or any other
> otherwise valid command codes that are undefined for the device type
> in question.

Hm... let's tweak that a bit? It's not that "test" is an invented
category; it's just that this has not been a valid command for
post-s/370 and therefore should not get any special treatment and just
be sent to the hardware?

> 
> [1] POPS states that a x08 is a TIC CCW, and that having any high-order
> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
> high-order bits are ignored.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

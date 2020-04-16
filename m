Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7A1ABCFA
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 11:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503340AbgDPJhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 05:37:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32773 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2441116AbgDPJhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 05:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587029853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pj2Z5zIfZpfK9yoKUf7nhYIW+i/THuj4xzmXqydWcB0=;
        b=Es0KGflQV1MlrDr5IeaQVZ3uWxcl2+wxPUs3KgsDcnroEpWhrRVwJkn8IxJhergGYK7gNV
        ANNzj2vYLrHBhKRmTcIgP2H0YqNU1v0QLF0zD32iAF5uLcWPsHmoUCzQ+/S07rfKnLix93
        OALNWTli+KQqC2zMeixAvxrXWyqEdyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-yAynds6mNt64OS7LpyoNxA-1; Thu, 16 Apr 2020 05:37:31 -0400
X-MC-Unique: yAynds6mNt64OS7LpyoNxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62F3D18FF665;
        Thu, 16 Apr 2020 09:37:29 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20307116D94;
        Thu, 16 Apr 2020 09:37:23 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:37:21 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200416113721.124f9843.cohuck@redhat.com>
In-Reply-To: <35d8c3cb-78bb-8f84-41d8-c6e59d201ba0@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
        <20200414145851.562867ae.cohuck@redhat.com>
        <35d8c3cb-78bb-8f84-41d8-c6e59d201ba0@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 13:10:10 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 4/14/20 8:58 AM, Cornelia Huck wrote:
> > On Tue,  7 Apr 2020 15:20:03 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> +
> >> +	if (ap_drv->in_use)
> >> +		if (ap_drv->in_use(newapm, ap_perms.aqm))  
> > Can we log the offending apm somewhere, preferably with additional info
> > that allows the admin to figure out why an error was returned?  
> 
> One of the things on my TODO list is to add logging to the vfio_ap
> module which will track all significant activity within the device
> driver. I plan to do that with a patch or set of patches specifically
> put together for that purpose. Having said that, the best place to
> log this would be in the in_use callback in the vfio_ap device driver
> (see next patch) where the APQNs that are in use can be identified.
> For now, I will log a message to the dmesg log indicating which
> APQNs are in use by the matrix mdev.

Sounds reasonable. My main issue was what an admin was supposed to do
until logging was in place :)

> 
> >  
> >> +			rc = -EADDRINUSE;
> >> +
> >> +	module_put(drv->owner);
> >> +
> >> +	return rc;
> >> +}  


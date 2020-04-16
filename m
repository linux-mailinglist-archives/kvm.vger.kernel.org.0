Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DAD1ABCDB
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503664AbgDPJeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 05:34:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2503627AbgDPJeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 05:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587029648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0IPo0Ds7AJ1DPz8eMpn9oh2qqiK1Lq47iTdtzhbLqA=;
        b=Gniz1jrTBTi4yHD3V8vzE50KqILdfDjeF1VFsF7JwkL3QKruWMDUjwVymyKj9GGu4Dl+PU
        1MLA8G5QliAFBkERmwtevLStt2cRDGQ+FIgi14H4ZBb1YVVbF0lNL9DcSuzdB/8ZyxsEwp
        wynhBA3Ds3/CTjTUNZYkf5DVxK2P3hI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-tprWSifANDOm2c09AFcakQ-1; Thu, 16 Apr 2020 05:34:06 -0400
X-MC-Unique: tprWSifANDOm2c09AFcakQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22FDF107B769;
        Thu, 16 Apr 2020 09:34:04 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1BBD5DA2C;
        Thu, 16 Apr 2020 09:33:58 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:33:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, mjrosato@linux.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200416113356.28fcef8c.cohuck@redhat.com>
In-Reply-To: <82675d5c-4901-cbd8-9287-79133aa3ee68@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
        <20200414145851.562867ae.cohuck@redhat.com>
        <82675d5c-4901-cbd8-9287-79133aa3ee68@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 08:08:24 +0200
Harald Freudenberger <freude@linux.ibm.com> wrote:

> On 14.04.20 14:58, Cornelia Huck wrote:
> > On Tue,  7 Apr 2020 15:20:03 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> +	/* The non-default driver's module must be loaded */
> >> +	if (!try_module_get(drv->owner))
> >> +		return 0;  
> > Is that really needed? I would have thought that the driver core's
> > klist usage would make sure that the callback would not be invoked for
> > drivers that are not registered anymore. Or am I missing a window?  
> The try_module_get() and module_put() is a result of review feedback from
> my side. The ap bus core is static in the kernel whereas the
> vfio dd is a kernel module. So there may be a race condition between
> calling the callback function and removal of the vfio dd module.
> There is similar code in zcrypt_api which does the same for the zcrypt
> device drivers before using some variables or functions from the modules.
> Help me, it this is outdated code and there is no need to adjust the
> module reference counter any more, then I would be happy to remove
> this code :-)

I think the driver core already should keep us safe. A built-in bus
calling a driver in a module is a very common pattern, and I think
->owner was introduced exactly for that case.

Unless I'm really missing something obvious?


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39362C116C
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 18:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgKWRDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 12:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390215AbgKWRDg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 12:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606151015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KQjlYGpM0Jo472SEJajFJgHSfKbcvhfoBX2kIE5oOZw=;
        b=YU0yAUHYOOjTuWHPv6QylR1LfvSn/A83sczBrcmJxg/pYBkz9fySeJTOBNIaLnFYY5niwm
        nZ4+m5Z3ZVotzVKhx7xQITCHN6wRPripaUB+iH8vYoSSJN4Ja3dt/Xut1lJu+4cvKrLhgv
        GU7KrEhr4KJZXvQSsoo8q4G2qcdQMG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-WuQ-qpwTOPqDoVFfXdXKkw-1; Mon, 23 Nov 2020 12:03:31 -0500
X-MC-Unique: WuQ-qpwTOPqDoVFfXdXKkw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3055805BF6;
        Mon, 23 Nov 2020 17:03:28 +0000 (UTC)
Received: from gondolin (ovpn-113-104.ams2.redhat.com [10.36.113.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3909A5C1C4;
        Mon, 23 Nov 2020 17:03:19 +0000 (UTC)
Date:   Mon, 23 Nov 2020 18:03:16 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 05/14] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20201123180316.79273751.cohuck@redhat.com>
In-Reply-To: <20201114004722.76c999e0.pasic@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-6-akrowiak@linux.ibm.com>
        <20201027142711.1b57825e.pasic@linux.ibm.com>
        <6a5feb16-46b5-9dca-7e85-7d344b0ffa24@linux.ibm.com>
        <20201114004722.76c999e0.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 14 Nov 2020 00:47:22 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 13 Nov 2020 12:14:22 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> [..]
> > >>   }
> > >>   
> > >> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> > >> +			 "already assigned to %s"
> > >> +
> > >> +static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
> > >> +					 unsigned long *apm,
> > >> +					 unsigned long *aqm)
> > >> +{
> > >> +	unsigned long apid, apqi;
> > >> +
> > >> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
> > >> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> > >> +			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);  
> > > Isn't error rather severe for this? For my taste even warning would be
> > > severe for this.  
> > 
> > The user only sees a EADDRINUSE returned from the sysfs interface,
> > so Conny asked if I could log a message to indicate which APQNs are
> > in use by which mdev. I can change this to an info message, but it
> > will be missed if the log level is set higher. Maybe Conny can put in
> > her two cents here since she asked for this.
> >   
> 
> I'm looking forward to Conny's opinion. :)

(only just saw this; -ETOOMANYEMAILS)

It is probably not an error in the sense of "things are broken, this
cannot work"; but I'd consider this at least a warning "this does not
work as you intended".


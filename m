Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF55D1A276D
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgDHQqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:46:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40760 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgDHQqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 12:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586364381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OS1BYKCP7cBLf4oxAp06CiLumissixgN9CzFoFmvPFs=;
        b=g1fuDWN0gcw1sfLsyfBwPDsk2d0+OV8McPVZy1Mpta29aEKQXVDDo9203W8IyHSCt7F60c
        NfE2amgG38QUj9i4aJTkkhaIec8yl5uv+1q/RDFcyqgaW/4mwdGdbZft9ZGGiKRENlMdzs
        AaatgXkmg2xc0ZVSnVsyvVloSe+t69c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-q_lr7LQCNHOKfs94-AlDmw-1; Wed, 08 Apr 2020 12:46:19 -0400
X-MC-Unique: q_lr7LQCNHOKfs94-AlDmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AAA5801E5A;
        Wed,  8 Apr 2020 16:46:18 +0000 (UTC)
Received: from gondolin (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 908721195A4;
        Wed,  8 Apr 2020 16:46:09 +0000 (UTC)
Date:   Wed, 8 Apr 2020 18:46:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 06/15] s390/vfio-ap: sysfs attribute to display the
 guest CRYCB
Message-ID: <20200408184606.309d9cd9.cohuck@redhat.com>
In-Reply-To: <60c6bfb6-dd0a-75dc-1043-8dffe983220a@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-7-akrowiak@linux.ibm.com>
        <20200408123344.1a9032e1.cohuck@redhat.com>
        <60c6bfb6-dd0a-75dc-1043-8dffe983220a@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Apr 2020 12:38:49 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 4/8/20 6:33 AM, Cornelia Huck wrote:
> > On Tue,  7 Apr 2020 15:20:06 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The matrix of adapters and domains configured in a guest's CRYCB may
> >> differ from the matrix of adapters and domains assigned to the matrix mdev,
> >> so this patch introduces a sysfs attribute to display the CRYCB of a guest
> >> using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
> >> guest using the matrix mdev can be displayed as follows:
> >>
> >>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> >>
> >> If a guest is not using the matrix mdev at the time the crycb is displayed,
> >> an error (ENODEV) will be returned.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
> >>   1 file changed, 58 insertions(+)
> >> +static DEVICE_ATTR_RO(guest_matrix);  
> > Hm... should information like the guest configuration be readable by
> > everyone? Or should it be restricted a bit more?  
> 
> Why? The matrix attribute already displays the APQNs of the queues
> assigned to the matrix mdev. The guest_matrix attribute merely displays
> a subset of the matrix (i.e., the APQNs assigned to the mdev that reference
> queue devices bound to the vfio_ap device driver).
> 
> How can this be restricted?

I was thinking of using e.g. 400 instead of 444 for the permissions.

I'm not sure if the info about what subset of the queues the guest
actually uses is all that interesting (except for managing guests); but
if I see guest information being exposed, I get a little wary, so I
just stumbled over this.

Maybe I'll come back to that once I have looked at the series in more
detail, but this might not be a problem at all.

> 
> >  
> >> +
> >>   static struct attribute *vfio_ap_mdev_attrs[] = {
> >>   	&dev_attr_assign_adapter.attr,
> >>   	&dev_attr_unassign_adapter.attr,
> >> @@ -1050,6 +1107,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
> >>   	&dev_attr_unassign_control_domain.attr,
> >>   	&dev_attr_control_domains.attr,
> >>   	&dev_attr_matrix.attr,
> >> +	&dev_attr_guest_matrix.attr,
> >>   	NULL,
> >>   };
> >>     
> 


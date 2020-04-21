Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3671B24A2
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgDULIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:08:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726018AbgDULIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587467316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jh8uyTBGRxMFMAmO4slkY+3mJJQCYZxrQVfVGSajF/Q=;
        b=F1iuTGxfj4FLURMwHoXVadPYJN83gb+OC09cRq68heV46JjL7F9b3kpKjqSSYBPVk5MLug
        5fGgIgr9XpLdg5BHA++H8k54a6PwcWJR0MbgZ5eFtSKPYrFUvnWY5YnPcIEe5ENA7oT4jB
        33gXnxX22hB5fAYZ4f+fGu+wXQEz+3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-YZXOwKxNO6KCkA5lj1ag9Q-1; Tue, 21 Apr 2020 07:08:34 -0400
X-MC-Unique: YZXOwKxNO6KCkA5lj1ag9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3919A1085925;
        Tue, 21 Apr 2020 11:08:33 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C421E19C58;
        Tue, 21 Apr 2020 11:08:31 +0000 (UTC)
Date:   Tue, 21 Apr 2020 13:08:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 5/8] vfio-ccw: Introduce a new CRW region
Message-ID: <20200421130829.49144c72.cohuck@redhat.com>
In-Reply-To: <e24dfccc-d2b7-9a47-3cef-323c01797ee1@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
        <20200417023001.65006-6-farman@linux.ibm.com>
        <20200421114114.672f35a4.cohuck@redhat.com>
        <e24dfccc-d2b7-9a47-3cef-323c01797ee1@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Apr 2020 07:02:03 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 4/21/20 5:41 AM, Cornelia Huck wrote:
> > On Fri, 17 Apr 2020 04:29:58 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:

> >> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> >> index 98832d95f395..3338551ef642 100644
> >> --- a/Documentation/s390/vfio-ccw.rst
> >> +++ b/Documentation/s390/vfio-ccw.rst
> >> @@ -247,6 +247,22 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
> >>  Reading this region triggers a STORE SUBCHANNEL to be issued to the
> >>  associated hardware.
> >>  
> >> +vfio-ccw crw region
> >> +---------------------
> >> +
> >> +The vfio-ccw crw region is used to return Channel Report Word (CRW)
> >> +data to userspace::
> >> +
> >> +  struct ccw_crw_region {
> >> +         __u32 crw;
> >> +  } __packed;
> >> +
> >> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
> >> +
> >> +Currently, space is provided for a single CRW. Handling of chained
> >> +CRWs (not implemented in vfio-ccw) can be accomplished by re-reading
> >> +the region for additional CRW data.  
> > 
> > What about the following instead:
> > 
> > "Reading this region returns a CRW if one that is relevant for this
> > subchannel (e.g. one reporting changes in channel path state) is
> > pending, or all zeroes if not. If multiple CRWs are pending (including
> > possibly chained CRWs), reading this region again will return the next
> > one, until no more CRWs are pending and zeroes are returned. This is
> > similar to how STORE CHANNEL REPORT WORD works."  
> 
> Sounds good to me.
> 
> Hrm...  Maybe coffee hasn't hit yet.  Should I wire STCRW into this, or
> just rely on the notification from the host to trigger the read?

Userspace is supposed to use this to get crws to inject into the guest,
no stcrw involved until the guest actually got the machine check for it.


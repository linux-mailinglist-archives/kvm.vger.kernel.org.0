Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E5E1938D9
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 07:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgCZGtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 02:49:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51851 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbgCZGtG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 02:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585205344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=daV7nts9VUWz145xdDcmvCz2hORC30Bg7fJYrEUh55M=;
        b=S6saloZ6aPwHWih+muP+2BRqM7svp3/HjdfV5F7Vcld2zWSQM4kg1xBNkkWoGPC9q5BibU
        UJxy7P/DCTtiEqb8RsISOIBKum/DVYBaB7xIj+Hbh7m8KXWW3CPIdjdsvsVxQIxvZeiWsT
        BMOVJaLcf5GaxYSHwbdcdPq442DdbgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-XR0YdQPqPgeUnvTBV3umqA-1; Thu, 26 Mar 2020 02:48:05 -0400
X-MC-Unique: XR0YdQPqPgeUnvTBV3umqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9EC1107ACC4;
        Thu, 26 Mar 2020 06:48:03 +0000 (UTC)
Received: from gondolin (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4C859CA3;
        Thu, 26 Mar 2020 06:48:01 +0000 (UTC)
Date:   Thu, 26 Mar 2020 07:47:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/9] vfio-ccw: Register a chp_event callback for
 vfio-ccw
Message-ID: <20200326074759.5808c945.cohuck@redhat.com>
In-Reply-To: <302a0650-99b0-22ef-b95d-cecdeb0f9f04@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-3-farman@linux.ibm.com>
        <20200214131147.0a98dd7d.cohuck@redhat.com>
        <459a60d1-699d-2f16-bb59-23f11b817b81@linux.ibm.com>
        <20200324165854.3d862d5b.cohuck@redhat.com>
        <302a0650-99b0-22ef-b95d-cecdeb0f9f04@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020 22:09:40 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 3/24/20 11:58 AM, Cornelia Huck wrote:
> > On Fri, 14 Feb 2020 11:35:21 -0500
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> On 2/14/20 7:11 AM, Cornelia Huck wrote:  
> >>> On Thu,  6 Feb 2020 22:38:18 +0100
> >>> Eric Farman <farman@linux.ibm.com> wrote:  

> >>>> +	case CHP_ONLINE:
> >>>> +		/* Path became available */
> >>>> +		sch->lpm |= mask & sch->opm;    
> >>>
> >>> If I'm not mistaken, this patch introduces the first usage of sch->opm
> >>> in the vfio-ccw code.     
> >>
> >> Correct.
> >>  
> >>> Are we missing something?    
> >>
> >> Maybe?  :)
> >>  
> >>> Or am I missing
> >>> something? :)
> >>>     
> >>
> >> Since it's only used in this code, for acting as a step between
> >> vary/config off/on, maybe this only needs to be dealing with the lpm
> >> field itself?  
> > 
> > Ok, I went over this again and also looked at what the standard I/O
> > subchannel driver does, and I think this is fine, as the lpm basically
> > factors in the opm already. (Will need to keep this in mind for the
> > following patches.)  
> 
> Just to make sure I don't misunderstand, when you say "I think this is
> fine" ... Do you mean keeping the opm field within vfio-ccw, as this
> patch does?  Or removing it, and only adjusting the lpm within vfio-ccw,
> as I suggested in my response just above?

I meant the code change done in this patch: We update the lpm whenever
the opm is changed, and use the lpm. I'd like to keep the opm separate,
just so that we are clear where each value comes from.


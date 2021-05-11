Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFE37AC13
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhEKQhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:37:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhEKQhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa8ISZD+9VCaLFGh8Nx9yVUDD7ZejYAK3rK1NXQssoI=;
        b=KJgG9sjmBpB6ZtLa88Tye4D1/rPOMT5JGlKrECFRpq75tF0Cz+r7ZS13hLzBwDQk4BxNIp
        Orahjbe5589gWF7g78QcLvRNc61KCgPm6Vmf4ZdoqMyKJ1eow2YurHt+ovT2FYYVdvm754
        GIb45/Yo0MwdE1KoWYCHXuITos6SJwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-CX8DcdlfOQ6mrqGo36PzDA-1; Tue, 11 May 2021 12:36:30 -0400
X-MC-Unique: CX8DcdlfOQ6mrqGo36PzDA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DCB1801817;
        Tue, 11 May 2021 16:36:29 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C63F100164C;
        Tue, 11 May 2021 16:36:25 +0000 (UTC)
Date:   Tue, 11 May 2021 18:36:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature
 probing
Message-ID: <20210511183622.1251155d.cohuck@redhat.com>
In-Reply-To: <20210511174645.550c741d@ibm-vm>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
        <20210510150015.11119-3-frankja@linux.ibm.com>
        <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
        <20210511164137.0bba2493@ibm-vm>
        <2f0284e1-b1e0-39d6-1fe0-3be808be1849@redhat.com>
        <20210511174645.550c741d@ibm-vm>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 17:46:45 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Tue, 11 May 2021 17:38:04 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
> > On 11.05.21 16:41, Claudio Imbrenda wrote:  
> > > On Tue, 11 May 2021 13:43:36 +0200
> > > David Hildenbrand <david@redhat.com> wrote:
> > >     
> > >> On 10.05.21 17:00, Janosch Frank wrote:    
> > >>> Lets grab more of the feature bits from SCLP read info so we can
> > >>> use them in the cpumodel tests.
> > >>>
> > >>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > >>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > >>> ---
> > >>>    lib/s390x/sclp.c | 20 ++++++++++++++++++++
> > >>>    lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
> > >>>    2 files changed, 55 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> > >>> index f11c2035..f25cfdb2 100644
> > >>> --- a/lib/s390x/sclp.c
> > >>> +++ b/lib/s390x/sclp.c
> > >>> @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
> > >>>    	return (CPUEntry *)(_read_info +
> > >>> read_info->offset_cpu); }
> > >>>    
> > >>> +static bool sclp_feat_check(int byte, int mask)
> > >>> +{
> > >>> +	uint8_t *rib = (uint8_t *)read_info;
> > >>> +
> > >>> +	return !!(rib[byte] & mask);
> > >>> +}    
> > >>
> > >> Instead of a mask, I'd just check for bit (offset) numbers within
> > >> the byte.
> > >>
> > >> static bool sclp_feat_check(int byte, int bit)
> > >> {
> > >> 	uint8_t *rib = (uint8_t *)read_info;
> > >>
> > >> 	return !!(rib[byte] & (0x80 >> bit));
> > >> }    
> > > 
> > > using a mask might be useful to check multiple facilities at the
> > > same time, but in that case the check should be    
> > 
> > IMHO checking with a mask here multiple facilities will be very error 
> > prone either way ... and we only have a single byte to check for.  
> 
> as I said, I do not have a strong opinion either way :)
> 
> 

If you need a tie breaker, I'd vote for bit over mask :)


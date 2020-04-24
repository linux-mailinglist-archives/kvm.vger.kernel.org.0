Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDE1B7278
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDXKta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:49:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20454 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726289AbgDXKta (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587725368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rx2k1LEzWMhZb9b/yXIkzrrVo6d8zDbQRCXwJ86SySQ=;
        b=WQdPHNsWCu1K/LH/0W0hPCOEN+4iHghGF01A4BWhaJAqFlaUOP3hyyrag7MwsK+P0X9iEy
        2Wt+N4RzH5lMAiUD+Y8onUy2v2xn0+ibgvCAbCkf3qUKTQ9RGqFeYnh2g7AHvTney2s5Sr
        gSfEcAXwmmX+MYCTydsrOhW6QQSklPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-4QnMzKqZMWW2Kvuyi6xD3A-1; Fri, 24 Apr 2020 06:49:27 -0400
X-MC-Unique: 4QnMzKqZMWW2Kvuyi6xD3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ACE4855E04;
        Fri, 24 Apr 2020 10:49:26 +0000 (UTC)
Received: from gondolin (ovpn-112-240.ams2.redhat.com [10.36.112.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B89F260CD0;
        Fri, 24 Apr 2020 10:49:21 +0000 (UTC)
Date:   Fri, 24 Apr 2020 12:49:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 04/10] s390x: interrupt registration
Message-ID: <20200424124919.6c243286.cohuck@redhat.com>
In-Reply-To: <b5c02122-68a7-31e7-11e4-5f05403feb08@linux.ibm.com>
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
        <1582200043-21760-5-git-send-email-pmorel@linux.ibm.com>
        <c8d1081a-8e94-f28e-66e7-fe98aea31837@linux.ibm.com>
        <b5c02122-68a7-31e7-11e4-5f05403feb08@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 12:44:16 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-04-24 10:27, Janosch Frank wrote:
> > On 2/20/20 1:00 PM, Pierre Morel wrote:  
> >> Let's make it possible to add and remove a custom io interrupt handler,
> >> that can be used instead of the normal one.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >> Reviewed-by: David Hildenbrand <david@redhat.com>
> >> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   lib/s390x/interrupt.c | 22 +++++++++++++++++++++-
> >>   lib/s390x/interrupt.h |  7 +++++++
> >>   2 files changed, 28 insertions(+), 1 deletion(-)
> >>   create mode 100644 lib/s390x/interrupt.h
> >>

> >> +static void (*io_int_func)(void);
> >> +
> >>   void handle_io_int(void)
> >>   {
> >> +	if (*io_int_func)
> >> +		return (*io_int_func)();
> >>   	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
> >>   		     stap(), lc->io_old_psw.addr);
> >>   }
> >>   
> >> +int register_io_int_func(void (*f)(void))
> >> +{
> >> +	if (io_int_func)
> >> +		return -1;
> >> +	io_int_func = f;
> >> +	return 0;
> >> +}
> >> +
> >> +int unregister_io_int_func(void (*f)(void))
> >> +{
> >> +	if (io_int_func != f)
> >> +		return -1;
> >> +	io_int_func = NULL;
> >> +	return 0;
> >> +}  
> > 
> > I'm currently working on something similar for PGMs and I see no
> > additional value in two functions for this. Unregistering can be done by
> > doing register_io_int_func(NULL)
> > 
> > This should be enough:
> > 
> > int register_io_int_func(void (*f)(void))
> > {
> > 	io_int_func = f;
> > }

You can even make this void :)

> >   
> There are several ways to do this and I really don't mind how it is done.
> Since it has been reviewed by, I would like to have the others reviewers 
> opinion.

One version might make it easier to catch programming errors, while the
other one is more compact. I don't really have a preference on this,
either is fine with me.


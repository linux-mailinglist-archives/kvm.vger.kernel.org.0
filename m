Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FB9332CDE
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCIRJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:09:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231245AbhCIRIp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 12:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615309725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z81F3ToxTtoB+hBfmKgavO5HYdYeG5l9hwtNkEnMkNo=;
        b=LwnktTT8h/2b9wakGTIwiGslIKkmjzyRlsva8jY+htZ/lQEPeQvDZBAZ4OG3JcE9PT2XgA
        ZBslVxCEfr4ueHcPAGwGVqYMlxMdmqFWMJqNIrf7+7quPszNJgzseyHTj0NtU9agrAB0wJ
        9QeoSzoAPwyFJ+AOT5bOgzphlTlO1hQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-5tL9JaBvPjaHmg9tGOTwUg-1; Tue, 09 Mar 2021 12:08:43 -0500
X-MC-Unique: 5tL9JaBvPjaHmg9tGOTwUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C135364AD2;
        Tue,  9 Mar 2021 17:08:41 +0000 (UTC)
Received: from gondolin (ovpn-113-144.ams2.redhat.com [10.36.113.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BECC5C261;
        Tue,  9 Mar 2021 17:08:36 +0000 (UTC)
Date:   Tue, 9 Mar 2021 18:08:34 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 0/6] CSS Mesurement Block
Message-ID: <20210309180834.14945da1.cohuck@redhat.com>
In-Reply-To: <20210309175401.6302833e.cohuck@redhat.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
        <20210309175401.6302833e.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 17:54:01 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue,  9 Mar 2021 13:51:11 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > We tests the update of the Mesurement Block (MB) format 0
> > and format 1 using a serie of senseid requests.
> > 
> > *Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
> > unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
> > is applied.  
> 
> That one has hit QEMU master by now.
> 
> > With Protected Virtualization, the PGM is correctly recognized.
> > 
> > The MB format 1 is only provided if the Extended mesurement Block
> > feature is available.
> > 
> > This feature is exposed by the CSS characteristics general features
> > stored by the Store Channel Subsystem Characteristics CHSC command,
> > consequently, we implement the CHSC instruction call and the SCSC CHSC
> > command.
> > 
> > In order to ease the writing of new tests using:
> > - interrupt
> > - enablement of a subchannel
> > - multiple I/O on a subchannel
> > 
> > We do the following simplifications:
> > - we create a CSS initialization routine
> > - we register the I/O interrupt handler on CSS initialization
> > - we do not enable or disable a subchannel in the senseid test,
> >   assuming this test is done after the enable test, this allows
> >   to create traffic using the SSCH used by senseid.
> > - failures not part of the feature under test will stop the tests.
> > - we add a css_enabled() function to test if a subchannel is enabled.
> > 
> > *note*:
> >     I rearranged the use of the senseid for the tests, by not modifying
> >     the existing test and having a dedicated senseid() function for
> >     the purpose of the tests.
> >     I think that it is in the rigght way so I kept the RB and ACK on
> >     the simplification, there are less changes, if it is wrong from me
> >     I suppose I will see this in the comments.
> >     Since the changed are moved inside the fmt0 test which is not approved
> >     for now I hope it is OK.  
> 
> I'll double-check, but I think it should be ok.

...that said, I found some reordering issues, but nothing major;
generally, it looks good to me.

> 
> > 
> > Regards,
> > Pierre
> > 
> > Pierre Morel (6):
> >   s390x: css: Store CSS Characteristics
> >   s390x: css: simplifications of the tests
> >   s390x: css: extending the subchannel modifying functions
> >   s390x: css: implementing Set CHannel Monitor
> >   s390x: css: testing measurement block format 0
> >   s390x: css: testing measurement block format 1
> > 
> >  lib/s390x/css.h     | 115 ++++++++++++++++++++-
> >  lib/s390x/css_lib.c | 236 ++++++++++++++++++++++++++++++++++++++++----
> >  s390x/css.c         | 216 ++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 540 insertions(+), 27 deletions(-)
> >   
> 


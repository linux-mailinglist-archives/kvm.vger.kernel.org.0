Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B752A9310
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKFJqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgKFJqg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 04:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604655995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4QMXYId98ZoiJ+pAayk7nRCKSRkqsxFYcMBHQ/J/9ME=;
        b=W8Lscdw85v/EWOhaykOr/h5dcBui+yyWtcm+AFtX2Bo0Lq5oX94S7thwbRdjkUcXHAHQSy
        S2VAfW/HOHWuPOtLus7EfCiTYCV3f+Nkbah9yf9lI2W7MyLyjZiyaspK/x2jkh6urTkYmq
        0vInSr57r6aUkEsffZJ5e6MY7i20JSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-o-NBSfKYMEyjO9X9nIaIfQ-1; Fri, 06 Nov 2020 04:46:33 -0500
X-MC-Unique: o-NBSfKYMEyjO9X9nIaIfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E8791853DB1;
        Fri,  6 Nov 2020 09:46:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C57D81002C2A;
        Fri,  6 Nov 2020 09:46:26 +0000 (UTC)
Date:   Fri, 6 Nov 2020 10:46:24 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
Message-ID: <20201106094624.jcrowpqrexigyrj5@kamzik.brq.redhat.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
 <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
 <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
 <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 03:15:47PM +0100, Janosch Frank wrote:
> On 11/5/20 1:16 PM, Pierre Morel wrote:
> > 
> > 
> > On 9/29/20 9:19 AM, Janosch Frank wrote:
> >> On 9/28/20 5:31 PM, Cornelia Huck wrote:
> >>> On Mon, 28 Sep 2020 16:23:34 +0200
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>
> >>>> Some architectures need allocations to be done under a
> >>>> specific address limit to allow DMA from I/O.
> >>>>
> >>>> We propose here a very simple page allocator to get
> >>>> pages allocated under this specific limit.
> >>>>
> >>>> The DMA page allocator will only use part of the available memory
> >>>> under the DMA address limit to let room for the standard allocator.
> >>>>
> > 
> > ...snip...
> > 
> >>
> >> Before we start any other discussion on this patch we should clear up if
> >> this is still necessary after Claudio's alloc revamp.
> >>
> >> I think he added options to request special types of memory.
> > 
> > Isn't it possible to go on with this patch series.
> > It can be adapted later to the changes that will be introduced by 
> > Claudio when it is final.
> > 
> > 
> 
> Pierre, that's outside of my jurisdiction, you're adding code to the
> common code library.
> 
> I've set Paolo CC, let's see if he finds this thread :)
>

I'll also try to find some time to revisit this.

Thanks,
drew 


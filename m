Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6266387CE6
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbhERPx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 11:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243156AbhERPx4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 11:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621353156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5LMqI0lhO9Ys/kMfPgvFTZWjl7kX5k5QEuIhNJTDQZk=;
        b=AAeZJeB+mprq2oIZncecf42w8wqan6uVC6sLgA9iyLPSgfUcnliWdaZMO4XlYEjsGvHlv+
        Z8vts33FiIP6dMZFVKF0WkilLfToFxzdL1bkwcjL0ncxFpNtQVB94TBSd0eomXcW5sgIIi
        XOvWQZHlI2dQvV6+P5j9B48F482glX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-gvOjpajKPpOq89gkACHbCw-1; Tue, 18 May 2021 11:52:34 -0400
X-MC-Unique: gvOjpajKPpOq89gkACHbCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C931FCA4;
        Tue, 18 May 2021 15:52:33 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-74.ams2.redhat.com [10.36.113.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14EB81001B2C;
        Tue, 18 May 2021 15:52:27 +0000 (UTC)
Date:   Tue, 18 May 2021 17:52:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518175225.32f61744.cohuck@redhat.com>
In-Reply-To: <225fe3ec-f2e9-6c76-97e1-b252fe3326b3@de.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
        <20210518173624.13d043e3@ibm-vm>
        <225fe3ec-f2e9-6c76-97e1-b252fe3326b3@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 17:45:18 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.05.21 17:36, Claudio Imbrenda wrote:
> > On Tue, 18 May 2021 17:05:37 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:

> >> Can too many not-yet-cleaned-up pages lead to a (temporary) memory
> >> exhaustion?  
> > 
> > in case of reboot, not much; the pages were in use are still in use
> > after the reboot, and they can be swapped.
> > 
> > in case of a shutdown, yes, because the pages are really taken aside
> > and cleared/destroyed in background. they cannot be swapped. they are
> > freed immediately as they are processed, to try to mitigate memory
> > exhaustion scenarios.
> > 
> > in the end, this patchseries is a tradeoff between speed and memory
> > consumption. the memory needs to be cleared up at some point, and that
> > requires time.
> > 
> > in cases where this might be an issue, I introduced a new KVM flag to
> > disable lazy destroy (patch 10)  
> 
> Maybe we could piggy-back on the OOM-kill notifier and then fall back to
> synchronous freeing for some pages?

Sounds like a good idea. If delayed cleanup is safe, you probably want
to have the fast shutdown behaviour.


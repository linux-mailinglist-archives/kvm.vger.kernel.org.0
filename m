Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469691B5EB8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgDWPLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:11:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729028AbgDWPLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587654671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p98rCYJhtZR44ScMt2ctfYRg4qGKkTUSrXSjyzpvnXo=;
        b=V9aE5CMl2oJxT+DlZzmVYsM4/xMm+EeXTs5vb5033wL+u25x3K1doBgNJrIYn739ECKj6u
        L8pDhvmgsTiZeOioEL2n7dERpx5gyuB5Jq/2iTkawqywz9MgC2cE6dpndjY2uDNekKiHMv
        mS75GSByBEFDR7kICsDl0CfC2CrOY8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-O4prfYliPcqdEkCRMS9Erg-1; Thu, 23 Apr 2020 11:11:09 -0400
X-MC-Unique: O4prfYliPcqdEkCRMS9Erg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E7E3872FF0;
        Thu, 23 Apr 2020 15:11:08 +0000 (UTC)
Received: from gondolin (ovpn-112-121.ams2.redhat.com [10.36.112.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0E8D600F5;
        Thu, 23 Apr 2020 15:11:06 +0000 (UTC)
Date:   Thu, 23 Apr 2020 17:11:03 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Message-ID: <20200423171103.497dcd02.cohuck@redhat.com>
In-Reply-To: <20200423155620.493cb7cb.pasic@linux.ibm.com>
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
        <20200417182939.11460-2-jrossi@linux.ibm.com>
        <20200423155620.493cb7cb.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 15:56:20 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 17 Apr 2020 14:29:39 -0400
> Jared Rossi <jrossi@linux.ibm.com> wrote:
> 
> > Remove the explicit prefetch check when using vfio-ccw devices.
> > This check is not needed as all Linux channel programs are intended
> > to use prefetch and will be executed in the same way regardless.  
> 
> Hm. This is a guest thing or? So you basically say, it is OK to do
> this, because you know that the guest is gonna be Linux and that it
> the channel program is intended to use prefetch -- but the ORB supplied
> by the guest that designates the channel program happens to state the
> opposite.
> 
> Or am I missing something?

I see this as a kind of architecture compliance/ease of administration
tradeoff, as we none of the guests we currently support uses something
that breaks with prefetching outside of IPL (which has a different
workaround).

One thing that still concerns me a bit is debuggability if a future
guest indeed does want to dynamically rewrite a channel program: the
guest thinks it instructed the device to not prefetch, and then
suddenly things do not work as expected. We can log when a guest
submits an orb without prefetch set, but we can't find out if the guest
actually does something that relies on non-prefetch.

The only correct way to handle this would be to actually implement
non-prefetch processing, where I would not really know where to even
start -- and then we'd only have synthetic test cases, for now. None of
the options are pleasant :(


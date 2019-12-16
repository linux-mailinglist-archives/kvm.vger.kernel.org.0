Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84494120303
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 11:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfLPKyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 05:54:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727436AbfLPKyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 05:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576493660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKfanrHwOpmLcOycHLXxbfC4P1nz4bcChNMeZN9SUEc=;
        b=HqzcwU//qB1L3daKsu/Zqxse0toCaV6VLTqONCWDsR4A3XUxWApPNS9ns8c8pbBb3G3Qfc
        mc3jqjVYMliWMWldAXsRlIY7B0Nxk9AhAeHS6bdP33YIUtFt78OQgVNHS3TqOOuXlcgZy9
        IdoMX2yLd7AQYNlqtFysCHJeOLBgwOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-LsjyBCTiNTSq51hB6-ezjA-1; Mon, 16 Dec 2019 05:54:16 -0500
X-MC-Unique: LsjyBCTiNTSq51hB6-ezjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 862261005502;
        Mon, 16 Dec 2019 10:54:15 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCB346759E;
        Mon, 16 Dec 2019 10:54:11 +0000 (UTC)
Date:   Mon, 16 Dec 2019 11:54:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: css: ping pong
Message-ID: <20191216115409.3a89717a.cohuck@redhat.com>
In-Reply-To: <bb6c04a1-501c-16c4-107b-f10ac9d1e41d@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-10-git-send-email-pmorel@linux.ibm.com>
        <20191213105009.482bab48.cohuck@redhat.com>
        <bb6c04a1-501c-16c4-107b-f10ac9d1e41d@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Dec 2019 17:50:02 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-13 10:50, Cornelia Huck wrote:

> > [This also got me thinking about your start_subchannel function
> > again... do you also want to allow flags like e.g. SLI? It's not
> > unusual for commands to return different lengths of data depending on
> > what features are available; it might be worthwhile to allow short data
> > if you're not sure that e.g. a command returns either the short or the
> > long version of a structure.]  
> 
> I would prefer to keep simple it in this series if you agree.

Sure, that's fine.

> 
> AFAIU the current QEMU implementation use a fix length and if a short 
> read occurs it is an error.
> Since we test on PONG, there should be no error.

It all depends on how the QEMU device is supposed to work. For a
command reading/writing some data, I'd usually expect the following:

- If SLI is not set, require the length to be the exact value expected
  by the device; otherwise, generate an error.
- If SLI is set, require the length to be between the minimum length
  that makes sense and the full length of the buffer; otherwise,
  generate an error.

Of course, if minimum length == full length, SLI has no real effect :)

> 
> I agree that for a general test we should change this, but currently the 
> goal is just to verify that the remote device is PONG.
> 
> If we accept variable length, we need to check the length of what we 
> received, and this could need some infrastructure changes that I would 
> like to do later.

You mean at the device level? At the driver level (== here), you should
simply get an error or not, I guess.

> 
> When the series is accepted I will begin to do more complicated things like:
> - checking the exceptions for wrong parameters
>    This is the first I will add.

Agreed, that's probably the most useful one.

> - checking the response difference on flags (SLI, SKP)
> - using CC and CD flags for chaining
> - TIC, NOP, suspend/resume and PCI
> 
> These last one will be fun, we can also trying to play with prefetch 
> while at it. :)

I think any kind of ccw chain will already be fun :) It's probably not
so well tested anyway, as virtio is basically single-command.


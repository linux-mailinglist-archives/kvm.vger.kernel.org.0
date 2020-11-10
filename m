Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C72ADC8E
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 18:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgKJREk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 12:04:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730164AbgKJREk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 12:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605027878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9wOIuNHk1ihqz6rKln//hf0NFVwKup+mAShRMiRmYUs=;
        b=fuB+WNRv9HB2m/nET9r7aHa1HG6qO36BHNa2/kHUKilrFCGFfVy53lhm4l3vCzTIy5mVZm
        yd8Qf0YVtA4DK7Toh6zcqW14tw6Tbe6XVC0uhK6rGGg95No8bCaSrDM50oGi8oo3gul+9X
        JPTc1PAAzXG9/97fhjSGvWrQs5k6Llw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-LxUj6EBePXGROk4JDAN2Uw-1; Tue, 10 Nov 2020 12:04:36 -0500
X-MC-Unique: LxUj6EBePXGROk4JDAN2Uw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC5551052502;
        Tue, 10 Nov 2020 17:04:34 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75E5E5B4AE;
        Tue, 10 Nov 2020 17:04:31 +0000 (UTC)
Date:   Tue, 10 Nov 2020 10:04:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thanos Makatos <thanos.makatos@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        John Levon <levon@movementarian.org>,
        John G Johnson <john.g.johnson@oracle.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>
Subject: Re: clarifications on live migration in VFIO
Message-ID: <20201110100431.5edbf4f2@w520.home>
In-Reply-To: <MW2PR02MB3723556EAC82D2EAF13B54BD8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
References: <MW2PR02MB3723556EAC82D2EAF13B54BD8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Nov 2020 13:11:52 +0000
Thanos Makatos <thanos.makatos@nutanix.com> wrote:

> I'm implementing live migration and I have a few questions:
> 
> * Do the stop-and-copy and stopped states have any effect on the operation of
>   the device? E.g. is it legitimate to access registers of other regions except
>   the ones of the migration region? Can the device effectively "shut down"
>   apart from functionality related to handling the the stop-and-copy state?    

When the device is !_RUNNING it should perform no DMA, not process
interrupts, the internal state machine should not automatically
advance, etc.  I would think that a well behaved user should not access
the device at this point other than via the migration region, but things
like mmaps into a device could make that difficult to enforce w/o
invalidation and sigbus type behavior.  We'd generally consider
migration to be cooperative with the user, so as long as the user
cannot inject bogus state while stopped that could allow them to break
out of the device, I don't see it as necessary to block access.

> * What happens if an iteration has started (pending_bytes has been read), but
>   pending_bytes is read again without the migration data having been read
>   entirely? I suppose this is a user bug?

If data_offset is not read, pending_bytes can be repeatedly polled with
no breach in protocol.  It's only once data_offset is read that we
initiate an iteration where re-reading pending_bytes indicates the data
prepared by the vendor driver has been consumed.  It's my understanding
that once data_offset is read, it's the user's responsibility to
determine the size of the available data via data_size and consume it
from the migration region.  If pending_bytes is re-evaluated before
either of these it would be a breach of protocol and the results are
undefined.  Ideally sequencing at the target will detect this, worst
case it should be no different than misprogramming the device and it
can misbehave confined within it's resource restrictions, same as
modifying a stopped device.

> * Regarding the pending_bytes register, can its value fluctuate in time or must
>   it decrease monotonically and by data_size bytes during each iteration? E.g.
>   can the size of migration data increase during e.g. the pre-copy phase?

It's considered volatile, I believe the only protocol expectations are
around whether the value is zero or non-zero.
 
> * What are the semantics of reading data_offset or data_size if an iteration
>   hasn't started? I suppose the read value is undefined?

I know the docs say that reading pending_bytes indicates the start of
an iteration, but pending_bytes can also be re-read indefinitely.  The
data transfer of an iteration doesn't really begin until data_offset is
read.  The user having never read pending_bytes seems like a corner
case, we can't really put time bounds on the sequence of operations.
Therefore, I'd tend to expect data_offset to work like it's supposed
to, preparing data to be read.  Reading data_size out of sequence seems
undefined to me.  If the user doesn't read pending bytes to terminate
the iteration, they'll continue to be presented with the same data aiui.

> * Regarding the following statement:
> 
>  "Read on data_offset and data_size should return the offset and size of
>   the current buffer if the user application reads data_offset and
>   data_size more than once here."
>   
>   I'm not sure I understand here, does this mean that data_size and data_offset
>   don't change during an iteration, even if the user reads migration data
>   [with] multiple read(2) calls during an iteration?

Yes, I understand them to be invariant within the iteration, only the
first read of data_offset will induce the vendor driver to prepare
data, that data and the registers describing it can be re-read until
the iteration is concluded by reading pending_bytes.

Hopefully Kirti and Intel folks will chime in whether this matches
their implementation.  Thanks,

Alex


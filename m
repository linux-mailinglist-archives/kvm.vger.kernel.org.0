Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5BB2835EF
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJEMuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 08:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgJEMuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 08:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601902211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fu/eL/KDszZrvnK8wLNudcc5lSyxtGGtbRFa5WgiL1Y=;
        b=LLsurGfCl0xOmSVrgPbdSrALFzrinT0Qbyt6/l631dY2vG2eJspXYq1Z3uX9KFviQoXtIS
        YLkkrChgCNLcFvKQbRITYJULb3tBh1XsCJy7g/AzRxZqrEJx38qf4BbfCJlDzSrxtljQnp
        49rDrm5uGl0EjO/fW7qcrtRIHkxd/P4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-WXeIm161McmDWRVrig0Ipg-1; Mon, 05 Oct 2020 08:50:10 -0400
X-MC-Unique: WXeIm161McmDWRVrig0Ipg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E768F107ACF8;
        Mon,  5 Oct 2020 12:50:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB0495C221;
        Mon,  5 Oct 2020 12:49:57 +0000 (UTC)
Date:   Mon, 5 Oct 2020 14:49:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
Message-ID: <20201005124955.onvwzfx5zpcqopco@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
 <20201005143503.669922f5@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005143503.669922f5@ibm-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 02:35:03PM +0200, Claudio Imbrenda wrote:
> On Mon, 5 Oct 2020 13:54:42 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> [...]
> 
> > While doing a page allocator, the topology is not the only 
> > characteristic we may need to specify.
> > Specific page characteristics like rights, access flags, cache
> > behavior may be useful when testing I/O for some architectures.
> > This obviously will need some connection to the MMU handling.
> > 
> > Wouldn't it be interesting to use a bitmap flag as argument to 
> > page_alloc() to define separate regions, even if the connection with
> > the MMU is done in a future series?
> 
> the physical allocator is only concerned with the physical pages. if
> you need special MMU flags to be set, then you should enable the MMU
> and fiddle with the flags and settings yourself.
>

Given enough need, we could create a collection of functions like

 alloc_pages_ro()
 alloc_pages_uncached()
 ...

These functions wouldn't have generic implementations, only arch-specific
implementations, and those implementations would simply do a typical
allocation, followed by an iteration of each PTE where the arch-specific
flags get set.

Thanks,
drew


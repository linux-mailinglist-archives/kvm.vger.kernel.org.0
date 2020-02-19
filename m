Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01207165047
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 21:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgBSUw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 15:52:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726713AbgBSUw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 15:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582145577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A2RHU5VyNwtUUpMTMdrOWwP8lL7E1VPByJ14YfIWHKM=;
        b=Dmk2rLwJDNcAHAGvzwroQ0dU5ykKmt5ZbyB7Z1RhhVFMQPXM0Sx370DUvn7nr6A7vWeStd
        P7E2xwVdmPjR6IVH8e83n6ZebtPQS2s5douc5jiY4Iw5hLL2azEqhlN60aJL9usye4a4xb
        WQ1PKmeBYYRfokNvGBohS0iGPWeZ5p8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-YsNOfG4pPY2GExLNYJMCqg-1; Wed, 19 Feb 2020 15:52:50 -0500
X-MC-Unique: YsNOfG4pPY2GExLNYJMCqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E0351937FC3;
        Wed, 19 Feb 2020 20:52:49 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8BC5C13C;
        Wed, 19 Feb 2020 20:52:48 +0000 (UTC)
Date:   Wed, 19 Feb 2020 13:52:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] vfio/type1: Reduce vfio_iommu.lock contention
Message-ID: <20200219135247.42d18bb2@w520.home>
In-Reply-To: <20200219090417.GA30338@joy-OptiPlex-7040>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
        <20200117011050.GC1759@joy-OptiPlex-7040>
        <20200219090417.GA30338@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Feb 2020 04:04:17 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Jan 17, 2020 at 09:10:51AM +0800, Yan Zhao wrote:
> > Thank you, Alex!
> > I'll try it and let you know the result soon. :)
> > 
> > On Fri, Jan 17, 2020 at 02:17:49AM +0800, Alex Williamson wrote:  
> > > Hi Yan,
> > > 
> > > I wonder if this might reduce the lock contention you're seeing in the
> > > vfio_dma_rw series.  These are only compile tested on my end, so I hope
> > > they're not too broken to test.  Thanks,
> > > 
> > > Alex
> > > 
> > > ---
> > > 
> > > Alex Williamson (3):
> > >       vfio/type1: Convert vfio_iommu.lock from mutex to rwsem
> > >       vfio/type1: Replace obvious read lock instances
> > >       vfio/type1: Introduce pfn_list mutex
> > > 
> > > 
> > >  drivers/vfio/vfio_iommu_type1.c |   67 ++++++++++++++++++++++++---------------
> > >  1 file changed, 41 insertions(+), 26 deletions(-)
> > >  
> 
> hi Alex
> I have finished testing of this series.
> It's quite stable and passed our MTBF testing :)
> 
> However, after comparing the performance data obtained from several
> benchmarks in guests (see below),
> it seems that this series does not bring in obvious benefit.
> (at least to cases we have tested, and though I cannot fully explain it yet).
> So, do you think it's good for me not to include this series into my next
> version of "use vfio_dma_rw to read/write IOVAs from CPU side"?

Yes, I would not include it in your series.  No reason to bloat your
series for a feature that doesn't clearly show an improvement.  Thanks
for the additional testing, we can revive them if this lock ever
resurfaces.  I'm was actually more hopeful that holding an external
group reference might provide a better performance improvement, the
lookup on every vfio_dma_rw is not very efficient.  Thanks,

Alex


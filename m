Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46D16C013
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 12:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgBYL52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 06:57:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45289 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgBYL52 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 06:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582631846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IjgFx2gNue03GpLz7k8zfaeqI0G+XjMlbO0HtDdyUxk=;
        b=F6ZW5vjkF1AiTO1+FW/HPuoBkwDucZYHhLhwOzXvBX3SPc18xXwnrn0uRaAOJfoBGKKwvl
        PQK/hK59r7peT6jeDG0RdJYajo2jhLJnhT80h3TA/PWMMzeXD5i5Or/fSiiMJVRYiBjpJi
        OEohm2StItmNP13K/HfRwnkWTHnG4gc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-hyZiLNfSMxeSDCw1yfLllg-1; Tue, 25 Feb 2020 06:57:25 -0500
X-MC-Unique: hyZiLNfSMxeSDCw1yfLllg-1
Received: by mail-qt1-f199.google.com with SMTP id c8so14556409qte.22
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 03:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IjgFx2gNue03GpLz7k8zfaeqI0G+XjMlbO0HtDdyUxk=;
        b=g8Zv1fND0cDh9lg89ns9/KCJCdBVgcTF87MQceaXJyvqUcxsQNh9usx3+FCOvreYJx
         QWwDBQojXtV1F7oNsumjaGTpUNedEDtCf4Lew26Tum6dET7ogVQIGWb+EsLREGa5kr8w
         YTEr946wXTJC3sfmLBr7yovraj3fvd0vBB/3qsJrb3KEc/T3ApkNTveut7mhpzabKbIc
         Hytg8Qe3lQzU7ICBxT9ZQyTx3Z47Lhfil9Ojdy3042Thq1D/ESWo2Lchwfqw2UHVvX0L
         CKWlyJc2g3Cib2fs6DTbo3Uf8jJQ39DMCmzcjL3dEIZhqhp4TDXR1QscbcVG4QbHuX6X
         rmYA==
X-Gm-Message-State: APjAAAXuahmbRtjTDQ4js7K7TAhWCG2CAKHuFqjs/PSAYE95fTGt+X1V
        SkxecbEM7Rcpf+4maFwulKr9DEZSSEe5d09K66DtWRiVhQMvmE3U1hDKSuCkkNBwISX4QzTbWxr
        S1a8T36esy/60
X-Received: by 2002:a05:620a:214f:: with SMTP id m15mr52788851qkm.461.1582631845038;
        Tue, 25 Feb 2020 03:57:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPtnm4xJvcHCy5JfLYWZkvyhF/z/HHFDiFCAS4AO3eplgJLQuboFf3nUoKXmE5tDaZUc/FKw==
X-Received: by 2002:a05:620a:214f:: with SMTP id m15mr52788832qkm.461.1582631844813;
        Tue, 25 Feb 2020 03:57:24 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id f7sm7414909qtj.92.2020.02.25.03.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 03:57:23 -0800 (PST)
Date:   Tue, 25 Feb 2020 06:57:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, cohuck@redhat.com,
        slp@redhat.com, felipe@nutanix.com, john.g.johnson@oracle.com,
        robert.bradford@intel.com, Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200225065034-mutt-send-email-mst@kernel.org>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <20200224120522-mutt-send-email-mst@kernel.org>
 <20200225092434.GD4178@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225092434.GD4178@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 09:24:34AM +0000, Stefan Hajnoczi wrote:
> On Mon, Feb 24, 2020 at 12:10:25PM -0500, Michael S. Tsirkin wrote:
> > On Sat, Feb 22, 2020 at 08:19:16PM +0000, Stefan Hajnoczi wrote:
> > > The KVM_IOREGIONFD_POSTED_WRITES flag
> > > skips waiting for an acknowledgement on write accesses.  This is
> > > suitable for accesses that do not require synchronous emulation, such as
> > > doorbell register writes.
> > 
> > I would avoid hacks like this until we understand this better.
> > Specificlly one needs to be very careful since memory ordering semantics
> > can differ between a write into an uncacheable range and host writes into
> > a data structure. Reads from one region are also assumed to be ordered with
> > writes to another region, and drivers are known to make assumptions
> > like this.
> > 
> > Memory ordering being what it is, this isn't a field I'd be comfortable
> > device writes know what they are doing.
> 
> Unlike PCI Posted Writes the idea is not to let the write operations sit
> in a cache.  They will be sent immediately just like ioeventfd is
> signalled immediately before re-entering the guest.

But ioeventfd sits in the cache: the internal counter. The fact it's
signalled does not force a barrier on the signalling thread.  It looks
like the same happens here: value is saved with the file descriptor,
other accesses of the same device can bypass the write.

> The purpose of this feature is to let the device emulation program
> handle these writes asynchronously (without holding up the vCPU for a
> response from the device emulation program) but the order of
> reads/writes remains unchanged.
> 
> Stefan

I don't see how this can be implemented without guest changes though.
For example, how do you make sure two writes to such regions are ordered
just like they are on PCI?

-- 
MST


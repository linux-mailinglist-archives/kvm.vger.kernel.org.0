Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFC136146
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgAITjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:39:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729905AbgAITjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 14:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578598792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kb2vQrfoKpjSeL//XIyF85PILUK7bLDKHFU29Jc77FQ=;
        b=AqqO335b4VhZUEDWQL1zh3TCZS7HDWgjkKfXkWzU6suRMFy4uxxTnPI0dK0mAs/rAvfQ8b
        jIEr7pW5avc/rciG3IkL2kS1Lhwt84nZJYqjcNJel31NmO3quyjxxWGzRMUhUstIiQvIfZ
        fxQzAaf2bvIAanaTXL1ivuhc/orBJ0s=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-_j1VisGOOQS3F14nrpeHaw-1; Thu, 09 Jan 2020 14:39:51 -0500
X-MC-Unique: _j1VisGOOQS3F14nrpeHaw-1
Received: by mail-qv1-f72.google.com with SMTP id f16so4819275qvr.7
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:39:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kb2vQrfoKpjSeL//XIyF85PILUK7bLDKHFU29Jc77FQ=;
        b=s8NFq+vbE6fWxPWOwaWsK+PVLyOALX2RO6fM1Kh5JXV1nycANc26LvQ9F1VmNlYFMr
         fUu9V1gdCcMQF0IcdHUNMa5mjQAt2h0KWodt0nTYD/PsNf17RMDnuTqKvDU+Ix7RJXcz
         7ep7hyfS6g0yR1jZ102lFqwwNP3swx06WY/xinUiSL0qDql350mcanN42k2BoVmI0xDX
         RINg4mndnxoFdJYqKYpcabCMUpaMKNXeooR5iAqWlfhUJkVDbPa7+tQJis2QTgYpBeDo
         JvqtFK/gNOW/cE30hjwZ2SFe+ryd1EUoLz1IYrNBdQSYoXuFjT13tgsLqE4H6Kd24RZ2
         lsuQ==
X-Gm-Message-State: APjAAAUceU1/ex2TnWeENsxcx1ChiRcz49MWkMbVYa4vkNKkMyhL4VGN
        pstxGqKJa1IHar17iMnjkfMUu6S+D5Wxfub2o3yAG6U/q5nFQfdGUFWxu0K86uExjuF55ritG5k
        eruRRL/KM4QUU
X-Received: by 2002:ac8:6909:: with SMTP id e9mr9449261qtr.339.1578598791415;
        Thu, 09 Jan 2020 11:39:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmpSTaUwBhJTP7ZOnS+KZYWFlAWfDcxzaLmcjz7WS9B1GcqzT6ZUntOllSL94XygLzXh2UZw==
X-Received: by 2002:ac8:6909:: with SMTP id e9mr9449233qtr.339.1578598791201;
        Thu, 09 Jan 2020 11:39:51 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id i2sm3802548qte.87.2020.01.09.11.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:39:50 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:39:49 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109193949.GG36997@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
 <20200109170849.GB36997@xz-x1>
 <20200109133434-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109133434-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:08:52PM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 12:08:49PM -0500, Peter Xu wrote:
> > On Thu, Jan 09, 2020 at 11:40:23AM -0500, Michael S. Tsirkin wrote:
> > 
> > [...]
> > 
> > > > > I know it's mostly relevant for huge VMs, but OTOH these
> > > > > probably use huge pages.
> > > > 
> > > > Yes huge VMs could benefit more, especially if the dirty rate is not
> > > > that high, I believe.  Though, could you elaborate on why huge pages
> > > > are special here?
> > > > 
> > > > Thanks,
> > > 
> > > With hugetlbfs there are less bits to test: e.g. with 2M pages a single
> > > bit set marks 512 pages as dirty.  We do not take advantage of this
> > > but it looks like a rather obvious optimization.
> > 
> > Right, but isn't that the trade-off between granularity of dirty
> > tracking and how easy it is to collect the dirty bits?  Say, it'll be
> > merely impossible to migrate 1G-huge-page-backed guests if we track
> > dirty bits using huge page granularity, since each touch of guest
> > memory will cause another 1G memory to be transferred even if most of
> > the content is the same.  2M can be somewhere in the middle, but still
> > the same write amplify issue exists.
> >
> 
> OK I see I'm unclear.
> 
> IIUC at the moment KVM never uses huge pages if any part of the huge page is
> tracked.

To be more precise - I think it's per-memslot.  Say, if the memslot is
dirty tracked, then no huge page on the host on that memslot (even if
guest used huge page over that).

> But if all parts of the page are written to then huge page
> is used.

I'm not sure of this... I think it's still in 4K granularity.

> 
> In this situation the whole huge page is dirty and needs to be migrated.

Note that in QEMU we always migrate pages in 4K for x86, iiuc (please
refer to ram_save_host_page() in QEMU).

> 
> > PS. that seems to be another topic after all besides the dirty ring
> > series because we need to change our policy first if we want to track
> > it with huge pages; with that, for dirty ring we can start to leverage
> > the kvm_dirty_gfn.pad to store the page size with another new kvm cap
> > when we really want.
> > 
> > Thanks,
> 
> Seems like leaking implementation detail to UAPI to me.

I'd say it's not the only place we have an assumption at least (please
also refer to uffd_msg.pagefault.address).  IMHO it's not something
wrong because interfaces can be extended, but I am open to extending
kvm_dirty_gfn to cover a length/size or make the pad larger (as long
as Paolo is fine with this).

Thanks,

-- 
Peter Xu


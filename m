Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D001370C7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 16:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgAJPK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 10:10:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727855AbgAJPK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 10:10:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578669057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ltOkanThXPeot2TPJmTHUMaFNfpDV2RzAlhTkMJQWGk=;
        b=H8T3yVFWc297hFDXa3e69ogB98nvO/F30nQqWMxtj+SgSWnZUfrBtJNaPRNmGs4WgpiFg/
        Cdfq/7VxdNRxKZnG5aGYAWPHZKHioOjr63k+9PgMZxT0thSBNe4q00M0z01stijAtf3gYQ
        bWbhy5LHfv6FLIL1IWi8bzZt1zoPrmE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-X9VrFT03PSu4j2xJi0sSmQ-1; Fri, 10 Jan 2020 10:10:56 -0500
X-MC-Unique: X9VrFT03PSu4j2xJi0sSmQ-1
Received: by mail-qv1-f72.google.com with SMTP id di5so1345486qvb.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 07:10:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ltOkanThXPeot2TPJmTHUMaFNfpDV2RzAlhTkMJQWGk=;
        b=rjK1zgvf34iu9QYD5jHkeAErVi87FZyQCPHI+E8VkoWq4o6+eQIqo+hGMkb+jGG2JM
         LcL63iIQ7Tv19bkiIveybNUdq1OwfQM5zAZsPCKUTXGVj5j0bpAbBUDhbVIoiojGLTbl
         ti1exduOnTdspN5dzBYJGamWhGkwhNfTD+1PQQs+LYlrvBTCbwqonKcjox/xZ0c860M+
         TvtFCQ1to1QkM0I20bICnXHecgDG6TkQ+idEbeVLAFGORuKpfx21ypo8R6Gmio/lwdU/
         xNkkH1l5VRVHs7twAeg/z7W/1Ei2HrepoBQj/zBQywV86mavGNpgYDYceUQ+eWFRe0Iz
         lb3w==
X-Gm-Message-State: APjAAAVoDuJNacopBx3jblcN9TCmPZfodLwU1y3SNEJPV++H/n+yAN8e
        kUPkUcazUib6/E79gO+X88VQ3dfye/I2eD5Ryl+GC+p+bAL6/HLQC9EV2RVFuaKJlUVlgGmbN2t
        Kp/oe1fKcQtH7
X-Received: by 2002:aed:2bc2:: with SMTP id e60mr2811127qtd.115.1578669056113;
        Fri, 10 Jan 2020 07:10:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwz1r1ONGXTup5Yq+eOHuTwVk4LBOmjj/SDXS4nm/iC9Ca6WSmY4fOOxfZebKAczT+NKktz5g==
X-Received: by 2002:aed:2bc2:: with SMTP id e60mr2811109qtd.115.1578669055902;
        Fri, 10 Jan 2020 07:10:55 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id m5sm1118351qtq.6.2020.01.10.07.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:10:55 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:10:53 -0500
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
Message-ID: <20200110151053.GB53397@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
 <20200109170849.GB36997@xz-x1>
 <20200109133434-mutt-send-email-mst@kernel.org>
 <20200109193949.GG36997@xz-x1>
 <20200109172718-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109172718-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 05:28:36PM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 02:39:49PM -0500, Peter Xu wrote:
> > On Thu, Jan 09, 2020 at 02:08:52PM -0500, Michael S. Tsirkin wrote:
> > > On Thu, Jan 09, 2020 at 12:08:49PM -0500, Peter Xu wrote:
> > > > On Thu, Jan 09, 2020 at 11:40:23AM -0500, Michael S. Tsirkin wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > > I know it's mostly relevant for huge VMs, but OTOH these
> > > > > > > probably use huge pages.
> > > > > > 
> > > > > > Yes huge VMs could benefit more, especially if the dirty rate is not
> > > > > > that high, I believe.  Though, could you elaborate on why huge pages
> > > > > > are special here?
> > > > > > 
> > > > > > Thanks,
> > > > > 
> > > > > With hugetlbfs there are less bits to test: e.g. with 2M pages a single
> > > > > bit set marks 512 pages as dirty.  We do not take advantage of this
> > > > > but it looks like a rather obvious optimization.
> > > > 
> > > > Right, but isn't that the trade-off between granularity of dirty
> > > > tracking and how easy it is to collect the dirty bits?  Say, it'll be
> > > > merely impossible to migrate 1G-huge-page-backed guests if we track
> > > > dirty bits using huge page granularity, since each touch of guest
> > > > memory will cause another 1G memory to be transferred even if most of
> > > > the content is the same.  2M can be somewhere in the middle, but still
> > > > the same write amplify issue exists.
> > > >
> > > 
> > > OK I see I'm unclear.
> > > 
> > > IIUC at the moment KVM never uses huge pages if any part of the huge page is
> > > tracked.
> > 
> > To be more precise - I think it's per-memslot.  Say, if the memslot is
> > dirty tracked, then no huge page on the host on that memslot (even if
> > guest used huge page over that).
> 
> Yea ... so does it make sense to make this implementation detail
> leak through UAPI?

I think that's not a leak of internal implementation detail, we just
define the interface as that the address for each kvm_dirty_gfn is
always host page aligned (by default it means no huge page) and point
to a single host page, that's all.  Host page size is always there for
userspace after all so imho it's fine.  Thanks,

-- 
Peter Xu


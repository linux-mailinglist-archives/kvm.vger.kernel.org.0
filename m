Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12413633A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgAIW2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:28:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbgAIW2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 17:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578608924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yP6ZOz+k5yA79mKV5MErQ0ppXSFgMQpJyHWqxj1MuvU=;
        b=CB7M/SfWAjcl437dCzpu+YtPTlBkpcvHy5a46chtsj93k1GNRgVXJdl9+ai05di1/EYGLA
        dv67GPwew/zuHWyVkUnffjo44Jj1VInNRcevki2xdYQugEc10/dkdDKCce72z9t1AmhYjx
        JNFlaFy1OhpbR/mwwf71LH0+l3wxLy4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-uvysNUjQOligBtD2ab0I9Q-1; Thu, 09 Jan 2020 17:28:43 -0500
X-MC-Unique: uvysNUjQOligBtD2ab0I9Q-1
Received: by mail-qv1-f69.google.com with SMTP id l1so5083904qvu.13
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 14:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yP6ZOz+k5yA79mKV5MErQ0ppXSFgMQpJyHWqxj1MuvU=;
        b=q1VZSqK860i5goXd8wjW+R8H4yw3Xp1Jm0Q1q6vmJqBv+g0J/pzhnwtsGQKyFsblgp
         wG9n9ZzIPKmajTWfyE93RQE/JpL24gtlOqoipKWr6Ox+gC6SaM1PpDVt4rpA896RR+hd
         Fyymvu4qS2lXSwgaU8Y0Q89WQsdWInHnUz9VJkT2KN0CKCLZ/ULUZzjQD0pVveD+CHPh
         tGUwu/oiaj4Oy82li2FxEnq+POYI2PtuC/tEg7WTWV1Xl0CUBxQktHOhtW/xsteluing
         kAIbgadFqCu9Ef3ds+z4KDwkDc8AfmcGTjbOmdHilcBVAf4+j2LMtu+F6c96l4uTSG2z
         QGww==
X-Gm-Message-State: APjAAAWEBDTsJ46gGgWz+ePWh+7tTrbA/cW84GK4xypx9N6n9FoHWRzp
        zorw62ALYEUnRFH2fXRJCMO1pMfFckiRp/pFND7hNkqFjlEAoZCT/N6JcazhUwuECHvbNjHFMbt
        GepeiyotO62bh
X-Received: by 2002:ae9:ef4b:: with SMTP id d72mr144236qkg.27.1578608923201;
        Thu, 09 Jan 2020 14:28:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxFR4XfZTMuhobcGtdb+vjHM3K7vkFCIVeO74RUWN25HZ1Jkpn9V0d0fwI5Dt7sMPyDK0B8fA==
X-Received: by 2002:ae9:ef4b:: with SMTP id d72mr144221qkg.27.1578608922958;
        Thu, 09 Jan 2020 14:28:42 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id k9sm5457qtq.75.2020.01.09.14.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 14:28:41 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:28:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
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
Message-ID: <20200109172718-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
 <20200109170849.GB36997@xz-x1>
 <20200109133434-mutt-send-email-mst@kernel.org>
 <20200109193949.GG36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109193949.GG36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:39:49PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 02:08:52PM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 09, 2020 at 12:08:49PM -0500, Peter Xu wrote:
> > > On Thu, Jan 09, 2020 at 11:40:23AM -0500, Michael S. Tsirkin wrote:
> > > 
> > > [...]
> > > 
> > > > > > I know it's mostly relevant for huge VMs, but OTOH these
> > > > > > probably use huge pages.
> > > > > 
> > > > > Yes huge VMs could benefit more, especially if the dirty rate is not
> > > > > that high, I believe.  Though, could you elaborate on why huge pages
> > > > > are special here?
> > > > > 
> > > > > Thanks,
> > > > 
> > > > With hugetlbfs there are less bits to test: e.g. with 2M pages a single
> > > > bit set marks 512 pages as dirty.  We do not take advantage of this
> > > > but it looks like a rather obvious optimization.
> > > 
> > > Right, but isn't that the trade-off between granularity of dirty
> > > tracking and how easy it is to collect the dirty bits?  Say, it'll be
> > > merely impossible to migrate 1G-huge-page-backed guests if we track
> > > dirty bits using huge page granularity, since each touch of guest
> > > memory will cause another 1G memory to be transferred even if most of
> > > the content is the same.  2M can be somewhere in the middle, but still
> > > the same write amplify issue exists.
> > >
> > 
> > OK I see I'm unclear.
> > 
> > IIUC at the moment KVM never uses huge pages if any part of the huge page is
> > tracked.
> 
> To be more precise - I think it's per-memslot.  Say, if the memslot is
> dirty tracked, then no huge page on the host on that memslot (even if
> guest used huge page over that).

Yea ... so does it make sense to make this implementation detail
leak through UAPI?

> > But if all parts of the page are written to then huge page
> > is used.
> 
> I'm not sure of this... I think it's still in 4K granularity.
> 
> > 
> > In this situation the whole huge page is dirty and needs to be migrated.
> 
> Note that in QEMU we always migrate pages in 4K for x86, iiuc (please
> refer to ram_save_host_page() in QEMU).
> 
> > 
> > > PS. that seems to be another topic after all besides the dirty ring
> > > series because we need to change our policy first if we want to track
> > > it with huge pages; with that, for dirty ring we can start to leverage
> > > the kvm_dirty_gfn.pad to store the page size with another new kvm cap
> > > when we really want.
> > > 
> > > Thanks,
> > 
> > Seems like leaking implementation detail to UAPI to me.
> 
> I'd say it's not the only place we have an assumption at least (please
> also refer to uffd_msg.pagefault.address).  IMHO it's not something
> wrong because interfaces can be extended, but I am open to extending
> kvm_dirty_gfn to cover a length/size or make the pad larger (as long
> as Paolo is fine with this).
> 
> Thanks,
> 
> -- 
> Peter Xu


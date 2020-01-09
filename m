Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF11360C5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbgAITJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:09:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732054AbgAITJC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 14:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578596941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wn5Zuv80xKOsac1lq8/+TruwlKdERakoNi7IK73yy/E=;
        b=bJhJEPjmQLUHdDbknqPwk4TWawao7hWgB+WqwcdoKJzowLPksmCIgwfl6rJOZzzojYtZm9
        7UDSOpGt/V++QT5tRmC7GLi1IcaIlgNKUMR25jz0SWXMPErlUBrauPNUooO0K8VmDZx9Ik
        rbK4kgYNx0gTFoYnmVzWHHbxHUGIK1s=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-5FsWejImMY6D8ZPw90mvoQ-1; Thu, 09 Jan 2020 14:09:00 -0500
X-MC-Unique: 5FsWejImMY6D8ZPw90mvoQ-1
Received: by mail-qv1-f70.google.com with SMTP id e26so4740076qvb.4
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wn5Zuv80xKOsac1lq8/+TruwlKdERakoNi7IK73yy/E=;
        b=SISokm38axMWIYLO3BNiSS1i9cw+z13C+mB2kC8n7HKTi16a7YK7FYpjrh6EbXuxLJ
         SyL3hW4+HrcRJkLxvPqoI2h2egZPXu9lzeJQzFODZ1WtEp0e3+HAphdXsj3cKaoathmV
         lj+d77WatgV2BqJpMYYkpABWdfJb5wiVc47e3kB1I8woXbCX93f4TvX3OYTk038Ckh2L
         njWn8aSTJsFv5zBZaC5X6GBQsYgZJaNcvKpKQ46hKzbFx6CHNm2SiGcRfZUzWGuyZH4L
         kfAzIiXqdY1v3xNDsUEIH+tM/uEYrhy7WiA0qm4GOawgAmnw9n3rs/f5pXYUt+MO8esH
         XCTw==
X-Gm-Message-State: APjAAAXn+qKrnohjW30+dnACFrVXh+fRzDaERQoi/wUfMDuX0h4Fakcf
        ktGz/mMVXR3O4IgG2Gtdsq+Yx6wgQUVCwuci5KeWyCUwVcU9dElM8l2Q02hej30jDJtCyG8H8RO
        6BbvTWVzziYcT
X-Received: by 2002:a37:6706:: with SMTP id b6mr10292492qkc.461.1578596940069;
        Thu, 09 Jan 2020 11:09:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLdjByYVhr9xxDwDxgAlgb4WngV9KzL1B4XjIChNcIFtx+pqdlEgKRsk5TjL575If71IHHaQ==
X-Received: by 2002:a37:6706:: with SMTP id b6mr10292474qkc.461.1578596939851;
        Thu, 09 Jan 2020 11:08:59 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id p185sm3525999qkd.126.2020.01.09.11.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:08:58 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:08:52 -0500
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
Message-ID: <20200109133434-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
 <20200109170849.GB36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109170849.GB36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 12:08:49PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 11:40:23AM -0500, Michael S. Tsirkin wrote:
> 
> [...]
> 
> > > > I know it's mostly relevant for huge VMs, but OTOH these
> > > > probably use huge pages.
> > > 
> > > Yes huge VMs could benefit more, especially if the dirty rate is not
> > > that high, I believe.  Though, could you elaborate on why huge pages
> > > are special here?
> > > 
> > > Thanks,
> > 
> > With hugetlbfs there are less bits to test: e.g. with 2M pages a single
> > bit set marks 512 pages as dirty.  We do not take advantage of this
> > but it looks like a rather obvious optimization.
> 
> Right, but isn't that the trade-off between granularity of dirty
> tracking and how easy it is to collect the dirty bits?  Say, it'll be
> merely impossible to migrate 1G-huge-page-backed guests if we track
> dirty bits using huge page granularity, since each touch of guest
> memory will cause another 1G memory to be transferred even if most of
> the content is the same.  2M can be somewhere in the middle, but still
> the same write amplify issue exists.
>

OK I see I'm unclear.

IIUC at the moment KVM never uses huge pages if any part of the huge page is
tracked. But if all parts of the page are written to then huge page
is used.

In this situation the whole huge page is dirty and needs to be migrated.

> PS. that seems to be another topic after all besides the dirty ring
> series because we need to change our policy first if we want to track
> it with huge pages; with that, for dirty ring we can start to leverage
> the kvm_dirty_gfn.pad to store the page size with another new kvm cap
> when we really want.
> 
> Thanks,

Seems like leaking implementation detail to UAPI to me.


> -- 
> Peter Xu


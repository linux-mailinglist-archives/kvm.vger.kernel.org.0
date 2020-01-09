Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164E9135EE6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgAIRI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:08:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387970AbgAIRI4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 12:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578589735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NNEsFj/o0jBF/fCYORNopN7APt59GO74aaqbRZLn7eo=;
        b=Fywyu/96WhEDJx+zzrSUAq1Yr8ZB7MSyM7GtHydOfElpzx4XLoy3V4R/IGeKdiX1U2tXvF
        My2utxfJ0pz+GezmgJVz/cNCZeHEKzy9+uii6XQoYJoEmZXNZPKuWxNPoIvZ0hv4K4pojN
        okVI+Py5k2+WhtDTR4xWFrAuMHOnCao=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-jTm5lbTXOUSw0KCNbxoYEg-1; Thu, 09 Jan 2020 12:08:52 -0500
X-MC-Unique: jTm5lbTXOUSw0KCNbxoYEg-1
Received: by mail-qv1-f70.google.com with SMTP id g15so4513138qvk.11
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 09:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NNEsFj/o0jBF/fCYORNopN7APt59GO74aaqbRZLn7eo=;
        b=noMrF8hLoLeKz0nuDOYqZda8eEHhgiKy9e+Xv6R9vu8puqzt01Eqr0VHKCJkLlY0Ao
         XrK+Qo7ZLfZFBJk6GQHItXAv5Nqhr/uOb148ye1Qw2kFELHpseX/vhcXQfgrz9Mbn8iw
         jg+WmZQi33WE+U3bPFyGRN0AXcbl9DjoLEnwPAgng/M5lwFSRh7WB9g6WkXE4PuJ2Ea/
         ILaAE7oURmh7fhDbuldaSARwlzJDxSalRgnOb2dbfY4Du6aABoJdKeu3rgFxKwMs4aph
         ePu7tLmSpoFPY6So0a1h4AtaNDNiMlQYYRlXiJj9U8gpo8q4k2WQdn+xMDKbAOmPcQju
         jJnQ==
X-Gm-Message-State: APjAAAV4aVSdSbQDLSVoDRRjbE3DgjUsPX7wSibAa5/021X8ALSzxdtO
        ccEb2MGXzivdo8PYU83tn9hrerPYOCi3Kh9IVKXdWCjXB2rZqLjcvmGu4DXKDrvASPH1kEzLplg
        v3i425Mcz0mzx
X-Received: by 2002:ac8:59:: with SMTP id i25mr8915422qtg.110.1578589731670;
        Thu, 09 Jan 2020 09:08:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmi+GInpmAyf4dUoy+x6coGpcUyilqGJsYyHvmUNTmQpEgNWR+lquAycQvqlL2YFSE84UNug==
X-Received: by 2002:ac8:59:: with SMTP id i25mr8915400qtg.110.1578589731447;
        Thu, 09 Jan 2020 09:08:51 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h34sm3670383qtc.62.2020.01.09.09.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 09:08:50 -0800 (PST)
Date:   Thu, 9 Jan 2020 12:08:49 -0500
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
Message-ID: <20200109170849.GB36997@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109113001-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 11:40:23AM -0500, Michael S. Tsirkin wrote:

[...]

> > > I know it's mostly relevant for huge VMs, but OTOH these
> > > probably use huge pages.
> > 
> > Yes huge VMs could benefit more, especially if the dirty rate is not
> > that high, I believe.  Though, could you elaborate on why huge pages
> > are special here?
> > 
> > Thanks,
> 
> With hugetlbfs there are less bits to test: e.g. with 2M pages a single
> bit set marks 512 pages as dirty.  We do not take advantage of this
> but it looks like a rather obvious optimization.

Right, but isn't that the trade-off between granularity of dirty
tracking and how easy it is to collect the dirty bits?  Say, it'll be
merely impossible to migrate 1G-huge-page-backed guests if we track
dirty bits using huge page granularity, since each touch of guest
memory will cause another 1G memory to be transferred even if most of
the content is the same.  2M can be somewhere in the middle, but still
the same write amplify issue exists.

PS. that seems to be another topic after all besides the dirty ring
series because we need to change our policy first if we want to track
it with huge pages; with that, for dirty ring we can start to leverage
the kvm_dirty_gfn.pad to store the page size with another new kvm cap
when we really want.

Thanks,

-- 
Peter Xu


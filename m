Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51817135E7E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbgAIQke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:40:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728027AbgAIQkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S/z9cSjm4MFRCg23zobmeqQEga1mN5PQBjlffN7ciXs=;
        b=O8EeG0/035x8rqyPf+qadBf+enbPclyHXSTN/ep+W5Llokis2du4POnxCkpYOPGzFi8Q2J
        Z6fMBwXlb4aiKgT3cDRNlbc15kGwnrbVvZ7c8weH+K1BWUAv3/6d8w4apgvdCAwr/OKiMP
        v92LOnuH+qsZ4NlHTRMMylxQassETEo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-CXOUJJu9N7-nsrZvXHMx-g-1; Thu, 09 Jan 2020 11:40:30 -0500
X-MC-Unique: CXOUJJu9N7-nsrZvXHMx-g-1
Received: by mail-qv1-f69.google.com with SMTP id ce17so4499562qvb.5
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 08:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S/z9cSjm4MFRCg23zobmeqQEga1mN5PQBjlffN7ciXs=;
        b=cZdtdRRrWg1F3z50RuAbIveoIo4jlfaS8nXZWNfXXtMpcbvEw0fVdlexaezQXu81h1
         bDSX3RT+wloI2P9pacS85oCgkO4+p97PEUm0tBalGizDKDmoPltxsC7ePUgV76z4vmIS
         N6ZspPxTu52pZ8wyP0QD0+xr5Gd/ke5i/eMvPBRVwEwaHRrq8y1BDwS1PRaWepEEb6fv
         7XyjZy5ln2tMVTaMCP8kcwAQnRzwJ2kj/xa4t8SRKyYx7j2RQCe77+hPjjJgywtHYQM+
         HX7PlRpW7TUCO4Vg3PgSk+Q8VgrBi/VGKPYuoB3u4kIP16iEDQpe5cRC/GcJYlilTkeN
         /43g==
X-Gm-Message-State: APjAAAVWKmJLEPd2ryNgXz5xJswZWqqw29ims6o5D7g9gVpOOgY5vUQc
        3BdEx/hF+elP2VF4oMOfwY6PeE9OLv8VOyGFgASdYksCq++k1L1oARzzSkkmLlVz7ezMze81k0t
        udhFrZB/rOcU7
X-Received: by 2002:ae9:c318:: with SMTP id n24mr10603487qkg.38.1578588030513;
        Thu, 09 Jan 2020 08:40:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDVYHhz9ZSpnK4rVVgNRnHdbjFbv/jn4JOFdx9W3R587rNjBIdioKEtRvSFXqG5VWAVpZcXQ==
X-Received: by 2002:ae9:c318:: with SMTP id n24mr10603463qkg.38.1578588030295;
        Thu, 09 Jan 2020 08:40:30 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id s27sm3265926qkm.97.2020.01.09.08.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:40:29 -0800 (PST)
Date:   Thu, 9 Jan 2020 11:40:23 -0500
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
Message-ID: <20200109113001-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109161742.GC15671@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 11:17:42AM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 10:59:50AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 09, 2020 at 09:57:08AM -0500, Peter Xu wrote:
> > > Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> > > (based on kvm/queue)
> > > 
> > > Please refer to either the previous cover letters, or documentation
> > > update in patch 12 for the big picture.
> > 
> > I would rather you pasted it here. There's no way to respond otherwise.
> 
> Sure, will do in the next post.
> 
> > 
> > For something that's presumably an optimization, isn't there
> > some kind of testing that can be done to show the benefits?
> > What kind of gain was observed?
> 
> Since the interface seems to settle soon, maybe it's time to work on
> the QEMU part so I can give some number.  It would be interesting to
> know the curves between dirty logging and dirty ring even for some
> small vms that have some workloads inside.
> 
> > 
> > I know it's mostly relevant for huge VMs, but OTOH these
> > probably use huge pages.
> 
> Yes huge VMs could benefit more, especially if the dirty rate is not
> that high, I believe.  Though, could you elaborate on why huge pages
> are special here?
> 
> Thanks,

With hugetlbfs there are less bits to test: e.g. with 2M pages a single
bit set marks 512 pages as dirty.  We do not take advantage of this
but it looks like a rather obvious optimization.

> -- 
> Peter Xu


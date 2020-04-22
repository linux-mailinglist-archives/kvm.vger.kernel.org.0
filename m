Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678511B4CE6
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 20:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgDVSwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 14:52:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgDVSwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 14:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587581523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=trPq/Y5FosLGaXOvjfTLOLDEExV7IW7COeIEuuhVB14=;
        b=XkMce8TUoquSKvS4DOBlcf66Kw81AexoNioLCT6+1dWb2X0WGy8f8ljUIKwxcwojLCnMAw
        M+eXSYqU38lNcEYG9+hUQXRiLRxLDq6MPOp3NKvKs9q+BkXk2HvsInNwAWkSx0lmVDmmwd
        ZheWa3yJqY7DnuhY9Rg4BOBPpKt0vag=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-CoEbegW3PI-9MvfbkA0Rqw-1; Wed, 22 Apr 2020 14:51:59 -0400
X-MC-Unique: CoEbegW3PI-9MvfbkA0Rqw-1
Received: by mail-qv1-f71.google.com with SMTP id u5so3382050qvt.12
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 11:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=trPq/Y5FosLGaXOvjfTLOLDEExV7IW7COeIEuuhVB14=;
        b=mBjajRkeK7+RflYoEI4PY8bOAIv8s/5v+BZ2W0JS81fm4eVB11+068zKrsaWC9fFK9
         XwAA6JidsqV1D19M6bh+GVH2KO1W07RWNmmrRZDFzqbH3iaNUW2u7Ins13HiHemg9G3m
         z7CxG53QI2AeZ6kHtUxmqptzKH0FWajoUyUAOBFnuEJvvG8hZWsrwXx9I2/h7qmjh9da
         8yjoq1by2nM55JvyRzyWUiIXlxuw/rW37UuSqUXhhkuMua4nj0E6q9U1nQY4/nAdpO2x
         ThTbVh4P5TTvbX1ekG9OIclHL178fiUpwA2Jhu8CLrx7cv8ShHLHzo1dsHy6bXKoQp4+
         s9gw==
X-Gm-Message-State: AGi0Pua0rrCo3AYp6l8pMx+B/tuQxp2wC7EXa1lNmQZ4X6Rk6XwsXEn/
        lsVhEXQk2wouE/WxxFFpi8aOa021cLF2Q7779Q42EU9hs4CFAJ/lmmQxbZEm1otB7KO5TIhs7Eu
        PQVto6v361aDZ
X-Received: by 2002:a37:b15:: with SMTP id 21mr28563999qkl.104.1587581518878;
        Wed, 22 Apr 2020 11:51:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypLLzkmnDYGbbOkIaC8yISYdS2vxaekStNwPP8eyf0MeRUT+hbOr8YWc7KYSWKcge0VUFezzCA==
X-Received: by 2002:a37:b15:: with SMTP id 21mr28563901qkl.104.1587581517797;
        Wed, 22 Apr 2020 11:51:57 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w10sm14397qka.19.2020.04.22.11.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 11:51:56 -0700 (PDT)
Date:   Wed, 22 Apr 2020 14:51:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 00/14] KVM: Dirty ring interface
Message-ID: <20200422185155.GA3596@xz-x1>
References: <20200331190000.659614-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

TL;DR: I'm thinking whether we should record pure GPA/GFN instead of (slot_id,
slot_offset) tuple for dirty pages in kvm dirty ring to unbind kvm_dirty_gfn
with memslots.

(A slightly longer version starts...)

The problem is that binding dirty tracking operations to KVM memslots is a
restriction that needs synchronization to memslot changes, which further needs
synchronization across all the vcpus because they're the consumers of memslots.
E.g., when we remove a memory slot, we need to flush all the dirty bits
correctly before we do the removal of the memslot.  That's actually an known
defect for QEMU/KVM [1] (I bet it could be a defect for many other
hypervisors...) right now with current dirty logging.  Meanwhile, even if we
fix it, that procedure is not scale at all, and error prone to dead locks.

Here memory removal is really an (still corner-cased but relatively) important
scenario to think about for dirty logging comparing to memory additions &
movings.  Because memory addition will always have no initial dirty page, and
we don't really move RAM a lot (or do we ever?!) for a general VM use case.

Then I went a step back to think about why we need these dirty bit information
after all if the memslot is going to be removed?

There're two cases:

  - When the memslot is going to be removed forever, then the dirty information
    is indeed meaningless and can be dropped, and,

  - When the memslot is going to be removed but quickly added back with changed
    size, then we need to keep those dirty bits because it's just a commmon way
    to e.g. punch an MMIO hole in an existing RAM region (here I'd confess I
    feel like using "slot_id" to identify memslot is really unfriendly syscall
    design for things like "hole punchings" in the RAM address space...
    However such "punch hold" operation is really needed even for a common
    guest for either system reboots or device hotplugs, etc.).

The real scenario we want to cover for dirty tracking is the 2nd one.

If we can track dirty using raw GPA, the 2nd scenario is solved itself.
Because we know we'll add those memslots back (though it might be with a
different slot ID), then the GPA value will still make sense, which means we
should be able to avoid any kind of synchronization for things like memory
removals, as long as the userspace is aware of that.

With that, when we fetch the dirty bits, we lookup the memslot dynamically,
drop bits if the memslot does not exist on that address (e.g., permanent
removals), and use whatever memslot is there for that guest physical address.
Though we for sure still need to handle memory move, that the userspace needs
to still take care of dirty bit flushing and sync for a memory move, however
that's merely not happening so nothing to take care about either.

Does this makes sense?  Comments greatly welcomed..

Thanks,

[1] https://lists.gnu.org/archive/html/qemu-devel/2020-03/msg08361.html

-- 
Peter Xu


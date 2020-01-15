Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F513C7A1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAOP1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 10:27:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729113AbgAOP1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 10:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrQDI1QKJQFSWKTPV8QBF65zJbsbNfFS1aRIu3lctzI=;
        b=CPciMU+T8h5nZEXDAQLXQnxyAepN5CRKhbDjg7XOgLftCBqslr8BiuxW1qkOpbpvWWCOhC
        w4+X1fpSGuKbYnCRrQW9AMXr+P4Pszq3wz8gHlP4CVoVkMn3YAYI83UcQ8EFeUMD4ZTbq5
        BHvng6H2X17BnFNL/A6xBZliANBfkLo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-kDchtcCOPvew-d3Z_iMZ0Q-1; Wed, 15 Jan 2020 10:27:14 -0500
X-MC-Unique: kDchtcCOPvew-d3Z_iMZ0Q-1
Received: by mail-qv1-f70.google.com with SMTP id e14so11266833qvr.6
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 07:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GrQDI1QKJQFSWKTPV8QBF65zJbsbNfFS1aRIu3lctzI=;
        b=rXvnqC2Ld21sfqSgFgZ84bjSTq3G4+D5046dEGvxghDiM8TLChSsVJyFA3QiaLdcbH
         scpIAZ+kzJFVmeHmSNd6CwH+VWYsonvuk3QxZWqbJYF3O6GkdeXDfbbhCzL8oLEHoZQE
         sGqLRZRxGHF42XA2udyMmbqG9cemUjc0D6XikkbEqCugTmqJEo+PQyCQCqrZm0SBVIn1
         3tBch44LrJgeArOmVSSvfO+pn3HTP2kRQ/5MaTuz4De5gHJYSJsFFCjm4uUrHZJLUTm7
         NPfUwTBCozBJeH8QTQL/H4QdTSI3/bNtbK1lgM8d2LBfTk0/0w1i0ayrqvoyx3OZCTAL
         zPDw==
X-Gm-Message-State: APjAAAWlVGtKA/vFRDBqMsOGe1Y1NCOssz9ENkA8nU6xZpU57jH4irq0
        xOe5eSUn+SZ+QVI+BqqmfvxciE0X3dW7NDgqpMKeU5mpP6cARXXKnYwQ2tIo8UgzBIdXhOLtSN9
        M+Mw56nh2JptY
X-Received: by 2002:ad4:47ad:: with SMTP id a13mr26671523qvz.29.1579102033343;
        Wed, 15 Jan 2020 07:27:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyf/k+vFbqZWyHaisJpZvjvigX9YZaUA6qbIjXme6863s0ct9zw5T+J85MQddVkV1a+vd4PsA==
X-Received: by 2002:ad4:47ad:: with SMTP id a13mr26671502qvz.29.1579102033071;
        Wed, 15 Jan 2020 07:27:13 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id t15sm8461294qkg.49.2020.01.15.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:27:12 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:27:11 -0500
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
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200115152711.GG233443@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200115014047-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200115014047-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 15, 2020 at 01:47:15AM -0500, Michael S. Tsirkin wrote:
> > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > new file mode 100644
> > index 000000000000..d6fe9e1b7617
> > --- /dev/null
> > +++ b/include/linux/kvm_dirty_ring.h
> > @@ -0,0 +1,55 @@
> > +#ifndef KVM_DIRTY_RING_H
> > +#define KVM_DIRTY_RING_H
> > +
> > +/**
> > + * kvm_dirty_ring: KVM internal dirty ring structure
> > + *
> > + * @dirty_index: free running counter that points to the next slot in
> > + *               dirty_ring->dirty_gfns, where a new dirty page should go
> > + * @reset_index: free running counter that points to the next dirty page
> > + *               in dirty_ring->dirty_gfns for which dirty trap needs to
> > + *               be reenabled
> > + * @size:        size of the compact list, dirty_ring->dirty_gfns
> > + * @soft_limit:  when the number of dirty pages in the list reaches this
> > + *               limit, vcpu that owns this ring should exit to userspace
> > + *               to allow userspace to harvest all the dirty pages
> > + * @dirty_gfns:  the array to keep the dirty gfns
> > + * @indices:     the pointer to the @kvm_dirty_ring_indices structure
> > + *               of this specific ring
> > + * @index:       index of this dirty ring
> > + */
> > +struct kvm_dirty_ring {
> > +	u32 dirty_index;
> > +	u32 reset_index;
> > +	u32 size;
> > +	u32 soft_limit;
> > +	struct kvm_dirty_gfn *dirty_gfns;
> 
> Here would be a good place to document that accessing
> shared page like this is only safe if archotecture is physically
> tagged.

Right, more importantly is where to document for kvm_run, and any
other shared mappings that I'm not yet aware of across the whole KVM.

[...]

> > +/*
> > + * The following are the requirements for supporting dirty log ring
> > + * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
> > + *
> > + * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
> > + *    of kvm_write_* so that the global dirty ring is not filled up
> > + *    too quickly.
> > + * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
> > + *    enabling dirty logging.
> > + * 3. There should not be a separate step to synchronize hardware
> > + *    dirty bitmap with KVM's.
> 
> 
> Are these requirement from an architecture? Then you want to move
> this out of UAPI, keep things relevant to userspace there.

Good point, I removed it, and instead of this...

> 
> > + */
> > +
> > +struct kvm_dirty_gfn {
> > +	__u32 pad;
> > +	__u32 slot;
> > +	__u64 offset;
> > +};
> > +
> 
> Pls add comments about how kvm_dirty_gfn must be mmapped.

... I added this:

/*
 * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
 * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
 * size of the gfn buffer is decided by the first argument when
 * enabling KVM_CAP_DIRTY_LOG_RING.
 */

Thanks,

-- 
Peter Xu


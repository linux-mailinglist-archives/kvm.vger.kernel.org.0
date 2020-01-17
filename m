Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A141406E2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 10:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAQJvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 04:51:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgAQJu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 04:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579254656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYd4XcpTB2WmAb9JpP9U+6d1Bzc5qT6nYxXsqhauuYY=;
        b=UI+J2iIxQLGsDJweG8xJ0l/17IUg9rQi8BTDOJjLnnEJxd2BPJiF19gVU9K9DmDEd8AUlk
        /iLQF0CaEE2y1syjF3YHaVtYtGIUJpycE/CpdXTUlWeo2Rfip884UYX243TGpWfDmqtgET
        4sOhmYcKhPWGDRUNWUetfaG63AYWD/o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-NXrl3AR_OsCrsvJb8yRBEg-1; Fri, 17 Jan 2020 04:50:55 -0500
X-MC-Unique: NXrl3AR_OsCrsvJb8yRBEg-1
Received: by mail-qv1-f70.google.com with SMTP id e10so15170697qvq.18
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 01:50:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mYd4XcpTB2WmAb9JpP9U+6d1Bzc5qT6nYxXsqhauuYY=;
        b=dPu6Qqy86gNDZj2j2pv4XW0Vlfy6KW6y4Klem3nz/krW79tf2LNjPpFNb7/sJvE21u
         l16qI4PvM93/wMCZ8Zwd34izThAVuCHubmyaj1j852fAxxzl2Fm8Sd1qWF/1r5DKNmK7
         huEBcfCuEG8ZI7jQtOhULEmtnTU40O+AvjTiyCoY8J6pdtJnB9oFic/CkC1haDQAL7nk
         ZlyBY17imZ2fgayehl2LoT4Qw86JRgMeBucYB0yG1JzmgVqQZ0PvwQAnarSnRraYtRBv
         3gDQ2JE2JjLfLQhkJirn7gFaeJzyVW/w79TIH5Cr7PgCF7XK1sdVnlSO0uwhLIEVLIni
         Cm+Q==
X-Gm-Message-State: APjAAAUuUd1fEHIw1NSI7x3h0mG5x5sxwR7s4oU1Hu+CI24i8qCkBTK3
        zCk4qRE4KImoLgPNPDvtc/QMMpeBaN9ym0Y/xdw4xcUNY/206Fws48BhTME8ukAV492sBcbOQuQ
        HagKXQXXCoDof
X-Received: by 2002:a37:a70b:: with SMTP id q11mr32130064qke.393.1579254655345;
        Fri, 17 Jan 2020 01:50:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxPk0EzmH8BB5RmxgtwTU30bMvpsJqk/7qLf7iaQA6f+J68LLqTM68sZN85WrQckS6a24uP8w==
X-Received: by 2002:a37:a70b:: with SMTP id q11mr32130048qke.393.1579254655163;
        Fri, 17 Jan 2020 01:50:55 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id t38sm12968064qta.78.2020.01.17.01.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:50:54 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:50:48 -0500
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
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200117045019-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200116033725-mutt-send-email-mst@kernel.org>
 <20200116162703.GA344339@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116162703.GA344339@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 11:27:03AM -0500, Peter Xu wrote:
> On Thu, Jan 16, 2020 at 03:38:21AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> > > +	/* If to map any writable page within dirty ring, fail it */
> > > +	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> > > +	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> > > +	    vma->vm_flags & VM_WRITE)
> > > +		return -EINVAL;
> > 
> > Worth thinking about other flags. Do we want to force VM_SHARED?
> > Disable VM_EXEC?
> 
> Makes sense to me.  I think it worths a standalone patch since they
> should apply for the whole per-vcpu mmaped regions rather than only
> for the dirty ring buffers.
> 
> (Should include KVM_PIO_PAGE_OFFSET, KVM_COALESCED_MMIO_PAGE_OFFSET,
>  KVM_S390_SIE_PAGE_OFFSET, kvm_run, and this new one)
> 
> Thanks,


I don't think we can change UAPI for existing ones.
Userspace might be setting these by mistake.

> -- 
> Peter Xu


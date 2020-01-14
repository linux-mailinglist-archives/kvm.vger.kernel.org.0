Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5621B13B34F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgANUBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 15:01:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41674 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgANUBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 15:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579032099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5YGCCGIX+lIuE1xVDvMmlXX8AVAofNe88Se1/lzptk=;
        b=bQgNSKsdn/+k6J/0nR5h6y6iw1hQLDxUY8vYTboOpK0Pxb/4uVJculfzo7aHJb+iFGd1eK
        YByexd5sJkRxg5VbekMN/u0dNF5kSZemEXkOP1FupqINwttYzPZgp4qVAci6It9354PGnE
        ewkdDlIOFvHXhndegUdZQi9KPzGI73E=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-BdqQVZtUO8-8ZVsXuaA3aQ-1; Tue, 14 Jan 2020 15:01:37 -0500
X-MC-Unique: BdqQVZtUO8-8ZVsXuaA3aQ-1
Received: by mail-qv1-f71.google.com with SMTP id z9so9421556qvo.10
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 12:01:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F5YGCCGIX+lIuE1xVDvMmlXX8AVAofNe88Se1/lzptk=;
        b=l2XiRJ+g5iAUzWoe9XhRdfTg0vyCLSDRQa/yGNPfAISlEZ0UB6J1RXJkOXBNe041Yn
         cRtSGUcZbrGAI7dwgjdQWu19OCgw0/aczlSp0H8aLJo5B71VjOB0XtW4qfLx0/LBmJZq
         KIX5KsH+MUvuHMGQByuQ22SlyhOjOo+5HOs+0JnFVWF5kERzOWWBMIwFXXVVHsI/4trd
         dyPQuxTJwNhHV8kwpOemqY8e5o3GxautTQznm0GD20ZcC+v8GhJTHPc9MVLISqNyE7Z0
         BWa72Bv+ofnRTcUTfu1K7o4NefVRcJDyj48kvURGm//R3hyQbDz1UoXyi+9q1pWVnj2g
         /qKg==
X-Gm-Message-State: APjAAAVi3l/FN9EoUF3ITlLZjldmzcqc3ycs4yeQ6aVyLUDGDk+g+eYB
        totpH4EDCVh+6WF4EIN8i9W63Fw1Rad9n5fwYiBWHxL+E1opVrZy8LXMPt+alAXwG+SH+pi4kRL
        hgIyjD5OY1Mtd
X-Received: by 2002:ad4:51cc:: with SMTP id p12mr22091564qvq.113.1579032097454;
        Tue, 14 Jan 2020 12:01:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNbvJ19TaniVCvM/mX2nsCuKcnV2VokhOKt9QMPvk/ivDM+6fGWGUc2wdsUeBtEK+BAUVjqA==
X-Received: by 2002:ad4:51cc:: with SMTP id p12mr22091536qvq.113.1579032097113;
        Tue, 14 Jan 2020 12:01:37 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id m8sm8255953qtk.60.2020.01.14.12.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 12:01:36 -0800 (PST)
Date:   Tue, 14 Jan 2020 15:01:34 -0500
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
        Lei Cao <lei.cao@stratus.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200114200134.GA233443@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <20200109141634-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109141634-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:35:46PM -0500, Michael S. Tsirkin wrote:
>   ``void flush_dcache_page(struct page *page)``
> 
>         Any time the kernel writes to a page cache page, _OR_
>         the kernel is about to read from a page cache page and
>         user space shared/writable mappings of this page potentially
>         exist, this routine is called.
> 
> 
> > Also, I believe this is the similar question that Jason has asked in
> > V2.  Sorry I should mention this earlier, but I didn't address that in
> > this series because if we need to do so we probably need to do it
> > kvm-wise, rather than only in this series.
> 
> You need to document these things.
> 
> >  I feel like it's missing
> > probably only because all existing KVM supported archs do not have
> > virtual-tagged caches as you mentioned.
> 
> But is that a fact? ARM has such a variety of CPUs,
> I can't really tell. Did you research this to make sure?
> 
> > If so, I would prefer if you
> > can allow me to ignore that issue until KVM starts to support such an
> > arch.
> 
> Document limitations pls.  Don't ignore them.

Hi, Michael,

I failed to find a good place to document about flush_dcache_page()
for KVM.  Could you give me a suggestion?

And I don't know about whether there's any ARM hosts that requires
flush_dcache_page().  I think not, because again I didn't see any
caller of flush_dcache_page() in KVM code yet.  Otherwise I think we
should at least call it before the kernel reading kvm_run or after
publishing data to kvm_run.  However I'm also CCing Drew for this.

Thanks,

-- 
Peter Xu


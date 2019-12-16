Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02851209C6
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfLPPdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:33:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728259AbfLPPdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z0ykzv4O9XDflANBBucUp6ssbent/uqQftfOjZxhGN0=;
        b=CvItLLLFf9H0OcxsysiMIYLsVR993UsqrVKMkYsTASsyRTNbjoURpshFMP1kK9iGXKnGaQ
        mg5uX2nXfGMYeE3HPJlDj7wxZ9s3bQy4jMzWVKalFf4vzitTXsxrQ/SHuBWBh4HWbtdnWz
        Aq0+rKZ8agxql3pc30/68RGVyfBb0AU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-NfvDKqAgPr6CxT3BceY57g-1; Mon, 16 Dec 2019 10:33:49 -0500
X-MC-Unique: NfvDKqAgPr6CxT3BceY57g-1
Received: by mail-qv1-f71.google.com with SMTP id z12so1926455qvk.14
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z0ykzv4O9XDflANBBucUp6ssbent/uqQftfOjZxhGN0=;
        b=ULyMG+88Z026M3WdEGLhbR1nMOJ/aMgBI3pmfvDFAFEEYqB15GAD/vcT7GzoQ5fcqw
         Ozz0sXATXV0aelasjr8s8SVj0htPM4uKxKLn/44BvkC/ElWjGUss66XTgHmc/12twrFs
         oKfduo56VQOzvkwAtk9Kc3XWDA8VFJr9UzEmbH8POvxqrnEz8J/Z7AUj0ELus3oX1Pdm
         66tmztd87FqFWzT5YEXDq3gEiDZhOqiXKOPQ0zs/0BoBU+lR4pwtFTTzKhttV9hyntwu
         X39YYPhJ1IkZcm0O4xDxQUpq27SJlH0UGyz1DGSI79To9ZloDLzgRB0ZezFgPAZklC2N
         +2aw==
X-Gm-Message-State: APjAAAVwzz4PchHNuGyaBGETy7SI6htljdWKo7jVi+iSaCqBCnimSZO9
        li0RSg+knHt9YheCYfa2qs3qhd6IEfoGiRDkfhCkRJEWPfPkxW92NNhH0nlCf5nfOL6Ei5p6Djn
        r9VzzOnwtAYcq
X-Received: by 2002:a05:620a:b18:: with SMTP id t24mr27387984qkg.341.1576510428730;
        Mon, 16 Dec 2019 07:33:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYwsAN4Q+QC29+/ynoBvhgn+sVgs19/Aa51xUTnXtyYxuSUmHPy54H02pcDC57nW5rMIQk2w==
X-Received: by 2002:a05:620a:b18:: with SMTP id t24mr27387965qkg.341.1576510428508;
        Mon, 16 Dec 2019 07:33:48 -0800 (PST)
Received: from redhat.com ([212.199.108.238])
        by smtp.gmail.com with ESMTPSA id b191sm6118550qkg.43.2019.12.16.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:33:47 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:33:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216103251-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191215173302.GB83861@xz-x1>
 <20191216044619-mutt-send-email-mst@kernel.org>
 <20191216150754.GC83861@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216150754.GC83861@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 10:07:54AM -0500, Peter Xu wrote:
> On Mon, Dec 16, 2019 at 04:47:36AM -0500, Michael S. Tsirkin wrote:
> > On Sun, Dec 15, 2019 at 12:33:02PM -0500, Peter Xu wrote:
> > > On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
> > > > >>> What depends on what here? Looks suspicious ...
> > > > >>
> > > > >> Hmm, I think maybe it can be removed because the entry pointer
> > > > >> reference below should be an ordering constraint already?
> > > > 
> > > > entry->xxx depends on ring->reset_index.
> > > 
> > > Yes that's true, but...
> > > 
> > >         entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > >         /* barrier? */
> > >         next_slot = READ_ONCE(entry->slot);
> > >         next_offset = READ_ONCE(entry->offset);
> > > 
> > > ... I think entry->xxx depends on entry first, then entry depends on
> > > reset_index.  So it seems fine because all things have a dependency?
> > 
> > Is reset_index changed from another thread then?
> > If yes then you want to read reset_index with READ_ONCE.
> > That includes a dependency barrier.
> 
> There're a few readers, but only this function will change it
> (kvm_dirty_ring_reset).  Thanks,

Then you don't need any barriers in this function.
readers need at least READ_ONCE.

> -- 
> Peter Xu


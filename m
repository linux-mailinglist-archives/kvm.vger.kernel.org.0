Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEB12094D
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfLPPIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:08:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728109AbfLPPIA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 10:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576508878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AaYS2d/uqJ46OLZ/1yehXsn/hccZMKnfSM509Os6C9g=;
        b=GNlVNF4FOFalINF+nI9TVLLd7HnbPCkmOTsaEUHa8Qwh2Tp4R8JD01BS4YFcBaePHgjseV
        8GyY34GRNvwVVrsHDmZ/Z7rkfBoK8n2FemJjn4oG2IPRqa8kYv/rI/JEIGu6Yxvb5X1k5z
        Eg2WgsITpBQsk2ilswsAE0QDUusl5O0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-5TvquMcFNZScuaF8TuxMcQ-1; Mon, 16 Dec 2019 10:07:56 -0500
X-MC-Unique: 5TvquMcFNZScuaF8TuxMcQ-1
Received: by mail-qt1-f197.google.com with SMTP id l25so4808872qtu.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:07:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AaYS2d/uqJ46OLZ/1yehXsn/hccZMKnfSM509Os6C9g=;
        b=milHALK0dVuwY3t20ahRM5FCEp8LAgJnuvGyfnNlh/D4k6N/7cQpYQTu1Zmg5iQ5qk
         IGh/AU6fq4kaTID7DxRfeNL8Wfar30UQhPKB+7fscGEGHjn1DrcKVsg0dU6r02BK0058
         KV6xOGfMED/ygCiKFqO865Z4/jqufxzL2W3s4HlQCcqswYDYFQHv6wea+b+zvFT36XMH
         2pHkSP0LL62lAYhjx5lMW2VXkCkvXQWD9qC+SopRUB+liSDjA0impHGRm7lR8MrTaz6s
         GS/CflxdthwJYLFtwXTX6jEgORTIOE4IqVjGfIEvdt85kiv98dBMDvGX3av8/KZksxoj
         xriQ==
X-Gm-Message-State: APjAAAXw6Hm0Gt9dKiqWgXjjRp0EVAzua6L4IILo1UGEa85ODYRHyZVU
        aTtAWNOmSPcJ16jqKQhHYjc0TTWZlgWyUMUrrMOg4sgJ4afEXMJU4Flc/jBn4Cq1nBVDCs7H1hi
        N7H1GWX4bwSUr
X-Received: by 2002:ac8:787:: with SMTP id l7mr18610238qth.99.1576508875503;
        Mon, 16 Dec 2019 07:07:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYfnL3o3dLmvysdxBkpTp3PrdiWzj1LMSkxOlgD/ePz+FfCYUR507X8Dna+HG79+AXJS7/Tg==
X-Received: by 2002:ac8:787:: with SMTP id l7mr18610206qth.99.1576508875250;
        Mon, 16 Dec 2019 07:07:55 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w1sm5343645qtk.31.2019.12.16.07.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:07:54 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:07:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216150754.GC83861@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191215173302.GB83861@xz-x1>
 <20191216044619-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216044619-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 04:47:36AM -0500, Michael S. Tsirkin wrote:
> On Sun, Dec 15, 2019 at 12:33:02PM -0500, Peter Xu wrote:
> > On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
> > > >>> What depends on what here? Looks suspicious ...
> > > >>
> > > >> Hmm, I think maybe it can be removed because the entry pointer
> > > >> reference below should be an ordering constraint already?
> > > 
> > > entry->xxx depends on ring->reset_index.
> > 
> > Yes that's true, but...
> > 
> >         entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> >         /* barrier? */
> >         next_slot = READ_ONCE(entry->slot);
> >         next_offset = READ_ONCE(entry->offset);
> > 
> > ... I think entry->xxx depends on entry first, then entry depends on
> > reset_index.  So it seems fine because all things have a dependency?
> 
> Is reset_index changed from another thread then?
> If yes then you want to read reset_index with READ_ONCE.
> That includes a dependency barrier.

There're a few readers, but only this function will change it
(kvm_dirty_ring_reset).  Thanks,

-- 
Peter Xu


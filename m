Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7C8120A07
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfLPPrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:47:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53957 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728328AbfLPPrr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 10:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576511266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RgWQhpsAIADMZAP/1x3HqNJ9NVK8air/mo1dw8k/m4w=;
        b=KP8P9neQEi/etdg9XiABiSrbkHbNwpX6R74F+WffydS1P/hI1y3Q3Vwm9BaReN2hM2wjXk
        T8zsFe8AYYcY4ukTRF+JTTohguoO9+CNNSJCKAeyQPEqiz+5iRxXYaCFI+qnyP7zCu8WB7
        XDGmdQbGdd7ooRhnQUBtshs6oO+Iiy8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-1BezqNWlP-eIpya79w9K6g-1; Mon, 16 Dec 2019 10:47:44 -0500
X-MC-Unique: 1BezqNWlP-eIpya79w9K6g-1
Received: by mail-qv1-f70.google.com with SMTP id p3so5526648qvt.9
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RgWQhpsAIADMZAP/1x3HqNJ9NVK8air/mo1dw8k/m4w=;
        b=AoUPC7vCJwS8YxbiWjcXLchcnrc9+lSWWp4PEbXznUhjRPBmj3kykZN2RL/ErDjzyP
         ELeutOmBx1vZG6iUsI2oTiBnsGj3Z9NjrxkxkBowgHP/TFdbDnOlweKOvZJs6ZE9qDwm
         BAQ6kIZdLgDY8vIkENVqxltAmq02GevRt9WNJDpbWMeYssBJWyu7hJPl56KhOHdCVYTb
         qZtD8+nGpK0NV5N6SFlKdPB9pcpBFLAUZ+z9E+x8hHpcGc1O8A4+dRp9tbpr35MhB4NB
         KjT0ZSU1qHT2U1QIh3VCVReq5slLDpXVkmHypOO7sXTxeLtzmW2efY2jOMM4Juil099f
         kXdg==
X-Gm-Message-State: APjAAAXrmR6dWCF2FhVj7X4Q8bSBtbcDjOpfx4yRcrNDUN43c/ArbdQ+
        pTuRtFma3IW/iOKelDpAxFPOrwb5zz3Bst6LLJBA0agMQ9QXYXwqcy7+cg17D95xkqU7m5D6icG
        wFHFUqNykKwAZ
X-Received: by 2002:a05:6214:108a:: with SMTP id o10mr26486290qvr.246.1576511264400;
        Mon, 16 Dec 2019 07:47:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1PDmhMHZHSnB6wuEZN9qkZjX10yPTV1uCaDq6nRhK2p6zGEl4P7bhy8kKpOy1w0Z1WWcikg==
X-Received: by 2002:a05:6214:108a:: with SMTP id o10mr26486280qvr.246.1576511264193;
        Mon, 16 Dec 2019 07:47:44 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id b7sm6059467qkh.106.2019.12.16.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:47:42 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:47:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216154742.GF83861@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191215173302.GB83861@xz-x1>
 <20191216044619-mutt-send-email-mst@kernel.org>
 <20191216150754.GC83861@xz-x1>
 <20191216103251-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216103251-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 10:33:42AM -0500, Michael S. Tsirkin wrote:
> On Mon, Dec 16, 2019 at 10:07:54AM -0500, Peter Xu wrote:
> > On Mon, Dec 16, 2019 at 04:47:36AM -0500, Michael S. Tsirkin wrote:
> > > On Sun, Dec 15, 2019 at 12:33:02PM -0500, Peter Xu wrote:
> > > > On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
> > > > > >>> What depends on what here? Looks suspicious ...
> > > > > >>
> > > > > >> Hmm, I think maybe it can be removed because the entry pointer
> > > > > >> reference below should be an ordering constraint already?
> > > > > 
> > > > > entry->xxx depends on ring->reset_index.
> > > > 
> > > > Yes that's true, but...
> > > > 
> > > >         entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > > >         /* barrier? */
> > > >         next_slot = READ_ONCE(entry->slot);
> > > >         next_offset = READ_ONCE(entry->offset);
> > > > 
> > > > ... I think entry->xxx depends on entry first, then entry depends on
> > > > reset_index.  So it seems fine because all things have a dependency?
> > > 
> > > Is reset_index changed from another thread then?
> > > If yes then you want to read reset_index with READ_ONCE.
> > > That includes a dependency barrier.
> > 
> > There're a few readers, but only this function will change it
> > (kvm_dirty_ring_reset).  Thanks,
> 
> Then you don't need any barriers in this function.
> readers need at least READ_ONCE.

In our case even an old reset_index should not matter much here imho
because the worst case is we read an old reset so we stop pushing to a
ring when it's just being reset and at the same time it's soft-full
(so an extra user exit even race happened).  But I agree it's clearer
to READ_ONCE() on readers.  Thanks!

-- 
Peter Xu


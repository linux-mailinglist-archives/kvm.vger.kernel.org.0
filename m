Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF99142469
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 08:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATHr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 02:47:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgATHrz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 02:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579506474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DRxgwdNfsPjpaqCnob500hqCEgh7ZacCIxaAxxV7tMc=;
        b=c2xx9xwp97A/zMFgxKPYh1DKvQXS0ikdjkYImvirfX1tgWNswLiuq5EXfnONQsiH15bo7W
        P1PgFbLtbM8Tu74IABd2UAdLuLvF3uIHnGSRv8BP0qIM7r029cCavzxRMnW9GdUIH6yynB
        wkDoeSp5XUhgiS45dee/OlE29aN0nFY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-bbaNcVdUMJOaVe-mtF_PMA-1; Mon, 20 Jan 2020 02:47:53 -0500
X-MC-Unique: bbaNcVdUMJOaVe-mtF_PMA-1
Received: by mail-qk1-f197.google.com with SMTP id m13so19952428qka.9
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 23:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DRxgwdNfsPjpaqCnob500hqCEgh7ZacCIxaAxxV7tMc=;
        b=W2cNu8f2etS0wRuDh6k82CKAw/UdkcPNYIqkvMPDLwFjxdRqtwoXrrEVpUOnkiX7ch
         qppNz2YecUVJs6jYlRAy6GAi1BBLqOO54hgMnexuc3txmvww+euCQvIlb3AOJzb/MHls
         tXpYRIFpjMueYfB/l8F1BFmn5QjLyo5QoRZXlRzP2wZjypaPgFVSUE4L2YZ4luSRcPth
         4rVht7PYa2gGXQD7+iDz7ryCu7T8pG3iqEvhP0c1BibjLpSOBlkQn1MIUGs8IM4FHt2O
         SbA6PdsBeU+Ed0bMIG7iP3QoqRfHRpQymxTM0gI8FoXnTgnCFNOc8Nij/nXuhsbnuHxd
         kpsg==
X-Gm-Message-State: APjAAAUEWS0rCiY9up2pdhX3yT+CoVNouDyiEK1X9urtjpzV609V1siA
        LqiXVi2tiMSFUFegsQL5LVfMrREPNpPu46gNbB4O7ldbzfvY4GU/qfCD57OfnUZRw7rya2lxwMJ
        oGp90esBD1XSU
X-Received: by 2002:ad4:52cb:: with SMTP id p11mr19032839qvs.40.1579506473110;
        Sun, 19 Jan 2020 23:47:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEtY1SIzk7pMswk1YUQyizl2SeTF2C4wWLaIi1wnQRoKNrV6mfhMbDyW+/x5CqEr86nb11+g==
X-Received: by 2002:ad4:52cb:: with SMTP id p11mr19032827qvs.40.1579506472874;
        Sun, 19 Jan 2020 23:47:52 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id q126sm15453824qkd.21.2020.01.19.23.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 23:47:52 -0800 (PST)
Date:   Mon, 20 Jan 2020 02:47:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
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
Message-ID: <20200120024717-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
 <20200119051145-mutt-send-email-mst@kernel.org>
 <20200120072915.GD380565@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120072915.GD380565@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 03:29:15PM +0800, Peter Xu wrote:
> On Sun, Jan 19, 2020 at 05:12:35AM -0500, Michael S. Tsirkin wrote:
> > On Sun, Jan 19, 2020 at 10:09:53AM +0100, Paolo Bonzini wrote:
> > > On 09/01/20 20:15, Peter Xu wrote:
> > > > Regarding dropping the indices: I feel like it can be done, though we
> > > > probably need two extra bits for each GFN entry, for example:
> > > > 
> > > >   - Bit 0 of the GFN address to show whether this is a valid publish
> > > >     of dirty gfn
> > > > 
> > > >   - Bit 1 of the GFN address to show whether this is collected by the
> > > >     user
> > > 
> > > We can use bit 62 and 63 of the GFN.
> > 
> > If we are short on bits we can just use 1 bit. E.g. set if
> > userspace has collected the GFN.
> 
> I'm still unsure whether we can use only one bit for this.  Say,
> otherwise how does the userspace knows the entry is valid?  For
> example, the entry with all zeros ({.slot = 0, gfn = 0}) could be
> recognized as a valid dirty page on slot 0 gfn 0, even if it's
> actually an unused entry.

So I guess the reverse: valid entry has bit set, userspace sets it to
0 when it collects it?


> > 
> > > I think this can be done in a secure way.  Later in the thread you say:
> > > 
> > > > We simply check fetch_index (sorry I
> > > > meant this when I said reset_index, anyway it's the only index that we
> > > > expose to userspace) to make sure:
> > > > 
> > > >   reset_index <= fetch_index <= dirty_index
> > > 
> > > So this means that KVM_RESET_DIRTY_RINGS should only test the "collected
> > > by user" flag on dirty ring entries between reset_index and dirty_index.
> > > 
> > > Also I would make it
> > > 
> > >    00b (invalid GFN) ->
> > >      01b (valid gfn published by kernel, which is dirty) ->
> > >        1*b (gfn dirty page collected by userspace) ->
> > >          00b (gfn reset by kernel, so goes back to invalid gfn)
> > > That is 10b and 11b are equivalent.  The kernel doesn't read that bit if
> > > userspace has collected the page.
> 
> Yes "1*b" is good too (IMHO as long as we can define three states for
> an entry).  However do you want me to change to that?  Note that I
> still think we need to read the rest of the field (in this case,
> "slot" and "gfn") besides the two bits to do re-protect.  Should we
> trust that unconditionally if writable?
> 
> Thanks,
> 
> -- 
> Peter Xu


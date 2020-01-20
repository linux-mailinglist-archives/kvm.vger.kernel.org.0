Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA7142437
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 08:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgATH3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 02:29:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23006 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbgATH3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 02:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579505371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jI34RrcUPMd0jM0u87vFiLfbd5SdFZjWwVYjwdRJHw4=;
        b=apeB2UuOyj3zY3z3TTSs/84xOCn3q03kWOZdEBxxLDhAPNCgI1GJk58Jig7nuSOYkT3ibm
        emmi4W+nPG1S1yM3Vy8gYYM40SUjMDx4m36HTZQhX5XKJkzB2r+fMk/7ngSVTW44VFJBPD
        ZSUhBBS9WkvulxAloYKZEtcMVsqC05Q=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280--5RqX8g9MYyD0q7iOjphjA-1; Mon, 20 Jan 2020 02:29:30 -0500
X-MC-Unique: -5RqX8g9MYyD0q7iOjphjA-1
Received: by mail-pl1-f198.google.com with SMTP id c12so13862666pls.22
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 23:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jI34RrcUPMd0jM0u87vFiLfbd5SdFZjWwVYjwdRJHw4=;
        b=GxyHc65NiPUp08UdJMwB2oavK/8hyLWEZXVHfZIT1lkv/x/jehFqHWYwUtg/+mh3Td
         RrVS8GVTN1pdaSR2xue2so2Saz8TARsGfjuK6ajxY6u9RWYRziDoNWG0mbN5BC3GSxXa
         jem9VWjtmSDj4hNG4pjkKiBqqzOA+OSSYmpFn/VhvtUe7+6KcLepTs2YYMgQBUVcvKSS
         N/cj1yADlXTcN/Dvd9MgtKDYjag3qEzw/9CMlXf0MP0bWFMaDzeqZ2G9p3bd8Dcol2hU
         Wrt+tGekH5bv4rEmNgx6qI47bMOm6EFxGKHU/F+pKKZcaGxVYvec+cPHI5v8PlsspSds
         4wtw==
X-Gm-Message-State: APjAAAU1/5cLCnQg+rVVih8s63Py+XrF6+1EL08NLiS2QZWPI+PJcspn
        71PvxzAnwLt9SGBuUSpUEMObqz3R0xln0lPWgsU6QtFv2qSOviDN/MqA1SnWVwMNX9QIazNlh2w
        03F7odRJE7ntP
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr13987754plp.324.1579505368987;
        Sun, 19 Jan 2020 23:29:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPyolAukpA6MYI9Ufq/PRLUWLhID+YoT4UYIEQRyTCrxIEsEGeooxUbVvLw9NC5i1u7Tgb6w==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr13987732plp.324.1579505368730;
        Sun, 19 Jan 2020 23:29:28 -0800 (PST)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j9sm37663567pfn.152.2020.01.19.23.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 23:29:27 -0800 (PST)
Date:   Mon, 20 Jan 2020 15:29:15 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20200120072915.GD380565@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
 <20200119051145-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200119051145-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 19, 2020 at 05:12:35AM -0500, Michael S. Tsirkin wrote:
> On Sun, Jan 19, 2020 at 10:09:53AM +0100, Paolo Bonzini wrote:
> > On 09/01/20 20:15, Peter Xu wrote:
> > > Regarding dropping the indices: I feel like it can be done, though we
> > > probably need two extra bits for each GFN entry, for example:
> > > 
> > >   - Bit 0 of the GFN address to show whether this is a valid publish
> > >     of dirty gfn
> > > 
> > >   - Bit 1 of the GFN address to show whether this is collected by the
> > >     user
> > 
> > We can use bit 62 and 63 of the GFN.
> 
> If we are short on bits we can just use 1 bit. E.g. set if
> userspace has collected the GFN.

I'm still unsure whether we can use only one bit for this.  Say,
otherwise how does the userspace knows the entry is valid?  For
example, the entry with all zeros ({.slot = 0, gfn = 0}) could be
recognized as a valid dirty page on slot 0 gfn 0, even if it's
actually an unused entry.

> 
> > I think this can be done in a secure way.  Later in the thread you say:
> > 
> > > We simply check fetch_index (sorry I
> > > meant this when I said reset_index, anyway it's the only index that we
> > > expose to userspace) to make sure:
> > > 
> > >   reset_index <= fetch_index <= dirty_index
> > 
> > So this means that KVM_RESET_DIRTY_RINGS should only test the "collected
> > by user" flag on dirty ring entries between reset_index and dirty_index.
> > 
> > Also I would make it
> > 
> >    00b (invalid GFN) ->
> >      01b (valid gfn published by kernel, which is dirty) ->
> >        1*b (gfn dirty page collected by userspace) ->
> >          00b (gfn reset by kernel, so goes back to invalid gfn)
> > That is 10b and 11b are equivalent.  The kernel doesn't read that bit if
> > userspace has collected the page.

Yes "1*b" is good too (IMHO as long as we can define three states for
an entry).  However do you want me to change to that?  Note that I
still think we need to read the rest of the field (in this case,
"slot" and "gfn") besides the two bits to do re-protect.  Should we
trust that unconditionally if writable?

Thanks,

-- 
Peter Xu


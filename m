Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEF31209A1
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfLPP0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:26:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26705 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728248AbfLPP0w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 10:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGwZfkSSJJnwVp/7Ati+2Sz+85Pj+b7tepwX8oznNuk=;
        b=IxEBPUWDCre9pvmRnvVHVXlLd0ZzspouaPDCuuTdvcVfedlc/OFM3ORM5yXHokvEfbXsdD
        2/OngRE1Eu2kIK3AOTkAtAkKKA/iUfQVEHGJ12iL/lUNGeT2Tx27uLnk6Qi4Ii37n+44TB
        CHNQw5unY5BEGBPMzVU8QNcz7seG4mo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-hNwIFUuvOD2piHGdDt5s1A-1; Mon, 16 Dec 2019 10:26:49 -0500
X-MC-Unique: hNwIFUuvOD2piHGdDt5s1A-1
Received: by mail-qk1-f198.google.com with SMTP id a200so2397748qkc.18
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:26:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iGwZfkSSJJnwVp/7Ati+2Sz+85Pj+b7tepwX8oznNuk=;
        b=eSsG9G5uqyiMK6l/HJ9CdR9WSDR6YhNyGh7bPqSFmUUAQPxudN1HAcnH9Rzc1R5CZq
         y8drDWUCbLZiPYrFxOEm7tQNESAaG/vXSShBbA+XpX5KT5R9GzWZ+oGAUsj/rJLOjgNu
         J3Q+G9scoq25S6e4XAjt8HpSB9s8v2hn4n21JRSUcVvFdP79gIYMdsHVgZRxkEFkqYgi
         UXPkDKrU/mUWg5AXTp80lH055zJysloJ4vHhy6Vw7+rWvU99ff7J/z4GD1RxC7hrLqOZ
         jCDUo+0zJJRsA8rRMUd6i8PDGfi2YQ9twff8VIqiNiVueB6B4EOw7IY20Q5VPus7vJwy
         wRJQ==
X-Gm-Message-State: APjAAAUksOJWNNvLOQoXu1gK4pcPEMvPeis9yY8+K1/iRNTlCAWktxAH
        8EdFDIEMzyrFn02aOf0X/9B38QbI/5SlJ1MzcI5uxjGRIrmZ4WjCDmSR78VGcawCRFIBp+3hxt2
        bbOmlKpCXVmQ8
X-Received: by 2002:ac8:5257:: with SMTP id y23mr12518066qtn.88.1576510008518;
        Mon, 16 Dec 2019 07:26:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzjZKLtqnKl3UUpSm2cxHKwBagl6vJ99FCgj6lDTxMrEQ4zqr3hHWPw+ZrHloqvoZLMECC06A==
X-Received: by 2002:ac8:5257:: with SMTP id y23mr12518048qtn.88.1576510008236;
        Mon, 16 Dec 2019 07:26:48 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id u15sm6007057qku.67.2019.12.16.07.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:26:46 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:26:47 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216152647.GD83861@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <20191214162644.GK16429@xz-x1>
 <0f084179-2a5d-e8d9-5870-3cc428105596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0f084179-2a5d-e8d9-5870-3cc428105596@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 10:29:36AM +0100, Paolo Bonzini wrote:
> On 14/12/19 17:26, Peter Xu wrote:
> > On Sat, Dec 14, 2019 at 08:57:26AM +0100, Paolo Bonzini wrote:
> >> On 13/12/19 21:23, Peter Xu wrote:
> >>>> What is the benefit of using u16 for that? That means with 4K pages, you
> >>>> can share at most 256M of dirty memory each time? That seems low to me,
> >>>> especially since it's sufficient to touch one byte in a page to dirty it.
> >>>>
> >>>> Actually, this is not consistent with the definition in the code ;-)
> >>>> So I'll assume it's actually u32.
> >>> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
> >>> more. :)
> >>
> >> It has to be u16, because it overlaps the padding of the first entry.
> > 
> > Hmm, could you explain?
> > 
> > Note that here what Christophe commented is on dirty_index,
> > reset_index of "struct kvm_dirty_ring", so imho it could really be
> > anything we want as long as it can store a u32 (which is the size of
> > the elements in kvm_dirty_ring_indexes).
> > 
> > If you were instead talking about the previous union definition of
> > "struct kvm_dirty_gfns" rather than "struct kvm_dirty_ring", iiuc I've
> > moved those indices out of it and defined kvm_dirty_ring_indexes which
> > we expose via kvm_run, so we don't have that limitation as well any
> > more?
> 
> Yeah, I meant that since the size has (had) to be u16 in the union, it
> need not be bigger in kvm_dirty_ring.
> 
> I don't think having more than 2^16 entries in the *per-CPU* ring buffer
> makes sense; lagging in recording dirty memory by more than 256 MiB per
> CPU would mean a large pause later on resetting the ring buffers (your
> KVM_CLEAR_DIRTY_LOG patches found the sweet spot to be around 1 GiB for
> the whole system).

That's right, 1G could probably be a "common flavor" for guests in
that case.

Though I wanted to use u64 only because I wanted to prepare even
better for future potential changes as long as it won't hurt much.
Here I'm just afraid 16bit might not be big enough for this 64bit
world, at the meantime I'd confess some of the requirement could be
really unimaginable before we know it..  I'm trying to forge one here:
what if the customer wants to handle 4G burst dirtying workload during
a migration (besides the burst IOs, mostly idle guests), while the
customer also want good responsiveness during the burst dirtying?  In
that case even if we use 256MiB ring we'll still need to freqently
pause for the harvesting, but actually this case really suites for a
8G ring size.

My example could be nonsense actually, just to show that if we can
extend something to u64 from u16 without paying much, then why not. :-)

> 
> So I liked the union, but if you removed it you might as well align the
> producer and consumer indices to 64 bytes so that they are in separate
> cache lines.

Yeh that I can do.  Thanks,

-- 
Peter Xu


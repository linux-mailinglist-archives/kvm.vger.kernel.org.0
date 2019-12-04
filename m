Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AC91135F8
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfLDTwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:52:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727867AbfLDTwh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 14:52:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575489157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2HusBtOWadZiLTPK1SmC8n0gdc/q9WlraTHbywKYh/s=;
        b=ZsP+JtW+SPCx3zoVpwPZr9WbEolxp98kw0mGaMTZ2Ho8TLxSVdwNwWJ3g9t5ZCHZZmqkm6
        fRVSfwT/DKbe3LMuAEkar+cAAb0l2g4wfXVaouJaIoMf5QSxj3/fpJdtFFSFayCx+XjIPY
        OzA1yjEWx9pTF9JO1QUQ3fl3Dd4c7d8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-Wk397ZESNdWq_c_XloFGYQ-1; Wed, 04 Dec 2019 14:52:33 -0500
Received: by mail-qt1-f200.google.com with SMTP id x8so728036qtq.14
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:52:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=COps3gzSWJZrk5fQQE220Gmmy+Anmpkd5GgCFKaWMT0=;
        b=BAsV9PlJF2+wTiCruIBG2aL/yjgLPFgPiAghvhOV3JHSVCSso7l+CHxskkh+GhNKE/
         b/l3HOdqDcoZezR2DJ4MhVefjl0OzPS6y984lFGWKI8h2JKrdjTMiagIvqXKkUTOUckq
         4dzh9x6VqTd9z4Vhg7VSAnNssT1fmdppKOlDaFKXn3Jbd81R+PDTiLnVxGRuR75jS9yg
         WmntrpmIUdXORZ+RmJ5+OSsEHhygV3ZaUvCPWKJp60cSWCCpHnn8oTe/s8EpKD0rTalN
         xO+XF+SNL0X9XNpnS4M5PLg9xYdvFzF8gfGoJtB68F/FjUsjTrFbaRa3O7KL1QWngiYA
         swfw==
X-Gm-Message-State: APjAAAXu+64ubFtR6sbDlsZZfIpBlM/GZZtHr4s2BF7GVSJrYuPRly91
        3ElrhdZo6rtos2X+aZSlKObhdhl+sKRhpU8uz0s7lwh5QSbbxBpI9IGjVMxV2pOTy7TFt/5pUEE
        QHGj0E9jZ83Ll
X-Received: by 2002:a37:9345:: with SMTP id v66mr4783226qkd.195.1575489152870;
        Wed, 04 Dec 2019 11:52:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmm8jnKWcmw4+PPJFHhDL8CRLCxfukJjz5uZsgYx4DOnQ3LuvLF7qvQ1/vOwQrDYghrXaqbA==
X-Received: by 2002:a37:9345:: with SMTP id v66mr4783190qkd.195.1575489152545;
        Wed, 04 Dec 2019 11:52:32 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id t9sm453529qkt.112.2019.12.04.11.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:52:31 -0800 (PST)
Date:   Wed, 4 Dec 2019 14:52:30 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191204195230.GF19939@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
MIME-Version: 1.0
In-Reply-To: <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: Wk397ZESNdWq_c_XloFGYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 12:04:53PM +0100, Paolo Bonzini wrote:
> On 04/12/19 11:38, Jason Wang wrote:
> >>
> >> +=C2=A0=C2=A0=C2=A0 entry =3D &ring->dirty_gfns[ring->dirty_index & (r=
ing->size - 1)];
> >> +=C2=A0=C2=A0=C2=A0 entry->slot =3D slot;
> >> +=C2=A0=C2=A0=C2=A0 entry->offset =3D offset;
> >=20
> >=20
> > Haven't gone through the whole series, sorry if it was a silly question
> > but I wonder things like this will suffer from similar issue on
> > virtually tagged archs as mentioned in [1].
>=20
> There is no new infrastructure to track the dirty pages---it's just a
> different way to pass them to userspace.
>=20
> > Is this better to allocate the ring from userspace and set to KVM
> > instead? Then we can use copy_to/from_user() friends (a little bit slow
> > on recent CPUs).
>=20
> Yeah, I don't think that would be better than mmap.

Yeah I agree, because I didn't see how copy_to/from_user() helped to
do icache/dcache flushings...

Some context here: Jason raised this question offlist first on whether
we should also need these flush_dcache_cache() helpers for operations
like kvm dirty ring accesses.  I feel like it should, however I've got
two other questions, on:

  - if we need to do flush_dcache_page() on kernel modified pages
    (assuming the same page has mapped to userspace), then why don't
    we need flush_cache_page() too on the page, where
    flush_cache_page() is defined not-a-nop on those archs?

  - assuming an arch has not-a-nop impl for flush_[d]cache_page(),
    would atomic operations like cmpxchg really work for them
    (assuming that ISAs like cmpxchg should depend on cache
    consistency).

Sorry I think these are for sure a bit out of topic for kvm dirty ring
patchset, but since we're at it, I'm raising the questions up in case
there're answers..

Thanks,

--=20
Peter Xu


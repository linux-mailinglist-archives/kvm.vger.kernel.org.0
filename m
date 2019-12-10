Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA9118D28
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 17:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfLJQCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 11:02:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20897 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727178AbfLJQCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 11:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575993735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmrUnVVfu+gicASXeQuwmvLpG3WehUtcphinC4uDACQ=;
        b=Efr32DHdgvCyp/iJ1nYyqdMPtPhvgJhEHfKlrm58ZZSfPEM31oQhaeBFcyxsXc1/rUFzGT
        dSyEonrqep5RrWOGF+QlxQ2YRsPPg6sOZf6qwOgimbHRTbKLbcTzTkv8VQ/7ZuZlOrfim4
        wPZ/tV/DIp0ZoTRuZ9hXAUHYz/eI9Lw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-8Vcujk8jPumyUNV9fPe-Nw-1; Tue, 10 Dec 2019 11:02:14 -0500
Received: by mail-qt1-f197.google.com with SMTP id d9so2193840qtq.13
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 08:02:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KTRO4sKa0TSsx0s4k8rd2usE0Lc8/iEKmdicKPLyJcY=;
        b=Fys/ISOCwV5Ut6mp/7f+jpUcNCUPyxYBhB+WvG13Hu8PZsPYXtrjOOQ4WzxMIOxTzx
         ULe8KrNOjYtr+fRrfyKNbqyoOm7LpChLmQmhb4HOHg7pmJ6RNZfVG2F00yalOFpwfRdy
         Vv5mvsKDGPK2YW6zUMWKTB75VHzrgqLvcOIpEFD/fpM1B7wC2thtTgsUa2YYM8OxBxtU
         lb9Aiv10SkaoTMwvIAt4IEB/uE8LI8T2mQpDWQHjKI7tbDPWz6k/DgXwnGXe4HA6WJA+
         jcOJQ088sqS6I8AXAKDfYqh26ALNzZKwZQgCuLgFl45WYAL57VB0Dropw5e2a4U8YBUC
         YrRA==
X-Gm-Message-State: APjAAAXTYMtMcz+K8BFdzI2GAcUejXQRgIbqA1/ZIkiBsEXuUtTTAK7D
        T9RSe+fWTOkM+h/1o7QfNywtt25LCSQp3uXMs7G9XWdAmrlIPQF8mNyrCTsDUA0s05QZEEro/EY
        HE/0Kp0ua3RBN
X-Received: by 2002:ac8:6908:: with SMTP id e8mr18354345qtr.124.1575993733841;
        Tue, 10 Dec 2019 08:02:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFY9Zu4KFA0Cgq3rNYhbKTV85FtEH60qO0JD/0nPDQokpcMpqEq1wyebMhUioLku1+qtqLKg==
X-Received: by 2002:ac8:6908:: with SMTP id e8mr18354311qtr.124.1575993733549;
        Tue, 10 Dec 2019 08:02:13 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id x32sm1237252qtx.84.2019.12.10.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 08:02:12 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:02:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191210160211.GE3352@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
MIME-Version: 1.0
In-Reply-To: <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: 8Vcujk8jPumyUNV9fPe-Nw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
> On 10/12/19 14:25, Michael S. Tsirkin wrote:
> >> There is no new infrastructure to track the dirty pages---it's just a
> >> different way to pass them to userspace.
> > Did you guys consider using one of the virtio ring formats?
> > Maybe reusing vhost code?
>=20
> There are no used/available entries here, it's unidirectional
> (kernel->user).

Agreed.  Vring could be an overkill IMHO (the whole dirty_ring.c is
100+ LOC only).

>=20
> > If you did and it's not a good fit, this is something good to mention
> > in the commit log.
> >=20
> > I also wonder about performance numbers - any data here?
>=20
> Yes some numbers would be useful.  Note however that the improvement is
> asymptotical, O(#dirtied pages) vs O(#total pages) so it may differ
> depending on the workload.

Yes.  I plan to give some numbers when start to work on the QEMU
series (after this lands).  However as Paolo said, those numbers would
probably only be with some special case where I know the dirty ring
could win.  Frankly speaking I don't even know whether we should
change the default logging mode when the QEMU work is done - I feel
like the old logging interface is still good in many major cases
(small vms, or high dirty rates).  It could be that we just offer
another option when the user could consider to solve specific problems.

Thanks,

--=20
Peter Xu


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EFB11AB83
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 14:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfLKNEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 08:04:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728446AbfLKNEr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 08:04:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576069486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=668P4/OaTFkh0OL4KrzWbTMYtWCJ7hnKwvkYl6vOypI=;
        b=Nk+N/pawziQpWUkhC7J70w9e0IpB2Kl4yyZh+HEcKmvIk87BnsvvpOObAk2+LEguhWF1Q1
        s3ZQwLH0f1ndYYkp4ClcU9mjs95VBxLneVKOr22OsvQwjSPuYlJJpekD2llEbs9j9F3q1g
        LFS+AmzrNDrq3g1DvtMmxzShaxzHO20=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-mUDqozAsM_ClSJIGfXyBfw-1; Wed, 11 Dec 2019 08:04:42 -0500
Received: by mail-qk1-f198.google.com with SMTP id u30so2137850qke.13
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 05:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ARBDs3VLIa5a0RMtKyWzB3pZRG0sJsUGt9fBfh6q/08=;
        b=nzk8gFI2jM0Ik+LXN2CViwbj0Oc3GCqRjIFQ1d2k2HBa9cWuVVDeJmuR6DEn81r2F+
         sEr38B3Ps6h6CFMS9cTHiau5UVJ9pZifhel/1AwhEX3oLlD8fmr+e1rnJNaLu5GVtfaY
         gkuuN5Wko48hWMMXJ9pUwlxrQl0upirs+5+X8AybtIP/fS+NDIGoRug+6USxR6c+SoK8
         EmG2VlNXBP2xXa3dxlrk3tiTokxYmbW1pISwzegYIqxXdMaUbtu71V1OmiDKEyrIIfBs
         92MaXEYUOZnH9VVED7EPM81K/3SoR67VncxMItfUgizYZohJz5wXMBVJ8zMaXRvbopuH
         LIFQ==
X-Gm-Message-State: APjAAAXLZN1vW+y1QbQs8QMe2FZ8PSKDjhdbBJr0tZ4EOVpTN6CZ1sY3
        zEPkMlSFebnxGH3/lmRglYBO6SDf22NkCLJu3/o8yC6Kzq8Y+p9rgQe/eBcepdfKRnCES1l4uvb
        pwNkVe0e0Mt81
X-Received: by 2002:ac8:7491:: with SMTP id v17mr2569502qtq.154.1576069482494;
        Wed, 11 Dec 2019 05:04:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/4YfGzliqAf/Ryggut1GuwBdPupkaWePKoB8f6NY10Fx0F2PrhbbNHNNWZ0jnzd90OG1Ymw==
X-Received: by 2002:ac8:7491:: with SMTP id v17mr2569484qtq.154.1576069482284;
        Wed, 11 Dec 2019 05:04:42 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id g62sm647370qkd.25.2019.12.11.05.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 05:04:41 -0800 (PST)
Date:   Wed, 11 Dec 2019 08:04:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191211075413-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
 <20191210160211.GE3352@xz-x1>
 <20191210164908-mutt-send-email-mst@kernel.org>
 <1597a424-9f62-824b-5308-c9622127d658@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1597a424-9f62-824b-5308-c9622127d658@redhat.com>
X-MC-Unique: mUDqozAsM_ClSJIGfXyBfw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 10:05:28AM +0100, Paolo Bonzini wrote:
> On 10/12/19 22:53, Michael S. Tsirkin wrote:
> > On Tue, Dec 10, 2019 at 11:02:11AM -0500, Peter Xu wrote:
> >> On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
> >>> On 10/12/19 14:25, Michael S. Tsirkin wrote:
> >>>>> There is no new infrastructure to track the dirty pages---it's just=
 a
> >>>>> different way to pass them to userspace.
> >>>> Did you guys consider using one of the virtio ring formats?
> >>>> Maybe reusing vhost code?
> >>>
> >>> There are no used/available entries here, it's unidirectional
> >>> (kernel->user).
> >>
> >> Agreed.  Vring could be an overkill IMHO (the whole dirty_ring.c is
> >> 100+ LOC only).
> >=20
> > I guess you don't do polling/ event suppression and other tricks that
> > virtio came up with for speed then?

I looked at the code finally, there's actually available, and fetched is
exactly like used. Not saying existing code is a great fit for you as
you have an extra slot parameter to pass and it's reversed as compared
to vhost, with kernel being the driver and userspace the device (even
though vringh might fit, yet needs to be updated to support packed rings
though).  But sticking to an existing format is a good idea IMHO,
or if not I think it's not a bad idea to add some justification.

> There are no interrupts either, so no need for event suppression.  You
> have vmexits when the ring gets full (and that needs to be synchronous),
> but apart from that the migration thread will poll the rings once when
> it needs to send more pages.
>=20
> Paolo

OK don't use that then.

--=20
MST


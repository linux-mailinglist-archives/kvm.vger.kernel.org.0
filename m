Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61531189B1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 14:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfLJNZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 08:25:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49549 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727482AbfLJNZu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 08:25:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575984349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n00JJ/T4yzKQXwRZ4QxpKz4nx3mh99h11BJMbwluGO0=;
        b=W6CqnBuhL6HCkd9ohBUxRMPy9Q+PIbANNzZGx7h2iAsXLM1ufq924Rt2kcSOUV9t2Ud2bU
        D+CzFYoHeYKtq3C2GEDxtUXjhBDjJsFPN346gjR+dTOqchDks3q08BIaqJ7EHMB25Y1tsr
        iFGn6citLXe4zkHw6rsUVlqVwiafxm8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-6FclueA2PMe1pSCetGh9Iw-1; Tue, 10 Dec 2019 08:25:48 -0500
Received: by mail-wm1-f70.google.com with SMTP id p5so604209wmc.4
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 05:25:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=h/LUwbgV6TmsnuImnzKLy4kXaRWB507qnk8lk81yvpI=;
        b=oZu5J4nJISRcnYVEwWH5Wgz2lMrUKSX0ZxtIT+8O4fYvr6+NUujj4BUrn4QZan888U
         wEWSYA2kFwyD0GmHWjpc2xwGTfsmx+w04yNLIXEJJGhfdLdzv3kiCJt2/pR5uovKgajU
         2vEU8aAROl1dKbaQ08NLF4N3qZJ5M1mGUEW30RWSdBFtmWWQpE4m0vbws21aJqcOsbw9
         dwb7JcK09lgJ+Mw8s6GCIZvPzKx1E+BwFq5bkRIF7IpwtiLBFOBhy425ziUC64XY6ZPc
         lwFd/3HT0vIMhIB71UPRC1WWHNSrrBUxChRCkQDG74Xij6Qs5eJyNI2xX0TbxbbdvSB7
         205w==
X-Gm-Message-State: APjAAAWGbVWrwtf5TspZtem1lkeXh7ayjnjbDcVfzkD7YruYAD6QemGU
        jcMgfef1sSbf/FKHRV+F4KtyOdP5d1blTkgyM9OzqYMQAyfpzFXM1Agy8QS4700XgDuwQ4hn2XP
        uyhAwVILg0iw8
X-Received: by 2002:adf:b602:: with SMTP id f2mr3125150wre.99.1575984347508;
        Tue, 10 Dec 2019 05:25:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqycwvEm+aXyU7FL7AtjcKlWZq1DB7Nbgrk/qYzyK5Qdvd+vvqukZEz1jI6Kz5T5LwoE0oYz+Q==
X-Received: by 2002:adf:b602:: with SMTP id f2mr3125139wre.99.1575984347323;
        Tue, 10 Dec 2019 05:25:47 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id w17sm3212357wrt.89.2019.12.10.05.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:25:46 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:25:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191210081958-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
MIME-Version: 1.0
In-Reply-To: <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
X-MC-Unique: 6FclueA2PMe1pSCetGh9Iw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 12:04:53PM +0100, Paolo Bonzini wrote:
> On 04/12/19 11:38, Jason Wang wrote:
> >>
> >> +=A0=A0=A0 entry =3D &ring->dirty_gfns[ring->dirty_index & (ring->size=
 - 1)];
> >> +=A0=A0=A0 entry->slot =3D slot;
> >> +=A0=A0=A0 entry->offset =3D offset;
> >=20
> >=20
> > Haven't gone through the whole series, sorry if it was a silly question
> > but I wonder things like this will suffer from similar issue on
> > virtually tagged archs as mentioned in [1].
>=20
> There is no new infrastructure to track the dirty pages---it's just a
> different way to pass them to userspace.

Did you guys consider using one of the virtio ring formats?
Maybe reusing vhost code?

If you did and it's not a good fit, this is something good to mention
in the commit log.

I also wonder about performance numbers - any data here?


> > Is this better to allocate the ring from userspace and set to KVM
> > instead? Then we can use copy_to/from_user() friends (a little bit slow
> > on recent CPUs).
>=20
> Yeah, I don't think that would be better than mmap.
>=20
> Paolo
>=20
>=20
> > [1] https://lkml.org/lkml/2019/4/9/5


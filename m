Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AF611AE6A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 15:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfLKOyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 09:54:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727457AbfLKOyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 09:54:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576076053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTML3ZY4XajEGIMXTQF+X7InEuyoASYWfqymLI5iBaw=;
        b=ZLZifJk6o0dit61gUTp1Hd+hqFUEa+RcY3jSwIO2/DSSQeGS7gA4zCnJHwowBwGqpWHv8d
        xIYITfJW146nrfh/7eTAirsP2fzV1gDUacn1QLyZa/zu5jJNSf4ebXmZGC4OlYuv1XwWP9
        izJw1VhYi2MnQWqkGCB2GRUySGhEvnY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-VSMMGefSPRGCBwKr6_Fsag-1; Wed, 11 Dec 2019 09:54:12 -0500
Received: by mail-qv1-f71.google.com with SMTP id c22so9252348qvc.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 06:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=62xWb0cf1MCXJ37uAv39v37rLn99Ssaq3pAFUpU9gao=;
        b=PD8Mb8vvBp1soQ4PkbzyxrGpTnvu9y5v3P2QXk1Ghjo3Fueb3FCAf8p5H/tiwktZVn
         F5Y7fKJlFmfbRtiMd/tqgPW1fL4+YBmCPlmMa3xm1uXOHTUO6PuFsOMGMvtHHMj9Fk9U
         5jaBeuG/YrRFq4R2qFbXlRlKjQtWjTALQuExJzNIkvM3pMpJT1gQ1aXic8qm2oZvPBE+
         K+XV7HL2mgklSf8b1qOnX6tvYXgtkRVvWq1iu+QKNu6C/Nl8Rq+qIiKu0QHsiVohJVap
         5O04fIq6xskoCjCquKIfGv6l+AELSb8qk515ELZq5zfRUBQibTtL4RqjVfIwIp68S5uf
         Q01Q==
X-Gm-Message-State: APjAAAUSKT+BA0xQy+EuysgTZQ7VnfeCdsmlNUN8dM7hcCK7/mQQ5KEz
        7G8npv1UiCvRhqjUmyFs9mcOBd+y57TRD1xKLrYFSJdFlus2iYua24MSINAFX1IOSY4EdytYHE7
        nITcH5EYFEyB1
X-Received: by 2002:a0c:d4aa:: with SMTP id u39mr3348808qvh.76.1576076052100;
        Wed, 11 Dec 2019 06:54:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6Z1czXLZJjBLnmWHepFgS8gviQBQkXR+INEflNGPDvrBHCj0nHMpXc8tT4MJlNfYGagK0Vw==
X-Received: by 2002:a0c:d4aa:: with SMTP id u39mr3348791qvh.76.1576076051828;
        Wed, 11 Dec 2019 06:54:11 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id g16sm727342qkk.61.2019.12.11.06.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:54:11 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:54:04 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191211145404.GC48697@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
 <20191210160211.GE3352@xz-x1>
 <20191210164908-mutt-send-email-mst@kernel.org>
 <1597a424-9f62-824b-5308-c9622127d658@redhat.com>
 <20191211075413-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191211075413-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: VSMMGefSPRGCBwKr6_Fsag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 08:04:36AM -0500, Michael S. Tsirkin wrote:
> On Wed, Dec 11, 2019 at 10:05:28AM +0100, Paolo Bonzini wrote:
> > On 10/12/19 22:53, Michael S. Tsirkin wrote:
> > > On Tue, Dec 10, 2019 at 11:02:11AM -0500, Peter Xu wrote:
> > >> On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
> > >>> On 10/12/19 14:25, Michael S. Tsirkin wrote:
> > >>>>> There is no new infrastructure to track the dirty pages---it's ju=
st a
> > >>>>> different way to pass them to userspace.
> > >>>> Did you guys consider using one of the virtio ring formats?
> > >>>> Maybe reusing vhost code?
> > >>>
> > >>> There are no used/available entries here, it's unidirectional
> > >>> (kernel->user).
> > >>
> > >> Agreed.  Vring could be an overkill IMHO (the whole dirty_ring.c is
> > >> 100+ LOC only).
> > >=20
> > > I guess you don't do polling/ event suppression and other tricks that
> > > virtio came up with for speed then?
>=20
> I looked at the code finally, there's actually available, and fetched is
> exactly like used. Not saying existing code is a great fit for you as
> you have an extra slot parameter to pass and it's reversed as compared
> to vhost, with kernel being the driver and userspace the device (even
> though vringh might fit, yet needs to be updated to support packed rings
> though).  But sticking to an existing format is a good idea IMHO,
> or if not I think it's not a bad idea to add some justification.

Right, I'll add a small paragraph in the next cover letter to justify.

Thanks,

--=20
Peter Xu


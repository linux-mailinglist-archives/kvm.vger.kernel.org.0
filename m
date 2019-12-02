Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8DA10F1C9
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLBUxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:53:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725775AbfLBUxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 15:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575319999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nzdSrqDoDaZLrr7Z/HI4Eq39Uy86S9VN5wk5kCYVuo=;
        b=IJ8JoxdeEEDHWNI9ox3pZNDY9y5APrd2wWDey2ygLjbu2IB5BjCUDN9JLPEA/XqhLinDKQ
        5hL5+M6rjKkignNsWYv0qUXD9Ulnq5N29u6pNu4cGKNp1+4AzEKohuC6pBrBAIV5+3IIrV
        UW9FGZ09uEThZQrteUzc1DF2kvJklo4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-WBDQWXqPMeS9sSD46qkBDw-1; Mon, 02 Dec 2019 15:53:18 -0500
Received: by mail-qv1-f71.google.com with SMTP id c22so637891qvc.1
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:53:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oxwwpQ4RKFsIi9Z+fAteD9Dt6Rn16jWGk/RGrFjPOZw=;
        b=qdGrKGBm+VQy1V4Y9gRLp3WPPw916jW9W663IJugL86kWrHpaZk4YiRqBiDOmMvusj
         tm9+TWrk45YhsroxMvrwLQBNtM37XefYQzzDZhNI5i9jSTO1pWmhMfsXGbyvWXhzdECT
         SUsy1VrianFRw24ZH3Uws0hRxZfCorpIhvO0c9l0EWniFsHs+Mk/GG8U0EGTjRU0UGfB
         Z2krvs91VTpdBJky+4nI6j6n7/Z/30oxiwBeh36W9XVgtTIoD85ka26jVrthUpTyz/AI
         k8T0JnjF3Ia8wuDXCROI3lMCyfPevuauelNrZqCDKVUiD+hMiLgGsFVRDsNE/FjQav0x
         j4YA==
X-Gm-Message-State: APjAAAX5BzjBI1uOFP3DolRTPg5dCwxQtjBiNro3OdY/p+v19LSr3lBs
        w5bGyK5HQG3MyXxEWzR12a8GWE4evoO8d6gVJHXKz0QqNR3sFyU7yp85qWxm4rSEAyTjCOmQhc2
        nosDmbh4UKTiD
X-Received: by 2002:a0c:b620:: with SMTP id f32mr1253047qve.186.1575319997701;
        Mon, 02 Dec 2019 12:53:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7RyIukmiE0taxCXnf2NVIwHKmA/H+hHrpLPg20zIZotwqa6rW+f0MZ8dYn31XxuPk+tkkiQ==
X-Received: by 2002:a0c:b620:: with SMTP id f32mr1253022qve.186.1575319997404;
        Mon, 02 Dec 2019 12:53:17 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d6sm410396qtn.16.2019.12.02.12.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:53:16 -0800 (PST)
Date:   Mon, 2 Dec 2019 15:53:15 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
Message-ID: <20191202205315.GD31681@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-4-peterx@redhat.com>
 <20191202193027.GH4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202193027.GH4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: WBDQWXqPMeS9sSD46qkBDw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 11:30:27AM -0800, Sean Christopherson wrote:
> On Fri, Nov 29, 2019 at 04:34:53PM -0500, Peter Xu wrote:
> > It's already going to reach 2400 Bytes (which is over half of page
> > size on 4K page archs), so maybe it's good to have this build-time
> > check in case it overflows when adding new fields.
>=20
> Please explain why exceeding PAGE_SIZE is a bad thing.  I realize it's
> almost absurdly obvious when looking at the code, but a) the patch itself
> does not provide that context and b) the changelog should hold up on its
> own,

Right, I'll enhance the commit message.

> e.g. in a mostly hypothetical case where the allocation of vcpu->run
> were changed to something else.

And that's why I added BUILD_BUG_ON right beneath that allocation. :)

It's just a helper for developers when adding new kvm_run fields, not
a risk for anyone who wants to start allocating more pages for it.

Thanks,

>=20
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 8f8940cc4b84..681452d288cd 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -352,6 +352,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm=
 *kvm, unsigned id)
> >  =09}
> >  =09vcpu->run =3D page_address(page);
> > =20
> > +=09BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
> > +
> >  =09kvm_vcpu_set_in_spin_loop(vcpu, false);
> >  =09kvm_vcpu_set_dy_eligible(vcpu, false);
> >  =09vcpu->preempted =3D false;
> > --=20
> > 2.21.0
> >=20
>=20

--=20
Peter Xu


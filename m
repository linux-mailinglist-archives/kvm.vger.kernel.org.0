Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F596118D13
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfLJPxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 10:53:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727440AbfLJPxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 10:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575993182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7Wkuo5DOrROzVyUdQcO7Id9YJhb4KcA4EFLGC9qzM8=;
        b=V9A8Is0U3DRFP8i6swiFb+jykQmeWthfs8OmOuyqiR77nokwjNWU1tKxqyvdjQhb5Uqpqy
        6xATPgaIPdTKWTsKQY0FbKPVZHDox3mNB9DpA0HzfjgVtQoNURAlqnIJRetj1MBhbSHk9k
        N0pRG24GIRNKGudysFlmTQUu1FWXROA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-HD24bgSTOzmiPyNvotEeZA-1; Tue, 10 Dec 2019 10:53:01 -0500
Received: by mail-qt1-f200.google.com with SMTP id m8so2152558qta.20
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 07:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CTMg4TU0Xzm9Sp3cKGL3NKbE9vCAJaofWeL0HT4DNMU=;
        b=Cu+V4l8UVis6l1fGe6F7bOVQxABaYEepPNf21fkIaEGGWKg6GgQUixoY+bbl0NL4OQ
         cEfagoFjllY6QryVop+8bb7PAkpWRbEgR6qsfC9Gtji4ux95hwybxx1WmjbpEi4ZgKik
         lx+hCTFgbwHuM5PVnB/vMTBuCX01LpAus9YLHbWSCD3HX0+CzVDMmQEgvrDYmBRjxxcC
         QoP0YlLEgD3xZNqCW/Rz3Nlw+yd+XVWLqM7o8hILBrUQvEt1KoKinuFGFQT4uUNP1dVX
         kyUZoCnWnWhVdhsdN959LM1CxJtLSn+2rGNNxikJUp948ca4gBr+Lxr6eJoNwx7dBEVu
         U0EA==
X-Gm-Message-State: APjAAAWL/7magvDfl33qnmWDjwPcGWVVLACLghrlxUy2yKRxrcRQwgqq
        eRuD7RdZqNbKb4cbgTV2kuDSFQ7mxfjoR316Yk/fObxoUZr0otiB49tD9AZvh7hmNCMwMwNscTH
        /0c6HxKTWbY9E
X-Received: by 2002:aed:2469:: with SMTP id s38mr4423845qtc.172.1575993181257;
        Tue, 10 Dec 2019 07:53:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQcTBiI7P3OeRYMxxzIss87EQVvdXW+O/wzbi1TnkUtQrmno9BbevPH1mBp0ZhCa/2sQMpbA==
X-Received: by 2002:aed:2469:: with SMTP id s38mr4423817qtc.172.1575993180966;
        Tue, 10 Dec 2019 07:53:00 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id 4sm1040383qki.51.2019.12.10.07.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 07:53:00 -0800 (PST)
Date:   Tue, 10 Dec 2019 10:52:59 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191210155259.GD3352@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
MIME-Version: 1.0
In-Reply-To: <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: HD24bgSTOzmiPyNvotEeZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 11:07:31AM +0100, Paolo Bonzini wrote:
> > I'm thinking whether I can start
> > to use this information in the next post on solving an issue I
> > encountered with the waitqueue.
> >=20
> > Current waitqueue is still problematic in that it could wait even with
> > the mmu lock held when with vcpu context.
>=20
> I think the idea of the soft limit is that the waiting just cannot
> happen.  That is, the number of dirtied pages _outside_ the guest (guest
> accesses are taken care of by PML, and are subtracted from the soft
> limit) cannot exceed hard_limit - (soft_limit + pml_size).

So the question go backs to, whether this is guaranteed somehow?  Or
do you prefer us to keep the warn_on_once until it triggers then we
can analyze (which I doubt..)?

One thing to mention is that for with-vcpu cases, we probably can even
stop KVM_RUN immediately as long as either the per-vm or per-vcpu ring
reaches the softlimit, then for vcpu case it should be easier to
guarantee that.  What I want to know is the rest of cases like ioctls
or even something not from the userspace (which I think I should read
more later..).

If the answer is yes, I'd be more than glad to drop the waitqueue.

>=20
> > The issue is KVM_RESET_DIRTY_RINGS needs the mmu lock to manipulate
> > the write bits, while it's the only interface to also wake up the
> > dirty ring sleepers.  They could dead lock like this:
> >=20
> >       main thread                            vcpu thread
> >       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                            =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >                                              kvm page fault
> >                                                mark_page_dirty_in_slot
> >                                                mmu lock taken
> >                                                mark dirty, ring full
> >                                                queue on waitqueue
> >                                                (with mmu lock)
> >       KVM_RESET_DIRTY_RINGS
> >         take mmu lock               <------------ deadlock here
> >         reset ring gfns
> >         wakeup dirty ring sleepers
> >=20
> > And if we see if the mark_page_dirty_in_slot() is not with a vcpu
> > context (e.g. kvm_mmu_page_fault) but with an ioctl context (those
> > cases we'll use per-vm dirty ring) then it's probably fine.
> >=20
> > My planned solution:
> >=20
> > - When kvm_get_running_vcpu() !=3D NULL, we postpone the waitqueue wait=
s
> >   until we finished handling this page fault, probably in somewhere
> >   around vcpu_enter_guest, so that we can do wait_event() after the
> >   mmu lock released
>=20
> I think this can cause a race:
>=20
> =09vCPU 1=09=09=09vCPU 2=09=09host
> =09---------------------------------------------------------------
> =09mark page dirty
> =09=09=09=09write to page
> =09=09=09=09=09=09treat page as not dirty
> =09add page to ring
>=20
> where vCPU 2 skips the clean-page slow path entirely.

If we're still with the rule in userspace that we first do RESET then
collect and send the pages (just like what we've discussed before),
then IMHO it's fine to have vcpu2 to skip the slow path?  Because
RESET happens at "treat page as not dirty", then if we are sure that
we only collect and send pages after that point, then the latest
"write to page" data from vcpu2 won't be lost even if vcpu2 is not
blocked by vcpu1's ring full?

Maybe we can also consider to let mark_page_dirty_in_slot() return a
value, then the upper layer could have a chance to skip the spte
update if mark_page_dirty_in_slot() fails to mark the dirty bit, so it
can return directly with RET_PF_RETRY.

Thanks,

--=20
Peter Xu


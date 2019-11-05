Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6B4F006B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 15:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389681AbfKEO5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 09:57:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389628AbfKEO5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 09:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572965827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEZHakZ/d1soyr+G6fFBZtfVSOtoyc+a/+kprjYqw1o=;
        b=LJo/Lmae5ueVpRtxTUbvdXG0TUMEPkKTNFj8qC3x6jAy+F2zgKexO69Btge1f2egoFm/Ax
        ho28aIM/MtVxc2aLEnVsU06nYuZ6q8murgoVHTJPVv059RX3k4j0YvC28lRu3n8OhPOyRT
        vZGILjlQsq7tJEzJdYhd8yyg4QhZZKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-pODoF3CRNrSfU86NQQcmKg-1; Tue, 05 Nov 2019 09:57:03 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A272C477;
        Tue,  5 Nov 2019 14:57:01 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CE891001DC0;
        Tue,  5 Nov 2019 14:56:52 +0000 (UTC)
Date:   Tue, 5 Nov 2019 09:56:51 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jessica Yu <jeyu@kernel.org>,
        Matthias Maennich <maennich@google.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Message-ID: <20191105145651.GD30717@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
MIME-Version: 1.0
In-Reply-To: <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: pODoF3CRNrSfU86NQQcmKg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 03:09:37PM +0100, Paolo Bonzini wrote:
> You can reorder patches so that kvm_x86_ops assignments never happen.
> That way, 4/13 for example would be moved to the very beginning.

Ok 3/13 and 4/14 can both go before 2/13, I reordered them fine, the
end result at least is the same and the intermediate result should
improve. Hopefully this is the best solution for those two outliers.

Once this is committed I expect Sean to take over 4/14 with a more
optimal version to get rid of that branch like he proposed initially.

> >> - look into how to remove the modpost warnings.  A simple (though
> >> somewhat ugly) way is to keep a kvm.ko module that includes common
> >> virt/kvm/ code as well as, for x86 only, page_track.o.  A few function=
s,
> >> such as kvm_mmu_gfn_disallow_lpage and kvm_mmu_gfn_allow_lpage, would
> >> have to be moved into mmu.h, but that's not a big deal.
> >=20
> > I think we should:
> >=20
> > 1) whitelist to shut off the warnings on demand
>=20
> Do you mean adding a whitelist to modpost?  That would work, though I am
> not sure if the module maintainer (Jessica Yu) would accept that.

Yes that's exactly what I meant.

> > 2) verify that if two modules are registering the same export symbol
> >    the second one fails to load and the module code is robust about
> >    that, this hopefully should already be the case
> >=20
> > Provided verification of 2), the whitelist is more efficient than
> > losing 4k of ram in all KVM hypervisors out there.
>=20
> I agree.

Ok, so I enlarged the CC list accordingly to check how the whitelist
can be done in modpost.

> >> - provide at least some examples of replacing the NULL kvm_x86_ops
> >> checks with error codes in the function (or just early "return"s).  I
> >> can help with the others, but remember that for the patch to be merged=
,
> >> kvm_x86_ops must be removed completely.
> >=20
> > Even if kvm_x86_ops wouldn't be guaranteed to go away, this would
> > already provide all the performance benefit to the KVM users, so I
> > wouldn't see a reason not to apply it even if kvm_x86_ops cannot go
> > away.
>=20
> The answer is maintainability.  My suggestion is that we start looking
> into removing all assignments and tests of kvm_x86_ops, one step at a
> time.  Until this is done, unfortunately we won't be able to reap the
> performance benefit.  But the advantage is that this can be done in many

There's not much performance benefit left from the removal
kvm_x86_ops. It'll only remove a few branches at best (and only if we
don't have to replace the branches on the pointer check with other
branches on a static variable to disambiguate the different cases).

> separate submissions; it doesn't have to be one huge patch.
>=20
> Once this is done, removing kvm_x86_ops is trivial in the end.  It's
> okay if the intermediate step has minimal performance regressions, we
> know what it will look like.  I have to order patches with maintenance
> first and performance second, if possible.

The removal of kvm_x86_ops is just a badly needed code cleanup and of
course I agree it must happen sooner than later. I'm just trying to
avoid running into rejects on those further commit cleanups too.

> By the way, we are already planning to make some module parameters
> per-VM instead of global, so this refactoring would also help that effort=
.
>
> > Said that it will go away and there's no concern about it. It's
> > just that the patchset seems large enough already and it rejects
> > heavily already at every port. I simply stopped at the first self
> > contained step that provides all performance benefits.
>=20
> That is good enough to prove the feasibility of the idea, so I agree
> that was a good plan.

All right, so I'm not exactly sure what's the plan and if it's ok to
do it over time or if I should go ahead doing all logic changes while
the big patch remains out of tree.

If you apply it and reorder 4/13 and 3/13 before 2/13 in a rebase like
I did locally, it should already be good starting point in my view and
the modpost also can be fixed over time too, the warnings appears
harmless so far.

Thanks,
Andrea


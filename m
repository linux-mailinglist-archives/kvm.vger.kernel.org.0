Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8291CEFF0C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 14:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbfKENyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 08:54:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54330 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388615AbfKENyV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 08:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572962060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPzADiipN47QPgXt2IGh+jPKvV3zaficOk9JUTgI2GU=;
        b=UdcS96y9kzV+rR5z5MlTvPnHp6LqgQwjRCGRuE5fnt2FNr8Kx3h3WtXepnuDoAkGRhH605
        9xenEINSz2/uGoPx7lpVVXVVJ036Px8y1gyZtzLSmbp1ww4MjUDGlG8odxD+Gc5qMqYj7q
        bJXdJRVUUxvmEdgijrHORIwchu8ldNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-eEgf_IbvNgWojIsO_UJlcQ-1; Tue, 05 Nov 2019 08:54:17 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 486708017DD;
        Tue,  5 Nov 2019 13:54:15 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 222F85D9C9;
        Tue,  5 Nov 2019 13:54:15 +0000 (UTC)
Date:   Tue, 5 Nov 2019 08:54:14 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Message-ID: <20191105135414.GA30717@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
MIME-Version: 1.0
In-Reply-To: <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: eEgf_IbvNgWojIsO_UJlcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 11:37:47AM +0100, Paolo Bonzini wrote:
> For the rest, please do this before posting again:
>=20
> - ensure that everything is bisectable

x86-64 is already bisectable.

All other archs bisectable I didn't check them all anyway.

Even 4/13 is suboptimal and needs to be re-done later in more optimal
way. I prefer all logic changes to happen at later steps so one can at
least bisect to something that functionally works like before. And
4/13 also would need to be merged in the huge patch if one wants to
guarantee bisectability on all CPUs, but it'll just be hidden there in
the huge patch.

Obviously I can squash both 3/13 and 4/13 into 2/13 but I don't feel
like doing the right thing by squashing them just to increase
bisectability.

> - look into how to remove the modpost warnings.  A simple (though
> somewhat ugly) way is to keep a kvm.ko module that includes common
> virt/kvm/ code as well as, for x86 only, page_track.o.  A few functions,
> such as kvm_mmu_gfn_disallow_lpage and kvm_mmu_gfn_allow_lpage, would
> have to be moved into mmu.h, but that's not a big deal.

I think we should:

1) whitelist to shut off the warnings on demand

2) verify that if two modules are registering the same export symbol
   the second one fails to load and the module code is robust about
   that, this hopefully should already be the case

Provided verification of 2), the whitelist is more efficient than
losing 4k of ram in all KVM hypervisors out there.

> - provide at least some examples of replacing the NULL kvm_x86_ops
> checks with error codes in the function (or just early "return"s).  I
> can help with the others, but remember that for the patch to be merged,
> kvm_x86_ops must be removed completely.

Even if kvm_x86_ops wouldn't be guaranteed to go away, this would
already provide all the performance benefit to the KVM users, so I
wouldn't see a reason not to apply it even if kvm_x86_ops cannot go
away. Said that it will go away and there's no concern about it. It's
just that the patchset seems large enough already and it rejects
heavily already at every port. I simply stopped at the first self
contained step that provides all performance benefits.

If I go ahead and remove kvm_x86_ops how do I know it won't reject
heavily the next day I rebase and I've to redo it all from scratch? If
you explain me how you're going to guarantee that I won't have to do
that work more than once I'd be happy to go ahead.

Thanks,
Andrea


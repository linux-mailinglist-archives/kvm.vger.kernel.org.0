Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242DC10F2EB
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 23:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfLBWkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 17:40:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29614 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725899AbfLBWkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 17:40:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575326439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwCovQ1A2FIuM4qGkGFZtb5WeOCUje3jnQT4pB8ARrA=;
        b=eI/hrgGFw+B/JoC1Lqw7fK1Vogb/BKh2mq0oXH4FNUsWHLEYcCDG/hITTmJQrhB7fqBJ7A
        mS5+Xlq4ZiUsg8gPaA8GQXomzKXGSf34X66+hSvCjI89g4qbNzjvyBh3iT6mkl61aDl4Bl
        dd4nQI3UT0gtLUf0E1P5qddCiJnn/UY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-cCBvuz62PxakOrpSLIySqw-1; Mon, 02 Dec 2019 17:40:38 -0500
Received: by mail-qt1-f200.google.com with SMTP id x8so1009163qtq.14
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 14:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A88TYrr+6QOTlvqShlweWdE3g666CkKb/QVajbFrpQI=;
        b=XSl4y+rwEeooTgN2WV1ypzDXhDOjwv3fNEfD09ZwhpQTMNqKm8w5ISEMDsV3KM+phN
         xa+dD16e8Z3L/oP8R8UbxMInFa+pSGeAm56Fk2dLaie2L2xcdNWX8DOLMaNIDugJLJX6
         nAHW1eur6/bKLV4iI+zaTRBczQ7Uw5V8ah6ghKamIHIf5AnmF15o0PB4sTiQpSA8bfCE
         5XqPgFiCir+9UaWizFVidhQNTDXuRjmz7HA4prKJNRIBklDeZ2Kkk1quRtS7/GCVlGEn
         CBDmeWFR2vDLxuJHkVhuXV5kA6nGyJqIn/H4pX5sfGzSsp2ESEguqAfKCNZ25eO7TErJ
         6HXA==
X-Gm-Message-State: APjAAAVbaaCRegdq7x8bMeXoohbSnsZxhDEmrIrA/yD+JO/wxZKszaSU
        Kor+6RjLu0xDSJtONOu5a8D7rnECco9BSBwYaanqC/ZxxvxtdQ6lCNJyEVMsbPYC99V+E/IYFsQ
        ASVqezminFqcU
X-Received: by 2002:ac8:2632:: with SMTP id u47mr2029166qtu.54.1575326437883;
        Mon, 02 Dec 2019 14:40:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0JXhcvRX7e044tXudZta8UN6SWffpQCBnM5ZwWBduteqD4RVUl21bTGrSw2DHFn+vpV/4cA==
X-Received: by 2002:ac8:2632:: with SMTP id u47mr2029148qtu.54.1575326437538;
        Mon, 02 Dec 2019 14:40:37 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::3])
        by smtp.gmail.com with ESMTPSA id o10sm519593qtp.38.2019.12.02.14.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 14:40:36 -0800 (PST)
Date:   Mon, 2 Dec 2019 17:40:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
Message-ID: <20191202224034.GH31681@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-4-peterx@redhat.com>
 <20191202193027.GH4063@linux.intel.com>
 <20191202205315.GD31681@xz-x1>
 <20191202221949.GD8120@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202221949.GD8120@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: cCBvuz62PxakOrpSLIySqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 02:19:49PM -0800, Sean Christopherson wrote:
> On Mon, Dec 02, 2019 at 03:53:15PM -0500, Peter Xu wrote:
> > On Mon, Dec 02, 2019 at 11:30:27AM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 29, 2019 at 04:34:53PM -0500, Peter Xu wrote:
> > > > It's already going to reach 2400 Bytes (which is over half of page
> > > > size on 4K page archs), so maybe it's good to have this build-time
> > > > check in case it overflows when adding new fields.
> > >=20
> > > Please explain why exceeding PAGE_SIZE is a bad thing.  I realize it'=
s
> > > almost absurdly obvious when looking at the code, but a) the patch it=
self
> > > does not provide that context and b) the changelog should hold up on =
its
> > > own,
> >=20
> > Right, I'll enhance the commit message.
> >=20
> > > e.g. in a mostly hypothetical case where the allocation of vcpu->run
> > > were changed to something else.
> >=20
> > And that's why I added BUILD_BUG_ON right beneath that allocation. :)
>=20
> My point is that if the allocation were changed to no longer be a
> straightforward alloc_page() then someone reading the combined code would
> have no idea why the BUILD_BUG_ON() exists.  It's a bit ridiculous for
> this case because the specific constraints of vcpu->run make it highly
> unlikely to use anything else, but that's beside the point.
>=20
> > It's just a helper for developers when adding new kvm_run fields, not
> > a risk for anyone who wants to start allocating more pages for it.
>=20
> But by adding a BUILD_BUG_ON without explaining *why*, you're placing an
> extra burden on someone that wants to increase the size of kvm->run, e.g.
> it's not at all obvious from the changelog whether this patch is adding
> the BUILD_BUG_ON purely because the code allocates memory for vcpu->run
> via alloc_page(), or if there is some fundamental aspect of vcpu->run tha=
t
> requires it to never span multiple pages.

How about I add a comment above it?

  /*
   * Currently kvm_run only uses one physical page.  Warn the develper
   * if kvm_run accidentaly grows more than that.
   */
  BUILD_BUG_ON(...);

Thanks,

--=20
Peter Xu


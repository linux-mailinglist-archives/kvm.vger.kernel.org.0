Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEF3110320
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 18:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLCREm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 12:04:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726449AbfLCREk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 12:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8DvubUvc77D7QCd7w64sRjJyRVQE6dAmn4FvsDL5hw=;
        b=Zwge6x1Cpd4kSfnN+vFCPy8cyr1lqsJ02b2KIJkVLr84j1ZgLOyOnibGSJJMrRxC890dYU
        z2OimvDujGGZTLHRTnkYhzihaCZHeCbNl+zsBMg7whHWU07Vr17IskH+afRj6iUFTU0YVP
        sobin6L0Okzt8P5fJlsGM+fRahtOrN4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-vqH3Sj27OYSwzZzJqNIBmg-1; Tue, 03 Dec 2019 12:04:36 -0500
Received: by mail-qv1-f70.google.com with SMTP id p9so2576380qvq.22
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 09:04:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GwSc2v/NazflzpFrOlkNA8IEQZUbi7+GF+4oI30XE/w=;
        b=U1wDxJY9BglmeiBXpBEaqCwfT1SIUyVozLe9/7xrHUMTykBpi70e5wqW6z5Lv4+zhh
         Mmh2ss93967Alr8L9lRYjM9CFjoyDYgWCCMeFi/TkQDDbZpGB6/Cg9/VheyVRBhy21nS
         sJwWQcaTVbltR4TfjHyae6FCWZVog8Nwn0nrx/I91SkQbtf2Z6jNx55/3eTVoFfW15UT
         KmdNk424AV92hYWlX6GEbxBFVjlnAvNrAH9wXmhP/nUmIlWhDyyZvt5s50XVGqzsR5QG
         nwxlAJhjnQ9vZEIRMCnz1rQk2/kJGIVG46VdCXKvwVy6rHpkZV/2iIcG/IyWHwgz4bUS
         xJwQ==
X-Gm-Message-State: APjAAAUVI1gM2esAIOAGQb2xmdBOt5h14RcgMtcUgY5FNo62y4eZZG6Q
        huUbAp8RHpEiZoJ23CJlgcGQWk9e3OFk93/df0CcKLXZOuElxSabh2Pfp7GeUfPNFgr1Hck3zmV
        wYSbkpY/F5Au+
X-Received: by 2002:ae9:ed43:: with SMTP id c64mr5709438qkg.78.1575392675444;
        Tue, 03 Dec 2019 09:04:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxETwyoGLSM2JBWDT+YiR0hnGqeVSXHwTu0/n3KH8ZbAv41W1TPnYnRnlWUEQgCwYJO0Iavvw==
X-Received: by 2002:ae9:ed43:: with SMTP id c64mr5709327qkg.78.1575392674409;
        Tue, 03 Dec 2019 09:04:34 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l130sm2062530qke.33.2019.12.03.09.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 09:04:33 -0800 (PST)
Date:   Tue, 3 Dec 2019 12:04:32 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
Message-ID: <20191203170432.GF17275@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-4-peterx@redhat.com>
 <20191202193027.GH4063@linux.intel.com>
 <20191202205315.GD31681@xz-x1>
 <20191202221949.GD8120@linux.intel.com>
 <ee107756-12d2-2de0-bb05-a23616346b6d@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ee107756-12d2-2de0-bb05-a23616346b6d@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: vqH3Sj27OYSwzZzJqNIBmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:41:58PM +0100, Paolo Bonzini wrote:
> On 02/12/19 23:19, Sean Christopherson wrote:
> >>> e.g. in a mostly hypothetical case where the allocation of vcpu->run
> >>> were changed to something else.
> >> And that's why I added BUILD_BUG_ON right beneath that allocation. :)
>=20
> It's not exactly beneath it (it's out of the patch context at least).  I
> think a comment is not strictly necessary, but a better commit message
> is and, since you are at it, I would put the BUILD_BUG_ON *before* the
> allocation.  That makes it more obvious that you are checking the
> invariant before allocating.

Makes sense, will do.  Thanks for both of your reviews.

--=20
Peter Xu


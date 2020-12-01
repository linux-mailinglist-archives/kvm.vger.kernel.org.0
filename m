Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1A2CAB39
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 20:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgLAS7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 13:59:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730132AbgLAS66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 13:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606849051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pAuzzb7BbpYaUN9NyFBwlGuXTmyHgvRWMaZqHnBmRH4=;
        b=WPgloV7dX5nFKF9E2oaBWtyLQvqI1VV3q09nvg+JO3HrHivUt1X5WzGaHwppgsxxE5Blrd
        TlGP+iEKW0vn+Q/aGWxpq4+eUJcji/s2Ly0QsO5Uqs17u1Y8dUTB6vvEpLdwDeu645RWSX
        q/ASJMBkx+tOQQfam2Uy11zzGuEQCSs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-VQlruColOxuQAe-pFoReoQ-1; Tue, 01 Dec 2020 13:57:28 -0500
X-MC-Unique: VQlruColOxuQAe-pFoReoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 138F98581A4;
        Tue,  1 Dec 2020 18:57:26 +0000 (UTC)
Received: from work-vm (ovpn-115-1.ams2.redhat.com [10.36.115.1])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9826710021AA;
        Tue,  1 Dec 2020 18:57:20 +0000 (UTC)
Date:   Tue, 1 Dec 2020 18:57:17 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 01/11] memattrs: add debug attribute
Message-ID: <20201201185717.GN4338@work-vm>
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
 <CAFEAcA8eiyzUbHXQip1sT_TrT+Mfv-WG8cSMmM-w_eOFShAMzQ@mail.gmail.com>
 <20201201115047.GA15055@work-vm>
 <CAFEAcA_cdixD7jvu68snUU=PN2xQow1W2goKjshfdF9jGb2dBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA_cdixD7jvu68snUU=PN2xQow1W2goKjshfdF9jGb2dBQ@mail.gmail.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Tue, 1 Dec 2020 at 11:51, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> >
> > * Peter Maydell (peter.maydell@linaro.org) wrote:
> > > On Mon, 16 Nov 2020 at 19:28, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > >
> > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > >
> > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > >
> > > > Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as
> > > > general indicator that operation was triggered by the debugger.
> > > >
> > > > A subsequent patch will set the debug=1 when issuing a memory access
> > > > from the gdbstub or HMP commands. This is a prerequisite to support
> > > > debugging an encrypted guest. When a request with debug=1 is seen, the
> > > > encryption APIs will be used to access the guest memory.
> > >
> > > So, what counts as "debug" here, and why are debug requests
> > > special? If "debug=1" means "can actually get at the guest memory",
> > > why wouldn't every device model want to use it?
> >
> > SEV has a flag that the guest-owner can set on a VM to enable debug;
> > it's rare for it to be enabled; so it's not suitable for use by normal
> > devices.  It's only there for debug if the guest owner allows you to.
> 
> So if I do a memory transaction with debug=1 then I should expect
> that it might come back with a failure status (meaning "this VM
> doesn't permit debug") and I should handle that error ?

I think that's probably true.

Dave

> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


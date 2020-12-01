Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8473D2CA1CC
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgLALw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:52:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728320AbgLALw0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 06:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606823460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ay9ItD6Kzh25y4pze0iPQOTVfknUuyVxyktssHh8Ios=;
        b=JeejJbXb62xBuMU5CZWX8XSvneKmwqtd01F4AIrNvQTxmbbfGzxarlDEtYa3mcgpuKj2Zh
        7tEvMXMknSTbTZWfAykdMQKllYTBNfDcrAvBCzkZ4sxv6Lkpub2srv8RWCNgWoyBKOcfRY
        YH4xurvIf9tRT+I/cRov6B8XZV3IYXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-CgMN2nTtMV2UUlP0nhldsA-1; Tue, 01 Dec 2020 06:50:57 -0500
X-MC-Unique: CgMN2nTtMV2UUlP0nhldsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 905BF817B91;
        Tue,  1 Dec 2020 11:50:55 +0000 (UTC)
Received: from work-vm (ovpn-115-1.ams2.redhat.com [10.36.115.1])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FB4F6086F;
        Tue,  1 Dec 2020 11:50:49 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:50:47 +0000
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
Message-ID: <20201201115047.GA15055@work-vm>
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
 <CAFEAcA8eiyzUbHXQip1sT_TrT+Mfv-WG8cSMmM-w_eOFShAMzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA8eiyzUbHXQip1sT_TrT+Mfv-WG8cSMmM-w_eOFShAMzQ@mail.gmail.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Mon, 16 Nov 2020 at 19:28, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as
> > general indicator that operation was triggered by the debugger.
> >
> > A subsequent patch will set the debug=1 when issuing a memory access
> > from the gdbstub or HMP commands. This is a prerequisite to support
> > debugging an encrypted guest. When a request with debug=1 is seen, the
> > encryption APIs will be used to access the guest memory.
> 
> So, what counts as "debug" here, and why are debug requests
> special? If "debug=1" means "can actually get at the guest memory",
> why wouldn't every device model want to use it?

SEV has a flag that the guest-owner can set on a VM to enable debug;
it's rare for it to be enabled; so it's not suitable for use by normal
devices.  It's only there for debug if the guest owner allows you to.

Dave

> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


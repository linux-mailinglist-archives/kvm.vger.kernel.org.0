Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994292CD4FF
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgLCL6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:58:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgLCL6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606996636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvudTwkZlrk5cjZrGWhnLWxf/bDsuqFy86ZB03kMeqU=;
        b=V819oOn4ZoLAmE7VCfz0w+KTr+xnuMCFtgotHS/xFb0K0Bl0vVtd3dSwHmGC+MShSUgfj9
        mxdvfIkPCZ21S+vn6/b10xCXwutxtxFY88WRLjUb+LbmdMdwhNIkGKpyJUBLIiSaHbuceI
        Ry69ynf372L/zQn/lGkNCPDxGAURkf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-RZmLZlsOMP2e65EnnaD2SQ-1; Thu, 03 Dec 2020 06:57:14 -0500
X-MC-Unique: RZmLZlsOMP2e65EnnaD2SQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78517100A64D;
        Thu,  3 Dec 2020 11:57:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2BA25C1B4;
        Thu,  3 Dec 2020 11:57:06 +0000 (UTC)
Message-ID: <0d8c407cc81bedc9a344646978c857d26f2b5be8.camel@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu, 03 Dec 2020 13:57:04 +0200
In-Reply-To: <FB43C4E2-D7C4-430B-9D6B-15FA59BB5286@amacapital.net>
References: <874kl5hbgp.fsf@nanos.tec.linutronix.de>
         <FB43C4E2-D7C4-430B-9D6B-15FA59BB5286@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-01 at 08:19 -0800, Andy Lutomirski wrote:
> > On Dec 1, 2020, at 6:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > ﻿On Mon, Nov 30 2020 at 16:16, Marcelo Tosatti wrote:
> > > Not really. The synchronization logic tries to sync TSCs during
> > > BIOS boot (and CPU hotplug), because the TSC values are loaded
> > > sequentially, say:
> > > 
> > > CPU        realtime    TSC val
> > > vcpu0        0 usec        0
> > > vcpu1        100 usec    0
> > > vcpu2        200 usec    0
> > 
> > That's nonsense, really.
> > 
> > > And we'd like to see all vcpus to read the same value at all times.
> > 
> > Providing guests with a synchronized and stable TSC on a host with a
> > synchronized and stable TSC is trivial.
> > 
> > Write the _same_ TSC offset to _all_ vcpu control structs and be done
> > with it. It's not rocket science.
> > 
> > The guest TSC read is:
> > 
> >    hostTSC + vcpu_offset
> > 
> > So if the host TSC is synchronized then the guest TSCs are synchronized
> > as well.
> > 
> > If the host TSC is not synchronized, then don't even try.
> 
> This reminds me: if you’re adding a new kvm feature that tells the guest that the TSC works well, could you perhaps only have one structure for all vCPUs in the same guest?

I won't mind doing this, but this might be too much work for
too little gain.

IMHO, modern hosts don't need the kvmclock in the first place,
and should just expose the TSC to the guest 
together with the invtsc bit.

Best regards,
	Maxim Levitsky

> 
> > Thanks,
> > 
> >        tglx



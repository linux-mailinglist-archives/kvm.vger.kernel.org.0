Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0BD153643
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgBERWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:22:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726534AbgBERWY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 12:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580923343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qci0qV8XotWeHY82iVD/LzwEvOcK0TuHj9xzIsdib7Q=;
        b=FDFVfwJvOLXI+rRdGqpaThB9NGsCFoQaMyCjn8AVCl2ie/6V9e+tyLz/CCzHdYNVRFwpC4
        9SDumoCbhQMokA9UiihvgRTFibYD+cau6LpWZuLbSLKmOdGWjl+6nLJ9TWByaccK1dzhgx
        JtjBRUBXnZtuzCATZ5JFLKywFcfbJwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-MvGxd1-EO-O9jL9y9rzzAg-1; Wed, 05 Feb 2020 12:22:10 -0500
X-MC-Unique: MvGxd1-EO-O9jL9y9rzzAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB80E1007270;
        Wed,  5 Feb 2020 17:22:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0CC81213;
        Wed,  5 Feb 2020 17:22:07 +0000 (UTC)
Date:   Wed, 5 Feb 2020 18:22:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH kvm-unit-tests] x86: provide enabled and disabled
 variation of the PCID test
Message-ID: <20200205172205.rcmbddvouynatcq4@kamzik.brq.redhat.com>
References: <1580916580-4098-1-git-send-email-pbonzini@redhat.com>
 <20200205154904.GF4877@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205154904.GF4877@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 07:49:04AM -0800, Sean Christopherson wrote:
> On Wed, Feb 05, 2020 at 04:29:40PM +0100, Paolo Bonzini wrote:
> > The PCID test checks for exceptions when PCID=0 or INVPCID=0 in
> > CPUID.  Cover that by adding a separate testcase with different
> > CPUID.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  x86/unittests.cfg | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index aae1523..f2401eb 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -228,7 +228,12 @@ extra_params = --append "10000000 `date +%s`"
> >  
> >  [pcid]
> >  file = pcid.flat
> > -extra_params = -cpu qemu64,+pcid
> > +extra_params = -cpu qemu64,+pcid,+invpcid
> > +arch = x86_64
> > +
> > +[pcid-disabled]
> > +file = pcid.flat
> > +extra_params = -cpu qemu64,-pcid,-invpcid
> >  arch = x86_64
> 
> Hrm, but "-cpu qemu64,-pcid,+invpcid" is arguably the more interesting test
> from a KVM perspective because of the logic in KVM to hide invpcid if pcid
> isn't supported.
> 
> And +pcid,-invpcid is also interesting.
> 
> Is there an easy-ish change that can be made to allow iterating over
> multiple CPU configurations for single test case?
>

Just a small change to Paolo's patch

[pcid]
file = pcid.flat
extra_params = -cpu qemu64,+pcid,+invpcid
arch = x86_64
group = pcid

[pcid-disabled]
file = pcid.flat
extra_params = -cpu qemu64,-pcid,-invpcid
arch = x86_64
group = pcid

[pcid-more-interesting]
file = pcid.flat
extra_params = -cpu qemu64,-pcid,+invpcid
arch = x86_64
group = pcid

Then run the group with ./run_tests.sh -g pcid

Thanks,
drew


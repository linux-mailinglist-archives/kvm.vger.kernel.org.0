Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB233197E
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHVo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229978AbhCHVoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615239863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TJsn949M8n9WGSdMpDiEtGlLtK0SvJQUpKO/vJJsrkM=;
        b=DMFxgFskSijqlPKvzzptEk7euOb1ArSYBno02VEnKpHtAwh4Rjm/QboO0LGzjnUbXd26GS
        Ib65kFB9GOawYv7B9jJEpjwSE+Co2vlq3eoyw8+Q5m/hsGAcrzM7wHwGJA6kEBfwLCJnSL
        YJu5PQZ9y4eQVRch4bd9bFw7zBpgmEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-yi7wvKP0OJ6TuQuCr0Z2KA-1; Mon, 08 Mar 2021 16:44:20 -0500
X-MC-Unique: yi7wvKP0OJ6TuQuCr0Z2KA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA6201085932;
        Mon,  8 Mar 2021 21:44:17 +0000 (UTC)
Received: from starship (unknown [10.35.206.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D7505C27C;
        Mon,  8 Mar 2021 21:44:15 +0000 (UTC)
Message-ID: <25a4d6e1f267e70aa94876e261634165a1422ed6.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Connect 'npt' module param to KVM's internal
 'npt_enabled'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Mar 2021 23:44:14 +0200
In-Reply-To: <YEZceKJLrFwt93AA@google.com>
References: <20210305021637.3768573-1-seanjc@google.com>
         <106d2e650647408a901dfbec53f1b89cc36b2906.camel@redhat.com>
         <YEZceKJLrFwt93AA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-08 at 09:18 -0800, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Maxim Levitsky wrote:
> > On Thu, 2021-03-04 at 18:16 -0800, Sean Christopherson wrote:
> > > Directly connect the 'npt' param to the 'npt_enabled' variable so that
> > > runtime adjustments to npt_enabled are reflected in sysfs.  Move the
> > > !PAE restriction to a runtime check to ensure NPT is forced off if the
> > > host is using 2-level paging, and add a comment explicitly stating why
> > > NPT requires a 64-bit kernel or a kernel with PAE enabled.
> > 
> > Let me ask a small question for a personal itch.
> > 
> > Do you think it is feasable to allow the user to enable npt/ept per guest?
> > (the default should still of course come from npt module parameter)
> 
> Feasible, yes.  Worth the extra maintenance, probably not.  It's a niche use
> case, and only viable if you have a priori knowledge of the guest being run.
> I doubt there are more than a few people in the world that meet those criteria,
> and want to run multiple VMs, and also care deeply about the performance
> degregation of the other VMs.
I understand.
On one of weekends when I am bored I probably implement it anyway,
and post it upstream. I don't count on getting this merged.

It just that I often run VMs which I don't want to stop, and sometimes I want
to boot my retro VM which is finally working but I need for that
to reload KVM and disable NPT.

> 
> > This weekend I checked it a bit and I think that it shouldn't be hard
> > to do.
> > 
> > There are some old and broken OSes which can't work with npt=1
> > https://blog.stuffedcow.net/2015/08/win9x-tlb-invalidation-bug/
> > https://blog.stuffedcow.net/2015/08/pagewalk-coherence/
> > 
> > I won't be surprised if some other old OSes
> > are affected by this as well knowing from the above 
> > that on Intel the MMU speculates less and doesn't
> > break their assumptions up to today.
> > (This is tested to be true on my Kabylake laptop)
> 
> Heh, I would be quite surprised if Intel CPUs speculate less.  I wouldn't be
> surprised if the old Windows behavior got grandfathered into Intel CPUs because
> the buggy behavior worked on old CPUs and so must continue to work on new CPUs.

Yes, this sounds exactly what did happen. Besides we might not care but other
hypervisors are often sold as a means to run very old software, and that includes
very old operation systems. 
So Intel might have kept this working for that reason as well, 
while AMD didn't have time to care for an obvious OS bug which is 
even given as an example of what not to do in the manual.

> 
> > In addition to that, on semi-unrelated note,
> > our shadowing MMU also shows up the exact same issue since it
> > also caches translations in form of unsync MMU pages.
> > 
> > But I can (and did disable) this using a hack (see below)
> > and this finally made my win98 "hobby" guest actually work fine 
> > on AMD for me.
> > 
> > I am also thinking to make this "sync" mmu mode to be 
> > another module param (this can also be useful for debug,
> > see below)
> > What do you think?
> > 
> > On yet another semi-unrelated note,
> > A "sync" mmu mode affects another bug I am tracking,
> > but I don't yet understand why:
> > 
> > I found out that while windows 10 doesn't boot at all with 
> > disabled tdp on the host (npt/ept - I tested both) 
> >  the "sync" mmu mode does make it work.
> 
> Intel and AMD?  Or just AMD?  If both architectures fail, this definitely needs
> to be debugged and fixed.  Given the lack of bug reports, most KVM users
> obviously don't care about TDP=0, but any bug in the unsync code likely affects
> nested TDP as well, which far more people do care about.

Both Intel and AMD in exactly the same way. 
Win10 fails to boot always, with various blue screens or just
hangs. With 'sync' mmu hack it slow but boots always.

It even boots nested (very slow) with TDP disabled on host.
(with my fix for booting nested guests on AMD with TDP disabled on the host)

Note that otherwise this isn't related to nesting, I just boot a regular win10 guest.
I also see this happen with several different win10 VMs.


> 
> > I was also able to reproduce a crash on Linux 
> > (but only with nested migration loop)
> 
> With or without TDP enabled?
Without TDP enabled. I also was able to reproduce this on both Intel and AMD.

For this case as Linux does seem to boot, I did run my nested migration test,
and its is the nested guest that crashes, but also most likely not related to
nesting as no TDP was enabled on the host (L0)

With sync mmu I wasn't able to make anything crash (I think though that I 
tested this case only on AMD so far)

I also did *lot* of various hacks to mmu code.
(like to avoid any prefetching, sync everything on every cr0/cr3/cr4 write,
flush the real TLB on each guest entry, and stuff like that, and nothing seemes to help).


Best regards,
	Maxim Levitsky

> 



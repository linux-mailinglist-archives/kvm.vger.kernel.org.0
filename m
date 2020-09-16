Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303D026BF62
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIPIeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 04:34:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53587 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgIPIeD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 04:34:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600245241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DAGiU6tQPn7qIzmXwLxHU7yiPU3YBQ56AcEEwsHRgsA=;
        b=RsHvEIW70qwD/J2J9zGvn+vVIqu8bR7TNVXNaAYT9TGfgwhdJvKVMsoxkUWrYjwbAhF9qI
        ZdByYyo70q5ovLwT1SA1obrG8yIHsoflXoTtXXU7awlZ1CSk29VlqMh6ihGtOAy1kwCR9N
        anTqeXszvkrWMcyh+Hthp/yPtp3RwhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-4HDCgbP5Okm5jDY_6ZfxHg-1; Wed, 16 Sep 2020 04:33:58 -0400
X-MC-Unique: 4HDCgbP5Okm5jDY_6ZfxHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B00D1800D4A;
        Wed, 16 Sep 2020 08:33:56 +0000 (UTC)
Received: from work-vm (ovpn-114-237.ams2.redhat.com [10.36.114.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EF9B5DE86;
        Wed, 16 Sep 2020 08:33:53 +0000 (UTC)
Date:   Wed, 16 Sep 2020 09:33:51 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, Wei Huang <whuang2@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
Message-ID: <20200916083351.GA2833@work-vm>
References: <20200915154306.724953-1-vkuznets@redhat.com>
 <20200915165131.GC2922@work-vm>
 <20200916034905.GA508748@weilap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916034905.GA508748@weilap>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Wei Huang (wei.huang2@amd.com) wrote:
> On 09/15 05:51, Dr. David Alan Gilbert wrote:
> > * Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> > > With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
> 
> Could you elaborate on this limit? On Rome, I counted ~35 CPUID functions which
> include Fn0000_xxxx, Fn4000_xxxx and Fn8000_xxxx.

On my 7302P the output of:
    cpuid -1 -r | wc -l

is 61, there is one line of header in there.

However in a guest I see more; and I think that's because KVM  tends to
list the CPUID entries for a lot of disabled Intel features, even on
AMD, e.g. 0x11-0x1f which AMD doesn't have, are listed in a KVM guest.
Then you add the KVM CPUIDs at 4...0 and 4....1.

IMHO we should be filtering those out for at least two reasons:
  a) They're wrong
  b) We're probably not keeping the set of visible CPUID fields the same
    when we move between host kernels, and that can't be good for
migration.

Still, those are separate problems.

Dave

> > > KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
> > > from '40' in 2010. We can, of course, just bump it a little bit to fix
> > > the immediate issue but the report made me wonder why we need to pre-
> > > allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
> > > This RFC is intended to feed my curiosity.
> > > 
> > > Very mildly tested with selftests/kvm-unit-tests and nothing seems to
> > > break. I also don't have access to the system where the original issue
> > > was reported but chances we're fixing it are very good IMO as just the
> > > second patch alone was reported to be sufficient.
> > > 
> > > Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > 
> > Oh nice, I was just going to bump the magic number :-)
> > 
> > Anyway, this seems to work for me, so:
> > 
> > Tested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > 
> 
> I tested on two platforms and the patches worked fine. So no objection on the
> design.
> 
> Tested-by: Wei Huang <wei.huang2@amd.com>
> 
> > > Vitaly Kuznetsov (2):
> > >   KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
> > >   KVM: x86: bump KVM_MAX_CPUID_ENTRIES
> > > 
> > >  arch/x86/include/asm/kvm_host.h |  4 +--
> > >  arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
> > >  arch/x86/kvm/x86.c              |  1 +
> > >  3 files changed, 43 insertions(+), 17 deletions(-)
> > > 
> > > -- 
> > > 2.25.4
> > > 
> > -- 
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


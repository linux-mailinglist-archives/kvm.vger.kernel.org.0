Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2B2744AF
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIVOus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVOus (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dum7Y2sVYostqgHyuDYV4BcH6A2VsvfCX37jDJ02YsQ=;
        b=XAKN7XIsIwcqQY3+Ru2ZA1g/E4g2PqrqO4P+wzKtLf2EKC+nufOkKM+XQlTS7cHeLGzoec
        kINB67RLDYaCw5711idZYeFR/hno/89R8CO7ciHvaWgqPcIdemWXOTU33DIMv68TR5T/I0
        zTtaJZvkKRcJJxJ7d/p2pRYWN/veqg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-71DJAb7KOSul45HHYVye5w-1; Tue, 22 Sep 2020 10:50:45 -0400
X-MC-Unique: 71DJAb7KOSul45HHYVye5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEE06807341;
        Tue, 22 Sep 2020 14:50:42 +0000 (UTC)
Received: from starship (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7D4E78822;
        Tue, 22 Sep 2020 14:50:37 +0000 (UTC)
Message-ID: <7db1383cc9d40f76a02076c3b86cf832fd7463cc.camel@redhat.com>
Subject: Re: [PATCH v2 1/1] KVM: x86: fix MSR_IA32_TSC read for nested
 migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Tue, 22 Sep 2020 17:50:36 +0300
In-Reply-To: <de9411ce-aa83-77c8-b2ae-a3873250a0b1@redhat.com>
References: <20200921103805.9102-1-mlevitsk@redhat.com>
         <20200921103805.9102-2-mlevitsk@redhat.com>
         <20200921162326.GB23989@linux.intel.com>
         <de9411ce-aa83-77c8-b2ae-a3873250a0b1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-09-22 at 14:50 +0200, Paolo Bonzini wrote:
> On 21/09/20 18:23, Sean Christopherson wrote:
> > Avoid "should" in code comments and describe what the code is doing, not what
> > it should be doing.  The only exception for this is when the code has a known
> > flaw/gap, e.g. "KVM should do X, but because of Y, KVM actually does Z".
> > 
> > > +		 * return it's real L1 value so that its restore will be correct.
> > s/it's/its
> > 
> > Perhaps add "unconditionally" somewhere, since arch.tsc_offset can also contain
> > the L1 value.  E.g. 
> > 
> > 		 * Unconditionally return L1's TSC offset on userspace reads
> > 		 * so that userspace reads and writes always operate on L1's
> > 		 * offset, e.g. to ensure deterministic behavior for migration.
> > 		 */
> > 
> 
> Technically the host need not restore MSR_IA32_TSC at all.  This follows
> the idea of the discussion with Oliver Upton about transmitting the
> state of the kvmclock heuristics to userspace, which include a (TSC,
> CLOCK_MONOTONIC) pair to transmit the offset to the destination.  All
> that needs to be an L1 value is then the TSC value in that pair.
> 
> I'm a bit torn over this patch.  On one hand it's an easy solution, on
> the other hand it's... just wrong if KVM_GET_MSR is used for e.g.
> debugging the guest.

Could you explain why though? After my patch, the KVM_GET_MSR will consistently
read the L1 TSC, just like all other MSRs as I explained. I guess for debugging,
this should work?

The fact that TSC reads with the guest offset is a nice exception made for the guests,
that insist on reading this msr without inteception and not using rdtsc.

Best regards,
	Maxim Levitsky

> 
> I'll talk to Maxim and see if he can work on the kvmclock migration stuff.
> 
> Paolo
> 



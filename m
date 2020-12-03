Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE862CD45F
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgLCLN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387752AbgLCLN1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606993920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oj9Eb3KtE+2YyHKM1FeeyiYyawdfTwBxc5qATzsgyHM=;
        b=Mp+26P8jymnLkxpyWSClj4JTaceqhh+stXq+ip/bIwVCe9AOcL1vPHk9iSpjJFXSaQ1EEQ
        vapBReA8KMU9H8F9QACytSZy240kUUeGllRSXzSXJCZwcZoE5VAXSM3pltgcvQAlbWZz+F
        pGMyZnaCcWY9o8vfqe6vSnNVV/WDqM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-0Ehb4NofNIuuNpcntl7fgQ-1; Thu, 03 Dec 2020 06:11:59 -0500
X-MC-Unique: 0Ehb4NofNIuuNpcntl7fgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 802F780732C;
        Thu,  3 Dec 2020 11:11:56 +0000 (UTC)
Received: from starship (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6787A1A8A0;
        Thu,  3 Dec 2020 11:11:49 +0000 (UTC)
Message-ID: <cd1c80e6ed7367f8736a965c4100c333b79bbdcc.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: implement
 KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu, 03 Dec 2020 13:11:47 +0200
In-Reply-To: <87h7p5fh1m.fsf@nanos.tec.linutronix.de>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <20201130133559.233242-2-mlevitsk@redhat.com>
         <87h7p5fh1m.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-01 at 20:43 +0100, Thomas Gleixner wrote:
> On Mon, Nov 30 2020 at 15:35, Maxim Levitsky wrote:
> > +  struct kvm_tsc_info {
> > +	__u32 flags;
> > +	__u64 nsec;
> > +	__u64 tsc;
> > +	__u64 tsc_adjust;
> > +  };
> > +
> > +flags values for ``struct kvm_tsc_info``:
> > +
> > +``KVM_TSC_INFO_TSC_ADJUST_VALID``
> > +
> > +  ``tsc_adjust`` contains valid IA32_TSC_ADJUST value
> 
> Why exposing TSC_ADJUST at all? Just because?

It's because we want to reduce the number of cases where
KVM's msr/read write behavior differs between guest and host 
(e.g qemu) writes.
 
TSC and TSC_ADJUST are tied on architectural level, such as
chang
ing one, changes the other.
 
However for the migration to work we must be able 
to set each one separately.

Currently, KVM does this by turning the host write to 
TSC_ADJUST into a special case that bypasses
the actual TSC adjustment, and just sets this MSR.
 
The next patch in this series, will allow to disable
this special behavior, making host TSC_ADJUST write
work the same way as in guest.

Therefore to still allow to set TSC_ADJUST and TSC independently
after migration this ioctl will be used instead.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
>         tglx
> 



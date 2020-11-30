Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0782C88D8
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 17:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgK3QAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 11:00:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgK3QAb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 11:00:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606751945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYyaNMWXIzphPUXACrUhTp271jhjXQRzrhohRKC0mcw=;
        b=bU8xw2Y76mpMymDp4KDq1IzBooZhUUSqYav9GzBzPlBwwGVxMTWRp3K2cnE83ZU19bT39X
        5KhzlOkgb8nUSjx5fV3T6P4RkhLJZwcPeka0cNbgx7JARjn+BTOtZ1S2TYIx2QOdLr93OP
        jVv0+gAaekYWnya3cZkggsXy9N9aELI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-PEEJD8uZNkCkGJpbLxvTaw-1; Mon, 30 Nov 2020 10:59:03 -0500
X-MC-Unique: PEEJD8uZNkCkGJpbLxvTaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B30025708B;
        Mon, 30 Nov 2020 15:59:01 +0000 (UTC)
Received: from starship (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F15B05D9C0;
        Mon, 30 Nov 2020 15:58:55 +0000 (UTC)
Message-ID: <ee06976738dff35e387077ba73e6ab375963abbf.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: implement
 KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Date:   Mon, 30 Nov 2020 17:58:54 +0200
In-Reply-To: <38602ef4-7ecf-a5fd-6db9-db86e8e974e4@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <20201130133559.233242-2-mlevitsk@redhat.com>
         <38602ef4-7ecf-a5fd-6db9-db86e8e974e4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-11-30 at 15:33 +0100, Paolo Bonzini wrote:
> On 30/11/20 14:35, Maxim Levitsky wrote:
> > +		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
> > +			tsc_state.tsc_adjust = vcpu->arch.ia32_tsc_adjust_msr;
> > +			tsc_state.flags |= KVM_TSC_STATE_TSC_ADJUST_VALID;
> > +		}
> 
> This is mostly useful for userspace that doesn't disable the quirk, right?

Isn't this the opposite? If I understand the original proposal correctly,
the reason that we include the TSC_ADJUST in the new ioctl, is that
we would like to disable the special kvm behavior (that is disable the quirk),
which would mean that tsc will jump on regular host initiated TSC_ADJUST write.

To avoid this, userspace would set TSC_ADJUST through this new interface.

Note that I haven't yet disabled the quirk in the patches I posted to the qemu,
because we need some infrastructure to manage which quirks we want to disable
in qemu
(That is, KVM_ENABLE_CAP is as I understand write only, so I can't just disable
KVM_X86_QUIRK_TSC_HOST_ACCESS, in the code that enables x-precise-tsc in qemu).

> 
> > +		kvm_get_walltime(&wall_nsec, &host_tsc);
> > +		diff = wall_nsec - tsc_state.nsec;
> > +
> > +		if (diff < 0 || tsc_state.nsec == 0)
> > +			diff = 0;
> > +
> 
> diff < 0 should be okay.  Also why the nsec==0 special case?  What about 
> using a flag instead?

In theory diff < 0 should indeed be okay (though this would mean that target,
has unsynchronized clock or time travel happened).

However for example nsec_to_cycles takes unsigned number, and then
pvclock_scale_delta also takes unsigned number, and so on,
so I was thinking why bother with this case.

There is still (mostly?) theoretical issue, if on some vcpus 'diff' is positive 
and on some is negative
(this can happen if the migration was really fast, and target has the clock
   A. that is only slightly ahead of the source).
Do you think that this is an issue? If so I can make the code work with
signed numbers.

About nsec == 0, this is to allow to use this API for VM initialization.
(That is to call KVM_SET_TSC_PRECISE prior to doing KVM_GET_TSC_PRECISE)

This simplifies qemu code, and I don't think 
that this makes the API much worse.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 



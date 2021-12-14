Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047A9474A5A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhLNSEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 13:04:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43266 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbhLNSEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 13:04:52 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639505091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mr4L/VgYICxxzlwNt3+eGl5F3lIZOANlf30RgEVCqXI=;
        b=B/H4e8O1QMVsEYGo20SJFsTlvuHpkfVFx+nREjxCIFqYx9Cr1tHCUz5dnQjxJW1B0eZAUg
        WZtJzGonHGgzle/rMf+Nf6djyIA70I1FSxN+S6uwooa3og39/Sjen89p5mhXZXu67Bv+wf
        68lqT4XIJUQaAg6Vkm0T7R+L5dTRk2tAFHdQPLD3Ssfrpu71W9qQ3ldeQI4AUmDJcrH5Zk
        Tb/4cFfWDuiXEhjZ849la25YPzcGo0K5FvSOy0DvMQCPeO3Cl7wCe/lS586unbNFVtabmo
        WcvJxxnVBkfVaDpPCvpkWiySvkl2AngcxfScTGeWPWZP9NwYq3wkI66YXkpkXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639505091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mr4L/VgYICxxzlwNt3+eGl5F3lIZOANlf30RgEVCqXI=;
        b=JnhN6AN2ym4HgrrSIImSsJ3Fh4A9cBsxGITvSWeip/HV+imjPJfZ9sBO4xSgzxytrCpB/f
        C35558vgrMtWaADg==
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <b3ac7ba45c984cf39783e33e0c25274d@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com>
Date:   Tue, 14 Dec 2021 19:04:50 +0100
Message-ID: <87r1afrrjx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei,

On Tue, Dec 14 2021 at 16:11, Wei W. Wang wrote:
> On Tuesday, December 14, 2021 11:40 PM, Thomas Gleixner wrote:
>> On Tue, Dec 14 2021 at 15:09, Wei W. Wang wrote:
>> > On Tuesday, December 14, 2021 10:50 AM, Thomas Gleixner wrote:
>> >> + * Return: 0 on success, error code otherwise  */ int
>> >> +__fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0,
>> >> +u64
>> >> +xfd) {
>> >
>> > I think there would be one issue for the "host write on restore" case.
>> > The current QEMU based host restore uses the following sequence:
>> > 1) restore xsave
>> > 2) restore xcr0
>> > 3) restore XFD MSR
>> 
>> This needs to be fixed. Ordering clearly needs to be:
>> 
>>   XFD, XCR0, XSTATE
>
> Sorry, just to clarify that the ordering in QEMU isn't made by us for this specific XFD enabling.
> It has been there for long time for the general restoring of all the XCRs and MSRs.
> (if you are interested..FYI: https://github.com/qemu/qemu/blob/master/target/i386/kvm/kvm.c#L4168).
> - kvm_put_xsave()
> - kvm_put_xcrs()
> - kvm_put_msrs()
>
> We need to check with the QEMU migration maintainer (Dave and Juan CC-ed)
> if changing that ordering would be OK.
> (In general, I think there are no hard rules documented for this ordering)

There haven't been ordering requirements so far, but with dynamic
feature enablement there are.

I really want to avoid going to the point to deduce it from the
xstate:xfeatures bitmap, which is just backwards and Qemu has all the
required information already.

Thanks,

        tglx





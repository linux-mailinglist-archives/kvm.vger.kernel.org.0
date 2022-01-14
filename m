Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D448EDAF
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243139AbiANQJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243113AbiANQI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:08:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7DEC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:08:57 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso22378191pjm.4
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ahkubcrgcnWjiRruY+cbCIcOcMw/nGOD40THRvByTZ4=;
        b=rtZ+WdwbQ/+MOMGU2toCDBOaxzzP5jVuX9NI+4NetFHGHeM2k4yYW94cFWQFAZim+d
         kImeCZNMQplwGO/A2Ce1YeDiqkteZQ6rqEYq68Fcc4IdoE+HcWQWXqj3zn5OPlr/OquN
         1JcgOySDNy5lGKONy5k/023Xq8/YjwqdMch/Lwx+uHmldJqaNIBh8UbWEeZSKI5yE2Pq
         FhDfiRqxvJn18Xt2VWC32tbRW8ff+mS49slbdlSpqs4PsmpgYlR6vln2vuNQPU0i6sfc
         VjzZxQnUxS9XmuIASvm60rs6+lYQ/LtPPDBBCIKU+sMkjmRCFabLyxXwCkabZ+MO0XTu
         Ho4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ahkubcrgcnWjiRruY+cbCIcOcMw/nGOD40THRvByTZ4=;
        b=12M3CxTPeYnSDufRRmGWd0kSEBSDqqZqPKbeVCmTJAvJCmj7Xg3nKUC1KoNcCEy0dR
         +cC3vlXw/TneGzSeUxOyRDBCsYQrxCe7OHsU98HHH3oTR9PMe8QzKKzazVDwhorHjB3m
         zjZuWVQ16jV4zKRs1kBpYi6xUtD0NPUDZjv46u2C8lxTSnXto+UfiAzIk3o6m+GzFQwM
         RGpQSKsI3Wa+QFRl12cWcDvtKArLzRegfFFzlHqeytliVdFYmVOJAkvgoXp5+pyiBEjo
         iNe/ahyumIuMUY/G8H9H8KV+/eSy1Fi+LCxmJh00KS+1fYc8wX6KdAhX5nbprgcz5dBf
         tihA==
X-Gm-Message-State: AOAM533iOUudeplbVENhxxrlY39DNfrI3r66h6j8hUB562s37r4d4hTI
        UwyPwyPH7QRqYLDizywV5ZRZPA==
X-Google-Smtp-Source: ABdhPJwOfS8tgYcL4QiB8ma4W1mxpMQOR/ylxwTDksnDxhP/Q3iW6PW0pHD0A6A1ielZnQucLXadBA==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr8150705pjb.65.1642176536637;
        Fri, 14 Jan 2022 08:08:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 13sm6485615pfm.161.2022.01.14.08.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:08:56 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:08:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <YeGgFP3VmMldszgh@google.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com>
 <5b516b51f81874fe7cafe8ce6846bc9936d83cc7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b516b51f81874fe7cafe8ce6846bc9936d83cc7.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Maxim Levitsky wrote:
> On Thu, 2022-01-13 at 22:33 +0000, Sean Christopherson wrote:
> > On Mon, Jan 03, 2022, Igor Mammedov wrote:
> > > On Mon, 03 Jan 2022 09:04:29 +0100
> > > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > 
> > > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > > 
> > > > > On 12/27/21 18:32, Igor Mammedov wrote:  
> > > > > > > Tweaked and queued nevertheless, thanks.  
> > > > > > it seems this patch breaks VCPU hotplug, in scenario:
> > > > > > 
> > > > > >    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> > > > > >    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> > > > > > 
> > > > > > RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> > > > > >   
> > > > > 
> > > > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> > > > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> > > > > the data passed to the ioctl is the same that was set before.  
> > > > 
> > > > Are we sure the data is going to be *exactly* the same? In particular,
> > > > when using vCPU fds from the parked list, do we keep the same
> > > > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> > > > different id?
> > > 
> > > If I recall it right, it can be a different ID easily.
> > 
> > No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
> > a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
> > and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
> > is not reachable from userspace.
> 
> So after all, it is true that vcpu_id == initial APIC_ID,
> and if we don't let guest change it, it will be always like that?

Except for kvm_apic_set_state(), which I forgot existed, yes.

> You said that its not true in the other mail in the thread. 

I was wrong, I was thinking that userspace could reach kvm_lapic_reg_write(), but
I forgot that there would be no connection without x2apic.  But I forgot about
kvm_apic_set_state()...

> I haven't checked it in the code yet, as I never was much worried about
> userspace changing, but I will check it soon.
> 
> I did a quick look and I see that at least the userspace can call
> 'kvm_apic_set_state' and it contains snapshot of all apic registers,
> including apic id.  However it would be very easy to add a check there and
> fail if userspace attempts to set APIC_ID != vcpu_id.

Yeah, hopefully that doesn't break any userspace.  I can't imagine it would,
because if the guest disabled and re-enabled the APIC, kvm_lapic_set_base() would
restore the APIC ID to vcpu_id.

With luck, that's the last hole we need to close...

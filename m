Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1972746A2B0
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbhLFR0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbhLFR0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:26:19 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B59C0613F8
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 09:22:50 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id u80so10781900pfc.9
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 09:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e4v6IKiW/2WlbASsvrvF2UTULHy1m6fHcEIgOmsmgnI=;
        b=NgWpG1PfIksDugSwjn0vSFOwpf7eoIHnHW1dTEJlxDOr14pHVHjuU3ZWJYo8nhSREw
         wORI/+Jr6dN58hMsmwYXSwCT+fVa2fb4EbGQBOx6nexwBFGboAhvZOXjOIMrUWIp+NsF
         1kzczu/D31wau2OYK0MQwWwKJ7f+2YdCTz0blWWLLLQeCtIzYS5rAlYyE6UhlABTVNnV
         RF+aOThFdVI3o+blg8LW6IBCb0XJvcpVvipZqW9rD6zu0ODObFjm2aylUKCvkXTgq/n5
         EsKSJeImQWl2Mox7vHpVbDfl3rPTcZW4p6V7TpublXSaaiG0RP8XrANvLZlGKVLL/Qpn
         DVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e4v6IKiW/2WlbASsvrvF2UTULHy1m6fHcEIgOmsmgnI=;
        b=qZKjO03H/dDQr4PpGJyA7dWHarItGmBsStFukc8sjflrcpxFDH+CxlCrx2JuEOIfg8
         PiENE5aS8zxUrL/LomkzHtw8yZN+dnS0+ft+oz+DBTdk/SApOUfR8OeyHcudiC+vP/Im
         j921zqxWPYkIpSNVRFKetlBY44irC7323sshT7EcPllTZ7mdLP2GZi8B+tJkNnHGyFAJ
         Or3z/SEdOb0xWwm2gSDtv4dDJWwxBmYSAkcSHT3drBVJ68N4xIcuxGPIz698Y+kbFOqu
         +iBM6sck3rJk28c6y7eKMFp4wMh9oz1jQJjBqk23IoKr8DUmLcvKLjwazc/LsUzbQW16
         E1Qw==
X-Gm-Message-State: AOAM5335ZRZOSjM7EFp7HyB+1fZnZVlItZBdT8DHUwb+4DakGXOtVZmn
        dfeLOhRpJZ/dlHw57OZeOuQGUEYOIkDz0g==
X-Google-Smtp-Source: ABdhPJy9GZqYqYpevufXjYQIZ/YpPacZwnffWH1X44rpkphLcq/o2EAlO3xFyWmJ//FGEG/zaZVs5w==
X-Received: by 2002:a63:1b1c:: with SMTP id b28mr19749416pgb.288.1638811369405;
        Mon, 06 Dec 2021 09:22:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm12586661pfu.205.2021.12.06.09.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:22:48 -0800 (PST)
Date:   Mon, 6 Dec 2021 17:22:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com,
        syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
Message-ID: <Ya5G5eQrGNRIwbcm@google.com>
References: <00000000000051f90e05d2664f1d@google.com>
 <87bl1u6qku.fsf@redhat.com>
 <Ya40sXNcLzBUlpdW@google.com>
 <87k0gh675j.fsf@redhat.com>
 <Ya5GrdTICjW6Csvr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ya5GrdTICjW6Csvr@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021, Sean Christopherson wrote:
> On Mon, Dec 06, 2021, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > > I objected to the patch[*], but looking back at the dates, it appears that I did
> > > so after the patch was queued and my comments were never addressed.  
> > > I'll see if I can reproduce this with a selftest.  The fix is likely just:
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index dc4909b67c5c..927a7c43b73b 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6665,10 +6665,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >          * consistency check VM-Exit due to invalid guest state and bail.
> > >          */
> > >         if (unlikely(vmx->emulation_required)) {
> > > -
> > > -               /* We don't emulate invalid state of a nested guest */
> > > -               vmx->fail = is_guest_mode(vcpu);
> > > -
> > >                 vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> > >                 vmx->exit_reason.failed_vmentry = 1;
> > >                 kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> > >
> > > [*] https://lore.kernel.org/all/YWDWPbgJik5spT1D@google.com/
> > 
> > Let's also summon Max to the discussion to get his thoughts.
> 
> Thinking more on this, we should do three things:

Doh, hit send too soon.  s/three/five, I'm not _that_ bad at math...

>   1. Revert this part back to "vmx->fail = 0".
> 
>   2. Override SS.RPL and CS.RPL on RSM for VMX.  Not sure this is strictly
>      necessary, I'm struggling to remember how SS.RPL and SS.DPL can get out of
>      sync.
> 
>        IF RFLAGS.VM = 0 AND (in VMX root operation OR the “unrestricted guest”
>        VM-execution control is 0)
>        THEN
>          CS.RPL := SS.DPL;
>          SS.RPL := SS.DPL;
>        FI;
> 
>   3. Modify RSM to go into TRIPLE_FAULT if vmx->emulation_required is true after
>      loading state for RSM.  On AMD, whose SMRAM KVM emulates, all segment state
>      is read-only, i.e. if it's modified to be invalid then KVM essentially do
>      whatever it wants.
> 
>   4. Reject KVM_RUN if is_guest_mode() and vmx->emulation_required are true.  By
>      handling the RSM case explicitly, this means userspace has attempted to run
>      L2 with garbage, which KVM most definitely doesn't want to support.
> 
>   5. Add KVM_BUG_ON(is_guest_mode(vcpu), ...) in the emulation_required path in
>      vmx_vcpu_run(), as reaching that point means KVM botched VM-Enter, RSM or
>      the #4 above.

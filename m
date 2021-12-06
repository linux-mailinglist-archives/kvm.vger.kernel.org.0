Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314E846A2A7
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhLFRZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbhLFRZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:25:23 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1F3C0613F8
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 09:21:54 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q16so11104382pgq.10
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 09:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zHMj/3qBUCC3+8//0waM7H9mXBNiTb8p3Q6GTlN1BIQ=;
        b=V89zMk9PSRF+6ij1Owd6/Wj/UvX1SzoChLPDcmQBHphtROUwfVaDe7S1YWFnQE2Plk
         Ei8bDn09+35LHdzX4DbfSInT9RDQAMUUWokyhdyjn/IH2FHJ25qwudNUPq5mGKIda/Tc
         fED6Sgp9Ndl7kX/D9YnkKHiSsp3On90gMTw0SIJhxqyHrNm9Rszak9vyaiPnSB+tmD2K
         fl1Z+FJyz+cx5+IXvtTGPFf4Lfa39WiKlYx7xZrhzHtI783+eyVMyvHfHvGtJ4ltLIK5
         3m0k/FZzpmSL4O6xGToB12SKS0VRRSuxBqV0LkMLUfLeTiSAhS+nNou4FhsKy3Ur2iOx
         cuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zHMj/3qBUCC3+8//0waM7H9mXBNiTb8p3Q6GTlN1BIQ=;
        b=mxGp2O3V/W6JaxeCBGZwwQOaVWYjUmTDy/5lxA0ybst/i5/rWMjcj70Ro0qaeA1/4H
         eVuF50cD7fq8tqccO0o7/pEqx8RuuNgpx3r3b5RH1wP2wmoaId1uimJwvvzaTeKconSx
         lytRBBm+jS1jjg7/bouab+tOmJA2yeVtUu0aY5DO7aKdFegT6ALaC+2RtB+mAiqiThHk
         xuHMzxCIOrcbZUL/U6JAfloUaOqWqbMs8oRRNmOqR6hBz3w1bRzP+VVygv9MNp7bElm7
         EnmYp3rZzZNXj0Ws5jOVwwgAKcnye9KAB3FdH+wpvCEJFbVmyHjrxy21s5R6DqSU8gSc
         yLeA==
X-Gm-Message-State: AOAM530a4pbhIA+BKOxQeWPX1Ci7vKdKea3AX5BXjsiC//6LX5RlWJhM
        fwpBwMfUS1lqIRjgYDFDQ/vo0g==
X-Google-Smtp-Source: ABdhPJwh85ZC9FOQGDlaNcHaXtupLcTY72D6mwObQ4WRn2rkhSYYxj9lRDQ8qyH2uMV3mFpDVI2iGA==
X-Received: by 2002:a63:d245:: with SMTP id t5mr19286123pgi.483.1638811314127;
        Mon, 06 Dec 2021 09:21:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 13sm12636549pfp.216.2021.12.06.09.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:21:53 -0800 (PST)
Date:   Mon, 6 Dec 2021 17:21:49 +0000
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
Message-ID: <Ya5GrdTICjW6Csvr@google.com>
References: <00000000000051f90e05d2664f1d@google.com>
 <87bl1u6qku.fsf@redhat.com>
 <Ya40sXNcLzBUlpdW@google.com>
 <87k0gh675j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0gh675j.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > I objected to the patch[*], but looking back at the dates, it appears that I did
> > so after the patch was queued and my comments were never addressed.  
> > I'll see if I can reproduce this with a selftest.  The fix is likely just:
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index dc4909b67c5c..927a7c43b73b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6665,10 +6665,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >          * consistency check VM-Exit due to invalid guest state and bail.
> >          */
> >         if (unlikely(vmx->emulation_required)) {
> > -
> > -               /* We don't emulate invalid state of a nested guest */
> > -               vmx->fail = is_guest_mode(vcpu);
> > -
> >                 vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> >                 vmx->exit_reason.failed_vmentry = 1;
> >                 kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> >
> > [*] https://lore.kernel.org/all/YWDWPbgJik5spT1D@google.com/
> 
> Let's also summon Max to the discussion to get his thoughts.

Thinking more on this, we should do three things:

  1. Revert this part back to "vmx->fail = 0".

  2. Override SS.RPL and CS.RPL on RSM for VMX.  Not sure this is strictly
     necessary, I'm struggling to remember how SS.RPL and SS.DPL can get out of
     sync.

       IF RFLAGS.VM = 0 AND (in VMX root operation OR the “unrestricted guest”
       VM-execution control is 0)
       THEN
         CS.RPL := SS.DPL;
         SS.RPL := SS.DPL;
       FI;

  3. Modify RSM to go into TRIPLE_FAULT if vmx->emulation_required is true after
     loading state for RSM.  On AMD, whose SMRAM KVM emulates, all segment state
     is read-only, i.e. if it's modified to be invalid then KVM essentially do
     whatever it wants.

  4. Reject KVM_RUN if is_guest_mode() and vmx->emulation_required are true.  By
     handling the RSM case explicitly, this means userspace has attempted to run
     L2 with garbage, which KVM most definitely doesn't want to support.

  5. Add KVM_BUG_ON(is_guest_mode(vcpu), ...) in the emulation_required path in
     vmx_vcpu_run(), as reaching that point means KVM botched VM-Enter, RSM or
     the #4 above.

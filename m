Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813AB46F2E9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243240AbhLISZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbhLISZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:25:58 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCA0C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:22:24 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s137so5790132pgs.5
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QXsXBVsCEAsPdVp73Q8QYplpMzVSNmLHtx7jAzyZz/g=;
        b=A9ab+4IB3zWhHgErBY9YpCwtN/ofuIZs5LmpOdFt5qyytxlMoMr6/sd4LNzZCFjM0Y
         dxH4aye7kR9YKOWzDySf2JvPZ/V8qp8btTOj4i4NkfQwBZNG17ft41iEy3b7dTCvOerd
         pPudCZpbmu56qmdKVzTnXWWqgN/K1AgPykNVCZ9s31uoYDn8leD/bmNXryOde4aXs8W1
         aW/w/+1oBIcRXg0yAR+Nf3KStER6D3JC/T6zFK4isRkExuvH9sOgLPGtw0a+193O5dIU
         YbXlTnleAGzqhsE0V+vywup0d8L5SxUS41UcViG42k6mSxsbLIj5CO5tir3aonjHvC7i
         SMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QXsXBVsCEAsPdVp73Q8QYplpMzVSNmLHtx7jAzyZz/g=;
        b=RvtA9im2SRfE4rgTftKboNfdaMLde4+dwIjdl1aNF7S9aH2BrUh4glgxEpx87iMSsz
         cUwAVAeFYwjZuMvY7TP4JAZ5cQbuvJmOEGXBOm0UA0rQAxjLgP0yHBsf3t7itwr3xaxY
         DnQbX3KcqvpDd2dNxv3jT7LbXwocIGhsslKPxPzQqnc1XW6kHM3jMEEn24E4IsPr2N5e
         0DT0t6Jogo4dH73ePRAqL1/G4JrRz2iY/+W8TBeQHbnIvE251m42PR8aS6B7rxl0hOUX
         +HNIf6RrlKTST0PeAvnGaVYyeb68kB/s4JRDPKQc1c4+urF6qiBftpn2RKeAIWf+UCN4
         1RQg==
X-Gm-Message-State: AOAM530ehv7POx6oQ2cN7SYKOXDw9ZtDJF6BJweatD5nJfnQTwHON7UR
        ThqxY1hrG/NawCa7Rj3Uw18v+w==
X-Google-Smtp-Source: ABdhPJyMfXL61yxua1Ptnp5Q55WP8Tc9mU4Ab+Nc95i0m4mzML89fq0MFLSKI3all5FnKZWFOUKaPw==
X-Received: by 2002:a63:fc58:: with SMTP id r24mr27039346pgk.342.1639074143952;
        Thu, 09 Dec 2021 10:22:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w1sm405094pfg.11.2021.12.09.10.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:22:23 -0800 (PST)
Date:   Thu, 9 Dec 2021 18:22:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        thomas.lendacky@amd.com, mlevitsk@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
Message-ID: <YbJJXKFevTV/L3in@google.com>
References: <20211209155257.128747-1-marcorr@google.com>
 <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
 <CALMp9eThf3UtvoLFjajkrXtvOEWQvc8_=Xf6-m6fHXkOhET+GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eThf3UtvoLFjajkrXtvOEWQvc8_=Xf6-m6fHXkOhET+GA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Jim Mattson wrote:
> On Thu, Dec 9, 2021 at 9:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 12/9/21 16:52, Marc Orr wrote:
> > > The kvm_run struct's if_flag is a part of the userspace/kernel API. The
> > > SEV-ES patches failed to set this flag because it's no longer needed by
> > > QEMU (according to the comment in the source code). However, other
> > > hypervisors may make use of this flag. Therefore, set the flag for
> > > guests with encrypted registers (i.e., with guest_state_protected set).
> > >
> > > Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> > > Signed-off-by: Marc Orr<marcorr@google.com>
> >
> > Applied, though I wonder if it is really needed by those other VMMs
> > (which? gVisor is the only one that comes to mind that is interested in
> > userspace APIC).
> 
> Vanadium appears to have one use of it.
> 
> > It shouldn't be necessary for in-kernel APIC (where userspace can inject
> > interrupts at any time), and ready_for_interrupt_injection is superior
> > for userspace APIC.
> 
> LOL. Here's that one use...
> 
> if (vcpu_run_state_->request_interrupt_window &&
> vcpu_run_state_->ready_for_interrupt_injection &&
> vcpu_run_state_->if_flag) {
> ...
> }
> 
> So, maybe this is much ado about nothing?

I assume the issue is that SEV-ES always squishes if_flag, so that above statement
can never evaluate true.

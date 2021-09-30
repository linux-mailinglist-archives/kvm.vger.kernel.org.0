Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65941DFC3
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 19:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350180AbhI3RKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 13:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344773AbhI3RKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 13:10:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F1AC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:09:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23so4689891pji.0
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EKGhHlRmNBHgim3DLaH7xTsK+Y5v1XvB6gEB+uTNeB8=;
        b=Ynt0Fe92ATIga4frdOXMZjXNKXXZSaPeQQAjGzSzWV9Kpo9gc3Y6JCFCI+fYAGT+tr
         fVH9GP0DIonT6Ibd2dLJGEuGW3i9A6JcGOkfOusbI8k3Lm7zXKlh3OS1buWjntZrLfoj
         SmnU0Tq76FxLTTs5j+a5d7Ry+frmSQ1kImg15JQdqFDq/FEmSLARE3Xn5u6cB6fB/KIa
         xX4qRqrGWqjzHucKkTdtA9EpWBZ7C1QlHMwDtRUQ+U17MuM+nsSfsf8/QoAPfCrvqeuy
         QR3jMq7wsCUw5hzP2MKrA/cW6l5x6rgX4mzp2ct3nOs8WAHUWc97lTK22Pm+OqAFcSog
         UTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EKGhHlRmNBHgim3DLaH7xTsK+Y5v1XvB6gEB+uTNeB8=;
        b=FvD/WVpg/Xa2WBh41zCUqGwyvrirm3gexWy3TwWHsnUCAvnxJwCWHqihw3FbrLNMvj
         24e7U62yFbjbEiquP7swzKi1o9eUENmisYuDp/KI6aRBzGEZyCRPSxdW4MDE470dtE43
         FUgk/w7pW6LOf5wt8aOmo0TiCVk6dnf2fYX/zMHOfm+bOoCP4QneD8YsfXZW0u8ioeMt
         pLhzHplddT1Mew+9bWcEYathJeizXGvEiv78lSMyK6MUMZo7/CQLPW2Mk7IGIRG2r+7P
         jt8bsFyzvFNs6cfJyowNTzRZRAkpSSyF7YgFTZG9DYtnKqk4NzTF+YcPqxwHQN6/PWUj
         sZtg==
X-Gm-Message-State: AOAM53203OCAsGetns5/TXyxN6AREZZJELB+Ab7wB/HQH1NNV5WwXi/d
        N5+r4VsYYJ40NtBgfM7F+ZFAhQ==
X-Google-Smtp-Source: ABdhPJy9a/9KPfExzlaHiK/uSGhoB3fOWzfp7hJLJmdGT0YDd2SJ7vM/v/Qxj0xUnoUgKECV9LqvSQ==
X-Received: by 2002:a17:90a:11:: with SMTP id 17mr7624246pja.238.1633021751439;
        Thu, 30 Sep 2021 10:09:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k127sm3746313pfd.1.2021.09.30.10.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 10:09:10 -0700 (PDT)
Date:   Thu, 30 Sep 2021 17:09:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
Message-ID: <YVXvM2kw8PDou4qO@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rzetk0o.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 20:16:04 +0100, Oliver Upton <oupton@google.com> wrote:
> > @@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> >  			kvm_vcpu_sleep(vcpu);
> >  
> > +		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > +			kvm_vcpu_suspend(vcpu);
> > +

...

> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 275a27368a04..5e5ef9ff4fba 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
> >  	} else {
> >  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> >  		vcpu->stat.wfi_exit_stat++;
> > -		kvm_vcpu_block(vcpu);
> > -		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +		kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> >  	}
> >  
> >  	kvm_incr_pc(vcpu);
> 
> This is a change in behaviour. At the point where the blocking
> happens, PC will have already been incremented. I'd rather you don't
> do that. Instead, make the helper available and call into it directly,
> preserving the current semantics.

Is there architectural behavior that KVM can emulate?  E.g. if you were to probe a
physical CPU while it's waiting, would you observe the pre-WFI PC, or the post-WFI
PC?  Following arch behavior would be ideal because it eliminates subjectivity.
Regardless of the architectural behavior, changing KVM's behavior should be
done explicitly in a separate patch.

Irrespective of PC behavior, I would caution against using a request for handling
WFI.  Deferring the WFI opens up the possibility for all sorts of ordering
oddities, e.g. if KVM exits to userspace between here and check_vcpu_requests(),
then KVM can end up with a "spurious" pending KVM_REQ_SUSPEND if maniupaltes vCPU
state.  I highly doubt that userspace VMMs would actually do that, as it would
basically require a signal from userspace, but it's not impossible, and at the
very least the pending request is yet another thing to worry about in the future.

Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
doesn't enter rcuwait if power_off (or pause) was cleared after the request was
made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.

> It is also likely to clash with Sean's kvm_vcpu_block() rework, but we
> can work around that.

Ya.  Oliver, can you Cc me on future patches?  I'll try to keep my eyeballs on this
series.

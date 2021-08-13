Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7A3EBA2C
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhHMQgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbhHMQgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 12:36:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF1AC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:35:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso16740085pjy.5
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HP9HeO2dKDdIM1vYJ0w/zQNtFn885ttrO64ykJSZNtI=;
        b=fOwLFVASK5AGXkp2LCYCLBNFRPnddmbeH6u+YCEy0mzAFCy7tlsAu8ExIR6YxyQ8Sa
         BdjbW6XS+ZmUum8eerKCyZ6Yue1DtjDizYoAOMRnGZIN3TPwrQvGXVTamJRvIylTs+5g
         MNbJpN5G9S4Ukd/PpnkpYlATKDrH+oPZBPsPCvNgzarLkSc5beDLm3ibXWjkTkpnB2vE
         B6ev17fL3d7oArXRcWhBKuir35NHnbqCBQ6FpR4sQigN6cYJb1Yu58i7x7eCOBRB9oxw
         TchZvirslzMhJ0tKT7oboJJ68NhmYDoY94woD9voFQ41J37e45kiLLDGWDVm67rjbtQx
         yrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HP9HeO2dKDdIM1vYJ0w/zQNtFn885ttrO64ykJSZNtI=;
        b=imZe2nzRXk3MfHpcKaAO+I0RVmvAT7GavFF8wBWzjLs2RN522R449xA1EBeGNywUaU
         RPg3uGWgK6/sd1g/mhhJS+nMyV2hBTMiNf9ije1ggxxFScFGyw3b7wxs/VdrIGpe+PWG
         Ydl/XNuhm6O3mpFjAQNcleRTEmdqwQITPwR86Iy4lmHf83CVPXAj6DYqruo2LrOfVGi1
         SRqisvvfQMrbMKbhVVo3LvfdfqfwtXiQk5007DRasTmrkdDZn9J+Up3pgB8PPJmjRQNz
         8p3yfdofAdILAz3XdcmcqnOYMMMqXLPE8Cf4eMyt/nFCqE5qXdeiL8e8QihzyOZtWsIo
         48aQ==
X-Gm-Message-State: AOAM530rpwBNBfHZYKneEkgDEY+Ard61WOtbjAE2A6v9xiSDKOV/JQV8
        6eDSXSnI1iW0Tzwp11A40n4ZMw==
X-Google-Smtp-Source: ABdhPJzar808ZU8LpYb9uDQ6rhW47LxD+qhmPnzoQAjdPbS6svcOjDw+3HMa4Zi//E0fbN3lKG2Ihw==
X-Received: by 2002:a17:90a:2fc2:: with SMTP id n2mr3230144pjm.112.1628872541032;
        Fri, 13 Aug 2021 09:35:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v63sm3437412pgv.59.2021.08.13.09.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:35:40 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:35:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 4/5] KVM: nVMX: Emulate MTF when performing
 instruction emulation
Message-ID: <YRafVro7jZoswngG@google.com>
References: <20200128092715.69429-1-oupton@google.com>
 <20200128092715.69429-5-oupton@google.com>
 <CALMp9eT+bbnjZ_CXn6900LxtZ5=fZo3-3ZLp1HL2aHo6Dgqzxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT+bbnjZ_CXn6900LxtZ5=fZo3-3ZLp1HL2aHo6Dgqzxg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021, Jim Mattson wrote:
> On Tue, Jan 28, 2020 at 1:27 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Since commit 5f3d45e7f282 ("kvm/x86: add support for
> > MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> > flag processor-based execution control for its L2 guest. KVM simply
> > forwards any MTF VM-exits to the L1 guest, which works for normal
> > instruction execution.
> >
> > However, when KVM needs to emulate an instruction on the behalf of an L2
> > guest, the monitor trap flag is not emulated. Add the necessary logic to
> > kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> > instruction emulation for L2.
> >
> > Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---

...

> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 503d3f42da16..3f3f780c8c65 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -390,6 +390,7 @@ struct kvm_sync_regs {
> >  #define KVM_STATE_NESTED_GUEST_MODE    0x00000001
> >  #define KVM_STATE_NESTED_RUN_PENDING   0x00000002
> >  #define KVM_STATE_NESTED_EVMCS         0x00000004
> > +#define KVM_STATE_NESTED_MTF_PENDING   0x00000008
> 
> Maybe I don't understand the distinction, but shouldn't this new flag
> have a KVM_STATE_NESTED_VMX prefix and live with
> KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE, below?

That does seem to be the case, seems highly unlikely SVM will add MTF.  And SVM's
KVM_STATE_NESTED_GIF_SET should have been SVM specific, but kvm_svm_nested_state_hdr
doesn't even reserve a flags field :-/

> >  #define KVM_STATE_NESTED_SMM_GUEST_MODE        0x00000001
> >  #define KVM_STATE_NESTED_SMM_VMXON     0x00000002

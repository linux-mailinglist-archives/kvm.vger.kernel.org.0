Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6E498CC3
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 20:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350059AbiAXTYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 14:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345327AbiAXTWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 14:22:24 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D27C02B860
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 11:08:43 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 187so16039283pga.10
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 11:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rVsQvo+ZjtK46Xp9A91RBZT4Worccr7KUw8/eqjUom4=;
        b=oBwmdtH13x9b6kAQu+AfvDYJoAIzyE+GKZg3N4sPHI6da5W4ZAw0iucdO03Hsjwk6P
         CxBAQ3AdTNCbqMwBxdqC2VysY9FZyaT/nmnwtCR1kaN7E/e+uRBV766ByYloQunh0WvK
         kNP8Nb4DjJK1oMj+xMboRHrl/r4uYzKGxpFYlaI4AaPfXU00JRGG+WhsLeyq0fjWERzq
         +xOrVG4tdVVa0Fv3m7HtNGGNlIEdZqSS8l/dxo9SW6E01VQA5b5rMLSz1Bek8egU8muk
         MBNeMStA5TimanH4T9D+u0ruY5E4N8jzcQAqZxcFWA3M7ELce0p3WnkldfQG4796IoxW
         phvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rVsQvo+ZjtK46Xp9A91RBZT4Worccr7KUw8/eqjUom4=;
        b=gu7xKCvpD0t6Tut768CQRlYuScolt2gz1VW+rX2Qs/wkbUZONxQsePox0N4alON/8k
         UeDf0pCrxYw5QIhR9YZeNoU0+7GwIJ/WTsIQ9qNCZam3uhaF98cScKoRS1bzcUd/CmL1
         hFXXYCZUjj1Xl89bRVps2rBEysteN7HsKyRrR+El4poQ0Yt6xWhgLTlrTH36XYfiWh7S
         +foLCClNh4HTkSlx+arzWhhHj8gvMc2qqPAOrt8nB6k7YFEDV+qu1PyH3IHt2usRtTnV
         1wtX4O/mb+9q/MY+PafbbrYSVfF7/eDGQ/S0sCjWAbsPkdu33iUdDju/CDbkISsMHkIx
         Vh5Q==
X-Gm-Message-State: AOAM533KlwoS2MSecpFWDugnj+z8tfycoNhMA4zfoZZYF1YVBh5bFfYF
        8slgAJJfMLb9+kuy41SCmrL0GQ==
X-Google-Smtp-Source: ABdhPJxGnukKA6tJEogfNC/QfbWw1VjuOOgZ06J37PBc5sW91RZk/AE0UMR+mdF9nkRQtPlsnbtgzw==
X-Received: by 2002:a63:ad42:: with SMTP id y2mr12736198pgo.386.1643051322966;
        Mon, 24 Jan 2022 11:08:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g21sm2080660pfc.11.2022.01.24.11.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 11:08:42 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:08:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
Message-ID: <Ye75NpxFoOwCi23e@google.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <95f63ed6-743b-3547-dda1-4fe83bc39070@redhat.com>
 <87bl01i2zl.fsf@redhat.com>
 <Ye7ZQJ6NYoZqK9yk@google.com>
 <979883b4-8fcd-7488-0313-de6348863b21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <979883b4-8fcd-7488-0313-de6348863b21@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> On 1/24/22 17:52, Sean Christopherson wrote:
> > On Mon, Jan 24, 2022, Vitaly Kuznetsov wrote:
> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > > > +	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
> > > > > +		return -EINVAL;
> > > > 
> > > > Hmm, not sure about that due to the padding in struct kvm_cpuid_entry2.
> > > >    It might break userspace that isn't too careful about zeroing it.
> > 
> > Given that we already are fully committed to potentially breaking userspace by
> > disallowing KVM_SET_CPUID{2} after KVM_RUN, we might as well get greedy.
> 
> Hmm, I thought this series was because we were _not_ fully committed. :)

We're fully committed in the sense that we know disallowing KVM_SET_CPUID2 after
KVM_RUN broke at least one use case, and instead of reverting we are doubling down
and adding more KVM code/complexity to grandfather in that one use case.  There's
no guarantee that there aren't other use cases that will break, but haven't been
reported simply because their users haven't yet moved to a 5.16 kernel.

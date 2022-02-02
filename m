Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF34A762E
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 17:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbiBBQs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 11:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiBBQs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 11:48:57 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306CC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 08:48:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so18816561plh.13
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 08:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=09vnfcjhMMo62cV1E7KraGWCFcsbkBKuHsD20oyeVS8=;
        b=B8p6BORxAW+ykfgl93riTzatgKBJSMvpdVgNHAHaGAS8WAwQWyx0LQmS3xguwXlUHd
         zMpunvcn5oDLO4lv2SLlpEXDZ6aWtHRHg0nrPZhMz316lXn5u2WetvGtF0B/DghKTmpo
         oHsJ7GEn1OSNVETzMN1qbo5sS47zwJMtNYIQlBZfVhrmg7XIAxYKMaLEzR8113/wCBO2
         RWeeaZAj+LssBgDbo7FN5BJ8aB3QZ9GVKTY6hk/ZWRVL7JHzoq+9u/hy1MS0QLe/m+/u
         C7IIZmhe0w6JVsNW3wXs3pJbIjFKZLMf7y0XP0S5go52iOvrE+fB7pL0UI79D/KpvSSO
         Z3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09vnfcjhMMo62cV1E7KraGWCFcsbkBKuHsD20oyeVS8=;
        b=qBiw/UqT8t6RLaX0prDm1IMg27iukLgKW7HO68WxM8L9D5f12Nb+9yMVNhAt6hIda1
         kUmwqtGIQhG2TMrgqW4+06ybdVU0dEzyGyqMJ5OIU92l4ZQEwUM6U0346fKUmKLZLw5w
         Wov753jwu4GWV25cxxEkWv6beP5gnQa8aa8wqiQSty8zXHP0VDbFiz3JBCBwDOxS8ykz
         394B0eDGqX7P6mvRhbYJNAa8xt/q6FCQBOimW2IVR01uJiukMpsc0TUUu/iZgxrZltgd
         DlYNTRWtnq7yAoXhuyP4+MiimdEdHvl0uS04hoUBiZkY4th1C1QfBT1xr9cK33jxQ00d
         4v/Q==
X-Gm-Message-State: AOAM5324CrIaV+y2Txtng3sQs6HJuL8IthoeLUCsE6w0mGtCrb5VjLwB
        a6EVXQwi4WERMPwEzrptAA0C7g==
X-Google-Smtp-Source: ABdhPJyuH1GZqEbV8Pm9kNi/PWyWJPimWxq0v0luhF93iG5qrIBobO/BnUgZqQ5AWOTbI7pPe+0z2A==
X-Received: by 2002:a17:902:d2cf:: with SMTP id n15mr30521766plc.33.1643820536752;
        Wed, 02 Feb 2022 08:48:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u18sm6716855pjn.49.2022.02.02.08.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 08:48:56 -0800 (PST)
Date:   Wed, 2 Feb 2022 16:48:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH][v3] KVM: x86: refine kvm_vcpu_is_preempted
Message-ID: <Yfq19FSnASMfd0BH@google.com>
References: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
 <20220202145414.GD20638@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202145414.GD20638@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Peter Zijlstra wrote:
> On Mon, Jan 17, 2022 at 01:37:22PM +0800, Li RongQing wrote:
> > After support paravirtualized TLB shootdowns, steal_time.preempted
> > includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> > 
> > and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED
> 
> This still fails to actually explain what the problem is, why did you
> write this patch?

Ya, definitely is lacking details.  I think this captures everything...

  Tweak the assembly code for detecting KVM_VCPU_PREEMPTED to future proof
  it against new features, code refactorings, and theoretical compiler
  behavior.

  Explicitly test only the KVM_VCPU_PREEMPTED flag; steal_time.preempted
  has already been overloaded once for KVM_VCPU_FLUSH_TLB, and checking the
  entire byte for a non-zero value could yield a false positive.  This
  currently isn't problematic as PREEMPTED and FLUSH_TLB are mutually
  exclusive, but that may not hold true for future flags.

  Use AND instead of TEST for querying PREEMPTED to clear RAX[63:8] before
  returning to avoid a potential false postive in the caller due to leaving
  the address (non-zero value) in the upper bits.  Compilers are technically
  allowed to use more than a byte for storing _Bool, and it would be all too
  easy for someone to refactor the return type to something larger.

  Keep the SETcc (but change it to setnz for sanity's sake) as the fact that
  KVM_VCPU_PREEMPTED happens to be bit 0, i.e. the AND will yield 0/1 as
  needed for _Bool, is pure coincidence.

> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff with v2: using andl and setnz
> > diff with v1: clear 64bit rax
> > 
> >  arch/x86/kernel/kvm.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index b061d17..fe0aead 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -1025,8 +1025,9 @@ asm(
> >  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
> >  "__raw_callee_save___kvm_vcpu_is_preempted:"
> >  "movq	__per_cpu_offset(,%rdi,8), %rax;"
> > -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> > -"setne	%al;"
> > +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> > +"andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax;"
> > +"setnz	%al;"
> 
> Isn't the below the simpler way of writing that same?

The AND is needed to clear RAX[63:8], e.g. to avoid breakage if the return value
is changed from a bool to something larger, or the compiler uses more than a byte
for _Bool.

> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a438217cbfac..bc79adcf59ff 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1025,7 +1025,7 @@ asm(
>  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>  "__raw_callee_save___kvm_vcpu_is_preempted:"
>  "movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> +"testb	$" __stringify(KVM_VCPU_PREEMPTED) ", " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
>  "setne	%al;"
>  "ret;"
>  ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"

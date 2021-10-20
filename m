Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A014434399
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 04:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhJTCvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 22:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTCvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 22:51:40 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86480C06161C;
        Tue, 19 Oct 2021 19:49:26 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id v77so7891867oie.1;
        Tue, 19 Oct 2021 19:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZtjUsGVsJLS4CvCJymVm70tVuEVaZ7HK9v4ONvYgro=;
        b=HYDe2nHsrKcit3rKbThWGTTOGMJf7R5JdSLMxBFEji2L0oT0iOyPxUAsP8ot90nFEX
         rF+7KBxkXoEuL9A0xVvbSqbNHF8nRdurfv0rYCJWvOOhVRNJHlE6Ww+bASUqwuABrE9t
         ICssh6v8x40A6p/a4WrCQ38XpqbO6X2TY9m8vK+FDTskA3pHn5+2cs+/Ll+t9l4XhBbj
         JvYWePs9xn6pQAR68BhhRZ8NiizrXMt1AYRu3NwryaezMb5VyKRbVmnmmP5B1m1oO7fg
         gYqvkt1VbWy9XSLuYysAwnrDPVEq7YGl/xflt3dAT4QgEO5lglpPhoFP5A0ZviZztRNB
         Vatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZtjUsGVsJLS4CvCJymVm70tVuEVaZ7HK9v4ONvYgro=;
        b=ZP7coRAai3G+H/FpzSh0AJiDSedHMhngg88sh/W5xGxFXXAK0sE+vGXkHagao8tnIg
         HVFlRNIyL0kHQ9xBs1QG+OoPbaZzQoWaOz4v/Jy+E+QqyNuh234mowkPyo6pEiVkY+V9
         Iaqzk4KKVo20X92d56pLj8azduJz0Wy9asbKwUH1XQOG/VBntEO5f4m3bpBAHQgyKzMq
         dATa3VLPoGDF6B+ST5igszkGfWfrBB9DK5QZdyAa5M84WG4dsQBZut7/WytaSGn3mFhE
         8/TQ0+7FIprWdLmLx3eYB8U09WmfPEFDXxnxSlpuOW9KdGber/j8K9/CkN2e9/IZGou2
         XMGQ==
X-Gm-Message-State: AOAM530Tycs6DdVLu279pFjzVdNnNSK3UnlqjKAZRO0wMTpiTngMzz2y
        f9CMJy9FUVLDvaQK0y5hBC9ewT/TvyGzF6+i594=
X-Google-Smtp-Source: ABdhPJzttPSjDLjxxS0gL+1B5v44Q2oNpxWTf+tmUw99FoWBiGEmNJQ45p7McgbunGY3za6HcFsg0/NDL5bEEfhCTXM=
X-Received: by 2002:aca:3f87:: with SMTP id m129mr6985212oia.5.1634698165919;
 Tue, 19 Oct 2021 19:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com> <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
 <YW8BmRJHVvFscWTo@google.com>
In-Reply-To: <YW8BmRJHVvFscWTo@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Oct 2021 10:49:14 +0800
Message-ID: <CANRm+CzuWnO8FZPTvvOtpxqc5h786o7THyebOFpVAp3BF1xQiw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 at 01:34, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 19, 2021, Paolo Bonzini wrote:
> > On 19/10/21 10:12, Wanpeng Li wrote:
> > > -   if (kvm_vcpu_wake_up(vcpu))
> > > -           return;
> > > +   me = get_cpu();
> > > +
> > > +   if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) && kvm_vcpu_wake_up(vcpu))
> > > +           goto out;
> >
> > This is racy.  You are basically doing the same check that rcuwait_wake_up
> > does, but without the memory barrier before.
>
> I was worried that was the case[*], but I didn't have the two hours it would have
> taken me to verify there was indeed a problem :-)
>
> The intent of the extra check was to avoid the locked instruction that comes with
> disabling preemption via rcu_read_lock().  But thinking more, the extra op should
> be little more than a basic arithmetic operation in the grand scheme on modern x86
> since the cache line is going to be locked and written no matter what, either
> immediately before or immediately after.

I observe the main overhead of rcuwait_wake_up() is from rcu
operations, especially rcu_read_lock/unlock().

>
> So with Paolo's other comment, maybe just this?  And if this doesn't provide the
> desired performance boost, changes to the rcuwait behavior should go in separate
> patch.

Ok.

    Wanpeng

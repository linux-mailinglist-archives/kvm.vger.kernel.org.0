Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C7C3DFF5F
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 12:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhHDKWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 06:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhHDKWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 06:22:52 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F95C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 03:22:39 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id f42so3565483lfv.7
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 03:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KeKqZfswV3Sb0AU8g0UPNhEdRtUw4ir+Xa9mBwdImhQ=;
        b=Sx8QK7m+vzLUPX7gwMaaMlpfLAgy9neplHDzBUyv9uNsaoqOSl1IYCGoAtYmWUIB0r
         mcpN8pzx3GClXZHioEL4F/x3ivqMmLOQ7BVi4CDxQ8EG3sz/yuttN1nBoQvpwG6tA6oP
         aB/xKpr90qG2ceJvP2f20MPyKWRYubGWo8oPlwRA7HJlUoao/JFWualIcemrFCxe6dU3
         BFXrUSR6d2YsnzwCBqVQWdcnBS/FmqxfR0Ogc0ZWjzgwooQfWsl5/ElVdtCBJ/UeXjFS
         hENab/eFfPPxqm1KmWzM3n2DzvGvp/36TlCZAkzJadr9O4rPeZKIitcswfL+VZz/xgi7
         wSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KeKqZfswV3Sb0AU8g0UPNhEdRtUw4ir+Xa9mBwdImhQ=;
        b=h85JjhNc7grykNfkg0yiRnXtLkynxqDyIadueS/aqVtK2q72O5V1w4WIiy+tAuhup9
         Al/X47CsVuXIIiUmIdoONpErdl2lP1lRXrLjc6HGbbIyOJrEjiFvTHEGzyrZEccpIu6z
         8DqRmQgEK7+lhEt5OBQJ6Bk6RcYIBxY/p2vycy97tM6Tvjge9W5IsjIf+PEhf9gkqlZ7
         TfYmo5bPt9CFXAtgqpRkDHRmyeHXMwSPIeu7gCsZ49YGUTtyk2mpcMSyuIUTC+GJFuN0
         3t9j5Ke+z3xNhsXU0bYDIYjbN3unA0q1dgUfYmKjqcQEmYjFJjBDvUnebVzNkecx1u2Q
         fzIw==
X-Gm-Message-State: AOAM5313ohfo2MJ6O8VPOkeVAw98x8KN98sjaRZM8NgWvQx+oiHcg75p
        30HrIxSYNZ+R6eL0TNHOh9AL2Ut0CnhhPXbxycTR5w==
X-Google-Smtp-Source: ABdhPJzB5JAVimicrB+LNM1WlhZujX7PYw4hx552TtO+zR1iDfLhqMpreHlla6ij7/LeLKw1/tY33IuZjyfFTZqjHcw=
X-Received: by 2002:ac2:57cd:: with SMTP id k13mr2429091lfo.117.1628072557209;
 Wed, 04 Aug 2021 03:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com> <20210804085819.846610-18-oupton@google.com>
 <20210804101743.bgkggw7a3wbx7woi@gator.home>
In-Reply-To: <20210804101743.bgkggw7a3wbx7woi@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 4 Aug 2021 03:22:26 -0700
Message-ID: <CAOQ_Qsh9cQob1X=-39H4mMf7gYES5VnQP-t5C_R+HdRgk0WPeg@mail.gmail.com>
Subject: Re: [PATCH v6 17/21] KVM: arm64: Allow userspace to configure a
 guest's counter-timer offset
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 4, 2021 at 3:17 AM Andrew Jones <drjones@redhat.com> wrote:
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index a8815b09da3e..f15058612994 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -85,11 +85,15 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
> >  static u64 timer_get_offset(struct arch_timer_context *ctxt)
> >  {
> >       struct kvm_vcpu *vcpu = ctxt->vcpu;
> > +     struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>
> This new timer variable doesn't appear to get used.

Ooops, this is stale. Thanks for catching that.

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks for the quick review!

--
Oliver

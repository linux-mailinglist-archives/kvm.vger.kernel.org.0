Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5931338F1AB
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhEXQkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbhEXQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 12:40:53 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1126BC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 09:39:25 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so25747600oth.8
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 09:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wTQhlr5VRlPPXQeXXrysbfx7IhbTtHompZ+bTQuGktw=;
        b=rlh89wgkmrQTfd7/rH3GgApxKIAw43xkBlEGLVaJGuJBV1yp2aYO44SMxyTABud6fz
         rK/GhYJRWH/rFLUQrEVeQ4huFo0ZBf48MxuYWm5wOraI0rO4uZ3aIuEA1A1MGrPwcwIc
         cm5wgTEzsSWAYneMqiemv+vsUzxbOc1Di6xi7EM306/JI1JL0qmkPeERSMdhGmkLMfZy
         iEQw9rce4VTHIlMLr2pi2ZOQHzhJQS0QuC3dG1qoLxvNwXxkvtvcBRn8iXPbGuxajra/
         g+QvV/NhAjZjm5Y5CBhCswTnCd7eHiYASbEdegKDhIaOaYDAk5d+jbRIHX8heHbwL4LN
         Xv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wTQhlr5VRlPPXQeXXrysbfx7IhbTtHompZ+bTQuGktw=;
        b=DN+pPNUzfaTiGBxgea9VL01GzCzHURqO5y76ga3xe17EfrA4JpPofjdbauQ4HQCQXh
         ZzQ97LGlra9IdICm7f+klDEolyR/QTpotNRRXT7DB5ixPFDAZegMqUgzeuuTvs1T0f0X
         K6ezeLFyl8EAVtcqf/eicLuw0j31RumEN71+kxCHrtYKsc/y3L4M4/xztP5rb/vXYJHD
         ldJyfNrkMTA8VShBbAOV3v8rOnAZK2AaX6sGmJtF7/VM2Z684BnWmHknPN6iFOMNHfHq
         7pHXrLuhd6QLczeAjeYWKs5V4DwFGjR7/W26gMtzH3I3FHRDbGeV+cBemktwPjUmIjv/
         1ung==
X-Gm-Message-State: AOAM5335TZRDEcX0Ryb2tTmtTym+nBbkWUpnqShYXnB8V6+ybOa6ixlp
        5HWkNIXrEqq8l9XoCfPbqZ1efkvAFzkLlg8hkAyNvA==
X-Google-Smtp-Source: ABdhPJy+DQau5UW2dt19l1vfmYTPq4ePWiGrfTdEid1JjmxfNFZYs93l2cqzc3ketToDBpcsr/k2+8Kkn5ac6XRDJwI=
X-Received: by 2002:a9d:131:: with SMTP id 46mr19745306otu.241.1621874362932;
 Mon, 24 May 2021 09:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
In-Reply-To: <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 09:39:11 -0700
Message-ID: <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events
 fails
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this patch, the accompanying selftest never wakes up from HLT
in L2. If you can get the selftest to work without this patch, feel
free to drop it.

On Mon, May 24, 2021 at 8:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/05/21 01:03, Jim Mattson wrote:
> > At present, there are two reasons why kvm_check_nested_events may
> > return a non-zero value:
> >
> > 1) we just emulated a shutdown VM-exit from L2 to L1.
> > 2) we need to perform an immediate VM-exit from vmcs02.
> >
> > In either case, transition the vCPU to "running."
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d517460db413..d3fea8ea3628 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9468,8 +9468,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
> >
> >   static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> >   {
> > -     if (is_guest_mode(vcpu))
> > -             kvm_check_nested_events(vcpu);
> > +     if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
> > +             return true;
>
> That doesn't make the vCPU running.  You still need to go through
> vcpu_block, which would properly update the vCPU's mp_state.
>
> What is this patch fixing?
>
> Paolo
>
> >       return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
> >               !vcpu->arch.apf.halted);
> >
>

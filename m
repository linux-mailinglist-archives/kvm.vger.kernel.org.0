Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811B848D830
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiAMMtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiAMMtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 07:49:02 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC402C06173F
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 04:49:01 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so6063305otu.10
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 04:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pbhK3Fg2xfmiZILBVft3X/N+oSYbmqzwQb62KlKxZuw=;
        b=HhhnUCyZ/Y9DUaduOuR0Rfo4mnEL/CV6YAQS3dOOWfWgb/N5zI/m+a63ON67CooGjX
         GE+bEW57tmNfolF2p7C6aNEfzLAjrZK/0wwl8J6a+jGMFTltefc/EDKyc7ZEdXyFPYZw
         /tdFQPyOkkiEqK0dNbbtyeXX8y2R8zIp9EirwdlZQ+p9LbF87kIbO5XX9O8ipWJJ2KqZ
         YoDZNvVPvEib8/yTFZvrY8rVCRkydYrkivl2ldzSFlNJwkwqklcMn4PWCNAZZ5z95YQs
         xrra7jdv4AYzv+OljBIyo+EnnIRqwk8QPPrPjjy6b/tLAslaBjurs737l8DGI84q+8uJ
         uSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pbhK3Fg2xfmiZILBVft3X/N+oSYbmqzwQb62KlKxZuw=;
        b=Qr2PKFWDMtcEq0ToZ9qVzIczBtO4ky1oWZtYMiiT4yZMSRZMEK/7h7mjqEJ/1dLr0m
         3RkNxGMVsE+0UON6Ira3T2iladTywSpHcOfIbc7CUwxzqGxAyLJWpku5QnrvlcbIACga
         FmcntZRP8YDiamnuhVjRQSjuXfy+VPTdfyOzQaDcdSQIO+2d3aVakG4dyLi/3nEKYBR6
         vvKsQ1V4+QqH84RFIRBsrJdF8hH41Fsm6HzcAmQPU/HJI+s9CrxmWfHSLdh7yBeh9zyN
         WPtPq5THK2VfYnXd3iy6pSrO5KIVs818de4wyCD0EWO22u+xz5TO8sPSakZMNbApWBG9
         TFww==
X-Gm-Message-State: AOAM531t5Vn962/r9xnrCh9j3lgplEb5ZMKQz+F1vn1kTYXopAR1us1M
        AXXzDjVFu92sqc6ujPx3nmuFs0q9ZwKn8dbJXOk=
X-Google-Smtp-Source: ABdhPJzIZ+L8zyqb7Kw2/L+m9/DAe1rH+PysUuoR9HCqUDhEHvcpotI4Rh8FJIpsu4m5KU3keEjnWOLvTCWXo0uhnFk=
X-Received: by 2002:a05:6830:411f:: with SMTP id w31mr3009699ott.55.1642078140445;
 Thu, 13 Jan 2022 04:49:00 -0800 (PST)
MIME-Version: 1.0
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net> <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net> <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
In-Reply-To: <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 13 Jan 2022 20:48:49 +0800
Message-ID: <CANRm+CwMTqCF7ReVoQKcOVasiXQcnZX7YC_CKJhHg52eBveUDQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Wang,Guangju" <wangguangju@baidu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jan 2022 at 18:16, Li,Rongqing <lirongqing@baidu.com> wrote:
>
>
>
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Peter Zijlstra <peterz@infradead.org>
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B41=E6=9C=8813=E6=97=
=A5 5:31
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Sean Christopherson <seanjc@google.com>
> > =E6=8A=84=E9=80=81: Li,Rongqing <lirongqing@baidu.com>; pbonzini@redhat=
.com;
> > vkuznets@redhat.com; wanpengli@tencent.com; jmattson@google.com;
> > tglx@linutronix.de; bp@alien8.de; x86@kernel.org; kvm@vger.kernel.org;
> > joro@8bytes.org
> > =E4=B8=BB=E9=A2=98: Re: [PATCH] KVM: X86: set vcpu preempted only if it=
 is preempted
> >
> > On Wed, Jan 12, 2022 at 05:30:47PM +0000, Sean Christopherson wrote:
> > > On Wed, Jan 12, 2022, Peter Zijlstra wrote:
> > > > On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> > > > > vcpu can schedule out when run halt instruction, and set itself t=
o
> > > > > INTERRUPTIBLE and switch to idle thread, vcpu should not be set
> > > > > preempted for this condition
> > > >
> > > > Uhhmm, why not? Who says the vcpu will run the moment it becomes
> > > > runnable again? Another task could be woken up meanwhile occupying
> > > > the real cpu.
> > >
> > > Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will
> > > voluntarily schedule out the vCPU and mark it as preempted from the
> > > guest's perspective.  The vast majority, probably all, usage of
> > > steal_time.preempted expects it to truly mean "preempted" as opposed =
to
> > "not running".
> >
> > No, the original use-case was locking and that really cares about runni=
ng.
> >
> > If the vCPU isn't running, we must not busy-wait for it etc..
> >
> > Similar to the scheduler use of it, if the vCPU isn't running, we shoul=
d not
> > consider it so. Getting the vCPU task scheduled back on the CPU can tak=
e a 'long'
> > time.
> >
> > If you have pinned vCPU threads and no overcommit, we have other knobs =
to
> > indicate this I think.
>
>
> Is it possible if guest has KVM_HINTS_REALTIME feature, but its HLT instr=
uction is emulated by KVM?
> If it is possible, this condition has been performance degradation, since=
 vcpu_is_preempted is not __kvm_vcpu_is_preempted, will return false.
>
> Similar, guest has nopvspin, but HLT instruction is emulated;

https://lkml.kernel.org/r/<20210526133727.42339-1-m.misono760@gmail.com>

So it is the second time guys talk about this, we should tune the
dedicated scenario like advertise guest KVM_HINT_REALTIME feature and
not intercept mwait/hlt/pause simultaneously to get the best
performance.

    Wanpeng

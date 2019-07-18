Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117966CBEB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 11:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfGRJ33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 05:29:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33076 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfGRJ32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 05:29:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id q20so28256992otl.0;
        Thu, 18 Jul 2019 02:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NpasdpGQ+k5k5hCl+7N6bXO3B/SAFa/2qIIRqxZLH2k=;
        b=EPwd0NHIgUF5z1lJ4D0bV1b32GqgQ8BaowK4v4Z9r5Aim+npx7WLCJQTMJtCsmzWyc
         OR7tKFCW6AAquA/cyG90tXUJFnA2Yoj7q2HLuUE8TM979Z451SE17/LiaIy1ILKMhyEW
         Dw+JC54KPWNOJTvxUNNg98EVVaGkqGpnttu7dAQHmnQ20F3yoVy7Mw9vLTuHxbwkocmV
         1wvoOHCNjuUw2TWfbJV2DifziYLllFfvI1fBpH4lSgFJy4E/TvrJEISioaOkUBmi246K
         s7j7RwW2ZRIt6JN1pROCnMCT+PNKbkOPE/d7bV1yQj8XOshVzri4zicMVDVpcBUKB4D7
         AAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpasdpGQ+k5k5hCl+7N6bXO3B/SAFa/2qIIRqxZLH2k=;
        b=QpIDbd6ysLDpYyEAJqqOvxjHWMmdAXkj0S4fobxV+TZ0eHtSbiVqi1krlTEOkHEqZm
         vYNzUqr87MFF0vp+L0P/A2d7Iha/I9MI46VpNEDgPgA81OJyex+arXlF5/vlpYXzLM7h
         m0EIlVdm9JzKWt8ecAcMnW2/f6XRblJGi8zmrwDhNozZplFIUAGEgeEeHVeGo86+Zq68
         bT5bFFIph0eAK+yo5rZs8qiylPENlBnDQ4vgm8ZvPd688Vhar3oWdX3B0I++YtC8fabp
         NaGjJB/0HhWudcX+TwbDt59GkqlSZdivsDc4BPHi5cORnvKQ6Qng19bZih9rgaQfv8DJ
         M6UA==
X-Gm-Message-State: APjAAAUwOzpJUwoZEmxfdPlM5nkBQylULNNIiWbdilEdkfwD2tCyAxWp
        jnPvlqzEWupLbYAPrYXUUBPnfUpwcb+ZABmUq3Tg4hqZ
X-Google-Smtp-Source: APXvYqz/cWRn5R55kKWuILJDwaGqioXzFn+iU7ibeLIuE7V6kDlJtr/zLoHWxeSnK2gz//Je7OTAbTcRq9DGNrvdLUg=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr30910465ote.254.1563442167790;
 Thu, 18 Jul 2019 02:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
 <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com> <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
 <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com> <CANRm+Cw43DKqD17U+7-OPX3BmeNBThSe9-uWP2Atob+A0ApzLA@mail.gmail.com>
 <bc210153-fbae-25d4-bf6b-e31ceef36aa5@redhat.com>
In-Reply-To: <bc210153-fbae-25d4-bf6b-e31ceef36aa5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 18 Jul 2019 17:29:19 +0800
Message-ID: <CANRm+CxV0c3RSidV_GQtVuQ5fUUCT8vM=5LpodgDg+dFWhkH3w@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jul 2019 at 17:07, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/07/19 10:43, Wanpeng Li wrote:
> >>> Isnt that done by the sched_in handler?
> >>
> >> I am a bit confused because, if it is done by the sched_in later, I
> >> don't understand why the sched_out handler hasn't set vcpu->preempted
> >> already.
> >>
> >> The s390 commit message is not very clear, but it talks about "a former
> >> sleeping cpu" that "gave up the cpu voluntarily".  Does "voluntarily"
> >> that mean it is in kvm_vcpu_block?  But then at least for x86 it would
> >
> > see the prepare_to_swait_exlusive() in kvm_vcpu_block(), the task will
> > be set in TASK_INTERRUPTIBLE state, kvm_sched_out will set
> > vcpu->preempted to true iff current->state == TASK_RUNNING.
>
> Ok, I was totally blind to that "if" around vcpu->preempted = true, it's
> obvious now.
>
> I think we need two flags then, for example vcpu->preempted and vcpu->ready:
>
> - kvm_sched_out sets both of them to true iff current->state == TASK_RUNNING
>
> - kvm_vcpu_kick sets vcpu->ready to true
>
> - kvm_sched_in clears both of them
>
> This way, vmx_vcpu_pi_load can keep looking at preempted only (it
> handles voluntary preemption in pi_pre_block/pi_post_block).
>
> Also, kvm_s390_vcpu_wakeup can be changed to use kvm_vcpu_wake_up, which
> is nice.

Will do. :)

Wanpeng

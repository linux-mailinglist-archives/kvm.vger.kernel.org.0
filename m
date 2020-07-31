Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945C5234383
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbgGaJo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732281AbgGaJo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 05:44:57 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9BC061574;
        Fri, 31 Jul 2020 02:44:57 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id a65so13041155otc.8;
        Fri, 31 Jul 2020 02:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JNG62fy69ZNDxq3ty1WqRJY8LhS3HHaZ7FOcyMliKZM=;
        b=SVQZMutRleHjpanJu5BLyhMUxWrVl6B4uU9D8HzlgqQvftLkuaf1ZFxkrnfd3GTyIa
         7qMaYgJMcz1N70WksGO0QX5QEfBzArA7Msr29OOkMygRVRtBW2zr9df7Z0VjxawHcd90
         7hbViw5+VwaGhAWYmNqFAF7AQvIn2kRzXK08uL/bj3y7LovP6cqtXyqlwM9oLA2hqpXM
         hjp/B+i7M+WNl4hathfkLJ8JpfCr7IV3jKw9LV+6HCfvdeiMoDgBBi5CxyPDZNVAhIkz
         Y5P5l9gQHMN0YG51tUfZkow23JVYMIbLQ7cNyFGDSekWsiwp3xcSpskf3f3LHsDR8iBD
         nYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JNG62fy69ZNDxq3ty1WqRJY8LhS3HHaZ7FOcyMliKZM=;
        b=Fl9hNteVGX8T9VSTR/arBj/wWMaZJyZ4sL82pp2EUTljUpJ+dKOnJQQu6rf1XJ9agI
         WRqnJYZ8p2iTNke5JJGzxOeiTJEexXGPJP+NtryZ5DLCuwI3MVZh+UHUNyg4upTZKJc/
         epoyXovVOV91ttJHBmVoT//cysE2kAJs/E+w8L40WS81rwt+kNI5ayAMRnJM5SDYYZlC
         nHErbtk6dMwkWdX0oBSor4LxZ3zCJdiyPCZI+2ocykMyOerJRq2z8DuTGfJcUae5Tvba
         OdO0W1NMjZwe/D5Qg9hYoFSDrN7UZyGS7JYMwt6yu4d4MDuJafgEA9H89/gDqAOvjUT+
         Tb0w==
X-Gm-Message-State: AOAM532lFUaGebOqX/wF3YslUEb7EVPTk7ERUmzMMCHkvZsIEgXBBgL1
        RzQI8fRmZvhtfUZLm2waPkkaqMHaHLo9TOLsNwA=
X-Google-Smtp-Source: ABdhPJyk0OiozpueLcIMLCpdph1GFde0a0IXBcDx9lCYtZP5FOhvy+APGIVDBOdPrSkJVtpSG/Fy51YApZ+mPki83X0=
X-Received: by 2002:a05:6830:23a1:: with SMTP id m1mr2303106ots.185.1596188696574;
 Fri, 31 Jul 2020 02:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
 <1596165141-28874-3-git-send-email-wanpengli@tencent.com> <ae8bf85f-00ee-c59c-e543-e0364481526c@redhat.com>
In-Reply-To: <ae8bf85f-00ee-c59c-e543-e0364481526c@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 31 Jul 2020 17:44:45 +0800
Message-ID: <CANRm+CzgB2G5TqcBYikq3JserkbBkNr5a9Q8Fw8E6s49TtrmvA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: SVM: Fix disable pause loop exit/pause
 filtering capability on SVM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Jul 2020 at 15:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/07/20 05:12, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > 'Commit 8566ac8b8e7c ("KVM: SVM: Implement pause loop exit logic in SVM")'
> > drops disable pause loop exit/pause filtering capability completely, I
> > guess it is a merge fault by Radim since disable vmexits capabilities and
> > pause loop exit for SVM patchsets are merged at the same time. This patch
> > reintroduces the disable pause loop exit/pause filtering capability support.
> >
> > Reported-by: Haiwei Li <lihaiwei@tencent.com>
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v2 -> v3:
> >  * simplify the condition in init_vmcb()
> >
> >  arch/x86/kvm/svm/svm.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c0da4dd..bf77f90 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> >       svm->nested.vmcb = 0;
> >       svm->vcpu.arch.hflags = 0;
> >
> > -     if (pause_filter_count) {
> > +     if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
> >               control->pause_filter_count = pause_filter_count;
> >               if (pause_filter_thresh)
> >                       control->pause_filter_thresh = pause_filter_thresh;
> > @@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
> >       struct kvm_vcpu *vcpu = &svm->vcpu;
> >       bool in_kernel = (svm_get_cpl(vcpu) == 0);
> >
> > -     if (pause_filter_thresh)
> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >               grow_ple_window(vcpu);
> >
> >       kvm_vcpu_on_spin(vcpu, in_kernel);
> > @@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >
> >  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > -     if (pause_filter_thresh)
> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >               shrink_ple_window(vcpu);
> >  }
> >
> > @@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
> >
> >  static int svm_vm_init(struct kvm *kvm)
> >  {
> > +     if (!pause_filter_count || !pause_filter_thresh)
> > +             kvm->arch.pause_in_guest = true;
> > +
> >       if (avic) {
> >               int ret = avic_vm_init(kvm);
> >               if (ret)
> >
>
> Queued all three, thanks.  Please do send a testcase for patch 1
> however, I only queued it in order to have it in 5.8.

Thanks, will do in the next week, today is too busy. :)

    Wanpeng

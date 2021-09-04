Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DA14008DC
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 03:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350767AbhIDAxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 20:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbhIDAxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 20:53:42 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD88CC061575;
        Fri,  3 Sep 2021 17:52:41 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b4so675751ilr.11;
        Fri, 03 Sep 2021 17:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMmbBZ9SvFPoZqiC5iSZagcMTS3jRD/IprdBwmAE77I=;
        b=OdzFMg+g1l+BxA/8QIWFvN6UHxfBYb9l3dMQCXTf0ALYSwddS5kdF4VIgkDyrFs3Wb
         qY+kxgZ0ZXqhQG8iR3ktd8h3ETT3u61lwIldXGmm6V3BMqRriYQ3BLJiyuH7kFi7w325
         xJCGjqu8TjI05/hiZzqTLdVyiu+tHzsXqQcTj1LKeBWCrOR6dbtD7j2pI3bB93JMPRGe
         1cbBjpR1m7TE5kVN337yx/7NCkoHozYTJG2K9lqZCmXs6AO30Zd8O4dgqQz0DPBDO/xI
         Ql1kotyeCmeqF+FCp6movVos5FK0CwNThLx7jkyIYaFQv4HXilHLGpT2bqBWOr1Qym9g
         oy9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMmbBZ9SvFPoZqiC5iSZagcMTS3jRD/IprdBwmAE77I=;
        b=H7y8hKnI90t1KUNzfSmibMwXk5TWcme4f93FQ9aZj3/zXkQ8StHjV4w/m1OIH/n07R
         OMFcIuj3XnF2zeZum6guBI3stWxJ1PYoXBFjcuVXLlxVKW7vmX87N0shUWBqXybbhZzH
         u2xBCCxPP/XBVKfDKzwuZ2quYgbjKmSSOnikvAmXPaQLFC+NBdg3J7j8sMkyTWeGeAdU
         p+i+RNIc2NtKZb5kKtcsFFlTYrJjThcqZ7tuyYw34VTlI+ccAsyAdqbovhwaWnXMf4iW
         zUhNXp5PJWfPh6Yy8c0qfsnaJaYTwM37w9qLSH9z4RB41Zg85jx+jQ/rw+GaSPvpNJC0
         w4Hw==
X-Gm-Message-State: AOAM533NpIntqDlVDMq0TC/VJtFYOQHSCrsXV/LBKW2R9zwv7NmEOCJ/
        gVJyQABtwlDUmy6QRv67i1MxSex+5Aqh4NFKcy8=
X-Google-Smtp-Source: ABdhPJytdLhHZ42hDGQpbmEisdDiZ23kphAOrTFuN/Jd8JO/pRcko1+yJXuT/n59IOvS82KIgic1aDsPlz2N/49vjyc=
X-Received: by 2002:a92:7f08:: with SMTP id a8mr1064151ild.125.1630716761230;
 Fri, 03 Sep 2021 17:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210903075141.403071-1-vkuznets@redhat.com> <20210903075141.403071-2-vkuznets@redhat.com>
In-Reply-To: <20210903075141.403071-2-vkuznets@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 4 Sep 2021 08:52:29 +0800
Message-ID: <CAJhGHyBPQehjirJRGWJW9GEV=-Q7n60OjoiNFc_mdrQsoJK+kw@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: Clean up benign vcpu->cpu data races when
 kicking vCPUs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 3, 2021 at 3:52 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Fix a benign data race reported by syzbot+KCSAN[*] by ensuring vcpu->cpu
> is read exactly once, and by ensuring the vCPU is booted from guest mode
> if kvm_arch_vcpu_should_kick() returns true.  Fix a similar race in
> kvm_make_vcpus_request_mask() by ensuring the vCPU is interrupted if
> kvm_request_needs_ipi() returns true.
>
> Reading vcpu->cpu before vcpu->mode (via kvm_arch_vcpu_should_kick() or
> kvm_request_needs_ipi()) means the target vCPU could get migrated (change
> vcpu->cpu) and enter !OUTSIDE_GUEST_MODE between reading vcpu->cpud and
> reading vcpu->mode.  If that happens, the kick/IPI will be sent to the
> old pCPU, not the new pCPU that is now running the vCPU or reading SPTEs.
>
> Although failing to kick the vCPU is not exactly ideal, practically
> speaking it cannot cause a functional issue unless there is also a bug in
> the caller, and any such bug would exist regardless of kvm_vcpu_kick()'s
> behavior.
>
> The purpose of sending an IPI is purely to get a vCPU into the host (or
> out of reading SPTEs) so that the vCPU can recognize a change in state,
> e.g. a KVM_REQ_* request.  If vCPU's handling of the state change is
> required for correctness, KVM must ensure either the vCPU sees the change
> before entering the guest, or that the sender sees the vCPU as running in
> guest mode.  All architectures handle this by (a) sending the request
> before calling kvm_vcpu_kick() and (b) checking for requests _after_
> setting vcpu->mode.
>
> x86's READING_SHADOW_PAGE_TABLES has similar requirements; KVM needs to
> ensure it kicks and waits for vCPUs that started reading SPTEs _before_
> MMU changes were finalized, but any vCPU that starts reading after MMU
> changes were finalized will see the new state and can continue on
> uninterrupted.
>
> For uses of kvm_vcpu_kick() that are not paired with a KVM_REQ_*, e.g.
> x86's kvm_arch_sync_dirty_log(), the order of the kick must not be relied
> upon for functional correctness, e.g. in the dirty log case, userspace
> cannot assume it has a 100% complete log if vCPUs are still running.
>
> All that said, eliminate the benign race since the cost of doing so is an
> "extra" atomic cmpxchg() in the case where the target vCPU is loaded by
> the current pCPU or is not loaded at all.  I.e. the kick will be skipped
> due to kvm_vcpu_exiting_guest_mode() seeing a compatible vcpu->mode as
> opposed to the kick being skipped because of the cpu checks.
>
> Keep the "cpu != me" checks even though they appear useless/impossible at
> first glance.  x86 processes guest IPI writes in a fast path that runs in
> IN_GUEST_MODE, i.e. can call kvm_vcpu_kick() from IN_GUEST_MODE.  And
> calling kvm_vm_bugged()->kvm_make_vcpus_request_mask() from IN_GUEST or
> READING_SHADOW_PAGE_TABLES is perfectly reasonable.
>
> Note, a race with the cpu_online() check in kvm_vcpu_kick() likely
> persists, e.g. the vCPU could exit guest mode and get offlined between
> the cpu_online() check and the sending of smp_send_reschedule().  But,
> the online check appears to exist only to avoid a WARN in x86's
> native_smp_send_reschedule() that fires if the target CPU is not online.
> The reschedule WARN exists because CPU offlining takes the CPU out of the
> scheduling pool, i.e. the WARN is intended to detect the case where the
> kernel attempts to schedule a task on an offline CPU.  The actual sending
> of the IPI is a non-issue as at worst it will simpy be dropped on the
> floor.  In other words, KVM's usurping of the reschedule IPI could
> theoretically trigger a WARN if the stars align, but there will be no
> loss of functionality.
>
> [*] https://syzkaller.appspot.com/bug?extid=cd4154e502f43f10808a
>
> Cc: Venkatesh Srinivas <venkateshs@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

> ---
>  virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e67c93ca403..786b914db98f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -273,14 +273,26 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>                         continue;
>
>                 kvm_make_request(req, vcpu);
> -               cpu = vcpu->cpu;
>
>                 if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>                         continue;
>
> -               if (tmp != NULL && cpu != -1 && cpu != me &&
> -                   kvm_request_needs_ipi(vcpu, req))
> -                       __cpumask_set_cpu(cpu, tmp);
> +               /*
> +                * Note, the vCPU could get migrated to a different pCPU at any
> +                * point after kvm_request_needs_ipi(), which could result in
> +                * sending an IPI to the previous pCPU.  But, that's ok because
> +                * the purpose of the IPI is to ensure the vCPU returns to
> +                * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
> +                * Entering READING_SHADOW_PAGE_TABLES after this point is also
> +                * ok, as the requirement is only that KVM wait for vCPUs that
> +                * were reading SPTEs _before_ any changes were finalized.  See
> +                * kvm_vcpu_kick() for more details on handling requests.
> +                */
> +               if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
> +                       cpu = READ_ONCE(vcpu->cpu);
> +                       if (cpu != -1 && cpu != me)
> +                               __cpumask_set_cpu(cpu, tmp);
> +               }
>         }
>
>         called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
> @@ -3309,16 +3321,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>   */
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  {
> -       int me;
> -       int cpu = vcpu->cpu;
> +       int me, cpu;
>
>         if (kvm_vcpu_wake_up(vcpu))
>                 return;
>
> +       /*
> +        * Note, the vCPU could get migrated to a different pCPU at any point
> +        * after kvm_arch_vcpu_should_kick(), which could result in sending an
> +        * IPI to the previous pCPU.  But, that's ok because the purpose of the
> +        * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
> +        * vCPU also requires it to leave IN_GUEST_MODE.
> +        */
>         me = get_cpu();
> -       if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> -               if (kvm_arch_vcpu_should_kick(vcpu))
> +       if (kvm_arch_vcpu_should_kick(vcpu)) {
> +               cpu = READ_ONCE(vcpu->cpu);
> +               if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
>                         smp_send_reschedule(cpu);
> +       }
>         put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> --
> 2.31.1
>

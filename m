Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A8D1B8AEE
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 04:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDZCFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 22:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbgDZCFM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 22:05:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA42C061A0C;
        Sat, 25 Apr 2020 19:05:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e26so19983154otr.2;
        Sat, 25 Apr 2020 19:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XV/ycCCkbNOtiapuFi8QAjboaHhRP6AP7U91LebFK/8=;
        b=m5h31eSaY8gD6hMEnGw1xNe7BGd9oox5GSVSkSSieNI3JeKRkfex0iT/T1xsDQRXCe
         VXL+zL8lhQ6OwZZgPZLuSyHauCFn82WrlcupV5jh4bBkpqHqZvOTJtj8jhhGd8eZ1hPL
         S6kB3dKzbZoOToILfjdGZWowgeiVsYxWgotBsWmBGZylZUnX3+9upjfeiIHLPu7cY3n+
         YcedJjmG2Y0A28wdx32M178ZUOj7kxx3OwIotIflTeIm/T6U69dXqXQ4G/RC/iP+mmCL
         l2Gn4UpaSgQfuJfKYRRMONB1kMr/XPOBGG398Td0ElXPOgEX/GpnTBx6kMqiM7xe5ATO
         +Rcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XV/ycCCkbNOtiapuFi8QAjboaHhRP6AP7U91LebFK/8=;
        b=FHZcAUKn82iyojfI260BHUBAru4UqUDmWSivUgBP9XG3GHx95/Z24sO4ND69kbdwNI
         zA5JyIcTNvmm2bo2GuSmp9L7+agvimK1Oye9WHiEBeN8lHENRiULyGLyleXB0N44PDNL
         Y71pir3WzsLRpQ274ELVe7GzrM/5eg8WDEQECjFMgdl1rujpfnu6fUPO//1bHEe5/ocW
         YW7tZs6elQRKkTISNN0z+hqdyLfrJZ+RWmia791i2lUR9veFwBaBF+O7+lMaM3eJPXCo
         wmHPd3GcvxiMjpPZZJBa+YWcxWdn3WgaYjLzjJkchINl8JQ8dl7wA9uxVVlp1mk1NIve
         9xYw==
X-Gm-Message-State: AGi0PuZXhTZufr9hDEOs3BX4PF+dxpUrP51vHr1FVJE3hO6t+4B8WYdy
        B1XLIXpC6I4qWYLj0rMtDVKgyXHp2o/42JFBtLjsuQjg
X-Google-Smtp-Source: APiQypJIyDV4LLYHpnEtCktMxekOVKPDUdGjh36BZXibZGgTZQNSbjuWNyQ481rAkx1gqvxwCIBL6Nv+IZqS/k8nx98=
X-Received: by 2002:a05:6830:20d9:: with SMTP id z25mr6500868otq.254.1587866711857;
 Sat, 25 Apr 2020 19:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com> <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sun, 26 Apr 2020 10:05:00 +0800
Message-ID: <CANRm+CwvTrwmJnFWR8UgEkqyE_fyoc6KmrNuHQj=DuJDkR-UGA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 at 14:23, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Introduce need_cancel_enter_guest() helper, we need to check some
> conditions before doing CONT_RUN, in addition, it can also catch
> the case vmexit occurred while another event was being delivered
> to guest software since vmx_complete_interrupts() adds the request
> bit.
>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  arch/x86/kvm/x86.c     | 10 ++++++++--
>  arch/x86/kvm/x86.h     |  1 +
>  3 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f1f6638..5c21027 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>
>  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  {
> -       enum exit_fastpath_completion exit_fastpath;
> +       enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         unsigned long cr3, cr4;
>
> @@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>         vmx_recover_nmi_blocking(vmx);
>         vmx_complete_interrupts(vmx);
>
> -       exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> -       /* static call is better with retpolines */
> -       if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> -               goto cont_run;
> +       if (!kvm_need_cancel_enter_guest(vcpu)) {
> +               exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> +               /* static call is better with retpolines */
> +               if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> +                       goto cont_run;
> +       }

The kvm_need_cancel_enter_guest() should not before
vmx_exit_handlers_fastpath() which will break IPI fastpath. How about
applying something like below, otherwise, maybe introduce another
EXIT_FASTPATH_CONT_FAIL to indicate fails due to
kvm_need_cancel_enter_guest() if checking it after
vmx_exit_handlers_fastpath(), then we return 1 in vmx_handle_exit()
directly instead of kvm_skip_emulated_instruction(). VMX-preemption
timer exit doesn't need to skip emulated instruction but wrmsr
TSCDEADLINE MSR exit does which results in a little complex here.

Paolo, what do you think?

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 853d3af..9317924 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6564,6 +6564,9 @@ static enum exit_fastpath_completion
handle_fastpath_preemption_timer(struct kvm
 {
     struct vcpu_vmx *vmx = to_vmx(vcpu);

+    if (kvm_need_cancel_enter_guest(vcpu))
+        return EXIT_FASTPATH_NONE;
+
     if (!vmx->req_immediate_exit &&
         !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
             kvm_lapic_expired_hv_timer(vcpu);
@@ -6771,12 +6774,10 @@ static enum exit_fastpath_completion
vmx_vcpu_run(struct kvm_vcpu *vcpu)
     vmx_recover_nmi_blocking(vmx);
     vmx_complete_interrupts(vmx);

-    if (!(kvm_need_cancel_enter_guest(vcpu))) {
-        exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
-        if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
-            vmx_sync_pir_to_irr(vcpu);
-            goto cont_run;
-        }
+    exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+    if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
+        vmx_sync_pir_to_irr(vcpu);
+        goto cont_run;
     }

     return exit_fastpath;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99061ba..11b309c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1618,6 +1618,9 @@ static int
handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data

 static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
 {
+    if (kvm_need_cancel_enter_guest(vcpu))
+        return 1;
+
     if (!kvm_x86_ops.set_hv_timer ||
         kvm_mwait_in_guest(vcpu->kvm) ||
         kvm_can_post_timer_interrupt(vcpu))

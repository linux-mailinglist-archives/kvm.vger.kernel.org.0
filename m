Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCF646C826
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 00:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhLGX0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 18:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbhLGX0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 18:26:38 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31987C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 15:23:08 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z6so311022plk.6
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=odaS6pNITaDkFmtnLCbjDjdEj6wji/Y2s13cR0tMYI0=;
        b=A5Dgml+ICiv0/XJnTsX/b6ZUogmJxRkeHcG86qOVgu1pcxsMxx+YXTpKTR61ICsJj9
         v0KQ9+mpu2RrOdqQBiZnJRMvvIdULeqangpBGCu62M0/7wsGQRWIfMINbHCxOLpL5Eas
         1hcioLEj5idWM7f2+I9qwdq9hiTlKbPIf4WmmbCI1UtDqqogbASHOT31GsJ0GBVAPjAz
         triaLaVGIHxVQbbTChW9FkuEc/XiQGUKl+sugxiTZ14gV6js4SqNgSdW63NpkfvD6GMU
         V90SDE3dB1oGA1wamhtB7KyE0BzAlP7+r1xq2NPstpW0F6oJ8fK3kiFOFgFNWACKYH7X
         MMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=odaS6pNITaDkFmtnLCbjDjdEj6wji/Y2s13cR0tMYI0=;
        b=0H+IDu+NPKNoLsY3MqJK0bPMRLVetvOCt7HdjjTaDUuZYmvawjy8BQ8MiPM/RIhtJe
         qP7w29hU2Tmoi5M1q259fgUOMWhWJwmg/X5IHoGHmZM2vPQW9QEH7z079famgke7DWZp
         T01sW1j/35WKTloWut7sSNtnVe1b3x3U1jdAp68HUdFXPwEHlPxlDaBVzx6uAbXss6d1
         vk/EbrgRXT77a+lCd3XfJjeHC+5M9Y/Rz0EELhvrn8yzxc0tyxjV2uhvjx+9V/WoH2wm
         jdfaRpcnw4mDUZFh5AwgU9U+qkVYGyL9Lacgf9XGacT7e6+gTAAO6LwsUiM9tHjXkCtD
         KrXg==
X-Gm-Message-State: AOAM531E2M+QWpTrWetiMHw07aqnkaUSA1ypFUUyHKC3Tz2kDCT2cDtk
        rZBnwyufrYwl21SOebq4mGgsMQ==
X-Google-Smtp-Source: ABdhPJxQi9iVEzKR+cwVo75xEqkFOxRQYSlNj/puTovuLCsY6ib3tUvsobXQe60M7Xfxvvu6cz+Pbg==
X-Received: by 2002:a17:90a:d684:: with SMTP id x4mr2822958pju.244.1638919387463;
        Tue, 07 Dec 2021 15:23:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id me7sm4606927pjb.9.2021.12.07.15.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:23:06 -0800 (PST)
Date:   Tue, 7 Dec 2021 23:23:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aili Yao <yaoaili126@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <Ya/s17QDlGZi9COR@google.com>
References: <20211124125409.6eec3938@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124125409.6eec3938@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021, Aili Yao wrote:
> When cpu-pm is successfully enabled, and hlt_in_guest is true and
> mwait_in_guest is false, the guest cant't use Monitor/Mwait instruction
> for idle operation, instead, the guest may use halt for that purpose, as
> we have enable the cpu-pm feature and hlt_in_guest is true, we will also
> minimize the guest exit; For such a scenario, Monitor/Mwait instruction
> support is totally disabled, the guest has no way to use Mwait to exit from
> non-root mode;
> 
> For cpu-pm feature, hlt_in_guest and others except mwait_in_guest will
> be a good hint for it. So replace it with hlt_in_guest.

This should be a separate patch from the housekeeping_cpu() check, if we add
the housekeeping check.

> Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> ---
>  arch/x86/kvm/lapic.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 759952dd1222..42aef1accd6b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -34,6 +34,7 @@
>  #include <asm/delay.h>
>  #include <linux/atomic.h>
>  #include <linux/jump_label.h>
> +#include <linux/sched/isolation.h>
>  #include "kvm_cache_regs.h"
>  #include "irq.h"
>  #include "ioapic.h"
> @@ -113,13 +114,14 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);

Why not check kvm_{hlt,mwait}_in_guest()?  IIUC, non-housekeeping CPUs don't _have_
to be associated 1:1 with a vCPU, in which case posting the timer is unlikely
to be a performance win even though the target isn't a housekeeping CPU.

And wouldn't exposing HLT/MWAIT to a vCPU that's on a housekeeping CPU be a bogus
configuration?

>  }
>  
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_x86_ops.set_hv_timer
> -	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
> +	       && !(kvm_hlt_in_guest(vcpu->kvm) ||

This is incorrect, the HLT vs. MWAIT isn't purely a posting interrupts thing.  The
VMX preemption timer counts down in C0, C1, and C2, but not deeper sleep states.
HLT is always C1, thus it's safe to use the VMX preemption timer even if the guest
can execute HLT without exiting.

The timer isn't compatible with MWAIT because it stops counting in C3 (or lower),
i.e. the guest can cause the timer to stop counting.

>  		    kvm_can_post_timer_interrupt(vcpu));
>  }
>  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> -- 

Splicing in Wanpeng's version to try and merge the two threads:

On Tue, Nov 23, 2021 at 10:00 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> ---
>  arch/x86/kvm/lapic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 759952dd1222..8257566d44c7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +       return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);

As Aili's changelog pointed out, MWAIT may not be advertised to the guest. 

So I think we want this?  With a non-functional, opinionated refactoring of
kvm_can_use_hv_timer() because I'm terrible at reading !(a || b).

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 40270d7bc597..c77cb386d03d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,14 +113,25 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)

 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
 }

 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
-       return kvm_x86_ops.set_hv_timer
-              && !(kvm_mwait_in_guest(vcpu->kvm) ||
-                   kvm_can_post_timer_interrupt(vcpu));
+       /*
+        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
+        * guest can execute MWAIT without exiting as the timer will stop
+        * counting if the core enters C3 or lower.  HLT in the guest is ok as
+        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
+        *
+        * Don't use the hypervisor timer if KVM can post a timer interrupt to
+        * the guest since posted the timer avoids taking an extra a VM-Exit
+        * when the timer expires.
+        */
+       return kvm_x86_ops.set_hv_timer &&
+              !kvm_mwait_in_guest(vcpu->kvm) &&
+              !kvm_can_post_timer_interrupt(vcpu));
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);


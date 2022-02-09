Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB434AFC17
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 19:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbiBISyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 13:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiBISyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 13:54:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD261C1DC14B
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 10:50:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 10so3028920plj.1
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 10:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kx4teeGsTxdOC1Dg3+JbRhwrBSaO2guC2PPNniJkznY=;
        b=FgRJxSt2dxBWmhNeNCqHb64siqU8YTgLxiXBg8B5pSiKwRSRHGyHX/ccEP5CrFKzYh
         rsWW570rsB9ApA3pHSbQ4/byjfSLPqU/PPCfVPVusMyAo6/XGnkjFSvNl8XL/p9aygl9
         7m46PGz7pY1YpUAPV5D+qJrRhk9RbWFX6PSCg2tYHnn35oua2xK8XeZCyMjaapbotcDX
         Tg0zNuJoPk9ZTt9IsW7CVct+yHWw/NOSVVGVd7k5fsbVK9I/On+qNZPTvDHlw1/ibSBU
         cGyVcivuEBwE+zfTUllitg3BhN3LrqGOI1j7fvUwnPfHIAToMcrbJufzxBsQyDW3s+Rv
         q/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kx4teeGsTxdOC1Dg3+JbRhwrBSaO2guC2PPNniJkznY=;
        b=RlaO3ukQ2fNhqbL7coTT5nr6DoINRI4ldASv3CcPpekGeazfc7Dp57XSVjjtgdQQA3
         /4/GoslQumvurPH63WyJR67F+siMLOQcA0vyA6EAXFyvyrBpPyPGw97+yZq/lAg/qzOY
         NTp/vSUWtSfO7zc9frvriRDtD+zaSIwqdTrrBGNq0DL7C7jSAGK1KhOtHkxSqcanu11y
         iBIiPK/Cn71RhLw0NXvsPlpSN7OTIlGMvRDnIxGRuCKPmHimPy+Cgsxax4Nk6acj/auu
         OGfxNRwA15Bv/M3JUZpL6KCjqCZM7Wt0LtgqC6j/Orn+A/sBT0g0nGJ/hnBsoBOhPo17
         33Ag==
X-Gm-Message-State: AOAM5330ecXFLhgPVl5k8jliJxuouvp9tPSBRpE78J58vaMtnEFNZpye
        3rOJMA/zBtf8BtBTdWsh9m3Jkw==
X-Google-Smtp-Source: ABdhPJx1b8RaBZmJ8u/66Dq6vtiJ5PkfUlU00AExJreoN16rQPc3KIHbej3FxXuRDHSOR0GObcJGdw==
X-Received: by 2002:a17:903:2283:: with SMTP id b3mr3471150plh.0.1644432633928;
        Wed, 09 Feb 2022 10:50:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k13sm22025862pfc.176.2022.02.09.10.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:50:33 -0800 (PST)
Date:   Wed, 9 Feb 2022 18:50:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: x86: Fix emulation in writing cr8
Message-ID: <YgQM9Y1AewuYFVzL@google.com>
References: <20220209062428.332295-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220209062428.332295-1-zhenzhong.duan@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Zhenzhong Duan wrote:
> In emulation of writing to cr8, one of the lowest four bits in TPR[3:0]
> is kept.
> 
> According to Intel SDM 10.8.6.1(baremetal scenario):
> "APIC.TPR[bits 7:4] = CR8[bits 3:0], APIC.TPR[bits 3:0] = 0";
> 
> and SDM 28.3(use TPR shadow):
> "MOV to CR8. The instruction stores bits 3:0 of its source operand into
> bits 7:4 of VTPR; the remainder of VTPR (bits 3:0 and bits 31:8) are
> cleared.";
> 
> so in KVM emulated scenario, clear TPR[3:0] to make a consistent behavior
> as in other scenarios.

AMD's APM agrees:

  Task Priority Sub-class (TPS)—Bits 3 : 0. The TPS field indicates the current
  sub-priority to be used when arbitrating lowest-priority messages. This field
  is written with zero when TPR is written using the architectural CR8 register.

> This doesn't impact evaluation and delivery of pending virtual interrupts
> because processor does not use the processor-priority sub-class to
> determine which interrupts to delivery and which to inhibit.

I believe hardware uses it to arbitrate lowest priority interrupts, but KVM just
does a round-robin style delivery.

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>

Probably worth:

  Fixes: b93463aa59d6 ("KVM: Accelerated apic support")

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/lapic.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7e6fde82d25..306025db9959 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2242,10 +2242,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
>  
>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
>  {
> -	struct kvm_lapic *apic = vcpu->arch.apic;
> -
> -	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
> -		     | (kvm_lapic_get_reg(apic, APIC_TASKPRI) & 4));
> +	apic_set_tpr(vcpu->arch.apic, (cr8 & 0x0f) << 4);

This appears to have been deliberate, but I've no idea what on earth it was
trying to do.  Preserving only bit 2 is super weird.

Author: Avi Kivity <avi@qumranet.com>
Date:   Thu Oct 25 16:52:32 2007 +0200

    KVM: Accelerated apic support

    This adds a mechanism for exposing the virtual apic tpr to the guest, and a
    protocol for letting the guest update the tpr without causing a vmexit if
    conditions allow (e.g. there is no interrupt pending with a higher priority
    than the new tpr).

    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 50c3f3a8dd3d..e7513bb98af1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -815,7 +815,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)

        if (!apic)
                return;
-       apic_set_tpr(apic, ((cr8 & 0x0f) << 4));
+       apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
+                    | (apic_get_reg(apic, APIC_TASKPRI) & 4));
 }



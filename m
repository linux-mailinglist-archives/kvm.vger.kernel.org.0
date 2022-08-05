Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A597B58B005
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiHESuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiHESuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 14:50:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F61764B
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 11:50:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so3378085pgb.4
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 11:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IcI0dLC9PfhjnsRXg+d0B7Dkxih292fFLLz0vnGA0yk=;
        b=A4cz+6MJrIAigBX3SMz8GASWuAFGOE2ABZwdbuYRFcUm88GxYfjBG4qljFTZOuYtUq
         Wa9gINp37YjkMMvityfLVreV1kl61mG4sMbGJMS5nqt4dOeLS0QJ5Elt1fgOOhgJAB6Q
         BfjXNg3mF9lnychcnaCeFa+UjZVag+o67gDTNSMuKB1qbPpdvhg5GvJUlgrEsxZdBxkv
         esLu6LSuaHxQ4ng6AvGy4HKv/E/xJuG987BHT2Fncs30Ry5cAGjVPZyew2HhZ3twL6jI
         6gMefXAI3egr2B0tOlcAuaRvGrzQLK9rNAMUHs8Deys22SKcFt5QOxlUev3TdpryUw56
         nW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IcI0dLC9PfhjnsRXg+d0B7Dkxih292fFLLz0vnGA0yk=;
        b=Hd6AfGOBwa8BtfZoZKUATv06TLOYhkenzyh67BtxOOpOdlgRwvvEWy+NnMj9k3B7wU
         dQyfXLDn0tsb7fou5TiKzH6zPUW/Ru/RrP/WLK0qK/niBmBVhPuzwxEV7EO4IlYSa5nx
         pJFMN4IlBZLJF4Aswavn0AbLdwNrFPW7qOGFUEOKfmqkZnZHNjUIfkSncvBhVbdA4fmU
         z/TA8y8kictAoUVFSh5uCguPHl8SZttGLl2sqUHj8DxZYYb+W8lMnpuLJwBVMYJhPdMS
         BE2DB0uHmMUUi45lE9kJsdGmQrNQINR2Lgu5r/0QTKa2DAGPvZns/1wDiOcvNYq2mc9g
         Lz/g==
X-Gm-Message-State: ACgBeo2ABzd1qH3XC9AJ6mhqmMSdR97E6p2wOmUHjJ1eoBW38Fmz6DOF
        lrXW1TEQNtl7YlAZq51Y/7NsEA==
X-Google-Smtp-Source: AA6agR5lmpe/MTkZsFSxmfgL2Dw/FuKlbLRGdONHPB/BeqByVsc7b8wIBZS5DjYiZeKGpHOY+ohKvw==
X-Received: by 2002:a63:6941:0:b0:41c:9703:d2ea with SMTP id e62-20020a636941000000b0041c9703d2eamr6655204pgc.304.1659725419479;
        Fri, 05 Aug 2022 11:50:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e5c200b0016ec8286733sm3377528plf.243.2022.08.05.11.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 11:50:19 -0700 (PDT)
Date:   Fri, 5 Aug 2022 18:50:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Coleman Dietsch <dietschc@csp.edu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] KVM: x86/xen: Stop Xen timer before changing the
 IRQ vector
Message-ID: <Yu1mZyJeYf/0/LP+@google.com>
References: <20220729184640.244969-1-dietschc@csp.edu>
 <20220729184640.244969-3-dietschc@csp.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729184640.244969-3-dietschc@csp.edu>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022, Coleman Dietsch wrote:
> This moves the stop xen timer call outside of the previously unreachable

Please avoid "This", "This patch", etc... and describe what the change is, not
what the patch is.

> if else statement as well as making sure that the timer is stopped first
> before changing IRQ vector. Code was streamlined a bit also.

Generally speaking, don't describe the literal code changes, e.g. write the changelog
as if you were describing the bug and the fix to someone in a verbal conversation.

> This was contributing to the ODEBUG bug in kvm_xen_vcpu_set_attr crash that
> was discovered by syzbot.

That's not proper justification as it doesn't explain why this patch is needed
even after fixing the immedate cause of the ODEBUG splat.

  Stop Xen's timer (if it's running) prior to changing the vector and
  potentially (re)starting the timer.  Changing the vector while the timer
  is still running can result in KVM injecting a garbage event, e.g.
  vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
  a previous timer but inject the new xen.timer_virq.

> ODEBUG: init active (active state 0)
> object type: hrtimer hint: xen_timer_callbac0
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
> Call Trace:
> __debug_object_init
> debug_hrtimer_init
> debug_init
> hrtimer_init
> kvm_xen_init_timer
> kvm_xen_vcpu_set_attr
> kvm_arch_vcpu_ioctl
> kvm_vcpu_ioctl
> vfs_ioctl
> 

Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
Cc: stable@vger.kernel.org

> Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
> Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
> Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
> ---
>  arch/x86/kvm/xen.c | 37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 2dd0f72a62f2..f612fac0e379 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -707,27 +707,26 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> -		if (data->u.timer.port) {
> -			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> -				r = -EINVAL;
> -				break;
> -			}
> -			vcpu->arch.xen.timer_virq = data->u.timer.port;
> -
> -			/* Check for existing timer */
> -			if (!vcpu->arch.xen.timer.function)
> -				kvm_xen_init_timer(vcpu);
> -
> -			/* Restart the timer if it's set */
> -			if (data->u.timer.expires_ns)
> -				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> -						    data->u.timer.expires_ns -
> -						    get_kvmclock_ns(vcpu->kvm));
> -		} else if (kvm_xen_timer_enabled(vcpu)) {
> -			kvm_xen_stop_timer(vcpu);
> -			vcpu->arch.xen.timer_virq = 0;
> +		if (data->u.timer.port &&
> +		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> +			r = -EINVAL;
> +			break;
>  		}
>  
> +		/* Check for existing timer */
> +		if (!vcpu->arch.xen.timer.function)
> +			kvm_xen_init_timer(vcpu);
> +
> +		/* Stop the timer (if it's running) before changing the vector */
> +		kvm_xen_stop_timer(vcpu);
> +		vcpu->arch.xen.timer_virq = data->u.timer.port;
> +
> +		/* Restart the timer if it's set */

The "if it's set" part is stale, maybe this?

		/* Start the timer if the new value has a valid vector+expiry. */

> +		if (data->u.timer.port && data->u.timer.expires_ns)
> +			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> +					    data->u.timer.expires_ns -
> +					    get_kvmclock_ns(vcpu->kvm));
> +
>  		r = 0;
>  		break;
>  
> -- 
> 2.34.1
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10A56E4E4F
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 18:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjDQQbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 12:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDQQbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 12:31:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4073BF
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:31:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 188-20020a2504c5000000b00b8f6f5dca5dso7123861ybe.7
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681749098; x=1684341098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iZkIcnWaamidOaKX7hyO8KL0dK9JwUzNbsosN0GOY68=;
        b=PqLRElpN5D8h4xNj0PlvBaq1BJIvkmq371aSak27LLccPRk+cruRX2WKNEzNu4BCiE
         qhs873FhNTGP/RteS79EozWBEaXNuXOP/AKf5qFmasNTOkE+a3fZM554E835wdn2zZaT
         WTjuwJsBhGZvuiq2TuPWK31Dd3TdiKow77vmFLYld3S5GoMUaPfZdN2om0vNNDGweNCf
         RgFGR60j4WCKMnb0h+08Ty1a1VXKhYaGULOnifilkNoh3EMNtp9SmOWoE4CdR30ZJiaS
         8qAkSJxgo/CKuojCb8MUTmvRKsjhOlitjnbkWOSusXJYYFtB4CRPhpBQUgg2DhU6G6eN
         E+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681749098; x=1684341098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZkIcnWaamidOaKX7hyO8KL0dK9JwUzNbsosN0GOY68=;
        b=RUSwrY6bQJ3iUtE6lI3IlLpdWMTAq8jZ1i/ulBGI6N+Wns64RgTAaieBG0kKfWuYKp
         inVP0XZmTFQDa4sqzo1qJPq1oKMXBaRwuPcC6T+J5GJgFzxXsG6GwnJfrH870EwQQgYN
         WYmftvBs3Y/9Dbm/XdixEEHPLsENbVG4Rs0gkaEov6vdAodW580aAuqymscoN6l2wXnx
         G/r2bNTofIWF46YlN93nYbz0545UnBwZsrPaXLDOOMZghriHUf2AKEfeUDwDcA/Vg7Sz
         r3KqIREYRCkeh6SDYQ7TyjVKPKNsyLVpofhVAAjSGFzXzGnQQrTMD0C6kKE+NHKngvu0
         toOQ==
X-Gm-Message-State: AAQBX9f8FwKURh7UBBOAA6E+/WKDShbVlfsMxvZK/V6VugT8QF/02qZO
        vFwPp79hqUlPq8xgLXh1IMKuLu2AXng=
X-Google-Smtp-Source: AKy350b12TLR7wEhO6we2JrC2a6cENyZpKBn08VbDboXZGGRXXRuwWHnBTmQ1jEfz1HsxQu3CI2mLNRBTRk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af55:0:b0:552:e74d:318e with SMTP id
 x21-20020a81af55000000b00552e74d318emr2283071ywj.7.1681749098147; Mon, 17 Apr
 2023 09:31:38 -0700 (PDT)
Date:   Mon, 17 Apr 2023 09:31:36 -0700
In-Reply-To: <20230417122206.34647-2-metikaya@amazon.co.uk>
Mime-Version: 1.0
References: <20230417122206.34647-1-metikaya@amazon.co.uk> <20230417122206.34647-2-metikaya@amazon.co.uk>
Message-ID: <ZD10aFK0heJrs6f2@google.com>
Subject: Re: [PATCH v2] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        bp@alien8.de, dwmw@amazon.co.uk, paul@xen.org, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023, Metin Kaya wrote:
> HVMOP_flush_tlbs suboperation of hvm_op hypercall allows a guest to
> flush all vCPU TLBs. There is no way for the VMM to flush TLBs from
> userspace.

Ah, took me a minute to connect the dots.  Monday morning is definitely partly
to blame, but it would be helpful to expand this sentence to be more explicit as
to why userspace's inability to efficiently flush TLBs.

And strictly speaking, userspace _can_ flush TLBs, just not in a precise, efficient
way.

> Hence, this patch adds support for flushing vCPU TLBs to KVM

Don't use "this patch", just state what the patch does as a command.

> by making a KVM_REQ_TLB_FLUSH_GUEST request for all guest vCPUs.

E.g.

  Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
  allows the guest to flush all vCPU's TLBs.  KVM doesn't provide an ioctl()
  to precisely flush guest TLBs, and punting to userspace would likely
  negate the performance benefits of avoiding a TLB shootdown in the guest.

> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> 
> ---

Regarding the cover letter, first and foremost, make sure the cover letter has
a subject.  `git format-patch --cover-letter` will generate what you want, i.e.
there's no need hand generate it (or however you ended up with a nearly empty
mail with no subjection.

Second, there's no need to provide a cover letter for a standalone patch just to
capture the version information.  This area of the patch, between the three "---"
and the diff, is ignored by `git am`, and can be used for version info.

>  arch/x86/kvm/xen.c                 | 31 ++++++++++++++++++++++++++++++
>  include/xen/interface/hvm/hvm_op.h |  3 +++

Modifications to uapi headers is conspicuously missing.  I.e. there likely needs
to be a capability so that userspace can query support.

>  2 files changed, 34 insertions(+)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 40edf4d1974c..78fa6d08bebc 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -21,6 +21,7 @@
>  #include <xen/interface/vcpu.h>
>  #include <xen/interface/version.h>
>  #include <xen/interface/event_channel.h>
> +#include <xen/interface/hvm/hvm_op.h>
>  #include <xen/interface/sched.h>
>  
>  #include <asm/xen/cpuid.h>
> @@ -1330,6 +1331,32 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, bool longmode,
>  	return false;
>  }
>  
> +static void kvm_xen_hvmop_flush_tlbs(struct kvm_vcpu *vcpu, bool longmode,

Passing @longmode all the way down here just to ignore just screams copy+paste :-)

> +				     u64 arg, u64 *r)
> +{
> +	if (arg) {
> +		*r = -EINVAL;
> +		return;
> +	}
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);

This doesn't even compile.  I'll give you one guess as to how much confidence I
have that this was properly tested.

Aha!  And QEMU appears to have Xen emulation support.  That means KVM-Unit-Tests
is an option.  Specifically, extend the "access" test to use this hypercall instead
of INVLPG.  That'll verify that the flush is actually being performed as expteced.

> +	*r = 0;

Using a out param in a void function is silly.  But that's a moot point because
this whole function is silly, just open code it in the caller.

> +}
> +
> +static bool kvm_xen_hcall_hvm_op(struct kvm_vcpu *vcpu, bool longmode,

There's no need for @longmode.

> +				 int cmd, u64 arg, u64 *r)
> +{
> +	switch (cmd) {
> +	case HVMOP_flush_tlbs:
> +		kvm_xen_hvmop_flush_tlbs(vcpu, longmode, arg, r);

This can simply be:

		if (arg) {
			*r = -EINVAL;
		} else {
			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_TLB_FLUSH_GUEST);
			*r = 0;
		}
		return true;

> +		return true;
> +	default:
> +		break;
> +	}
> +
> +	return false;
> +}
> +
>  struct compat_vcpu_set_singleshot_timer {
>      uint64_t timeout_abs_ns;
>      uint32_t flags;
> @@ -1501,6 +1528,10 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>  			timeout |= params[1] << 32;
>  		handled = kvm_xen_hcall_set_timer_op(vcpu, timeout, &r);
>  		break;
> +	case __HYPERVISOR_hvm_op:
> +		handled = kvm_xen_hcall_hvm_op(vcpu, longmode, params[0], params[1],
> +					       &r);

It'll be a moot point, but in the future let code like this poke out past 80 chars.
The 80 char soft limit exists to make code more readable, wrapping a one-char variable
at the tail end of a function call does more harm than good.

> +		break;
>  	}
>  	default:
>  		break;
> diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
> index 03134bf3cec1..373123226c6f 100644
> --- a/include/xen/interface/hvm/hvm_op.h
> +++ b/include/xen/interface/hvm/hvm_op.h
> @@ -16,6 +16,9 @@ struct xen_hvm_param {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
>  
> +/* Flushes all VCPU TLBs:

s/VCPU/vCPU

And "all vCPU TLBs" is ambiguous.  It could mean "all TLBs for the target vCPU".
Adding "guest" in there would also be helpful, e.g. to make it clear that this
doesn't flush TDP mappings.

> @arg must be NULL. */

Is the "NULL" part verbatim from Xen?  Because "0" seems like a better description
than "NULL" for a u64.

E.g.

  "Flush guest TLBs for all vCPUs"

> +#define HVMOP_flush_tlbs            5
> +
>  /* Hint from PV drivers for pagetable destruction. */
>  #define HVMOP_pagetable_dying       9
>  struct xen_hvm_pagetable_dying {
> -- 
> 2.39.2
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEA058AFF3
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiHEShV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 14:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241225AbiHEShT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 14:37:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516D2EE2C
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 11:37:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q19so2947586pfg.8
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 11:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=lELyiIs1M4XhaXsTw4w5NqfKv5uqGU1KMVAeFBFrmLw=;
        b=IjSOTskopD9xhiXK61Q0+jIYrE1wEloCdlU8aKJFpxNmGh4dk0tEyWp8tiKqoAH9S/
         vfWt5HGfLWgwGo0iuRY1BHR0J5VSYzv85H9DvcVdXGdiqUhmxLyU7r5IdEYP247TdcGY
         PgogGFR/bHG35vakLhyyIOaHbTbVsxHDPcsi70s342ctBmpme/sQQORnmeln6LjFnUaS
         i91Whc6wvegRSfOiXyNrHvONBZm+q7SVhaRLQmNHA9VN49Gc7JaIL8eknoDE80Ausndf
         ZWUZU+XceH3clbGQghM592Uh7sYRu5a+pYvh1DHyFjF3YVkzgl8CO9fEeJw982UUMZdA
         Fx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lELyiIs1M4XhaXsTw4w5NqfKv5uqGU1KMVAeFBFrmLw=;
        b=MBjaw6OYR6oszm3MwdtVY+uapVnLzoBCL8iCEn1efkmUfMgbHQLjW+leImkqOzc0S5
         0tYAqDqw0Jub/DRITBCwaDzM/xu6n8JOiFPBNinFRf1KInmMJklS6puBsx/g94xgSCkT
         k5MCy61SNIqiegUNY3vmMLIC68BT4xwfsWxYkHCJqwOl3Ywu+D9YtajUlnzAnmS0uHUz
         anigcJzkW+0UkGAWNF5M2R6sC4HjObFq+1ahcB4+3CLFAtPABmXkCcg2Usx8kIXg0VW5
         Net7rY6CWF2y+gp1jHknnDGVmOTWLkwP/ly1lAM5CfTYV7gTXikZF7iBAxMurIB8qZ+b
         BecQ==
X-Gm-Message-State: ACgBeo02kQCdFCVGQYZdjBzC2fIvNiVI97YnsjWr69merSHhmBYk8r8m
        hbxfMHiuLqBEirdfpo/WF9xs0g==
X-Google-Smtp-Source: AA6agR5uK/vVHvtkmvHFgUqgHizAXSnbLOqsLz1hkP/xNbxDCwRqyr+pfYvuuGfxHn/o2dsOXdYKvg==
X-Received: by 2002:a63:4645:0:b0:41a:6c24:4fa3 with SMTP id v5-20020a634645000000b0041a6c244fa3mr6892782pgk.114.1659724637580;
        Fri, 05 Aug 2022 11:37:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t67-20020a628146000000b0052d8b663c37sm3288244pfd.195.2022.08.05.11.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 11:37:17 -0700 (PDT)
Date:   Fri, 5 Aug 2022 18:37:13 +0000
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
Subject: Re: [PATCH v2 1/2] KVM: x86/xen: Initialize Xen timer only once
Message-ID: <Yu1jWSPHiow72qVc@google.com>
References: <20220729184640.244969-1-dietschc@csp.edu>
 <20220729184640.244969-2-dietschc@csp.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729184640.244969-2-dietschc@csp.edu>
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
> Add a check for existing xen timers before initializing a new one.
> 
> Currently kvm_xen_init_timer() is called on every
> KVM_XEN_VCPU_ATTR_TYPE_TIMER, which is causing the following ODEBUG
> crash when vcpu->arch.xen.timer is already set.
> 
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

One uber nit below, otherwise:

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/xen.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 610beba35907..2dd0f72a62f2 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -713,7 +713,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  				break;
>  			}
>  			vcpu->arch.xen.timer_virq = data->u.timer.port;
> -			kvm_xen_init_timer(vcpu);
> +
> +			/* Check for existing timer */

I vote to omit the comment, "existing timer" is ambiguous, e.g. it could mean that
there's an existing _running_ timer as opposed to an existing initialized timer.
IMO the code is obvious enough on its own.

> +			if (!vcpu->arch.xen.timer.function)
> +				kvm_xen_init_timer(vcpu);
>  
>  			/* Restart the timer if it's set */
>  			if (data->u.timer.expires_ns)
> -- 
> 2.34.1
> 

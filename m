Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5F85209B8
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 01:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiEIX7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 19:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiEIX7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 19:59:04 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ECD29B819
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 16:55:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d22so15285784plr.9
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 16:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O78xywV/WeUMZw6P+ZnHpCQ7tZ+vR8qII19ouyYA5rU=;
        b=Es7HhFKCIeaWF1sF/V4rHwVPw2S15afmHGuDUtoTm3zrXHozb/yFik/SGvyGUaGNeR
         TnOcaBofWYugjbi8ZXo5H9XHRgDHmcSLL09mIW0fOS/u6NHz4rY7S79agxEZF9llteML
         Q0rw+LCw9kWNiksl3g4o6ky3qE2GkvUh02te31ekng1EC+CY/DHveXzR2idBQHlKQ4vj
         w6DSePuUpzVBGh0S5hO5X4yyJeXYrcbp7z22jclrug2KK07BCYsgCVycZSkG1OskgbHX
         oPi2K3EkWB4i39WMP7PlxmrreZKiJy/7P4oFJoW2WpgMAleGo6EOjrRrfP94nQLh2+gj
         m/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O78xywV/WeUMZw6P+ZnHpCQ7tZ+vR8qII19ouyYA5rU=;
        b=TF08csSxOzElD9g+BT9bP7RVVkXqL81TiGcfhAVWSXuOOBy9WPWhO5EXxFwGQIB/dE
         zEyLSd1+28T8VbDdhisUQpzwQJxFVHNxwxUSvbsrsVrv+ji0LpjDA77GTC6eKlR3I/JN
         IILcNxzTZXiN05JCT21S6I44O9r7SRxYIdVz/W7n4VNeA4qZRYzQ9AdfuXQPzazzLO2H
         ADiI+SZZn03CBUPvtkBFZ5Z+CzmBs/Rv/s7nnCtuzITN1X/S5iKTnaiQPw2nD7JpHaRB
         xC86wecwPSixdVf3dV4PLqtqzd2mkjj3MSQshMg6D8B9QRMBAqfibLrwiresw7Xf6ME1
         Ksbw==
X-Gm-Message-State: AOAM532x47k2YvQE1Ie+6QNKd+1+EtAZGRXqj7jaDR6O7WN9acEhG0Ac
        JszZuHubIp7r5I5CKOB/EqcTNw==
X-Google-Smtp-Source: ABdhPJz8yjL98IB1aOTDK7vwl648g2e2RAZa9hJXMAXstr/QS6XGMFDjVl70LVEPCkEBHXh+0/IgFg==
X-Received: by 2002:a17:903:228e:b0:15e:9462:b058 with SMTP id b14-20020a170903228e00b0015e9462b058mr18359407plh.64.1652140508432;
        Mon, 09 May 2022 16:55:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k70-20020a638449000000b003c6445e2aa8sm7212096pgd.4.2022.05.09.16.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 16:55:08 -0700 (PDT)
Date:   Mon, 9 May 2022 23:55:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Zhang <zhanwei@google.com>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: allow guest to send its _stext for kvm
 profiling
Message-ID: <Ynmp2AEOQvWw+CYK@google.com>
References: <20220412195846.3692374-1-zhanwei@google.com>
 <20220412195846.3692374-2-zhanwei@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412195846.3692374-2-zhanwei@google.com>
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

On Tue, Apr 12, 2022, Wei Zhang wrote:
> The profiling buffer is indexed by (pc - _stext) in do_profile_hits(),
> which doesn't work for KVM profiling because the pc represents an address
> in the guest kernel. readprofile is broken in this case, unless the guest
> kernel happens to have the same _stext as the host kernel.
> 
> This patch adds a new hypercall so guests could send its _stext to the
> host, which will then be used to adjust the calculation for KVM profiling.

Disclaimer, I know nothing about using profiling.

Why not just omit the _stext adjustment and profile the raw guest RIP?  It seems
like userspace needs to know about the guest layout in order to make use of profling
info, so why not report raw info and let host userspace do all adjustments?

> Signed-off-by: Wei Zhang <zhanwei@google.com>
> ---
>  arch/x86/kvm/x86.c            | 15 +++++++++++++++
>  include/linux/kvm_host.h      |  4 ++++
>  include/uapi/linux/kvm_para.h |  1 +
>  virt/kvm/Kconfig              |  5 +++++
>  4 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 547ba00ef64f..abeacdd5d362 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9246,6 +9246,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
>  		return 0;
>  	}
> +#ifdef CONFIG_ACCURATE_KVM_PROFILING
> +	case KVM_HC_GUEST_STEXT:
> +		vcpu->kvm->guest_stext = a0;

Rather than snapshot the guest offset, snapshot the delta.  E.g.

		vcpu->kvm->arch.guest_stext_offset = (unsigned long)_stext - a0;

Then the profiling flow can just be

		unsigned long rip;

		rip = kvm_rip_read(vcpu) + vcpu->kvm->arch.guest_text_offset;
		profile_hit(KVM_PROFILING, (void *)rip);


> +		ret = 0;
> +		break;
> +#endif
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> @@ -10261,6 +10267,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(prof_on == KVM_PROFILING)) {
>  		unsigned long rip = kvm_rip_read(vcpu);
> +#ifdef CONFIG_ACCURATE_KVM_PROFILING

A Kconfig, and really any #define, is completely unnecessary.  This is all x86
code, just throw the offest into struct kvm_arch.

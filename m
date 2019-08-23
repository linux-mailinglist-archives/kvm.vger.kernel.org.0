Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD89AE70
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403857AbfHWLvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:51:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732231AbfHWLvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:51:31 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43F7D3C919
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 11:51:31 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id o5so4688403wrg.15
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 04:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h8apOMQcMnkR0Xh2bX2ZYhURLs98LXNDVyrmuOfYteo=;
        b=nBdJjtgimYa55OhKdW6ait4g8KGx4yN7m14OiWkFdvHMO30XEwuTmaYyclBkA2W5KZ
         tgnSuZYEUXhEhT+t9QcDSgrQz6vC94hqPYMzG6FJa4O1uRLDYbP6yf7JmKABE0P6Z2RP
         zWZWTt5RleITErDSyTF5F1GKya7sadcLZqLzDipO4Tb3O3/0O9bLq/U/pUAg6ccnaebJ
         +G9cXjUF0w7bUAaBRYwHANHvEPWeHE7Or0yESLbZtAFIK0o7aZCqIjInj+Fhkb7wJlWD
         P3G6J4c/HFtKdsPYekACbKhrdgTjVUeJtbDsbxkZFb1pQnODlvCmYnjou6WHm9FhX/Wr
         cuTw==
X-Gm-Message-State: APjAAAWO7YJ/fiRQPUc0gOGq7PvWpIL8PaoFhFD9DRbYYbsoEm6XcBsG
        kg5ZWP/mu60oFL9HXroxocv7qAhN3ilOuLPikok4pL10ErdH4XvUs1P5EIv6rpKu3laepT0GuB8
        Ch5LWMNHc6oLF
X-Received: by 2002:a1c:8187:: with SMTP id c129mr4749718wmd.32.1566561089895;
        Fri, 23 Aug 2019 04:51:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyjnmwlYvislsMs2UJ/v8ZJ0/n+8yf6ansBAOCch+OGC2DEsaKbLG57Jwsh/MiBGehwvmAwkw==
X-Received: by 2002:a1c:8187:: with SMTP id c129mr4749700wmd.32.1566561089650;
        Fri, 23 Aug 2019 04:51:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v7sm2641709wrn.41.2019.08.23.04.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 04:51:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RESEND PATCH 05/13] KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error code
In-Reply-To: <20190823010709.24879-6-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com> <20190823010709.24879-6-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 13:51:28 +0200
Message-ID: <87y2zknlq7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> The VMware backdoor hooks #GP faults on IN{S}, OUT{S}, and RDPMC, none
> of which generate a non-zero error code for their #GP.  Re-injecting #GP
> instead of attempting emulation on a non-zero error code will allow a
> future patch to move #GP injection (for emulation failure) into
> kvm_emulate_instruction() without having to plumb in the error code.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

(I just need to get this off my chest)

There was a long-standing issue with #GP interception: in case the
exception has nothing to do with VMware we were getting into infinite
loop of #GPs (and not #GP -> #DF -> #TF), e.g. here is a trace of 
platform_info selftest:

           <...>-43752 [001]  3615.602298: kvm_exit:             reason EXIT_MSR rip 0x4015c2 info 0 0
           <...>-43752 [001]  3615.602299: kvm_msr:              msr_read ce = 0x0 (#GP)
           <...>-43752 [001]  3615.602300: kvm_inj_exception:    #GP (0x0)
           <...>-43752 [001]  3615.602301: kvm_entry:            vcpu 0
           <...>-43752 [001]  3615.602302: kvm_exit:             reason EXIT_EXCP_GP rip 0x4015c2 info 6a 0
           <...>-43752 [001]  3615.602308: kvm_emulate_insn:     0:4015c2: 0f 32
           <...>-43752 [001]  3615.602308: kvm_inj_exception:    #GP (0x6a)
           <...>-43752 [001]  3615.602309: kvm_entry:            vcpu 0
           <...>-43752 [001]  3615.602310: kvm_exit:             reason EXIT_EXCP_GP rip 0x4015c2 info 6a 0
           <...>-43752 [001]  3615.602312: kvm_emulate_insn:     0:4015c2: 0f 32
           <...>-43752 [001]  3615.602312: kvm_inj_exception:    #GP (0x6a)
           <...>-43752 [001]  3615.602313: kvm_entry:            vcpu 0
  and so on.

This commit fixes the issue as the second #GP has error code:

           <...>-52213 [006]  3740.739495: kvm_entry:            vcpu 0
           <...>-52213 [006]  3740.739496: kvm_exit:             reason EXIT_MSR rip 0x4015c2 info 0 0
           <...>-52213 [006]  3740.739497: kvm_msr:              msr_read ce = 0x0 (#GP)
           <...>-52213 [006]  3740.739502: kvm_inj_exception:    #GP (0x0)
           <...>-52213 [006]  3740.739503: kvm_entry:            vcpu 0
           <...>-52213 [006]  3740.739504: kvm_exit:             reason EXIT_EXCP_GP rip 0x4015c2 info 6a 0
           <...>-52213 [006]  3740.739505: kvm_inj_exception:    #DF (0x0)
           <...>-52213 [006]  3740.739506: kvm_entry:            vcpu 0
           <...>-52213 [006]  3740.739507: kvm_exit:             reason EXIT_EXCP_GP rip 0x4015c2 info 42 0
           <...>-52213 [006]  3740.739508: kvm_fpu:              unload
           <...>-52213 [006]  3740.739510: kvm_userspace_exit:   reason KVM_EXIT_SHUTDOWN (8)

I'm not exactly sure this covers all possible cases as there might be
other cases when error code is not set but this is definitely an
improvement.

Reviewed-and-tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/svm.c     | 6 +++++-
>  arch/x86/kvm/vmx/vmx.c | 7 ++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5a42f9c70014..b96a119690f4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2772,11 +2772,15 @@ static int gp_interception(struct vcpu_svm *svm)
>  
>  	WARN_ON_ONCE(!enable_vmware_backdoor);
>  

In case you'll be respinning for whatever reason, could you please add a
short comment here (and vmx) saying something like "#GP interception for
VMware backdoor emulation only handles IN{S}, OUT{S}, and RDPMC and none
of these have a non-zero error code set" (I don't like the fact that
we'll need to have two copies of it but I can't think of a better place
for it).

> +	if (error_code) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +		return 1;
> +	}
>  	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
>  	if (er == EMULATE_USER_EXIT)
>  		return 0;
>  	else if (er != EMULATE_DONE)
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>  	return 1;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ecf773825e2..3ee0dd304bc7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4509,11 +4509,16 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  
>  	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
>  		WARN_ON_ONCE(!enable_vmware_backdoor);
> +
> +		if (error_code) {
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +			return 1;
> +		}
>  		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
>  		if (er == EMULATE_USER_EXIT)
>  			return 0;
>  		else if (er != EMULATE_DONE)
> -			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>  		return 1;
>  	}

-- 
Vitaly

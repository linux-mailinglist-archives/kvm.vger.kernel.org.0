Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E17E4F550D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377338AbiDFFZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846071AbiDFCCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 22:02:40 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19D6C92F
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 16:31:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h19so909670pfv.1
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 16:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6JOmtv6Rm4jDh0GV7OKzMV/6Ac5cnRIZHSOY48wGL+U=;
        b=IR7NpSrOcaWXxtSNibofCxKTyR+Y1ehaqpsHYBWsLG588QCVk7fyXTNrhtWv6FZeN2
         4HDgQFkk5m4kzQLr6UWhK0RjQoq+ntg9xHh9c17ebLkzzEG6C1PW/dgwNs+PxqotwjNj
         sTBMKqfrkpgzOefDX4j9aEhyESmeM0tv64aQXFVSLdQd04zlAbQ/OnewgnvGt5izAhek
         xwpsUnP7pRDkR2YZJuD5/oG7B9GuG9RD5K+bM7Ra/2kc/2hFSgL0d6EYVroT8YhB0RbO
         RNKIUB9VO74CVWys7kx8e5eu77BmMlRwoOaesF9yaVKJyhGwgagVzn3SjGmPi8cgQk2c
         Im8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6JOmtv6Rm4jDh0GV7OKzMV/6Ac5cnRIZHSOY48wGL+U=;
        b=KqRbE/81dRobDnZagSz85+kkioVhMX+FTTwu84gmh3OV9pJjFHrEfeeGUi0/j8Femf
         modCasieSkZGzYry2LLZsR64k1yhsLl0ourmpfFYT4BhQoMU0FSJNzvBcpaI4/qXGwl5
         tWITqohuwgrBSB+N53+sXKO2VlRZ854CEkojoJDYo4bLyX7A6cecXhOb3iUhL+XhIJ1y
         7HjDHqt11zDi1ldE+ze6ggaP0RYNR7OqcHGXCUe7d5aARskgFU9rCvZcbchUcz/G+LMq
         hl38z122Ebm1tnilXU2ZwZvKVJBxCwnTMxFORHMXBeF0r0gx4TL4hXdnJ0mlYqlrtNEd
         inMQ==
X-Gm-Message-State: AOAM530hG/mIT03/zza2JDqgsPlKNXBRvo+gcZtPZqFsqvQomrR0EGNI
        YfZByXBlqhRQRb5DF0KjXa03oQ==
X-Google-Smtp-Source: ABdhPJxsLjjK4uqFcbL1535kTJ41gTxis92axMmsCdKtnF2Ol53TKxBl5mCocSqV/2Ap1aWie/DWRg==
X-Received: by 2002:a63:6645:0:b0:382:65eb:1215 with SMTP id a66-20020a636645000000b0038265eb1215mr4767387pgc.337.1649201484673;
        Tue, 05 Apr 2022 16:31:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v22-20020a056a00149600b004fb34a7b500sm17228303pfu.203.2022.04.05.16.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 16:31:23 -0700 (PDT)
Date:   Tue, 5 Apr 2022 23:31:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Message-ID: <YkzRSHHDMaVBQrxd@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074955.22428-2-chenyi.qiang@intel.com>
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

On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> For the triple fault sythesized by KVM, e.g. the RSM path or
> nested_vmx_abort(), if KVM exits to userspace before the request is
> serviced, userspace could migrate the VM and lose the triple fault.
> Fix this issue by adding a new event KVM_VCPUEVENT_TRIPLE_FAULT in
> get/set_vcpu_events() to track the triple fault request.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  Documentation/virt/kvm/api.rst  | 6 ++++++
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/x86.c              | 9 ++++++++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 691ff84444bd..9682b0a438bd 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1146,6 +1146,9 @@ The following bits are defined in the flags field:
>    fields contain a valid state. This bit will be set whenever
>    KVM_CAP_EXCEPTION_PAYLOAD is enabled.
>  
> +- KVM_VCPUEVENT_TRIPLE_FAULT may be set to signal that there's a
> +  triple fault request waiting to be serviced.

Please avoid "request" in the docs, as before, that's a KVM implemenation detail.
For this one, maybe "there's a pending triple fault event"?

> +
>  ARM/ARM64:
>  ^^^^^^^^^^
>  
> @@ -1241,6 +1244,9 @@ can be set in the flags field to signal that the
>  exception_has_payload, exception_payload, and exception.pending fields
>  contain a valid state and shall be written into the VCPU.
>  
> +KVM_VCPUEVENT_TRIPLE_FAULT can be set in flags field to signal that a
> +triple fault request should be made.


And here, "to signal that KVM should synthesize a triple fault for the guest"?

> +
>  ARM/ARM64:
>  ^^^^^^^^^^
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index bf6e96011dfe..d8ef0d993e86 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>  #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>  #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>  #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
> +#define KVM_VCPUEVENT_TRIPLE_FAULT	0x00000020
>  
>  /* Interrupt shadow states */
>  #define KVM_X86_SHADOW_INT_MOV_SS	0x01
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4fa4d8269e5b..fee402a700df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4891,6 +4891,9 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  	if (vcpu->kvm->arch.exception_payload_enabled)
>  		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
>  
> +	if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> +		events->flags |= KVM_VCPUEVENT_TRIPLE_FAULT;
> +
>  	memset(&events->reserved, 0, sizeof(events->reserved));
>  }
>  
> @@ -4903,7 +4906,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
>  			      | KVM_VCPUEVENT_VALID_SHADOW
>  			      | KVM_VCPUEVENT_VALID_SMM
> -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
> +			      | KVM_VCPUEVENT_VALID_PAYLOAD
> +			      | KVM_VCPUEVENT_TRIPLE_FAULT))
>  		return -EINVAL;
>  
>  	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
> @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);

Looks correct, but this really needs a selftest, at least for the SET path since
the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
exit.

Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
window to intercept the request.

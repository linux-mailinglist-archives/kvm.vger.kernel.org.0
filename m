Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8792A4D50C5
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 18:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbiCJRoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 12:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiCJRoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 12:44:13 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65412D088
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:43:11 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v4so5939413pjh.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U2/1SQEW+tBxMVNWHvxV6hzm1CuOWDHQm+P5ss8iTBE=;
        b=bjyh/1bolV7ox6A8Wziq5hVMf1xAaOUWapyZlBPbiqWsied8s8+6Wthye5+WQw5zdE
         HA3YygMVSzq9LvkGLM2H/Hs8lZ6mEz4sr5MlQK3VgFo483M9luAMWyJv1s0/2AyQRu0K
         g1ywCYsoadyUunyNyc/nDSom8TW82eWtWU1ujxwbs3V+CS9Q3uALHpMRwKv0dSDLYUFr
         hDKNt0Fm5vXp7IK2UxaqgwAiPG3SB0IDKSuqxSmL220A5ahcSzDhPJYIf2Yito7f8Xfg
         gK/cTbGBuKXYJjAB3zV4e9E+b/FFDT1Vm7zBpQx5MaQ7nCOgLYugkKZJPRA5o1nR1Qcw
         7g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U2/1SQEW+tBxMVNWHvxV6hzm1CuOWDHQm+P5ss8iTBE=;
        b=gzurVKxM6eZfuJKpX5JrdBsJPPnwzkQ/fOM6P+CYRm/wNGMXq7DWxUi3VPmnV08MSD
         GoaWXnHAMpuvZ94x3d2LZsakBohZH2hSS4YadzeiVHY/1yHHWnQ4CXaPxo0ehKbaFzqk
         J+UIvYVrbZU/D+t3xj8TQ3ZHZTAB1hy3HBfNqpqRu7bZ4m0YSf0E1fO9uvwIi9WJrgZh
         64DWe35hJMapjpzi3DVlHZzm5Zj3ASkfN5jf8jOBwu6JvdP+rMK1vu1Jed4I5IqE3RpG
         xTKNw2dunCsFL+oFLbI12kOfB5Hp2XnfhDiqWJTXSlOJ6kdADAEcq+5oDmFaG938hIbf
         Gv4Q==
X-Gm-Message-State: AOAM533HfWziZCKikqBn0Eg/u81hujCfVQezSS0z4a0ptuKUVhemNjZv
        FJUifkTjDtD5HW9K7DPiRK/V6XsTO9WJNA==
X-Google-Smtp-Source: ABdhPJw2CevXJ/wrierohIkyDHBh7k6yZIbqg2kCUxcIvk+7QecPx8bwKXjgdvrIxWWcZtJDoZY3lw==
X-Received: by 2002:a17:902:d48a:b0:151:dd60:4177 with SMTP id c10-20020a170902d48a00b00151dd604177mr6296689plg.2.1646934190890;
        Thu, 10 Mar 2022 09:43:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5-20020a056a001a4500b004f731e23491sm8196301pfv.7.2022.03.10.09.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 09:43:10 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:43:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: X86: Extend KVM_SET_VCPU_EVENTS to inject a
 SHUTDOWN event
Message-ID: <Yio4qknizH25MBkP@google.com>
References: <20220310084001.10235-1-chenyi.qiang@intel.com>
 <20220310084001.10235-2-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310084001.10235-2-chenyi.qiang@intel.com>
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

On Thu, Mar 10, 2022, Chenyi Qiang wrote:
> In some fatal case, the target vcpu would run into unexpected behavior
> and should get shutdown (e.g. VM context is corrupted and not valid in
> VMCS). User space would be informed in such case. To kill the target
> vcpu, extend KVM_SET_VCPU_EVENTS ioctl to inject a synthesized SHUTDOWN
> event with a new bit set in flags field. KVM would accordingly make
> KVM_REQ_TRIPLE_FAULT request to trigger the real shutdown exit. Noting
> that the KVM_REQ_TRIPLE_FAULT request also applies to the nested case,
> so that only the target L2 vcpu would be killed.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  Documentation/virt/kvm/api.rst  | 3 +++
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/x86.c              | 6 +++++-
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 691ff84444bd..d1971ef613e7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1241,6 +1241,9 @@ can be set in the flags field to signal that the
>  exception_has_payload, exception_payload, and exception.pending fields
>  contain a valid state and shall be written into the VCPU.
>  
> +KVM_VCPUEVENT_SHUTDOWN can be set in flags field to synthesize a SHUTDOWN
> +event for a vcpu from user space.
> +
>  ARM/ARM64:
>  ^^^^^^^^^^
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index bf6e96011dfe..44757bd6122d 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>  #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>  #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>  #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
> +#define KVM_VCPUEVENT_SHUTDOWN		0x00000020
>  
>  /* Interrupt shadow states */
>  #define KVM_X86_SHADOW_INT_MOV_SS	0x01
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4fa4d8269e5b..53c8592066c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4903,7 +4903,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
>  			      | KVM_VCPUEVENT_VALID_SHADOW
>  			      | KVM_VCPUEVENT_VALID_SMM
> -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
> +			      | KVM_VCPUEVENT_VALID_PAYLOAD
> +			      | KVM_VCPUEVENT_SHUTDOWN))
>  		return -EINVAL;
>  
>  	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
> @@ -4976,6 +4977,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> +	if (events->flags & KVM_VCPUEVENT_SHUTDOWN)
> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);

Huh.  I think we need to make this bidirection and add it to get_vcpu_events()
as well, and treat it as a bug fix.  In direct triple fault cases, i.e. hardware
detected and morphed to VM-Exit, KVM will never lose the triple fault.  But for
triple faults sythesized by KVM, e.g. the RSM path or nested_vmx_abort(), if KVM
exits to userspace before the request is serviced, userspace could migrate the
VM and lose the triple fault.

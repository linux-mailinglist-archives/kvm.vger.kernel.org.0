Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0024C2E52
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiBXOYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiBXOXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:23:47 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54F41637CE;
        Thu, 24 Feb 2022 06:23:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q17so3086142edd.4;
        Thu, 24 Feb 2022 06:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7auIWEJM6MC8ScpEmtv1C4E/fqB/KIkHM2nvPFKd6is=;
        b=fLGvRvN1ISGysrGJQmdl7pQ/3vIpgylLRYVvIU9WbfeP/Z/gaAwPvmRzTuh3bDBcYs
         9Qn4cwkSl5uja3X0Zde9CNJVlhtmBxUh67zsrKpaWMhTkv/rJjjvbvfbOPt1SgIHabMO
         Aq9HDezf7wGyCUlS72Vm4beMvbbqvminJi7/xzTQwmA+MG3PmepPEw8Uo2s3vUOhVci0
         QAhSIhTH8rE7cb0T18qhmu1Q7t+P0FHgiy1R+un+HB9TzdbWFJ3uwkyq4Y8d/6eyxHwg
         FHoCIIanhpJhucybHC0iIPniWnyQk8jOhwwUGNuv49V72vsTmJcrXkuoJ3OCkxODxYCi
         J7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7auIWEJM6MC8ScpEmtv1C4E/fqB/KIkHM2nvPFKd6is=;
        b=yHom/00BsQxmyFSo/m3DGD6YRa1hMvkXbGBzJPIyS3nTWWEJMkJ/vwZDwvcJY1/C8t
         PG1NEa7D9ykMuH+jMcSmIYRjRLQREIkeNBGwqm29JSbVWHQUBYB9hrC2HT/NEhPjODu+
         XTt5Z3Nzt3lkUp4AtTYhChqm9mViR5pYLlp5eHH+CZuhy2VuQnmv9edlM1EgLr7Z/hgT
         vlCBwGrcbgtIeuxJQ31OHhcDJWZ1ZSUYYcBVmahcPBfcXIUWmS3nUELd91Mogh2whM5h
         BVR6CgLM3A54MEl7ILwJ52L4DNHoXTVNt0PVYl9CUGIuj4wc8r2RmKOYzVY91LaOLl7J
         2UWw==
X-Gm-Message-State: AOAM531ztBHCYY6r+TeHed+JjRvdaIr1m8mx7CcKBgghQ+33++l/UO4u
        KVcdORYPb0knnquLEoABrF4=
X-Google-Smtp-Source: ABdhPJzDqdEuS1bbYLjr5rMNEoHcI3kLnIyJYrCsWsHZa4hdnXcj+uoj5Z+K9ploCv9Nlqc9oDWDOw==
X-Received: by 2002:aa7:c3d5:0:b0:40f:b885:8051 with SMTP id l21-20020aa7c3d5000000b0040fb8858051mr2569264edr.395.1645712595524;
        Thu, 24 Feb 2022 06:23:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id jz17sm1402326ejb.195.2022.02.24.06.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:23:14 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4ce5ed1c-78e5-8150-65cd-288f1023c7a0@redhat.com>
Date:   Thu, 24 Feb 2022 15:23:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Fix pointer mistmatch warning when patching
 RET0 static calls
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220223162355.3174907-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220223162355.3174907-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 17:23, Sean Christopherson wrote:
> Cast kvm_x86_ops.func to 'void *' when updating KVM static calls that are
> conditionally patched to __static_call_return0().  clang complains about
> using mismatching pointers in the ternary operator, which breaks the
> build when compiling with CONFIG_KVM_WERROR=y.
> 
>    >> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch
>    ('bool (*)(struct kvm_vcpu *)' and 'void *') [-Wpointer-type-mismatch]
> 
> Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> Reported-by: Like Xu <like.xu.linux@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 713e08f62385..f285ddb8b66b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1547,8 +1547,8 @@ static inline void kvm_ops_static_call_update(void)
>   	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
>   #define KVM_X86_OP_OPTIONAL __KVM_X86_OP
>   #define KVM_X86_OP_OPTIONAL_RET0(func) \
> -	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
> -			   (void *) __static_call_return0);
> +	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
> +					   (void *)__static_call_return0);
>   #include <asm/kvm-x86-ops.h>
>   #undef __KVM_X86_OP
>   }
> 
> base-commit: f4bc051fc91ab9f1d5225d94e52d369ef58bec58

Queued, thanks.

Paolo

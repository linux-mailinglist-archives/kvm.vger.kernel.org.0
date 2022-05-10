Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909FC52204B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiEJQAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347915AbiEJP6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:58:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18746222B;
        Tue, 10 May 2022 08:51:19 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 129so10460923wmz.0;
        Tue, 10 May 2022 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U+dHyajQd3anp7nv4LUi4+uXP3c9J/d9icW+Cpa8Rx4=;
        b=EEGksnPVQEfnXlXJ573PuMx7zIkoG9RPGI75mioecwCn0quJVydceHRLuVAPAglCDC
         4m8XBMTqla3/duWHi1hoWgO7ryels3JZp1IUmSJRSIUW/Yc7WDbWYHp9IZlyjHWcKvtV
         pT7XUIS3cMnbLZmq4gr0jiSri/LqRkauMyoiY6drqG+0kjSrBpoJ1VXn6QvJsPLJ2M77
         yMvr2TPVoBgelPxURlLgtnr02zYEryA4d42mM0f59kzEQ3SVs1BcGMPiWR4j072nizW1
         ELDOoVpHmmUEDTl4KB++D1QIA/AAcpZIa/w/CGHBOQJZN0/PSCT67OCAAkiN93xvvTqQ
         lxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U+dHyajQd3anp7nv4LUi4+uXP3c9J/d9icW+Cpa8Rx4=;
        b=pH1UAAqtlW/MGimuVlPeT/3JjIefzJTDZ9abplYLeqcCqPVO/sUqzt7T6O6cYjYfYF
         c8uIvO2g2v+eRzGXYXoJGeMuwt7jn7fjLSXrRaZwi45lQK5BCXT9vTECF8kcZn305s7L
         RF0EhJ1DApae9TyKmX1X7rDCf61PXIi7c9UK+S83iEfW2A+5+8PKl71o/d5bV41JZFaJ
         OCMRyDHyZ8XJrRa61lvjb9EQQZypf2UflXR894l9MGZly71kjAvYpnDD/aio3nnIEaZU
         6A9CBJ6M8z66OanS6ei37NJ+KuM2FgU21RTX97T2DGMndro5MMUaL5Ah449zOQZVqtLT
         /5wA==
X-Gm-Message-State: AOAM531wUdbfGiN8NxJZsKTmZnxXq4APr0SseX9fvkXZaE67h008t/mR
        hxWMoB2yeiQXAIoGCBZl7QQ=
X-Google-Smtp-Source: ABdhPJw5U56ogAboldiGwx8gv9uCorZH3h5VqTSJ4hH1zxOniYl+KRYnnfpeHCWmokLOV7neyZx2hw==
X-Received: by 2002:a05:600c:4f15:b0:394:8ea0:bb45 with SMTP id l21-20020a05600c4f1500b003948ea0bb45mr634056wmq.206.1652197872914;
        Tue, 10 May 2022 08:51:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id o6-20020adfe806000000b0020c5253d927sm13726740wrm.115.2022.05.10.08.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 08:51:12 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
Date:   Tue, 10 May 2022 17:51:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, jmattson@google.com,
        seanjc@google.com, kan.liang@linux.intel.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220506033305.5135-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 05:33, Yang Weijiang wrote:
> Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
> on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
> LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
> clear the bit when guest does warm reset.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d6ee9cf82f5..b38f58868905 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4593,6 +4593,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	if (!init_event) {
>   		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>   			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
> +	} else {
> +		flip_arch_lbr_ctl(vcpu, false);
>   	}
>   }
>   
> @@ -7704,6 +7706,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>   	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>   	vmx->nested.vmxon = false;
>   	vmx_clear_hlt(vcpu);
> +	flip_arch_lbr_ctl(vcpu, false);
>   	return 0;
>   }
>   
> @@ -7725,6 +7728,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>   		vmx->nested.nested_run_pending = 1;
>   		vmx->nested.smm.guest_mode = false;
>   	}
> +	flip_arch_lbr_ctl(vcpu, true);
>   	return 0;
>   }
>   

This is incorrect, you hare not saving/restoring the actual value of 
LBREn (which is "lbr_desc->event != NULL").  Therefore, a migration 
while in SMM would lose the value of LBREn = true.

Instead of using flip_arch_lbr_ctl, SMM should save the value of the MSR 
in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm 
(feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), i.e. 
the 32-bit case can be ignored).

Paolo

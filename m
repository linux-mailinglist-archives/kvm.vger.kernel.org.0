Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1F4DA52B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 23:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352157AbiCOWTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 18:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbiCOWTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 18:19:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD2D2D1DA;
        Tue, 15 Mar 2022 15:18:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x13so505908wrg.4;
        Tue, 15 Mar 2022 15:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ee8SRMPwnuVzIS2RQDv2rxgJJ6KdOOPHSiC+3OVAB5A=;
        b=gRoK1zE2dd7rBlGBzvjoSMlAZjOP9GPFKKeNkSh8wsuzFFOh6qs4IrEpaHRWol/7n4
         RTiA9CtF792wYOog6ElXRzlCVCaYJrwH5TuL1HxwWCvwDD0JJ8JQbY6OrLqdOe/Z7h86
         jfoG6fCyyPFpMqcwVXZSNXfP147oczxvpx1SosBQ+LUVl42g72Qfhm3R/CefhkuqTUdD
         YrZjKC7VdSwvlY/wmD8wC/P2FqWH3iYVtBSjj1x5t6aXg/7B/Ft99saclQiSDTI1HASf
         khpVqZ9wzfk+9qxh9kYko2LjWHJJ0TAq/61ho3h5qESmsDnLPlIrpSn/QZnyecXVJ7IE
         tx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ee8SRMPwnuVzIS2RQDv2rxgJJ6KdOOPHSiC+3OVAB5A=;
        b=1g/va7cIToqVW5ImfXD3HtEpz01cIHevSuQTSQK94wllVuwxTItgKlBTdshSFc1syw
         kYjHvJswUpPPCLvp0OY+rcE8plSKUNThC02nzHNEUVyvDE4/RMHdhXj99z6prlfJns3H
         b6YEajG8HCZSIQsiEkydO0HtClmE/fHoCFupjq9GuaVWOKr5YI+QAojb3Ry7vajZqgKi
         +esA7iTbNbgwYTqk96sQQHA5o+FiahpbDPULTnTP9WLrIKUZA7g0TJBSJvfzH2/Xyjgn
         1ycUboyZXWwEqci8Bfw4pPD9XEkW922dLwUvSz5+g2d3lFFo9YPBul1jmGpcM9cv6Weq
         AEFQ==
X-Gm-Message-State: AOAM530RY09hIPnV7shYcrsVydDSciKMa5xL96o1HleGVxlpufabJfWT
        OhgoA+axxbSqccmIK9TuroE=
X-Google-Smtp-Source: ABdhPJyyvrxwXMm5Bp+XvNsYD7xBXcfEyg/WzcB3qlhMdMdCZX2z6D3kMmtLDtZc15jfFPCnyNfjOg==
X-Received: by 2002:adf:df01:0:b0:203:d6f0:794b with SMTP id y1-20020adfdf01000000b00203d6f0794bmr3515540wrl.394.1647382708631;
        Tue, 15 Mar 2022 15:18:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e2-20020adfe7c2000000b001f04d622e7fsm161981wrn.39.2022.03.15.15.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 15:18:28 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8968615c-4ef2-49b9-77eb-82d580259a9c@redhat.com>
Date:   Tue, 15 Mar 2022 23:18:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/2] KVM: x86/emulator: Emulate RDPID only if it is
 enabled in guest
Content-Language: en-US
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <2b2774154f7532c96a6f04d71c82a8bec7d9e80b.1646655860.git.houwenlong.hwl@antgroup.com>
 <45a2dbcbf694c48f1fb6a834a0f97a36a226a172.1646655860.git.houwenlong.hwl@antgroup.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <45a2dbcbf694c48f1fb6a834a0f97a36a226a172.1646655860.git.houwenlong.hwl@antgroup.com>
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

On 3/7/22 13:26, Hou Wenlong wrote:
> When RDTSCP is supported but RDPID is not supported in host,
> RDPID emulation is available. However, __kvm_get_msr() would
> only fail when RDTSCP/RDPID both are disabled in guest, so
> the emulator wouldn't inject a #UD when RDPID is disabled but
> RDTSCP is enabled in guest.
> 
> Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>   arch/x86/kvm/emulate.c     | 4 +++-
>   arch/x86/kvm/kvm_emulate.h | 1 +
>   arch/x86/kvm/x86.c         | 6 ++++++
>   3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 3497a35bd085..be83c9c8482d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3521,8 +3521,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
>   {
>   	u64 tsc_aux = 0;
>   
> -	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
> +	if (!ctxt->ops->guest_has_rdpid(ctxt))
>   		return emulate_ud(ctxt);
> +
> +	ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux);
>   	ctxt->dst.val = tsc_aux;
>   	return X86EMUL_CONTINUE;
>   }
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 29ac5a9679e5..1cbd46cf71f9 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -228,6 +228,7 @@ struct x86_emulate_ops {
>   	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
>   	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
>   	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
> +	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
>   
>   	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 09c5677f4186..44f97038d3e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7723,6 +7723,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
>   	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
>   }
>   
> +static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
> +{
> +	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
> +}
> +
>   static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
>   {
>   	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
> @@ -7807,6 +7812,7 @@ static const struct x86_emulate_ops emulate_ops = {
>   	.guest_has_long_mode = emulator_guest_has_long_mode,
>   	.guest_has_movbe     = emulator_guest_has_movbe,
>   	.guest_has_fxsr      = emulator_guest_has_fxsr,
> +	.guest_has_rdpid     = emulator_guest_has_rdpid,
>   	.set_nmi_mask        = emulator_set_nmi_mask,
>   	.get_hflags          = emulator_get_hflags,
>   	.exiting_smm         = emulator_exiting_smm,

Queued, thanks.

Would you try replacing the ->guest_has_... callbacks with just one that 
takes an X86_FEATURE_* constant as a second argument?

Paolo

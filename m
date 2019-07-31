Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC93F7C313
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 15:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbfGaNPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 09:15:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43549 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfGaNO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 09:14:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so69611363wru.10
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 06:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2qO4ZtAFEjGbhKpZYZIrICeNvO6yrVyniiCc6Rw+4tA=;
        b=eMR9kuu+hRA/UzZ8JjL1CcRrYVQT3qTNIUkO8XBNZP4/l6bn4SgsKl56rSBBPBcK3H
         Hyn2OrYEvWMaVZ1K+ZV55ODBvezCecTMCozUnsCdY1oaW7mQ0xMvb243BSrPuywd6f8+
         6jbzOf1wtQdUtDecSTZ8HAyReoEk/49vtKpDYEhVW9n3ppy0knA6733x4KItyesKZj9J
         wpg0SSI22lu984adwdAZzvjrFJ7486drnN5aLmhJ1pyxhG40NfcL1brscjxaq6CEzHRt
         NXKNgKTSuhCRIvBlQ0ythytTl+AEZFUbLJhacfve6rCOPoPmKAEmcv1Zh/8ou/EQho3m
         jJxw==
X-Gm-Message-State: APjAAAWhMZFO7gt8Z9HDrJjJzHkaCxEfJ+6tx3XwHtYsv15trQJ08hnp
        TVphGI85Y4hurdyMGShoiRnbjg==
X-Google-Smtp-Source: APXvYqxYCllhTfncAoR1iIV4Cdz6EoShZ6pM0+LLTCU1P8Ot61fd3+4nd92y4hrwUv/3eSz8q1Pp5g==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr136812839wru.141.1564578895964;
        Wed, 31 Jul 2019 06:14:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id t63sm61935053wmt.6.2019.07.31.06.14.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 06:14:55 -0700 (PDT)
Subject: Re: [PATCH RFC 4/5] x86: KVM: add xsetbv to the emulator
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
 <20190620110240.25799-5-vkuznets@redhat.com>
 <a86ca8b7-0333-398b-7bf6-90cb79366226@redhat.com>
 <87lfwe73oz.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <73e6ddee-5ca9-64ea-d8d3-fabe046691fd@redhat.com>
Date:   Wed, 31 Jul 2019 15:14:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87lfwe73oz.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 15:07, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 20/06/19 13:02, Vitaly Kuznetsov wrote:
>>> To avoid hardcoding xsetbv length to '3' we need to support decoding it in
>>> the emulator.
>>>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> Can you also emulate it properly?  The code from QEMU's
>> target/i386/fpu_helper.c can help. :)
>>
> 
> (Had a chance to get back to this just now, sorry)
> 
> Assuming __kvm_set_xcr() is also a correct implementation, would the
> code below do the job? (Just trying to figure out why you suggested
> me to take a look at QEMU's variant):
> 

Yes, I didn't remember __kvm_set_xcr.

Paolo

> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index feab24cac610..77cf6c11f66b 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -229,7 +229,7 @@ struct x86_emulate_ops {
>  	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
>  			     const char *smstate);
>  	void (*post_leave_smm)(struct x86_emulate_ctxt *ctxt);
> -
> +	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
>  };
>  
>  typedef u32 __attribute__((vector_size(16))) sse128_t;
> @@ -429,6 +429,7 @@ enum x86_intercept {
>  	x86_intercept_ins,
>  	x86_intercept_out,
>  	x86_intercept_outs,
> +	x86_intercept_xsetbv,
>  
>  	nr_x86_intercepts
>  };
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 718f7d9afedc..f9e843dd992a 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4156,6 +4156,20 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
>  	return rc;
>  }
>  
> +static int em_xsetbv(struct x86_emulate_ctxt *ctxt)
> +{
> +	u32 eax, ecx, edx;
> +
> +	eax = reg_read(ctxt, VCPU_REGS_RAX);
> +	edx = reg_read(ctxt, VCPU_REGS_RDX);
> +	ecx = reg_read(ctxt, VCPU_REGS_RCX);
> +
> +	if (ctxt->ops->set_xcr(ctxt, ecx, ((u64)edx << 32) | eax))
> +		return emulate_gp(ctxt, 0);
> +
> +	return X86EMUL_CONTINUE;
> +}
> +
>  static bool valid_cr(int nr)
>  {
>  	switch (nr) {
> @@ -4409,6 +4423,12 @@ static const struct opcode group7_rm1[] = {
>  	N, N, N, N, N, N,
>  };
>  
> +static const struct opcode group7_rm2[] = {
> +	N,
> +	II(ImplicitOps | Priv,			em_xsetbv,	xsetbv),
> +	N, N, N, N, N, N,
> +};
> +
>  static const struct opcode group7_rm3[] = {
>  	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
>  	II(SrcNone  | Prot | EmulateOnUD,	em_hypercall,	vmmcall),
> @@ -4498,7 +4518,8 @@ static const struct group_dual group7 = { {
>  }, {
>  	EXT(0, group7_rm0),
>  	EXT(0, group7_rm1),
> -	N, EXT(0, group7_rm3),
> +	EXT(0, group7_rm2),
> +	EXT(0, group7_rm3),
>  	II(SrcNone | DstMem | Mov,		em_smsw, smsw), N,
>  	II(SrcMem16 | Mov | Priv,		em_lmsw, lmsw),
>  	EXT(0, group7_rm7),
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6d951cbd76c..9512cc38dfe9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6068,6 +6068,11 @@ static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
>  	kvm_smm_changed(emul_to_vcpu(ctxt));
>  }
>  
> +static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
> +{
> +	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
> +}
> +
>  static const struct x86_emulate_ops emulate_ops = {
>  	.read_gpr            = emulator_read_gpr,
>  	.write_gpr           = emulator_write_gpr,
> @@ -6109,6 +6114,7 @@ static const struct x86_emulate_ops emulate_ops = {
>  	.set_hflags          = emulator_set_hflags,
>  	.pre_leave_smm       = emulator_pre_leave_smm,
>  	.post_leave_smm      = emulator_post_leave_smm,
> +	.set_xcr             = emulator_set_xcr,
>  };
>  
>  static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
> 


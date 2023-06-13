Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDBB72E36F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 14:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242077AbjFMM4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240639AbjFMM4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 08:56:39 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D781734;
        Tue, 13 Jun 2023 05:56:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f644dffd71so6796103e87.1;
        Tue, 13 Jun 2023 05:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686660996; x=1689252996;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WICqJH+RY9rL2TO+4voHx0nD9gL2WvHqo9ICGl9Zhr8=;
        b=prNplwdsTxvCbTHswX7EviFH0PzuEuI8aCS0FYz3Q8nBx+uf0jbyzCubpHiNpgI8YK
         74LRt03Y1AZUmdFTCD3IIwvsxHtUIOscldibGwXtSiJSwSJqr0xCNe5vBQ9IYT/LHffQ
         lgmtWbOlq9e/BUEYYRri9eBE2XtabjvFdr7E1Wuv0iS8l1RxwCUfCZupmvAS/Z9NG7kg
         BuAucJ6xsNbK4u/jJ/y/F0r+BtIeYHYTBO/UIwBa3fkflPj1fVK3Ie5gyeIvDBezlPTa
         qDg2geE3HSafLmzbr3FxpiJpWK70NVi/vcX9xw5XyO/AEgMrOGjt3qQFEGPdqMLoEyy9
         S1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686660996; x=1689252996;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WICqJH+RY9rL2TO+4voHx0nD9gL2WvHqo9ICGl9Zhr8=;
        b=ezu1EfNAfQ9PZ5Y6daFievPdEzrSGladU4dFZgXkRPAJhzLDu0MdRLruRwuHw3qR2P
         DUjAFAMz9OGa2Cz6FIGIaAdn05vUFHyqc1iTQnEVMaoCr5POEP14JcNt9kbxMpVkFXc7
         cUDJxpylB4mvuv1XhZmjpmMlUvZKCHzRIZkZnbEzTWT7IYlVOkpiM2nJ8+ZGVtCWC5+I
         jxInQYf62H8iJkpeKKQUZfH0EtoLi2MZf8R/5NgSUYHHkLTF488qAuQefHRJQhqj8aDW
         kTjFUj1UVO50W6RgzHXljpe+zElIarQDW555GpxGPZBOcCnmDvlOPaNoZkXDUDfy675E
         /X6g==
X-Gm-Message-State: AC+VfDyM8qyWY4DE5XC6WABbgm2dip6wfxjWGkekD4OqFmpTQF42ng9g
        yo4M1npih0mhiHXAFwIv3NM=
X-Google-Smtp-Source: ACHHUZ4eDjiZq+6LCo3PUb6iG1hsZFF9yaGP1ilxp8FzBDDkMmIdJLrioYFr0dES8PbQ+b99/PRoFg==
X-Received: by 2002:ac2:46ec:0:b0:4f3:a820:dd98 with SMTP id q12-20020ac246ec000000b004f3a820dd98mr6097106lfo.7.1686660996264;
        Tue, 13 Jun 2023 05:56:36 -0700 (PDT)
Received: from ?IPV6:2a0b:6204:4302:5f00:4dab:3483:4506:9a0e? ([2a0b:6204:4302:5f00:4dab:3483:4506:9a0e])
        by smtp.gmail.com with ESMTPSA id u1-20020ac248a1000000b004eaf41933a4sm1773998lfg.59.2023.06.13.05.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 05:56:35 -0700 (PDT)
From:   "bibo, mao" <bibo.mao@gmail.com>
X-Google-Original-From: "bibo, mao" <maobibo@loongson.cn>
Message-ID: <b55f4665-1e2b-30fe-fb29-ae8856227275@loongson.cn>
Date:   Tue, 13 Jun 2023 20:56:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v13 08/30] LoongArch: KVM: Implement vcpu handle exit
 interface
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
 <20230609090832.2131037-9-zhaotianrui@loongson.cn>
In-Reply-To: <20230609090832.2131037-9-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo Mao <maobibo@loongson.cn>

Regards
Bibo, Mao

在 2023/6/9 17:08, Tianrui Zhao 写道:
> Implement vcpu handle exit interface, getting the exit code by ESTAT
> register and using kvm exception vector to handle it.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/kvm/vcpu.c | 45 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index eba5c07b8be3..a45e9d9efe5b 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -52,6 +52,51 @@ static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>   	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
>   }
>   
> +/*
> + * Return 1 for resume guest and "<= 0" for resume host.
> + */
> +static int _kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exst = vcpu->arch.host_estat;
> +	u32 intr = exst & 0x1fff; /* ignore NMI */
> +	u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
> +	int ret = RESUME_GUEST;
> +
> +	vcpu->mode = OUTSIDE_GUEST_MODE;
> +
> +	/* Set a default exit reason */
> +	run->exit_reason = KVM_EXIT_UNKNOWN;
> +
> +	local_irq_enable();
> +	guest_state_exit_irqoff();
> +
> +	trace_kvm_exit(vcpu, exccode);
> +	if (exccode) {
> +		ret = _kvm_handle_fault(vcpu, exccode);
> +	} else {
> +		WARN(!intr, "vm exiting with suspicious irq\n");
> +		++vcpu->stat.int_exits;
> +	}
> +
> +	cond_resched();
> +	local_irq_disable();
> +
> +	if (ret == RESUME_HOST)
> +		return ret;
> +
> +	/* Only check for signals if not already exiting to userspace */
> +	if (signal_pending(current)) {
> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> +		++vcpu->stat.signal_exits;
> +		return -EINTR;
> +	}
> +
> +	kvm_pre_enter_guest(vcpu);
> +	trace_kvm_reenter(vcpu);
> +	guest_state_enter_irqoff();
> +	return RESUME_GUEST;
> +}
> +
>   int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long timer_hz;

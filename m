Return-Path: <kvm+bounces-4037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74CD080C900
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 13:06:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4508B20FA4
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 12:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C6A38FB0;
	Mon, 11 Dec 2023 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YmOxTAcq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869881700
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 04:06:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1d04c097e34so33796975ad.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 04:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702296397; x=1702901197; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLveeWFyWywPQcnXkq0FjFrjO0zX9tcVjYAUuEsBwb0=;
        b=YmOxTAcqK0FNny52/JkbcqgFFqcJskLcSTeUqFfVV853S24CXA+OvwRTbjKye6gDqy
         qeyZwJ9Tn2l9Lzt8cvLv0itNgzGpv7zd5zYOdEpg+zkGrlRZz9RCQKrmcu0pOOpX1iqa
         zVUn3Zgc0iYh8/JEm3/6w6KIo0YKJcDcImVBWdL/o34Jxy4+PKNrh0fkDXkSJto7BgIg
         pkp8/M11C0lJURxCy9dMYHh2bpNp994hEJRegIwgrgtsNYcEyRyQ2oHv9YiJfz0LWEIP
         6b7FGBb2OA/NUJ7HqLF4UlfDI4/WZH8l5FfCJiIxhjaSqxhEXijzomgaztgALv4iJ3Uj
         6Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702296397; x=1702901197;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLveeWFyWywPQcnXkq0FjFrjO0zX9tcVjYAUuEsBwb0=;
        b=MoBZft2ys3Drj1PzQvDwl5ja8+D2BZ1guEz3gteXGmJtu5wxOqsp2Y77zxHs9s8soe
         UPA5M/GvGjVh6As0SIzO8jGBiWBy6BAQ89RTMLvlcgzqW8lR+UWh4830pOv9vKP9sO1e
         XQEkFWsTHVK2lZYNnRGHiCvmkXsXTHo/fJG91e15PHVjNj/VFz4U3SjTKoNzRWCVaF/x
         BlHtn2hurSG17DmPROqB92kRzw7t2jMMlEpCR1FaESKtkT0q7kEV0iV3Dq8I82vCplcY
         gsfE9co3rerjxoea27Tp/UldKIM7HZkntWX7WBPNXucyRCXCRRlH0T3cJ/Sy2A20RVIc
         C80Q==
X-Gm-Message-State: AOJu0YzUD6qdDOJv4nlUt8E4I3+/okBVHe/Vw51RUuwwacDmHUgza42+
	pWcOE9UOxpp7+6dWBZNBkbx8lexRAFBnMhogd9Q=
X-Google-Smtp-Source: AGHT+IEN2iF5dEYENST9QgKGVHqvG4TBX6hHbLpDgKXK7tr2X4/a4F+nPOUuJd9duYYI8Gxi87I8wg==
X-Received: by 2002:a17:903:41cf:b0:1c6:11ca:8861 with SMTP id u15-20020a17090341cf00b001c611ca8861mr5011983ple.21.1702296396903;
        Mon, 11 Dec 2023 04:06:36 -0800 (PST)
Received: from [192.168.68.110] ([152.234.124.8])
        by smtp.gmail.com with ESMTPSA id z18-20020a170902ee1200b001cf570b10dasm6511626plb.65.2023.12.11.04.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 04:06:36 -0800 (PST)
Message-ID: <94bcaa6d-fe18-4eed-b2d4-a6a5521230bf@ventanamicro.com>
Date: Mon, 11 Dec 2023 09:06:33 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: remove a redundant condition in
 kvm_arch_vcpu_ioctl_run()
Content-Language: en-US
To: Chao Du <duchao@eswincomputing.com>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, anup@brainfault.org, atishp@atishpatra.org
References: <20231211094014.4041-1-duchao@eswincomputing.com>
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20231211094014.4041-1-duchao@eswincomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/11/23 06:40, Chao Du wrote:
> The latest ret value is updated by kvm_riscv_vcpu_aia_update(),
> the loop will continue if the ret is less than or equal to zero.
> So the later condition will never hit. Thus remove it.

Good catch. There's another potential optimization to be done a little above
this change:


	while (ret > 0) {
		(...)

		/* Update AIA HW state before entering guest */
		ret = kvm_riscv_vcpu_aia_update(vcpu);
		if (ret <= 0) {
			preempt_enable();
			continue; <------------------
		}
		(...)

Note that this 'continue' isn't doing much - we'll restart the loop with ret <= 0
while requiring ret > 0 to do another iteration. I.e. this 'continue' can be
replaced for 'break' without compromising the logic.

(of course, testing it to be sure is always advised :D )

> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---


Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>


>   arch/riscv/kvm/vcpu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e087c809073c..bf3952d1a621 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -757,8 +757,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		/* Update HVIP CSR for current CPU */
>   		kvm_riscv_update_hvip(vcpu);
>   
> -		if (ret <= 0 ||
> -		    kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
> +		if (kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
>   		    kvm_request_pending(vcpu) ||
>   		    xfer_to_guest_mode_work_pending()) {
>   			vcpu->mode = OUTSIDE_GUEST_MODE;


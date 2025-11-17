Return-Path: <kvm+bounces-63357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F19C63CCC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C7BBE4EA156
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D83C31E0F7;
	Mon, 17 Nov 2025 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZlRkk9m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCE283FF9
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378791; cv=none; b=TdwDiLzNZ8WzzTWi+KsbKrZJ2SbTp8pXJXl3+WvJhm1yupqq/TqgrZvuP4X0OSkMecqZbSD/Q/PCHbr5fGrPIdqk9Vx6AXXInEvQ15YZCRxd0bfp2CrYl5AzaXCtW0bKCYpp2FY0DuWiOaRXMsVbFuDuOM2nOApfE9RH+6NSrZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378791; c=relaxed/simple;
	bh=/rhf9hmgiMKFdWRnE5GdTAp4asqaldwnLnA3FvpRkxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OpXKzEfjk327Ui0MakuTmnJgT6KUc0+y7HNNDOd582Ddtfro2cKQYXwTomH/trozKdRVnIUn9adRO7yTFZQ95bt3r1RUbeiqPJd7uugVhGHt2/YZUrhHsl9AZcidDnNk/N63+D0uWdkQZDOGHUiW18tpOqVauNKm81f7N434ALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yZlRkk9m; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4edb8d6e98aso673191cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 03:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763378789; x=1763983589; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=49ctbnqVDAwIBJX5k40l0vJpezvfhKgkxScmbFVG3vs=;
        b=yZlRkk9mOvRKCPRCxAqDXhMJ98xUYbOE8ooRdGY6wGXACZ9n0pkCzC4fMjT3ML9kjC
         xeb8ZIJpwyQmux2swxNnI/xw3e4DikiLHBaKpJQ7fijgEpFlDs7a9d8GEU/qNDpZ9zL7
         M2FCeCs/+/acnnxiKx/PpAQvXVRBRxi41OuUQAtriYXor/tz91PM8vdUZCQ0/UL7L4L4
         HxcYZH/yvMS83wuwE6so1xUcMNghZpj0T2Ba0qluTiBS8vF5KexBqQmI4HPSpv04x2VL
         FZPCjhp7dj7YhShRrnWZXNPlJ0WvpI8l3T7L526eUPhfoZB6mQTi5fZhDt/llyC7lfwu
         VtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763378789; x=1763983589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49ctbnqVDAwIBJX5k40l0vJpezvfhKgkxScmbFVG3vs=;
        b=Bj70qBteB1PdFfTwFAm5T5AG5hKa80w1e2K1tVLFat4Q5PDN2FAzsUtpo+WitwQoql
         j8fbq3KqEv2GYWDEZ2ycZDCZGU/bUqHHIt05F1kArtyRjw2KA5ZqiEM5n39YjthcafUF
         VxBdRlyUXtYLetgmswqqY+N/9WNY7NV7OmWvXmWgIaUuOdVehzS5xWliszVl7B58Jfm7
         mjfaRFxlrZ3aprBz+XzyWx0lWUqFvZPZgDf48HVzhh5AwZ8CnL+mQXIPqh/gc6uNY1Oh
         lKN1tucE9up7hoC5604WSzIs5V9nb0OFlmQmYws/nNmCRmqsKY01GwWwboMTdMfKz/L8
         +Vcw==
X-Forwarded-Encrypted: i=1; AJvYcCXGtg1FQ/8VDFwoEJrJ7SkWk9YP5JQq++JFTGxJMFIpaKSUJ6LNJy+IjFZPnXf+kpsY5MQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPjUxiArWHHkFKDy69IWPODrsD7BBi4fh0ricB9hg0TIOXWphp
	uVAG1sN8mGI/D+A6lO6/K8t+1OlM/yeByvvq3EyhQ0BbizsbPjzixr1id6vOohEjMEQvSpWi2lW
	D9trEu+33xfno0Kl9KQavQqfO25VWjAKVKQXKYzyY
X-Gm-Gg: ASbGncvu9UMPjjmF5fXDmkK3Yu1Ta1Fw7yNSGFfu7U8ocQdwVHtcMWAq9ANM9gKFNkF
	19sycOUgQed8QNXhCKX38wX0m2xhMd3Tjoanm0G26+V0l1WVBXl1vehsEZJ5PBDb26oJB8pNd0Y
	Syzdrj3riv2z7rEmHbt5Q7YRM/RVGhV4wnViqOVmnj5GH/Wep6lbJNHow7SnVLmRv7cA0Pw0Ifx
	v+OzsJanvWcpNCYwVmY6bhZvgH8oBLZL92i6Btd2oAAvbBPIS5Nt+eqx67DZWnQl17OpxBs8lfQ
	Cr+0sEUFw6pGm19x
X-Google-Smtp-Source: AGHT+IEioMYFsqCc/4jnG0fmbEwZ6LA1WtQ/uRrIvwVWDiUcLFKyLiTmWE933E92hMBlL3D5tgBe1zTgaGIOHcn1qNw=
X-Received: by 2002:a05:622a:1191:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4ee0279d624mr12602131cf.2.1763378788577; Mon, 17 Nov 2025
 03:26:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-5-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:25:52 +0000
X-Gm-Features: AWmQ_bmeFv51Sa8WTg6Ls1D8vjiLqQnByeUS2NLYDYoerk0mUC01snRaXzO25Vg
Message-ID: <CA+EHjTwEj_-tDvq2+2x9MxTom2yw7Rx0ZZg7XuBOWxFxBJ-n9Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: arm64: GICv3: Remove vgic_hcr workaround
 handling leftovers
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Nov 2025 at 09:20, Marc Zyngier <maz@kernel.org> wrote:
>
> There's a bizarre or'ing of a 0 with the guest's ICH_HCR_EL2's
> value, which is a leftover from the host workaround merging
> code. Just kill it.
>
> Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index bf37fd3198ba7..40f7a37e0685c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -323,10 +323,9 @@ static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
>                                         struct vgic_v3_cpu_if *s_cpu_if)
>  {
>         struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
> -       u64 val = 0;
>         int i;
>
> -       s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
> +       s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
>         s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
>         s_cpu_if->vgic_sre = host_if->vgic_sre;
>
> --
> 2.47.3
>
>


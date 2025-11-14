Return-Path: <kvm+bounces-63208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D21EC5D93A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36A234EC394
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 14:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA0C32470A;
	Fri, 14 Nov 2025 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MH3t1hp2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D29E320A38
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763130086; cv=none; b=AAsm9IQq/vqve0K1vV/YxWvQNlMIswG1bn3L08m5dT+Qp1DVbfQgQgRx4kkrz4jPgSDxLb4/7JLZQmSIZmWc49BhA4nKoBeGVX4uKY3WZ48fvbAcnEOYAVEeD0KyYTNIByXLXBuJWqTUL4ImoBiqzCoh+ue/QTsMpiLGaTaBN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763130086; c=relaxed/simple;
	bh=CRbKex889t15hNnEaJZ2L2WSxzJx+xzomjJ8renljCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/oZXRvcpj5FQzjObyuuPaw4cm3DeVzytUNzx0mFC/kwC0yy4uR2KgJ8uFmKS2T+zqXb4fs2rHNNIdQ9mEw96M8liKrDoB4UTOazy/XqUxC/dazW1k89CobcPVC1O8YcPLPc1JFzpmv20KIq366CweCJqE33MT1iekZXTYufoGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MH3t1hp2; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ede12521d4so298781cf.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 06:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763130083; x=1763734883; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iebc9wAbiB5E5IOqak411hyeSp97Jf8NhK9FIOstGQ4=;
        b=MH3t1hp25nh3VeAzi7vIWsyB3FV80OTcOyRErIs/uWAzRmCvjNz3elzW58gO1lkBxf
         u8BxPftE5D2AZGdTEe6CEFz/0FaLZP9H85xh/qSQTJV4t8X0qXisgfFmmTkkLjhGafOk
         bQcha5eDPL6vOSQfb4BKJv36zRBDn/3y/fX8Na9/AOh0Q6B5IMzzK79U++p7IC9EHPfK
         Vke55TwXRkINT/JCQ71FDj5UMEINETlA5hGi5VcSm0eVzGYkp9ofKfb4toP9DLoark2T
         Ad4VixExe67UNj3wNHK1J3zf+XX6KZhU/ygbyOLwib81FeOYNvxpwIdj2xuRFk0q9HMj
         dV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763130083; x=1763734883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iebc9wAbiB5E5IOqak411hyeSp97Jf8NhK9FIOstGQ4=;
        b=lTBQsQtGzbPT2UZsmTE1qlrjW4a8FwPxF0bHtU2fCvf3lIMovG+VJgedyeERDgoY7z
         eoaYVEGMxNSvXtapyls/+bM/AaX/6Qhx37KFF76LB6Iyu46837GrEikup2q57KMk0AVy
         hjJ0zozDM5uqYv37jhHU4jKxYaHr/GWBacQFiataflLqhlI8vbNNeWtWH4CnsLjk8ioX
         /xV+CCgBq7hqkfcsOs1j8BPAmUvhYGY1FpEdXv/p3f8IyOe94qr35t73ZPXrACIu/E4+
         AcADoSfR99T+MowvxI3DKNNAWqdM5kS+f/p58YQOaLmtZEFNErGdKJd828V7eMeoRFPg
         Uyvw==
X-Forwarded-Encrypted: i=1; AJvYcCUliEID4W5p4yCi0HgBxvr3yyCkvLZnqqNn6pE0gl3r2qacRPqbwgJRz1uvyLfuaZ59KIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqfM3wKQj1KxV7Ww3op61vkrvbIkDXTKp4sVSX3pf7XWbZzG6A
	yqCP8f4iHWrBe8vx0ajJB5VS0/C4chHIEiOq8LQMdvHfoYgIID1mXz9wz7A5vWpWCc0LM1U5GbC
	NpSNm7KYFNJRcAG9U3eBnI8eDeSP/v23UKk15TXg2
X-Gm-Gg: ASbGncsY7icVAMIOml3pwAn1hGqq48JQKmZ/ayDKmL3eMxsk/UxzSWEjFmUivEwzAwZ
	k469RSQbaabNnIYvff220rReefC3xqneoalhNxU0jl4i/IQxWJZ0Ne0qU/WnZNk+HT1Tw1BI+T6
	oQO/y2y8Db5KK3wtb7xrRodsKL9MuwASfoGJXd991amnSQu/BkmzmrlOCEuU+DoIyrNg55B0sDi
	V/Dlck6n5CoorLm0cAxzoAOA/tC/3FJ3ttFmwJpcDgCM9nam7sDA1XIcy1/ISeGyiMQ2QKN8b1R
	x7VlVTCrCBel52IO
X-Google-Smtp-Source: AGHT+IE5Oe19RaLFBsVRY5odgzBmRaaiSdzxsgMGjxiUojw4mI94n9CHnCtVAFThAGs6iI94m/QfSBQkFZ6pjRXMhQg=
X-Received: by 2002:ac8:580f:0:b0:4e5:7827:f4b9 with SMTP id
 d75a77b69052e-4edf47135camr5213031cf.3.1763130082793; Fri, 14 Nov 2025
 06:21:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109171619.1507205-1-maz@kernel.org> <20251109171619.1507205-30-maz@kernel.org>
In-Reply-To: <20251109171619.1507205-30-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 14 Nov 2025 14:20:46 +0000
X-Gm-Features: AWmQ_bkph9z6RWKdMnig0aZ2huiMgSjHMys0UY_nuIP5-xDzsPT50bNsv9UL6s8
Message-ID: <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
Subject: Re: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when
 interrupts overflow LR capacity
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 9 Nov 2025 at 17:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we are ready to handle deactivation through ICV_DIR_EL1,
> set the trap bit if we have active interrupts outside of the LRs.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 1026031f22ff9..26e17ed057f00 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
>                 ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
>         cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
>                 ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
> +
> +       /*
> +        * Note that we set the trap irrespective of EOIMode, as that
> +        * can change behind our back without any warning...
> +        */
> +       if (irqs_active_outside_lrs(als))
> +               cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
>  }

I just tested these patches as they are on kvmarm/next
2ea7215187c5759fc5d277280e3095b350ca6a50 ("Merge branch
'kvm-arm64/vgic-lr-overflow' into kvmarm/next"), without any
additional pKVM patches. I tried running it with pKVM (non-protected)
and with just plain nVHE. In both cases, I get a trap to EL2 (0x18)
when booting a non-protected guest, which triggers a bug in
handle_trap() arch/arm64/kvm/hyp/nvhe/hyp-main.c:706

This trap is happening because of setting this particular trap (TDIR).
Just removing this trap from vgic_v3_configure_hcr() from the ToT on
kvmarm/next boots fine.

I'm running this on QEMU with '-machine virt,gic-version=3 -cpu max'
and the kernel with 'kvm-arm.mode=protected' and with
'kvm-arm.mode=nvhe'.

Let me know if you need any more info or help testing.

Cheers,
/fuad


>  static bool lr_signals_eoi_mi(u64 lr_val)
> --
> 2.47.3
>
>


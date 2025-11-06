Return-Path: <kvm+bounces-62151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2227C39461
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 07:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68CDE3B3B03
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 06:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B88F27C842;
	Thu,  6 Nov 2025 06:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ivnu9Bnp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB63E1E1E1C
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762410675; cv=none; b=cgxNtmp9LPRD/CmapTBqbH6LDEQQxF1dUDY8WOk8hQsuQsWtQ8hUyY9fh/Z2XByHIYyLYI6gi8AovYfwSlkIQvc34UIWTbJCZjRpsAuUpq/lncshAZQ8gAAu59FRm/yCj50FutsPYVW87T1LZebbb6cj9NSNF+z2klDIl5c3ZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762410675; c=relaxed/simple;
	bh=mH++FUUWiNs6njLTnVHXr3I4PNEnL/QgVM/9ZKawPqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Unex9d6wuGYKCsFdoreciezjN1Rb2esc3JZGA0Gat5iS8ofHOw0Qs5B3783JuLkpjtVbLUtlVjjaQDZv9SbAynJg2LZpQJCm60FsFGVaRSXawd3Ptnfy81CE3dVeWXvr00F6jbCUWklokNBXA1QhNp4KG1XGWKXhu2kT9fxhxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ivnu9Bnp; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4330d2ea04eso1881515ab.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 22:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1762410673; x=1763015473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wsAqJo0NXbvMDfBjbCfB9v96+a4KboR1hex7uLJfTY=;
        b=ivnu9Bnpdyr6HD37ODXkMpI/1eJb/GLduZXZAtmwH4maRvFtZGukq+L/aqNDwcCZcR
         CDRlMNRNLcW1ilohUHxp2gUvQUczlGxW28OMddnXMMbyG/cdO0iVJzzMkgOGfzjPcSc8
         W3f/mZ4/SJimtpJube0n2sTeRCXGPMgdg6GIYVxp6lIZo2Aet6ecwtRDNI9wDXYmYAMI
         D81PaB9dKodIicfpCfJ3f7lUU/L7dSXmEEgUHUnfJeMsJSHdyOaIcLwbwcC26UPBVyM9
         rGP4GPk+fVwzA2pYixP6dGZa3ZhYJRZiXc1qwlOfWPgutGiRwfT5CQ3ewTZPi7Qw4a66
         JQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762410673; x=1763015473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wsAqJo0NXbvMDfBjbCfB9v96+a4KboR1hex7uLJfTY=;
        b=MF1qYJ+T5b536N9RgDJwGi5g3TVAKODiklAa60Nj6krhDGg0kYlU0aivH7gcImFWYu
         xUGi+e4OeZaR0KamCb6W8EtMQn4cYAWynLRkL2n9PgmcWt12x7wNE12OBh0Ca6DxGIcu
         SFoJ58hQocZYqI4XpJPWjHEhUakyCS8s4SIsyq5ilRmMRo6wiKfmEWtrpY1exeED+7qK
         jlpD0YjSnHEeGYBRyENgr0frnYgxWTat8fT+Hy9E2/xMeRQq6ONf1wbSMIUtHsRK5WgD
         c21qWKuLJqdbnhQy3Dy2OOjJDdgWkUFfQ55Hr2uHRZAzFco7F5gnDVG7wbe9WxAbcLHE
         As6w==
X-Forwarded-Encrypted: i=1; AJvYcCXHybuWKzLf9qS/+OSZFXy9tSzqUMqmSfkC/OwrMfs3Rxc9x/MPke+1bH2Cidf8zEiBShw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKNtyN7C2X8w2PXJI5ePf3UyizvAbiJpklQMw6J4Lr7ESUc1pF
	+pBYM4PLpihmOGOhqL2S3jUpGuQl8wlEPvVxJylMrbH3d5VFjA2Hdcs4Fs3EMIgGObspO8FS7SJ
	vfYik11EoTMspSkkXURgHBlGyo3Jl7T05Kz7rHLgCgw==
X-Gm-Gg: ASbGncs2BRUghM6EhPO3yIpLbhAjTRhIjFIasrW6mRpQ8q2dlMlKaEHN4ywhlaGe3Yu
	5azhfZyD3HXXzpsW8/Q7f5mgdsn7BNc9XSZEO0D64IFeixmex8XmzFjUNo7M2Qjy8Pu/mrw1M/x
	b3V+c1vzr7CIr28JBMQjoVbT5ruo5R4lpG01S5ATzTA921jB74X5BhPh4JpAsqK2Q/vmEvKas+z
	DX8ofG7k+fu2ey2jdRN1w1tc3aXyPEKocivUVIdWDXhDZRnNzU3wyoQ3pQwhdxr0JAJijWjTSyN
	phIRx3o=
X-Google-Smtp-Source: AGHT+IE62i5hdnOw1tkRcQojVd9lPnQXpVgG5xN5CqCFTDG7bifDDZ9QHqo5x/eJro/G00X8hkfIC+3pZrHlhszwkJs=
X-Received: by 2002:a05:6e02:3087:b0:433:2fa2:a558 with SMTP id
 e9e14a558f8ab-43340789f0cmr86438485ab.9.1762410672706; Wed, 05 Nov 2025
 22:31:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918073927.403410-1-qiaozhe@iscas.ac.cn>
In-Reply-To: <20250918073927.403410-1-qiaozhe@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 6 Nov 2025 12:01:01 +0530
X-Gm-Features: AWmQ_bnVS73erzCQONrC7p_TFgCPBgKI27B4YWN1vAUbG-ECAIYJMH0uCmATp_w
Message-ID: <CAAhSdy2asCgoU+2q2wTQVCMD+LvdQjhJSbKUc-yRaGqmHnQoLQ@mail.gmail.com>
Subject: Re: [PATCH] RISCV: KVM: Add support for userspace to suspend a vCPU
To: Zhe Qiao <qiaozhe@iscas.ac.cn>
Cc: atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 1:09=E2=80=AFPM Zhe Qiao <qiaozhe@iscas.ac.cn> wrot=
e:
>
> Add RISC-V architecture support for the KVM_MP_STATE_SUSPENDED vCPU
> state, indicating that a vCPU is in suspended mode. While suspended,
> the vCPU will block execution until a wakeup event is detected.

There is no clear use-case why KVM user-space would put a VCPU in
suspended state while it is running.

>
> Introduce a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to notify

As the name suggests, the KVM_SYSTEM_EVENT_WAKEUP is for
system-level (or vm-level) wake-up and not VCPU-level wake-up.

> userspace when KVM has recognized such a wakeup event. It is then
> userspace=E2=80=99s responsibility to either make the vCPU runnable again=
 or
> keep it suspended until the next wakeup event occurs.
>
> Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
> ---
>  arch/riscv/include/asm/kvm_host.h |  2 ++
>  arch/riscv/kvm/vcpu.c             | 37 +++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index d71d3299a335..dbc6391407ae 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -43,6 +43,8 @@
>  #define KVM_REQ_HFENCE                 \
>         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> +#define KVM_REQ_SUSPEND                \
> +       KVM_ARCH_REQ_FLAGS(7, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3ebcfffaa978..0881c78476b1 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -496,6 +496,18 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu =
*vcpu,
>         return 0;
>  }
>
> +static void kvm_riscv_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_SUSPENDED);
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +       kvm_vcpu_kick(vcpu);
> +}
> +
> +static bool kvm_riscv_vcpu_suspended(struct kvm_vcpu *vcpu)
> +{
> +       return READ_ONCE(vcpu->arch.mp_state.mp_state) =3D=3D KVM_MP_STAT=
E_SUSPENDED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> @@ -516,6 +528,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *=
vcpu,
>                 else
>                         ret =3D -EINVAL;
>                 break;
> +       case KVM_MP_STATE_SUSPENDED:
> +               kvm_riscv_vcpu_suspend(vcpu);
> +               break;
>         default:
>                 ret =3D -EINVAL;
>         }
> @@ -682,6 +697,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         }
>  }
>
> +static int kvm_riscv_handle_suspend(struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_riscv_vcpu_suspended(vcpu))
> +               return 1;
> +
> +       kvm_riscv_vcpu_wfi(vcpu);
> +
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +
> +       if (kvm_arch_vcpu_runnable(vcpu)) {
> +               memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->sys=
tem_event));
> +               vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_WAKEUP;
> +               vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
> +               return 0;
> +       }
> +
> +       return 1;
> +}
> +
>  /**
>   * kvm_riscv_check_vcpu_requests - check and handle pending vCPU request=
s
>   * @vcpu:      the VCPU pointer
> @@ -731,6 +765,9 @@ static int kvm_riscv_check_vcpu_requests(struct kvm_v=
cpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
>                         kvm_riscv_vcpu_record_steal_time(vcpu);
>
> +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> +                       kvm_riscv_handle_suspend(vcpu);

Why ignore the return value of kvm_riscv_handle_suspend() ?

> +
>                 if (kvm_dirty_ring_check_request(vcpu))
>                         return 0;
>         }
> --
> 2.43.0
>

Regards,
Anup


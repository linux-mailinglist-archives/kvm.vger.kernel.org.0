Return-Path: <kvm+bounces-28419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6636D99853A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 13:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02F802818BE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0528B1C3F03;
	Thu, 10 Oct 2024 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="SYpBSO9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5DB1C245C
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728560517; cv=none; b=s+b8MKaGpNbnKh4escCSa6pfjEouEH1r6P6adU5I8fX/nzUb+L92b8fw9Pxc+4l/asQM3mm9eBPqQ8G40Dmos+yuXhbV3I07GmDeNW/6I+Bl4uYuewAwgB3Pp8nF57UoOu2qfDkiY+smI5MCJNWc460HME4jzzASsw87KMFQk88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728560517; c=relaxed/simple;
	bh=cD3n/uf1r9a2FxmfN8WSucBewvCmKvnyhsZqZXLZ0mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBCKP0zpCrYKHwVwPDljzlpU4HhrrFelFsa70qgzQH7nwNTWZMHNYeRF0o/4k+aTtCA1GiDVQryBOrNKjcf6hzbQ3YrzH7sI4ItqkqmC4IZz8MhK5OO7DWe/vzj9orW83XTFwmNrOM1IJgzHsm/iyNmFKJWDeliJhEGt04jcWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=SYpBSO9x; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a3a3a9e4ffso2541125ab.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 04:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1728560515; x=1729165315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLGEeXitWZKflpz7f8dvCOzHMw8lQ7/MkR5+khK1S4U=;
        b=SYpBSO9xntUv72qsLx/7VjTBlHcqieu+UIxc67cOY/3qGVwlfi5qMUUd6+GvMyakiG
         InLC4DB9Mn93u4214snJmTNlV9KgaCk7YbrlxZ3vWQlgY7w6TWQZgB2JiMFtxnfSVa5h
         DTBlaJ4AhzhZf1B9xmOabDggcytdHuJe1ws4cr9I6y+uHYFyz8Ge59pgDt7P7Wqk8KY6
         9pIXDgerqyIqQz7q9iG6uQt4rc95cYs5Rjk6HBl6aWnAZIDFvywffXDqzrcb+xzDvWGe
         PVR0gkHxTR9sLDn13Dhd4HEFnpRbuLJZQ1Mbn7vI8TdfTg5hNGDbw/6U+rsMqwxSCFya
         g3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728560515; x=1729165315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLGEeXitWZKflpz7f8dvCOzHMw8lQ7/MkR5+khK1S4U=;
        b=U8GqxbWNZ5eqq3B3U0ErROUZJMQtUwZtZUQA8OFIqsZkPdSnNYhPvsrNb0bTz4bM+q
         Yx5EBivR3sE31u8NKx8Rq3L+cBn1U821p4845sOI/FJc8JuKU0fk89Dzw9XRGsb5+Oft
         hMEYcJy7X4c11mhWA+H1wczABw78y/lQSSvAtdUALIUo+MJ9BBQh+TsdWDFiBYHDe1X5
         OOHVbwlOK2tOF9JX1Cd1vyokfdsq4u+KqskSen4VnTzmsROpQEj54uzWrvCm3lqGt+l8
         rHREpdXdEPjnxprcXUhepNwEjtZYF403cCqbGQYCjsr1q4Slycxn9nLtlQN+z7PH3b/H
         Fklw==
X-Forwarded-Encrypted: i=1; AJvYcCVX7cWt0pyJNTlonasa8IaK8g7xFyQlAKWOU+evLrieSF/VPDQrsiXoHEcofQIf8J7RHCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2KYp1tPB/A/n+08Mk538TfAgYOpJBl5WTo8pZSB+XV9pR/98u
	A9c5ZYGjR05ixuBlFRIW2gM9av2UA5564Dql+Kavxeqcn3lCeHhKgUosuCnvi4+MrS+onr368bX
	c+eBItvyXRmuuCa2Sb6vix+aOdK3I4DgqzJA/0A==
X-Google-Smtp-Source: AGHT+IGdjd1/XT2c4B0Z8vQGIotkt4pyM5B4YYch5zcEe11pNDikzWWp/JAP0Tw+7KI97Zc523H2fMoWAABaV3y6nik=
X-Received: by 2002:a92:c265:0:b0:39f:325f:78e6 with SMTP id
 e9e14a558f8ab-3a3a6d2747dmr16106495ab.0.1728560514733; Thu, 10 Oct 2024
 04:41:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-2-seanjc@google.com>
In-Reply-To: <20241009154953.1073471-2-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 10 Oct 2024 17:11:43 +0530
Message-ID: <CAAhSdy0Z27X9KMF-ps97-s5==7xdA=6B84Mxa2b-um_t+NjWkg@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] KVM: Move KVM_REG_SIZE() definition to common
 uAPI header
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 9:19=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Define KVM_REG_SIZE() in the common kvm.h header, and delete the arm64 an=
d
> RISC-V versions.  As evidenced by the surrounding definitions, all aspect=
s
> of the register size encoding are generic, i.e. RISC-V should have moved
> arm64's definition to common code instead of copy+pasting.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/arm64/include/uapi/asm/kvm.h | 3 ---
>  arch/riscv/include/uapi/asm/kvm.h | 3 ---
>  include/uapi/linux/kvm.h          | 4 ++++
>  3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 964df31da975..80b26134e59e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -43,9 +43,6 @@
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>  #define KVM_DIRTY_LOG_PAGE_OFFSET 64
>
> -#define KVM_REG_SIZE(id)                                               \
> -       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> -
>  struct kvm_regs {
>         struct user_pt_regs regs;       /* sp =3D sp_el0 */
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index e97db3296456..4f8d0c04a47b 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -207,9 +207,6 @@ struct kvm_riscv_sbi_sta {
>  #define KVM_RISCV_TIMER_STATE_OFF      0
>  #define KVM_RISCV_TIMER_STATE_ON       1
>
> -#define KVM_REG_SIZE(id)               \
> -       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> -
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
>  #define KVM_REG_RISCV_TYPE_SHIFT       24
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc055145..9deeb13e3e01 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1070,6 +1070,10 @@ struct kvm_dirty_tlb {
>
>  #define KVM_REG_SIZE_SHIFT     52
>  #define KVM_REG_SIZE_MASK      0x00f0000000000000ULL
> +
> +#define KVM_REG_SIZE(id)               \
> +       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> +
>  #define KVM_REG_SIZE_U8                0x0000000000000000ULL
>  #define KVM_REG_SIZE_U16       0x0010000000000000ULL
>  #define KVM_REG_SIZE_U32       0x0020000000000000ULL
> --
> 2.47.0.rc0.187.ge670bccf7e-goog
>


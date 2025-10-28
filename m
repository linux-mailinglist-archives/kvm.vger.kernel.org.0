Return-Path: <kvm+bounces-61311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDC8C15CF1
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:30:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D0822354A38
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8497F2882AF;
	Tue, 28 Oct 2025 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="2aHdX4Jr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC232D440
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761668987; cv=none; b=qfTsfICalfBa16G+0tqN5A6rTFJYIlARmAKzWch4NfgBqn5X4SXfK7k4Eb/X2p8tMsncduXzub469f227lNN3UAijWti45I5qBldPNAnpFMxVtQqhYA1NcJDYnyH6lh/IffgWx3aotFdUJA2XNK3FJ3oVxQIED7wWloPDURMKxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761668987; c=relaxed/simple;
	bh=xQ0DSL8vGlaPGQU9Hp7y9CcwdlTXKyRGe5V82OocB5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qhrnvOEdkTTVimWozKgBPIcIxhcmqzyVfi753FEtLT7XNLVQ3pfF0X4XbFcYWH8o8SbLCpWkpsUnc202PbaGJyTKq1rZWiIqA9iIvaOMFxesvfoiC/BiJP6dY9C1K8VS1rqfgs2AP9TIWYiaNDf6/U4qtge3XsHBQwxlpEgk09k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=2aHdX4Jr; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-430d098121cso27097885ab.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761668985; x=1762273785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vU+TdivIUQqN8kZ5z+UlMDP2EK04JqI3D0gfCEED62A=;
        b=2aHdX4JrMmiQeCqQefDdTvXXrjSCVX/dfkXE/gznbAtx5/jO01zA+l/CJNEQuvLnWX
         o6v0/DoyzWNPt3oSO++UjGjCslc+BXZ4FJRnCzp5YOexCvA8Asa+ArKqnVhScY+mdZ3J
         b+TaWGvrrE4HNPF0lpgE6FLcnHdu4KGY3RCYkbyKDT6aMEMPpfTyhFU6nar7FOh+DC2e
         CWAEehGAl5V6gCaence0ZgaXdHvFofgWbmqiEP/QK9zD9iUosgZbKlSmfIK7Z5Gf9Zf+
         KsXV64UgSzgZr/yAvzoe2fLOfJ2xEwnlH2cRsuRzhqeIuQfwLDSd6Qv1Fz7KGXJaJJzY
         nGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761668985; x=1762273785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vU+TdivIUQqN8kZ5z+UlMDP2EK04JqI3D0gfCEED62A=;
        b=j6F8IsYJZ3XdRuzuhAI6il6N7sMLD/o1h5dGCTaWZQaQM0eO5pR8Jz8WURF3ioiIGa
         WNFMLmlS57HBUBr3/goS203a5BDC9s5BB35sJQ0AoaxNz4ghTiRgWYYypADfA/TwAGBZ
         U85vK0gUFFB8ENAvkbfNgrjRkAaQOkHx6EhVbTm92/pTgHSF/M2M87f3Sq7wiJM3C7rJ
         oVntavQTIKjVLihJ9dNpSGijuNIP2uSSZZKY/DS7/+PsYe9Ng3ElSKR4yL1PvthA+yDu
         9ZbmQuVCXkL3bYYvQra0dBzSe1D1FxMvH6otQS0urQoRfMXKX/CP73UeiuhgGD6+DX/W
         eryA==
X-Forwarded-Encrypted: i=1; AJvYcCWA8S6bdJlFp+7gLvgHjbeBPiU3HFia8G+yVLwbAuZZOMp176QL+bgKUckxRtrue+xGe8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Vqu+BkGLe7rcAU3w7tA6p6RraNqLtyM1y8ZA0DbaZMekjBD3
	0Jdc1zClEs2JwR3XRnPZrEm7DYI0l3RRw8HYW1XCz+McRIIT153RX5wMfCX20QGv7EM0sIkGWtr
	YtI7CJSXfcmIZDT82Emu9Z8jaYAnYrUHwkw7Z7gvang==
X-Gm-Gg: ASbGncsTAHyONBtpwROz3oV24VqWF+4QarmSrPARTDwM8k9WxVOvpmdYQzyL6KLxaY7
	pZXuepqCNxAOQ70zd/N3TpQDDOq9KtmyoK6BTkQEcZQDG4iLT6tjgU/oyoPe6wHMtQ+9gM4MgrP
	WK33eLrgYF56lfEN7hauykCxVlE3mq7oH0zKv9CnvdW0qnMHyutoUHXRlqgjRIxGhEL4ozcvy5O
	j2eoEA2n0RhyYeLDzR+NFdYJAyOasTq3S1Q3jw3FHqt/BgWrhdywXJfgD3ZyXaYqlLq4MOBKvMO
	bQwOgxR41uAhhWtm3w==
X-Google-Smtp-Source: AGHT+IErAS74fWZIiI+tq2UyEDPXnXxNVCopnwSSqDNelEK9r7LFhgamKfvM6HVy6byU9ivOLNYx10ZFvWOtH8QctNI=
X-Received: by 2002:a05:6e02:97:b0:3f3:4562:ca92 with SMTP id
 e9e14a558f8ab-432f82bbd0dmr6242035ab.10.1761668984856; Tue, 28 Oct 2025
 09:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251023032517.2527193-1-minachou@andestech.com>
In-Reply-To: <20251023032517.2527193-1-minachou@andestech.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 28 Oct 2025 21:59:34 +0530
X-Gm-Features: AWmQ_blNGqcbnB8O5PtfaRq8QkAGM6_aeGo0IUFrD9sil21TuzEIfSgTnICVsec
Message-ID: <CAAhSdy285QMVghHZv0He8-YOdBdK71_UXtQcy7_nf=3jaPxWsg@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
To: Hui Min Mina Chou <minachou@andestech.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, tim609@andestech.com, ben717@andestech.com, 
	az70021@gmail.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 8:59=E2=80=AFAM Hui Min Mina Chou
<minachou@andestech.com> wrote:
>
> From: Hui Min Mina Chou <minachou@andestech.com>
>
> If multiple VCPUs of the same Guest/VM run on the same Host CPU,
> hfence.vvma only flushes that Host CPU=E2=80=99s VS-stage TLB. Other Host=
 CPUs
> may retain stale VS-stage entries. When a VCPU later migrates to a
> different Host CPU, it can hit these stale GVA to GPA mappings, causing
> unexpected faults in the Guest.
>
> To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
> G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CP=
U.
> This ensures that no stale VS-stage mappings remain after VCPU migration.
>
> Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CP=
U changes")
> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

My comments on v2 are not addressed.

Regards,
Anup

> ---
> v3:
> - Resolved build warning; updated header declaration and call side to
>   kvm_riscv_local_tlb_sanitize
>
> v2:
> - Updated Fixes commit to 92e450507d56
> - Renamed function to kvm_riscv_local_tlb_sanitize
>
>  arch/riscv/include/asm/kvm_vmid.h | 2 +-
>  arch/riscv/kvm/vcpu.c             | 2 +-
>  arch/riscv/kvm/vmid.c             | 8 +++++++-
>  3 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/k=
vm_vmid.h
> index ab98e1434fb7..75fb6e872ccd 100644
> --- a/arch/riscv/include/asm/kvm_vmid.h
> +++ b/arch/riscv/include/asm/kvm_vmid.h
> @@ -22,6 +22,6 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
>  int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
>  void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
>
>  #endif
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3ebcfffaa978..796218e4a462 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -968,7 +968,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                  * Note: This should be done after G-stage VMID has been
>                  * updated using kvm_riscv_gstage_vmid_ver_changed()
>                  */
> -               kvm_riscv_gstage_vmid_sanitize(vcpu);
> +               kvm_riscv_local_tlb_sanitize(vcpu);
>
>                 trace_kvm_entry(vcpu);
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..6323f5383d36 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vc=
pu)
>                 kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
>  }
>
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>  {
>         unsigned long vmid;
>
> @@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu =
*vcpu)
>
>         vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>         kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +
> +       /*
> +        * Flush VS-stage TLBs entry after VCPU migration to avoid using
> +        * stale entries.
> +        */
> +       kvm_riscv_local_hfence_vvma_all(vmid);
>  }
> --
> 2.34.1
>


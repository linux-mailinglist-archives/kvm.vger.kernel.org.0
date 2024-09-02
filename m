Return-Path: <kvm+bounces-25665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 583F29683E6
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A0C51C225B9
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F861D3188;
	Mon,  2 Sep 2024 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5FVJtjL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416391D1F6E
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 09:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271138; cv=none; b=HDgH8n/CYDfksLsxsgi4EOJH7FLn1rhyfZ+q94mOg3Kb7NMw/qZNn38+4+ixyV7E1ALo4OCMjfuw0Gwr0mdZNMjC626Y94TDc65H0GxMQwkRFhz+LjZq9WtA9j6BakUNOyh4IgM2e3gAJdc01YwM1TCpdp9IOvIO6IIZ4Lkdl98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271138; c=relaxed/simple;
	bh=BTRkW3xmxXHurQAVY701fWMBVhIpjdnc5tz3yF4Tua0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ntfmiISVkvdvSiCJ44QOn0VKqmH8SqXvD/goCRt3b3DY3w4TdyPp4tD+aY0x3uY4NllxrcpM2mLqAm4tiAoe6IKsfkDiVXAZ1aVDOXDXkYH2+ZsbzhXQmJwwM8+hxk3CSbj/CqEcKzcnOYKMq565rKWRArgjYnIdSNAk/pNBe14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5FVJtjL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725271136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ+K8eSEOtaWbpAfWLmNDheCB3Bj04E+T76/DftjJL8=;
	b=Q5FVJtjLn+4Ydsv0uZ0Sp0mlmD6Id3jkLcfByY0jB4CBMw/0Tj3D3SmgFf9L/AIRrddPH8
	WReUIydeQyzzeX71JjD3zdHHYyGA/XEhPPFeLol3+mekDvOENEAqVL6R/ov+joHFtl/j95
	ZFDt9YduspiN/gLDqw/rGCmRRdY/n30=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-L_UKkIc9PQ2F4GId51ugPA-1; Mon, 02 Sep 2024 05:58:55 -0400
X-MC-Unique: L_UKkIc9PQ2F4GId51ugPA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37188f68116so2714070f8f.3
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 02:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271133; x=1725875933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ+K8eSEOtaWbpAfWLmNDheCB3Bj04E+T76/DftjJL8=;
        b=GgkPwBpCgEeivE0iuDkOn+FXuJnfym+CCctUV1vfVhma68Zl48bn+8ufos3feyoveu
         aps1kKfd8BGBXcgRFsJKaigkzHXhjjMazfiqDwpa2xQwuw783TOMPv224gL1S/6pIVV1
         08m6LIMWwqkk0MjSiWtO8DXRn2AHWbZK0XgdtDzOKs8icYtbLD2QGgtJdeMsT2g+EkgL
         1Xd7LUmrBM/9snnqYsf8XoOX9s465G0wxVcW6CB4F9BwhWaxlgtcQJGUqjVP43gBM3k2
         bMLugF5CjipwvLuMkIF9TZxP2IIzUh2eVE0bvcbiUIbndaBA/tYn0qZdGTnEAT5AxEiy
         QVXg==
X-Gm-Message-State: AOJu0YwwSqY4YfJr72Rj77kc9luEDDZ0AKhOU5n+b+2O8eQmkJ+AHEQ8
	+Eef7xpz0EX3V7jLtgcvG8U2G2L6ChNe+doIfVyf9PlnbCmaHWTbvaE5hyHfHNFelc/itNgcGfb
	tzCXEy5p5Y8F5OEQKCeJeEQfDxllvcoaZTfJgNRaPTb6dw5fndIosxF/7+0ke39Wmsr0aXmmdTZ
	VtzGVHJQh7SFru+nn6GEkmdxlN9WaotBRHv25I5Q==
X-Received: by 2002:a5d:598c:0:b0:371:899b:5c5 with SMTP id ffacd0b85a97d-3749b54d9dfmr8779775f8f.27.1725271133240;
        Mon, 02 Sep 2024 02:58:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhkdHZNQcsFtS77EBUtm4w/qI+BidAfcz4I4KmP/oeWMIUFO7gY8HdOCvuLo/g6faFQsWixvT4rfu2njLFZVc=
X-Received: by 2002:a5d:598c:0:b0:371:899b:5c5 with SMTP id
 ffacd0b85a97d-3749b54d9dfmr8779762f8f.27.1725271132794; Mon, 02 Sep 2024
 02:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com> <20240802195120.325560-2-seanjc@google.com>
In-Reply-To: <20240802195120.325560-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 11:58:40 +0200
Message-ID: <CABgObfYT_X3-Qjb_ouNAGX1OOL2ULT2aEA6SDKessSbJxGZEOQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR)
 fastpath is successful
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 9:51=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> Re-enter the guest in the fastpath if WRMSR emulation for x2APIC's ICR is
> successful, as no additional work is needed, i.e. there is no code unique
> for WRMSR exits between the fastpath and the "!=3D EXIT_FASTPATH_NONE" ch=
eck
> in __vmx_handle_exit().

What about if you send an IPI to yourself?  Doesn't that return true
for kvm_vcpu_exit_request() if posted interrupts are disabled?

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..cf397110953f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2173,7 +2173,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kv=
m_vcpu *vcpu)
>                 data =3D kvm_read_edx_eax(vcpu);
>                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                         kvm_skip_emulated_instruction(vcpu);
> -                       ret =3D EXIT_FASTPATH_EXIT_HANDLED;
> +                       ret =3D EXIT_FASTPATH_REENTER_GUEST;
>                 }
>                 break;
>         case MSR_IA32_TSC_DEADLINE:
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>



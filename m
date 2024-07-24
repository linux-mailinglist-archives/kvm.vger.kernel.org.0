Return-Path: <kvm+bounces-22170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBBF93B356
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C239283043
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 15:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E182E15B0F9;
	Wed, 24 Jul 2024 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZmLEL2z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8255612E71
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721833368; cv=none; b=qlKgWuadUqrRaV0tCMqp+EbOIcL85+KPOLr3nmrQ32Se4+WYtthkuOdWhmKDILtJiiE1Kxe7de7gQjMO9UiOkhDZ3fx5ot5tuEz4adT3xzODQXUxlUNtGn+cZYm09duPXWrYVzjDY7rGKK+MC+ufdx8r4GyNai0XH/r/ettcDL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721833368; c=relaxed/simple;
	bh=E0X1nrqHO8R0gpBqwXb61IIQG9iBOUcVQ5QVYCvFclY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q+bx4zv8isB/G8M9Am0QH+AJwOAsi+SfTKRRKlF7+g+Z5VfKu3Ww8o4I0fXXY8sOJDaP/RXDUNCyFWTPGhKMknMG9kUlmbeGinSiPdYfc61KFnr9OjDp5b3rJiacpF1IRTA/wy5yAO5QT+j+15EiSj8cLhGbjZPU6zQEtVWTLQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CZmLEL2z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721833365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zoge/yJFeeViXjSex+u5bq32QmDqGoP9ZYclm6j+h44=;
	b=CZmLEL2zDX8vU5cnlIkNO5ZLPoDIqcSTWgZgKUs51sMEJMqNpIzLWohCVvi2XE/OM5sSku
	hSFDAG6THy+ps7JboOGl+wDA0LncPYYWtZ8LkSIa6CXpiHdXa7YVMf7S8+fNSBHzcW3UnV
	F8fqGRvztYL6xXnEwf4Q4WXotD6Xb5U=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-nr4tJPExO0Gn1aVjV2eipg-1; Wed, 24 Jul 2024 11:02:44 -0400
X-MC-Unique: nr4tJPExO0Gn1aVjV2eipg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ef3133ca88so30058581fa.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 08:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721833362; x=1722438162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zoge/yJFeeViXjSex+u5bq32QmDqGoP9ZYclm6j+h44=;
        b=XjP3XhciNgAllwxJfPZ22QHzDKwZ/gUG+8FqEkZpL5viTzpYFQlfH1oE9eRFJbJPHW
         mb0+88LH8O9/CwIDUqNuApQmsYHY8nZpaR3jZ5WXnntxt2DLwDny5jfokMFTGMcWLffQ
         xEZxTV2Uk4Roie+iSlXl2TJ1BhENMnTTrtjyckRZdFS3L/qonqdIgM/sckywNQAuxFZM
         9/DQF/OzSjYmLXSwH/e2jyknoUhQdMdmXzxSVNU8sRsPy8CnBu12r20G3LKJBgIzp8/I
         FqJTw9+qW6XaV+A0Y6HzltBHB77nMI/+01bgLXYBDltQFSfL2/WIEUkxVb6kEWIFNNxK
         luDA==
X-Forwarded-Encrypted: i=1; AJvYcCUWWcv5eY1mvM7lO/2cjc/pTtvQSIzeTAxQST4JX2O4kbPRVVhIano1epp938Yqo4wglVM2OeeGVqBuSUnymrI4VPkP
X-Gm-Message-State: AOJu0Yym5EytsI24McRUWyzvEmX4WdynsMv0Z5ZZeMMhCkNN5F4X87Ud
	d/Q6hk26NryTHiJpgfpnimZrUiWqJeiz2fW7I3gJ575GpznJiFcjx6t7EpeFGQfxGHNMKsFOugw
	0spx1sdxMl6BgdJobg9iXTx3EJzKHy1/mOBmg73P5/kgiFUPa1U7ybaDzjfLxhPLhUs7o362zkX
	32vtF2Pyz8wgKOuGxYZEJV+HSl9TbTrsgF
X-Received: by 2002:a2e:b177:0:b0:2ef:2e59:11dc with SMTP id 38308e7fff4ca-2f039ea7e78mr473141fa.25.1721833361937;
        Wed, 24 Jul 2024 08:02:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz21slK5EjDe5XNiZaFmx/2TgdS8UQyCtQItTYlVoejwIOUapJGaRf7U/R2/HBOVDs7AueJD6OaQoGJlbCvbY=
X-Received: by 2002:a2e:b177:0:b0:2ef:2e59:11dc with SMTP id
 38308e7fff4ca-2f039ea7e78mr472811fa.25.1721833361454; Wed, 24 Jul 2024
 08:02:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724080858.46609-1-lei4.wang@intel.com>
In-Reply-To: <20240724080858.46609-1-lei4.wang@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 24 Jul 2024 17:02:28 +0200
Message-ID: <CABgObfYHK+N68pOamxA4nT6iZUvEDeUN-AkNwEE9jgnig3AfNw@mail.gmail.com>
Subject: Re: [PATCH] target/i386: Raise the highest index value used for any
 VMCS encoding
To: Lei Wang <lei4.wang@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Xin Li <xin3.li@intel.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 10:09=E2=80=AFAM Lei Wang <lei4.wang@intel.com> wro=
te:
> Because the index value of the VMCS field encoding of Secondary VM-exit
> controls, 0x44, is larger than any existing index value, raise the highes=
t
> index value used for any VMCS encoding to 0x44.
>
> Because the index value of the VMCS field encoding of FRED injected-event
> data (one of the newly added VMCS fields for FRED transitions), 0x52, is
> larger than any existing index value, raise the highest index value used
> for any VMCS encoding to 0x52.

Hi, can you put together a complete series that includes all that's
needed for nested FRED support?

Thanks,

Paolo

> Co-developed-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Lei Wang <lei4.wang@intel.com>
> ---
>  target/i386/cpu.h     | 1 +
>  target/i386/kvm/kvm.c | 9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c6cc035df3..5604cc2994 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1192,6 +1192,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU =
*cpu, FeatureWord w);
>  #define VMX_VM_EXIT_PT_CONCEAL_PIP                  0x01000000
>  #define VMX_VM_EXIT_CLEAR_IA32_RTIT_CTL             0x02000000
>  #define VMX_VM_EXIT_LOAD_IA32_PKRS                  0x20000000
> +#define VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS     0x80000000
>
>  #define VMX_VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
>  #define VMX_VM_ENTRY_IA32E_MODE                     0x00000200
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index b4aab9a410..7c8cb16675 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3694,7 +3694,14 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, Fea=
tureWordArray f)
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
>                        CR4_VMXE_MASK);
>
> -    if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALING) {
> +    if (f[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
> +        /* FRED injected-event data (0x2052).  */
> +        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x52);
> +    } else if (f[FEAT_VMX_EXIT_CTLS] &
> +               VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
> +        /* Secondary VM-exit controls (0x2044).  */
> +        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x44);
> +    } else if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALI=
NG) {
>          /* TSC multiplier (0x2032).  */
>          kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x32);
>      } else {
> --
> 2.39.3
>



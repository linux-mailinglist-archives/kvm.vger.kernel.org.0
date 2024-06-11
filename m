Return-Path: <kvm+bounces-19329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0D0903E6D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29BB01F2222F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0906217D8A1;
	Tue, 11 Jun 2024 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGmDUaKy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696317D36F
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718115102; cv=none; b=jgeRdIg8Vh8HPi5hExtxEkbpPwywk+h1h60wIKDDJQYSwmUBOqUtm8MAIROlIKxRr0ic9nFwduoRLw/4iRY1pvuyyYy1Qm40Vt/j6+2zU2TnTJeLQ4EjmslvKbBq3hScNE4YMc+msRjXEoAdsjAiOd5pi2KVDmzqVx8hfuA8ugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718115102; c=relaxed/simple;
	bh=pIcYc7qj+KGZTsXvqC+Dyfy5a8D1ol5MLnz6Q2+/6T0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EpaD3r916tC/GJWK1yvSEfxMAQWUn66Pnislj8LtB4XB+6wfUR0e7wIq7d8oVf2PLjbV/dTTJoSh2W/v87Hfz11xJS0lpWPhbn+26MlQcvNsG3g0Huo+HWpV/7SipQXjwyDYnrkCaK4GT7p6Ost9ZHL1GVan8HzN6Qs5gLMjJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGmDUaKy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718115099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpDAWqVGKOY605xFCvj/GBOlGGRTneCE6rG1ivSak+k=;
	b=CGmDUaKyDS+MXAIOAB2TebwVwrUtllmxzvMDMzE7Fa004x0ITqiEo2+vN/zCthFPqhC1g7
	MMPG0cQs1ED+z3Jjyi4jhA/Kv53i4Q+zkiBj2Dv8E9WqZK2LGkzspoj0x6pj9PNx9xzq1z
	GpxOHZnqKVlyPHCn4ZXrG47p3/XKQqg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-mCsIcj_5OZyoTp69IJxNdw-1; Tue, 11 Jun 2024 10:11:37 -0400
X-MC-Unique: mCsIcj_5OZyoTp69IJxNdw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ebdc5ccb17so20649231fa.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 07:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718115095; x=1718719895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpDAWqVGKOY605xFCvj/GBOlGGRTneCE6rG1ivSak+k=;
        b=SdeK2lL1EKH5t3mpfOktLCuChYx4X47Vm3dJ9bjF4NM5Qj4ZKjcHDIlkFOKVLQxCQP
         j17N971IVrEQ8a+0tA14344PokFzmhVb0BaKRpnkH1+aev7sz2z8+H4XG6WyXPi/f+VF
         FFmJTMRfSqVQWHLRGUpGuQ10NLcPOQIR4APXz54S5ZjzMHJMrmuR6VxaxNDjFvzL91aw
         csBOR2rnAuwlbPhPJNmqVNqSgQI3ssul2U6jb3THhz+Gn6wVR1xOsS+Si4pmWYd6Wi0k
         Oa4YDEpxBJ+ufydiwVYiuyx4OkXGiJBPiKFnZyZ+/oSNmHPOpC4G4jqKiNb4YpjRlp+s
         MXHg==
X-Forwarded-Encrypted: i=1; AJvYcCXXWRQhx/YWyLHUrzZmkSqSAGGWdl7ET3axQWhUtZykkv9Kj93BNJ05x5XpThkyY2lttvoEEQTV8aNPTNHhmwgT8oYr
X-Gm-Message-State: AOJu0YymoywtGbGMTF6YbWqBpBq7VmGmUNvD9gf2k5nFVPSH06u6u4uH
	l/IPErlZ7GbKRGTmr12TFJTsBwIee3Tp8xgkOeIqVVL8Ct4OW0SXdDJVuFWK32SrRsDDnPyQmJP
	d8bZcyfSh7qiowrQtpaJfMEmxYwBnEM2r4SEpDTgcA+djz4RwysEyjnsNwVXPQR1bOV/HvMh/zY
	Da+rohAx32JNfbfFPx0y/gd+jn
X-Received: by 2002:a2e:9b95:0:b0:2eb:dc60:6ca9 with SMTP id 38308e7fff4ca-2ebdc6071f1mr44282031fa.21.1718115095641;
        Tue, 11 Jun 2024 07:11:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdNr89xOFxsu/OE+Qb/AhaeTb6Ok/589nDo93/+gKXMC8huDBP4tutt942gwRvE3O+A/NcNjdibu2XZ8tiX8Y=
X-Received: by 2002:a2e:9b95:0:b0:2eb:dc60:6ca9 with SMTP id
 38308e7fff4ca-2ebdc6071f1mr44281841fa.21.1718115095310; Tue, 11 Jun 2024
 07:11:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
 <ZiJ3Krs_HoqdfyWN@google.com> <aefee0c0-6931-4677-932e-e61db73b63a2@linux.intel.com>
In-Reply-To: <aefee0c0-6931-4677-932e-e61db73b63a2@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 11 Jun 2024 16:11:23 +0200
Message-ID: <CABgObfb9DC744cQeaDeP5hbKhgVisCvxBew=pCP5JB6U1=oz-A@mail.gmail.com>
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 3:18=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> >>   }
> >>
> >> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> >> index ed46e7e57c18..4f3b872cd401 100644
> >> --- a/arch/x86/kvm/vmx/main.c
> >> +++ b/arch/x86/kvm/vmx/main.c
> >> @@ -283,6 +283,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu=
 *vcpu)
> >>      vmx_msr_filter_changed(vcpu);
> >>   }
> >>
> >> +#ifdef CONFIG_KVM_SMM
> >> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> >> +{
> >> +    if (is_td_vcpu(vcpu))
> >> +            return tdx_smi_allowed(vcpu, for_injection);
> > Adding stubs for something that TDX will never support is silly.  Bug t=
he VM and
> > return an error.
> >
> >       if (KVM_BUG_ON(is_td_vcpu(vcpu)))
> >               return -EIO;
>
> is_td_vcpu() is defined in tdx.h.
> Do you mind using open code to check whether the VM is TD in vmx.c?
> "vcpu->kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM"

I'd move it to some place that main.c can see. Or vmx.c as Sean says
below, but I am not sure I like the idea too much.

Paolo

> > And I wouldn't even bother with vt_* wrappers, just put that right in v=
mx_*().
> > Same thing for everything below.

If it's a KVM_BUG_ON()



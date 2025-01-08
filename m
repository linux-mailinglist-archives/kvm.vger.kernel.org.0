Return-Path: <kvm+bounces-34788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24310A05F85
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD823A6D1B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907051FCFF5;
	Wed,  8 Jan 2025 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wTKCtLEm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615FF15350B
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736348464; cv=none; b=t1g16yNCwjvzt7BdYnoh5SS7i4zKKBP42AXTKkl56gfrS1lYDo5KimdbvEAfubZPjqb1tKVmfrn98Kwx6Mw8kku3xeEkbqfvtJ/UZuKN27A33jBYkvlWu6WL1SKD9T4gFGbFzw4+/2SVlIn/hVYuIVhAlAZEtgny05SeQQUeFzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736348464; c=relaxed/simple;
	bh=nyV2yl3XmNDhQ40W7YYCBaBWCDclqEByPJGKII1QDBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nfat2+xKRBQRSgYbpoeas3z74EfZF4ZwL97Ukd7EEny2ioIeNcMQFEIvACG/gi55URJCySCDdSc5f9MNckwt3XlwoH6j5x5cWAD5ydM0NWdkXI/lO3l5LUSWP+W6Hfo6scuBWy5agy4KAs9i7bR/2L/p8kzIlHKJfw9NaJfRUDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wTKCtLEm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so38942462a91.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 07:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736348463; x=1736953263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BxpHeQa6+oVcHk1D5x+DCISdWdWpyOX6w9TVx4KjZs=;
        b=wTKCtLEmrkvOllL+NbJrzl5JdEYnqCasorgC26rk+s9Edr/zfpzvGqGv6bfRs6zTmQ
         w/O/weH//g9a2zUwA8vyCGV0g182INkzpgilen5s05iPmOIxvOq4CtIAz2DiFd6z28LZ
         bXHq/TjMLM40a0OO6yA3lASpJPaDZasSYjKC82+xfaElrdPCM7UgjcNIThZXYj6UA2BI
         T7dVSg2BAz+EgxZFr7YzE0og91ZG2CWR2z1UqjTZ1kLPhIKzJmYNsMvdJMsvUilNI0+8
         4M6hmw5mzeU3zFMrf9AKdUWKFaaV/uktoal+eUu5GDaJSigZmycO2sARmUgwN1guuP5z
         IRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736348463; x=1736953263;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/BxpHeQa6+oVcHk1D5x+DCISdWdWpyOX6w9TVx4KjZs=;
        b=CSFNJ7xWE8PMe9vaHGAsp9nCV9QvpQtFpH8yJtmnA/q0AMIdAaBSe4MY5UBPUDcVBa
         3zM+n0wEvLUzruCADtQjpma8WPMlpyORTsbXZkj+YicZRb2FU3pJUhkfFhAs+ND+0p2q
         ggxTh1CFUywPOpKzewmURyo7LDIa3aalRfIGIp7Cq+4E3fdHdYo7oPfVKL2C8HFXCckc
         Vx11Dh12ksnrvf38iq4Pkoj/CdRDJWqGZGuq6A3hZz60orTtzRNwHC9r8+n9L/tzNqIK
         z78Vvx9OwkYa0S/aaM4rTqDT8Vh1KOTh1BaC8+YfB9mNYFmVCFrsQGenuJZSfFD9TkWZ
         lLxg==
X-Forwarded-Encrypted: i=1; AJvYcCX8Wk2zHX+IA2XXzQZfNub3S/d6zN9B27Pt1precq2byWgID/gaykggFPzL37+MxpbA+dI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNnQVQf0XSL8EnPK+ftujGmzc4L0tgx8LXH50oNYBVH4IX7OAs
	S3QcvKE0CBWTaymXgVzkZ1UPaVhBYIrkLF1LkfSBcmAjlwQuo4m4ZSGd5Si2wUZBjtaOG9L05F0
	63Q==
X-Google-Smtp-Source: AGHT+IHPEwOjIRpY3qflTXtWlCZWrnzWqpeJtMdMBn2fUt52cnKKWya/HJRk3WY+oGQFCmrz/1mIlOBmAf0=
X-Received: from pfbcv10.prod.google.com ([2002:a05:6a00:44ca:b0:725:e60b:1e4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:178e:b0:725:f4c6:6b81
 with SMTP id d2e1a72fcca58-72d21f459e8mr4979296b3a.2.1736348462619; Wed, 08
 Jan 2025 07:01:02 -0800 (PST)
Date: Wed, 8 Jan 2025 07:01:01 -0800
In-Reply-To: <Z34NGyZL7G_j716N@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
 <Z3zZw2jYII2uhoFx@tlindgre-MOBL1> <7f8d0beb-cc02-467d-ae2a-10e22571e5cf@suse.com>
 <Z34NGyZL7G_j716N@tlindgre-MOBL1>
Message-ID: <Z36TLcX1kOe1ltjp@google.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
From: Sean Christopherson <seanjc@google.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2025, Tony Lindgren wrote:
> On Tue, Jan 07, 2025 at 02:41:51PM +0200, Nikolay Borisov wrote:
> > On 7.01.25 =D0=B3. 9:37 =D1=87., Tony Lindgren wrote:
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -139,6 +139,8 @@ __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noa=
pic_vcpu);
> > >   EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> > >   __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ=
);
> > > +EXPORT_SYMBOL_GPL(apic_hw_disabled);
> >=20
> > Is it really required to expose this symbol? apic_hw_disabled is define=
d as
> > static inline in the header?

No, apic_hw_disabled can't be "static inline", because it's a variable, not=
 a
function.

> For loadable modules yes, otherwise we'll get:
>=20
> ERROR: modpost: "apic_hw_disabled" [arch/x86/kvm/kvm-intel.ko] undefined!
>=20
> This is similar to the EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu) already
> there.

Heh, which is a hint that you're using the wrong helper.  TDX should check
lapic_in_kernel(), not kvm_apic_present().  The former verifies that local =
APIC
emulation/virtualization is handed in-kernel, i.e. by KVM.  The latter chec=
ks
that the local APIC is in-kernel *and* that the vCPU's local APIC is hardwa=
re
enabled, and checking that the local APIC is hardware enabled is unnecessar=
y
and only works by sheer dumb luck.

The only reason kvm_create_lapic() stuffs the enable bit is to avoid toggli=
ng
the static key, which incurs costly IPIs to patch kernel text.  If
apic_hw_disabled were to be removed (which is somewhat seriously being cons=
idered),
this code would be deleted and TDX would break.

	/*
	 * Stuff the APIC ENABLE bit in lieu of temporarily incrementing
	 * apic_hw_disabled; the full RESET value is set by kvm_lapic_reset().
	 */
	vcpu->arch.apic_base =3D MSR_IA32_APICBASE_ENABLE;


Return-Path: <kvm+bounces-30709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2409BC9A7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C7B1F21423
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389EB1D151F;
	Tue,  5 Nov 2024 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDKSgLVi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861423C6BA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730800454; cv=none; b=RfIMmUl88JCyYVVOVD8EkrSHBIGLcWr9LTgw01+oCw2pcDrEPybhgRRjUcATb4Xc2WrbhtX9NFVv4jtgM8UPui59g8zXPDr9fJnnBSk/0m+MLU49813d1rno+9ylqxpm16EYm9uDjQZ1/X9hpiezB8/zygBb0PLBa86v4sP1ii8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730800454; c=relaxed/simple;
	bh=2iz/DjnkvEzLL1QCqCKwwsCWMiXOo94QECfsZfW1Hlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UpK1sG/51M09N3CVuiqGXo/C9x5TFkdlpW7ZjbBiacxOzKMyi9Xr/GQX/I5You0WbiYDbDD1a0owyL8+otqiBFg75v15Isu0xGuZc2u3Ee0xmhL+0yYEmjj2WUlQO1ykPNMSyYiablYrvMxYzx5RtXEHaKBRhusWipqjf0KfnZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDKSgLVi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730800451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLK8CGodL7ScRszYLizC0fSmOUX6I2Ja8rM/oIftHTU=;
	b=FDKSgLVij5Gtwg2FurOCc8N2qrBQJdQRHBI9+CugLx+Bo825SRuuTYQEJpOl551WaDQCA+
	13TuGGr2gklu8Q/Wesj223CmGxsJDOcDVY2gMISCePPdKJ5hMKrQyfeGDBDLZqqDyXMM1e
	pTKjjBVhjUIpIgdsRUHerRSBA4YeuBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-IMIUMpsJOqiVTg8JmSuASg-1; Tue, 05 Nov 2024 04:54:09 -0500
X-MC-Unique: IMIUMpsJOqiVTg8JmSuASg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4314f1e0f2bso34763675e9.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 01:54:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730800448; x=1731405248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLK8CGodL7ScRszYLizC0fSmOUX6I2Ja8rM/oIftHTU=;
        b=mz7Lb2+j0VVBUCiN7o90orLOfDfPBm6kJpVDS9GR0axG2q0tHpyTXZbBfzzNAR4XiE
         C3KZ4jh+cA6WI4I6u7L3L2bj4ArnRAUG1QoMJJrt0r256ciMuuBde8I3/bvjUeq/fOdx
         gffJcmbTvh5OdIqGwtg8qEwfun0OGYgh1faz16jgQ6EWgs6CFIHOr0EB9i/ZGDduLAgy
         +og+X7LtThHxDZjQTRzM2yFjDDPQe7Lo5ckAUizUEIWdk41nSaFnrZ8LQOLszuOnkD5h
         L1tMG0hTT72+QY+alPl4fXSv/t06T04H6mumo0hdkH8XCCipyt0fCsMvxZr201W+AloP
         2W3g==
X-Forwarded-Encrypted: i=1; AJvYcCWnqVmobUZkeT/02G2IyBWYsKJwlcUIZ10YI+xjJ4SAYbQGRpJh81UTaz+2jNViiM3vWDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfQsSifzUxusmvmgMnOoTuToEglzWZVYPQP2qWvzZGtiwCvUKV
	d7lntFLa3WV+VLbkwh3H6XPIzxYs513vMi1W6Z4RySlibk6fwFECXCCT6uv876h/06PNszC2aMT
	hETwvvNMux6iJ/WWjZd6pr1t4aUHy2PzdFFpRnoAlvM7NS9+TnNV3Xsctvs8lb1ZiJUYgWY2eam
	3+Rb80t+mOiUS7A+DC01PUI81d
X-Received: by 2002:a05:600c:450d:b0:431:4a5a:f09a with SMTP id 5b1f17b1804b1-4328327e02cmr123290685e9.24.1730800448571;
        Tue, 05 Nov 2024 01:54:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrChRQ/ANVarKuoF1a5YBsEYToVHl9GfWnLHSr4UjYEhuQT5OIeXUXcDgIqDDfSOWWLHjauEoFpQ+GOgeBvLI=
X-Received: by 2002:a05:600c:450d:b0:431:4a5a:f09a with SMTP id
 5b1f17b1804b1-4328327e02cmr123290405e9.24.1730800448232; Tue, 05 Nov 2024
 01:54:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-60-xiaoyao.li@intel.com> <9601f5a1-f1f1-47ab-a240-30331946b584@redhat.com>
 <08939cf7-f27b-44c2-93cf-d0951d2d2141@intel.com>
In-Reply-To: <08939cf7-f27b-44c2-93cf-d0951d2d2141@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 5 Nov 2024 10:53:55 +0100
Message-ID: <CABgObfZVxaQL4FSJX396kAJ67Qp=XhEWwcmv+NQZCbdpfbV9xg@mail.gmail.com>
Subject: Re: [PATCH v6 59/60] i386/cpu: Set up CPUID_HT in x86_cpu_realizefn()
 instead of cpu_x86_cpuid()
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Riku Voipio <riku.voipio@iki.fi>, Richard Henderson <richard.henderson@linaro.org>, 
	Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Igor Mammedov <imammedo@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 10:33=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 11/5/2024 5:12 PM, Paolo Bonzini wrote:
> > On 11/5/24 07:24, Xiaoyao Li wrote:
> >> Otherwise, it gets warnings like below when number of vcpus > 1:
> >>
> >>    warning: TDX enforces set the feature: CPUID.01H:EDX.ht [bit 28]
> >>
> >> This is because x86_confidential_guest_check_features() checks
> >> env->features[] instead of the cpuid date set up by cpu_x86_cpuid()
> >>
>
> It seems I mixed it up with no_autoenable_flags. /faceplam
>
> CPUID_HT doesn't get enabled by x86_cpu_expand_features() for "-cpu
> host/max". It won't be filtered by x86_cpu_filter_features() either
> because QEMU sets it in kvm_arch_get_supported_cpuid().
>
> yes, the comment is wrong and comment needs to be dropped. The code can
> be move up to just below x86_cpu_expand_features() or inside it?

Inside it seems okay, and you can then remove it from cpu_x86_cpuid().

However, let's also add qemu_early_init_vcpu() to the realize function
from all targets, and remove

    MachineState *ms =3D MACHINE(qdev_get_machine());

   cpu->nr_cores =3D machine_topo_get_cores_per_socket(ms);
    cpu->nr_threads =3D  ms->smp.threads;

from qemu_init_vcpu(). You can resend patches 58 and 59 separately
from the TDX series.

Paolo



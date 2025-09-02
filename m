Return-Path: <kvm+bounces-56602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEA8B40813
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 16:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE7895E5706
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7112322A2D;
	Tue,  2 Sep 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yiWzrT4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55954320A33
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756824628; cv=none; b=nQE6m4LirzuTOMvz7EgNo8ic1f/LcA4lE6g3lkiUfxyDUumoQwPfHbCPjGN5a9kBdB+jnWrSbI6e+bjW30mQAOHJMYOxCObmHdDuffFVu+GPf4i13VpQbURc3IG7dM6ycu40cCTps0E9T/OBenDkluGlwbqB1wWAoqcCafM1l6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756824628; c=relaxed/simple;
	bh=dH9WJqnnaUBg0PJEQdCMKAbP/OG3mpvTrdhmMKmcYHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kM10tW4Ntw9Cj9V3+bWgDNNHD5nnv8g5FuNGtBkeH2P1L+J/I3ECz7d+idGWquQLa4DmZn1R9kpirlOSCnoSh2nPVMz7k2tj108M0GOgnqw6174YCepeLfCHXv4Vt2ZGrKTIxlsQyGB5soiYjcl93sp3bInrvCH52S6yvpEFepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yiWzrT4P; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso5260739b3a.2
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756824626; x=1757429426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVhDXq7LIMwuZZc1aVBi0bntn8J+fEILMHHxGS2ec3Q=;
        b=yiWzrT4PQjJgLy8fs6EhcAUdEd96gqW/soblg7P3rZLuhLOuqG4keii5hwV4an1dp0
         HuRp+LzoIdkRBRhpLdNMIAFRePjsIiuOhQMKPoTiQqiA5LqKz6uRhejWVXeTFc7xJuc3
         9lwVcVQXwmy+S2Sw6VA2vwbgy4BpxvRT0aWGD/RFWTjn/+6zk3Tk6x4nIhGSQa4FEK7Q
         CnesL3vbauHSsn31sHYdPp3ocwy71ZS4wJ1WuCgbR93bSw5n3fYMVyDK4+29ZJsNr9XN
         g1zzf1qXautgtybKpdmHxMOs/QeBLVj/IMVhla+zVyFw4xucZ9PW4GFNBvAWMoAlyzZr
         AR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756824626; x=1757429426;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BVhDXq7LIMwuZZc1aVBi0bntn8J+fEILMHHxGS2ec3Q=;
        b=V/2TqfYj1+Aak2RQnJWg6FMcvzumtrovjukAshA+Hrr8hBAm8gNbW/hyFPp0OEZKPy
         0/Znz09QfHJFEPn0cZLoLMdhhXyoQpIkhZT620jClV35rhdLfHs1+KYaUmG6jfyFSylR
         FGNpqgZZYl1nz/jvyLWpCx0qqUU20kJikbms0TMFdrEZ5B3lSfS9KOwXtzFl5i9KHW61
         4eUMgfwz71a/dFQEinGmmbLg/eelTTSkMylHbkgJjcp4C8JJptDuJgBvTN+cwSgg+Odw
         2zhThjXtC6v3nxcqS49+LhbnZafdCa687oPbCefHXpp/StwJIXXPkUU/X0q7jK4ov3kM
         CsUg==
X-Forwarded-Encrypted: i=1; AJvYcCWW6+MLAlH58IKzxPOa+tRam8KC1GjS8WyjsaJkRdy+9QC71H+m60mkY5jA6UIYGaVZRjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyElZagvEwH88mZ1sVc/Q0yVOpDUsXs84e4NRGxWKfViIoDNiM8
	VMDVupv2TL0Pp9YbTY6ApKhn55sX5FkcJCM/BT8fVeVeuV+MjDymS8YFSdTqTB3f1y8Swq718ye
	/Ws6yvQ==
X-Google-Smtp-Source: AGHT+IFtWd0Vy9I1oKsoEPVbgz7z2BDFEVbR9IM8u1o9qW9c7L994gWT3hCAFl0msMpLwSM0dvMW7Cf8q/4=
X-Received: from pfbdi11-n2.prod.google.com ([2002:a05:6a00:480b:20b0:76c:6ec8:ac2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fd2:b0:772:641:cfb8
 with SMTP id d2e1a72fcca58-7723e0d366emr11456143b3a.0.1756824626392; Tue, 02
 Sep 2025 07:50:26 -0700 (PDT)
Date: Tue, 2 Sep 2025 07:50:24 -0700
In-Reply-To: <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com> <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com> <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
 <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com> <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
Message-ID: <aLcEMCMDRCEZnmdH@google.com>
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Xin Li <xin@zytor.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2025, Xiaoyao Li wrote:
> On 9/1/2025 3:04 PM, Xin Li wrote:
> > On 8/31/2025 11:34 PM, Binbin Wu wrote:
> > > > We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
> > > >=20
> > >=20
> > > Indeed.
> >=20
> > Good catch!
> >=20
> > >=20
> > > There is a virtualization hole of this feature for the accesses to th=
e
> > > MSRs not intercepted. IIUIC, there is no other control in VMX for thi=
s
> > > feature. If the feature is supported in hardware, the guest will succ=
eed
> > > when it accesses to the MSRs not intercepted even when the feature is=
 not
> > > exposed to the guest, but the guest will get #UD when access to the M=
SRs
> > > intercepted if KVM injects #UD.
> >=20
> > hpa mentioned this when I just started the work.=C2=A0 But I managed to=
 forget
> > it later... Sigh!
> >=20
> > >=20
> > > But I guess this is the guest's fault by not following the CPUID,
> > > KVM should
> > > still follow the spec?
> >=20
> > I think we should still inject #UD when a MSR is intercepted by KVM.

Hmm, no, inconsistent behavior (from the guest's perspective) is likely wor=
se
than eating with the virtualization hole.  Practically speaking, the only g=
uest
that's going to be surprised by the hole is a guest that's fuzzing opcodes,=
 and
a guest that's fuzzing opcodes at CPL0 isn't is going to create an inherent=
ly
unstable environment no matter what.

Though that raises the question of whether or not KVM should emulate WRMSRN=
S and
whatever the official name for the "RDMSR with immediate" instruction is (I=
 can't
find it in the SDM).  I'm leaning "no", because outside of forced emulation=
, KVM
should only "need" to emulate the instructions if Unrestricted Guest is dis=
abled,
the instructions should only be supported on CPUs with unrestricted guest, =
there's
no sane reason (other than testing) to run a guest without Unrestricted Gue=
st,
and using the instructions in Big RM would be quite bizarre.  On the other =
hand,
adding emulation support should be quite easy...

Side topic, does RDMSRLIST have any VMX controls?

> For handle_wrmsr_imm(), it seems we need to check
> guest_cpu_cap_has(X86_FEATURE_WRMSRNS) as well, since immediate form of M=
SR
> write is only supported on WRMSRNS instruction.
>=20
> It leads to another topic, do we need to bother checking the opcode of th=
e
> instruction on EXIT_REASON_MSR_WRITE and inject #UD when it is WRMSRNS
> instuction and !guest_cpu_cap_has(X86_FEATURE_WRMSRNS)?
>=20
> WRMSRNS has virtualization hole as well, but KVM at least can emulate the
> architectural behavior when the write on MSRs are not pass through.


Return-Path: <kvm+bounces-59455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B497EBB6EEC
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 15:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0E16A4EC86D
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 13:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A0C2F3630;
	Fri,  3 Oct 2025 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwzR6ij7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D502F0687
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759496976; cv=none; b=u1dm2uJEHB3sNoH4/5KkWJ5AVdB4RSJjVhzkHSiIIyXRXatAH8f8jry3yYgVaKqhYfr8oEQ7kJHo/Myi5+97W2ie8MMTEe5uVtVUMmwF3zWIiA4HtL/vwaHlFYeNyD/m63otINMpU6sQH7gNCiAvb4W5lNEXLTrV1LGjO3wJWsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759496976; c=relaxed/simple;
	bh=0Xw4OrpjWdDORDcldR9v9bzLrfr0F1CBruVxe1CW9mY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aFWUhJUaawM7YzqPlK3ljzTZkFYRRLW0sZBmSxlqlB8JjWeiJabNpod7q64Q+NMnWAo4N0EL5v6xkq4Im8kgUGv0Eh1Pa7JBzbqTK9huNMmtLN6+EVy81VpjY14yVaZ33qUSrhZ/h2AvpzfCDEc6wk5YYakXKD//lzCljie0I9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NwzR6ij7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759496973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eg6B+28DeYgN6XdKeJOVznWh4ZfZPQPBD7mqFN84nc8=;
	b=NwzR6ij7Nw4SI9cN6alPYmXFyhnnriAazQ1v8M1cPCiJTv6JtH9CXO212epqkWDjflvaoQ
	APDMa2hRhaBE+WVUuSmtMGzd+Qtb6bw34zRF2TWMuBxQgzXV83Uxp1UScarwZi4oRJXrNz
	Teol03UjoQ6TFmIU4ftRGHo0F3FOiVs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-b6LUFOGLMp6tk2Rp2Ji0qA-1; Fri, 03 Oct 2025 09:09:30 -0400
X-MC-Unique: b6LUFOGLMp6tk2Rp2Ji0qA-1
X-Mimecast-MFC-AGG-ID: b6LUFOGLMp6tk2Rp2Ji0qA_1759496969
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so1064303f8f.2
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 06:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759496969; x=1760101769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eg6B+28DeYgN6XdKeJOVznWh4ZfZPQPBD7mqFN84nc8=;
        b=GoJ+G8wwTYWFZn1NR0KpkR36T6lZh4wS+pl/MkUAvXR3nOurIxrP2ku/ljVmqkqv+p
         UKxStQF5AfK/oLO+7vsBp4AkAuc9b+/krDtDbDcdYUAkX4xWUdpyBjtdkZfLOsO0Rnzp
         CmX+VpPPYa/hq4gNM6ShgoPMFWr8Nu98CwYReT7gPuQ+0OQnOuw7+rTKPl2bC96eZfMT
         wrjaJWywuOAMXKCmtk4B79YTzGcTjwlB/Bl0+peRnrYiS0NaBiKSMHIOxj/XMxPDg2/3
         U6DMTRo69nCE58B2t/Ze+O7srO2Wd5G1uH/0inkLaKmt63Yn1zG71fNweeC/s4Pz2rNk
         9xWw==
X-Forwarded-Encrypted: i=1; AJvYcCVfa8f9Ne6LvOSjUzSNn8jncGHsDn6m3WqXz7vp0RbMfm3Ic+HuuIxJC93qivcIaPN23ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHOP0C8aPXnNzvw1A2ZBRse43CvP+CEDoSl/htGCyTHRxD3hfX
	AC+afly+Yyyqr2h28ACxkhB9AzJg5CPT+V21Y9qZx7fcWrBLqop4R9mAI7+AIohm4xobQqV8pV6
	vuQ480aIelCFThJqAXM0OXWja7ZfFBzdtymRU4URx35yFlOw99RXYLGPAaWyQOWIuj+opJQsDj/
	oTNczgjsX0cv/IZ5MLE6TabZ21abzE
X-Gm-Gg: ASbGncskI2jOQn6u3XXb63QaIPohWOSZcJOtjonwinRn8lu6YJQF0PaHFWyxlW0g6XC
	hrPMdpvHmLH/Ku451hYxB5LimxfTCvywxIITyxWR/2hGI4QZeSlFeVv4pBrKF+TsxN3fQL4Fq1D
	rJYIIV8l8G+hO6skt6iXNWsmwarYtW01FrQqSeaoTLxheFS0GWYcoTDb1x8ZyyzNy2kA2eG9Uwk
	E8Lbrf53Z62bdTjDYY8oGY+TduHZQ==
X-Received: by 2002:a05:6000:2583:b0:407:23f7:51 with SMTP id ffacd0b85a97d-42567139c92mr1640649f8f.1.1759496969105;
        Fri, 03 Oct 2025 06:09:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzAenVtcphcMGAWHYvO2v3kNfpOU2vJxj0QqILnulExcDPJNr8MPCwAVl6rlHmLadXK2j/bt5MbGd1fhqTEe8=
X-Received: by 2002:a05:6000:2583:b0:407:23f7:51 with SMTP id
 ffacd0b85a97d-42567139c92mr1640625f8f.1.1759496968712; Fri, 03 Oct 2025
 06:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com>
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 3 Oct 2025 15:09:17 +0200
X-Gm-Features: AS18NWAANVc028IrEWCYH8_s3j0p7D-JkOKS1W3aZhhlnuZ_7HZRUQfOviWSiqM
Message-ID: <CABgObfb0Qc3hdXTmZvOykxuR+7RZ4vRUBpm8M84UmHgjwx7BCA@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] TDX host: kexec/kdump support
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dave.hansen@intel.com
Cc: bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, 
	hpa@zytor.com, thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, kai.huang@intel.com, 
	seanjc@google.com, reinette.chatre@intel.com, isaku.yamahata@intel.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com, 
	chao.gao@intel.com, sagis@google.com, farrah.chen@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave and others,

any reason why this series was not pulled into 6.18? I was a bit
surprised not to see it...

Thanks,

Paolo

On Mon, Sep 1, 2025 at 6:09=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> Currently kexec() support and TDX host are muturally exclusive in the
> Kconfig.  This series adds the TDX host kexec support so that they can
> be both enabled in Kconfig.
>
> With this series, the user can kexec (including crash kdump) to the new
> kernel at any time regardless of whether TDX has been enabled in the
> first kernel.  One limitation is if the first kernel has ever enabled
> TDX, for now the second kernel cannot use TDX.  This is the future work
> in my TODO list.
>
> This series should go in through the tip tree.
>
> Thanks,
>
> Paolo
>
> v7->v8: stub out the new code when kexec is not enabled in the kernel.
>         Of course even the smallest code change is subject to bikesheddin=
g,
>         and I chose my preferred color for the bikeshed.  But it's pastel
>         green and I'm sure you'll agree that it's beautiful.
>
>
> Kai Huang (7):
>   x86/kexec: Consolidate relocate_kernel() function parameters
>   x86/sme: Use percpu boolean to control WBINVD during kexec
>   x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
>   x86/kexec: Disable kexec/kdump on platforms with TDX partial write
>     erratum
>   x86/virt/tdx: Remove the !KEXEC_CORE dependency
>   x86/virt/tdx: Update the kexec section in the TDX documentation
>   KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
>
>  Documentation/arch/x86/tdx.rst       | 14 ++++-----
>  arch/x86/Kconfig                     |  1 -
>  arch/x86/include/asm/kexec.h         | 12 ++++++--
>  arch/x86/include/asm/processor.h     |  2 ++
>  arch/x86/include/asm/tdx.h           | 31 +++++++++++++++++++-
>  arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
>  arch/x86/kernel/machine_kexec_64.c   | 44 ++++++++++++++++++++++------
>  arch/x86/kernel/process.c            | 24 +++++++--------
>  arch/x86/kernel/relocate_kernel_64.S | 36 +++++++++++++++--------
>  arch/x86/kvm/vmx/tdx.c               | 10 +++++++
>  arch/x86/virt/vmx/tdx/tdx.c          | 23 +++++++++++++--
>  11 files changed, 167 insertions(+), 47 deletions(-)
>
> --
> 2.51.0



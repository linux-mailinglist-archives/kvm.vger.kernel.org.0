Return-Path: <kvm+bounces-31609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA0A9C5312
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 11:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCE701F26468
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3129A2141A7;
	Tue, 12 Nov 2024 10:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPTgpW2F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74520213EE7
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406652; cv=none; b=qaKFJk36WZq3VOwHu4aWewPC1L4vSxICIS0jzL0MJXGvyYBHeUCLTT84A18xi7sbbe5P05Ilh+aYacdsVie8yZM1j5saMFApJzTo/2PaV5chNvz0kLbDWEcT9Qws5KpVtydaJW450cxNEUsTdTeNDQO9gnTv2y3WxjsIOtFzkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406652; c=relaxed/simple;
	bh=3LE/uQCFRzD9AYK90x3fGGWlE6ZUcSfNuzikrT/rsEM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JwB94th56T5PqRSXafHiJEgmwDrR535bFIOf/J1BJJi49drHJpdR32dyDtPn6wG4f0N9kqOjAJFvtMOG4IHG5kFFSZD4heQvCl9MkQPauRgDQC47iy0WM6MYo7oLAYFsWr4mezqMus8QSgCZN4HWWXPq6Ft0y7tYV6O8/h9RQ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPTgpW2F; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cefa22e9d5so6198601a12.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 02:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731406649; x=1732011449; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3LE/uQCFRzD9AYK90x3fGGWlE6ZUcSfNuzikrT/rsEM=;
        b=ZPTgpW2FO/6dahRMjv9oIL0jPZ7YyMKYU4KqznmtdpbXJleD9Nb+20+5iQ8TZ/39YP
         u1SHNJBfMuQkMSDrz+4+scVwIxDLUNK3KGceJXZbr2qWtH0n53lULP557f9DWXZdOz9j
         Et3vNMeP9ENeGGP76jIya2QNsF6MVwvkYzNSLOfyVPz1OdJEJSrESuzPZ0Yq1lbzGNS2
         O2RabtLfkNFriUm9dnaDhPP0jd/pP2BqiHBpjKmfXaKceHef1pE0996qAKimLgOQX73f
         IdMJk+IyAN+3fLiTz3SP8pJ1GF+M5lEqy76tyzQR6Qqcgg7bridIws8a8sTZL39Z/ytB
         s1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731406649; x=1732011449;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LE/uQCFRzD9AYK90x3fGGWlE6ZUcSfNuzikrT/rsEM=;
        b=PHqyhVLVix9Br8lFoPCagiz6qpNltlRd7iqz4/KexUEoGah6M3VsvxV7nb+JRYpA7u
         j2QXj49/O5GBXP2ycgxU1qu8rrPuGdN4O3JITk42WDBpcOJwmL3rC0WywG19Dl55hcNy
         4AEmfkFZ32BnI/fye2t6LgD0XmNQACtGaGhrnFi2GHOWSt61QXa2cTtPzLFuKWof382v
         N844SX5+Nz96CwQ2g8rnGI86DuVbEUaD6LeWvMNcboSzkcFj4U6WWkCsnXdkvEbnnlCz
         MnOA1Eh0MZcNdhJKIBemyBU4L0PNdmJBQz5h2KbdN5CwLu/4+CSysOVtLT+2lnfNh4OD
         rPig==
X-Forwarded-Encrypted: i=1; AJvYcCWcBj/W64QsAyK69rRtB5tVdyS7ysNOWwdhoJgeNoooRHprOh1s5ULkGZb0OI9Xo27cAZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3k9gzAUtO2moak/OS1odpHpklxRtB7pSWcQP7GIyG7+UeZ9un
	QR4DZrAU3aLMPpad4cAGD8kZjHNHNOKmlblJF87J746+zD+T8sWr
X-Google-Smtp-Source: AGHT+IEb5ELpA9GlL2palg2Q4wuZ8cY7EssS8HMyUxKWbS47/oLRn+cYjuGANhR2YPA5JkbkzzkiPg==
X-Received: by 2002:a05:6402:2067:b0:5cd:5499:8dbb with SMTP id 4fb4d7f45d1cf-5cf0a32388cmr9660204a12.20.1731406648264;
        Tue, 12 Nov 2024 02:17:28 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:fb75:3035:4c0:20e9? ([2001:b07:5d29:f42d:fb75:3035:4c0:20e9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03b5d76esm5735357a12.9.2024.11.12.02.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:17:27 -0800 (PST)
Message-ID: <17f00e24648b3f4f2ad5b941d848ca1d1fc075ae.camel@gmail.com>
Subject: Re: [PATCH v6 60/60] docs: Add TDX documentation
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Riku Voipio <riku.voipio@iki.fi>, Richard Henderson
 <richard.henderson@linaro.org>, Zhao Liu <zhao1.liu@intel.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>, Yanan
 Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>, "Daniel
 P." =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>, Eric Blake
 <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>,  rick.p.edgecombe@intel.com, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
Date: Tue, 12 Nov 2024 11:17:25 +0100
In-Reply-To: <20241105062408.3533704-61-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	 <20241105062408.3533704-61-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-11-05 at 01:24 -0500, Xiaoyao Li wrote:

> diff --git a/docs/system/confidential-guest-support.rst
> b/docs/system/confidential-guest-support.rst
> index 0c490dbda2b7..66129fbab64c 100644
> --- a/docs/system/confidential-guest-support.rst
> +++ b/docs/system/confidential-guest-support.rst
> @@ -38,6 +38,7 @@ Supported mechanisms
> =C2=A0Currently supported confidential guest mechanisms are:
> =C2=A0
> =C2=A0* AMD Secure Encrypted Virtualization (SEV) (see :doc:`i386/amd-
> memory-encryption`)
> +* Intel Trust Domain Extension (TDX) (see :doc:`i386/tdx`)
> =C2=A0* POWER Protected Execution Facility (PEF) (see :ref:`power-papr-
> protected-execution-facility-pef`)
> =C2=A0* s390x Protected Virtualization (PV) (see :doc:`s390x/protvirt`)
> =C2=A0
> diff --git a/docs/system/i386/tdx.rst b/docs/system/i386/tdx.rst
> new file mode 100644
> index 000000000000..60106b29bf72
> --- /dev/null
> +++ b/docs/system/i386/tdx.rst
> @@ -0,0 +1,155 @@
> +Intel Trusted Domain eXtension (TDX)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Intel Trusted Domain eXtensions (TDX) refers to an Intel technology
> that extends
> +Virtual Machine Extensions (VMX) and Multi-Key Total Memory
> Encryption (MKTME)
> +with a new kind of virtual machine guest called a Trust Domain (TD).
> A TD runs
> +in a CPU mode that is designed to protect the confidentiality of its
> memory
> +contents and its CPU state from any other software, including the
> hosting
> +Virtual Machine Monitor (VMM), unless explicitly shared by the TD
> itself.
> +
> +Prerequisites
> +-------------
> +
> +To run TD, the physical machine needs to have TDX module loaded and
> initialized
> +while KVM hypervisor has TDX support and has TDX enabled. If those
> requirements
> +are met, the ``KVM_CAP_VM_TYPES`` will report the support of
> ``KVM_X86_TDX_VM``.
> +
> +Trust Domain Virtual Firmware (TDVF)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Trust Domain Virtual Firmware (TDVF) is required to provide TD
> services to boot
> +TD Guest OS. TDVF needs to be copied to guest private memory and
> measured before
> +the TD boots.
> +
> +KVM vcpu ioctl ``KVM_TDX_INIT_MEM_REGION`` can be used to populates

s/populates/populate

> the TDVF
> +content into its private memory.
> +
> +Since TDX doesn't support readonly memslot, TDVF cannot be mapped as
> pflash
> +device and it actually works as RAM. "-bios" option is chosen to
> load TDVF.
> +
> +OVMF is the opensource firmware that implements the TDVF support.
> Thus the
> +command line to specify and load TDVF is ``-bios OVMF.fd``
> +
> +Feature Configuration
> +---------------------
> +
> +Unlike non-TDX VM, the CPU features (enumerated by CPU or MSR) of a
> TD is not

s/is/are

> +under full control of VMM. VMM can only configure part of features
> of a TD on
> +``KVM_TDX_INIT_VM`` command of VM scope ``MEMORY_ENCRYPT_OP`` ioctl.
> +
> +The configurable features have three types:
> +
> +- Attributes:
> +=C2=A0 - PKS (bit 30) controls whether Supervisor Protection Keys is
> exposed to TD,
> +=C2=A0 which determines related CPUID bit and CR4 bit;
> +=C2=A0 - PERFMON (bit 63) controls whether PMU is exposed to TD.
> +
> +- XSAVE related features (XFAM):
> +=C2=A0 XFAM is a 64b mask, which has the same format as XCR0 or IA32_XSS
> MSR. It
> +=C2=A0 determines the set of extended features available for use by the
> guest TD.
> +
> +- CPUID features:
> +=C2=A0 Only some bits of some CPUID leaves are directly configurable by
> VMM.
> +
> +What features can be configured is reported via TDX capabilities.
> +
> +TDX capabilities
> +~~~~~~~~~~~~~~~~
> +
> +The VM scope ``MEMORY_ENCRYPT_OP`` ioctl provides command
> ``KVM_TDX_CAPABILITIES``
> +to get the TDX capabilities from KVM. It returns a data structure of
> +``struct kvm_tdx_capabilities``, which tells the supported
> configuration of
> +attributes, XFAM and CPUIDs.
> +
> +TD attributes
> +~~~~~~~~~~~~~
> +
> +QEMU supports configuring raw 64-bit TD attributes directly via
> "attributes"
> +property of "tdx-guest" object. Note, it's users' responsibility to
> provide a
> +valid value because some bits may not supported by current QEMU or
> KVM yet.
> +
> +QEMU also supports the configuration of individual attribute bits
> that are
> +supported by it, via propertyies of "tdx-guest" object.

s/propertyies/properties

> +E.g., "sept-ve-disable" (bit 63).
> +
> +MSR based features
> +~~~~~~~~~~~~~~~~
> +
> +Current KVM doesn't support MSR based feature (e.g.,
> MSR_IA32_ARCH_CAPABILITIES)
> +configuration for TDX, and it's a future work to enable it in QEMU
> when KVM adds
> +support of it.
> +
> +Feature check
> +~~~~~~~~~~~~~
> +
> +QEMU checks if the final (CPU) features, determined by given cpu
> model and
> +explicit feature adjustment of "+featureA/-featureB", can be
> supported or not.
> +It can produce feature not supported warnning like
> +
> +=C2=A0 "warning: host doesn't support requested feature:
> CPUID.07H:EBX.intel-pt [bit 25]"
> +
> +It will also procude warning like

s/procude/produce

> +
> +=C2=A0 "warning: TDX forcibly sets the feature:
> CPUID.80000007H:EDX.invtsc [bit 8]"
> +
> +if the fixed-1 feature is requested to be disabled explicitly. This
> is newly
> +added to QEMU for TDX because TDX has fixed-1 features that are
> enfored enabled

s/enfored/enforced

> +by TDX module and VMM cannot disable them.
> +
> +Launching a TD (TDX VM)
> +-----------------------
> +
> +To launch a TDX guest, below are new added and required:

This sentence is missing a subject (such as "command line options").

> +
> +.. parsed-literal::
> +
> +=C2=A0=C2=A0=C2=A0 |qemu_system_x86| \\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -object tdx-guest,id=3Dtdx0 \=
\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -machine ...,kernel-irqchip=
=3Dsplit,confidential-guest-
> support=3Dtdx0 \\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -bios OVMF.fd \\
> +
> +restrictions
> +------------
> +
> + - kernel-irqchip must be split;
> +
> + - No readonly support for private memory;
> +
> + - No SMM support: SMM support requires manipulating the guset

s/guset/guest

> register states
> +=C2=A0=C2=A0 which is not allowed;
> +
> +Debugging
> +---------
> +
> +Bit 0 of TD attributes, is DEBUG bit, which decides if the TD runs
> in off-TD
> +debug mode. When in off-TD debug mode, TD's VCPU state and private
> memory are
> +accessible via given SEAMCALLs. This requires KVM to expose APIs to
> invoke those
> +SEAMCALLs and resonponding QEMU change.

s/resonponding/corresponding



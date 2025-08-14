Return-Path: <kvm+bounces-54689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 572C8B26E9A
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 20:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EFA67BDC0F
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E2C319863;
	Thu, 14 Aug 2025 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yp4lHwwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FC3319852
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755194461; cv=none; b=OvMSWDV17XauXivtx1xcohIrhO522eB/T67PywQqyzUYM2ZuSX+yB/mxLqCjP10/JcnwJPxAly7llqDrsP0eDZ0kLIeLzFhjeBz7gu47Jnxz/I2QHW3rh9+4Fo2dGcg3t8/VsV4jgM+NrV/h59WwBFcZqOBjgEkJopCHfHfhDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755194461; c=relaxed/simple;
	bh=sgHYyHT9P3+Ri4inTzepKA9eeR2T6s/x27iDn6LlylY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UPkSAZ79i/5/bVHJV9czVaVzKHlvf/SLFl34IswzzJw/cmDyKmYuUDF4IXKhx1ljHmMaQnFp0/Tg3ZMcWrVaBomds+YqhwV0ILlVglk0PRdTUQDt1N9BehLK4rpNyvaJMEfOtAWNs7xM87dPhCjqbdJ6LQbPdsF4umESI6kccYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yp4lHwwJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326779c67so1212852a91.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 11:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755194460; x=1755799260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qo8YP48saC70f8nhVLPXqNgxZORbU+kNCjpBN1UXxU4=;
        b=yp4lHwwJYq2zxzBh5QeF3tBijABWJ3ejrrCveINGhpxVfKNdPMuCd+x9XKvYmCGEyY
         MgrxkRwTZzhajoanqEaIqea8C5AcbQBde5KlsOXEFb5WwsEHlI5bkZ90qArxvnNLsbfQ
         e1/gShvmilV8015UIZMRlWBANAKc0BKnFm5fU5U9ptMFaik89bl2nKiPVu8xKCKJlu5A
         x5+ER4txzZOI67kW16NVqCnjU8MFd8KvY/XayF7RfcMUCyL8um9LQv0o/K7AeLi9nE+d
         9OrglUl39wt0Ibika3AKX8orSaC8dbEspx9NaV7v2zsOhFxooc4Fc/0aJdgxKcxNA9t/
         WZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755194460; x=1755799260;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qo8YP48saC70f8nhVLPXqNgxZORbU+kNCjpBN1UXxU4=;
        b=PMaccZO2oA1gT1w1dwWxpHekAnwpk0m4vupK6kWDKSheExbqzYrU3KfWNruus5Poki
         b6BoPEz4jpwNr7Q8Hf45C7sVQDeKeRvc48zgT0I1lVJEa4boKxCY7YReOD0eX/jYmM0f
         Y5t7Mk/6+5xCndR/ClhP7QpY0IAf+9FCGu3Q4TiEb/dyG3RejuI4q+gHOVQ0pbpyff8o
         IQ3z1Iat7WhtQLFLjr0g9EOiNmJs3x9acFxu9I68SeTVTRVRaYm1A3xZydoMBxFC/Kki
         i9IkLs5iGRnJWVNp/WZP0mbgNoEkBiH0WumelkC8DIbUPxu4xOfOP8x1UciHK4uPbvbL
         1cWA==
X-Forwarded-Encrypted: i=1; AJvYcCVEDtW5pHI3bYXQ+sQiQXsh16AwIBtH3QHT0h7DH6+odra7YlD5hEwlUpBqusW9w9jdbPE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ixBT7pcz36RtBfT8Jt/Hn+p0lfgj0fpGyYg5DcOdAb0Yn6Y4
	1jsuPYAU6gFvKHI+JW4bF4I8fmsy+q+qJewik+Rt/+08xuWPDujgG1+NDjPhEVu+T2XHC7/Kez/
	LGPykhA==
X-Google-Smtp-Source: AGHT+IEGQtx1mDPknNV+0MSozvZx9Iz59OeDO2C+iu+5XN28Cy4LHlj3QKqp8YTRlYFCSm+U+Hh+N8eOiJg=
X-Received: from pjbtd11.prod.google.com ([2002:a17:90b:544b:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cd:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-3232b239af0mr5459494a91.9.1755194459725; Thu, 14
 Aug 2025 11:00:59 -0700 (PDT)
Date: Thu, 14 Aug 2025 11:00:57 -0700
In-Reply-To: <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755126788.git.kai.huang@intel.com> <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
 <aJ3qhtzwHIRPrLK7@google.com> <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
Message-ID: <aJ4kWcuyNIpCnaXE@google.com>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, Dave Hansen <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, 
	Farrah Chen <farrah.chen@intel.com>, "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Dan J Williams <dan.j.williams@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-14 at 06:54 -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 66744f5768c8..1bc6f52e0cd7 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -442,6 +442,18 @@ void tdx_disable_virtualization_cpu(void)
> > > =C2=A0=C2=A0		tdx_flush_vp(&arg);
> > > =C2=A0=C2=A0	}
> > > =C2=A0=C2=A0	local_irq_restore(flags);
> > > +
> > > +	/*
> > > +	 * No more TDX activity on this CPU from here.=C2=A0 Flush cache to
> > > +	 * avoid having to do WBINVD in stop_this_cpu() during kexec.
> > > +	 *
> > > +	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
> > > +	 * before booting to new kernel, but that code has a "race"
> > > +	 * when the normal REBOOT IPI times out and NMIs are sent to
> > > +	 * remote CPUs to stop them.=C2=A0 Doing WBINVD in stop_this_cpu()
> > > +	 * could potentially increase the possibility of the "race".

Why is that race problematic?  The changelog just says

 : However, the native_stop_other_cpus() and stop_this_cpu() have a "race"
 : which is extremely rare to happen but could cause the system to hang.
 :=20
 : Specifically, the native_stop_other_cpus() firstly sends normal reboot
 : IPI to remote CPUs and waits one second for them to stop.  If that times
 : out, native_stop_other_cpus() then sends NMIs to remote CPUs to stop
 : them.

without explaining how that can cause a system hang.

> > > +	 */
> > > +	tdx_cpu_flush_cache();
> >=20
> > IIUC, this can be:
> >=20
> > 	if (IS_ENABLED(CONFIG_KEXEC))
> > 		tdx_cpu_flush_cache();
> >=20
>=20
> No strong objection, just 2 cents. I bet !CONFIG_KEXEC && CONFIG_INTEL_TD=
X_HOST
> kernels will be the minority. Seems like an opportunity to simplify the c=
ode.

Reducing the number of lines of code is not always a simplification.  IMO, =
not
checking CONFIG_KEXEC adds "complexity" because anyone that reads the comme=
nt
(and/or the massive changelog) will be left wondering why there's a bunch o=
f
documentation that talks about kexec, but no hint of kexec considerations i=
n the
code.


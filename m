Return-Path: <kvm+bounces-29884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5649B3917
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7D94B213C3
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFDCE1DFDA1;
	Mon, 28 Oct 2024 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dIJp2+P5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413461DF73A
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140061; cv=none; b=fujw9EMf6ihXQ8r0QkXA1KdjlOuPgbA23kk56vwuAwiz4QMlv6DRyi3M8ITMltjODR5HKbC31o7BwpHQwGuqiQNz2sVi2l6owkCqt8UhfqQx5QpOyEmwyseFq4NU4BSqwn+UzJYOTRXT5I6h5HizfAmKUxJlDaeyEhgZWmMnBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140061; c=relaxed/simple;
	bh=b1S1kMmCum00nro+Vr3336NHK/tiVehkGpWnxsKKwWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tw5TuKLZ8sRPQ1MdHINBJZYbQtGsMXtc324eBb6097HDRDgaoHAtdnAql+K2bhhy5p0vlTyLeJa73+8/q4T/9CGQVOK3bdrNmA3kWwugqQ0wk4lur28IzIA+Osd+nlU2lyIt+1FVpoJt0/+rZC3CqhU0T380iDaYGLAHc7PaekE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dIJp2+P5; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e307c375d36so5562220276.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 11:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730140058; x=1730744858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmnbZOU0qjIEimURD21SxRpoBoMeIUpyXKqWoTkNi2A=;
        b=dIJp2+P5X5PHVU8BE/doOTRgmnSVZxdnbz1OZM8RcfVnZSmOpPc9vMaZ4g6O5fliiK
         Lsj1+wGw5dgihVYMbItp2+oHmp1s52H/tv38LGlMVo8ZUa6QCh6ptHB/LmlmIJMXtQ7m
         uZT8ZDG9AX2mKEkY8j+4iHtvuacpJRsTLNaFaqNXYqs5IOdpJhfK2pQllemwf6ccR4DX
         5qDnDeinhdrME/SEveYh0vszejw9eVoOFVs+7P4J63Xyowwtb+nDihI92dWgErXSxJtU
         TRGSuWaghojh3XQGhw7Wt6AhIV5ehLclk1k0tZVQQXj7ueqoclII86rEfB61nDweIvfq
         gMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730140058; x=1730744858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmnbZOU0qjIEimURD21SxRpoBoMeIUpyXKqWoTkNi2A=;
        b=hbUD9AqmNs++ACiH507PN1Ed4JCWZhWmbHeFi3s9uZSwlX1PryoHcL3B0S0uxIW049
         WYUJFyzSkwDZUnVXAsIDn0fVSN6AIKfCE2tuO1Gcr/FIKdJbPa6ecQ+xJUNctk1o3U08
         S3HgfFR4zwMHmaQX+DfPtmJe8S7WCwR+DFXQUtSrXfrSNQjB1txa07aM6wwhpg2AkBMT
         nUe2v1UnJGpBjwc3kA7MKm7lHljfQs4WYHaX+H273H3uIWyUva942xsoKW4aUvcWuxd1
         UMFxBfpQShYp0ANhrorLMi9UU+wa3kvLmfNm4M/0GQlCT7h2ZyfFDx2NYpg4GN2ZC7YQ
         ukZA==
X-Forwarded-Encrypted: i=1; AJvYcCWxuB6OH363IzsaYnWYeWGgM9uNJMwxoZsSlfHsLA7JGCaYQcO08kIGU5m3kRylxUnJwyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaRmufp5RYqOYfpRg6Br5bFv/Cy4DONQQExwz5oZLxdUzO/Scn
	4+3ZxU9B2XZjbFsion9m4VWSPXIm3siA8k8j8aMefNuHAHyNrt5itsiRJ6gwnw/Q5krUVXf219F
	bdA==
X-Google-Smtp-Source: AGHT+IFn240YgEA2N2ByflWwnKUPX22a8Bmi+G7kKnmPMa+4cJwROFpduXbMAKP/dP2eb/K6QoAQDQFEUeI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b28e:0:b0:e29:6df8:ef58 with SMTP id
 3f1490d57ef6-e3087a5bd64mr65240276.4.1730140058246; Mon, 28 Oct 2024 11:27:38
 -0700 (PDT)
Date: Mon, 28 Oct 2024 11:27:36 -0700
In-Reply-To: <Zx9Ua0dTQXwC9lzS@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <20241001050110.3643764-26-xin@zytor.com>
 <Zxn6Vc/2vvJ3VHCb@intel.com> <f9bb0740-21ec-482d-92fb-7fed3fef7d36@zytor.com> <Zx9Ua0dTQXwC9lzS@intel.com>
Message-ID: <Zx_XmJnMCZjb7VBS@google.com>
Subject: Re: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xin Li <xin@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 28, 2024, Chao Gao wrote:
> On Fri, Oct 25, 2024 at 12:25:45AM -0700, Xin Li wrote:
> >> > static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
> >> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> >> > index 2c296b6abb8c..5272f617fcef 100644
> >> > --- a/arch/x86/kvm/vmx/nested.h
> >> > +++ b/arch/x86/kvm/vmx/nested.h
> >> > @@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
> >> > 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
> >> > }
> >> > 
> >> > +static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
> >> > +{
> >> > +	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
> >> > +	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
> >> > +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
> >> > +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
> >> 
> >> Is it a requirement in the SDM that the VMM should enable all FRED controls or
> >> none? If not, the VMM is allowed to enable only one or two of them. This means
> >> KVM would need to emulate FRED controls for the L1 VMM as three separate
> >> features.
> >
> >The SDM doesn't say that.  But FRED states are used during and
> >immediately after VM entry and exit, I don't see a good reason for a VMM
> >to enable only one or two of the 3 save/load configs.

Not KVM's concern.

> >Say if VM_ENTRY_LOAD_IA32_FRED is not set, it means a VMM needs to
> >switch to guest FRED states before it does a VM entry, which is
> >absolutely a big mess.

Again, not KVM's concern.

> If the VMM doesn't enable FRED, it's fine to load guest FRED states before VM
> entry, right?

Yep.  Or if L1 is simply broken and elects to manually load FRED state before
VM-Enter instead of using VM_ENTRY_LOAD_IA32_FRED, then any badness that happens
is 100% L1's problem to deal with.  KVM's responsiblity is to emulate the
architectural behavior, what L1 may or may not do is irrelevant.

> The key is to emulate hardware behavior accurately without making assumptions
> about guests.

+1000

> If some combinations of controls cannot be emulated properly, KVM
> should report internal errors at some point.


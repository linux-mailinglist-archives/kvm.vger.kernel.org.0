Return-Path: <kvm+bounces-8352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAEA984E566
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A436284558
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 16:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A717FBA0;
	Thu,  8 Feb 2024 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQyfUJy4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C9973164
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707410941; cv=none; b=Ty+uM8xrsMkN5PnLPAHvwlyYWeBgsI7/KPBcN3JsqQgZxkOn59lXiHlYN0dbeOUk9QtHKuVU90fwFCw1DzYyXvcz2uUmLuYXO00ObFPZADWkd/LgNsFI5pW8kfKg5a3/B+1XGBZxSEFdId4nZ6NxYg9KBfUtGVCGpHKBKAmSt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707410941; c=relaxed/simple;
	bh=pIkQcZS9dPhEHcosG9RvWsKh81a3Ju3tnA2/A83HRUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFAeZ9qciuOD0o2QVohVx1muRmSOjxZcrSbr8k+BTmqnphzwyBETIf9EhqH+actg03VCJOK0Bkz+z9TnqVgCDXaDokGi/KZXPy4noJnnhPk6nyYPJz1ve7YQpjRG24L6DF+KNiDdzPjXy84qcOsgq6tvCaEbvV8bKEuYnJpG5gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QQyfUJy4; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso3487149276.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 08:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707410938; x=1708015738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lOwnn26TKMYPd0wmIeXSxvlCDp0GqmDj4OeL7dzZHIA=;
        b=QQyfUJy4VaY6qF1ffR89eKTTiCe+wRKJS1CVSaicweFzZ8gujNbUWsiIpk2pr8ZCM8
         mDpYZSGygkyOxefclvVCXi2ZUv1oQbD9Zww5abP1ZDYWDrAjFbovXNsrh33kSMekCdBa
         KgoqqgekplgDRfFWHc30TZckLAL2dXATCQclEL7s5PrsHSYc0Y/2UAXYrmGS3Kxcbh6J
         m0/CrqrXIAF6voQ3+hcjGsboPt0I84aAQ8HNdlfJsb4+pS6salKppRGpRPLW4Nabu5br
         YS32TAGLPbH88J+JmqlKYofCPv9ynOB6HrwmuQGfLTumBrYxTn+Qb/PRoourTrBtRZoo
         p8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707410938; x=1708015738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOwnn26TKMYPd0wmIeXSxvlCDp0GqmDj4OeL7dzZHIA=;
        b=INY/20TamFr6mezU4445S0nx+NzZpVDt/GXIyb1S83XkYeljlkPQGzeuDzsifIjv0W
         NOHlNCepTMlHOQx6hWrQAHfzO3PQ/v4cDTzOlGZ9R4opzmPzPWL7WrLR1tKdA5FJoojG
         99YwKrF7S8eW0THJVx6zQtLOfL4WsFla3RDuinJFNmDxdUy88IJRkJlpRDCjPJmo5rvg
         7q7k+hyj0+wRFTSAZbHCf5Emk4W6u4l2lJ9DVcxYYUBqJhi7Or+VHCfYZdFja1Hl1gf8
         iWiCa1JBn3uiM3PBGP48uVv6hAA8qgZto0NZyjIE9eK5cbATMpEPWPE9pt8JcCkNAyuK
         9qfA==
X-Forwarded-Encrypted: i=1; AJvYcCXMQRwSxEl6zzp2FEJ5PexEEruDVTsTVE0thy8P7ija5v4pE62vQ+dxD7ClPkSqffWM+Rmun3vDhtFBnL797oyD6GKK
X-Gm-Message-State: AOJu0YzqYi6wNLbRSL0STrLXIf826JeNjHofZdsfadpCj+v2X3uurILP
	y0mT6Wma0c1eQdcSHFIJdExo9vP6m7mOfp1aA87fnjWSousngJKzmw+owR2mQVnVJQ+AeQ6hDna
	70w==
X-Google-Smtp-Source: AGHT+IFOo4ddahF0N7mDmX9X1X2sNM2ZcU+vQGm7JwWM0YenhPypIVF1WHscjjJm6Z5C2Oh/m3uaJv7ZgLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1a48:b0:dc2:3441:897f with SMTP id
 cy8-20020a0569021a4800b00dc23441897fmr2126896ybb.6.1707410938415; Thu, 08 Feb
 2024 08:48:58 -0800 (PST)
Date: Thu, 8 Feb 2024 08:48:57 -0800
In-Reply-To: <92918ee8-3cc9-41c3-a284-5cd6648abc05@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-12-paul@xen.org>
 <ZcMCogbbVKuTIXWJ@google.com> <92918ee8-3cc9-41c3-a284-5cd6648abc05@xen.org>
Message-ID: <ZcUF-TNbykWvh3r7@google.com>
Subject: Re: [PATCH v12 11/20] KVM: xen: allow shared_info to be mapped by
 fixed HVA
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 08, 2024, Paul Durrant wrote:
> On 07/02/2024 04:10, Sean Christopherson wrote:
> > On Mon, Jan 15, 2024, Paul Durrant wrote:
> > > @@ -638,20 +637,32 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
> > >   		}
> > >   		break;
> > > -	case KVM_XEN_ATTR_TYPE_SHARED_INFO: {
> > > +	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
> > > +	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA: {
> > >   		int idx;
> > >   		mutex_lock(&kvm->arch.xen.xen_lock);
> > >   		idx = srcu_read_lock(&kvm->srcu);
> > > -		if (data->u.shared_info.gfn == KVM_XEN_INVALID_GFN) {
> > > -			kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> > > -			r = 0;
> > > +		if (data->type == KVM_XEN_ATTR_TYPE_SHARED_INFO) {
> > > +			if (data->u.shared_info.gfn == KVM_XEN_INVALID_GFN) {
> > > +				kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> > > +				r = 0;
> > > +			} else {
> > > +				r = kvm_gpc_activate(&kvm->arch.xen.shinfo_cache,
> > > +						     gfn_to_gpa(data->u.shared_info.gfn),
> > > +						     PAGE_SIZE);
> > > +			}
> > >   		} else {
> > > -			r = kvm_gpc_activate(&kvm->arch.xen.shinfo_cache,
> > > -					     gfn_to_gpa(data->u.shared_info.gfn),
> > > -					     PAGE_SIZE);
> > > +			if (data->u.shared_info.hva == 0) {
> > 
> > I know I said I don't care about the KVM Xen ABI, but I still think using '0' as
> > "invalid" is ridiculous.
> > 
> 
> With the benefit of some sleep, I'm wondering why 0 is a 'ridiculous'
> invalid value for a *virtual* address? Surely it's essentially a numerical
> cast of the canonically invalid NULL pointer?

It's legal to mmap() virtual address '0', albeit not by default:

  config DEFAULT_MMAP_MIN_ADDR
	int "Low address space to protect from user allocation"
	depends on MMU
	default 4096
	help
	  This is the portion of low virtual memory which should be protected
	  from userspace allocation.  Keeping a user from writing to low pages
	  can help reduce the impact of kernel NULL pointer bugs.

	  For most ppc64 and x86 users with lots of address space
	  a value of 65536 is reasonable and should cause no problems.
	  On arm and other archs it should not be higher than 32768.
	  Programs which use vm86 functionality or have some need to map
	  this low address space will need CAP_SYS_RAWIO or disable this
	  protection by setting the value to 0.

	  This value can be changed after boot using the
	  /proc/sys/vm/mmap_min_addr tunable.


Obviously it's equally ridiculous that userspace would ever mmap() '0' and pass
that as the shared_info, but given that this is x86-only, there are architecturally
illegal addresses that can be used, at least until Intel adds LA64 ;-)


Return-Path: <kvm+bounces-51695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80751AFBB71
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 21:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52657188E4A8
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC3626560A;
	Mon,  7 Jul 2025 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4CMcRYG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332219755B
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 19:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751915156; cv=none; b=S+mO7OFOQGCgz5FVaM6oYF7HWoHWTZqzBOoOX80HA+JFUp6HGqrl3+b690gGoa/aBUU6prvhqNqA1/vZD/iCXc7skVxaGEEN00cYOIMl6DJqqxriGGajgTcIzJRrd7Eom9S6jriN1p9kwHP7bFyen8hX1qKZifTJZK6qS9Dj3zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751915156; c=relaxed/simple;
	bh=yMgwCKIxG610MRf2ajtC7f/aqzm0jr6IT7X7XcBtSNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UoceRjuJ/FvzWLNoX6d+qiQGXCOvAR22aAO4PuXh18KdfwnMjjU7bn4uOC94kjYNlv9lN/cPa4s3Z60JP7+GGKt84UI74R/AoHDeMM+poUxvSZFGlyRjB+ppc3XAMBqgc6I5fvfYJRpLlayVOoc8IRGsgP50U2hmuglLxnlsejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4CMcRYG; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b185fba41so2765889b3a.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 12:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751915155; x=1752519955; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhnPibTiFpdOU0rxGQkwLUax6xi0Sb89X0hOrW81VOE=;
        b=L4CMcRYGGlj/Ujk4LA+0D37DP0zazrFQSdS9bYpGrQRGyrv4gjQWS5Vlb6WyhzNnwO
         h/aP16kaos9M+Lio3S0o8HWSd7gl2ASDKu/3gLgakmtXdvclEzGZv9QgOwpjvYUFO5fC
         p3sH+B5EBlKibTRDP6aO0uA5WUIwMv1stxZZZlDzwzHZhvgKLMbBQ5FpQmCYgUGjg/TP
         nXOQG9tk+ruA+AwO/u4gtI2OlokBJi/sz5nNXiyk/whdlS2/Q3y2aMAagnkxwaG4iNYM
         XL7yfdwSmAvRa5dEDx92K99lbZ+39ZDnej5vlmAbFiW/xScoIDOYYwJNsEtGoPHwzIM0
         qnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751915155; x=1752519955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhnPibTiFpdOU0rxGQkwLUax6xi0Sb89X0hOrW81VOE=;
        b=cdVg99bRen14jjlqwR0FvyDYYeUVfVyGkY9/ztPwiUBHVx8wdVJ3DliplpFREy/2qF
         KCcnjx+zxoaY441y3ctc1kDLmGsfwPBdHg9tsrau6/4AAcETA3Qju+yjwmKwsVsEHNl1
         eQYOPYkJjHlSbCeGfq38V9hYcaa75McIONmjFIG9QAGgnD3QvIaHw+mZ7LCGWZNCnShg
         Vt8O04zPwrE1bjj/mM225/IbX7FuxnKOZNLmAM7O4ZRS5FLnyBgux8WuKMvJawOi9ggr
         PSLLkamylp6gj0hXd2LCMVNsFQuzb1L61cyfVBuFAD76nn0cAGgbUJbV6SPavTE1u37y
         /1hw==
X-Forwarded-Encrypted: i=1; AJvYcCVdnPRhcFHFoDPiH2au/2wsAPa40FD9zd1wFKIRHsjspEqJq5vu8w0SKPmdW5IlroQtnhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzEMseyG437Gfu+EJ1ryomm2Ws6QWf/yt0OWIsP4nofRyyRxtP
	66AWTgcLWDvQLKQGSzX1G7Y5T8yxyuO0cIUhfyonJJ+HMKNpYAJxTsnE8xenDJfNdSfW9dR3u+4
	ciXyAgg==
X-Google-Smtp-Source: AGHT+IEBQH7ZAAioHEOJOcMTVuu8EoOLPcu5RnHuohgxSMP6k/swZ2jlTt5pK3I3H0WX2gK7DOSf8TnWxNs=
X-Received: from pfbeq4.prod.google.com ([2002:a05:6a00:37c4:b0:746:683a:6104])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c94:b0:748:2fa4:14c0
 with SMTP id d2e1a72fcca58-74d24513e6bmr508036b3a.0.1751915154684; Mon, 07
 Jul 2025 12:05:54 -0700 (PDT)
Date: Mon, 7 Jul 2025 12:05:53 -0700
In-Reply-To: <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com> <20250701150500.3a4001e9@fedora> <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
Message-ID: <aGwakUTUQ7ZxYlUe@google.com>
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Alexandre Chartre <alexandre.chartre@oracle.com>, 
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org, 
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 01, 2025, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 01, 2025 at 03:05:00PM +0200, Igor Mammedov wrote:
> > On Tue, 1 Jul 2025 20:36:43 +0800
> > Zhao Liu <zhao1.liu@intel.com> wrote:
> > 
> > > On Tue, Jul 01, 2025 at 07:12:44PM +0800, Xiaoyao Li wrote:
> > > > Date: Tue, 1 Jul 2025 19:12:44 +0800
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised
> > > >  on AMD
> > > > 
> > > > On 7/1/2025 6:26 PM, Zhao Liu wrote:  
> > > > > > unless it was explicitly requested by the user.  
> > > > > But this could still break Windows, just like issue #3001, which enables
> > > > > arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> > > > > turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> > > > > value would even break something.
> > > > > 
> > > > > So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> > > > > that it is purely emulated, and is (maybe?) harmful.  
> > > > 
> > > > It is because Windows adds wrong code. So it breaks itself and it's just the
> > > > regression of Windows.  
> > > 
> > > Could you please tell me what the Windows's wrong code is? And what's
> > > wrong when someone is following the hardware spec?
> > 
> > the reason is that it's reserved on AMD hence software shouldn't even try
> > to use it or make any decisions based on that.
> > 
> > 
> > PS:
> > on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
> > guest would actually complicate QEMU for no big reason.
> 
> The guest is not misbehaving. It is following the spec.
> > 
> > Also
> > KVM does do have plenty of such code, and it's not actively preventing guests from using it.
> > Given that KVM is not welcoming such change, I think QEMU shouldn't do that either.
> 
> Because KVM maintainer does not want to touch the guest ABI. He agrees
> this is a bug.

No, I agreed that KVM's behavior is pointless, annoying, and odd[*].  I do not
agree that KVM's behavior is an outright bug.

[*] https://lore.kernel.org/all/aF1S2EIJWN47zLDG@google.com


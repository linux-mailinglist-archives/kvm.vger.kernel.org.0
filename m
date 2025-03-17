Return-Path: <kvm+bounces-41259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2F3A6596F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 053703AD667
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6BA204C16;
	Mon, 17 Mar 2025 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G3Y6SovF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1017F20371F
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230408; cv=none; b=XsT99Qcsj45tjonq4z2+LI/6YeLmlNDVbD57J11IYmE6ccfVinJhUtD4V1M0mJj/k1XPmXXSXLVJtwsiGZ/z1Z+6jso6ZGHmK6gp/e96fDlQYXAfVH1IrAN6ldfYKafHk1We/32wQ2XPLQUNqd7GAWGKhCLKcVDFUlu4NwVnbgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230408; c=relaxed/simple;
	bh=qXnVOgqYG1FQiAJ7DrIUcFxKM+SXGAYFBrMi0yRhVLE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBNzCRvsWlWAxwp0Tb6BVEPjqrdf6X0JXKFbapSwSkbAChpfJCN8gKsCTJsv/BfZma1CEoljmUPtXXZ3UsDNylsVGdR6B98qtuE7/M+msWACdOII9+9RD48LKcjB4LsAuip5pbFzOfceL5GhNF0B3NvPp570193Mxa3wViHue48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G3Y6SovF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff5296726fso6735857a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742230406; x=1742835206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v444Ih8Wrl3P9CM41VrD5YikquTct6TP/BZ+x7IqEJw=;
        b=G3Y6SovF+SS2UXIOsTCgWKScWPrmOHoD9kfv6i5s2qv3KL2EO545T4qI0XeA9mJJlx
         YlqWGkPuqSMwIkDxFjZUNzKIsj2uiVgsqhDQpeekpXMb5VgOOlCuGblSc7nYGvwAH7uj
         MzyLDXaeoc4OIZDzMYz2OeArIqOOH1giH87UMAGHQCsKpLSLKpnL0OfOqQDMhg9zrEoH
         XOdlf28YV1+vZzrPmdbzTJ6S0fEuUQwJLd8p2LVumexoI3FDGkppoBkzveE15BnajrDm
         wmrgHN5pXLr6RQyFH9D2tbs3LKfYKkoB29mCBBCiw+Rc/0ZAo7wt1lucSTDE3pmx9p5N
         DPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230406; x=1742835206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v444Ih8Wrl3P9CM41VrD5YikquTct6TP/BZ+x7IqEJw=;
        b=DYym/sQMvuPo66eyn7eXTjSo6hudZFrI49+TxR3UhViDY7S9cjv4EDPu2cfu/KcMFX
         p5zy8pPTgskFn0PJCN0/mPeaDl0nrPEA/EC1oYvhgrpOJfO760ghTQ1P6XpxMsy7MYUG
         8iWHNiElsk6bUpwptXyVOJbZZgRV1OfTZ6fyyXFFoE7zse0TtOO8xDzZn96rUYYvVtr2
         WYbd/uY2shFERsWl/+nS+h260htcBjnFruKxcKRLF818sWBk+TKuV6xpkx2+rYim/z2+
         09WcqX6Y3AI3IAySGtLbH9L7ffHYEnt8NbfRXvP/Q1d3p/fU1SROUhmk5ioIlplc/LPf
         u6Pw==
X-Forwarded-Encrypted: i=1; AJvYcCUE4kmldacNx17biUiU+PUivln+exLFQsTcev9Nvg9b+8YbID61Z6K5kMDPiH3yaAWebmw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfR2L2jY418lzE7PLNjdWgzCGY/WGxrd9MrbIfHsOP4KUehoML
	6dDpqhJSzkwelsSs8hb9deKoA+HsX8/b3s/nVSR1z23uuvS6oJZ2GOBDCO3ygLtdmbIA14xHf42
	QKw==
X-Google-Smtp-Source: AGHT+IFOoYATiC/rIu32xRtF+lQHMNYL63/M8Ury4RfsKkWn2hqTxV2zJEn9dcXHvExkZwAcFk/2LTNCnBE=
X-Received: from pgvo23.prod.google.com ([2002:a65:6157:0:b0:ad5:45a5:644c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3397:b0:1f5:769a:a4b2
 with SMTP id adf61e73a8af0-1fa4428f019mr428693637.17.1742230406330; Mon, 17
 Mar 2025 09:53:26 -0700 (PDT)
Date: Mon, 17 Mar 2025 09:53:24 -0700
In-Reply-To: <87wmcn4x78.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com> <20250315030630.2371712-3-seanjc@google.com>
 <87wmcn4x78.ffs@tglx>
Message-ID: <Z9hThFNFrrbXjkjc@google.com>
Subject: Re: [PATCH 2/8] x86/irq: Track if IRQ was found in PIR during initial
 loop (to load PIR vals)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 17, 2025, Thomas Gleixner wrote:
> On Fri, Mar 14 2025 at 20:06, Sean Christopherson wrote:
> > @@ -409,25 +409,28 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
> >  {
> >  	int i, vec = FIRST_EXTERNAL_VECTOR;
> >  	unsigned long pir_copy[4];
> > -	bool handled = false;
> > +	bool found_irq = false;
> >  
> > -	for (i = 0; i < 4; i++)
> > +	for (i = 0; i < 4; i++) {
> >  		pir_copy[i] = READ_ONCE(pir[i]);
> > +		if (pir_copy[i])
> > +			found_irq = true;
> > +	}
> 
> That's four extra conditional branches. You can avoid them completely. See
> delta patch below.

Huh.  gcc elides the conditional branches when computing found_irq regardless of
the approach; the JEs in the changelog are from skipping the XCHG.

But clang-14 does not.  I'll slot this in.

Thanks!


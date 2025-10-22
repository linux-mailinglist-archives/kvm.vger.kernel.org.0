Return-Path: <kvm+bounces-60837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C011BFCC87
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51B02188F0A1
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3B234CFCE;
	Wed, 22 Oct 2025 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eE5VupDt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48901322A2E
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145586; cv=none; b=VzbL7++r5MIGZ24eNg/kJbr78Uu092oQ/8lBP7IFHR+c9HcUwBvWu6KbrPwYY7eyV2AKNR8XATKvwXlOgMPFdrO2o5+PipkudTsrMTnC/xbTsJZeR+FFDJyFKYYKYpOL/8R9h74oGcaU/gMcp/wbHRHyf83wYZvU+Ogj/QMHcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145586; c=relaxed/simple;
	bh=WpipEQJXVYcFkpkRLqzSzEcCHbasdGEjiXt0RvDq5AE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YMoUfdDw/gsXbj5jOugFWqQDFiLzuGZh+TBvqlS5PJ6Lh3yx2EXf2Ap8JJ/Ih2K9Q104xUF++8znAbCAR8pRWudV9aUCZdtYBICBWrj9TQkO/r4O+wxZf5WWyfT9hWvsdLvSciBGFw7nDkZOyBSpNTtS0ub5Qc31FFKHqBpJT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eE5VupDt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso7853550a91.1
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761145584; x=1761750384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mbNHPrOmzWNWm5K2/uwLb5lW4ecWkzdO5AE+PIr0iHg=;
        b=eE5VupDt/WhVRJP5hN/zTaP42o3Pe8X6O/KEm0etamHRKlKjzZklaSIcX0F01+3Ez3
         JcBu7M2Ummif1ulPt95Sjs1tHCLOMx0X9Ijhdp3ABzNa49daxr5gywEZxAgb3WM6oPkA
         T6lLAgb3Retog9XYarieLqaMTmfyMf22OzoFQFipp1WoQz/dcOlWfnG1FzbUzBhHDoHC
         a9naMVIAsL0Xj4oLuBWU50vo6R3K7GlClR+EYgPfLeLhZb5DHHpcjuTWtJ6huF/hbR7i
         2AzWPLo6efBRkiQ/e2FY8YmhIfooSd0lKTh3uJjpUh809xSVsjtOcHZEKKxrLoa+Sy/a
         AN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145584; x=1761750384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbNHPrOmzWNWm5K2/uwLb5lW4ecWkzdO5AE+PIr0iHg=;
        b=FciZVvOPrn0n63b935gLnbAj9dnv5IOaXZej9FocTNUJrpHu+q1pRbqx3WOOZadJhK
         zCKNeShvrr+2DFU6hLIqSC8+8zYLyE2/Lro8WLU8vIFQ8MX4UzYri+TumdAXaOgzqj8i
         Jlx3lqlOrrkZCT6LJ3maNdn1fAyR58vpP2SwW3bYOtkWPpMdBCng1gCqx+jMLEuoRGwL
         O/LEJwRipQ2sqjWkaBjhsbXjxPYrFaPrU2G8IlOD5LBH8C48eySGMZRWSgBRjaPLFbQ9
         oGnk5zFFra8HHz4jx42BEoc5zVNyG6CXWPPeFvI2vQf/1pT4UwWtndIu9nCiIpnUtw6J
         rIbg==
X-Forwarded-Encrypted: i=1; AJvYcCUGa/GLRDB3HpuvtNkbYo4+glZozH0jIBI0MZVAagfn7xDvwejhUBmXUsjxWIMXC9zizeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjEHqdQMjSa+TgMZEWnvCU8Rb28Rp+iQwYDIWM/Kj21bLPSvq8
	Pw8kHwQYJBEN4+PBjn9UduwLQuXRuzprrOu9qXs2N9ksMWTwtXQQR+adrwTHbW9xApX3pChwBW/
	7rKUcSg==
X-Google-Smtp-Source: AGHT+IGz5vCeuL6eg8BiHl+RDaAcDo1Jpgx/peM1TaCMEc8yk3bL7cPCwEmOI+HAuhAgN2IA8jgg5UzY0pE=
X-Received: from pjbbk16.prod.google.com ([2002:a17:90b:810:b0:32d:a4d4:bb17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2403:b0:33e:2d0f:4793
 with SMTP id 98e67ed59e1d1-33e2d0f5972mr2232790a91.11.1761145584675; Wed, 22
 Oct 2025 08:06:24 -0700 (PDT)
Date: Wed, 22 Oct 2025 08:06:23 -0700
In-Reply-To: <20251022013657.n2he5yabfgunm5vb@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-4-seanjc@google.com>
 <20251022013657.n2he5yabfgunm5vb@desk>
Message-ID: <aPjy72H6q3CH-BB1@google.com>
Subject: Re: [PATCH v3 3/4] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Pawan Gupta wrote:
> On Thu, Oct 16, 2025 at 01:04:16PM -0700, Sean Christopherson wrote:
> > @@ -302,6 +303,16 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
> >  	return 0;
> >  }
> >  
> > +static int vmx_setup_l1d_flush(void)
> > +{
> > +	/*
> > +	 * Hand the parameter mitigation value in which was stored in the pre
> > +	 * module init parser. If no parameter was given, it will contain
> > +	 * 'auto' which will be turned into the default 'cond' mitigation mode.
> > +	 */
> > +	return vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> 
> A likely typo here, it should be:
> 
> 	return __vmx_setup_l1d_flush(vmentry_l1d_flush_param);

Argh, I have a feeling I clobbered my branch with a --force push, as I remember
fixing this exact problem.  Or maybe I saw Brendan's struggles and thought, "hold
my beer!" :-D


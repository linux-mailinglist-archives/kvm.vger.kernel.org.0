Return-Path: <kvm+bounces-10977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A28DA871EAE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D991C24440
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E379F5A110;
	Tue,  5 Mar 2024 12:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BcQnRcUM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588147484
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 12:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640749; cv=none; b=Gs3+iN93cmWLAIGCOh7ecoPDQMz7JLUuMZENzkjIbWNGDCAlt6BEL7h+W8YW6wmgWvWB3vdQYhnNB87v4xUNi19jiRjr0AbGy5WslmmZX+KQnBNTHQ1IqO0AVGSmza2FIF40ugdD/JKY4b8/GecZCBsD2dc95b8OMRlasuUU48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640749; c=relaxed/simple;
	bh=ocMIsDhlS5WldfjDukI+u3DpHI4pPjCBjT49loOkVsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrVYB5VXmQC9X+3zEZIiVE0sV5E7aQrBqoOiLqbn9eH+KK2Pe4FztryBC9Necs3nYWgDS3I/eSdriWbr9JIe036OABEvmk0OOdRFf1XiU/4zXtK/e2BVLvIH7ydoyOwlhOaTt75ONVHFJ+fyMrHgukfj8oZWOeFps5rMSMa6PUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BcQnRcUM; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d27fef509eso79489891fa.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 04:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709640745; x=1710245545; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5m7gYDKto0sFQCZ782GSun8unKW9cIcfeVFfoYHYElE=;
        b=BcQnRcUMVgmVGzlL57LCww0DbqJ5HIE7Jxss4YB7RW8g+JTeHwu6R/Lav5+i85KmhE
         bzEx31oRm2rcFu+nnRcSuYN5tronlW2LIryEZiDRB8kPXUGZCHZsxYwDomVDCfCUJx/4
         YxXaYenVaqp5yDUfbljIYP1GW7xZra71EuJmcDNMP4rAWLOEfWbUfH0Ucd24VMlDhHE9
         gIFnTKRju9lgV9LlvFE/4KEc1n2Y97wv2VfAzG7VPobRHppuHxJOUZjCvJsN3dhPljMM
         O+BrXbIpxKldSUKASAIhiKv1yjWnOMTTyMm3vZ2RB5pZWpG7Oxu1efqN6IrmQmBfqzeL
         ChUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640745; x=1710245545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5m7gYDKto0sFQCZ782GSun8unKW9cIcfeVFfoYHYElE=;
        b=qMDHaQF1sbALCOroifZjMwum+82xwXFYTI5ExlDQe956iXTBrtYCEQYwi5Hagaqore
         YnFHXcHz6sH0YPyDO9wN+qaL9mBg3W+Az5luRAPUf27aks8zjdjMKRtrYbHWRDAWwf2G
         Wr3YiWK40r/jp7GCeLCJxrfvb0Se0v6FUQOvcYdBnLG0VP4mlh0wDfxF3DKGaJoQcoA9
         +rL2xkUcth3sPDfvvfPL7vFVjglJwAlZIDBFKBxWp2+qS5TTvMvcwY9xWPOXShUj4qm+
         0lfMne33kfL5ZyFmlvv7j/YLDEpvx72+t4R29N1s4KhLJyWT/Yrb/XtRcYAgEr1Ac3Gw
         YZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxxUpnHYh/MP4GTB2P51B1iuiwShLHb4SL5LGXvUb3b+1LgZHUcSd6tRXjo9rjZDAzGZuqQIhilRZijnzG7njBFBpU
X-Gm-Message-State: AOJu0Yy7qVhqVEkQGahkLP1QNL5Q/Mx46Xf2tlVzQSILWCnJqry7FNDs
	tZrLPFDob2AjI9RAueELCj0zxN1h4B6ptgLBJ38Irbx0dttqg5u3XiPq2sxvB58=
X-Google-Smtp-Source: AGHT+IGD7Z2QBwGwn4YryjUN6znpGI3JV/UOun2bVjCoidWV/1/p0sKcqoMZxU2kw7bIWMzf+PXSuw==
X-Received: by 2002:a2e:300d:0:b0:2d2:9b77:6e38 with SMTP id w13-20020a2e300d000000b002d29b776e38mr1074386ljw.27.1709640745431;
        Tue, 05 Mar 2024 04:12:25 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v29-20020a50a45d000000b005649f17558bsm6021422edb.42.2024.03.05.04.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 04:12:25 -0800 (PST)
Date: Tue, 5 Mar 2024 13:12:24 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Laurent Vivier <lvivier@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
Message-ID: <20240305-7ef885812bb2490a8110f301@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <CZLGGDYWE8P0.VKR8WWH6B6LM@wheely>
 <542716d5-2db2-4bba-9c58-f5fa32b22d52@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542716d5-2db2-4bba-9c58-f5fa32b22d52@redhat.com>

On Tue, Mar 05, 2024 at 07:26:18AM +0100, Thomas Huth wrote:
> On 05/03/2024 03.19, Nicholas Piggin wrote:
> > On Fri Mar 1, 2024 at 10:41 PM AEST, Thomas Huth wrote:
> > > On 26/02/2024 11.12, Nicholas Piggin wrote:
> > > > Add basic testing of various kinds of interrupts, machine check,
> > > > page fault, illegal, decrementer, trace, syscall, etc.
> > > > 
> > > > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > > > can be incorrectly set to 0.
> > > 
> > > Two questions out of curiosity:
> > > 
> > > Any chance that this could be fixed easily in QEMU?
> > 
> > Yes I have a fix on the mailing list. It should get into 9.0 and
> > probably stable.
> 
> Ok, then it's IMHO not worth the effort to make the k-u-t work around this
> bug in older QEMU versions.
> 
> > > Or is there a way to detect TCG from within the test? (for example, we have
> > > a host_is_tcg() function for s390x so we can e.g. use report_xfail() for
> > > tests that are known to fail on TCG there)
> > 
> > I do have a half-done patch which adds exactly this.
> > 
> > One (minor) annoyance is that it doesn't seem possible to detect QEMU
> > version to add workarounds. E.g., we would like to test the fixed
> > functionality, but older qemu should not. Maybe that's going too much
> > into a rabbit hole. We *could* put a QEMU version into device tree
> > to deal with this though...
> 
> No, let's better not do this - hardwired version checks are often a bad
> idea, e.g. when a bug is in QEMU 8.0.0 and 8.1.0, it could be fixed in 8.0.1
> and then it could get really messy with the version checks...
>

We've tried to address this type of issue (but for KVM, so kernel versions
instead of QEMU versions) in the past by inventing the errata framework,
which is based on environment variables. Instead of checking for versions,
we check for a hash (which is just the commit hash of the fix). While we
do guess that the fix is present by version number, it can always be
manually set as present as well. In any case, the test is simply skipped
when the errata environment variable isn't present, so in the worst case
we lose some coverage we could have had, but the rest of the tests still
complete and we don't get the same failures over and over. An example of
its use is in arm/psci.c. Look for the ERRATA() calls.

We could extend the errata framework for QEMU/TCG. We just need to add
another bit of data to the errata.txt file for it to know it should
check QEMU versions instead of kernel versions for those errata. We can
also ignore the errata framework and just create the errata environment
variable which would by 'n' by default now and later, after distros have
fixes, it could be changed to 'y'.

Thanks,
drew


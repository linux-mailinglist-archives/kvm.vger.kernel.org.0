Return-Path: <kvm+bounces-48104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EE0AC9288
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 17:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98ABC1C07931
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 15:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659B122C331;
	Fri, 30 May 2025 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EQeGUojl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3032EFBF0
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748618857; cv=none; b=gPX83nBcuCskAcNoTUKWI3Bdi7MBNqv95UD1mjzIO5aP4vYR5Z9+EDLq5fJVm0/ZNSMDwGv4HHTHYD03jhfT39ehBvl1JWBGvGALYO7hpqGqguorPCS56ZKpXW0cA7Vs9k6WvnCzPsv3F15x22Ff1s0HlTE7kCVtC+edZAE7WAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748618857; c=relaxed/simple;
	bh=WcNEdB+8zbRQTpD8U/gv3Wn2Hj7GpqHPo9eX0YJXCjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ok84D2y6dJq5DJ7XFfyKpxy0jYezOP3IKDM+kh48AR6pb3mqxA92QoLyge/RbUHXCpUD+fuWexGfXIgdahGR2pTenDv200naNy2OLY0fw0mIqjVsWgZ5bcyOE4QYyTfjISpWPNHmix16jq2GXc0bWACpEWD/lreNZ90BuYtxYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EQeGUojl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73c09e99069so2381638b3a.0
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748618855; x=1749223655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dlcZF9D4z/NfsF/j8DhS5iN3JAihcxF+Hr9AiRnC8o0=;
        b=EQeGUojlh6gPlHKBEYwU/BidiJAuuYwn+uRqjVl0WPZJShg83qG2jfMqAUfoqK75nU
         jBIcMnBzKdd1Dgcium+D3FnEnNWniLwM7UoDeaK+6K0RsQppGtdwtFWnficTIh9x+J0S
         BUAl+UVPNYf56o8n7arklneYJJF104vKubnJRTmxZlimyp310nUNTvbPfemPwKx1EZ/X
         2q4k98uIDs0n8c+u5sa5Fu60bbh0TeRTopdq2T48gZ7wwbhVQRazkvwH3g7vjRTlMQTa
         /1AKUEpCh9T67UkyQGSzLDIHXCTu8LK8c9gLsmYlcSwyOvOMAAnyn9aLcHf2eFmKwtUQ
         6IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748618855; x=1749223655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dlcZF9D4z/NfsF/j8DhS5iN3JAihcxF+Hr9AiRnC8o0=;
        b=pgozYMu3KqfThsn6/7NuRGNRpk+KtZRtgD8lquWWCGsupVn9z8PabLcPZSfysuoEhG
         N5FFsa/LanS4dFO+9kEa6rFxHBwah+J4muEWxlKKbmrFPRtZ5CDFMiqUiJZHyKk5tTZQ
         lQQ3CGi8GcbETzZZy8i6imbSFi4mNY4qgOutVQIVYvbsfiywqditJGqtqa+zeahcKFHE
         kCbFqUp9QrGw7A04wBivDSC2lc42EPRnUzqS00C7SnVV4oLb0tlvWjrygTzPapzu7KOL
         5iyTEaVUqYxKwPQJW5tbdClFJjz96hbPqNsKj0MIZgWEDf3KduZYkz9PnNxpVDlsXBzX
         K76w==
X-Forwarded-Encrypted: i=1; AJvYcCXRggxU4jpJ2J2ve5xQETZ3NHszrE1Ilpo0V5jkdfILet2b5smYTCSa3iyeLCkEbrPgBkw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ3TWBJf0TOQFALtt3UHwGyyljaRPlQJF5kbSWig4ZHfXi6k+F
	bh7hgRshGJcwC5N1mvVyvQ4B2Njx1YugKDHl7+8Luqq/B9itlsq/TFpeDkSkF39hkmQxMub01Bz
	Gwe4n8Q==
X-Google-Smtp-Source: AGHT+IEBBzs51D4oN5kbQO9IB+f8uk70SsiK24ocSmhrJGHiy/reojLOvzP1I2RPVHzHsSxUxb8DhHIiegk=
X-Received: from pfbit20.prod.google.com ([2002:a05:6a00:4594:b0:746:21fd:3f7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d1d:b0:737:678d:fb66
 with SMTP id d2e1a72fcca58-747bd94c561mr4980787b3a.5.1748618855396; Fri, 30
 May 2025 08:27:35 -0700 (PDT)
Date: Fri, 30 May 2025 08:27:33 -0700
In-Reply-To: <20250530-4859709c9df9481d6897a818@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529205820.3790330-1-seanjc@google.com> <20250530-4859709c9df9481d6897a818@orel>
Message-ID: <aDnOZc9FS59AV3pH@google.com>
Subject: Re: [kvm-unit-tests PATCH] runtime: Skip tests if the target "kernel"
 file doesn't exist
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Andrew Jones wrote:
> On Thu, May 29, 2025 at 01:58:20PM -0700, Sean Christopherson wrote:
> > Skip the test if its target kernel/test file isn't available so that
> > skipping a test that isn't supported for a given config doesn't require
> > manually flagging the testcase in unittests.cfg.  This fixes "failures"
> > on x86 with CONFIG_EFI=y due to some tests not being built for EFI, but
> > not being annotated in x86/unittests.cfg.
> > 
> > Alternatively, testcases could be marked noefi (or efi-only), but that'd
> > require more manual effort, and there's no obvious advantage to doing so.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  scripts/runtime.bash | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index ee229631..a94d940d 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -150,6 +150,11 @@ function run()
> >          done
> >      fi
> >  
> > +    if [ ! -f "$kernel" ]; then
> > +        print_result "SKIP" $testname "" "Test file '$kernel' not found";
> > +        return 2;
> > +    fi
> > +
> 
> I see mkstandalone.sh already has something like this. There's still one
> other place, though, which is print_testname(). Should we filter tests
> from the listing that are missing their kernels?

Huh, TIL you can list testcases :-)

I would say no?  Because then listing testcases would depend on a successful
build, which would be annoying in a variety of scenarios.

It would also be weird to list testcases that are excluded based on e.g. arch,
but not list testcases that are effectively excluded via Makefile.


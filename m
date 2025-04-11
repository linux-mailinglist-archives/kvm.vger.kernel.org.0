Return-Path: <kvm+bounces-43150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6086A8584D
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 11:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E4837AD5D3
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 09:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4EF29899B;
	Fri, 11 Apr 2025 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="H6Bl+6Yn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968076125;
	Fri, 11 Apr 2025 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364768; cv=none; b=uCi6dYrUjgygyK7j3rC8fBv4nJQflQZS32yu8Q2oh8thJMG1rbIgiBEoNUjzfLvlP8uk4MOiRqe5lydVAjf11ogt2onDtOvNEnsq11DBiH2lYLJCktqTsebrtRkvJOayrYO0h25sl/NlJ32VWBH1RXk4d961fuNlV3THnaxup8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364768; c=relaxed/simple;
	bh=1RVik0NlfQSByh+MVGU2m8fVn3PKpjEfUQ8PK51vI3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5OXgwUaLqtZj6vlEYDO1l1jOMLAunFGGs6CzMRMdKqW0eGCeuXsLRDIoSsIjjZyVTmJacAMSb+nHpHcdjotq/MAbrnVLSymL57p19Il353ZJYPxw6IsY5zhzkId7cGtLfwW4omsMZjDxtADl/caFc7tcCJhfMrsSpduXC38LXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=H6Bl+6Yn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7961640E0244;
	Fri, 11 Apr 2025 09:46:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id r5D8zoiJXQKE; Fri, 11 Apr 2025 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744364759; bh=ayElILbyVh8//B/ihafKwcK06o8pVHIZiL8+eeH1q1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H6Bl+6YnOZ7oHDpjjH9I6xLEYfdi7fyVTrPlZPxWTGM6We8DXdvABPJ71+M4Xk+9u
	 LK12I1A+ZP3QAjFQyil6tFEAc66x8kQAUCjyu6oL/5RUftjBtwEHYoivaJL10bp988
	 IztDKABslaY3i4hus+2chG486EgFJZ0ZCXxmVNO42hTVLwcH7TYuw27k5awsJDeq+h
	 stbhRxUi95giNWd47hdlW6jb/uGjxrpnsxV+N4r0L6mrhRoKndPK6d65EB88EB9tR7
	 nGgAhZNWS9iMqEtaLWX2MxB4PwrVd60yrbPUTUIehnwehfVY27zGHfBLxcagamqEhQ
	 c2zJsH7zr/JEJRJ+lhhRaCkNOqhy24v0ynlDDs6LRWnEYkb5jlJ54By2/kkTxPkyar
	 CRFbY79Bht/75kb4b/+dTepW/hA0S8ZXy/ThOjFClww6Pv6f5UuMlzzvupc5VbU+3E
	 DSUlXUFvw+UvOdwbUG4eT8ZraAZ07WSvJc9kM9+zehjh6BjF1Zwu4XZ8oKwwGALFYj
	 6deRmuW1kK49j3AAiI0/+GaP727CCXwBYlVwzAKrN6Rcu74Wq9rJ4tXQRg2nrkxreo
	 a8d7Ag9MjzTdUCbnNn7NUm6UXxJekhUKhltJur3GPaHvpzlxwpAZKKpjgrcsetgfYk
	 Rqy2mYyfCmJOq7PtjVYBuWQM=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1258740E0243;
	Fri, 11 Apr 2025 09:45:53 +0000 (UTC)
Date: Fri, 11 Apr 2025 11:45:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
Message-ID: <20250411094551.GAZ_jkz8N2zDkkPbTt@fat_crate.local>
References: <20250324160617.15379-1-bp@kernel.org>
 <Z_g8Py8Ow85Uj6RT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z_g8Py8Ow85Uj6RT@google.com>

On Thu, Apr 10, 2025 at 02:46:39PM -0700, Sean Christopherson wrote:
> I'm going to skip these, as they aren't yet publicly documented,

https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip

> and there are patches proposed to add actual support.  I wouldn't care all
> that much if these didn't collide with Intel's version (the proposed patches
> name them AMD_FSxx).
>
> https://lore.kernel.org/all/20241204134345.189041-2-davydov-max@yandex-team.ru

Pff, I think the right thing to do is to detect those and when set, set the
Intel flags because they're basically the same.

Lemme go reply there.

... goes and replies...

> 
> >  		/* PrefetchCtlMsr */
> > -		F(WRMSR_XX_BASE_NS),
> > +		/* GpOnUserCpuid */
> > +		/* EPSF */
> 
> FWIW, this one's also not in the APM (though the only APM I can find is a year old),
> though it's in tools/x86/kcpuid.

See above. Yeah, the PPRs have them earlier than the APM.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


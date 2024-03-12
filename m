Return-Path: <kvm+bounces-11659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBD0879322
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 12:37:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D873B21ECA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 11:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD14879DAC;
	Tue, 12 Mar 2024 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Iz4mbxoD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4607A79B88
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710243436; cv=none; b=M7nvW9eqqmtHPguRUx+RQHuNg/T/CIU3q3ddfPm1NBf9g7MRLwc4xSw2+msbYo/8GwqptE+fy/J0Z9PqjmulLNhTkfw/jPre25rdb8Zd5TW9wV41zQKjq4J4I5tOGGjRTYOIo/JMkogICUTRhRuirMTyGluwXqK0Ck9cKeKxg10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710243436; c=relaxed/simple;
	bh=chTrwZT8NXVLEUa2dl9y+6TkJvt3TzokccqUDxIBNRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+Kqt42tBfskiIqVhjsFsvXaECYH+SEcALB6R0c7QASnQRrFTG1VAxc2xk4k7Z7NuP6Mcbn6Ha9o10xn2WvouzjeQhxwsnBqB3OsKbccojoHW618hZxeAvcEY7cWVIOxAsLrNh75WIt2yQcw2pSfzP8rGkTNJUaQTvoh5th87Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Iz4mbxoD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-413385f1a0dso2710435e9.2
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 04:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1710243432; x=1710848232; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CtMvBGNct3U2PHqGOqTZ5d7CNu5qscq89UTxpK7rfY=;
        b=Iz4mbxoDbJYgqOKtPPOMuYaFzbMf0oa/2bVk2VTxBv3PG2IpQSpAajxNSlGrwOYcjj
         PC9HuyEmksUgB0NrFcsBuq218wgsH9/aDeX2fqdi+sRgT6WULywMmxbAPz2OhibVfNbT
         SxDFWK46+/yD2Ir0uqiSeN8zS5sZfOYXM8A0M0BliYaqW3KanGnsqNpFOupNbJBULE7y
         oxifhEn0t1BfGKsJw3355lNooDYDMbg18hKj1CF9mZJDXYNITVu+jctUlqB3Ymiwvnez
         JeI7p4kCSWVi03WHCq6D0BKRCNIMMpQ/Npj/J8BCvFf8EXosOD9/6dEMdwCkdDCGprVH
         AowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710243432; x=1710848232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CtMvBGNct3U2PHqGOqTZ5d7CNu5qscq89UTxpK7rfY=;
        b=Akx0ge84UmJLLCpry+LkDCntzgUsybQQskDnmGjZ92iPgV2HF9ym63g4W4uahtZI1Q
         zhPbFUTd+uKXQMLO726UHnA97bcFmqJ7k1nREdAf5JTLhaGttkR6i71QUbxbYnyfxATV
         LpjoHkt7Xn4hY0/wx1MicCwSdH0ySv0NTTP5PUmQeyY45s/PVBS4nrN245ddKeIzdNss
         nYO9SABcOcMG/WpbEfrcIen2x8invqtL4/GFdD2YlbouVhVjc528uDweYs74/wmq8Zt5
         Zbf5+OtVnYxMjMRD4TIEH3pLXm15u+30dlznVkS6JMDRuRHZyfc7zPb797F5+ZEgQea7
         WADg==
X-Forwarded-Encrypted: i=1; AJvYcCWu+E5RorVHPQRZTPOuWL0W8b4L8Jfs1vUk5PGfKvjEyq1jFeV9lF48J0sB608LgyaClbcS+qEJ+iWZBCM9DiPMV1PQ
X-Gm-Message-State: AOJu0YxWuY6JEW3iYyk+psMHdK32SfBBGpu6PUFDd7+0fjnCTRaTX7rM
	fMvB4+smH51udAxtoMdl8XP009nZ3NJGx2D+sBzzMqoE4RweGZQi1lpnDphjR4I=
X-Google-Smtp-Source: AGHT+IF6YmXYt56LuY92XqYmAeNeE1eeoVAMg8whc3qew24PgYFEgyRtZb4xlxe/pOZ0Brkc8FeWAg==
X-Received: by 2002:a05:600c:4991:b0:413:194d:12c6 with SMTP id h17-20020a05600c499100b00413194d12c6mr6797808wmp.23.1710243432446;
        Tue, 12 Mar 2024 04:37:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id r13-20020a05600c458d00b00413429bfab0sm1363579wmo.16.2024.03.12.04.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 04:37:12 -0700 (PDT)
Date: Tue, 12 Mar 2024 12:37:11 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org
Subject: Re: kernel selftest max_guest_memory_test fails when using more that
 256 vCPUs
Message-ID: <20240312-0334bd56a139b40ffec19772@orel>
References: <f39788063fc3e63edb8ba0490ff17ed8cb6598da.camel@redhat.com>
 <Ze-cPqZDXnF-FEXj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ze-cPqZDXnF-FEXj@google.com>

On Mon, Mar 11, 2024 at 05:05:18PM -0700, Sean Christopherson wrote:
> On Mon, Mar 11, 2024, mlevitsk@redhat.com wrote:
> > Hi,
> > 
> > Recently I debugged a failure of this selftest and this is what is happening:
> > 
> > For each vCPU this test runs the guest till it does the ucall, then it resets
> > all the vCPU registers to their initial values (including RIP) and runs the guest again.
> > I don't know if this is needed.
> > 
> > What happens however is that ucall code allocates the ucall struct prior to calling the host,
> > and then expects the host to resume the guest, at which point the guest frees the struct.
> > 
> > However since the host manually resets the guest registers, the code that frees the ucall struct
> > is never reached and thus the ucall struct is leaked.
> > 
> > Currently ucall code has a pool of KVM_MAX_VCPUS (512) objects, thus if the test is run with more
> > than 256 vCPUs, the pool is exhausted and the test fails.
> > 
> > So either we need to:
> >   - add a way to manually free the ucall struct for such tests from the host side.
> 
> Part of me wants to do something along these lines, as every GUEST_DONE() and
> failed GUEST_ASSERT() is "leaking" a ucall structure.  But practically speaking,
> freeing a ucall structure from anywhere except the vCPU context is bound to cause
> more problems than it solves.

Yes, ideally the host could clobber guest registers, or do whatever it
likes, without having to consider how it impacts the guest's ability
to manage the test. I.e. the guest code should be more the "software
under test" than the "test software", but kvm selftests blurs the line
between test code and tested code all the time, so freeing ucall objects
is just one more case of that.

> 
> >   - remove the manual reset of the vCPUs register state from this test and
> >   instead put the guest code in while(1) {} loop.
> 
> Definitely this one.

I agree.

> IIRC, the only reason I stuffed registers in the test was
> because I was trying to force MMU reloads.  I can't think of any reason why a
> simple infinite loop in the guest wouldn't work.  I'm pretty sure this is all
> that's needed?
> 
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> index 6628dc4dda89..5f9950f41313 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -22,10 +22,12 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  {
>         uint64_t gpa;
>  
> -       for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> -               *((volatile uint64_t *)gpa) = gpa;
> +       for (;;) {
> +               for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> +                       *((volatile uint64_t *)gpa) = gpa;
>  
> -       GUEST_DONE();
> +               GUEST_DONE();

I'd change this to a GUEST_SYNC(0), since the infinite loop otherwise
contradicts the "done-ness".

Thanks,
drew


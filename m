Return-Path: <kvm+bounces-7540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B928439DD
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFD40B2990E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6B169DF9;
	Wed, 31 Jan 2024 08:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RJXUKUI+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD24669DF0
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 08:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706690986; cv=none; b=XUSoduTNBN/F3W8mzpsZkUIRRbGcuNLFbrqrf7CnztUad6uKGqBiQY8iHUYRn/e/8Q4KupcU/7E5qG5a172j7+UT0KtBWN0qXfqG2Wq1+EmvVEbnMApLRRbzlS4ykCWxGOTUVU5aob2FYai/wbNpr9vU9YRNeUv7VIru+n/vWvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706690986; c=relaxed/simple;
	bh=cp6hObYP6vO3TLjZQhgbViQN59Nd01J+jfFWB5Rty3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZpraeT2jFwLSOag2YQVKJv828+h+xKqXHhNWHQKDv59h5mVBDsyMV4HXRJOkrW/92oElAVonDJ+T3Olc5FdebXSbH96yXh37l9bgairbyc1WTBxanTeePzEdETd4a64NnXn4HrZWQa2htU68wqvR/OB/yd4uDJrYqkNk2qn0cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RJXUKUI+; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a271a28aeb4so620113966b.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1706690982; x=1707295782; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwrF8m8GQsGFceTJh31l3SS1YmhpII4/27Snk+jZIFo=;
        b=RJXUKUI+JoA9PBRfguwu7G3apZtgBRW2CcHiY7C1BHFGG2diIg/oCPU41PdTGTMWru
         fxldOr8KtnPH3Oedch//uoVDPO3P8275M0ZeGIzNaXbndwgj7ap5Xm97KfZNHxo2NTpk
         KkL2XIvdG4KQ+ZM22sAzMfU0ZDsh8c90kDUHMPVei7X95qSwSvP+O4zjSAyCgGjWq/0h
         92xd9/rcfpUfjTK5VusNosQ1FcDpwBrXCdkw+WcoBraK9LaQ3SE++WHJygxK7lrgnHsT
         40tY2pwpNKWXV9CMEYYWGYO+T2ldUFhng8Cbb3wny1QR9+J6UnNYdRFuX97aL9SwUcXx
         RHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706690982; x=1707295782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwrF8m8GQsGFceTJh31l3SS1YmhpII4/27Snk+jZIFo=;
        b=mLQjBM3vqO2TSoleZ9KDQYzn9b3U3hStrcSqsPP8Op+NdVLYy9JZiVsJfd3uu8yqZt
         Mh/DJ40GoB+JaJV+F/3BbDzVOJu6A/GU5CsIMNpMlqNMcfNtEtvbjrjvmozPVNIhVLqf
         xcy9AbwbabpyhAjdF9dQSjdRQJKauanekTBITBaFOjoxfkl/1ILy5d0ssa7hJd+cIxXJ
         +99WSo60ipba2bbGBcp1FTDzncEfSyNx60aJFZbx3MGWx7f7Xi2W69hMP9aNN2yBXhwj
         eDkE7BFTeZGYWfjWg284WUjowOdBYz76Zr8JvCr/T0zRMbMH1DvBglBFT3Z++rlAQTXb
         jT0Q==
X-Gm-Message-State: AOJu0YwDuFMuqHornQjSI5f0CL+CtUxF5NEHYsGy+PaI7Oye7pIuPIIc
	SNSEwcD+cFxsc5xM9rvo9OZ4gKT+EUQ48rbK7lsnRz2J2ZcBiLDeiGW2JtIiEE4=
X-Google-Smtp-Source: AGHT+IG59LQFPP5uvyfMTy1OF+ECx5mfRwwnUh01lCUMG3TenERfKODeoOZBRnXKky/WMQTQPIKPwA==
X-Received: by 2002:a17:906:48ca:b0:a35:1f1a:ca50 with SMTP id d10-20020a17090648ca00b00a351f1aca50mr647395ejt.11.1706690982080;
        Wed, 31 Jan 2024 00:49:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c2-20020a170906170200b00a33604d2a41sm5953449eje.132.2024.01.31.00.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 00:49:41 -0800 (PST)
Date: Wed, 31 Jan 2024 09:49:40 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Subject: Re: Re: [PATCH 5/5] KVM: selftests: x86_64: Remove redundant newlines
Message-ID: <20240131-aaad2df64c2f26b892623006@orel>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
 <20231206170241.82801-12-ajones@ventanamicro.com>
 <ZblbcUloeMqc-lR0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZblbcUloeMqc-lR0@google.com>

On Tue, Jan 30, 2024 at 12:26:25PM -0800, Sean Christopherson wrote:
> On Wed, Dec 06, 2023, Andrew Jones wrote:
> > @@ -162,7 +162,7 @@ static void check_clocksource(void)
> >  		goto out;
> >  	}
> >  
> > -	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> > +	TEST_ASSERT(!strncmp(clk_name, "tsc", st.st_size),
> 
> This newline is functionally necessary.  It's in the strncmp() (*#$@ sysfs appends
> newlines to everything), not the TEST_ASSERT message.  I'll give you a pass and
> fixup when applying since I'm guessing you don't have x86 hardware ;-)

Thanks for the fixup!

> 
> I double checked the other arch patches and didn't see anything sneaky like this.

And for the double check!

drew


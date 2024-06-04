Return-Path: <kvm+bounces-18795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 471E98FB7EF
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 17:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0120E2847D8
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012081494BB;
	Tue,  4 Jun 2024 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c16QxdAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D713D27F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516091; cv=none; b=VNslL+Yz3L1m5xXWcFXt18tv+hzkaTfTi8DDprTOIRA+Vt0J/VJZdH4+HHpniu3NvJwGgErYGyjXIonUsfDXJEzHEhubRj0/1q472hxUzZhmPkCgP/IEgjHcjc43jYAGP02H6RayOtkvpgtkC0zQ9RuLtW3LupydinuHen96ISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516091; c=relaxed/simple;
	bh=9jijODcLLa4zmqRhqLOhK+fqQf2gqdWVamK0zwZspgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OC+UK8FwYLp/r6Abc93mFFVBSzHL3ozK+uSsf12+kN8Mgug5How3U/lSBMiP9/Xtk82ytjaQmqY26bhMFH11JbuRIqMW2o18w0QhJmUysMXyI3UsVVoLYbjWa7LQJbwd/zDceygtH7HJRRViS4COqtI1bDJRO+QakSvYow4Lk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c16QxdAg; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57a20ccafc6so5312122a12.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 08:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516088; x=1718120888; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VI9QUYhV/KkiBFZad3q1F1Q6NWjZ0fGxKdlSAnXosBY=;
        b=c16QxdAgTwan51NlkphDs9PHZnwktKbJnmBuz+C4JPN1kmFz2eyex6DbEMcsO1JigK
         PYNTKA2dEID/QL2WSJKFwwxVltSjPueQ38Hjkzr7KDoFBuSZct4UtxF2hzKtrrRswlxW
         VJa+3fn+oSI8kxAlyC51UN2Sd6XZ28IrIE8+sHpPKryYms1t71z5KvYscymR0Y8efCN5
         b8idlUINoZPL324MHk7NJjkEMcl3HsJDoT2f3N7OUBnygMusZnjpFvVUwOI/eQZOWOM8
         bicQAzOsh317/Wh8wKP+z5qGQHx3I2doslWtycYIQg8hgPKlHZeKH2TD6NKHITHhk8LJ
         p1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516088; x=1718120888;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VI9QUYhV/KkiBFZad3q1F1Q6NWjZ0fGxKdlSAnXosBY=;
        b=BVHvg1QlUqV3TG/JHxdCYS9+csplz9ZNBzos2gYiW/eN607wqcJHdHL5OMgMle13dk
         YljRLNC0u4TiUh2hmxkAn7SzBGOCDSut41GR0Gq7mXTWI90gLVm563FEoX3dLfS99tys
         q4en6PfW2I82flNrsO1aRWTozkNJ/2EKDQ2if8GJYPLoOzKoEay2RtfkWxT82ef7ESWY
         z2yI2fTD6+vmIdM5AGW1hNnRbMqVbwsnnU90yPQ0wizBawSHfHARF1+80FfsV2PdlJBf
         iE1LBwdNZmEQphDQwamRbvVDxgdkzlG/ORii41WePbSxHP5jRaeGwXl6qiitA5vyCXo7
         YWeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeuxUpLJ4vPywGIFRBNIAvHsPZ03p2pkLZsFeefXIP5taobqqBU52kQIr2eFL02UYQ8e26VgKW3f6t9YYj9haVRZJl
X-Gm-Message-State: AOJu0YzalF0URLUyuZ9Wsny8cqMoxpvjuEhgmYMnrmNCwnq9OdcLhKUu
	Z5XI7/lq26uDN+SvuzJrM2DwN1WUNQJmvzTGyeEeRTDe6FFd4/6nG7PjwnuR4g==
X-Google-Smtp-Source: AGHT+IFcdEOYIUvsNwOkrvSmA4o8vKrkPn2u1Z8aKrnP0GmKz+XZvtUMn7cgz/gxbmln8PCFDViBGA==
X-Received: by 2002:a50:a455:0:b0:578:6c3e:3b8f with SMTP id 4fb4d7f45d1cf-57a8b67c37fmr23084a12.2.1717516087560;
        Tue, 04 Jun 2024 08:48:07 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31be52b5sm7673564a12.49.2024.06.04.08.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:48:06 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:48:02 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic
 path
Message-ID: <qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-4-ptosi@google.com>
 <20240603143030.GD19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603143030.GD19151@willie-the-truck>

Hi Will,

Thanks for the review; I will make sure to Cc you on v5, with your Acked-by.

On Mon, Jun 03, 2024 at 03:30:30PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:09PM +0100, Pierre-Clément Tosi wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 135cfb294ee5..71fb311b4c0e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
> >  	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
> >  	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
> >  
> > -	/* If a guest is loaded, panic out of it. */
> > -	stp	x0, x1, [sp, #-16]!
> > -	get_loaded_vcpu x0, x1
> > -	cbnz	x0, __guest_exit_panic
> > -	add	sp, sp, #16
> 
> I think this is actually dead code and we should just remove it. AFAICT,
> invalid_host_el2_vect is only used for the host vectors and the loaded
> vCPU will always be NULL, so this is pointless. set_loaded_vcpu() is
> only called by the low-level guest entry/exit code and with the guest
> EL2 vectors installed.

This is correct.

> > -
> >  	/*
> >  	 * The panic may not be clean if the exception is taken before the host
> >  	 * context has been saved by __host_exit or after the hyp context has
> >  	 * been partially clobbered by __host_enter.
> >  	 */
> > -	b	hyp_panic
> > +	stp	x0, x1, [sp, #-16]!
> > +	b	__guest_exit_panic
> 
> In which case, this should just be:
> 
> 	add	sp, sp, #16
> 	b	hyp_panic
> 
> Did I miss something?

Jumping to hyp_panic directly makes sense.

However, this patch keeps jumping to __guest_exit_panic() to prepare for the
kCFI changes as having a single point where all handlers (from various vectors)
panicking from assembly end up before branching to C turns out to be very
convenient for hooking in the kCFI handler (e.g.  when saving the registers, to
be parsed from C). I also didn't want to modify the same code twice in the
series and found it easier to limit the scope of this commit to a minimum by
following the existing code and keeping the same branch target.

With this in mind, please confirm if you still prefer this fix to jump to
hyp_panic directly (knowing the branch will be modified again in the series).

Also, I don't get why the 'add sp, sp, #16' is needed; what is it undoing?

Thanks,

Pierre


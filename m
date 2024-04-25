Return-Path: <kvm+bounces-15969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D258B2962
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EE6E28553C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48780152DE7;
	Thu, 25 Apr 2024 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeCouqSp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAE152511
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 20:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714075517; cv=none; b=olZhs2Emm4KSiqESvioWjj4Lg/X1pCQFxUKhXz+ey4Nd6EVlTJARvDJOyfCCAxLBHV02eL7klMLaQZxxY6AgPr9ZAvBLTcsSC9Fu2EPg8MbXuAjFyjMV/j232HI6wDzS0iCsgoNb1zdwInU3jc8w12Pofn43fHHIsL+abgFWerA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714075517; c=relaxed/simple;
	bh=bOvbZhiEqyjPuBLJVqqXLJ1Croua5lZNvydmJoGnPsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdleydfk+2UemS6yXknYbI1jU5yw6nwAZKKk4NnyZlvvTlogl5A3oWcTo/dvhHkqn06drV6Sffctub+6bF2/bOXdsuUuVycElpgALBmTbNQwOZZG0U4q/mNfZGhxXa1s5HnO5iz4f1XSgP0xEKZEQQX98/623X5cWVdDEkHlcvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jeCouqSp; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so814391a12.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714075515; x=1714680315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+PUsYcEhIl7NFBcQl5HzjdmNkUqr5Lezi51boZCbK0=;
        b=jeCouqSpRhvJwODGTeNuQVI72a5SIBVLAceLu6LqOOfDExi39tHXQ7WA9XrUF/U7dZ
         KBJDUqj+IhooJsC+0S/nzwdJjvNplSy0c+RKtmmV/P287Pg3UZux7p5j9Wxf+SijXNUS
         0d3Nkm1JFtYDZA4aNLkVIFadPDGk9KE7ituQb9/h1MxacfdVxfIipYuULbWiPkHmx/3x
         92qNxIbVeuMbo6Hv56eS0VqSx11DzPiHLvOZVuLtDpbqRBuMzc1zmd3oN/p0Btvpywc2
         XHKn1v44vhQ+N5OaW56kYU2/zODNZuPgSq+bRTiQAEKTPPnH99xRLGWVuovhQfRRRHuU
         1ALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714075515; x=1714680315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+PUsYcEhIl7NFBcQl5HzjdmNkUqr5Lezi51boZCbK0=;
        b=SsHelSvnczkZKj6CQdHug3AfkoqwXzZpisO7LPrYjmhE2h6irEIHZ1hJBOHck7E2Uv
         8K0cNNXoSp3IICOZzJuOi8hX6NfoYLaeeedGacPmbtRPLb1N42/tPhqKOBIq3gca+UB7
         gedPwDNZs2DbXKNCLyLcBtQ4PLcCq+GHgV1xF5irwoExq280dpGHQxH3a7v4loIaUnWb
         H2Z6JqBwQrloxS8z4utDQY7VRhZqKnOWVmuuGHNou4Vf8sI6kjeaaK+IVHwvRMT/IiW9
         ie/buVw+nb4uXvPOloltRC8UmvH7PMfC2irTogAqmEj6LT7eciknir0SR0kOBlBZ39DW
         V8gg==
X-Forwarded-Encrypted: i=1; AJvYcCX4UnMabCgwnpLc+L9aE1ZqTrVLFFgI82KitXJLzdH6lKeH+ob2jxvoiI2zmuRgvVzEwjWdVYNKGnE9qwg9XOEklxK7
X-Gm-Message-State: AOJu0YxPbuRHDqhxofQ+ubxx84mwkUYeQERpJlxeEMvM+qfpPo4GAJih
	jYKE+j8t7MQgkid7ch7iSV/tQE9PEC6m2u+kf4AIzLDtmu/XT82WCEUgohqYQA==
X-Google-Smtp-Source: AGHT+IFosj66byr4ut0fALOOpnjmuEai2jHYsC5+5DIu9RrCn3tv054jH5EGtKA8eFg9knNPeC7v4w==
X-Received: by 2002:a17:90a:f286:b0:29b:c0a5:1143 with SMTP id fs6-20020a17090af28600b0029bc0a51143mr624336pjb.29.1714075515031;
        Thu, 25 Apr 2024 13:05:15 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a114200b002a533330849sm14731777pje.16.2024.04.25.13.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 13:05:14 -0700 (PDT)
Date: Thu, 25 Apr 2024 20:05:10 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: rananta@google.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Fix testing failure in x86/msr
Message-ID: <Ziq3ZJP4kEOaDYR9@google.com>
References: <20240417232906.3057638-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417232906.3057638-1-mizhang@google.com>

On Wed, Apr 17, 2024, Mingwei Zhang wrote:
> Fixing failures in x86/msr for skylake on MSR_IA32_FLUSH_CMD. All code
> suggested by Sean. Thanks for the help.
> 

gentle ping on this?

> v1: https://lore.kernel.org/all/20240415172542.1830566-1-mizhang@google.com/
> 
> 
> Mingwei Zhang (2):
>   x86: Add FEP support on read/write register instructions
>   x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM
>     emulation
> 
>  lib/x86/desc.h      | 30 ++++++++++++++++++++++++------
>  lib/x86/processor.h | 18 ++++++++++++++----
>  x86/msr.c           | 17 +++++++++++++++--
>  3 files changed, 53 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 7b0147ea57dc29ba844f5b60393a0639e55e88af
> -- 
> 2.44.0.683.g7961c838ac-goog
> 


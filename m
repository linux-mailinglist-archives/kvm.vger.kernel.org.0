Return-Path: <kvm+bounces-50907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2FFAEA86B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 448477AF708
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5920C24A06F;
	Thu, 26 Jun 2025 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y1CVIriL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC01F9F7A
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750971012; cv=none; b=eoFESq4JNBagLqJf2x6Y+QNXlpEcmaNfHlDtgxtGTDqunB4kjJUVZOuI46lfdl8oLuGzTz9TCmrTYhYhLc+NBx8nm+Yv6W2FVYHGwm19KAIY+AbcGt0IIoZdtlgjtr9bs3THRyvw2q2tgWiVxlWiAIzl8hQu/A3QQoQNbis59MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750971012; c=relaxed/simple;
	bh=0B+GG0V9IxayHUjd+GrM2c+j6iCMSNSpCAoduPtwMhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K+67bEanl5MeDk++kVb/Q33STx6JFSgzskB+Z22IFmEcNPDj7OmaWu9Q7TpdcpDqaREnrG1Zf9QMBbGsi/WQgA53DWR/atKmmgssbI9o9WnLvQZxlqAklEGL+PVmF66/3s5iaJtm1g2lpsdbQiQBapnLGWzFTIxso7+NBqzegX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y1CVIriL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747ddba7c90so1082216b3a.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750971010; x=1751575810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7OlW39s6ulMaqljMLUWDij/EiBowAxWTwHoPBioqCw=;
        b=Y1CVIriLkNaBw/viUcGDvDPqlnb6Ndw5HFsEvPS4yLBLaFTA23gRPhG7LHIPCwyVUi
         Pl9N9JbOGEsqMSnW7U1x0NxKf+ty+TstREp73gJ/VneRX8hDBjELX9yOkXejNnFPH9bn
         88mDUs7tf0pZfn78JNm344qfphLB6uF+UvsjQHSg404Fyni8sOSqm8liehzc053Lqxtp
         Yh8jQCf40KD6xq7FmruAPFW8nj3lKdIdYw0qHOlALStpLX2XBuQ+DJxPqJ58TbbzUFep
         RNFr7SA0FV7BUBujccTXW1peOaHEvujOTrHH/dEnlzciufHhNEzs3ruGfo91/E7Zso3c
         E2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750971010; x=1751575810;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C7OlW39s6ulMaqljMLUWDij/EiBowAxWTwHoPBioqCw=;
        b=EJCKeWcELE5kZrhFYQDRyoVLDoqVT0G+BYxbAUOgh+AsyqTIUW7hJ8XuPnCp3y+88Z
         ERrKTWVnGy2eaQcmS4DHLZ5BgWVGkcHO6/0gDnyRTzbsBvamxYH1NWJcFlHFhO3ift8X
         gjZavurTRsBKJlxY4tNp6egK2JyE8hp02j2zhY+EryEaesQhhgRSEt6OAm0TCfV6+psl
         QGvW0h7LGgxg2Mltjjq7qJUBcNf4gynrczMlpiLybOnmBmqUd7tYoMLay0aVS6UoLjv6
         25OoTMbRJlfiKHxcVKrWhvohLHIol3fZxTt+DpE/zgjmeQqcQ5EbV0lJJpWDhIDVJrbQ
         ohVA==
X-Forwarded-Encrypted: i=1; AJvYcCWJEgNmhk8Z1KB3LQLi3tCOErd+77NKJSNGQQS6JNkXk5Y2L1g1oOhw13Tb7fiGvWFybHg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn0OuXLvd+FFqUTsbY6EPTfWR+QGP4ApRwHj0GensiChJpo/kX
	W4ASlAh4+ulWS1ix5LMNNQhzhT5wAFtbH/aXkoLpsAeCI+ogjgI5tP8GpxXCjgYl1wDVOlG+up8
	FKmDwdg==
X-Google-Smtp-Source: AGHT+IEvqZwxFHUi+bQpaauJGtY8KGrib3OUPRdkSaQ6XydD6Sn6vov8+Sgs49EQUuL4CN8i3MDM/JPkMv0=
X-Received: from pfbdo6.prod.google.com ([2002:a05:6a00:4a06:b0:749:1d32:aa78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e1e:b0:748:2eb7:8cc7
 with SMTP id d2e1a72fcca58-74af6f79db6mr649612b3a.21.1750971010693; Thu, 26
 Jun 2025 13:50:10 -0700 (PDT)
Date: Thu, 26 Jun 2025 13:50:09 -0700
In-Reply-To: <003b5de7-502c-47ba-ae46-0905ee467384@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-9-xin@zytor.com>
 <aFrR5Nk1Ge3_ApWy@google.com> <858a3c30-08ab-4b9b-b74c-a3917a247841@zytor.com>
 <003b5de7-502c-47ba-ae46-0905ee467384@zytor.com>
Message-ID: <aF2ygVI8MN5IrAcg@google.com>
Subject: Re: [PATCH v4 08/19] KVM: VMX: Add support for FRED context save/restore
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025, Xin Li wrote:
> On 6/25/2025 10:18 AM, Xin Li wrote:
> > >=20
> > > Maybe add helpers to deal with the preemption stuff?=C2=A0 Oh, never
> > > mind, FRED
> >=20
> > This is a good idea.
> >=20
> > Do you want to upstream the following patch?
>=20
> As I have almost done addressing your comments in my local repo, just
> sent out the patch.

Saw it, and the LKGS patch.  I'm OOO for a week, so I probably won't get th=
em
applied for a couple weeks.

Thanks!


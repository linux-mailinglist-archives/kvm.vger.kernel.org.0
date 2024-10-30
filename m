Return-Path: <kvm+bounces-30071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665839B6B7C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B3D2283595
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA5A2144C8;
	Wed, 30 Oct 2024 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S1mG1TBC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC831EF0B0
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311029; cv=none; b=JCXGuI18qW6n87UQms9ECcnblukljNg1g7WabdJE/0xxRRY1Po+AfQPoSvILVh27ZvFSI7qoGsB13mesHcAlN6BTCU4xYbzHweWLk7NT4HPNCQZV9lpk+6J4Nz6R20FDXIRqhq6EGQFJthkI2H2MF4wnxiZvxc2Jip4Do78QcCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311029; c=relaxed/simple;
	bh=HXbZbbEbISWZDvCQL2LRu8qBoXGWfihRMp1PGTLERlA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=giSi0MC+bakCjm+F6CIxXEga14kwA7NOQQrd6FDJ1aijA4K55sHmwVaaUJ/PEBxz4lEkhUZnlaqAhebiMS7/iAaCz+cSznJFG46AePeVR8CeNuP4B2sHTBRw83PxTHMgYEUYVNNkdmBMlE9aI9bJg0puLTnMRwmP5pG+X/cKVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S1mG1TBC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea33aad097so14076817b3.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 10:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730311025; x=1730915825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Js0851Wg/yN4BQPMb8zIhsnP1AdasvixqJsqtfPfy8=;
        b=S1mG1TBCpJXphib/kmXkuqCxlsxoPJyuMwCFIKRYBgNR1YdIA3G4tS6Y33fKDCQ0eV
         rh7f9CDC4/zRzpwrn82rM8ePXG8SYqFgQSI4+Kd5pmMCHeduhcPg25Cp58KNXYXw7CS8
         MTeiZUZSg66sbFZXVFJgPwelCUvr1091HxQI2rOZgYpzXgGHuZAZuDHDTAalxP9Fx/09
         kyHfyEXwO3KkQu+my9qbPBjN5cKtQGtH0KY18K3f4ge3vOvxEeChdzaBABqhZF/npeUH
         wBFL+TDsFlQVTAftn86CkqlMtu9sAqyHYiebjGFLt66ToqZy4PUelICv+b54fSlz/2r5
         yULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730311025; x=1730915825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Js0851Wg/yN4BQPMb8zIhsnP1AdasvixqJsqtfPfy8=;
        b=SwV1uTycI+UsHOEYrtqa7jmbzNW0i15F0QQDAO2hKpRWlO36lsubIleYqPU4KZ7z4u
         Q961pYvlHTyumIdksYMaeHMHzWOAUI8Dapthk6kskjDvOLmRsSKTO3LZjQwMxQbL20TG
         Ci4jQull12hbdxeO80sxWZip2+F8Jx5L5VPWWAzdV2Vm40XQYAj4aqMqTl6cuB5kpd8d
         XzRJuVcz32hOVzI2sB39KdW8q9JfFT47/6gydNZVq+FWd4qPM/Y2Ysidu/fdKj7QwS8M
         Q3rxW8XeIX8tlDfrkq4qzT3HmR4ilz9lrpVqEHUdojcm02k5d06ecO5lpKGB2joMfvN0
         dFfA==
X-Gm-Message-State: AOJu0YzkxgQIIgtAFoly5T8S4vVwn3fzDROPhCwvK/fDn4sbA4uZr1WR
	uhCre7ejCh/gGHTiKB1099lCYd72mK8D0r5SAS77NAF31sB7Ul7f5H2Y6t9ZJnX1r+rMoTzv6wZ
	hpA==
X-Google-Smtp-Source: AGHT+IEYu76tmgovzI1MJ4Q0ogjcSHvzLY7LpCf9XIb8Oyf3mLX6BXz6eqH4rINu/IoBsyC7/Or/ksRFTcQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ad5b:0:b0:e30:b89f:e3d with SMTP id
 3f1490d57ef6-e30d51da951mr62418276.1.1730311025650; Wed, 30 Oct 2024 10:57:05
 -0700 (PDT)
Date: Wed, 30 Oct 2024 10:57:04 -0700
In-Reply-To: <de2a6758-a906-4dc0-b481-6ce73aba24b9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com>
 <20240905124107.6954-3-pratikrajesh.sampat@amd.com> <Zw2fW2AJU-_Yi5U6@google.com>
 <4984cba7-427a-4065-9fcc-97b9f67163ed@amd.com> <Zx_QJJ1iAYewvP-k@google.com>
 <71f0fb41-d5a7-450b-ba47-ad6c39dce586@amd.com> <ZyI4cRLsaTQ3FMk7@google.com> <de2a6758-a906-4dc0-b481-6ce73aba24b9@amd.com>
Message-ID: <ZyJzcOCPJstrumbE@google.com>
Subject: Re: [PATCH v3 2/9] KVM: selftests: Add a basic SNP smoke test
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 30, 2024, Pratik R. Sampat wrote:
> On 10/30/2024 8:46 AM, Sean Christopherson wrote:
> > +/* Minimum firmware version required for the SEV-SNP support */
> > +#define SNP_FW_REQ_VER_MAJOR   1
> > +#define SNP_FW_REQ_VER_MINOR   51
> > 
> > Side topic, why are these hardcoded?  And where did they come from?  If they're
> > arbitrary KVM selftests values, make that super duper clear.
> 
> Well, it's not entirely arbitrary. This was the version that SNP GA'd
> with first so that kind of became the minimum required version needed.
> 
> I think the only place we've documented this is here -
> https://github.com/AMDESE/AMDSEV/tree/snp-latest?tab=readme-ov-file#upgrade-sev-firmware.
> 
> Maybe, I can modify the comment above to say something like -
> Minimum general availability release firmware required for SEV-SNP support.

Hmm, so if AMD says SNP is only supported for firmware version >= 1.51, why on
earth is that not checked and enforced by the kernel?  Relying on userspace to
not crash the host (or worse) because of unsupported firmware is not a winning
strategy.


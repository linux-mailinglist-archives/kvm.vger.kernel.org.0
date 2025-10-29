Return-Path: <kvm+bounces-61409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5CDC1C402
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 17:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7B80B34B9FE
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 16:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38252F5484;
	Wed, 29 Oct 2025 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNnaS3Dr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC991A9F84
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 16:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761756760; cv=none; b=Ac8GehG081rONCe7oxZu4SmAUfFpVmNTXI2MDAHX6gqdLRKnppmKOwLxNdbK1R419MO4fERDNOdYjdlQ4MB6QzQW6douj0HY1Sd6yt0VdzjsFU9UMRL/KTMVe4C+VpX2zQDYFRxBTtEZ9fwYGRNeVeBmGHrMmLcnANQlhTV/d9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761756760; c=relaxed/simple;
	bh=E+mHz391F1PKa0dHF1fPVCJltjtoUNF5ywFNqc8qzdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imOYCafeieZQQ30U/i+T0zAxJZTvsIa0bzuyr/IhXvbPv61jyb+RNsJJ1KVb8HkG+iz1as3Uc+IxYAb7lR+3ES0E9NJcxP0T/ds+m14Kr5NeHFCrgLdtxTFv5CoK9yiUMAboJrDlpH8k35gi+lUBAx6ywspBw+TzNzGIGg6wLmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GNnaS3Dr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso80985a91.1
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 09:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761756758; x=1762361558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pJaZ6v3LnnDXyCDb6O2FHtrylN6ssw7lLK2BEb22MyI=;
        b=GNnaS3DrDcjWEfDx0LOHpD7PvMWQvS622vyDWsYQFyW27Q1UrH2nydf87A2dGs4dUj
         CtlhDVyO+4vyDWq4PHZb/Ojo5QTm8rc8Nbz7Ts1a6/YkZ0PkXXBGaWtxiwfmDnA4GrLz
         ctym0A8fB9tI/XqMBUPWmn85I3hmodjchilt/wB3iR4RPkXg1YzmMf3vDUPoHtEVj6MR
         0pQACWQfZdw3vIlIBIiZwCwLB3VVkUE0wgROsOz8lJwXmCGLaaxYifZH0oKsj8vzp9Eq
         5fLglw9qoerTX1b4/sArFKFDnm7qszX6LODLQHvbUY2NGNVkFzkNYtCjFUDbdTSSBHxA
         17KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761756758; x=1762361558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJaZ6v3LnnDXyCDb6O2FHtrylN6ssw7lLK2BEb22MyI=;
        b=wddXiS8t3t1LdbIiXvdGFygu6ijOwNZww7kNG3b6KSnCnQpTwPz8Kw35LMztTqW0HO
         kCP+3nnQRrmPE2lYICKuKKd2n5puME8Vfa5HvCnOy+8Mj4uXS/OcCCARz7wRU9MPd+D5
         pZ26toyFOtPY8JUhGGdBmn8XLfkbaxbSk/UJ6NfOYoetT9P+YOwOStRlcXDJuOhj/DUm
         OJxcTNsGns6SnLswGV5cGj5+bFlhbCXXkvaKF8ht4YBwVEfKZ6WPTpWSxezVMOlS8Urh
         fUuRk39f2B83gSUF8QKN8CGUB4LJHDh3xrovJB4TsR8ASt+dGtYGjbUOtNrqBHr7b882
         DOYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPtjPz3GK5KGl7t5fJcJOsWGD5Q8t+w6Zik3jZyDpyAwe8x09zxcO9zTwID1ztH19gkWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwknbymIMqeKeVjVonetVDiSSJIV5UYQyT97ZqqU5yTWOr9uYcQ
	+OPcd+l/AIunVMikTxvt8PJbGzFfHhRs3jywJ7tTPBtfHUcD/C8HzvzXT1pjiLGaZM9mjvCUop7
	jkfLDkw==
X-Google-Smtp-Source: AGHT+IEmYwXdXNcwE/12EZu7TdnOXWTJBAUGBEQ2ODPWawgLQu8EBueu2LQM0rkCqaX+3inPNPOfUM6gFyM=
X-Received: from pjbbt5.prod.google.com ([2002:a17:90a:f005:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288a:b0:32e:7270:94aa
 with SMTP id 98e67ed59e1d1-3403a2a1f3amr3825350a91.19.1761756757889; Wed, 29
 Oct 2025 09:52:37 -0700 (PDT)
Date: Wed, 29 Oct 2025 09:52:36 -0700
In-Reply-To: <0a327c8d-c8a2-4b73-9231-bc5201e36e1e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029055753.5742-1-nikunj@amd.com> <aQIdgeaeQ0wzGUz7@google.com>
 <0a327c8d-c8a2-4b73-9231-bc5201e36e1e@amd.com>
Message-ID: <aQJGVDSQruEooAE5@google.com>
Subject: Re: [PATCH] KVM: SVM: Add module parameter to control SEV-SNP Secure
 TSC feature
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Tom Lendacky wrote:
> On 10/29/25 08:58, Sean Christopherson wrote:
> > On Wed, Oct 29, 2025, Nikunj A Dadhania wrote:
> >> Add a module parameter secure_tsc to allow control of the SEV-SNP Secure
> >> TSC feature at module load time, providing administrators with the ability
> >> to disable Secure TSC support even when the hardware and kernel support it.
> > 
> > Why?
> 
> That's on me. Based on the debug_swap parameter I thought we wanted to
> be able to control all SEV features that are advertised and thought this
> was just missed for Secure TSC. I'm good with not adding it we don't
> need to do that.

DebugSwap was one big mistake.  At this point, I think we can and should rip out
its module param.

Commit d1f85fbe836e ("KVM: SEV: Enable data breakpoints in SEV-ES") goofed by not
adding a way for the userspace VMM to control the feature.  Functionally, that was
fine, but it broke attestation signatures because SEV_FEATURES are included in the
signature.

Commit 5abf6dceb066 ("SEV: disable SEV-ES DebugSwap by default") fixed that issue,
but the underlying flaw of userspace not having a way to control SEV_FEATURES was
still there.

That flaw was addressed by commit 4f5defae7089 ("KVM: SEV: introduce KVM_SEV_INIT2
operation"), and so then 4dd5ecacb9a4 ("KVM: SEV: allow SEV-ES DebugSwap again")
re-enabled DebugSwap by default.

Now that the dust is settled, the module param doesn't serve any meaningful purpose.


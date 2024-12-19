Return-Path: <kvm+bounces-34163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4BE9F7DDB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E464167337
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E545226175;
	Thu, 19 Dec 2024 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKXcP/mL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229D9224887
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734621606; cv=none; b=DpQ1S2POkGLe9N7jGPp/mOapV4hXIvbth53IPN2sCwErGXTSigANI3v4PAT8ZwYQ3lzTqnUdAJfQOwCT9fuC+Z8jgte3FeJ4JGMBjMBEjJd1EVLzCpYh30DCl90JW5ShhyvEIfoI0DhRrfKZi964c1q0aMyfivmtUWmEHJVRm+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734621606; c=relaxed/simple;
	bh=b/b6r6b/COseRN02rYeAj1TZ2F8d2AxJIGmqaMlv6uU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H7VO2Zla0XJTzti7wyyp5/Hg0pleSPstAQQM9mQJmbaoDmilEPpXwRAvt5OcdGkFl+rzIY3GMFbY5Q+CbbPc4fPSO0SE/URtqm14thxjH9QXMTgAS7CNA9LMvuSYJJW65ic8quHplZkPkktsOJRZpp1Xy6CqZJMqtftyY7o8LD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKXcP/mL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fcb7afb4e1so862428a12.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734621604; x=1735226404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFayNOW4b1jyIMCl98EpM1xSihyyfKaX8YnLIZw5b2g=;
        b=sKXcP/mLRevloY4k9IH9doanv/dNPnm343f7qRxL8NmwKNoy0aY/XdwdTlt2ex+opQ
         Jz+3MoPUBtS7Wts5mvnP1WZGPnWfxZ+M82ryNxUotfe629gTmTNYS9ldWFTppHiD39/X
         M8CnEUI3ZjVHX5aS0U7hKhHXio6vYNI4QwZDVnlObRa04DJ5OSrNtor4f07H29IEIOCv
         CR+e9M0IUSA78Mjh+Y2aVF0epGb0l8gYqKO1MlZfpQf1uVAXpjD+RKBljFbqeLs6Dfug
         rD3R03vo/y6bPibrFheER7tY4jiBl3Ps5MgUUXebeykPGzSU/B5CiyTOlTZCnFFUqIyo
         NElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734621604; x=1735226404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFayNOW4b1jyIMCl98EpM1xSihyyfKaX8YnLIZw5b2g=;
        b=qZhOBgGPDZQoOTmY5/8krhcfIhg21a4UscjGIjb5/N/5U5f9LsWqaqSuju3+qBbw0/
         xBtMUk+5tPI4DOUbrwYeZmQBvy7WXYfT7yeFoEFxDrmNr+lJWPO3sd4lzwblJsiYp6xQ
         Et66MhJLKkgVB9Rs3nneC5BDw//LzCjgmVRtBwCHcuLKU5pZix/NzOpwPKtZT/SmcsQI
         1l09d5boXPBeSrS6r368z7SdP7pMaJYK7usGlpTV7j8a4EEiP3QXfjgzVU6jdXsqsisr
         jk1pHAd/YS9jEX3ABpVIYa/csOuoEtjAWD8K9/T9KDbY22KhNaPalCKx4iOPsTos3T9Z
         IYCg==
X-Gm-Message-State: AOJu0YxGVmfjWBUUqIRPv/oJM2S6CCjca7Rv8jM5w6I9Qnka0SvJ9G+r
	rgEbcTDxYKKrkSHSRA4ErtfJRJ7iaWGQTj0+4Tvl5IFB0JR6guvnknqAlTzv6Pfu63EAaEttGlo
	wsQ==
X-Google-Smtp-Source: AGHT+IHWv5oKAY/0CIJF6KIKdjzGfI9ldz228nqoFj9Fjpq7z1K1R6o7J6SudZI7DItFZ9NpcfuUqPKohSc=
X-Received: from pglr14.prod.google.com ([2002:a63:514e:0:b0:7fd:4ce4:e9e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1643:b0:1e1:afa9:d397
 with SMTP id adf61e73a8af0-1e5b48067demr13046226637.15.1734621604301; Thu, 19
 Dec 2024 07:20:04 -0800 (PST)
Date: Thu, 19 Dec 2024 07:20:02 -0800
In-Reply-To: <c20368b8-ef6b-4be5-b9c6-46a577564f79@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211172952.1477605-1-seanjc@google.com> <173457547595.3295170.16244454188182708227.b4-ty@google.com>
 <c20368b8-ef6b-4be5-b9c6-46a577564f79@redhat.com>
Message-ID: <Z2Q5ovivF849OPcZ@google.com>
Subject: Re: [PATCH] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Simon Pilkington <simonp.git@mailbox.org>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 19, 2024, Paolo Bonzini wrote:
> On 12/19/24 03:40, Sean Christopherson wrote:
> > On Wed, 11 Dec 2024 09:29:52 -0800, Sean Christopherson wrote:
> > > Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
> > > for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
> > > in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
> > > nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
> > > it exists_.
> > > 
> > > KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
> > > underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
> > > to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
> > > the desired/correct behavior without any additional action (the guest's
> > > value is never stuffed into hardware).  And having LFENCE be serializing
> > > even when it's not _required_ to be is a-ok from a functional perspective.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 fixes, thanks!
> > 
> > [1/1] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
> >        https://github.com/kvm-x86/linux/commit/2778c9a4687d
> 
> Oh, I missed this!  I assume you're going to send me a pull request today or
> tomorrow?

Yep, I'll get it to you today.


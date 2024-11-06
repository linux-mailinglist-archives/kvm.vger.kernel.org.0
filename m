Return-Path: <kvm+bounces-30972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C10D69BF1CF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 591E7284DDA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D836020127C;
	Wed,  6 Nov 2024 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pL4T9+o0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A280318CC15
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907319; cv=none; b=QTvdqAbDV2gqnaR90es5XtU+qLhiBKxqxjtTsGz73FwRR2RIQ6V97J1Yzi6EfJl0YWa18GVGxKwFAzf/TpdhVpI2qjackqWf5aSCJg3RylsnRfvac4HvvlXsdA55wXlUpAhFWSFN+z409rQLkODv2JL9CmQtW12lY3gw8mDhKBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907319; c=relaxed/simple;
	bh=BzMh/SkjF/vZhwo25zJAi8RA4wwY7ojx5tSTsjGDWMQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N4L2tPKKPHmS2Gyssm3e378dyPIneH+N8bhfu0sman3xD+/Xq+vTIvtpbeTws9V13E2oyLXaOVxuoQEssQLfi5EVjYQaXpmVCPswTV1SOPjdgYR3HeokBqIh3rcwem0Ve8sLgct/i3Mt/hYD5N32Opmapae9OGSlEANgtqQw0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pL4T9+o0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e5bdb9244eso108260307b3.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730907316; x=1731512116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/yuAQmTAdCCAAaxxu5QbRxg4oOjJGHpnFzwE4CldcWU=;
        b=pL4T9+o0brGcw/QHzoU85hJtJ7RZz//gBFvuPkxZ4UME+7pqOFxvp//Leh6KdOx/jq
         OlS7SHxpOqT1VH6P4qpWyJQfReEm/2jVRkOEvMvVBLexV55rt707jgS50rp5Hdfngl0t
         /Ba92a6QM2PIlV39DCknXeaNmJ7SYFP8Gg8O7VArks8eiEZYQ5ReZ7FiSqZJxWk6FMxF
         yk0fhrbU4NyhL1d+a4TzIgVmtSY7MJXy0wtffNAoA5NoMx32rcK9B9eMfRzWHYzUnPN1
         Dpq17oLuJNB8oSDbyelpJ1SXwjUTcNq3gIZHlPqqtumartL/+wvUc+st5hRhBFAzf8lr
         r7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730907316; x=1731512116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/yuAQmTAdCCAAaxxu5QbRxg4oOjJGHpnFzwE4CldcWU=;
        b=S0V0YEiFFaIX7i5JM8SrEegWtZ3Tote48pysuFcYSX4gWGYQ+zg8oQWgmxDnI/Ha62
         Iu694X8GSQ5HB1OC2zEelYTYfYTKK4gJN5ooJNOb2nVW382OItsbtXZDEAGJrW/Z0JdG
         0Gkph+IqZunGXstTFCzKgPtrQ6h+2aKIaMYhGyS3fykNa2+fkFUYNzCCeFBtpGq3onws
         vG2hsTeriKt2FvT00rsF6u3/9GkHIfBc937TwDV5Gs74D8UUhT46xQrbQU129kGTfGcY
         Dvs2q8SzWIMHbBux1+YV5AnrVzcbG5TQY2HjQ1ZaGd0Z98omR7uBPu0jrC7C3xP0BQr3
         e5Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWynDwPK2CtuLab0D+OOcnUPdzKQmI6vd8ngKd4DHjuMy5w4YvXo1mQBEhlc7BJOJGtsf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb+1ys18mCiuFxmBiktrcav7vDBhBolS07jq6Sbv6iR54tIp/2
	IgGP70huZGZvBk7QReYgJvSodAYD6B8IOmZa+K0iuOWHoDjXXq9fL4pdKPUW0UQLV7G6/Sgp8rE
	0hA==
X-Google-Smtp-Source: AGHT+IHmNxgiraaP+U1uT1ChKSKhhI4xy7BUPpqdGKKVhBllQrZbqSbHpux9zDxuCCy+elXJIEPKqQ6aqPM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:25c7:b0:6e2:6f2:efc with SMTP id
 00721157ae682-6e9d8ad570amr9938387b3.5.1730907316561; Wed, 06 Nov 2024
 07:35:16 -0800 (PST)
Date: Wed, 6 Nov 2024 07:35:15 -0800
In-Reply-To: <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241104101543.31885-1-bp@kernel.org> <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local> <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local> <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local> <ZyuJQlZqLS6K8zN2@google.com>
 <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
Message-ID: <ZyuMsz5p26h_XbRR@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Borislav Petkov wrote:
> On Wed, Nov 06, 2024 at 07:20:34AM -0800, Sean Christopherson wrote:
> > I prefer to be To:/Cc:'d on any patches that touch files that are covered by
> > relevant MAINTAINERS entries.  IMO, pulling names/emails from git is useless noise
> > the vast majority of the time.
> 
> Huh, that's what I did!

You didn't though.  The original mail Cc'd kvm@, but neither Paolo nor I.

> Please run this patch through get_maintainer.pl and tell me who else I should
> have CCed.

  $ ./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nofixes -- <patch>
  Thomas Gleixner <tglx@linutronix.de>
  Ingo Molnar <mingo@redhat.com>
  Borislav Petkov <bp@alien8.de>
  Dave Hansen <dave.hansen@linux.intel.com>
  x86@kernel.org
  "H. Peter Anvin" <hpa@zytor.com>
  Peter Zijlstra <peterz@infradead.org>
  Josh Poimboeuf <jpoimboe@kernel.org>
  Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
  Sean Christopherson <seanjc@google.com>
  Paolo Bonzini <pbonzini@redhat.com>
  linux-kernel@vger.kernel.org
  kvm@vger.kernel.org

Versus the actual To + Cc:

  X86 ML <x86@kernel.org>
  Josh Poimboeuf <jpoimboe@redhat.com>,
  Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
  kvm@vger.kernel.org,
  LKML <linux-kernel@vger.kernel.org>,
  "Borislav Petkov (AMD)" <bp@alien8.de>


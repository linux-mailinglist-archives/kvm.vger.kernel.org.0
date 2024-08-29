Return-Path: <kvm+bounces-25367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE81E96490C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DA8C1C22B56
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD6C1B1429;
	Thu, 29 Aug 2024 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mQy7Re+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E916A931
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943020; cv=none; b=aPWh+VW4TWfkboQTunJXywQ+J/kY+cPqnj6aFwCCaotBSQERjmdZr8KjwnARX+HSb8cqAGctALlpLIQiQVXrlPUxDyqj1DjqT+kThqrX9mNr+OLw5kkEl7JBrbaCHBNT0BJtKeood3FCnuEatXaozxRSUQ4jwPxCU/t3VXmvmMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943020; c=relaxed/simple;
	bh=7owvFBq7H/zZo+uLT3Wf+SvWErVFCaIRpkT2UIT2MZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xolo8MnYpweOaon2x1/tPrw3jWks8S5cQYxAFVKPjU4EIs+/FUEPWhr+N5hg0OuaPRwI63QOS3tVaOvGL4LxORGByakRhrAmd7pk4KlH7q/VEhFAbFStYHtaI2o7vdGavzuN7DWjBOUyOe6qNVFSc1aiFjnETDAF1ETOFfg0Iy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mQy7Re+Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b2822668c2so15166537b3.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 07:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724943018; x=1725547818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K40x/XxYGu996xFAIHnF019vu74x3oRUZW/VL978XPs=;
        b=mQy7Re+ZrfITiMdVQU6svtb/OfcE8Gcm6Y3/ua4uYA7vcvsDo+O5SmpttULsN+yxyj
         uSruxnwNjn3SPzGJ3fEBWOXf7k2daUiFsGYSYOE9PuBu4nZfz+YEDtsbqLRiKyOfrWK9
         3X7QV/cSEuVI6UBbMh8JXErqgz3m5paVkXHnWB5ONOMy2LmQyagG+y2Zyq09DRXPm1WW
         zW0N9SriY4DTbkihN/3wddehscaHoy7dxVbddhdw7ptK0sK5ohZLdGR+R9XjdZmdZZOz
         vP+dpUbbsKNF4DB4bE1QUEBc5XZKj4kVdSNpa9PNOO0ctH9DjjnMBnBAIx5Zqy1VvVNB
         vCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724943018; x=1725547818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K40x/XxYGu996xFAIHnF019vu74x3oRUZW/VL978XPs=;
        b=gTT1Q+p6ZDd/cP0TmRbj1AaTaAG/7GEK2GJkHhXmH+0/eN/qsHo1QmIcFg0hB5QtnE
         CgbLWWATV0q/zW0Eg9d7WdgvdQL/qYxDi3k/oehJWszzxktoohKdSF0SAaWma3I7loQW
         IoaO2A/ajEsjDp1rv4YuWAIVdA70Gz0wydJnEZfGAXR6yQvJP4DbGRX+X63/xEjMg2h2
         w47Ox+Y4dnXJhFnvq72bdJiqdx3LjyOGMbY3TmmMzhxjaDe/FhoPMZqBwxTYah6aZsW9
         lhvbDrpsf+WTbwuZad8AGy5l+ywVJdoeF3vDJJX3ZzqSa4JUYm9l7Nel0+vJtlakObV7
         IoQg==
X-Forwarded-Encrypted: i=1; AJvYcCUAuNSgrRMC1i5biuFpHVKwAMsx3XtmX92pN496jW0fFKPBomzJbNJJOAPyJmgIw0VwA2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymkd2ih07sHKPTIHDql3OFBc5GhLbG95JWExS4zRJ4HHIfRoEl
	50zr4to/xFK+HEl9JQnkqbZN8eSl7ZZJ2YOJPHpE389JHnvGFY35URIWYHqg4k/N8wMy3/NRGs+
	tzg==
X-Google-Smtp-Source: AGHT+IGmzsl+rb2EC+zOzjzhADg2nn9Mafe2WTKumDpKYR0ktqk4W9+2ZAHTw7zGoStxNYtfttKBQBxzE5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:680d:b0:64a:e220:bfb5 with SMTP id
 00721157ae682-6d2e6f71327mr398347b3.1.1724943018336; Thu, 29 Aug 2024
 07:50:18 -0700 (PDT)
Date: Thu, 29 Aug 2024 07:50:16 -0700
In-Reply-To: <87475131-856C-44DC-A27A-84648294F094@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240827203804.4989-1-Ashish.Kalra@amd.com> <87475131-856C-44DC-A27A-84648294F094@alien8.de>
Message-ID: <ZtCKqD_gc6wnqu-P@google.com>
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com, dave.hansen@linux.intel.com, 
	tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kexec@lists.infradead.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 29, 2024, Borislav Petkov wrote:
> On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >From: Ashish Kalra <ashish.kalra@amd.com>
> >
> >With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
> >crashkernel boot failure with the following signature:
> 
> Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests and
> there's potential to lose guest data in the process?!

Because if the host is panicking, guests are hosed regardless.  Unless I'm
misreading things, the goal here is to ensure the crashkernel can actually capture
a kdump.


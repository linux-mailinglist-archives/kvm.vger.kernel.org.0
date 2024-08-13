Return-Path: <kvm+bounces-24050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A7A950B84
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 593201C2202C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B6C1A2C2A;
	Tue, 13 Aug 2024 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OQo0XQ32"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C951A0B00
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723570577; cv=none; b=mg86YeiRF50p7RQodn+9+6zXbaDqR7TahlNezZFfAFMPyO8SJd7BAuQf+deaAVH0/cyGRyAKiAGTe6OK+wjVXy7iyqg1L6gIUrOOZvKRtL4d9vICP5yIwM9AqfXs0NXExIFywdDKbCsz523eU+omrufmhV2FYIY8At1qsZ7Q008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723570577; c=relaxed/simple;
	bh=Snsxhi3LIQZcXAKg3rDQSNDIeb30hQkyvxggbi0dWFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCicgaR8L1k+U0uUc6e3sIMdaDvy1okjhwtXbafqE2fqJnYaDJvOXDQaFXTavuvxCh9LHzKPmFnYUfaKG/lG0suBH8l35XGjmIFm72yhg7VwyceSoTbm5ICiUSsPNquOu9O7dUsUOeFo3o6+MJYhym9j6jwCvfC+yteuewFMv38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OQo0XQ32; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201cdfca5deso8717275ad.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723570576; x=1724175376; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qaxx+RIlGX+ihV0yke86zTWP07hgBW9xJr8rC5KpwXM=;
        b=OQo0XQ32bjh0iBL5axa6SqPpuz/ew1BXtJu1dzlV6iVZ61Ojh5edef7Lnhtkndv6V7
         xqK8V+/2pHd9RL3u8gfMoDCQacUNStIog2s7MgkKma04UDSuQ2yrUHtDsLGcJu6etvex
         W+zdmOOf7ycJ6dYEj9NA24+BSpadURfId87UQXUf7FoWgJdlKKZe6VqM1SFTbj0hqIu8
         SRxnGAGgKik2dMx9/UQPQyGeNKIUW+/xaOLyPi8yZoCwCShz4YdOEbbpaNGO3tmbz77W
         dLBFKh+fan5KJlcum9jMg5KQQ3PBpUt2QF3SQZmoIaBTaHFpnMKG0H9MGUs3fdMORP09
         tRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723570576; x=1724175376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qaxx+RIlGX+ihV0yke86zTWP07hgBW9xJr8rC5KpwXM=;
        b=THrAMJZkUL9JCXBGv7LG+cnw0iK2nM5gL1TyWS/LPmU4oWFAZFnpTFeOWMSM3t1PMb
         ZZyoMB6CNDzE1RogSXdpezPdXlkYpnkGhLzDKDRGSJWp01S9g1c9mh6/5yuCu5IIpbmv
         Vbgn7Z/CA9Cj5OcWdBg85N+50+8JE41HhfDXdC4dWnA+EvPH+HHjtSHffQOqjL6ZUL1A
         yRqTLqZBFkKdpNWWl5IPHXg7Ledeb9Rq4Fx55RfzRJk8fsb+oPPYlpQzWDkRYWGNl/Wb
         ofMcCSB4XSOVNFCeuCbeFBbdKd9nh9dDK7B7pBEXS3z6Q6y8r662YquOn0D8hme4on+Y
         Ea/g==
X-Gm-Message-State: AOJu0Yz1dwIxayY4MSXIzPesHqX4Jf9x6jrD0hakRXQM9KT29ZgLpkGM
	3dqfHPiTK8HpVqyb88KYg8zN4IJm9zxFYVIIaAqQQ1fcIG8pLoXWo2aEP49WWTUF7lBFfTrW8wE
	LqQ==
X-Google-Smtp-Source: AGHT+IEAaxGWcx079WWkKDEjS2dVuIZWuu8HYSM3PufJYi/0hU7fPNMjSiLPVYS4fPuoi7FYVv5lbw02/Yo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d1:b0:1fb:6151:f630 with SMTP id
 d9443c01a7336-201d64a5e6bmr80045ad.10.1723570575607; Tue, 13 Aug 2024
 10:36:15 -0700 (PDT)
Date: Tue, 13 Aug 2024 10:36:14 -0700
In-Reply-To: <20240813164244.751597-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240813164244.751597-1-coltonlewis@google.com>
Message-ID: <ZruZjhSRqo7Zx_1r@google.com>
Subject: Re: [PATCH 0/6] Extend pmu_counters_test to AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Jinrong Liang <ljr.kernel@gmail.com>, Jim Mattson <jmattson@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 13, 2024, Colton Lewis wrote:
> (I was positive I had sent this already, but I couldn't find it on the
> mailing list to reply to and ask for reviews.)

You did[*], it's sitting in my todo folder.  Two things.

1. Err on the side of caution when potentially resending, and tag everything
RESEND.  Someone seeing a RESEND version without having seen the original version
is no big deal.  But someone seeing two copies of the same patches/emails can get
quite confusing.

2. Something is funky in your send flow.  The original posing says 0/7 in the
cover letter, but there are only 6 patches.

[*] https://lore.kernel.org/all/20240802182240.1916675-1-coltonlewis@google.com


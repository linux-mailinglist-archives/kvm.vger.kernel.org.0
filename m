Return-Path: <kvm+bounces-38763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75151A3E2B9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575ED17B0A9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC1342139D4;
	Thu, 20 Feb 2025 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLV/cPZs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91486212B0A
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073259; cv=none; b=bCk14rMa6CIXeu68JykVyLcLHAyJ6efw5yttIxWb7oCq769DqBuQaZeyC/I4obLRo8EpXKVbCCn/X/hrUNC4y2K2OwSyPjRb55MZ2HM83GB1raoCdAZ0FHikLyaxeJtpLdCJZwjLqthd36UD40jCFjPtA2uxf6uDEA3QKVo4fyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073259; c=relaxed/simple;
	bh=igYWIghKpNEHw3jO4vpUS5tpeSchXJrCfky4dIsQExA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kw1m9aoTmxEi4Tyoh4mzelANuOQ+oxY7MByg3IRQGV9++CtN81AS5NPpOxzA93hHZdYRXqJvuzoZcyZVDf5Dxeq+okeTqf83C9QHuHpSoce3OFVmVbdAqxNXyaH99ZRq2BlqCg/1JyYiYY8/eWJzPS7Oh3Ii1e0qogXHH9fJEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yLV/cPZs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2217b4a48a4so24651735ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 09:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740073257; x=1740678057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4oDaqQEbgPKdxoyp3SqOgQbZlTAQXlBrEQTLUadYlI=;
        b=yLV/cPZs9w/1d+vCH9GVeyIlDQhVG7PVgkFZsehptdAZ7AM6fr7Qq8gaalkaQFGLoh
         Tv7QDBovcOq/k3uwXbzY6Jq/WCF4bCR9V0zx9rerZrNM303STsRyTVFGvamGVbrAvkjC
         /YkdVrkkdxHPMPn7S4rA1VybAv4fcubDtt07G/4+EwGMKZQu2iUJxHYrHCwVFKZkuJGy
         L3Mjv14fZU6JWAKdD2B9XMeGFZajPti5+fMOS3Y0gRpPlwqpvCGO2p4POJXYL7JWHKPN
         o1zfQVzPHvbCRse5mHAkiq4rTmhaymqtvgIQitv3onHEsE9iyyiPD65pqSwDZJnfO7p/
         8k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740073257; x=1740678057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4oDaqQEbgPKdxoyp3SqOgQbZlTAQXlBrEQTLUadYlI=;
        b=uvN5CxnyDBjBUQtKsqlpsCcV9yVV/VaAmVnTTTgSLamzkhdXNqctKuku8SSo3Bi5yS
         h4zeuxlP4QJpTFJhfOKdN1+byX+QjylzGhXH5phn1EEgWCujT/dM2zInA9BN9dQnXhZq
         6GcuQ1HeiIr+bwIoCB04hwIz7h+e1xbL+oKGjIxdhYrM9TWpdbe6u2SNqbPLIgEYnt9x
         /IWMlsUtotrWzqns6gQnqnyDrA5iHoNCuWAqrTc2t/VMJskEmjiZSa5sVrvXGNu5bn+0
         /M4nE8b64+eyL/eLM7FpJEuyqj1w+elhMBd9lkRfreOt0VQpW0pRnDovfu12w/vCdhGe
         qxSQ==
X-Gm-Message-State: AOJu0YzY+5cAbzDU33LGLSZAFVT68OEK7pswv8O7+ieZZqEMiMWk6+qd
	LSLy2EyflPalQhn3pPgEOiB9qkTS7EGvKQMGfDmcUtzADmocnDX+7ZxF8vadBzXPoBZBf+Dtm12
	ibQ==
X-Google-Smtp-Source: AGHT+IHVDX8BcLlQVirHfV4THRe1nnHouaoBgJwRfjfOdCSR2YCw0QfWIxv2T8rwbFrNCGyjwE4XRPsB4f4=
X-Received: from pfhx18.prod.google.com ([2002:a05:6a00:1892:b0:730:759d:5049])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431a:b0:1ee:e46d:58a2
 with SMTP id adf61e73a8af0-1eef3c5593emr25422637.3.1740073257563; Thu, 20 Feb
 2025 09:40:57 -0800 (PST)
Date: Thu, 20 Feb 2025 09:40:56 -0800
In-Reply-To: <bug-219787-28872-1JniK28vj2@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219787-28872@https.bugzilla.kernel.org/> <bug-219787-28872-1JniK28vj2@https.bugzilla.kernel.org/>
Message-ID: <Z7do9SwCS_NLrobX@google.com>
Subject: Re: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 20, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219787
> 
> whanos@sergal.fun changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |whanos@sergal.fun
> 
> --- Comment #3 from whanos@sergal.fun ---
> I have been able to reproduce this bug too on Linux 6.13.3 - Specifically
> whilst attempting to download/install any game via Steam in a GPU passthrough
> enabled Windows KVM guest.

Are you also running an AMD system?


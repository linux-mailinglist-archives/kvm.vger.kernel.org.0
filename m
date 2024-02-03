Return-Path: <kvm+bounces-7888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13EC847DA7
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30DEF1C22942
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B167ED2FC;
	Sat,  3 Feb 2024 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dJqq1Pxt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0AC12F
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919194; cv=none; b=BmacslmkMJB6Mq+cgk0Pzy6uHj+es1CyZm+ImhBQ2QrynjCIm/L05Lg9TB953YINCWpWysSNfcQ11ZZ7oRMYvcJd64LbbQKX/oLSmfZUbE7rC3pVRjC0I1S9XZ38nkK1qgf0uVH5VdiR3WVawjOLyXvG7Dt61Fl7EBwQKVhIj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919194; c=relaxed/simple;
	bh=Jni0TSg9ot6qcQozjcLTwevDpNhGotmKANfaFNXV3iM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PIOonh6z8+sYz81kwWZVopxNgVIXPdECPpy7Sx/l3Cz2AR0+ICjSR0gXUYJl1YWHOcRsi58WLrwhIhEQvdm53NgPOHridVGsDWbeQ6p/pR4gkQwKnC2QvBGwU4ZdX2ksxW8Y2lC9hstiiIrtlDpC3/32ca9KwPSKvmwWjYKARmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dJqq1Pxt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5fc6463b0edso44880857b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919192; x=1707523992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KV+FXAPZ13lcrJzUvKxbJ1XxGB1dtZes5YLuLkQ/DUU=;
        b=dJqq1PxtZ1rd+4yceOyl/TgQ2EZzCBeRSuBSU2J/YdClCPRhj6Dg3PBPCVzP/FZK/j
         z+iJOFF/Gh74++jM0ikpvmGO4gEvxdlazkjoUSZnx1tbgeCt3U7ULiZTvNnN8jY22+ud
         g2RSO9fr01Yz0n/s8urDPDnGI84ghYKznGi0GOQgME5BfbK8JPQ3nNyYFXKU7svVDpz2
         HLVX81X9z3t17uyYBTPfFG/zRHDq6UtG+rQBtsFAx7FUdtoiI9u+saBe4E4HJC2e3hq2
         Vhu6w+yvOXSElybXJAzONtvGJUIgzzitVSJxBaVf6pLCspaEKrh8TRKmSfSOSFzoFn2Y
         iSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919192; x=1707523992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KV+FXAPZ13lcrJzUvKxbJ1XxGB1dtZes5YLuLkQ/DUU=;
        b=OpQh2kiUnzCOSzTjpV6v91SwUwnON+XckYsz8XEVeaXd42wpDTxyrXey9mBOdkcLIg
         JOVrm1NjcMqxIdk/RxvyWZBLjg0L2MWclxY+tDi570vP3fbCWF7x6ghCwwma0aUwMsG8
         L+sxMqg5+Canq5ElI4TbFQN2e7Vriig7S97C+lfmjvN7aUdh+6oqOXJm/ZEQANGZSUfC
         bIQp6GiZJUYdFGIJuqYRKdxN7qfitzF3HVWaBWEydU1xYaXHXLETE1xV3XUxLjTlRELz
         xnIsNIXcfB4ehJYdm2J2SYSXWrOiHktz7va1ttHKITyKKqUL82P+Co0Mcli4U+MOuAYl
         PMZg==
X-Gm-Message-State: AOJu0Yyqvi1OG2cC/bKwNoJabOkWb5JY/tHWw1o7X6+fpZFV1P6AYrTM
	TeT07VlNJMNg2iI2ifAFUEI7uPctwvMMTbeNS+3GsHts7QsVVK5ofM+kiYV0K/pD/fEaLtuLhfR
	IBQ==
X-Google-Smtp-Source: AGHT+IFwrMnn4VvsrgYURBQxyrN5tkSM7D0Vd6WTyJGbeg2WyMB02hw0RcROA7FQcIWE6njYR8iWglMP0xk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:e0e:b0:dbe:32b0:9250 with SMTP id
 df14-20020a0569020e0e00b00dbe32b09250mr207201ybb.0.1706919192678; Fri, 02 Feb
 2024 16:13:12 -0800 (PST)
Date: Fri,  2 Feb 2024 16:11:33 -0800
In-Reply-To: <20240116100025.95702-1-chentao@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240116100025.95702-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <170674428314.4156118.6499513902134394843.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, Kunwu Chan <chentao@kylinos.cn>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 16 Jan 2024 18:00:25 +0800, Kunwu Chan wrote:
> Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
> to simplify the creation of SLAB caches.
> 
> 

Applied to kvm-x86 mmu, with a slightly expanded changelog.  Thanks!

[1/1] KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()
      https://github.com/kvm-x86/linux/commit/0dbd05469966

--
https://github.com/kvm-x86/linux/tree/next


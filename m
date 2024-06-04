Return-Path: <kvm+bounces-18700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C12B8FA6B3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 02:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E2FA1C225D8
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 00:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067222A8D0;
	Tue,  4 Jun 2024 00:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZQONQF2Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A37A5382
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459238; cv=none; b=Fmy1wWYDbEaGT09QShGjz48evhP/eGQYWzNj7TylSMv729DxL0nmyv06MSmwqj2c5OF5TWMDjO5luE/XzSvxH2wg2nPH2KAz4BUIHLwnJ4oVGut4mNS9hD6xEUA/yvhj9pJX3ps/XWWaehw1x4YQRNXSe+6P/EB5nGPeSiXtxjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459238; c=relaxed/simple;
	bh=qmzipbdBY6KqUjrHfBG3VzqriXpHdWHYlYyt1ENKvq0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IfDq3YB9vzIPclX2DgxABrF9wnzxYyZPYXjvsFzQTFc+tRgUR35Kz9bbvJAMtECTXNPCdn+Q5qWG7TnliCZHE0JJxR+Ak4Bp3wbQAaJs2ZzaWIYBKV9ggdqO8KY10Y9r6jgUugInD6Bs3jtd3w5/frZGE57cvxwZH2v+TbrhOH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZQONQF2Q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6507e2f0615so4508138a12.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 17:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717459235; x=1718064035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X9TixsbS4vucV54Qx239yWNe5AZLJZTOJio74oth8eo=;
        b=ZQONQF2Q2Ikl2ID4JAuRYwoHQfqUopTTl/zUGiyTUrHa5N+CygYEQJfppVAknkh9JK
         j4pSYXk2Hj2u08iVxR5KtOtFuRJ6KdTiunVZaN2o/pz5rd/zqUT2X1UQfnsWAS7uP6zi
         p8TysO9hDHEC8w0abnkcA62D0Yow4EYV7fclW9euO7hCQ5AOot0J3OoBdT0aa4IHP3hK
         hFISuSwdOQSIXsXozSsbkKHf2sI0kptG6kv/9njKgg/QsrDgH+0StnqCMh4ZBvti0S1w
         GHX1Qk0G0eyLSuB53miE2svmCkK6VM7Jz55TRxGhatv7v6o1pbfL6b8WRGx3z/nVAl/G
         eteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717459235; x=1718064035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9TixsbS4vucV54Qx239yWNe5AZLJZTOJio74oth8eo=;
        b=cD2hJeh3qnED6BHdqg9wBGaPjqZ3C4GHXcZ24lHG1m/5LXb2x6wbBPIxcEsekf8iUK
         1dLyxtCjMp8HhhvfvmPGFctdPkE7ttDBpzTh1yXGDbdBm09YdiUaot7Cdw1AgEhcpwdk
         x+T32aNFBcQHgvBFWWezLzsTOJVPi3TbwOzStZRIOK5z/VFsFb6cAXKPjxW3rTmK0+/V
         3a+ZEaJMGiWeb/5cN04+J4i22xCjUyqOD3wh8Ce0O1mBfbosq8z/cfbfr5x1hQ4yCIH6
         z7JjB5QTZlWx90s3t1CQz9L0prhvL/3Z5hbEVDprh1tP3/HC50T9ITLEyuyJtp5obK4E
         gzTA==
X-Forwarded-Encrypted: i=1; AJvYcCVqxJZCT802yOjKdVwcabnSNOSzUIFNDn1olepSuYOoKQpEPsAPA67gaI8T4sLKyypcFvO1tfM0WUYT0rUURiOrnXIb
X-Gm-Message-State: AOJu0Yy7BshrQ/5LWQfjiQv3ZAM+vydjJ/Fj/aHo7CZYKoFNf8Vr4Lvb
	BvW9ITxwEUhNQpmrITWtBMSFspYLhP3QWUrhWhbouIjR7gfh9WqV3ekNKdlE08jV527Us0XTja1
	UQQ==
X-Google-Smtp-Source: AGHT+IEZPsEeD1Zd/VZMKCyFxGi7l593WU5W4++SYV2nnpe1UGIt5x3H32mkoIcyVAOGihn5nlLRW2Z7atY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ab0a:b0:2c2:4117:2409 with SMTP id
 98e67ed59e1d1-2c241172c69mr8738a91.8.1717459234737; Mon, 03 Jun 2024 17:00:34
 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:00:33 -0700
In-Reply-To: <20240520143220.340737-2-julian.stecklina@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520143220.340737-1-julian.stecklina@cyberus-technology.de> <20240520143220.340737-2-julian.stecklina@cyberus-technology.de>
Message-ID: <Zl5ZIXOXzaTryibL@google.com>
Subject: Re: [PATCH 2/2] KVM: fix spelling of KVM_RUN_X86_BUS_LOCK in docs
From: Sean Christopherson <seanjc@google.com>
To: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, Julian Stecklina wrote:
> The documentation refers to KVM_RUN_BUS_LOCK, but the constant is
> actually called KVM_RUN_X86_BUS_LOCK.
> 
> Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
> ---
>  Documentation/virt/kvm/api.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2d45b21b0288..5050535140ab 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6418,7 +6418,7 @@ affect the device's behavior. Current defined flags::
>    /* x86, set if the VCPU is in system management mode */
>    #define KVM_RUN_X86_SMM     (1 << 0)
>    /* x86, set if bus lock detected in VM */
> -  #define KVM_RUN_BUS_LOCK    (1 << 1)
> +  #define KVM_RUN_X86_BUS_LOCK    (1 << 1)
>    /* arm64, set for KVM_EXIT_DEBUG */
>    #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
>  
> @@ -7776,10 +7776,10 @@ its own throttling or other policy based mitigations.
>  This capability is aimed to address the thread that VM can exploit bus locks to
>  degree the performance of the whole system. Once the userspace enable this
>  capability and select the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
> -KVM_RUN_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
> +KVM_RUN_X86_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
>  the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>  notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
> -KVM_RUN_BUS_LOCK flag is used to distinguish between them.
> +KVM_RUN_X86_BUS_LOCK flag is used to distinguish between them.

There's a patch[*] that does this clean-up and more, which I'm going to grab for
6.11.  I am planning on grabbing patch 1 though.  Thanks!

[*] https://lore.kernel.org/all/20231116133628.5976-1-clopez@suse.de


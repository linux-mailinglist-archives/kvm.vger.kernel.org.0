Return-Path: <kvm+bounces-8132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4011A84BD79
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72A901C24AFD
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB5913FF6;
	Tue,  6 Feb 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mbx8/Ccj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1183A13AD9
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707245565; cv=none; b=tNlzKGwa+y335IC7v4wO3/i68p1qMw5LuQWZxEiyD1dcKrPA7OxWm1AM0D3rbziSRVSlSqDaG/yn5ysKYaMR2jKMhxYLoD5mdw7WmxONqxM4W+J/bt7RuMVVjnj2EqGnMEqiQOWfpLZvH6UnjEVRJK0iKAu12aZJwXFr6/M9HuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707245565; c=relaxed/simple;
	bh=BUmWErB+N5tn6asyrpetAClk4cg2hSp7vYAITm8roes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JsprnwMFPWKziAv7gO2WoYii5WeDnM2Kc2DYmNHwAMPSb0TkvEQHfvE25l9Qml9UmgoR4UraB656rq2gkvICYs9rZLZ1g+KjjZJkijdN2j/mLTbdMQJNV/menmqgYM5ZyUwKjzTzbNziaS0w1gIAlGZY7P2hM50pCBukU5VF/d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mbx8/Ccj; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047f0741e2so13383887b3.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707245563; x=1707850363; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rtm7sGc/cskMbbaudAaOLpukE/MUnKMOUQq2urRiA=;
        b=Mbx8/CcjGcO9q8X6+Rd0B2FSOLYujpjzejbs/+WekUYqripXWkIZ2Bl0SwIi8ZQ3I5
         p30tA4ynvFMq64NHQORuRj8Bqjd+qnWjnE4B++4mPu/vnXFCINU/yuGBsU13msAq7riO
         Hpq6qpi+qE8Bc1EnHQLLMOmNGUnXIY0VeBxNwUGI8TfRRS1FlUJBFG4pk2BSYeffLXRD
         J8JiTfGK8bdwKGbVuX7hGrT8xMiRB8xh1qx6FUmYIGhZbzqA7TNsG98pV7P6mzZVaTJH
         CAWQtXwyQuFvfOyaQv9gbJlvTmdtomJN2+LH+RMJw5fBEQqfCXxZN6kN0jKaHjPR6qCk
         mW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707245563; x=1707850363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rtm7sGc/cskMbbaudAaOLpukE/MUnKMOUQq2urRiA=;
        b=F+KRSYo4a0adGW24xNCjx3zK62rvUApOcTrc3onGZDBfoUxsjL2Tr1sYfA8rbAH+od
         l9vLYHs90Bu8b55h3husHeioKfaSoaoXBimQ/n+p0QT9crB4sL9Q7RKdnB4MIzOT4TK2
         XlTHNw0tikUVjYjCH9/N9tHj/rzACcEfKdFSIwwnF30Y82qHiLFN9fyAnV770Mq9Wcj8
         ZtzEK0SlID9Qr+R45Lx64gLdHOvOG4jkeLVH95i7Kg/3J3HgMPIeWZaGFVYkPhY2JzVT
         xsocoPaUZTOC8XLis7wuVrjbGJREC3ee5VPzm0Gh6VeyS04tADZvMo+vjpXZww5bruUO
         3/7Q==
X-Gm-Message-State: AOJu0Yx17j2QX549uhzMvq1gEbG8tYaMpIgqxoSJBv3N0c3Tz6zHySBo
	kBJXIHlIVLCKmG+hTYz2XuocsrND1jIt4pOBURomMGNnEb/Jze6hvl/eeNymT2x7XngBW5Yuhme
	l9w==
X-Google-Smtp-Source: AGHT+IHFT3Y30VofJu8kHzzUDzfZbKMjb6AJOfvgn/5h+iu6a/Vg+6dGEBFd+OaVX5j9qp7JV7jJFVMGFHQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:98e:b0:dc6:e7c9:b7d2 with SMTP id
 bv14-20020a056902098e00b00dc6e7c9b7d2mr108805ybb.10.1707245563025; Tue, 06
 Feb 2024 10:52:43 -0800 (PST)
Date: Tue,  6 Feb 2024 10:52:16 -0800
In-Reply-To: <20240203124522.592778-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170717632045.197018.17752898391870882928.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86 - misc fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sat, 03 Feb 2024 13:45:19 +0100, Mathias Krause wrote:
> This is v2 of an old patch which gained an info leak fix to make it a
> series.
> 
> v1 -> v2:
> - drop the stable cc, shorten commit log
> - split out dr6 change
> - add KVM_GET_MSRS stack info leak fix
> 
> [...]

Applied patch 1 to kvm-x86 fixes (for 6.8), and patch 3 to misc (for 6.9).  As
promised/threatened, I'll send a small series to cleanup the kvm_get_dr() mess.

[1/3] KVM: x86: Fix KVM_GET_MSRS stack info leak
      https://github.com/kvm-x86/linux/commit/3376ca3f1a20
[2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
      (not applied)
[3/3] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
      https://github.com/kvm-x86/linux/commit/e1dda3afe2a9

--
https://github.com/kvm-x86/linux/tree/next


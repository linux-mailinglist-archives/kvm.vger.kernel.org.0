Return-Path: <kvm+bounces-25614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF21966D7B
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59542281DE9
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9268E37708;
	Sat, 31 Aug 2024 00:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0zdmXkYP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C39312E4A
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063729; cv=none; b=S+JACXFwGFY0Giepnve44LRlbLBD6eSdUggdd55wGWJa49uAzpLP3QgVA1epgbriDBUuYOVO9vyz1SR+dxVYmfyfi7piOapnRRUkRgChWkNo45nOOfr8XzfjRyLtXwN7lfQyDXvfUYcS9b7ZYuJGEUKgahIO5B8KxxkApYZtFJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063729; c=relaxed/simple;
	bh=4jpBWmEqpFaCpjkz9FQ8P488qBnL2z5OXuuxbxGQh5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ToIVUcRAWtxFDwHX/vBPmVzZBSNfs8Wz3mTn1YSdev7XD+yPSGLyzmivAzQ8M6A1htQ8M1lPdKDFBz7zMNXwEn8/wfjOwyAG0KdPACUNw/0U5mlk+788L/dzGcaSG8zFYv/vGW4vTiBJRdHCOlWVCgQSDJGJL3PZ5y12vnh/AyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0zdmXkYP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d2159ebf3dso2291404a12.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063728; x=1725668528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s93PoQRPI03FQjIlxzhQNaPiB2j5cUZUcypAd0bHJjU=;
        b=0zdmXkYPclsDqepHOkp+C+eaOLSiTjGdXegQhtk2UqVihVi+ADb0wF8DzlrMtAN1nk
         9ZTK/rR8eWruPAbDOPGrqzfbkCYDTdE+D2lbe5TN+tWLHIOPM8ryPVUuKGwWzziEtjN7
         gpTcxAyWlGiA2EHkYcmQ/YIscnmXkeMS1eQg/yrNf7M1eixUWg4eKuHmj36rah8EXcLr
         JniEm9uDbc7P07w1f+u2jCcdbCdBcD0y5DZ5IuNvQbNI8aLNWVmPeqSk5OY+4Jh+BU3v
         yjOqotBWqwN1y9CetGeSImQwdgrLRzskaRh6b30A+jSNmCsR9B79rolWC30EeeyXZu9I
         QUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063728; x=1725668528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s93PoQRPI03FQjIlxzhQNaPiB2j5cUZUcypAd0bHJjU=;
        b=IbsQVUE4m5YOEsr56JO4UxvPLOO1TSPxyhS/Ek3LwMCjdwYzIu5oSG3485QnbbWvCX
         RgT7w6sjINUM0nWwfTJEPApwzhSVBPsQHR+fbqwxL+dd3gY1G7ms5Jm/HbmNA0Q0etdm
         j1AWGJSX6H5Q3ePcHDjmvpLNCO+buv1Zqmi4A0ZeApIlIxd/vfoRTA4BjypypT8bmLr0
         2rYC4aNZdxBgyAuMced/RRl/oQcaAd4qm57M+xnQ4t/bmKmyMNRV7eWpLNSB165XR6I3
         1W1BXDdyXCFHN1KGpDvVIqv1sZeAA6ziPqRbQ2TtuP9wFmbkcX9+er2aJVn2z25txsbh
         +xFg==
X-Gm-Message-State: AOJu0YxelzlyD2y/tB7ZOcYTckjvA/e9VYR8GcKdAZ3W9TRJ1Q0oD1YW
	KviqshXPkJaljjFNunAn9xznoD4OsKhg/GRIijWiQzkYduFtiQaxAf3/TlPfefoMnGVPmM+AMYj
	0eQ==
X-Google-Smtp-Source: AGHT+IF8vsiSOlgRBM3A+cfKgL74GTir7MKYchPctzD/Rpopijn5JsX2tpGYfgQLlPgC7fl6bew4McC/y+c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6559:0:b0:7b2:5893:ac16 with SMTP id
 41be03b00d2f7-7d4c107acb4mr22370a12.6.1725063727526; Fri, 30 Aug 2024
 17:22:07 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:21:03 -0700
In-Reply-To: <20240828215800.737042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828215800.737042-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506356913.338728.1114402830048660075.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Explicitly include committed one-off
 assets in .gitignore
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Aug 2024 14:58:00 -0700, Sean Christopherson wrote:
> Add KVM selftests' one-off assets, e.g. the Makefile, to the .gitignore so
> that they are explicitly included.  The justification for omitting the
> one-offs was that including them wouldn't help prevent mistakes:
> 
>   Deliberately do not include the one-off assets, e.g. config, settings,
>   .gitignore itself, etc as Git doesn't ignore files that are already in
>   the repository.  Adding the one-off assets won't prevent mistakes where
>   developers forget to --force add files that don't match the "allowed".
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Explicitly include committed one-off assets in .gitignore
      https://github.com/kvm-x86/linux/commit/9d15171f39f0

--
https://github.com/kvm-x86/linux/tree/next


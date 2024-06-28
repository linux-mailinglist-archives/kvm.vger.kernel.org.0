Return-Path: <kvm+bounces-20707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F90D91C964
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1AB41C22A3D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CCD824AE;
	Fri, 28 Jun 2024 22:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gzxH1/Sa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1713212B
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615434; cv=none; b=t2D9+SuborJsR/9s6pRndhvd8gfapICQXz03RqIUWb+H4oTUn3QLCfGsZyLhFDqeDEKHT+FbwQ2PvXGLsMR7X2aRXEf/jf7bKGfIuvUh+9MNJw7yraakkHWABNN5Uj93OXvsMjHQXXajTzwTnzb9gh47OShPyAOAZ6f7n9fgtVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615434; c=relaxed/simple;
	bh=Rx47Cuvv8ttSlJj2nOLZ1LhjMx5JPrfj/d2gagH2hLs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iTcn8v9Q7ZKxg/q3qCbxirveI3V+Tn4tMman2YLxAPdeoQ49I1qef6cc/QF3WiAvv+JOFJHEdWHsIvQI02ys306sJmoYbTNXPEjcI5G41HY571yPpPOuH23iphKrw74aFys989iZy3oVx4UE+153PGvs8gZXtBHaEZuTc84QlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gzxH1/Sa; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03641334e0so1237656276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615432; x=1720220232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ux3glCu0i9u2NP54Pg9mStOBBEHRzpvA91pkVO4CBfg=;
        b=gzxH1/Sah0NM7juzDK0yyM6ZOng7TljCSI2vju9McUxGyen0m3FvC8eicYOOlDZfhT
         3xUWju/C1XMEIHQx0aJhlnV0k9WliXhCR4hvXy2EXBoddn1QVT/bWdjlCuN05NlCg1yV
         YhlPM5wjmRLA1y88w7eKwIIcb6Pe/my2dzu06jdOU2Uhm3d2iXR6RU1nrRSkH+kpo4qT
         thFsqBPE0EG2rEEWJNneTfVT8bqBhZO0iuvuSEmbbnIl12oDHAV5UDR3mldFUbDVyWDs
         ncg/+kb8yiGDYcO0SMQrIiHESRb4z/E3/AbLwZOhhfghrIcUyEgFIxL5MqQBAV/wiup5
         eOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615432; x=1720220232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ux3glCu0i9u2NP54Pg9mStOBBEHRzpvA91pkVO4CBfg=;
        b=K8WUMCP0Lv7QOya2iYzadn8dPnkKTPczsGkMPv6XssDhEBJEXbeziHHwbGMGnZArTw
         9mYKZckUY1z82PICLjCy+LjlDSSZ0650TWOdtOFcVP8jxiFwgiLmMpLth7VMYVfGHUUU
         p55BDpDcKE7z1Jxo94GhrIBRQ7PGkAmGTyRcMjMWU7i89mH8fMteD5y6px4n5c9+Njgg
         JZZNFp2gAxGzUklWezYF4z8jgTV11Mp0DY4P8gTv+ZFOl+fLHRNF+phUskGDaE8P/kvA
         kKZGlLOyL3AHDftuKhFxRdGFIlRetyt0YBE1vKUMo+rgoHN/mfN20XMreWXCCkk842iS
         Uf4w==
X-Gm-Message-State: AOJu0YxzHrBim014faNLr+ck1fHLqDkwif1gJiYV6NGPl7kEF8ga0qjH
	XQW7pnudtsoXx1JbTp15jwegS43R4UbjHFmztQgm09N8nDBidWwlg2a5LSS7IzMu5PiPkkf1FBl
	j7g==
X-Google-Smtp-Source: AGHT+IGqAUon6uRbRWqlgCafs7AYOnBM+5+HwdAu2R3W4xK8SGgTTJm3EjE61MOSTX6VBthoGyzT66Hva9s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b92:b0:e02:8473:82c4 with SMTP id
 3f1490d57ef6-e0301072d02mr84947276.11.1719615432051; Fri, 28 Jun 2024
 15:57:12 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:34 -0700
In-Reply-To: <20240617210432.1642542-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240617210432.1642542-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961390054.229573.13409189641571607898.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: SVM: SEV-ES save area fix+cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"

On Mon, 17 Jun 2024 14:04:29 -0700, Sean Christopherson wrote:
> Fix a noinstr violation with allyesconfig builds due a missing __always_inline
> on sev_es_host_save_area(), and tidy up related code.
> 
> Sean Christopherson (3):
>   KVM: SVM: Force sev_es_host_save_area() to be inlined (for noinstr
>     usage)
>   KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux
>   KVM: SVM: Use compound literal in lieu of __maybe_unused rdmsr() param
> 
> [...]

Applied 1-2 to kvm-x86 svm.  The compound literal magic is unnecessary, and
hopefully someday we'll fixup the rdmsr mess.

[1/3] KVM: SVM: Force sev_es_host_save_area() to be inlined (for noinstr usage)
      https://github.com/kvm-x86/linux/commit/34830b3c02ae
[2/3] KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux
      https://github.com/kvm-x86/linux/commit/704ec48fc2fb
[3/3] KVM: SVM: Use compound literal in lieu of __maybe_unused rdmsr() param
      (not applied)

--
https://github.com/kvm-x86/linux/tree/next


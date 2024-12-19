Return-Path: <kvm+bounces-34102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2E79F72D0
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 576487A2E39
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A7713B787;
	Thu, 19 Dec 2024 02:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O/kZiP7m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DD179C0
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576140; cv=none; b=M4TOLsda3DG7i0JIVAlqEpUq/yh1K7+4vfMMkTinvUx/YqvWV/xhlwaIqd0jnrM5kems8QiN45TyvV7pY01IItHinD/8Ge5zPy1LPNQI+OnHVtnWiUuhUHhwLJcE6rh+I3ojGoKxbXUG4YFDBzmPxCN3PhHQc1Zq9feG9A11bnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576140; c=relaxed/simple;
	bh=IOeCgEezv1qZV+HFIqplbuQakLO0VSOS7XBt8hE170g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QpvoQy6wGBaLa24U9vG4E+spFN3p1ttjNV0PZfZezQ9eH/UxkemKRKV/nsVIuaT1teea2rUcmYrcPNorV+onq0AQIIwzHQ2ZK9DJIK6tYaL/pEAPNVn3CdKgIWOCsmK2kmYzMjSlkciv0/uY37UDgkEsF75EAiw/E/n+vGusLUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O/kZiP7m; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725e59e41d2so348322b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576138; x=1735180938; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3283AMqQi025NW8+V+BiFmLe0wWecaptec9DJ50LSI=;
        b=O/kZiP7mvKKoCu9sHmk07lk8zN6lCoRlnS8fVfOjJA6WCMOWxgWGy1fZwAITyLuS2c
         mIvVNf7NnRLHDrbA/DbeadM9MiuJiqdOmoBZXx3qvlOVD/2I67FHKkRjXvxkI6iEky8x
         GCUW97naLK4bUDb5fyHHefWqj9ebdYi8xv1+IjjYDg6v3yS/q9JXv1j2Jdtozp99+QvM
         ettprKeV3lUsYEBjYY+0huEd94vXXa8+2M/ej++3KyG0JHhJbMSa9QSMZyJvm+2lXii9
         5LgiFPPRx70ImMfRiLgh1/qfQv2Ytn8uRqPL3njyJU5SyrPU/MMAf6J7yvaeLq0JXjKZ
         z+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576138; x=1735180938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3283AMqQi025NW8+V+BiFmLe0wWecaptec9DJ50LSI=;
        b=qb0uRNbcGfQKERDHrFTfniJS9ra/b8c834QtEJmAEPABjjYBdPz7CNTAES8AU5hjBp
         eq5E/DAcAGq6qAX6VTJ5UY+tpfgx32fQm1Wkw/b9vovsn2m47H05/enZMjqOKuDAgcMi
         GlWnstTBumpKjlVny0XsCIjqzu65tJ18+ylTceT8Vl7lYCwUUk1cvZyjy76HffpB8Q2J
         /fmHI5mAhPNOpkX4i/gM2DeDPNsKXgJeman+3K+AagzcUqPXUZ11HIm+sjWm9DXp/DNY
         UU+fYHJJ+WRf/vY4TXCN6Yrhr3Fp4d1Yv1t8aeHMUI2B1+rqxtR5ebFW7HAEMpRrL0WQ
         tvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXw2LFLkdrfuTAnL2Fjwwmwxx3gNr7+HZpv747e7rOPoDUiiVP1OonERaYZwuFNQG+ymb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWw2iaBmu33/1RiYE7kvDED4R79vcmxzVLsiMbiWXm37nu5VCn
	Vr788QDbJNRcRGFb/RKMVT673kIKeXtJBm2lNfy1GiiQfuS1Zg0IaItlblXqV4T/Tg7y5sf2wce
	EDw==
X-Google-Smtp-Source: AGHT+IGhmFauhF888d5szWbyDxdRHy45rePRnJAHnmrPsIVy7VA2wuAOWE1A4elWDBQU2S46kXuqnWwGvyg=
X-Received: from pfne17.prod.google.com ([2002:aa7:8251:0:b0:72a:9fce:4f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1588:b0:1e0:c432:32fe
 with SMTP id adf61e73a8af0-1e5b4820e66mr6858473637.26.1734576138081; Wed, 18
 Dec 2024 18:42:18 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:48 -0800
In-Reply-To: <20240910200350.264245-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240910200350.264245-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457564700.3296873.12953215674601470528.b4-ty@google.com>
Subject: Re: [PATCH v5 0/3] KVM: x86: tracepoint updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 10 Sep 2024 16:03:47 -0400, Maxim Levitsky wrote:
> This patch series is intended to add some selected information
> to the kvm tracepoints to make it easier to gather insights about
> running nested guests.
> 
> This patch series was developed together with a new x86 performance analysis tool
> that I developed recently (https://gitlab.com/maximlevitsky/kvmon)
> which aims to be a better kvm_stat, and allows you at glance
> to see what is happening in a VM, including nesting.
> 
> [...]

Applied 1 and 2 to kvm-x86 misc, with the massaging to patch 1 I detailed earlier.
Again, please holler if you disagree with anything.  Thanks!

[1/3] KVM: x86: add more information to the kvm_entry tracepoint
      https://github.com/kvm-x86/linux/commit/3e633e7e7d07
[2/3] KVM: x86: add information about pending requests to kvm_exit tracepoint
      https://github.com/kvm-x86/linux/commit/0e77b324110c
[3/3] KVM: x86: add new nested vmexit tracepoints
      (no commit info)

--
https://github.com/kvm-x86/linux/tree/next


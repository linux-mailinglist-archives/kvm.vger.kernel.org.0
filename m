Return-Path: <kvm+bounces-60014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEF5BD9183
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 13:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B0FA542966
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3552F3112A9;
	Tue, 14 Oct 2025 11:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="30Askam3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A4F3101B4
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442391; cv=none; b=IIKTwN6KULH7HvvqOL9G1B3DxvzEB0LJj1SwLf+7k3BqjSmt5Pub8M2022w4vqvBq0ZXao2UkRgnMeXLPpOBqFIUGlgROhza/V49+qI1+7yD/tdxq162Q0+pXiDjehmYxCGUnMloaFuoE4LkeeE/j1kPUiWfo6RStR19gSmIAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442391; c=relaxed/simple;
	bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N2G0NCu+olxzE+dXuKcxXoUAJ/gdxAyw/623QtZ/cvzephSt1jtMsKMMrPUGWWSgpalvBV+V0Cq/gXCIBTWW6I0HlYXnwLXkpmQtvhgBsIJg5NKZYlYfTT+E5zwNw3ZRbvPGwElscAt35HuPdqrCeKhBr4h+lAY/alccDVFVcgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=30Askam3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e45899798so36073655e9.3
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 04:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760442388; x=1761047188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
        b=30Askam3Ga+tfeeKGLLEnQxEqudbDOIE7P1ThVxYyUIAWhECRgCmzTSmLWwszzk5ST
         W0nl/qulIDAYkF1qptf71ztJBfMUklPUwBZncj1KXJDkh0mysr1bimLosRiRPUH7ket1
         85uBlF/NeInHG7bfSpcw5w8eAWmO7i99xHPVRFmiBdyWNV8PJWmCo3NnJxDXm0BXTJdN
         LytbEXOJ/ppKBGYtY6oSjMvb4dh80hfiumjZHK/rCjK1OOcqM/STlXcWTHhAnvI9vM4L
         ocSeGeKo1ywO0WqoyyDk8zYiB8I6CZ92w+XMvHVsMORkJTAwMbK4Qsx/KFrjn3y/zb6H
         TOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442388; x=1761047188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
        b=tzNbO9OQo0RqKTeMQczK0fxfFwkpE4EPJW2K0GsCSubzMpM9DBD2t2FVDLrZifbd+Y
         8boaTqY0lE4UonwAx+2Ks9gzP9yztDBY1z0mEaRfV5weRIPKWWetyHytKF/gK56DxEjl
         llk8rftHRfdFbhd8m7BTyq50aWdISBLpJGFunbZmygHPMMEihhevByHs6spjpf2flZDe
         PVM8a3yK4vMTQwEjGo0R1ACeVLnl5fru7qC/cgeEWSH1xhUgVS4TIX+enk3m/982Z7je
         ngGLZOFRwd1SqK5yl5PEeUUy6pR44Wse1rqevnzuiEYWzdyh9tOpycPX7R48KIxDCcSP
         XTEg==
X-Forwarded-Encrypted: i=1; AJvYcCXZxGSryOJ9Zi23I/04Ms0LoFDo9lu4eAffMYVTSc/NoRtfv/6YEdERBgR1Fa328s+4qHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSiv9Idc/lWZdJPcC4O83L0HDcyLQVHkZ+s6lGmnNwUT51dBuH
	JLheEmZBfvs0jyPmIFKUXmvVirKry66opeIYZEkSljiZDlfjfWDLMQbwByZy+4nvPbmr3l94S1Q
	hbqjmr6TSMy6QTA==
X-Google-Smtp-Source: AGHT+IGOyIRofYjYdpZa5szgrk6yrVf55DI0nc+jrKz4dMBV/l2/6mxV2A4AekmoWWzzSKpimbmwyKo7J/9+QQ==
X-Received: from wmnp21.prod.google.com ([2002:a05:600c:2e95:b0:46e:5bd7:fc8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1987:b0:46e:4a2b:d351 with SMTP id 5b1f17b1804b1-46fa9b0792cmr172082275e9.28.1760442387950;
 Tue, 14 Oct 2025 04:46:27 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:46:27 +0000
In-Reply-To: <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
 <68edea17.050a0220.91a22.01fd.GAE@google.com> <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDI0QRWVTMQT.3BA2T46YJLIII@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, 
	syzbot ci <syzbot+ci693402a94575bcb2@syzkaller.appspotmail.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>, 
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 14, 2025 at 8:57 AM UTC, Brendan Jackman wrote:
> On Tue Oct 14, 2025 at 6:13 AM UTC, syzbot ci wrote:
>> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction
>
> Ah. And now I realise I never booted my debug config on an actual
> Skylake host, I'd better do that, presumably running the KVM selftests
> with DEBUG_PREEMPT etc would have been enough to catch this earlier.
>
> Anyway, I guest we just want to use vcpu->arch.last_vmentry_cpu instead
> of smp_processor_id()?

Just went to code it up and changed my mind about this. If the vCPU is
being migrated, it doesn't really matter which CPU stuff like
x86_emulate_instruction() sets the bit on since it's vcpu_load()'s job to
make sure it's set on the CPU that actually needs it. So I think instead
we just want raw_cpu_write() here, then there's no pointless remote
updates. The bit might get set on a CPU that doesn't end up needing it
for the current vCPU, but it was gonna get the bit set before it ran the
next vCPU anyway.


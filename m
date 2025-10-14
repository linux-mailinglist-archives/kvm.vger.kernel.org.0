Return-Path: <kvm+bounces-60007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F3CBD852D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 10:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C1164E6F3C
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198CD2E283E;
	Tue, 14 Oct 2025 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpwxJjTR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C282B265CB2
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 08:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760432256; cv=none; b=jFq+1fnc9uba5pIDMQXE3ksQY3MJYhx52POmKmffkZ4/AK/jCvZ+iClTCac/plKo7qFKd+c6aCcTRyes7lMRAJu7FMxN4k5uiR+IvEE9fvQRY404i92Sb5ECx7XUeblEw3N8a8k/g9/cRoUIbTVGtCdLRCgvnpg0aGF5b9IQD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760432256; c=relaxed/simple;
	bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZakzJjhRcdcOiduDv+i+KhMDhrlBf501uWyDE7rWIkFJyKFaNOYozMwgIMeHccpCFJluvH/pI4xLSyyuu3tz2Lu3DlZUVoI9KGwVy7JX4cMK7Jwz7cw4Z4zxM0gTwmGc2FZjJaMrwSQrTKQwkPxpNea8AZvaxedunRjr7Ah7X0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpwxJjTR; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e39567579so25835345e9.0
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 01:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760432253; x=1761037053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
        b=RpwxJjTRuqD6Kf8gUfHFbqCYZGabmOZcoSLYgjVCiNFH+fQTuezj9B0Ht+rDYeZb8G
         7O6EJ2F2IqHdehTSVk46golNqldpJubQRXBn60FFFtCL5HB3aImGWPX+mOFhXdEJxexP
         wy24ypfgsLlKBn+bKQzxMxXjRxs8EIFWRjVknMkxcmnoY7T1OWKMrbeY9tYoShf40EoU
         ARR0JwHa5EFlVuRIiVeYLmpTy2ayFgpjNkttZ4gWf/xiy5u/XOneIGrQ3Qk61D/v85xB
         F6w4WEmqDT29zhhdzQOZO0GrbdeO9SspoiT25reLIw13HY53CkbmnKt8MtitIdouCyvU
         egwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760432253; x=1761037053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
        b=bphvZ2iU/Xt+lMDGB58rYRh338QnjiGosoXGofhXW+MB9hHKJMyIgI1CpfRqmHNPsy
         lofW1wXLpU5MmiIPeOUZQ8/IwIXHQ7os7wmK7TssC+ji3ZV/wQXJPB8xbQLf7GXkDWft
         I86WKN4XbsRhsBGdGolj3IfGUt2ph2QKIhg82rfEw+7JmTo5OhNOEJU5YsVdolvvTg/h
         +zc/OfNF8ENCy96HJ2zBMupwYVCUEIKeGo+bky9qsdddiwJ5HUI5k+qK3Urln69cN0Md
         tWRjPjQR+pxCeyXa8biiqxn1toS44B5w5Dw2sQ2cuAJKzzCZrWHZD1kbsqy8igfWx4Gs
         Nn9g==
X-Forwarded-Encrypted: i=1; AJvYcCWTTryIKen3idh81b+CcFneaQXW+ZmbQelvdD92K7zMOHzHjJltlqKcVVoWwIlf6qFmE/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YygVOrLHIGVdZqvDjsdkcX76rA7nxU8XR2YuZmUyDpQZFVvZdOn
	EQ29LPSmEn6MwV87dwQmV8WMxeUFS9gxmuq7B3DsfXhR0fI+Gv3G7cAAHhLSo8UDhxjmpcsGtQ9
	jE3+rYrzCVtHl/A==
X-Google-Smtp-Source: AGHT+IG3ne3PsSqSbyFbnpOiDKEA5Cl7N+bezBY3keJ7BevMSp8mdAb5PmKQd21efPgwnEf76x9mBJX1JTeeNg==
X-Received: from wmpj26.prod.google.com ([2002:a05:600c:489a:b0:46e:3921:1b1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6287:b0:46f:b42e:e365 with SMTP id 5b1f17b1804b1-46fb42ee3f5mr101990975e9.39.1760432253068;
 Tue, 14 Oct 2025 01:57:33 -0700 (PDT)
Date: Tue, 14 Oct 2025 08:57:32 +0000
In-Reply-To: <68edea17.050a0220.91a22.01fd.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com> <68edea17.050a0220.91a22.01fd.GAE@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: syzbot ci <syzbot+ci693402a94575bcb2@syzkaller.appspotmail.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <jackmanb@google.com>, 
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, 
	<pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>, 
	<x86@kernel.org>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 14, 2025 at 6:13 AM UTC, syzbot ci wrote:
> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

Ah. And now I realise I never booted my debug config on an actual
Skylake host, I'd better do that, presumably running the KVM selftests
with DEBUG_PREEMPT etc would have been enough to catch this earlier.

Anyway, I guest we just want to use vcpu->arch.last_vmentry_cpu instead
of smp_processor_id()?


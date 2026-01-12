Return-Path: <kvm+bounces-67800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B727CD146EF
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:41:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 04B413025D84
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3503337E302;
	Mon, 12 Jan 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YqjF7WQU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDC8378D64
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239608; cv=none; b=I02sbUcIceZW3eSrcd0oxzE79pdruFVMHLdBvli5w9RFkR/ZI1WvIoNbU8HTPSK5UBmyPvAipdM8xAxQJvtd6odTI7sM8WHLJQu5URrb7a/7GfoD3IzLJ8IWj0xXdFthXiAt8eHkXveNEZwze0G9WlcQ8uXmnz3eV2GiqraxBGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239608; c=relaxed/simple;
	bh=N5nHsDesEazlhGApUuU5S6+fpl3bWYsFWklqRY//YJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vBQBcj1x2y8llXuL4Owk3uHIsANE6V+QhnQN9AlV4ZR7jGfEqZa2nQs/2mNN+1JOopWFxuBj2k+wjlFQUOCUt+MuUrTL+Zmhpa/H8h9dYRle2BuZsdn5bIhBHTq5eujcKUSlQL+hCArWyhEyA3PD4D767daNEg17EOa8vlVmT3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YqjF7WQU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so143881585ad.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239607; x=1768844407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzgTW3HLl9YAciusxTxWYfBKfJr+2MVmeSVJCahs0Cw=;
        b=YqjF7WQUnVw9t0MMo1pMoJUCEaY0aTnCYkvYJSuPCKdk7kP7JNGUJDq4upcvXQf39+
         KcZlecrvJS8GcviIFQc2dXYOhM4zAy69Ka7NB0yviOv+xr0qqTW5UfP3qkBCC5r/e/Up
         1JKH0RRdfCECmf03MWXD4mPWeleLZMvSImu4fVxB/9WoWtU12FJCwJsFpuXH0D40mcKR
         EDmpGzdmHNLiwkUszOWA+OFE2JmaIp7zm1ZsS1fdctmGTs7mmBChxar2kV2RwSMFN+mW
         6erwKWoBYDZldy1KOyGbc6hR9lvvoVl3z1FXXcZ9UZC/thbDHyLehDiNXk5HzCf/bxAp
         uVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239607; x=1768844407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzgTW3HLl9YAciusxTxWYfBKfJr+2MVmeSVJCahs0Cw=;
        b=fQ9ctzYtlor8PtJQAihNzuvuxCYnOC37cMxupNE34gSLCxUVdf4YjPYs8MZRJS39Mh
         PhZxAVaQLMoMM6eeehTgIZAgA4uMQjjLC+IiAHMYYH55KrIJpqO/rU2XWGq+QSHYABf3
         dq/K2eDJozRHcPlBqbeYb0ICicKAwVKZfshjt0hLuVU6AvCu5TFrsrGrjStOVDBBFEot
         nVHZIEz5V1BKNycqO84EF5S78eom5cBtnsBOQWiOdSokOkyKZsr18gdpNB3eA0r/mbq4
         VSDQc7du4ZYHnDbdfgaMDp4ckVq0J1MbTW+kXOv6JUQkCUf6GTvANcc5fmIsEELyOBB/
         EaKQ==
X-Gm-Message-State: AOJu0Yy+6OoU9TUgv1/QeN/bFPNfPmh91rr3FJFGJmdiUavOHDW5OVfO
	354X4zAGUBI/ZuDcACi+dqziCEuTWjXLCIGBunFvYk71laAtfPTVFLo1ZwkVZf+HifZMGGWim0P
	H39iDKw==
X-Google-Smtp-Source: AGHT+IFCIitJTUhWOxevIh5SITTdHNIiw1o9Jf6vIJhZg/0qKEvO/R6/qr8sbQzLaxqeRCtNEQBE+OV0/Q0=
X-Received: from plly9.prod.google.com ([2002:a17:902:7c89:b0:298:1f9e:c334])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2301:b0:29f:1bf:642a
 with SMTP id d9443c01a7336-2a3ee424c2dmr165985795ad.12.1768239607014; Mon, 12
 Jan 2026 09:40:07 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:40 -0800
In-Reply-To: <20251230205641.4092235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230205641.4092235-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823946368.1376238.573077114013944949.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Dec 2025 12:56:41 -0800, Sean Christopherson wrote:
> Extend KVM's restriction on CPUID and feature MSR changes to disallow
> updates while L2 is active in addition to rejecting updates after the vCPU
> has run at least once.  Like post-run vCPU model updates, attempting to
> react to model changes while L2 is active is practically infeasible, e.g.
> KVM would need to do _something_ in response to impossible situations where
> userspace has a removed a feature that was consumed as parted of nested
> VM-Enter.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Disallow setting CPUID and/or feature MSRs if L2 is active
      https://github.com/kvm-x86/linux/commit/b47b93c15b12

--
https://github.com/kvm-x86/linux/tree/next


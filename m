Return-Path: <kvm+bounces-47160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0659EABE112
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C2FE8C1E1C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B302726D4D5;
	Tue, 20 May 2025 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ucbEUtwH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A2D22083
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759698; cv=none; b=VpUjfbPz8z1W8V+TcCprh1DJUf27XaqxbYMBLCSM7OdED2ljaNXKg6tN72No/ARNaOnTipV4QYQh1DwFSB2ODjBUYKMDYXZDlnMK5jXiloxEZcRzoydGO1KVy4hEQX63uhVAAOVtYQ4bCDa130ZJj3kJwrVoTAhcV9gwO8wyxR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759698; c=relaxed/simple;
	bh=vaG1AyiwufvK/q6V0BdgNfGV5ktSt1kaK+/KaMzgyxU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fnDli9eZ+T1Pstq5Cu9z/vgasIgmFuv9vUC903liOoy+ngP8gURV0Ccwx2q3BRK9Vqaa3nROGcg2hj4pxmHQkeU8aF5tdCmpb42PmcAWyAATohjGnjN3h4MdnelPjafGGEM5A7WwPC9aLUFFYPQjths6tbOAZD4WLcYpRt0PJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ucbEUtwH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e5f28841dso4056900a12.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747759696; x=1748364496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K8+YuUSYlYqZjaqVi8KvARVNCx6CmbgvfMwxteqHVYw=;
        b=ucbEUtwHFUacrbqMXKkYJF2KNj/F986Jokx3womWSvJLzsdyzIQJhJUAD+xhCIRI6W
         4pKylJcAkMPcmS5Iji65Vh0ayO2CFCStC4PRwj5vHemWxoB3+i9Dyn84I3rwnytJoQxd
         W3rzIy1wbIYwjJwihtfDSCkQSAyMQyc8w4dRLeXj3T6P4lvhfunfbmAaJeGl9ybCJmTI
         8IMyR/s1XradFshsuKwp7Hy97yInB0E6WPONbl9W6wXmCgRZ/JB2fUoSHzazOAakAKJt
         XPBbsMentzSHMUuJU88Pu/D9/+5nIylmrex3U2UME5znsJYTU2GE9YosuQesyVt2w6Dr
         RxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759696; x=1748364496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8+YuUSYlYqZjaqVi8KvARVNCx6CmbgvfMwxteqHVYw=;
        b=MYEVn2cqQfPuHwD66QOiJnvHw08K4G4rjQeIG/mhsArTKeDwkAqDTXmp510So9B+Ku
         ZrfgztL5nPEGnoAVGnJI11GfpdGTw4V+afnR554al7ega+lxOHMUfwrelMdZm7ZD3dmj
         Us9LUftGSY4/TtnGD0nbXM4YYToehOvEXISV2N80ufrQ5bRrLfBmr7kf5cH/d8Tqjo5h
         ay/rSg8DRpt3d7nn2ZqWaA79ibv8DpqZOyywF9ockWo8TAjTjTYWLd/gQJrmo5iv1+hw
         9i9CaI+PBXeIAk5k5DytSbIwGAXFfQXutgoQ4nsEzSo/HxTxOa72tNO0cOdj0LDMWneP
         47pw==
X-Gm-Message-State: AOJu0YwdSDZw1KyWGzBJlsgM8W5HpiyBiNRbqjslGhakFPP4xdD/UYyl
	KWpC/7urIfNCrm5wBHdDM1RiCpsufNbPnSnFIScejPqXBkgPe/mxtbSPJCk6OmaDrPQq3Sy8d2A
	C7XNmug==
X-Google-Smtp-Source: AGHT+IEu/JMVZpzEiP5lovevj2HceA3rlhx10tlMh6Wzo0F+yguDjIYER5h4LnHBtzjgdiGXgmK1YFTBLWk=
X-Received: from pjbqj14.prod.google.com ([2002:a17:90b:28ce:b0:308:7499:3dfc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2644:b0:309:e195:59d4
 with SMTP id 98e67ed59e1d1-30e7d52b166mr34112928a91.12.1747759695854; Tue, 20
 May 2025 09:48:15 -0700 (PDT)
Date: Tue, 20 May 2025 09:48:04 -0700
In-Reply-To: <20250331182703.725214-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250331182703.725214-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <174774841895.2752531.5751818794863605913.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Use kvm_x86_call() instead of manual static_call()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 31 Mar 2025 11:27:03 -0700, Sean Christopherson wrote:
> Use KVM's preferred kvm_x86_call() wrapper to invoke static calls related
> to mirror page tables.
> 
> No functional change intended.

Applied to kvm-x86 mmu.

[1/1] KVM: x86/mmu: Use kvm_x86_call() instead of manual static_call()
      https://github.com/kvm-x86/linux/commit/6a3d704959bd

--
https://github.com/kvm-x86/linux/tree/next


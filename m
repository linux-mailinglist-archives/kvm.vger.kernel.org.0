Return-Path: <kvm+bounces-50550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9C8AE6FF4
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A864E1894030
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5182EF673;
	Tue, 24 Jun 2025 19:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJViIy5k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF090566A
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794129; cv=none; b=EE/D865/20gMjcX7tKFUBsnCP2L6pQ2nsWYfADGh6jVO5mxAM8HpB5dl/1xxInEb2k09emzHORRguRe8WbzD0nojC913uuKYhPvwAXS1G1nAZQaQMkfiIpKOkUOGismEeCxlrOnXlXuEEPlvkljwJlpdP/EiZJszzbtzVKuEjcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794129; c=relaxed/simple;
	bh=J4vR7SZtbxRakpQGlJHSsT8TJNks6Led0n3EAyUc0K8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRr6qFwj58bllVj2HzQxK79VuFQerWkvKXlqlTRNI6fkYQOEo8rPx1fxKMRVzY4DvedreRzezhKNpiEzG2GMbS1MQHGoYG25mT7KSdrWiqam7+PvY7C/9YxWVOCfvXUVQtLxIzFywD6Maliy8rg97n6uOmXYTd+bXeMtt2W63sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJViIy5k; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23632fd6248so51895975ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794127; x=1751398927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FcIVsm6SwCmai4pYGu1I3g9ltmCQWixFuWfg9AQgveQ=;
        b=vJViIy5kyg957PemRHKQ2O33/m1WVggkuuoQ5APMaaqW7tO01B8jANDl5lbPpQ17QB
         o+/GPh+BnwGHin90FU85P/N6VM+jqoZm30xyuTfn5ZNBqblZTcjwQlqVhopwp0I5Snr8
         xMY9pIJgfkuCVR/s4x8mkPP+LDFNxIwe75CT9cSvfG7jmFHQpitwOW2y7xaWQJXtCCKr
         t3p4bADYCB8Y8KS6n5eaKCogGZyPW4/RiZ9K5rTyg0yNupichuflQ10NRXz25KDkb0K2
         bW6MydUt2ROnwK9Y7d9kSt7rf8X7bkd5CmH4L4IUPk+kh+cpFKqxVv1Y2BcRXqs7Cujv
         Lseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794127; x=1751398927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcIVsm6SwCmai4pYGu1I3g9ltmCQWixFuWfg9AQgveQ=;
        b=wbs7a5thxK/gJhQ4h44iARtGNvwvrjg5SirGyrISQVXiRjHZ6hYeISut95EQe0DvVS
         pzhe16EtRbNdYDtZphc3us97kfksyic27CZohEa/zmgt+UHba3QowRGK+wZ5cFKfcPuE
         CrkdoZeQr0NVXiR8o3Y9KgNNI2V+qsia2EXcMbz76mf+0pkcjyjgJom/h3vb9OVxcvlc
         RvuRfJeGA6WFimC/AI96wYMjeJc4JtxeuRehXQ9AdhReTeI7DPBYn86yj2S+vA78MPK0
         NuOcsI4U2YNrGXqFieKbTQ8rWkf3suJ/pVynPfqRxFuHH5XhY6/l7iwCKRxVUmSU/TNQ
         SS6g==
X-Gm-Message-State: AOJu0YziSZE4YqOvHxVf1nFOm8HqbK7YMCKULia8lT55Ko1N7fdTH6Xs
	aLTakJgpFbZkuekESwrlBXQCnuPcjinyEllqHiTo1lLPdZzfzqhOv1wUlkmC5OASnjKjqUu7fM5
	NV/o6Aw==
X-Google-Smtp-Source: AGHT+IEq6KgpAt5TZlBf/a/lvKLpoi3UG5KRbpv+ZxHvaNEAIVgbzmKUN7CslVZPXksufY8n8U0SLN5z8sY=
X-Received: from plbmv13.prod.google.com ([2002:a17:903:b8d:b0:235:54f:4f12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b30:b0:235:129e:f649
 with SMTP id d9443c01a7336-23823f99aa7mr9831915ad.12.1750794127166; Tue, 24
 Jun 2025 12:42:07 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:38 -0700
In-Reply-To: <20250523001138.3182794-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079268655.517596.11530108670607154610.b4-ty@google.com>
Subject: Re: [PATCH v4 0/4] KVM: x86: Dynamically allocate hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 May 2025 17:11:34 -0700, Sean Christopherson wrote:
> Allocate the hashed list of shadow pages dynamically (separate from
> struct kvm), and on-demand.  The hashed list is 32KiB, i.e. absolutely
> belongs in a separate allocation, and is worth skipping if KVM isn't
> shadowing guest PTEs for the VM.
> 
> I double checked that padding kvm_arch with a 4KiB array trips the assert,
> but padding with 2KiB does not.  So knock on wood, I finally got the assert
> right.  Maybe.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/4] KVM: TDX: Move TDX hardware setup from main.c to tdx.c
      https://github.com/kvm-x86/linux/commit/1f287a4e7b90
[2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
      https://github.com/kvm-x86/linux/commit/02c6bea57d0d
[3/4] KVM: x86: Use kvzalloc() to allocate VM struct
      https://github.com/kvm-x86/linux/commit/97ad7dd0e53d
[4/4] KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list
      https://github.com/kvm-x86/linux/commit/59ce4bd2996b

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


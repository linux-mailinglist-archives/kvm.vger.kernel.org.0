Return-Path: <kvm+bounces-9467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D872860857
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9C71C225F4
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9D81170A;
	Fri, 23 Feb 2024 01:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nmIRYBN6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B477C13C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652189; cv=none; b=FFRB+Hq3PtT/s0AnB/NKTth+GiZgPgh8iB+BMnXuyq1+xlWFKfOAFToZYEMp3lm4+5Mhud3m36OgHKkr75jIQGURq2Be66Q+THCG1hwyVMF//Rsz+njvOkQeGNesF0N9dUjcno1AaZZmFlyuPzvgGhOcC6F6l4LV6cYa3DJH29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652189; c=relaxed/simple;
	bh=wxHfWMq7Lgq0G67zQZ2MnUqa7LLPfz3fmqOUA3OwDDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BFchS/GNO+iRxo2FiPyRoEeGgUYty7uJZ65XXc03HqcxeCfdFBUiqxLxd8S63is7S4nf+GeJ9KuqbHcNmFX4Hz/BWQDxXsbg774e42+tqFZtr4wraDoBS/BOksNF1JrhVwTdEbKRGhL73L7P6uhPNcaYp3QM1CUX7oRxmpKQ49Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nmIRYBN6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ee22efe5eeso7221197b3.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652186; x=1709256986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZOxtidqnLAab6ncFHZHgfs5e5Ab+wmQ1LWEiG/Eq7o=;
        b=nmIRYBN6qgptcdqAMatCANBuBCLZ3VH1z5nGK7vGyuHNAxuiIPPORAdGpvnkWXKv1/
         jgOm4FI29ePK0iq0lzBsqZY57i441Yv/k13CG5J12xfvp3XmqXx/RCMpJoHLpx4QrwBX
         6jFLJ+dFz2lGWVTOI7bmWNoacsR4QUnSot8xNKHR1yOpZ6IejVw59EEM2VTxvwUCvSr8
         x0Arp79ezK0d/i9K48PCU3cPs/+2BV80WO4i5TAZkwDwU0Qr8jcyL3VagCwMPI7NSinJ
         wwSqEvlTEDYuBC+TWyX0Sih4bOuICHMYTffvtX7d/TMripqTZNjRSOLrT130Ci5ISFSK
         Pziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652186; x=1709256986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZOxtidqnLAab6ncFHZHgfs5e5Ab+wmQ1LWEiG/Eq7o=;
        b=ZOQiKIN05Tmzv5G10cxfCH2fd2NtKK6CBoCUpBuiZLT/isDQjIFHozDOj9KD1qUKDJ
         Y9e7PWmOFv2wih1w1ru8t9daFKVq3RI/FgsJsl6pBqcwgxjnsF34CE6HcfiyxM9lp8I7
         kVBrMm4qHEQUKAZJV2uMVKNo5nakxtCXowooOxKjfYSmCfXB19iuhkAqDd9py22w3Uca
         8QVrpS+BCf6DuYpAns8i1otW2yuK547nF6P6/+S1kgpNmVeZ6pA8spWrJ2F1KD9FZVQJ
         8KL8EojsrV4TW8SWP6LWkdrGhwtkA2bv4dcic/V3tBthluCGy5Ev02zrRATWLh0K3Gld
         4wpA==
X-Gm-Message-State: AOJu0YwsGpSBwNHYca45j3jjT0fJlTpBEKhr7K6fYFpD/Z3qYSFmlgpt
	SF5m7iIyR4Q9oDv6vrPVe4l44X+gpTJbOniufmprd++avKB5i1nglJZF19+aDMot5wzYNq7U8aY
	TRw==
X-Google-Smtp-Source: AGHT+IFHKxDxmR9WB8yLWn/Z+MxbjDTvcrp37vqBa/Ljad7x10UvGxm48lqBVJ6xFYEFD1kLViisRCa4Aa4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1741:b0:dc6:b982:cfa2 with SMTP id
 bz1-20020a056902174100b00dc6b982cfa2mr24039ybb.8.1708652186598; Thu, 22 Feb
 2024 17:36:26 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:42 -0800
In-Reply-To: <20240110003938.490206-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864807002.3089764.1263409460793232398.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: Clean up "preempted in-kernel" logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Jan 2024 16:39:34 -0800, Sean Christopherson wrote:
> Provide a dedicated helper to query if a *different* vCPU was preempted
> in-kernel.  x86's VMX is an oddball and can only check if the vCPU is in
> kernel (versus userspace) if the vCPU is loaded on the current pCPU.
> 
> The existing kvm_arch_vcpu_in_kernel() "works", but it's an ugly mess as
> KVM x86 is forced to check kvm_get_running_vcpu() to effectively undo the
> multiplexing.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: Add dedicated arch hook for querying if vCPU was preempted in-kernel
      https://github.com/kvm-x86/linux/commit/77bcd9e6231a
[2/4] KVM: x86: Rely solely on preempted_in_kernel flag for directed yield
      https://github.com/kvm-x86/linux/commit/9b8615c5d37f
[3/4] KVM: x86: Clean up directed yield API for "has pending interrupt"
      https://github.com/kvm-x86/linux/commit/322d79f1db4b
[4/4] KVM: Add a comment explaining the directed yield pending interrupt logic
      https://github.com/kvm-x86/linux/commit/dafc17dd529a

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-68218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF78D278BB
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9669031549F4
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59173D1CB5;
	Thu, 15 Jan 2026 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z3V9IMb0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036E2C029F
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500239; cv=none; b=QpHTfikGwx3E6Dp7wBcCFuydu8ShxcYnckoe+Rl+5VtWzc/IbeTRCZ1P5/uZstK7Zi7P3FJFl2qzuURKkkElRYIp/Rqh3nDHLFA/AvThVDJvuHOM4E1fDtPx+yCu8nlNJFhp0qdJs2wMrbo+xmJYPJdqO2rbz7G1POn36142Tew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500239; c=relaxed/simple;
	bh=FUI0iiFLYP2imlRUS5jmAJI0Yflx/v9Xzv5kSCfqRZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nWzNl0jDos7hqbFRHOt6Bd6MHw2/oYqTrIPpfegUbCFR9Y0xuWGLH/ucu2xhvJ+iyY4TV+y7AazJZaOCGW+MBnDm+JZ6is1rPNgQvd87dENnKtgUaBmPI0F0f1Jl65mPzwzCybr9PMB4CYHneVuDOoJjAdjXUd5Ov2HngVMYDq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z3V9IMb0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so972484a91.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500237; x=1769105037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QY63jU/Eu1CgMPe+kJNatj9znFJfx2OpDX3nRh8FPk4=;
        b=Z3V9IMb0uM4m3dOO3Hak6r9vknIBy8uCePoI0IP6pM0JGHcwHqTjq7K4xG2rDrGg5d
         E80i85sOWjpk9AmFV+vIpMin1kN25jq+x1Bwld6xNeDfC1x8DUcq3tn+5qalCdakeHYg
         Vb0/sF4hamB0PRhBGlYG+Kgh5/9K+W1H71uThpqieG5DGzypuWiRzPkTgp03qK36IG+v
         U+jE2tFbAlFlIgXLjQ/SdGMt1L0rDMwAIRDddG+fQ2zmznSWjh3E8eJDfafe0linWdFT
         YUF8/JmV2tE99+pVP3K7iOf6o1lXqvp33JHsEjuw5AEBNNVClfUWN78EF7mBrgslLVwm
         sDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500237; x=1769105037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QY63jU/Eu1CgMPe+kJNatj9znFJfx2OpDX3nRh8FPk4=;
        b=vu9XWEvk+RsPxFZyRlNrNa8uaI0mD4y3l5uPI/zoOzvHKKRv1idR1tN1Yqa3jsYrvD
         xXFzKiB7dWdsJuJLqqfzOKUxYps69JUQZff6L0hqaJ0t3ZtvN7BOogXN7vs26d4+/E9m
         ddQYrofD0zAhKLO2Xtd8EmqDJ0oPLbNnQKN6NvDMIjCSNo/TWNv2iLLmZxOxLfE3+7wF
         R+MfEAm69atYkvhnuQhEX7fc6je910YU431TbpWqOvkHVSWhlVhY4FARXkFROdEibMt9
         AM/P4wcSKbOShCe+e6XtkgDwplnEgBdGH8NIsDDVchx0InB4JYG+0MYcZCl1DKvHFUPN
         JlkQ==
X-Gm-Message-State: AOJu0Yw1e8CTDPyt8VYeq6FSnOWf2dAy0jq6xUvJ6cXXXcJYzBxfg/4Y
	sSa+UDYJ2IkqYReAi7MPFVBbhhPSMTMoKpwM6ax7pa4bK0JrRYkXF8Qlai1a9J+IE7s8DlYvdAP
	X2Lio2w==
X-Received: from pjpo15.prod.google.com ([2002:a17:90a:9f8f:b0:34c:64ab:be12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5803:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-35272efcc92mr215884a91.16.1768500237281; Thu, 15
 Jan 2026 10:03:57 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:13 -0800
In-Reply-To: <20260113084748.1714633-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113084748.1714633-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849724659.705740.17111378342255599244.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 13 Jan 2026 16:47:48 +0800, Binbin Wu wrote:
> Remove the declaration of nested_mark_vmcs12_pages_dirty() from the
> header file since it has been moved and renamed to
> nested_vmx_mark_all_vmcs12_pages_dirty(), which is a static function.

Applied to kvm-x86 apic, thanks!

[1/1] KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()
      https://github.com/kvm-x86/linux/commit/ac4f869c5630

--
https://github.com/kvm-x86/linux/tree/next


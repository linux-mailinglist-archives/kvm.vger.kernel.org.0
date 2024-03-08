Return-Path: <kvm+bounces-11347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B66875D11
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72CC62826A1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 04:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56F72C87A;
	Fri,  8 Mar 2024 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yQ48m371"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A752C6AE
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 04:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709871232; cv=none; b=bELt/9BwCV1753fbWx23Cart3fDhtHskJTuRxBAXx/YpgGMQjzVxLnrQGgTVTdjZXGU+nPSp/A7qlSAuvVQ04Fm7c/Fb4kgVIe6V7oZ1N8H4EZmnmWQZjnuuG/C7AAcux+01x3kZ9PuvBXAOblXMVrEPRaSuzFWR4ihPUNBQP88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709871232; c=relaxed/simple;
	bh=qCIxyfYIQ2YAaqFZdN2RArkHnfxMrj0cqgZmFTqPB00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tfkDYI1C6Daor8dU6/IIkQdIjru9S57m4fOcLLXIg/86eMsuMUAukTPjoNvafG5xTaCOg+/Kqp40l2GSdG9rpxTQpGy8a1SRbIpD0C/t/6D6CXAiQDk6g5R17G+nvYpUqRvhaoMVJgUQdSnZ+imxbmM3Cf9td3qg3w30xEB49Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yQ48m371; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fb4fc058so9661357b3.3
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 20:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709871230; x=1710476030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tw7ZbqEsiKihQ0Zm7edjlrJvRegrpau9dDzQ/T5cB8M=;
        b=yQ48m371Fmb3slBEXDR0Az4e6jO+mgnvIwZcjMSHZFso52fIgBhSCSXE26asH7iSWO
         dN3+TqOKPf2yy5KEqBf02zLIL3hTPt8TpY0EWEN2lHNY/qaW/6ixQ94QAUJezNxjXuu7
         PDxewT0nU+YDhapdgJL9C7kTk0bRWAORKwkyzCySawaal4d3evs3tQ1Y4EQYn4W10Gaw
         Q5T7Td5579yoQp+pe3NCbtulO9xoUdNdy3MxSnVVcb1H8OpBpsKFFQowF03rBzNOERa9
         ENrUdEfx3xB0slB6pA0Fkp5gzpgyVk/NVtjd2YuiCQRAN67gXxwuVrDRKYr1aoebJK9Y
         4DKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709871230; x=1710476030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tw7ZbqEsiKihQ0Zm7edjlrJvRegrpau9dDzQ/T5cB8M=;
        b=BkrJxPUz30v3gp3Gp1zjqsj+rHx2f7QRNoupsGdl0gs/iza5TL/vOL9wT/dCqBKVQo
         gqLvS7jqfXcbtJ7sSota0zm96UD3XW1ve6cNgxYDm0G48zBerwUeOdXqX7vIAyZkqPc7
         YXq9ASVpH7vusYt24kw6jQIgqI9o2oE/de5exiT09W4uEDveJaFiRwhBjY4x0/1JY8Ew
         VOS7Mz/L1sylmzuRcp82M5MeGQm+YNnuefYyv3hzxa3fnlPSIuEt8sucF3LUo9b0lB0O
         6qVw+ZifE+eRwXE00E5ZwDLjzzjwEHsPNCfAhf34WGrmoBxYnB0yUZALfElo7bpWbk79
         R19A==
X-Forwarded-Encrypted: i=1; AJvYcCVguKU5PWxLVqsultNkrRA1ez598ludij9pxAlwtlonsoCf9zB1SDSrfnaEUmh+P/AnfmwfsMtL4GQDzbBGZDh/32G0
X-Gm-Message-State: AOJu0Yx+iuVLzhD42x3i5clePMK4Iojwbku8Xp7okENKbz/VR69/BW4q
	mt2HAMiaRZnCdXLDutYmb5l9TP8nfxtAKHq2ahdtqRMsx8/6tVvjTIL75JihAWpNmavunnwgRcU
	mPA==
X-Google-Smtp-Source: AGHT+IHadk63LQKc3OCg8CRe/y357x5bfyVRGi/E1H1s9xoMbsvXCiATXb0+tHK5W2MkF7MKY4NvFWSsH+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3508:b0:608:4cec:3e65 with SMTP id
 fq8-20020a05690c350800b006084cec3e65mr4524747ywb.5.1709871230577; Thu, 07 Mar
 2024 20:13:50 -0800 (PST)
Date: Thu,  7 Mar 2024 20:13:10 -0800
In-Reply-To: <20240228101837.93642-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228101837.93642-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170987090131.1157339.1162545682759176638.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix KVM_FEATURE_PV_UNHALT update logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Feb 2024 11:18:34 +0100, Vitaly Kuznetsov wrote:
> Guest hangs in specific configurations (KVM_X86_DISABLE_EXITS_HLT) are
> reported and the issue was bisected to commit ee3a5f9e3d9b ("KVM: x86: Do
> runtime CPUID update before updating vcpu->arch.cpuid_entries") which, of
> course, carries "No functional change intended" blurb. Turns out, moving
> __kvm_update_cpuid_runtime() earlier in kvm_set_cpuid() to tweak the
> incoming CPUID data before checking it wasn't innocent as
> KVM_FEATURE_PV_UNHALT reset logic relies on cached KVM CPUID base which
> gets updated later.
> 
> [...]

Applied to kvm-x86 hyperv.  I won't send a pull request for this until next week,
but I do plan on landing it in 6.9.  Holler if the selftests tweaks look wrong
(or you just don't like them).  Thanks!

[1/3] KVM: x86: Introduce __kvm_get_hypervisor_cpuid() helper
      https://github.com/kvm-x86/linux/commit/92e82cf632e8
[2/3] KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT
      https://github.com/kvm-x86/linux/commit/4736d85f0d18
[3/3] KVM: selftests: Check that PV_UNHALT is cleared when HLT exiting is disabled
      https://github.com/kvm-x86/linux/commit/c2585047c8e1

--
https://github.com/kvm-x86/linux/tree/next


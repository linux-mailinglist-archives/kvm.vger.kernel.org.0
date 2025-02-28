Return-Path: <kvm+bounces-39749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B9FA49FE9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F5471892A2B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E23189B84;
	Fri, 28 Feb 2025 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQ1WDW3e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40D1281351
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740762474; cv=none; b=LHyho1wBgTyATi1IVHPyaOcPV2JDTEHiX4JBrib3WRqwMaDxnPr4oefSH134E+FGOdUASk7tEb+1likCLXJMkLuTzPAJP3GZj+pWzaIA5QlKhD3VBMgqlulsM9F0CqQ/yh2vKT+UW/s7rMsExHltIH0zLi1RXj29FEpsqL+/aug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740762474; c=relaxed/simple;
	bh=xVmIBS8Yry96LzqfMn80N8uQNorpC8OE2/uVu9ohjIs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GxlpJjZ3Z8Jf/tZWAyUHECBcdPTTHlPip+br1D9hRUk6iV1fNRXH5E6ooXDpaexTB3nHVxptmmX6wJ6O9nTn1ISEU4WU1DH4c5EMnl9N68RRSZKWmldfp3Gr6IG+YFOWfuB4ogYclLwfOso4PDnKC8X7RMtdOCcZmOKzbHEdU5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQ1WDW3e; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2feb47c6757so3096902a91.3
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 09:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740762472; x=1741367272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M2oG6zshz8nl2FBqsuMKiFucOLA6s8CVVHZchlrSE30=;
        b=LQ1WDW3eTV8sgDqKB7tKT+rAtXMcbxCbuey4CGjycUgthkgR+IVq21tee/osV0rXEk
         zB0pOLnGy8YSEFQ2F73H3cMArPaG3b8N9gEFz9dmGAu5lteWqi3I3XdE8bgc7uUPJvb4
         /8FfE8Id8CKYu0OXuBDRpafgqgrVbWPBmOf//ZjSg4HK5uDaoqXSVxvqTvK9kLCAXDYK
         +xSiYeEDygojoevS/5viPvGyY6XbKvtQHofpVudpu+xHKPekiaFE5sQSc35EjiB9gp8g
         EcvhJRzQn3MIi7xYIQuF4sXy25ITL0aNY4m0y3Fed+vPgUxD9es+bnbEZpI8VbDwuOXS
         XyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740762472; x=1741367272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M2oG6zshz8nl2FBqsuMKiFucOLA6s8CVVHZchlrSE30=;
        b=jtUwkpuCL1ugX7Dd2hDtLkAchBFmEBvbMGX0OFxlFySxxzMLI4eWpzxlbUy7C/mI8f
         lF2DAlzJhSXvDdYl7gyLX3a59mnmJjQZ5ZeB6DKDjPHPLtuGRkKASR0xRjg2mehyjUB1
         zjhw4jqGL4FMHZrDjbADZL2gJuJCzOIplmGuJHc2ZMK/nvDbGPrpxNKRtFuRX5+UHNvd
         +FyNA2/8FvdmGM8TpudY+SkCSfbkyJObmEtR8r0hL9A98RsQwT20+SmvKZCSD9Ub3Yjj
         SLiPdxsdQRu3p60YPGdM/nWnDgrDPTAGzKRlAnIDf1kS9AG5NldmO37NIht8ZYKg3BJW
         WOXQ==
X-Gm-Message-State: AOJu0YwsVN51LzrNXixJX/O013tJmEJA5XiuXEm/N7vohKWRTmd88ui6
	iGrDvRpW4owBuC8hrj7bCX1bYpQCvqfMXyReqkiyozjswJ4dncW5WPzFoZZFk4ox5qVN/FFTJ2Q
	DgA==
X-Google-Smtp-Source: AGHT+IHxClS6Ov3N4mC2MOcBG8aooiB2l2G7Lim0GoLHj9tgAux8JsYTBZ13NlJ8w5b4r1UNpjTKlpoUIVg=
X-Received: from pjg7.prod.google.com ([2002:a17:90b:3f47:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1ccb:b0:2fe:b470:dde4
 with SMTP id 98e67ed59e1d1-2febab3c659mr7943858a91.12.1740762472274; Fri, 28
 Feb 2025 09:07:52 -0800 (PST)
Date: Fri, 28 Feb 2025 09:06:36 -0800
In-Reply-To: <20250215011437.1203084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174041641314.2341854.17309269285047570958.b4-ty@google.com>
Subject: Re: [PATCH v2 0/5] KVM: x86/xen: Restrict hypercall MSR index
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:14:32 -0800, Sean Christopherson wrote:
> Harden KVM against goofy userspace by restricting the Xen hypercall MSR
> index to the de facto standard synthetic range, 0x40000000 - 0x4fffffff.
> This obviously has the potential to break userspace, but I'm fairly confident
> it'll be fine (knock wood), and doing nothing is not an option as letting
> userspace redirect any WRMSR is at best completely broken.
> 
> Patches 2-5 are tangentially related cleanups.
> 
> [...]

Applied to kvm-x86 xen, with the docs change.  Thanks for the reviews!

[1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
      https://github.com/kvm-x86/linux/commit/5c17848134ab
[2/5] KVM: x86/xen: Add an #ifdef'd helper to detect writes to Xen MSR
      https://github.com/kvm-x86/linux/commit/bb0978d95a55
[3/5] KVM: x86/xen: Consult kvm_xen_enabled when checking for Xen MSR writes
      https://github.com/kvm-x86/linux/commit/a5d7700af6b0
[4/5] KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
      https://github.com/kvm-x86/linux/commit/69e5a7dde965
[5/5] KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen
      https://github.com/kvm-x86/linux/commit/26e228ec1695

--
https://github.com/kvm-x86/linux/tree/next


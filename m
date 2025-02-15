Return-Path: <kvm+bounces-38227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E31A36A90
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC5FE17244A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872081BD017;
	Sat, 15 Feb 2025 00:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SqoOGhAF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F613AA2D
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581013; cv=none; b=Q44yfCLHhGDC2qD59YpgTyv3qnfOz3Q0EYhH1H3FoWH8ba6hPQ19PVvN1KcSi6tp27NvhCI+XrqQDitaOprZDalt1kkL6UD+L6qEewhIftjaBn0c0u2/tAHfQXEDL1CVuUH8LsYTaluBNcbJbSm5AfVz1g4HId/vplVi8x1pLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581013; c=relaxed/simple;
	bh=SlXFcJN9gPIXQ7/UHXvc6Ej3/MtxP+TT4NMl74PBaJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dPGDjlj6yohGrHlkiRoC/K1QUtRBf/4B0MlQkfaofrWkxW0AQ/MU8gAUJXgqXtlKxPsQfONWAlMAAOBZttVXDrmjgB3eo2xr2WebtwK19H4pnN03DYF8vQv8aX84BW3NLjSfqP02T2B7MjLJL85fAjwYQEv47p4vzOSloLGcCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SqoOGhAF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220e62c4f27so53117945ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581012; x=1740185812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XGFU0x6ME31j27M/E1QZf0SjJwI3DZIXAbtz12osBGU=;
        b=SqoOGhAF7j43ZbRoEE/L8ZLb9P9Jg7kPcJuJ/TaGeeBSM8KcwNrcyixxNhDmcZrNyn
         nBT+a/Sf5J7ncNJTi3fqIQU9X5fuOACgaYr+praFaGGd0iB6c/1o1eJIBGq7FTqo041B
         3SW1ewO1zJv1BwxDqaO/k6LIHOYuOaX7gAOukYfsR/SMSdjh+ArQa+EWYz388b75upou
         bPrjZxBBu34upr4jjC6NWfSYDi3w1Sk0dIXTTSjjTCFHmfOojvWpwjQTUzu3LzJJM1ux
         ub+aPtYCgGItvDDbbyVF5V+I62HCVRANgeG3oI7ZzjaO5xzfXtkVGEtbp5mWCDh5k8Ye
         uNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581012; x=1740185812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGFU0x6ME31j27M/E1QZf0SjJwI3DZIXAbtz12osBGU=;
        b=M4auETVQlEDszO9PNLG2kGeCe6caRkwuatB1Kj3Vk64Se3FOc046mcKzwHF5BtVBBe
         R1OlmlKKTgzB73c4UFiM96SRTV2yx0ACGHHNsJ8lFEzCYWWHG/0l9GYGe9SMjBQujw9l
         IJYaC+BhDJ03e2S+lR6XrcBaS26D5viKUzBxgUXg67CUSpOY3I7DzR4jWjvLXaJApePW
         fYpPLWDjTrD0XGXxTuXdDCpRqCqslrzindG41achZaFoIOauExtp6crUHzQa57Mft94P
         CW2v69KM7OvI/FwhN/+TWDYyd49/g8cc7VLMXboL8Q0BvMsmPKbNr/tkzcp7dZuVApZ7
         qulQ==
X-Gm-Message-State: AOJu0YyQ9h0LnZwj3ve2VPSuYO6aWAu/aYcSsXNXFlQGVK9SDm32/xpQ
	Fc0h5vZgrFTEVfFyh35yqqndPJE17hy3HiiAA3AHkCGJdyErhXFYCoQMVr+H4R8ZIwXQGKSnrl7
	f3w==
X-Google-Smtp-Source: AGHT+IGzjZ4q3ipCJ9H8WgyBye344Mufo5MgNAaVcmrLT+j8+QI69Usa/fdkwZc427X31ScOU5PG+HDtyb0=
X-Received: from pfbcz19.prod.google.com ([2002:aa7:9313:0:b0:730:7bad:2008])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:619c:b0:1e0:c77c:450d
 with SMTP id adf61e73a8af0-1ee8caab780mr2596787637.1.1739581011703; Fri, 14
 Feb 2025 16:56:51 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:39 -0800
In-Reply-To: <1739241423-14326-1-git-send-email-yangge1116@126.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1739241423-14326-1-git-send-email-yangge1116@126.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958047445.1191117.9513441851544868586.b4-ty@google.com>
Subject: Re: [PATCH V4] KVM: SEV: fix wrong pinning of pages
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, yangge1116@126.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, david@redhat.com, 
	baolin.wang@linux.alibaba.com, thomas.lendacky@amd.com, liuzixing@hygon.cn, 
	Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 11 Feb 2025 10:37:03 +0800, yangge1116@126.com wrote:
> In the sev_mem_enc_register_region() function, we need to call
> sev_pin_memory() to pin memory for the long term. However, when
> calling sev_pin_memory(), the FOLL_LONGTERM flag is not passed, causing
> the allocated pages not to be migrated out of MIGRATE_CMA/ZONE_MOVABLE,
> violating these mechanisms to avoid fragmentation with unmovable pages,
> for example making CMA allocations fail.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SEV: fix wrong pinning of pages
      https://github.com/kvm-x86/linux/commit/7e066cb9b71a

--
https://github.com/kvm-x86/linux/tree/next


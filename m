Return-Path: <kvm+bounces-24985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DB195DA09
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72C15B24857
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C281CDA2D;
	Fri, 23 Aug 2024 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V/fVVELO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4611C945B
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457506; cv=none; b=WHnr9OYtwf1IOgKnMgOlU/JVek2aTzbI+j50QC417ej/69DFehR+KTnro1pJDEGOf/cd0a5t2yHS4+2TQu7FoU2ybaFganG46WxrEBjSoCSG9y1XUjqbNWjt3iP28tr4oHf/FKGiHKpNuMQ63D03hN3xIMlikxKG+lRmfN9Ma70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457506; c=relaxed/simple;
	bh=6E69GvJPGdqxt2NH32hfsxBD5Do1vLXWCTXhETYAFdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d013oj+UXFEkILgbdFIDsvnofZVhL4dUa7WN+YCo4MlWP0TFQuzrSmGLemLa9+B7C/2TgWGHzyjVZqDlFrBsCEtLuCQgFdWzxAcII4NJ/DS1p+nNWLpqNTZm/DM40Fft3Q6CAQfivvDMK4Tr7yx2mYmGjPrQad1IWBZF1Y+/hd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V/fVVELO; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e11703f1368so3563081276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457504; x=1725062304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ne9zdOPDN3O4vN5PAEI4z56i5zf9nmVI1XqBuuU+Bks=;
        b=V/fVVELOCcdNZMSyM0HAao+CUusIUMJWwHInxewMies7QmH5LW128BQGYpHZYSlWQ2
         Qfiqnt1o84XUWwDulEepHaRCdEFSHZQ08GllYBoa2xCWmR5pbs9tOxP7PDXZIl+x9Xuz
         ceYvsfr8+MM533U1K6jvdz64VQBnLDwwBBPHyYMzFlfhBlGZFACNJRMbwXoGYkbSSiHM
         auEuWjBicJR9ZZncLD0xh5teZ45Bhd3tnyaYVB1nPMZ4GMmTSwAKhEG+ke24XE95tU/f
         AeEiBSLLWLNpli5OWf4zhoVkUJyPot2588spUlcNta+qgSGgr9VwM4hkF28w1C+j5hUM
         9fUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457504; x=1725062304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ne9zdOPDN3O4vN5PAEI4z56i5zf9nmVI1XqBuuU+Bks=;
        b=vj6FVMKX/e+lXJI/SMPspPjmxGDWi63h0D9b+vHXeNRtwRJ7vvtW1N/Tm881Z1bzVl
         o4/ybdtJM7bo1LUTnjp3gJIw9s4a8zQY6OQdnQYOxE3c2GtbQFNQwjRIph7eV07VAl+C
         niHWYsBasn0x4AWUiZMRG54bCMzaI4uolZyFC6joP0pgS+C4P/QOoK1rdVuu76gGsneG
         o7sMsg7/Sku3RdPgWoOAgoDou2h5F7tODqeBopLGvZ4/H7pUsiUYlHovmVnugWpJOmiU
         Ff5bdFjvOT+5tiIhTTTn7yaVVV9dhbq0VcTUushvjeE/two5Cl8jIzaV2VnCE81UQESo
         l34A==
X-Forwarded-Encrypted: i=1; AJvYcCWsis+poag4uFE8sWxisTppVMA0lXH2PurmnJNAeGftToeGenzHUmd5GIgHqT1RPufymtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAIlQn13kLe8vYWJDcQolOasx1p+M5twED8crW39ZsUHPke+XW
	eCQim6RDfRVn+tEc4oErd7NLHOTW3dmNYtRUXL2IrVgD8cSHraz6t6z5AhBuDJCdfpM7V4fbnd6
	4ig==
X-Google-Smtp-Source: AGHT+IGz/iWUdwbfB0BiGGEXBQL2sxNDKimdIddb9xQzKYiDa+L9/VRlHd16z1WWnv+dhFnv8E9uVzciSXg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:32a1:b0:e0b:bd79:3077 with SMTP id
 3f1490d57ef6-e17a8630eb5mr5939276.9.1724457503665; Fri, 23 Aug 2024 16:58:23
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:48:03 -0700
In-Reply-To: <20240702064609.52487-1-liuq131@chinatelecom.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240702064609.52487-1-liuq131@chinatelecom.cn>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442193750.3956514.4353305637473091452.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Modify the BUILD_BUG_ON_MSG of the 32-bit field
 in the vmcs_check16 function
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Qiang Liu <liuq131@chinatelecom.cn>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 02 Jul 2024 06:46:09 +0000, Qiang Liu wrote:
> According to the SDM, the meaning of field bit 0 is:
> Access type (0 = full; 1 = high); must be full for 16-bit, 32-bit,
> and natural-width fields. So there is no 32-bit high field here,
> it should be a 32-bit field instead.
> 
> 

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Modify the BUILD_BUG_ON_MSG of the 32-bit field in the vmcs_check16 function
      https://github.com/kvm-x86/linux/commit/caf22c6dd312

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-68225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BCBD2794A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D419B3179311
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A16F3D3326;
	Thu, 15 Jan 2026 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CHkPA64o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A463BF30A
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500404; cv=none; b=n19JbTw5skxrGogxro9ef7XQxb/ZoJGkDlJMR68q6Rq/M8CppF9crLCRTkXBU9eGFSfSmLQxBG2f1yTK3tfPO1TIUUpbfg7H7mDDPZjfEVBZ0SaxihCIy1S+SkdHPN4lrqY6H0TPy168qGEHZV2xJu7ExBpVBjPnCjpd8zqJ3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500404; c=relaxed/simple;
	bh=0aeAyBDnKHvIDtFU+Bzc5NiOeUlTvSEwhy1kNLPL5uM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RcHjAMwzAxJovrFWTBkoczVKOAbzd1q7M9tgVglmpyOHKpWkBEyiO4SurpGANPfs5yVeKV3B6b/kuuh3yx+vcuwzRF2znd99b9tfKpFZAU9mBlMWZYa5BTiluRtlBKLDlgpNEsCbcD3G1OgxG2ourIgVI4M8H4k3lDF/nbCM5YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CHkPA64o; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c904a1168so1064837a91.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500403; x=1769105203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eJGb5mqNQAqOeMXHCtAlnLfiPVzW38r+Joh5J+UmC0=;
        b=CHkPA64oPFUPmM/yvxys4cdMwfg/eywX9vMeF3sXxMy89KDuNh1s+WlRrj9Ss7fAx5
         +Pv+LEDdT0inICxMP/SysXgsNEr20ar8w4KscMnftt92a4+HZgPOS6aa5oviBXgu1Tio
         QV9S2MzxiJd9xYB3iPZjScNiYAZA7CBWSOkKV/8H602FcsOzQ1/YwBL+irvx10+nI7ot
         RkyFAmUtoV6F10j3v4y9x2TnT9qJjr0weh4bg355Z4rAZjsX7XVi8xOvHyiqMX1AARBW
         fL8GPR43UOsmFx0RvuQIKYZa9DAHfgKtqyF6dTrzs4VezhB6jezIIpFlZT+tUEqoIlRu
         +oDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500403; x=1769105203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eJGb5mqNQAqOeMXHCtAlnLfiPVzW38r+Joh5J+UmC0=;
        b=KWJMrO0OzYfIVpQhpzXvXxFzA+ZqfSNLgIv5rKo7xSvw+RnT4mPepRjJ1WStzDaLED
         0mSmHX7d8kU5LtnGUBaqcyYeam5bmFVQ6jK+H9Vh3cjeA4QZcjOm4DllT3cjt0gsG3El
         w8W4XpOerUxpTKIDPx6Kv1YsrHYDLESqEp5er8mS5F1/KwOJlnoe4wNwqaFlNckX45Pn
         1cAA8pixZYCdpx1bsIjYAj1EgJkoorDFLOPh2Hy1OG0cf5fOcuBlxReASEPJPzP8luRu
         GgtWPxnL3h0beEa9JbXnX6yh/S12BsJGDFozJhyeQ4A1CJinv2d+YNfDsy1Zwu9udMdz
         4rvg==
X-Forwarded-Encrypted: i=1; AJvYcCV+5u5FSDTSnkT7WFhGR5EKyoq7yGWtay3kAFqpmA0Wa1HvMpQwuczy2H9XMDK1PS/BBVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLnCIXzdTaT9aVKofISAET5xM79AnpEbmt8qUO/gGBfnt8NnNM
	fHyoxuGIhjgjLQHFdsFtLMM4sabVat1p7ur5sKW3O56fSGp/OXndmBEw/IV3Aeim+lpKfoJwzzr
	6h/47pQ==
X-Received: from pjbft22.prod.google.com ([2002:a17:90b:f96:b0:34a:ae36:b509])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8d:b0:34a:b4a2:f0c1
 with SMTP id 98e67ed59e1d1-352731666e3mr191679a91.16.1768500402658; Thu, 15
 Jan 2026 10:06:42 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:30 -0800
In-Reply-To: <20260113171456.2097312-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113171456.2097312-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849723890.705555.5039008421742485282.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Slightly simplify memstress_setup_nested()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 13 Jan 2026 17:14:56 +0000, Yosry Ahmed wrote:
> Instead of calling memstress_setup_ept_mappings() only in the first
> iteration in the loop, move it before the loop.
> 
> The call needed to happen within the loop before commit e40e72fec0de
> ("KVM: selftests: Stop passing VMX metadata to TDP mapping functions"),
> as memstress_setup_ept_mappings() used to take in a pointer to vmx_pages
> and pass it into tdp_identity_map_1g() (to get the EPT root GPA). This
> is no longer the case, as tdp_identity_map_1g() gets the EPT root
> through stage2 MMU.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Slightly simplify memstress_setup_nested()
      https://github.com/kvm-x86/linux/commit/f756ed82c62a

--
https://github.com/kvm-x86/linux/tree/next


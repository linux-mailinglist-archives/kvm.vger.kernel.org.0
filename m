Return-Path: <kvm+bounces-53841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17100B18409
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 16:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3811517DF52
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 14:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C0E26CE3A;
	Fri,  1 Aug 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ShCwZM7W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1591E50E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754059143; cv=none; b=P1Gcxhc/P8WY2sDOQYWuCfkTj82uhLSYge/WjJFX3YNYAqaAl0AwY4h/BPGGKbpz+hb8MPsOgTHQoXn9L4pOlbfRjS+fv3eJFwbs9+AFQ+qVU8dH+S2JJCpKmYw9SD1JN4W4W9TTBEIk+JZnqcx7ah/AeOusZjCkq10bRO7yx+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754059143; c=relaxed/simple;
	bh=U5Or6D3NRoBpN43zLbUnWGUOaGO74yjKtNGaeBv80m4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s08Qv9QI9ta9rNRQqiAzxRRY8lDUZbnSCut9QxiSgItVKIK4LjQ50NDTmzVbA3C3tQRt+O+VVRbTNViaDhywNytE54Fe4+KRzPbrUs9rpZg3SPqf/zdl1MO+Q//kC4qSEjq4qvjSRuLKMHHpOB2sba31cjFL3rrnHP3ZuqfxjVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ShCwZM7W; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31ea430d543so1055333a91.3
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 07:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754059142; x=1754663942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/evpTted0KWagPhW0zbnRzfoAFtjQ8q4sV9ifqmLIaE=;
        b=ShCwZM7W1mt+rC/XadZ5nGMXTGEh0HB4LE87txm1cYSR5ioVFAI16V5231VnvEroVC
         37EnqyC9tgDGAq+ONIaw0C8r+t687pIJhpy3pMGeQO1weKMUHVYEKnc0Gr25lPi5irpH
         fEuF2Wdf07vpE7GDkZnGdtEClSe+Kv1M8Cl0tTsbDy3XwlZAM9Cd1aReOX0IhqUq0JMx
         LmKeV7gfz8xY3mv9BX6FrvW8Jdiw/kF9aIV/jxtQGWPoPtxfyB4McL80iYe2Zcq2Eifv
         XbQyIfB1gSexJCSnLWiA32GjLX5+P9uZMgipzLd61uzoUNnfbzaJSsBc479sb7gtIZ4h
         zGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754059142; x=1754663942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/evpTted0KWagPhW0zbnRzfoAFtjQ8q4sV9ifqmLIaE=;
        b=kJJ5FS+SxBgUZekqKzLyNppWN8zNkzpmVEu/iwOVkZHruL+9o017/ykgLpLRI3wOek
         PHT7cjeapfIEfRULQDUr9JK1HzwUDUsOIZs2RSk3CO0JaZYLs4x/wKj8xP4/LbdnaQmb
         0buV4ww+mu5QTa6zjjpKD4TOSTksr3IzggfZi8IHrw/lqLN0NUJ/kFwLiuFCH8T4B8jt
         hI+LdRGv7qsaUGlSEzs2yb3XThLe9HyW9D3iCU3bcdAxEAiDxFnIpfJ2u4niZESjs3y1
         A5ClACfc1RhfFsRdXU0x7FP4jZW/KX4Bxz8Zc85Cc/B5zHs7j4O4sZZQx1XUAghRJO+k
         Dt5g==
X-Forwarded-Encrypted: i=1; AJvYcCX30erJFaeV/95k+FzQHSENx6rilsbPXunxUulNPr7AcVrGGxHZ8nsI9E8qtdbLflAA3eY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwapicZsiqBC27MNZgNYxG4QwB8844K1y75SdnT/EpYDc0ru/7
	wtjbdl58uLfg+/nNh12BHdAilpg/ayEVCURJN7T5clCdFck3bIAY5LCNm9vR1um+2brVE0k2Zi2
	qj6fHAw==
X-Google-Smtp-Source: AGHT+IErf5mFW7eycP7uOftRa6st2gphx5ZI4tv3ZyVlCyQ+Y2NW756Z9s10ZU4KCEqSdtShOoUrIsBP/Ks=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c04:b0:31a:9004:8d36
 with SMTP id 98e67ed59e1d1-31f5de54abdmr16391258a91.20.1754059141926; Fri, 01
 Aug 2025 07:39:01 -0700 (PDT)
Date: Fri, 1 Aug 2025 07:39:00 -0700
In-Reply-To: <20250730174605.1614792-5-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250730174605.1614792-1-xin@zytor.com> <20250730174605.1614792-5-xin@zytor.com>
Message-ID: <aIzRhGVgZXPXNwA1@google.com>
Subject: Re: [PATCH v1 4/4] KVM: x86: Advertise support for the immediate form
 of MSR instructions
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 30, 2025, Xin Li (Intel) wrote:
> Advertise support for the immediate form of MSR instructions to userspace
> if the instructions are supported by the underlying CPU.

SVM needs to explicitly clear the capability so that KVM doesn't over-advertise
support if AMD ever implements X86_FEATURE_MSR_IMM.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca550c4fa174..7e7821ee8ee1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5311,8 +5311,12 @@ static __init void svm_set_cpu_caps(void)
        /* CPUID 0x8000001F (SME/SEV features) */
        sev_set_cpu_caps();
 
-       /* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+       /*
+        * Clear capabilities that are automatically configured by common code,
+        * but that require explicit SVM support (that isn't yet implemented).
+        */
        kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
+       kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
 }
 
 static __init int svm_hardware_setup(void)


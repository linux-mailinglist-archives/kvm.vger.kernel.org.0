Return-Path: <kvm+bounces-57654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A08BB58955
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8ECA521F22
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2881DF75D;
	Tue, 16 Sep 2025 00:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MYiySJqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF501A9FA1
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982486; cv=none; b=E5fThyKWNtGsAC4jhUMhnHiSE8oV/xnHFaNw+fEWaYUmv9N68WWFXaYpPPNTmfduEq1Fxp7Np89uaVLDfU2/ZZ0SpVPvv0ao8sH1Oq3cQJnpSLX1rTM6DhdskUrsJHrMN2kKI9qGHmSEguObeho+ReyolYkdU0yMEhuS+IzZnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982486; c=relaxed/simple;
	bh=MCUf77Gz/lK6ZggbWXLAmKsotAhvxZH/0v10hnJKq60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=bpWSjaalFh0UfdtwT41PG2R2XlJR6AmQzHjy5nHsTBb3tdryZRbg/x7rPvXMWQljE6PIIKIoE2i0sUirznHcJdiunteWTX59vLi0XyutSA0udzpcaP84em5yABv9yTEWCg7hMzJ2dQhxLABR7yUiecYdt4f74xnQPyz+K21KqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MYiySJqs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54dd0b6abaso560570a12.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982484; x=1758587284; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wwYTtvQj/ZCf0ydDIZizkKLgJE1+9J8FoZX9j9aEnrU=;
        b=MYiySJqs5s5L85TAv3e2bFD/9TdMXi/bk5p/y+7MxZmNnm02W4uReOTU80ztdxC6P/
         4Zn+1dMxpqd1Joq4nm5t/fre1lVrOnZVVm5o4nv1Qu2ZUY6yq3xIa0vKPyulR0CnGl1a
         aK0hXPRZSYa8/OrvdZLq84AviHuL5zOdJXPnZfYo+d0ekkz9w5aQ9UlddjyT3nnxQDMC
         2ixFHtDg3fE3JQvoOT3wG0dV1ztUXZv9jZlmHc+RCb0MVuoivoj8UJJMthXYGTxAHQYN
         t3W9AzMnTFxuVAAG2KexMPXDBtEOUbr6lFC4/w3D10lLgxB3ySAN/zh3M9yp5Ep5Zyph
         0CgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982484; x=1758587284;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wwYTtvQj/ZCf0ydDIZizkKLgJE1+9J8FoZX9j9aEnrU=;
        b=eMdVR7nVvLHNI5QcltG0X/xPZHn7hUU456HVX/VblPm3mtHq0Ci1UhdFsZejTXf2Ke
         7eeyx5M3Zx6jMWxo+vhaAoUtQ6ESGTOy3VvjdB2dedl+ryTrxlOuUijgFgG6B0zf08gT
         u2/LiK/zt9nn8IK6imahHWXtENy90Cl+Je0pYGtHLJ9FVAQPv2IF9IHam39fuaCV5q98
         8vvcWYyNlpjg+civ8BW46msJufuUCUTGda7j5C/TGSIUV05TefXmq7B09MD/AVfv0bA1
         Fw21Hy+X04BxZjnQAGX/O0sN8PddY83PeyxU0ObUX0VNz64diUIADBstn2GVAYchP2TB
         TiVw==
X-Forwarded-Encrypted: i=1; AJvYcCV8EAggbpq/Q+M2X5oLyIkb4HNclj70ZrwEmlfvTiw7WS+QhK0eYVihXOIHMNTPvCrRPLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDa197ZFBiZLY8Jdx1If6e2sXo5kU/jrpQOTJbb71TDBF5pA/q
	sM4YmEoOnNIf7hFakxozFLmzRtqOvKSDejnYALY1hiU2qSyj2x3qn10YMzuoj5Jt1OflLl2uhRi
	/3mPsrQ==
X-Google-Smtp-Source: AGHT+IEJET+77RUZau/4VM/H74JZrLMHstTVS/doUCPwmR2PI42Eod9+5xmCVbbDww4XM3v/CVSIOsU1j7M=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:32e:371e:abd5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d543:b0:267:9e3d:9b6e
 with SMTP id d9443c01a7336-2679e3da5acmr37112215ad.51.1757982484476; Mon, 15
 Sep 2025 17:28:04 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:41 -0700
In-Reply-To: <20250901131822.647802-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250901131822.647802-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798206914.624430.1356425451234333085.b4-ty@google.com>
Subject: Re: [PATCH] x86/apic: KVM: Use guard() instead of mutex_lock() to
 simplify code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Liao Yuanhong <liaoyuanhong@vivo.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 01 Sep 2025 21:18:21 +0800, Liao Yuanhong wrote:
> Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
> error handling to just return in case of error. No need for the 'out' label
> and variable 'ret' anymore so remove it.

Applied to kvm-x86 misc, thanks!

[1/1] x86/apic: KVM: Use guard() instead of mutex_lock() to simplify code
      https://github.com/kvm-x86/linux/commit/50f4db196766

--
https://github.com/kvm-x86/linux/tree/next


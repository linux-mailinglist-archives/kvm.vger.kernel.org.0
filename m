Return-Path: <kvm+bounces-64228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D22AC7B64A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 262EA363D8E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842F32F3620;
	Fri, 21 Nov 2025 18:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfozjILo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B3B2D8367
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751340; cv=none; b=RNF+jhQ7GkoycGx4FWnaI83kybUv9BaKoz2Lxt2W/rz/492+6nsS/UQEZK5hbN78r5fmoQz5uicG5HhRSJ6m/geU520jLX5BmyvLU2PUrK3hL7S4rGvaaQjwLN5quX8SMGvHf7vbIk0L+9VNcCCcXK2qoMjLzpKX25CF3cc2K4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751340; c=relaxed/simple;
	bh=lMozTflEnZkjmCXJPPx3fIg0Br6QrV1iFo81TSfgT0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gTlJiN9vTC17AnO0zFN9wTkvTqwR1vx/GAv3nQI32NAZZlX2ZWnJxlafDEfcX5AT1LI6jXzu0WEjuY4RSTkGmsbmrU7auWOkwk6mMz4EZkJrV2WgHH7m/fEof2VwVlVVFPuSrX65g7TBF3y2QWZ2YVDdWvofi2M1JL4OJ1MeX/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfozjILo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7bf15b82042so3378718b3a.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751338; x=1764356138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUAmzFYNxxdFW1RpfUQUnWX18V8qcQcBZCRu13KLV8I=;
        b=UfozjILo3tgZO/bSDjw7XkLUcpliVFX017BeH5Rxf5XmR+Io0QaQ3QOdAdMik2gTLC
         7akecCBQGNC8n+hOzAvSWSC+MqvzLDmZgnROYnY05wenhwBYOhQyA6puNvp2gqoYkd60
         qRJYvE4Bggr3ajuNUeBftApfEZ/CVfGMx2gppy53aKOaGYoUIXlX1RpVYM0RRm4IuWLO
         +Gdg/cN1SOn3w9Ooe0385df1tizKsvFS7mbZBfpji9s97LM/0IfkwI5+SZUSHyCLR3Ba
         q78AcAPuhrQqiW7s1KKtWO3X4+CpigOco+DKqJCsVR+svIKVOooUpG6MqQRtZ9owSank
         821g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751338; x=1764356138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUAmzFYNxxdFW1RpfUQUnWX18V8qcQcBZCRu13KLV8I=;
        b=Y/W8iSVCKRYy8d96PtjW8G4G2BI62RW4bPKVACOycgUxucGTs8kWdBE712bGzwBXlx
         WcE+eB9Iw4Peteyf1S8zrec2Y4GFnzdHRIx+P8dOoVtzYIlyf8FSRtXNYflQKE/1S3Nq
         6UwNwWgvmS83Nq/TA+zztVYY0IfRo594IoEDPt/zeTs5FJ/6fSm/EtMwCImw5YHpv676
         v4T5cFM7ROEwqrd0GHGStqNsezDc1ug/SmGqQpN33/rPeKvVOQSB0o3np0qkQmuGpOgr
         //NnXy/IDVJEn9ddIrjEV+mAPZQ4W3XzENEyHK0cQ8XLI0EPgMLZ4rZzkOSfmHuCKwNx
         6szQ==
X-Gm-Message-State: AOJu0YzOU/nz8/NFSqamvovXqOLxUn+0vfxzBrv61kOSGZaMhf2LlHht
	j7ypkoPnbV1UXcLh1VM0J1iZosNTUIK33IpzxH//DhTs7zzDAQjvyO7hHrB0hPbarUYzLQKP3JB
	UZWsZXQ==
X-Google-Smtp-Source: AGHT+IFb+1Vdxv4Q2MBki9nMzF2s2JAFjduHnz+LNOb+RMRJnI9RpAi/kWmMpFhcoVp6qKo/S1NK3Np/EoY=
X-Received: from pgac3.prod.google.com ([2002:a05:6a02:2943:b0:bc8:5648:d6bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3086:b0:35f:8b63:4528
 with SMTP id adf61e73a8af0-3614eb18956mr4311841637.4.1763751338277; Fri, 21
 Nov 2025 10:55:38 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:25 -0800
In-Reply-To: <20251110050539.3398759-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110050539.3398759-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375128951.289987.13847139471945459021.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Add a helper to dedup loading guest/host
 XCR0 and XSS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"

On Mon, 10 Nov 2025 13:05:39 +0800, Binbin Wu wrote:
> Add and use a helper, kvm_load_xfeatures(), to dedup the code that loads
> guest/host xfeatures.
> 
> Opportunistically return early if X86_CR4_OSXSAVE is not set to reduce
> indentations.
> 
> No functional change intended.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Add a helper to dedup loading guest/host XCR0 and XSS
      https://github.com/kvm-x86/linux/commit/0b28f21ad462

--
https://github.com/kvm-x86/linux/tree/next


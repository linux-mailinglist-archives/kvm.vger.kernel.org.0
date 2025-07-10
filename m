Return-Path: <kvm+bounces-52070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73015B00F54
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B38B1CC009B
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B672D322D;
	Thu, 10 Jul 2025 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oulmYX2r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBB32BEC53
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188995; cv=none; b=fn0Q+7rCFuNl+oa4+fPxE3q0JIJOzvH53h2PfUMHvkwsCihtPZd5lzmBcSlGElyqQztmHo3Y28UGBt/rXanYAsG3934odEG2bVszV/T0gqr6WbxfxXymzb7mjpLFqd0RLTni2CpYBw72lONJ3kNrH81Df7+fRVn/1w4AbeSjG7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188995; c=relaxed/simple;
	bh=rDR6TFy0U1+b5Ym9QhsrmAuvjwRfWzlAYTN870XnoWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s323pBo41tmoCco1kUG1hYdLfjoGicTNps59aLIsLgMVphPqHYZfaqBe7HRDq5T1K5/o4vMTdsZChR/P6fiCSJcWR7bGnXGOa+fSlk+yvBW1S+vZP7nrUju+5A1XI1FSGQ7JmLY5umrAKD9AOnqOff6i/7+9pTpwDrFm8Zalc70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oulmYX2r; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e64b3f1so1963977a91.3
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188993; x=1752793793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=67GwB+aWyumwRZOh2fINIZ/EYoiexZgJdVtrS9LdzOY=;
        b=oulmYX2rCjWPySXBUpjljAnUIWM+0rE7jd7wXo8dAa4BITFOTLkBTsSU+DrIoawIEC
         fYxWrS1t7UEu/XaB8oLDCofLm1Nte3XZNarBhP4CEmlQM7bJgwpwzG4teE+ZGdK9b1QZ
         IroMbvL5FDmTLMji/QKb+qWy5xUKqsWudiF3hkoChNyFy4nXRC7VMsp38/Hu2iaeAshK
         /Jp7gBSY8j9NmJf0W2iw5iQtaPFeqP3JM3KrHEwk3MJAtkSjLw3e1SJBzCT8qAyUf0r9
         I6n2qe4cxvXhuLsIy+Wp9Z97imwzMSV5C5KQ3/K9Wk2ZuVjJXiZKA1WQAsNzr7uQtBVB
         iVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188993; x=1752793793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67GwB+aWyumwRZOh2fINIZ/EYoiexZgJdVtrS9LdzOY=;
        b=nmsWWBy3cgh2bL1DqWWaodCi9g9fSj9OdTKGY8HOO1mBRDjrCgo6oPYrUJTcInHPF1
         hbFQNGAu2KFJz0kPwos0vR+4ZtHwmaM2yiQ+mNgILfcc761QuthsG77ZgIY5alXpr0/n
         78EuXau3tUhFOT8ZfvAJJoNuc/2sJP5R4YixrVk3WLgh4Xv8BIh5mibx16bbdpTRbfSp
         1K9Cy4kczOF7zqL95I2mbVzAz651aLQiuX0nhtxqOdbio1M8Oaa4b+houa2qBJwMXzk7
         qjvqktYpBQNwMjoLpzyCdTLpYywgmDwVVi5zT2UimH8lt+AXr+l4rZnrGdX6qymiR0by
         n2Iw==
X-Forwarded-Encrypted: i=1; AJvYcCXFi3333EuoKej15OcOXJMOU1G9CQcmmfbOtvVhh9W+bwH5FzkpZqrNT6ohGw/XF096ofk=@vger.kernel.org
X-Gm-Message-State: AOJu0YztcRECIERljNQ1eM+hynag93I4xf16z4crrwea4kABdpM1/mje
	3NYiahG2rTcbyv3Grx98jhPojzwh1QEm6YOeeS1fjT0SvRr0Q85xue8AYqroDUqeX4lI6kdIn7N
	XjEHTVg==
X-Google-Smtp-Source: AGHT+IEo94Y3+LJsQbHDiFEaMdeiLRqMSRnEEoCZTsH9vs3Gi2iRWPU6d3/xOwSjelhz6h4GAhCCPZ+Zu1E=
X-Received: from pjqq16.prod.google.com ([2002:a17:90b:5850:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5710:b0:311:a314:c2ca
 with SMTP id 98e67ed59e1d1-31c4f4b557bmr528192a91.6.1752188992830; Thu, 10
 Jul 2025 16:09:52 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:54 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218114710.1488061.16698832498491480621.b4-ty@google.com>
Subject: Re: [PATCH v3 0/8] x86, KVM: Optimize SEV cache flushing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 May 2025 16:37:24 -0700, Sean Christopherson wrote:
> This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
> flushing series[2].  The combined goal is to use WBNOINVD instead of WBINVD
> when doing cached maintenance to prevent data corruption due to C-bit aliasing,
> and to reduce the number of cache invalidations by only performing flushes on
> CPUs that have entered the relevant VM since the last cache flush.
> 
> All of the non-KVM patches are frontloaded and based on v6.15-rc7, so that
> they can go through the tip tree (in a stable branch, please :-) ).
> 
> [...]

Applied 5-8 to kvm-x86 sev (which is built on tip/x86_core_for_kvm).

[5/8] KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
      https://github.com/kvm-x86/linux/commit/55aed8c2dbc4
[6/8] KVM: SVM: Remove wbinvd in sev_vm_destroy()
      https://github.com/kvm-x86/linux/commit/7e00013bd339
[7/8] KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency
      https://github.com/kvm-x86/linux/commit/a77896eea33d
[8/8] KVM: SVM: Flush cache only on CPUs running SEV guest
      https://github.com/kvm-x86/linux/commit/d6581b6f2e26

--
https://github.com/kvm-x86/linux/tree/next


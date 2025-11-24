Return-Path: <kvm+bounces-64335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA88C7FC0F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 58FF334B290
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8876A2F9DA7;
	Mon, 24 Nov 2025 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YuidMMKd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6373D2F7ABC
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763978028; cv=none; b=dVwmjxInNSs2Y3AVSYxlj5YOe5Qf6VoxA3FB2XgI2gIhOyjUnSOd9zK5fqHrKxoUe9azpx7l9LUnM8UfbvynUN9iy1URCAiGqJD9370RuMea2IrGdqRyIpfyBdFsLQMECvRLmZEZjIGqKdTx4dBF/lgol58dMX1ZbQaedtVrnrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763978028; c=relaxed/simple;
	bh=wiljrihrTFWd3VE/1cDCgYhMxXMGfwVuactaVXvw534=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeA1c0yO8BJo5MS7BVSjl0YovhIQXRXVsM98QkCSNKcrGERPWNWpzvlUcBPZ1+BZxlpxdimiXKFQF9eoOl8hWe1aX0Wg2RjkVgYQzlazZii1Uj9hG1aM/rBVxGJJrYiaFeWfxw0YuZr9AwV7QX21VfS0oG2fFFsOPZZnNik83Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YuidMMKd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a1c28778so45111085e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 01:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763978025; x=1764582825; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEEvVNMGxH1RpDpApEF8jKXrYHO2JJ4qRnUSrmV+YwQ=;
        b=YuidMMKddCBCfSHdgoHci3AyM9Ao06LrHec/seSC68x7LNOy1slwhjR9za9hUznJkj
         +pnkr1D8WZEMFAev2p+S0ZowB6/X7UFZkeQnqz/WFfAgyJPL5C8Bv/qyRDIB7UBWHs3K
         nYwTFnlZEIRF/81W9UNyUMQvQzC6dw/+leV/TGsJXILqj1yxa+vlLvbivQkPrFfIfKJ1
         u6kwLsZ6rQUk/pI7VLsUzY74ox70CqhADE0OJsLY20oIzkGuUtJ0b7vRzaJnZT6zVBln
         oZFtOUpb76ojbh7tulkwGXIa8I7k8gOW+IqzRiEqLtEyLpnbMJuzk/mDylrpmOoVxKhe
         /vjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763978025; x=1764582825;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yEEvVNMGxH1RpDpApEF8jKXrYHO2JJ4qRnUSrmV+YwQ=;
        b=vQUXo5Ogwc3kT624VeKwsE8ePw87mPtrhiSzr4DOcQCSoTo7GKUikRBmNBpw9naWOw
         am1q6nMJsLM9oUrlnuv4x4rfrnoKTik9YW4213W6KQwPsMXkebi/CKYmgsAl28FTN1gD
         wDeAAGES6LhJ/JU4Tf/BhEF6Ziz5a7u9SD2xcNdsMqVYVmkf+xckpfTSHz60Jsk1dzLG
         6ovRl/N605tW+BXbwLH9CNpnF94WmFGd+XJwOswvFZpmxpZZj00pZCwethB1SI6LIzL7
         M6NGlyezgVHL7aY/uR1P2CleCyq974+7vlLY6g23gFnw84YufATIQ6v2y/JowmSRZgpA
         lmJw==
X-Gm-Message-State: AOJu0Yw7detl+yhI5BdHWC/uG6wGwm6+sdMQEjsviWZofAC8Nh88n/Vv
	Iym/mrpZMwW4U65/fddIFYIFojUIMaesOW/D63i0OksUn9hRQnmROR+nrK3qyP2QRy8=
X-Gm-Gg: ASbGncvV+L+FKl3Ch3uCFeQyVpuzJ6QPPMpuozg8nIPK6rYmdY0+O47x7y8SVvILhQm
	7grCCQmFdlJQY8i+RcuWu3/KjyTJ4j+q3l1/AoWLy4I3DwbUjNP3kQzyoLbCmKHGFqGDVlE+M0a
	hWZL5CkQnkRwOaoS0mk6kgqPNyU3L5SkbYIbEZYucK+KwTAs0tlQsligsGezt0p3m1pruS6Q2d3
	BDBUjs/nUxAqLfHbzAktSdiARzPH85vIh1BGT1TQix9QRNaLP5DPTHy9zXYrlP+TcZQoR437v3x
	eTG5E4G/hjhhJTLHeE7pN27vzKZHVzIRA5R+MsjItJGlWymRlHuvyRNeterM8eongaJ3UK4zjdv
	IW5FIDIb6CbrOxBT0N6b96hqspiBfu/16Kz2bemhL7zxZaI1z0586LsfcaPAqenYGkatx3z2xFG
	b7a8SLSFQsOGM0ea7ktomZBVV9/eP8c8KHbu6vuxV9
X-Google-Smtp-Source: AGHT+IEPsM3DGKWYoDpxm2pkepfxTk3FEz1+Khe7iQyOX90yHBMaUDc+nhqgHMx9nNkbBY7QqEJgLQ==
X-Received: by 2002:a05:600c:1f0f:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-477c017e20amr82946805e9.9.1763978024737;
        Mon, 24 Nov 2025 01:53:44 -0800 (PST)
Received: from r1chard (220-129-146-231.dynamic-ip.hinet.net. [220.129.146.231])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0b62e95sm14191368b3a.49.2025.11.24.01.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 01:53:44 -0800 (PST)
From: Richard Lyu <richard.lyu@suse.com>
X-Google-Original-From: Richard Lyu <r1chard@r1chard>
Date: Mon, 24 Nov 2025 17:53:39 +0800
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: VMX: Always reflect SGX EPCM #PFs back into the
 guest
Message-ID: <aSQrI9RlZDyvfQtC@r1chard>
References: <20251121222018.348987-1-seanjc@google.com>
 <4311158801c41117a13afe0136c2807f6d9afbcd.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4311158801c41117a13afe0136c2807f6d9afbcd.camel@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)

Reviewed-by: Richard Lyu <richard.lyu@suse.com>

On 2025/11/24 00:28, Huang, Kai wrote:
> On Fri, 2025-11-21 at 14:20 -0800, Sean Christopherson wrote:
> > When handling intercepted #PFs, reflect EPCM (Enclave Page Cache Map)
> > violations, i.e. #PFs with the SGX flag set, back into the guest.  KVM
> > doesn't shadow EPCM entries (the EPCM deals only with virtual/linear
> > addresses), and so EPCM violation cannot be due to KVM interference,
> > and more importantly can't be resolved by KVM.
> > 
> > On pre-SGX2 hardware, EPCM violations are delivered as #GP(0) faults, but
> > on SGX2+ hardware, they are delivered as #PF(SGX).  Failure to account for
> > the SGX2 behavior could put a vCPU into an infinite loop due to KVM not
> > realizing the #PF is the guest's responsibility.
> > 
> > Take care to deliver the EPCM violation as a #GP(0) if the _guest_ CPU
> > model is only SGX1.
> > 
> > Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
> > Cc: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>


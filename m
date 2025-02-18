Return-Path: <kvm+bounces-38450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2ECA3A0C3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0249D16A470
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 15:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0ED26B0A6;
	Tue, 18 Feb 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JWJYmu4t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5701A83E6
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739891076; cv=none; b=K60bfEpDBmapy4oQ5YmYgW8thYNjGct1/71/8mGxnXZXWKnlZvHQtfdn6frLQPRJDfpCDw/6O+pE6nsQfC6IEcAwDcZK/BoMph2ybItI9vpxeRRqPd95ASQNmAKfI6ulduO3ndnl4h4uPCJwn57Pgi9VOqFadwf8oLxG6A4B1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739891076; c=relaxed/simple;
	bh=I899cDCtzrLN27Unv61LFQINIpMMYCQTO3vzchKPTV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ivUFgAp18jbLLsxqwaG5kdZTO0DJjx5y9mRlavV8BJ5Cab0+sMK02AWUfUeuYnL2Vygn52hEAFjrfeMd9iuz9wf5u1TyfLTGNg9YW0ml8e+U72NY+xw0rkGCi2ioAENM3OY9exPl0v2yu8SpPxFjEHUsXl8xDbLO1QpXtVid5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JWJYmu4t; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22104619939so97245735ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 07:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739891074; x=1740495874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2knpZyBZj3T0QsRG2HDCFcc/2ipgVgDbXPlB+2nkirM=;
        b=JWJYmu4tAG+Iy607hcvs46XQbbfpO7Psf6uhLE38VWCbS3+Luw5QwCzvUTCvFPqf3w
         P3oT2umOgdXQHJsphV0e4uPcjlvlkZcyU1DWLKODpdwX12TfIKOz8RADuqjQglKlkgn6
         B67l86ptccjHkeA8MFxW6GvT2dCcC45yOaO5ZS98DSPyT6TtHpaTewjonErgbUrhQkPO
         XWVK/FZCbXAQ60syyXd74tghEgPNtYPd9+6gb0c7ea3NfoJffJpj47eiHS6wIlKZpbLn
         ORR8hzqkxKCpSwnbiM/5wHv06LuFs6+7su7J5nte6OysHkaNlOJ6h0rFGw8hGd+4D0y7
         7dNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739891074; x=1740495874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2knpZyBZj3T0QsRG2HDCFcc/2ipgVgDbXPlB+2nkirM=;
        b=lBfvhEsRtZy2x0lg/BbQ4zZ9yfToy/ldvwogS9CY3k8G2ELD5oWzEce9fx84Ppy0Or
         JMnNup7B7kXxLO9uIPhTIqp+c8wx7pNLZ4uiJ1yBERExYJObJS17ZOG/bJEueiXjVFVr
         J+LfeIVq5Zv9OcpEjpm24rG/gyrb5UKoDNKuoLL4wPoyZrjLD5FRxIDaNj/oEZ1yICSR
         iQcqLuYuYzZx9I5VyQwCB3OZrp/rHDG+isocnz6BVUO4AnGHuggTYNPvjd4RKowlSSoz
         NqU+JViOJmBJL+FayclR4F04a1kPpDQGWYT0LyaUAmWySWv2z8HiA2BGf247KcOGIh+s
         +0uQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFUYISGKNxnNfghFK4PlImKE4Ru8vRNad2lnbQn5zQ8vnTulw824PXqGBpUor1gPoZmzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjYlLnWuioxxq2gSoNNDcAeiQyeUNIkAqxVqW4G8ITYlsuGQni
	yZb9nwdWj3ZQY+d/b02qx8lcyqj4YNpu0TC05ls21yEdptixLadanwHrrS4texfmm2+TFqAj7Fb
	IEg==
X-Google-Smtp-Source: AGHT+IEQM/K6moISqV33XPWsPZzBljK/WoSuhYmU5iaE5Q5tbSVOXX7pggels/AhXSwuZfgpgUZ1nTGnfS0=
X-Received: from pfbga8.prod.google.com ([2002:a05:6a00:6208:b0:725:e4b6:901f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a21:b0:1e1:9f57:eaaf
 with SMTP id adf61e73a8af0-1ee8caab754mr24825593637.6.1739891074053; Tue, 18
 Feb 2025 07:04:34 -0800 (PST)
Date: Tue, 18 Feb 2025 07:04:32 -0800
In-Reply-To: <28dcae5c-4fb7-46a8-9f37-a4f9f59b45a2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-8-dapeng1.mi@linux.intel.com> <Z6-wmhr5JDNuDC7D@google.com>
 <28dcae5c-4fb7-46a8-9f37-a4f9f59b45a2@linux.intel.com>
Message-ID: <Z7ShgKYeSqpGUXGl@google.com>
Subject: Re: [kvm-unit-tests patch v6 07/18] x86: pmu: Fix potential out of
 bound access for fixed events
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 18, 2025, Dapeng Mi wrote:
> 
> On 2/15/2025 5:07 AM, Sean Christopherson wrote:
> > On Sat, Sep 14, 2024, Dapeng Mi wrote:
> >> @@ -744,6 +753,12 @@ int main(int ac, char **av)
> >>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
> >>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
> >>  
> >> +	fixed_counters_num = MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events));
> >> +	if (pmu.nr_fixed_counters > ARRAY_SIZE(fixed_events))
> >> +		report_info("Fixed counters number %d > defined fixed events %ld. "
> > Doesn't compile on 32-bit builds.  Easiest thing is to cast ARRAY_SIZE, because
> > size_t is different between 32-bit and 64-bit.
> 
> But ARRAY_SIZE() should return same value regardless of 32-bit or 64-bit,
> right?

Yep.  The value is the same, but the type "returned" by sizeof() is different.
On 32-bit, it's an "unsigned int"; on 64-bit, it's an unsigned long.  I.e. the
size of sizeof() is different (sorry, couldn't resist).


Return-Path: <kvm+bounces-34073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 140F39F6D85
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4567316AE52
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 18:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B5D1FBE92;
	Wed, 18 Dec 2024 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GfC8+9Pa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556A91F75B2
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734547309; cv=none; b=ZO7Wk+BVZuxLVg/1R9DZfAzmytKswUiQUMwqpkitR0Dxgx2eH/BqYmo2E+Eq2R8EOozWcBHi6hDmPJOXkwwsyZGjREI2UWulKphzoJzGaEpeWM1wtP9317HI4LO2wZXJUKGT/nEhvFhPOXCU4b9GZbI0HJx+E7O0UVK8d/LDj1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734547309; c=relaxed/simple;
	bh=AmqPUcaNh3SrzGKuWPwOKQfEtsOw+9MdHoJtyldfcY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N5WFuPrWNm03eJrAS9EP76wZ5MNBoofcyWa0zpKjZJNsLJCMd2GrljiT0M3Ll/2BcKdX2VYOnPOtmIqjpOgQyfl1COvnrBOjnloL+20Zk6h1bGJZ+dpUsD302ehtbnwkq9yWImc9ZBOsHIDlfndisiAsgVsuLJBcHc/rDSVbgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GfC8+9Pa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so9890983a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734547308; x=1735152108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AmqPUcaNh3SrzGKuWPwOKQfEtsOw+9MdHoJtyldfcY4=;
        b=GfC8+9Paa8r/xXYF6o7jCideMgdwemlEMdhbXA6HZXx/aBZJNBjKcXADGN4AgYAve+
         2pVF4tORe0kKzpVsFSc223+P/EqtBYjxWnmEgUJIZcOrTH3b1Mvl7zr4ieczUDgvl4dQ
         vFjc0CiFyaVNQq0HxENPPyjnvGcuTfrfsKV6eAFxdUCl30rUvMrTMMSdPqiJx6QkZYYT
         nYjtBNqX/8gWsX5KKPVqYOnQAN26MSMEo4Yyf5LKwKgL0J/CvBQ4iFTnyqdRNZXySt9s
         +65L2+oAdbN1x+/EXl+866p6SeuVLjfEMFv+j+4IP6o+zliu2GpDEdPzOHCYkdlPn9jl
         cFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734547308; x=1735152108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AmqPUcaNh3SrzGKuWPwOKQfEtsOw+9MdHoJtyldfcY4=;
        b=rhe6E9Jf8a2Epv9GyNdHXOm35giKTv/uYeQw+a9ou1eoNKHOf1Zgvch+pEByDZ++BS
         TwJWa3uB+B1yxS5LFEJuBi8PVfwGrrCElT3vTUZecs9sPeOH28U7LRp1RH9QJvyj9hdY
         0t1/IqIr0UZqlrmGEXY/xd79vo9ogNfyEpd4+4HXcz90dLxgFvNTdn1gXceC1Pu5jEQ3
         3eYlHC+ynM3TWSvwhIvZNfrJArD4fTzUDMnaFzTk+jXTGcYtczhigdjs5Tf4ZkyzWmOH
         nMGF8DL0nRF1nbqJUmgHdYgD9q8KY4mqR6J7jtgyDUTnu2txbHN6DWcv8VbOecfKITyS
         asYA==
X-Forwarded-Encrypted: i=1; AJvYcCXC34JMcQJ+gnticjOAb8FUAmZeUEofY6eZa5l2jC9aEsGLaJF9qZx63XzNVzzZUfSIGiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBVVsGfKzXpVBlBItrP+xi/pAkzoirlfgtvJf3nrOf+6ml+35j
	0XlMLVCGKTbG59YK0WOzGN5SstemEOKezpDNKfjuGhwyxeRa/7n7yoN5QOH1AjmWp6fTLsWfxZX
	uhA==
X-Google-Smtp-Source: AGHT+IFFoI5MIImj6gtjgu7VSnwwPtAX3zR1BOO5BRZlHWotpSveP12krxH99geELMyk+gXO8F4TGnUpttw=
X-Received: from pjwx6.prod.google.com ([2002:a17:90a:c2c6:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5210:b0:2ee:ad18:b309
 with SMTP id 98e67ed59e1d1-2f443cd36b1mr481606a91.3.1734547307730; Wed, 18
 Dec 2024 10:41:47 -0800 (PST)
Date: Wed, 18 Dec 2024 10:41:46 -0800
In-Reply-To: <20241217181458.68690-7-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241217181458.68690-1-iorlov@amazon.com> <20241217181458.68690-7-iorlov@amazon.com>
Message-ID: <Z2MXarq2lpuNh_nv@google.com>
Subject: Re: [PATCH v3 6/7] selftests: KVM: extract lidt into helper function
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, dwmw@amazon.co.uk, 
	pdurrant@amazon.co.uk, jalliste@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

KVM: selftests: is the preferred scope.


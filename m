Return-Path: <kvm+bounces-19610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E453F907BA5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53644B23C50
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 18:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B95D14D43B;
	Thu, 13 Jun 2024 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pa62ppOQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72F14D29A
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303896; cv=none; b=E7bETDmu8lHHQoi/fGYFYQnQhvxJ21SouHLWCsi0g3dmgjzt3AMkXGmFhqrp5Upb+/Kgm1N5rgVkerLnS6+ids0b+ByfDOu0ZaN1SWEYyDGNwHJvet/yIgniKRlczpOTHOUbjG4+yY39PynCaYU0RhbfaBLDalv9OeogawhRCdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303896; c=relaxed/simple;
	bh=L/I0jGSnKvfURjR9QPVZSHNpgzmXSr/7QAs2Yjq/MN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JcNUWZOEYftR3MRVRZ6Z7TxiQJBIhgXPIN3aX9vcsWwM0sN7j4R7GfJLZ9qIzLIQ6qqNDU3JAhXyCjFRu/imQWWT/V3RU6FrthJeeveDmO8ZOXj3cRPfG1eMrfUTXmQncjc7MEPwvPzoxLI8mJ/o/E8ifk9XNVtLbOrNaAKr1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pa62ppOQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c4a1c9c0e0so1215138a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 11:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718303895; x=1718908695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Updc3JmEB9tDfSD6bTK5d81zUhVfnHUf04ep4+BiNE0=;
        b=Pa62ppOQ/dth7kPb21G3Nd8RYVyAjomc/DV4cmyRvKhw6ydKU6UluwZWcJQlRITjC8
         B2UrSUsjKqZKLtan2C4jaxNc4zS+E3jFPZRYscMKFNkW6E/QLEf8suL1dVrPe1d5ocvg
         Oaj1tDKrgUR/S864nOxHPheE9uea2a6mRBREJJkmNYC1y4TNtYtHMHb6TkT298epb87Q
         uQ8yOhSDDHwZGV+nFQXdLc9cIlCnyxdORaXFPlkfKv1+jhuQh3Ky5ZNKmjuDF3KdvoBL
         vjyCXm2GCjp85TXC1cL2SdBZ0pF7fHfb6rReMJxcR+CIs5v4CPkZhREfrxIMYxry+qiM
         v9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718303895; x=1718908695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Updc3JmEB9tDfSD6bTK5d81zUhVfnHUf04ep4+BiNE0=;
        b=fDfZCWcFq3sbzvByy3t1KxlI2Dv5MnzLIF9B39bpn3v/+Zftu6af9zuZJGLfJ8dGkq
         oNsIv4vt5Xv4kvxDwj/9DxO1ohPTuWLBgNA5O6YJK6WQfx/C6qn6/KPDDRtSI75t4TWo
         Wu+sxtoL7UNxFghpROZJv8CsX2QoCTMrHoKX8T3ctjhGJCIHXUUbtF9L9bfrr4qXtmKw
         tgrI/Qrf5AqeVxr/2NZ59htfaMmWZxR8ME0EemgAuyMSwUoZXCqMYrDRq1Nvl73MPvk6
         /iAhilEEDSqkYyKss1w2v4GrVkJrMwMyYAjlpjtUbbruwifpImDf5K8sEHa8l8DKLh0F
         xIkA==
X-Forwarded-Encrypted: i=1; AJvYcCUJvGG6iodOi1JtWYmiIDG5+1y7OYwvj0GClq80exOKavXgUaJb1KD/rc3PpIZ6GSjOhVywSExZG0dtTcpsYOxMAsl8
X-Gm-Message-State: AOJu0YzCJ3DbPR/d2zvDgg9/9M6LXD6neYRmFycnzij47ykRCGFRYrI1
	yRY9NVVoc4iilTqQ8pJ8GWoRxZDiAykA0se1d2mnMQrN4N/ZjjgOcCVPQ1y4BEYLYJIEOojJ2og
	Eug==
X-Google-Smtp-Source: AGHT+IEoHsoXQ33CoHiGZZlVh3rR+/EUc+z3M2bB9VIq6N8UkxisrbO0XxnhPNgtzkGpaeE61uYDqNygW5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c8:b0:1f6:fbea:7976 with SMTP id
 d9443c01a7336-1f862a17756mr12475ad.10.1718303894500; Thu, 13 Jun 2024
 11:38:14 -0700 (PDT)
Date: Thu, 13 Jun 2024 11:38:13 -0700
In-Reply-To: <608b37dbc59a80d32719c8fde8b6979a2b839e10.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <608b37dbc59a80d32719c8fde8b6979a2b839e10.camel@intel.com>
Message-ID: <Zms8lRn20MGVVN9h@google.com>
Subject: Re: [PATCH v2 00/25] Enable FRED with KVM VMX
From: Sean Christopherson <seanjc@google.com>
To: Shan Kang <shan.kang@intel.com>
Cc: Xin3 Li <xin3.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, 
	"x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, Ravi V Shankar <ravi.v.shankar@intel.com>, 
	"xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024, Shan Kang wrote:
> On Wed, 2024-02-07 at 09:26 -0800, Xin Li wrote:
> > This patch set enables the Intel flexible return and event delivery
> > (FRED) architecture with KVM VMX to allow guests to utilize FRED.
> >=20
> We tested this FRED KVM patch set on a 7th Intel(R) Core(TM) CPU and the =
Intel=20
> Simics=C2=AE Simulator with the following four configurations:

That likely provides coverage for the happy cases, but I doubt it provides =
negative
testing, e.g. for VM-Enter consistency checks.  KVM-Unit-Tests are currentl=
y the
best choice for concistency checks (unfortunately).

And given the insanity of event re-injection, KVM selftests needs a dedicat=
ed test
for that, and another for the interactions with nVMX, e.g. a la svm_nested_=
soft_inject_test.c.

I haven't looked too closely at the selftest that's already provided, but m=
y
suspicion is that we'll want multiple tests, or alternatively one test that
uses KVM_ONE_VCPU_TEST_SUITE().


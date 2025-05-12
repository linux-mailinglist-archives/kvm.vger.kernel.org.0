Return-Path: <kvm+bounces-46241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FFBAB42B3
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6CDF1B61E8D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1014298C1E;
	Mon, 12 May 2025 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6oHlQ66"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB002989B0
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073291; cv=none; b=aW+wNWjVT7TI848ULoV4BAstJvlTDZtpYPYZCbgW2Oadc5XqRY07U+SgmxXf1X8fhZ0SjNnINZ3/Lxm7cD+1Ly6AAbBvir51SOsODOcrtCezrVU2MuTOjLf/WDLQ2xk9IQzM5tfOjWJc2zg23GUOivite6ifAmA5vjnfLhRMpQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073291; c=relaxed/simple;
	bh=ejLKkLFYtUMpXHdsOTHtW0v9ZW+VQmKQChOCq21oL40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G2jLSTGAuqhHwYlOZmpmeckyw6GSrawvGacSlTXuqBOzr5IMFlI4WR6MD/UBit8qi6xByQ5HjjBuBjIn4p2m2nvWBudXYo1s+5w6/MEEGERWXEmnsr+vXzSRouHyiEqbsd/mkJpAyxb/8hDStwN3tpE8cXJZzDRL21KrFDFg82k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6oHlQ66; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22fd4e7ea48so28703185ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747073289; x=1747678089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwuOPvPojv1l0TmDPTQsLIJwuOHkezsc7kTLGMrlcwg=;
        b=q6oHlQ66UIxXEUT5MyNWohZB8oRwTGbtFztjts23W0DqCHyagoa6TnPUd7z5SI8Ph+
         aA1UQTYf9xGfQQJSD1ywzN10ht0Qgh14zIRRQgb81Umsy0CyW+RixsQYF3bKQGeXRfDS
         tfn9EUYDueEzlBdsEV1lhNGafBiB4NNGY6ouKVwm6Xorbga5R47KLl1iNx2FHIK3ToOb
         56cD2Pll/5wyUGuWwkOWJiaW3pDcpqv/QW6RPHmDcnOX18QdZp2EUMIHjMR/9xtuY6+v
         jcI/4Qm0Gd6tkEg9MMDW5jWJkEvKwtC0O7gzwmoEd6CIztkFEfaMHe8JbUbZgiChCA3p
         Yw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073289; x=1747678089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwuOPvPojv1l0TmDPTQsLIJwuOHkezsc7kTLGMrlcwg=;
        b=fRBvqtMs/pWMuDStsWemt/kRFxrMJz+tSv+nO9pGonMeUZMnUW1ypJJ0YBpxAEmKzU
         cnkegzKLoFYlSWt4rFXE1JDJiAQANjPu4XB4Hsj+wtj+P0CxYBFikwNvbhVq7OqBeK1u
         0H2gINOfUZY2awUFbmqtSaaO3M5Hf81UBjK2DDUXZ3Y3sEUmaMklz5mvC0W2Vowe/Iuh
         b5WFnxcoeikkkpdT2PBpxgHtGqL441eac+W/P+hxUNGddyuW3+dswOb0JkG8eh9edM0f
         5A0xaxTogNeF32ri262w8E+P7r/RQJGkCkK3QEza2u3dhr6F7XO9xrAsXi6WMzNDsDOK
         iHsw==
X-Forwarded-Encrypted: i=1; AJvYcCVzPogg1YNa6rZ07fw/hmAmu2NDliXgeYwgmJto8D7ELZ0Taa1rvfdS4BdEzZFYYqysplM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxprhJS3i8R/qwkYJcJYI76O3ehUkUAIYV5N506n5D/3RrF45RC
	59GcUK7a/pPWz2Jbtthi2r7jOKcIMN6cIC97x6GzFaXb2MPraDImB51DvspEUKRbPnuv6CRLzqW
	FZw==
X-Google-Smtp-Source: AGHT+IH71D2UI9Ksbkvxo8YwHen4FAYZY6ws0smj3LEwh8OXjODVe85IC+hix2m/Z6IzhlrHe5bvJpSOD5Y=
X-Received: from plil3.prod.google.com ([2002:a17:903:17c3:b0:223:4c5f:3494])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:988:b0:22e:5abd:7133
 with SMTP id d9443c01a7336-22fc917f836mr180576485ad.45.1747073288984; Mon, 12
 May 2025 11:08:08 -0700 (PDT)
Date: Mon, 12 May 2025 11:08:07 -0700
In-Reply-To: <20250313203702.575156-4-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-4-jon@nutanix.com>
Message-ID: <aCI5B7Mz8mgP-V2o@google.com>
Subject: Re: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Add 'enable_pt_guest_exec_control' module parameter to x86 code, with
> default value false.

...

> +bool __read_mostly enable_pt_guest_exec_control;
> +EXPORT_SYMBOL_GPL(enable_pt_guest_exec_control);
> +module_param(enable_pt_guest_exec_control, bool, 0444);

The default value of a parameter doesn't prevent userspace from enabled the param.
I.e. the instant this patch lands, userspace can enable enable_pt_guest_exec_control,
which means MBEC needs to be 100% functional before this can be exposed to userspace.

The right way to do this is to simply omit the module param until KVM is ready to
let userspace enable the feature.

All that said, I don't see any reason to add a module param for this.  *KVM* isn't
using MBEC, the guest is using MBEC.  And unless host userspace is being extremely
careless with VMX MSRs, exposing MBEC to the guest will require additional VMM
enabling and/or user opt-in.

KVM provides module params to control features that KVM is using, generally when
there is no sane alternative to tell KVM not to use a particular feature, i.e.
when there is way for the user to disable a feature for testing/debug purposes.

Furthermore, how this series keys off the module param throughout KVM is completely
wrong.  The *only* input that ultimately matters is the control bit in vmcs12.
Whether or not KVM allows that bit to be set could be controlled by a module param,
but KVM shouldn't be looking at the module param outside of that particular check.

TL;DR: advertising and enabling MBEC should come along when KVM allows the bit to
       be set in vmcs12.


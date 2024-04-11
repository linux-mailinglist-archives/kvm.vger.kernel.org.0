Return-Path: <kvm+bounces-14268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C7B8A18AE
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 713C8285FB4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AF039AF1;
	Thu, 11 Apr 2024 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uUIo93Yo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901C1DDD2
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849181; cv=none; b=PY1aVQ07yrD02VC8aEaN0KpeYCKRCj40ozpXvdoJcuzsjRTiXaPaGS4uka17NG3wzPx97idhd5FI3N3Bbs6thBnKFd1z2vRfGcLA6UXc37a89l57gHvfU+S65C/V8iQDpJ3YyT8u63t92RVkQ6u7KNTvUHHpwU8UcUIhK3whfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849181; c=relaxed/simple;
	bh=ynCGKHUPmUHZ+eVS7oiWK85Hpo5+9fAUqkAqFmpGSb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WPLX4fUHShzTYN2e0dJrRjJZw8+PBLSPPY47LeSs9uyttGYGCpLtPTyaWU5k7aUeD5SaAehGK+4RnIpCxyhcbJIYptYgZK/QDuApm06oik0wRxJhhSU5drJxkHddyWSFBOrsi0EzRv0xU/2nbB3rPOsDejnMzzdnGNnQEkbn1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uUIo93Yo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-617bd0cf61fso129082607b3.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 08:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712849179; x=1713453979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynCGKHUPmUHZ+eVS7oiWK85Hpo5+9fAUqkAqFmpGSb0=;
        b=uUIo93YoOGCDFs1jtXz2iCvyVaG2gi36EqMkvEr8IygR/8RjD6hWUN9+o7qUoHDcza
         bR+SWdkj36sRWqPb4vVUxLJu96gaNBq3FXIU7sQ473nbhrTnptwNGMZIqAyvPwddn25j
         W1X2vRnZoXGSEZcKwcH2Rhwx9MaaI1zMc0DN1S1yuNE9BnfaITxyajdfEg80cz2Qop8G
         KvGoTRTmHNhGgY80OLAopKWtIAzAV/h3UcziSpGUpkCS7Lb7L43oP2YX8QK78QHP8QnH
         1bUMJm7Ethf3XpyntlZUZZSA2937JaL+LaDK/hVcnwEwXfidAI7ekL8WcZ9G1jWlwlpZ
         bO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712849179; x=1713453979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynCGKHUPmUHZ+eVS7oiWK85Hpo5+9fAUqkAqFmpGSb0=;
        b=fWJY63Mcc+kA1L0/Or05O+hMHzw8D9waPlKxq+LVYtE5qE6tud3GwBC9x/j4uTObvp
         3H76UniOJfKW41DgqF7xsoYSZcF6uhY90a94WhF5TjIlVJIFNz9jGtVMxI4L41fIg25v
         JblkSdAb5r0nm1vHpfgdiSlIKNuzWQYdA2Q7swXqO/1y3q3rCx/9CLCBzj+ScS87aOdO
         +T/hbnuM8fWUtHnQgUaqJLVSNhoHwnosbhD5VD9SxivEQmAul3H2vQyxw5pyfgm8iTfH
         eOZJsoFRQgW4QNYU2EgUj8jclT+oEUoqX9yPOFENOVjCmUtjvSR7sIyu3QtYMZEIqbZd
         UqRw==
X-Forwarded-Encrypted: i=1; AJvYcCXDE0w1cd238Fn3+O0INg3NcdhL8ROjeQ39M+wSgE1I8xrd6CsmgKC9v7MeLQt+5tQVcqEIcNKDgdORBLZ3f3Lhq6op
X-Gm-Message-State: AOJu0YzxMhmnJqZfb7G/CC3RCRtGpnBUtTJ4CsVAaYExDyI6pXcJshGC
	d31gnXS2PV5Nn/RCXfI2pbGuQsDr0YQ1YZoYmWjan9HFzj2HASejNJ3B+kJpjzoWv6Ci4no3ha3
	YJA==
X-Google-Smtp-Source: AGHT+IG8bllVA4yO1On7u5D5SxgvY3UE9xXuWus++v8c5DRGnYKSN91qnF5DOtTx85qDgLE/siI6+aiJ3uw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e50:0:b0:615:1579:8660 with SMTP id
 c77-20020a814e50000000b0061515798660mr1439958ywb.7.1712849179687; Thu, 11 Apr
 2024 08:26:19 -0700 (PDT)
Date: Thu, 11 Apr 2024 08:26:18 -0700
In-Reply-To: <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZhRxWxRLbnrqwQYw@google.com> <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com> <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com> <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com> <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com> <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
Message-ID: <ZhgBGkPTwpIsE6P6@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"davidskidmore@google.com" <davidskidmore@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"srutherford@google.com" <srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 11, 2024, Xiaoyao Li wrote:
> flexible (configurable) bits is known to VMM (KVM and userspace) because TDX
> module has interface to report them. So we can treat a bit as fixed if it is
> not reported in the flexible group. (of course the dynamic bits are special
> and excluded.)

Does that interface reported the fixed _values_?


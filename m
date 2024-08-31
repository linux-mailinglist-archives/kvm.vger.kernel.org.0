Return-Path: <kvm+bounces-25612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD79966D77
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A63C2836DC
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B1029CE8;
	Sat, 31 Aug 2024 00:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="acB0VQAr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73412E4A
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063717; cv=none; b=OKJ8lu93HHWO/eNXwdV01c5UADDkpKRN2R1h+oSl29jcHkSX58xv4aQ15PuXqdURPgFiFon+S3meLD/krSM/Jv2F7HVkIafiwceLGZ24US72gCaQYew4Mdbb+gIzdHEGHtyt7TPIqGjTAuEZ21gKgweUoHg8j6ZLPa7Lwti6g9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063717; c=relaxed/simple;
	bh=uikcsbcYWTizg70A9pXTDrH6Aq2HwfIpluSe5pLzm3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTe8xSLmaK/BvoKyLg2ZICbIZyzCqsAOAOujca9oeY87Y+Qsp3N2V0TFa0b15JuWNEKX6vPijMO09sfHbJNk0MvOIdXTPt6jNBFLQZE4aHvhnjsk4Av2MXYwU2rZrQ9uu8p6T+vwFNv79XxMPFRx52HBpbBl6BI68jX53xIhvn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=acB0VQAr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2052e7836a0so10403815ad.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063716; x=1725668516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQ0cv7Qd+gmdijk0mM0rETDzMYm/E79aKdx8FgcPeVI=;
        b=acB0VQArEtQmvLBS7CTAru7iGkooPoOoysItT3pQmAbm26BeEO641z74NzMR7itdzG
         eORY/TwjCzRA+xwJ3Q0l+raVgC5L8dF/S5cbgZO/nV0VoQZr2CWFMJHS0DoedEq+DeH8
         455Q/RRc6FDoAp8/3aMv2rGj6/TgnTPURkIHVjf2BfUBr3Lh6vvClouJcRzudmsR8JtN
         sxETvedqzNtx5zX9kvPU1GkPFmHSZSzKo1/0UBd1ybK+3RgpcyFmDbTH9nA8ITyxglPm
         5NF9BcPxC1IvGHS994eVGQLYgJKDS2GIMkjaqnXmr85noCX4OFaSYKQtlUVkAqzpsemT
         P8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063716; x=1725668516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQ0cv7Qd+gmdijk0mM0rETDzMYm/E79aKdx8FgcPeVI=;
        b=VeRjPyQ6JsETym9NI7GTdd9AQViYDiPLYuDx7VKJ06rWogHFdXkqCt+Bf4vJshu7QQ
         1FlkOhlQ/0VY0pt9SEcLPDKK+3DzVQ8mGtz63V4N9tURD9NxxbzJ4ggjlEEt/40a89mY
         quaYHX3JqzA99GY+V82+RhVWJuEsRJnoJOS67x6tErowMFlD/gXTDeoN4+QYCfwIFAFC
         dROifScON5Jp6RPcdHg1S2rs52Nvy54G2Irzz3GTTN0Z3lqfiaMduitf3wUZYqTp/cgK
         lc/yOR442P3J82+7avx4fwhRgeehXFzy2nmS8BJKsW7f838U/TRdSgMbVMaxATC0dY8s
         QFJg==
X-Forwarded-Encrypted: i=1; AJvYcCWBuRZyRWBUUlZYBkJ5Q1sKFSG6GcHrxD6uL8lNHldOlyHei+sN+ng+nzXTAniXJQUkQrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Nx+Hv5db0GYT7QwOBkOF39d9RnFVD17eluYg5GpYlv6iqXfM
	yvM5/Td1p/7JEM5N01W5Lov3xYRzTd0Fwxjp06D4FVYHuJTSc18LT6IYZOsvvYpOYSii/RnsCyg
	aUA==
X-Google-Smtp-Source: AGHT+IG1zZXwwzR1gaXHIo5VHk6KMji21CeC5APkFgCfFzhzxXAK9Z+KmZlxoO+VmmEZORM0HuKDi9jjeoo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c405:b0:1fa:fc15:c513 with SMTP id
 d9443c01a7336-20527e7da59mr2460095ad.9.1725063715836; Fri, 30 Aug 2024
 17:21:55 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:59 -0700
In-Reply-To: <20240709182936.146487-1-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709182936.146487-1-pgonda@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506355899.338644.7289334225291315172.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add SEV-ES shutdown test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Peter Gonda <pgonda@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alper Gun <alpergun@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Jul 2024 11:29:36 -0700, Peter Gonda wrote:
> Regression test for ae20eef5 ("KVM: SVM: Update SEV-ES shutdown intercepts
> with more metadata"). Test confirms userspace is correctly indicated of
> a guest shutdown not previous behavior of an EINVAL from KVM_RUN.

Applied to kvm-x86 selftests, with the IDT clobbering.  Thanks!

[1/1] KVM: selftests: Add SEV-ES shutdown test
      https://github.com/kvm-x86/linux/commit/2f6fcfa1f426

--
https://github.com/kvm-x86/linux/tree/next


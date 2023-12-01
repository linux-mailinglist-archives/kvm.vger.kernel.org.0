Return-Path: <kvm+bounces-3050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12917800156
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B22BB1F20F8F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FC5441B;
	Fri,  1 Dec 2023 01:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQ7L+KFB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AC013E
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:32 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d04ce0214dso825605ad.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395792; x=1702000592; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=toNsoSXypYSL9uZTcK8jfeH59RKbIqfw62avR9a71VU=;
        b=iQ7L+KFBtHneYZAw/MPGh4SS2rq2wzhUp9CyzgOMZdf2cv+OwTFaoyeDa8Oo2y2HAg
         qgaUKwUjWUVeQHVGyIf1lsFMSXdbQHtcL4zbY1V8OpTUjw8MbHTBv3PUepM3W4eIEGic
         7laSSz7fxywiQzGHUFfj1UmXHeeu7/9l8GfIGaUe5XOoRACm8cxqEcCThKxQCko0/vv6
         n9CHQgIqAXi5z9Ce3v0hu5CdaWiGQoWRw3Ho4oO15UuqOq0dN1/dSKCAtveijkYggwtL
         Im/feQ0zRyCHIpdMwSAgSHWU1fwbm/KQClUQTgGf/S2plHvr1vHv5PJUqJXtcLdRHAEB
         a73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395792; x=1702000592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toNsoSXypYSL9uZTcK8jfeH59RKbIqfw62avR9a71VU=;
        b=uDp+wy1iW2zLKX26aVdjL8TJjh+iRB7V61gwAu5JWJ80fNlVA2a7Fx3MWU9sUTcgHg
         glDQLhMsuaCf5VW8jkIancBjoXmG0t0dRpzakh5VkF7qgeWwdQCdetnowEfHaTS68XE1
         RqlSHg09c2WB8AGt9awgsyEU/p1n+TdJ1XUVpCKhXlmvnZ0xwqnu+qYc/j8+JSctb1qK
         4dxa8uINuJbasZ/EXAyC2m/sbI0sbe9zsBdAzFiGFkQEoerwN0eO5rSqj7A4G5R7NQHs
         6quoalQAMT/zQJA1uJDbsZuSFKIH9P0SWS2JQFPTBfo4ADds3QhvmVjI4y7oJNvbWs1g
         hIKQ==
X-Gm-Message-State: AOJu0Yyv5kqoFWfHsBwcQUd/195+3A4GWn3ii9C6b5IpDSIYYOLljxgf
	W/73zVr0LFiilsMOOhRQ/ZFNDzF/pwc=
X-Google-Smtp-Source: AGHT+IFuBXykSxmfmDFQrnUbRaNF6JzD+ONDaMRrQBnJw30Dc27VI6NQZPkPz7BUuWZEy4JDvo4LUxLxQis=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cb:b0:1cc:41b4:5154 with SMTP id
 o11-20020a170902d4cb00b001cc41b45154mr5681528plg.13.1701395792418; Thu, 30
 Nov 2023 17:56:32 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:28 -0800
In-Reply-To: <20231018193617.1895752-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018193617.1895752-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137748399.663624.5891433313552244274.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Explicitly require FLUSHBYASID to enable SEV support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 12:36:17 -0700, Sean Christopherson wrote:
> Add a sanity check that FLUSHBYASID is available if SEV is supported in
> hardware, as SEV (and beyond) guests are bound to a single ASID, i.e. KVM
> can't "flush" by assigning a new, fresh ASID to the guest.  If FLUSHBYASID
> isn't supported for some bizarre reason, KVM would completely fail to do
> TLB flushes for SEV+ guests (see pre_svm_run() and pre_sev_run()).
> 
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Explicitly require FLUSHBYASID to enable SEV support
      https://github.com/kvm-x86/linux/commit/770d6aa2e416

--
https://github.com/kvm-x86/linux/tree/next


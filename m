Return-Path: <kvm+bounces-13945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961CF89D00C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00422B22F6E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216054E1DA;
	Tue,  9 Apr 2024 01:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkebkAX8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D679E1
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 01:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712627595; cv=none; b=lf0II1TyFMsCtbsoFtWk+HPPTKzObqKO6FhFvY116Am8Vw4qu4A4Ooo5/1dnDMsUGbmA+D8UkRtQxmaLST30BiUFM+YJer62XF8/Ju6f+ysvPzxBLkAdPO+2RTG+Pifwta9JcqlQh6S3j312t0zn98fG4CRrfbXGA4gGcjkoLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712627595; c=relaxed/simple;
	bh=Jcc8Nzp0F1AYOMovPqP6yV3w4tsgxOfthxPFqCoobkQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DzVsi4jsL4LwJVwsNHWvuod/hvvb8wgH5DAU8Uhki0mPw7U1k4a5Fa5RoOLIZB7/jcnrXlV4j9dIgT2QHKviGXZzE1FOTJ1I+/5Hlz2vDy4vCoFxpnfjvfGww0GAI4bQ95ANA+oa3xurwrCNuwbJ1kMucoprIm0wh8EERyrzcKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkebkAX8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so6251213276.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 18:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712627593; x=1713232393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNIcC0zPKW6c4VEdraJr6fQiBC+vH79t0trD6bjo2rU=;
        b=DkebkAX8AI/8kysxNVebj8w/1UFHK1KPNEGvHP5HwgqNvBaWQPOyYChqqwZyaXI8D4
         pUgXKxnuI2dAGo7d8+NIYGr4RClZnjh1RE87X8X5K+qmRhTAqrl8uoq9FDXe9LOg4sqP
         AQyHo7FHdWuP69f2kg69KpjYxdavQFzoBk/wgDtRbpKIbqyjc3A86bFmG9CVkFebRrkw
         7j1pcZNYuLZG+H62AigVG7p9XDO4oC1xYSoK6JX9qXk5R2DBQZ6BgL+QvmQynOqhMYiD
         XKvFlqCaxCM2bpAFWoQQvTYf57QSP4UMLHpeImWW76phy7nx/O6gSA5x3PcgZ2e7lZpw
         HIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712627593; x=1713232393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNIcC0zPKW6c4VEdraJr6fQiBC+vH79t0trD6bjo2rU=;
        b=Rl46J1VJEpbW98KByFmX4Q3r1Vy9c0/9tU4htKLTr+xNij8jfJ+YU+coQYtcWAaCCb
         a1P4yIdyww9WkBRWWITqYbEHDOTXR/iYue01h6eVfsI/05rbsMynJMt/OWveF750zM0E
         lr8T9rt4YGkaw9q4gM3o0m4Uk277kFcM2x2NVYnLL2dbUiWWUOg/EqEzoco06OXBRpVK
         8ywAZBXwFeXIyIuNL7bYC77aiCFJoboEGpTRB11I1Z4RcEHOgynYFpL2sQ0ohfS57ruS
         Yq2q7Xwp0lpcremrKPyDvg2X4rqjmC39Bl9qKvlRSizN0L6jhuW+X9NrcejnHGfUxkRs
         m8Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWqzwkG6m4BIjEv9Di7q8SuRXLG/Wq5zlRXTXQKjvPj+Vu73GKPxmjCqgnxyueFxRU7yh74QiDqhwQL/vBYIzAmywmW
X-Gm-Message-State: AOJu0YzcIi0TRtUiQB0RZhUFs7hVr6PsbBewYOhX5AtPvzBPKBQi2Foc
	oP/kaevoW3lyPJ+915YkQyiFqT2KKDI9efuZfZ7hkUCdhETGBTGcBe3Du+8mE5mc8205TSfbDLZ
	1vQ==
X-Google-Smtp-Source: AGHT+IGNzMfhf/C267K03QXaEY8dqMwAGrwEdePwM2Ys6rp5wv0k7fEAGQmmlHl4gUT2Hwjir3poXqQXEww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1245:b0:dda:c566:dadd with SMTP id
 t5-20020a056902124500b00ddac566daddmr869326ybu.4.1712627592721; Mon, 08 Apr
 2024 18:53:12 -0700 (PDT)
Date: Mon,  8 Apr 2024 18:52:54 -0700
In-Reply-To: <20240403123300.63923-2-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403123300.63923-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262714494.1420034.12329953170509858303.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for riscv
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>
Cc: pbonzini@redhat.com, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>
Content-Type: text/plain; charset="utf-8"

On Wed, 03 Apr 2024 14:33:01 +0200, Andrew Jones wrote:
> commit 849c1816436f ("KVM: selftests: fix supported_flags for aarch64")
> fixed the set-memory-region test for aarch64 by declaring the read-only
> flag is supported. riscv also supports the read-only flag. Fix it too.

Applied to kvm-x86 fixes (for 6.9).  Figure it doesn't matter a whole lot if
this goes through the RISC-V versus something else, and I have a pile of things
to send to Paolo for 6.9-rc4.

[1/1] KVM: selftests: fix supported_flags for riscv
      https://github.com/kvm-x86/linux/commit/449c0811d872

--
https://github.com/kvm-x86/linux/tree/next


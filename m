Return-Path: <kvm+bounces-25616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F17AB966D7F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D6E11F214D6
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1942342AA8;
	Sat, 31 Aug 2024 00:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3OzyIw36"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420042077
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063746; cv=none; b=YQCNEY+htktm5rce93rI4o693Dqtd9EFXgQRR78DvLnIbMtOrTNEPcGCZtwqR0Hh6s7EKE0qsoU89vwvgBWugm+MS7/nNkjOYWZJWidnZQBuJmfmynmsEGWZAchUiUdTvNhGPldSPgWXAtUmsmL8wGX8hxk+5MPx73bPXZM3Xv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063746; c=relaxed/simple;
	bh=pOnikIeX/hx6RJZ3wP0KY3kh3B7ROYqQ/ZIW1bTiavc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kV37Rw0hdTO87Du2AahRUEoWrupjarTTDshBVNspSPzBFIs9ZJhryG0XRKf2p+MEBqX3qqtdaTrQE//vNZTg41N348+8foPoNl8j1GgFOQCgnRvtVyQRnBKiARAHv+GN2WjoJTCaeiAVu1OQUWSH5YKdw91LXbHG3ekGs2VsykY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3OzyIw36; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2052e7836a0so10405885ad.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063744; x=1725668544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfPXYWUZzU2kLwWvr5udHYDk6DJfP9px5nwFhFPqn7M=;
        b=3OzyIw36D5o1b4/ZEk04dFeWAc9G/rbI17mXvYT0zRk3O9HhGwgBMT3kVnhHFMcS7V
         codiA529GDMg+orBCjDhD4J4Sqj8i+y2rOoLjMl63vV8Gcy+yblyCRJCDIg7hQB9yhZG
         YniT+W4ytmwhI5ZMCTJTqy8FEE9JDVphbBHhznBTzyhd+5px/GizYj5sMl5nYP+6smsn
         LcD5C6gVFkw9iKNXTp6j/xUU/6YBsaQnasnPzbGz4x5pHRvZxueBTO8KPKq/F7wkI6xh
         WdFA07oc77b+Gf9Jb4Ew/kUcfXpxNZD7u5+lE3z6Ys4jgB4nXOWYHJn7TTYPuQGtcbdc
         cjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063744; x=1725668544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfPXYWUZzU2kLwWvr5udHYDk6DJfP9px5nwFhFPqn7M=;
        b=eW4Xv6356hjls8BHf3fYgidw8a6c6Biz2z4K+89IiqpbLDtV7+ebPqz/t81RBJ/8KW
         imQ8jMgobdPIypGMkxpQBieCm+s/AWk8bAj6Aw3YTjJl0a0rcmQMy+ugkdTy3uDAEY0w
         ic8iHuPq9oPBHVsjG386OQT76y+hD2/sebSqPoZTQtlff1ax6wrSLFkqFZ3B01TGmR9J
         xceR1bIDpmcjiRLhzKMPGSYPDUMCAEz3iXP8augBnv9Cb0mkp4T6CFu845kkDe0TKqaX
         9rvmXr899YkvCksLVI3PBramH3z/8nOVGrZbHeX5X77pYIc8BsDVAwA1+Q4yx/bvAmfg
         uJMg==
X-Gm-Message-State: AOJu0Yyl7UtI9nxP5B6k07MxfTFNET4fEpSnhVlYllQnfVlGdAd+9ick
	S/By7n7SEWHUZ1KwpcpMR4YQpxSazfhsAE6DlpDWEk36QIKVvRt0zVfeH7u8oWy4HzWys/+Uoch
	WhA==
X-Google-Smtp-Source: AGHT+IHw9nlj1RDw9fvFahv3VS7maxtfXI673zlaEm3HTQPEUSrWXzkh0viD9otkg49B4GER8BqpxoOPA64=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c7:b0:1fb:716e:819e with SMTP id
 d9443c01a7336-20527669412mr2038565ad.4.1725063744059; Fri, 30 Aug 2024
 17:22:24 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:21:07 -0700
In-Reply-To: <20240802204511.352017-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802204511.352017-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506355251.338547.8844071082030684446.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: SVM: Clean up SEV-ES save area management
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:45:08 -0700, Sean Christopherson wrote:
> Clean up KVM's handling of the SEV-ES host save area, and opportunistically
> add a helper to dedup code for converting an SME-tweaked PA back into its
> struct page.
> 
> Sean Christopherson (3):
>   KVM: SVM: Add a helper to convert a SME-aware PA back to a struct page
>   KVM: SVM: Add host SEV-ES save area structure into VMCB via a union
>   KVM: SVM: Track the per-CPU host save area as a VMCB pointer
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/3] KVM: SVM: Add a helper to convert a SME-aware PA back to a struct page
      https://github.com/kvm-x86/linux/commit/48547fe75ea7
[2/3] KVM: SVM: Add host SEV-ES save area structure into VMCB via a union
      https://github.com/kvm-x86/linux/commit/1b5ef14dc656
[3/3] KVM: SVM: Track the per-CPU host save area as a VMCB pointer
      https://github.com/kvm-x86/linux/commit/32071fa355e7

--
https://github.com/kvm-x86/linux/tree/next


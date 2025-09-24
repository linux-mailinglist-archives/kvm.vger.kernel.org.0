Return-Path: <kvm+bounces-58689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 486FDB9B649
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66C3C2E54DE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC80330D3F;
	Wed, 24 Sep 2025 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sl6ZgZWC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FD833086F
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758737301; cv=none; b=q/QPDJ8+HpUpyrS4gK7wTSA6FNCzQe6MaHXflYCY3iprya5KVmmgta0IoJV2wdhURCj1G0RzkdJjP8VPS1T1aS59LzAe/5BIwVvBT1Gom0idPM/WmRPfwuafgE6lc1O+B8euCq7Ai9K5TtkHRuOJMK+iRtckcqs97Hx+J9zOrRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758737301; c=relaxed/simple;
	bh=EGhb0RvyQlm7iZwhsGxvU7M6C4b/2pTdXMLeRQfd0Qc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SMuemUJ2JKni6vtX9RzverxN1a5NFAvRGhTQPG856OlB2lJfbaRh46nrYn50jgtxBPrZJPiPidieQdmnD3W5oItjy1xrYfZlgtlp4d4y7/8kHoLVNchGhKRwwxR5PVC22MpkWdxtgwvhC4LcHkTekkFiP7GmHElqA7leBEFDTwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sl6ZgZWC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-252afdfafe1so975585ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758737299; x=1759342099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bkuc/fF7H0VC8ANgHBpHu7wU6KQSXWbo1rt2SqB0zfk=;
        b=Sl6ZgZWCW031UTCtuUJE5AydySna6reS/EAZZlm7cn5T9JMxggeTxWPE6mspkXw+Xk
         ZeHwjazg6jT5VzWL8JeZBmQKnGWZuYocPFDowNggM1DdW6SRuoWkgJiXA+uvYUiYAitO
         wZd1i2ihKf8C3jfdLEAiK5GtPAklt1bAsy1Mq9R0Pn21AtdM4UXp/nJEJDnCoDis60Vr
         zNOCWEYdke6p//NMT29hADiZeb788ZRozV4o3dWKsX2U2RWXnEzIkGrZL8H7DKG1lDtW
         QJJPSb1UuaMH9Nnn7UqngYNWswRlZNxsmUbscr1zPrzqs5EYLMna2KRAOP28E2xo0f2t
         f7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737299; x=1759342099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkuc/fF7H0VC8ANgHBpHu7wU6KQSXWbo1rt2SqB0zfk=;
        b=EYwguyZwuiEblUgVRT0j8s8tsogZbZXNRkboNaHoaIzbVag8uaW3cW/1zh74yy7K5m
         zISNC5MrhGVIAGHMmKsWcvLi7ArfCDzW++q3kUccwbhO9Xvcbnmu3XWKJN7/d/t+sXws
         IUHu5+MbU2oVpKPluq8tpy2lzGpJrDyfstz3pqA+prsqqxas2qROmBZjwMRYgUZHxd2j
         Ju8lFWoxV7G9rGcK+YbZyAQ0hSkqPnqnH2YjiVj4BW7631Ej/R3XqbS5mKjv0yyvhppG
         GR3LLk5nIBFdivq4Or0bxkaliez7g3qODWkUiQpHX5GMH4vPk52hbSd2JDuF1bXESjtI
         bEyw==
X-Gm-Message-State: AOJu0YwcjCquUiXl405LEc37R92fJFhfyXbAOVurudgVVQ9h7etZ7mRu
	24+a7oWP55TxH8u2RsZTUGkIR7OPxoEqsHNeBdi5fV7yIo2eeF+7l1eWgH360HfK2sq6LddSVb/
	CjoBEJA==
X-Google-Smtp-Source: AGHT+IFiip93Y8SalTeWn/bXmvAZdZQIdPnwJH/peLWIGmz1ar9OPzcSFYPt0DBwYf8tyRdYIRNJWiF5JtI=
X-Received: from plss12.prod.google.com ([2002:a17:902:c64c:b0:269:ba45:78f9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19cb:b0:26d:58d6:3fb2
 with SMTP id d9443c01a7336-27ed49b30fdmr7146075ad.12.1758737299218; Wed, 24
 Sep 2025 11:08:19 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:32 -0700
In-Reply-To: <20250919004639.1360453-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004639.1360453-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873596698.2143185.9486968747074623197.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Don't treat ENTER and LEAVE as branches,
 because they aren't
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Sep 2025 17:46:39 -0700, Sean Christopherson wrote:
> Remove the IsBranch flag from ENTER and LEAVE in KVM's emulator, as ENTER
> and LEAVE are stack operations, not branches.  Add forced emulation of
> said instructions to the PMU counters test to prove that KVM diverges from
> hardware, and to guard against regressions.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Don't treat ENTER and LEAVE as branches, because they aren't
      https://github.com/kvm-x86/linux/commit/e8f85d7884e0

--
https://github.com/kvm-x86/linux/tree/next


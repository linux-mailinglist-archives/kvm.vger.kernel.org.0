Return-Path: <kvm+bounces-62666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 25770C4A0A6
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1B1644F43EA
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D143257849;
	Tue, 11 Nov 2025 00:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PAOuJwPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B72E4086A
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822360; cv=none; b=HSG+gDKqlIs3qBrgREK6hS2mv8tWIveU7ByAGMhdJnEIan1Ls7NQxzyTTXJdeQZFUAVjYAjPB4t9FJslAbHG63uPwlhEevmadNOH9RO56SsoE8Qhp6d91XBV4IwZDBUp2D+PEgzSbRRV5O7vOXFUmuW7Wiji+Xbl+52zH9BkJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822360; c=relaxed/simple;
	bh=AtQ/82EtmVgp8qVHviU2+lHSIDSfcaSM+ddQXov0DvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xjyf1YrrrvpuOQjAYkhYkmINoYvj7MDGc0q9umA9lr+FVoZ9JmWnEWgFGsmIEAOU7zKpnVe7KE1/8qb+AqmOV4LUJQnCyGdA8CF386h8X+Nd36C4pyAM7lB1ygpQrzfciTg4axNNNZrkA9Bq5Eh2Fm25BLlQQl7ppOpcZxr7+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PAOuJwPQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29809acd049so25223405ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 16:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762822358; x=1763427158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AtQ/82EtmVgp8qVHviU2+lHSIDSfcaSM+ddQXov0DvY=;
        b=PAOuJwPQ2rB2o6dwZxMjWxzfjIBn75cgYhgMJNlsxtkGHRUJdaYpweN0l+ghdAax13
         +3rBKyuR0YcxcwT2nDV2iJQ2CO+bL0rzntkcY3vwpgLnDU0rSc6WMvwFX9iT3K+8x7+1
         NdABF2WerHeoVt0xrSDW9F6emmkvEQ000/+Y9tlUlm3chogXyTP6dau9WMFAOtl5PO57
         t5pRauyijGHgBUPHMlWtLFEOHm1IpJAWzg3gXYy7VhMnveNEo+JB58C2OrzOMx5c260g
         haMF/Z+icgzsWcMtXBC6cyTc18+2WHptBgJc8RefQN1z9YFIX8EjtQQuiQ5Mp5V5UiiX
         oU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762822358; x=1763427158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AtQ/82EtmVgp8qVHviU2+lHSIDSfcaSM+ddQXov0DvY=;
        b=aJuJgL3FEJv0isIG6mqemORQoeE2EMc5O3ZNQrFpXZG61OZgWOP3supKfw2oM7rYHH
         /OusjdP3EfmNHZaqjq2ZxncxBMXqSr2aoGIDlGhyMihl6vVip108bC28+///DUlf1Mre
         bgptgg163hdBGBZ2InvlrDRUv30nNLLjgBSBEKGt7fOMmHKrSOMC817yC08IwAwJ44Qy
         uZ/86GPZ103WSHGjNHP2pwVUnXFGdQlLxl1YYLTeIjMYNybMZx4iClsHJ1wLOKMZUbDK
         BFk6iNJNe0zbMGhNX9ddE2hY1LnkhvCgwSoQa0FSNrRlqPirECv8WX+wp+F5oTu/JUkQ
         Wxkw==
X-Forwarded-Encrypted: i=1; AJvYcCWGeoH9QwJOHAuOjYeS4DYzfA67B0FUyfveST47ulBq5WnRTNhdhI7g+ijmCTdrYfK8mnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFcK9Hl9W34w/tBgxjDIEAZdWLGbzmatMejlsp1gQaQiqj2dyf
	HwL/i9g2sGulA6NZRJwXwLJen++q1U0hX0TeX5uImFQD4mjAIkJaEt//kznazLcyKRZKLczNPec
	QhszrEw==
X-Google-Smtp-Source: AGHT+IEbjrsxaiNUslg2isBtzSL5dpA3I7qFnMuYN9dPxztymlV3kqChz46KobwAd71NGTPeJlxs97sSep0=
X-Received: from plnx8.prod.google.com ([2002:a17:902:8208:b0:295:5d05:b2b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aaf:b0:298:3aa6:c03d
 with SMTP id d9443c01a7336-2983aa6c179mr35537105ad.57.1762822358616; Mon, 10
 Nov 2025 16:52:38 -0800 (PST)
Date: Mon, 10 Nov 2025 16:52:37 -0800
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Message-ID: <aRKI1bzrNRiWaQBK@google.com>
Subject: Re: [PATCH v3 00/14] Improvements for (nested) SVM testing
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Nit, in the future, please label the patches with "kvm-unit-tests" so that it's
super obvious what they're for, e.g. [kvm-unit-tests PATCH ...].


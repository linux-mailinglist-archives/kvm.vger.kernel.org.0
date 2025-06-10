Return-Path: <kvm+bounces-48863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95B7AD4315
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 001B43A445D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59917264A63;
	Tue, 10 Jun 2025 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwVznA1J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BCB264A6E
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584642; cv=none; b=Kd/uQeNi1pvZuaMxkicz8AztSSVd53zz0nMjGl2skGfc2tBpauSzhPHUuh97w9pl3ozycBKjDbWG84dA4IDsgQfwgplo52aSYT8ic0aJZj7oyZ07iuhrmnu98vG4zq396IuY+doWQd3DYwq1CWb+DXtmCXnvQpmvrHD0o0WUykA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584642; c=relaxed/simple;
	bh=JIwFId8ozu56bjhFW4oz7WISS53dzrUpnIriWJ77lew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHrf+An17lmVKSCxL7nd5ivwxIwDO+LOhzEWXi2qqnifjUEOsn8rcvdgnSPGP3D/HhQ2iU1JEU7j08JL0oyGPDTgNpb9QjERzmBLQcjbcSXnsufBvZZX6fo2dDXsIh8u9hGJNOtdp5BkTPBkzhUp/zNU2ucphYopYP5Dd6XgMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwVznA1J; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so5425338a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584640; x=1750189440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Q0en1o7Nu/P/v7lqO/V4ODsS5ddv4KjU1qh4ETQ6EQ=;
        b=zwVznA1JlZf+P+oCCXobpBAhYxarhNSuESzkoFzR9QRocqDpVCnKEzlfqKUyQyhtBu
         jXsoisWmr+kIRIvq6x5oYOrKHT0wAJjXlbLUQ1uF8AXO0AH4pZqMCK7QYklBoXlMB8HS
         sSqfCjKs75PBfwAFJQnt4gxjAbN9ivlRGSUWmgzDQMmjBv/fVGBefGHh2WJO/EFnTlNB
         dTypAf+nBpPOJRc4mid/XjdR3KEQb9rmPGHkUsl4IfQRpj0EdA7ceN1j0s8Iqec0rlTi
         +bIHHJJgtaTt0O4vzHr7KTEHBnnN/1hAoQNKIqDZYhvVvbqt0hAvgwyCe307dSbH2VOm
         TH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584640; x=1750189440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Q0en1o7Nu/P/v7lqO/V4ODsS5ddv4KjU1qh4ETQ6EQ=;
        b=ooD9RFQxrel2vvG/FIuXTke8KZYNmcI0gjGpz+aDPkiZynb4flyj7W10aPtx4VhNAF
         DxxoG5fxNM4/y32FCwfekTrAe8cwp9MqNL3Yks3+zXcdOvrpTd8Z5jEO/ByEt0vxzypg
         +Pp5Aj0okaXUdIoZy6/69IrCpApb52HA07KVlqk/dWW7d2Cw1UxICf5EYmbQP9ARf4Ux
         cWhk3dlE1n7aqH38Dl23Uzm3c73QCAJmXfiuqgwdjFX5aw9rxk3PiW2/CsO4GYt//ukd
         /Hm1MO96kkK8n1N5L1cwxwUdrrqZ5E2Et4Qrq27LfbwQB7hgN/oG4x6i8M05eyvZOC2e
         WAzA==
X-Gm-Message-State: AOJu0YwkBkpaVne6UbfLIw76+IP2jvqnPNyLEeu9/f98i6JqhVM9cUUs
	qKWLPkClSY68D6LNLO9n3K7ZdzNKJbfudUD2pBaKM3ETORyTy9hoBTbRTaeoU3AQwxdBK50M73o
	WBiysHg==
X-Google-Smtp-Source: AGHT+IGexYxsZP1PR3nZeBA5ore7pYtoOXFF1aHf3qcpPgixm0nCcfOH4Cf8y3xjyc0HtyMbOjzKOkRWQZM=
X-Received: from pjbsc9.prod.google.com ([2002:a17:90b:5109:b0:311:b3fb:9f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c81:b0:311:a314:c2d1
 with SMTP id 98e67ed59e1d1-313af0e4b85mr1047653a91.6.1749584640516; Tue, 10
 Jun 2025 12:44:00 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:34 -0700
In-Reply-To: <20250529205904.3790571-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529205904.3790571-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958165713.103031.17191541227158331584.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pks: Actually skip the PKS test if PKS
 isn't support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 13:59:04 -0700, Sean Christopherson wrote:
> Use report_skip() to call out that PKS isn't supported so that the report
> is accurate, which is especially important for EFI builds, which report a
> FAIL if no tests were run.

Applied to kvm-x86 next, thanks!

[1/1] x86/pks: Actually skip the PKS test if PKS isn't support
      https://github.com/kvm-x86/kvm-unit-tests/commit/61cfd6dd3fb8

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


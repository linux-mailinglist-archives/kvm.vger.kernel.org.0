Return-Path: <kvm+bounces-38243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D19A36ACB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1438E1704F2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10628824A3;
	Sat, 15 Feb 2025 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KuElyy/T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56A29CE7
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582437; cv=none; b=gF4kiMACSiOWeMh2VJdy9FJwK3GFZ3X5mvJ8AotZI3TCJfVgwqAF1wjf1tOKVUeKsEISI0oZhhAazHLiuU809/xW87162IJSKw7pHU+qnlHYMiTvRerbLpLZlbXDznT0dR3GtWTLotgPnMdIZCkAA2xnltTCp9xAlY+Y7uCwI1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582437; c=relaxed/simple;
	bh=6Qq7VupLlfVnZ+4nUykuUw5Gn9qHiT204NROoTILSPU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IUXoJycX1OiXuOfMZB7ilHQGZ3PYK7qaO5cSyF9IDvcYCxrBMUP1li5k+/VryJu94lb9FKaEMtvul+IdxoJ6f4lIm8plieYTDQhaHEF+Ncr2icYsyg/CqKmc9J07rib5DTaeNUNPU3RMOzEd+evV2pboYX7YHKgcHVl3vGHOiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KuElyy/T; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05bb5so5551480a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582434; x=1740187234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2xTxguh1p0bSQjHnZvpqIcKuzENee5L2WHWrbGfydp4=;
        b=KuElyy/Ti/uDAFINt9PiYo4eIh6QrclEkifc2tO2Z6n4ha3j9zEl5cHaxhqWNk4Hkf
         rVyD8Jd3eSX8jDBuHnxprQkKsp0HRXAzRerjdpD/xX/cmwPm3lseSjW+HuzYysI9aRMf
         +FKXqZWloXtaOsrwrHoOlI8ZgDbVLzubiAs4qXgOcIoeHjbIJHRPwsKFadfpbWPtcUPw
         bYhlHnl6evX3LAzY11H2LlC9eIJvNH7otcFbNDsW/zPFwlcCuaxzO7qruQRCMVqeKG8n
         CKE9eFF/dedf66gx0f0p3Ly58vYquehlg92buXQoI7sGJjhRLy+z8bWTPCbYvznZd+/z
         v5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582434; x=1740187234;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xTxguh1p0bSQjHnZvpqIcKuzENee5L2WHWrbGfydp4=;
        b=EIk8FUbTKdl3hrA3hbtlByCKfMoY1KjaJH9UJznQsvcWxrdal10+lb2R+m3CVdRe9K
         yNoleLgblVgFziL3ND0X8pU/mkYKv8gsDPhtVaMlQCv/A89vHbExbl3kqKUpNnGXEOxw
         eh2S8G1ZCqYLk6tQojMCb51FECNT+tEdoa1gSTTRMZ1Bqjuif1Zk9DBHMltciLjx98ah
         CyadI/K0PPZD1xF5fQFz83jBFffdyQi0psukbeeXGOOI4epdnbmflvOgbDBSdB9Sl/25
         65ZiJcY4flk/Bdmib/tcVxPKfGQrKIadyjGkRGi4GsgKiPhvZZK0Z6/CPhLWb8LFwQxM
         ZOoQ==
X-Gm-Message-State: AOJu0Ywe/Zd7ay21nBr4ybGM7ZBEx0BYTF7Gvz98u1w9PxwaaWRSNaP7
	dZdjYh0I7/j5/rWPnAeQw26thhWKZDLmlS53QCev86HyGdV4zq6XoBYZrzo2qBYmF8iB39N61v8
	jCA==
X-Google-Smtp-Source: AGHT+IE6Sdfdo43lyMHVvItJqG3Mssh3GbsmSVAnfegM6CBUptroke/QcI22LUGAqq2iN1qjC+qmAeampiw=
X-Received: from pjbqc12.prod.google.com ([2002:a17:90b:288c:b0:2fa:a30a:3382])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3904:b0:2ee:5111:a54b
 with SMTP id 98e67ed59e1d1-2fc4115c78dmr1707110a91.31.1739582434149; Fri, 14
 Feb 2025 17:20:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:20:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215012032.1206409-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: Bump per-CPU stack/data to 12KiB
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Make the stacks and per-CPU data page aligned, and bump the total size to
12KiB to reduce the probability having to debug stack overflow insanity in
the future.

Sean Christopherson (3):
  x86: Make per-CPU stacks page-aligned
  x86: Add a macro for the size of the per-CPU stack/data area
  x86: Increase per-CPU stack/data area to 12KiB

 lib/x86/apic-defs.h |  7 ++++---
 lib/x86/setup.c     |  2 +-
 lib/x86/smp.c       |  2 +-
 x86/cstart.S        | 10 +++++-----
 x86/cstart64.S      |  8 ++++----
 x86/trampolines.S   |  7 +++++--
 6 files changed, 20 insertions(+), 16 deletions(-)


base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog



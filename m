Return-Path: <kvm+bounces-20625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E5391B44D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 02:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2FE82842DC
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 00:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737906FC7;
	Fri, 28 Jun 2024 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q2U10q8o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593444C98
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719536163; cv=none; b=RaS03OP5mxMCSDvAbooXNpUH2txxF5zCff5Tp5G1kL4/+we62N9hxJulhAtvzAqQt2znbGnPL+pnOkxZRdAsaCJPSVTnLdivoxDrGbMWt965hNwLM+nIkwzxdG61eiNXyqZ4cwMeQ9MHSgULZlLKQ07NHz2BjCEI5Tj7ZzNcoGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719536163; c=relaxed/simple;
	bh=cbbm+ckRrExZY4dZWB9fQIjA93CBRPOBuyvhmoh3Sjs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UvF789OA9IRk+PhKiWIO6I2vP3GX2BPj7If8SNQ124499Hi0ZLwTjhdO+71KN+EfgvSw07vWN2j50NUIgdhmcjQUEbeSZ383XlYRpDXMbVmRmSQqFwKZI/3sGGrsQFV9HAmC08+ynrGicOu4/IX6fQWrxfyCI6Mgn2oPZ/Ao2m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q2U10q8o; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b5792baaso82280276.2
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 17:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719536161; x=1720140961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/oAzeV2dVc4YsKP2OxbQn62HUeGZJTHnx9/Fe198ZRg=;
        b=q2U10q8oC3QSK8Djgz78f0jHCEqRr9+vsnAD3R6ByBIfIxRZea9tIv05ZkLnurLnyg
         XGFeBpxqqrA6MRpZdPj8ON6MnXfjUwj/3DXZSQl07DO8JYvjNcXL213LUpJgaEZlhtvl
         Cw7lhG4hFXgI+v765NtsAgOlVKr250qO2o8kEpD4iAlA3HQVwP28by0PErgq0JZgcrcP
         TE1cjHZtpnRhx1sTCG3xzR5Mo6Ms8mVat2Yd+Aj2jcJyoaHNPxgaA0wTaHlETlzGTmDi
         vVXZOhGh3+jodXrlrIGlHyVMpRM3UJirztlKkw7cOdQ2bc/b6Z96VgM/niKcOYrqh+oG
         e0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719536161; x=1720140961;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/oAzeV2dVc4YsKP2OxbQn62HUeGZJTHnx9/Fe198ZRg=;
        b=iRV0M8d8hoGzb60i9wOE5J1AntSoFmkDmvPsU+cyyyRKDOKpMSB1EnB/vlMVJPGfDh
         m+l6XY+jNPvnbDbjkCxJCg7pSexO7DaqKEL7JhcT1ksKr3KUQTR93ZqZUklUIYMtx6/E
         GaT3Sds+MYUMU7ct7O3+Df7id/pzvWcOuDbH7H00k/cr2b7WXJGc3JLdkgfXhnlx+L3L
         kdNN1G4AyfrwmxQbBII5vv8JFknDSvLIBAfq26ugOmaTJawrHI/rLxLz3Clih0iVF0A8
         uueU/Na6nMcPpwxYgSZnvdS8K+bULir6jOpjX4mUwtw8D5wk23wH7ai4QHtdfzSQuBir
         ChiA==
X-Gm-Message-State: AOJu0Yx8RhfXgMlgIXdwlSl8QMpKWe/j+/5QtPUJtywTeMlYXz2BORhL
	2V8nt4o1xRNl5YZxXdk49rlUlBERIce1Nao770dLnRVw0tytp69zSKKT7wU5tre0MlbfR/7sGsR
	DKg==
X-Google-Smtp-Source: AGHT+IF1jK/zCFugTHqUrwCCUkh+kMerlYt4Sy/sFFJ6qVgb1wC4DxX/+h0yPsBwi/0qCVmgPbR+Fpl1h+c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c07:b0:dff:ad2:3c13 with SMTP id
 3f1490d57ef6-e0303fd0fa3mr282828276.9.1719536160946; Thu, 27 Jun 2024
 17:56:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Jun 2024 17:55:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <20240628005558.3835480-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: selftests: Fix PMU counters test flakiness
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

v2 of Maxim's patch to fix the flakiness with the PMU counters test do to
a single CLFLUSH not guaranteeing an LLC miss.

v2:
 - Add a prep patch to tweak the macros in preparation for moving CLFUSH{,OPT}
   into the loop.
 - Keep the MFENCE (because paranoia doesn't hurt in this case).

v1: https://lore.kernel.org/all/20240621204305.1730677-1-mlevitsk@redhat.com

Maxim Levitsky (1):
  KVM: selftests: Increase robustness of LLC cache misses in PMU
    counters test

Sean Christopherson (1):
  KVM: selftests: Rework macros in PMU counters test to prep for
    multi-insn loop

 .../selftests/kvm/x86_64/pmu_counters_test.c  | 44 ++++++++++++-------
 1 file changed, 29 insertions(+), 15 deletions(-)


base-commit: c81b138d5075c6f5ba3419ac1d2a2e7047719c14
-- 
2.45.2.803.g4e1b14247a-goog



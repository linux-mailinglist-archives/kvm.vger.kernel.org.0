Return-Path: <kvm+bounces-38909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AABF7A40309
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C3473AAFB1
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FD3250BF3;
	Fri, 21 Feb 2025 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nI+ffzh4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04BE1EE028
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178450; cv=none; b=mG3HTmoanCs6NYsdakEOEJMUCzmpAP1yMfVye5FFHF3LnwpcxMYxZqwOYux6newAlwO9ldY0l4a/IKomMRlfMic7EcyvaMR9w27rpk2H7UInghJwB9KaPnkdR3EylCKsAEfXMX8Id9mFfH0ZB+fq47Yoq+rugPur66DuPqwRbsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178450; c=relaxed/simple;
	bh=Ig5XE6tmPxoa9whhBOBCjp3dTivxc9g+jEquTonlFHA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SR/sw6IDbmvqR1Hth6AzTdirHSuH84J2RyfA2E5ldbAFOmf4G7JiUPlJhiJF1+cKAco/Ri8OHNQFptbj4P5mTu9Qv0zfn2IphhgT4fkkKHwId9Qay9oLvCgJTRIjDiWdnoVXpwrvFSpuAN5AuN7hTea1o23kdouz1jX2MRndPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nI+ffzh4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220f87a2800so86833335ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 14:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740178448; x=1740783248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2968BjKXU4uTfCWgpq4yUXLeo8y/uamy8Rf7xlnkzI=;
        b=nI+ffzh4l87F8ChYjBg6xcNQynY5DBYPOE/BzXyBlUK7IOFfDn6kUusjO9KwxeimjJ
         pfmJVcf0ITAgZy2MzF2Dbbn+XcoY/PD3YOBsOMAbe/cgHmL7wtFfD3WePZ45v9yLRqbC
         BYb7tj0TlAJXtdDXQiLMVldC+FuonQQZV5VmpSyMI4S5q6hmzWnwjlDDU9wXtLG3KXRG
         VBDSoCH9yivcf+Mhc0BWOcL+q09N8dRRHbb/BRi6CjfnhxkY1DciduPD8Aq4B3tRC6ga
         R6oefFhlzcFvDzf1yzlgU4+xS38gmH+kgp3B0HgUjZeBlU7efLv+heqDSw2nwTpuWXkz
         xUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740178448; x=1740783248;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2968BjKXU4uTfCWgpq4yUXLeo8y/uamy8Rf7xlnkzI=;
        b=b6cuMFkiydc2DdkNtwnC20fdzuLrIeXyzDN5di4hXCLQxPNN87jLP2CTeKYf4LKqFk
         1pQkYiNbY1GUVXZ2Q1gCgLa8iihQgpzzpzqFocpQMNmPBFpOrNRLOe/pIgyAFTkWnNGe
         4wYVAENY0ABuYAbD2syyLbsnsrFffhFe54AUA0lc3KheZJXTd7eURsbLyGtIw4KxKY/Z
         429BI/sdQJo3TLJhFxewyww0ZT8b4vtdBeELrtCPX+7pi9aZoURvjwHv6/ou+0HLevZB
         Eb1rKtJ4/uMJGzwUi9bTxj+bZvYf6sDR9Vy0ro4SOO+/cx+v4ZZWgMOIx4bYrznUycRE
         c9Ig==
X-Gm-Message-State: AOJu0YzdQdgVr7o5N7x64yS8bRH/V2TkQzNKuAh87MO1tSX3YZndz+rH
	IDIcvFu0P/JBlWAuwyhJU6PJhp5HsqpkD3WCDRT+v78/Nc8lVYl0M4ylL5j9W4S1is/VVoSTLX+
	N8w==
X-Google-Smtp-Source: AGHT+IGgJqudSSBU+HwsNnDFay2YEu7rgK+yi/dgu8bA8ivRdT//4FK9JKu8MnRKP6HjiTXG07iIQ14WLuw=
X-Received: from plbjb9.prod.google.com ([2002:a17:903:2589:b0:220:d3af:7f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f712:b0:220:ef79:ac95
 with SMTP id d9443c01a7336-221a1148b7bmr67466495ad.37.1740178448179; Fri, 21
 Feb 2025 14:54:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 14:54:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221225406.2228938-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: Use macros for selectors in asm
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Use macros for segment selectors in assembly instead of open coded literals.

v2:
 - Commit to using __ASSEMBLER__.

v1: https://lore.kernel.org/all/20240621122640.2347541-1-darcy.sh@antgroup.com


Hang SU (1):
  x86: replace segment selector magic number with macro definition

Sean Christopherson (2):
  x86: Move descriptor table selector #defines to the top of desc.h
  x86: Commit to using __ASSEMBLER__ instead of __ASSEMBLY__

 lib/x86/asm/page.h |   4 +-
 lib/x86/desc.h     | 123 +++++++++++++++++++++++----------------------
 x86/cstart64.S     |   8 +--
 x86/trampolines.S  |   8 +--
 4 files changed, 75 insertions(+), 68 deletions(-)


base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog



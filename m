Return-Path: <kvm+bounces-48858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E46B7AD430D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27277174B02
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A716226463B;
	Tue, 10 Jun 2025 19:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1yddMFPH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAB123183E
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584600; cv=none; b=LsEo5FXgatbbFsA7nURLrxh4FMwYPMCxa+nXZQ5tEcTuGvZ8kTkv/Tdd6RScB2koYtvq0BnhB2AbANAyJhPpEh7hEtbfzG9XoV0eWAfDBI/8Blxfau+RuJwn8jyacHlv0SNRVOmmmLvFTnMN/lfFINMHPNHuJ1yT8v2LAHiqhjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584600; c=relaxed/simple;
	bh=Iwy8NY58KQePrrWbHpjSW99wKuReIf2GvBm7+wChI50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BuYcEqdpmQxs2vPySlDOedY92RQ+yw5ngTTWpxdpkXARNPUo1Df5QCJjvX+2qGv5q9QtilbE5dak7gF76C3bh/DK+motRA+E0hnZI7QxEQDjnzvBR04j3Ke4Q5UXGqfzY89vtqf3S3hJ4rOKT134xDNSFhIlrMdUbZyZc3V3PS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1yddMFPH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742cf6f6a10so7972180b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584599; x=1750189399; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJejgViKNsZj7pWv49HUOX5soNzayp031qY6IfDd3CE=;
        b=1yddMFPHZ5a8A/z/cm/2IsmiFEAkM9tjTXmtXq3B9yQWpxe2pPe4Slwa/1isi22kvm
         VC0rorFdG8wPPGG2tQV4z25iqEhWiQOhwGlBHNeJcFeAEyfqRRoDUJzuNzvZpPQDmMC2
         5rwRE2cS868TCyszq8xarIsOfpMSrzufH84IDgiDgIUy4eH2TjcM7gIpmAc8cku1WmAD
         2Kenrt+LiMD8S+bjzheAB+CqJEZsqPOz6kxpr0V0uq5vVWm2hrE7pjDIqSjCWhE2IlEZ
         ssRlBaubQW0bFGTDKdXsPLUbfl43XZTZe1GkbnBupcC5nOOxcFYb6PuN0KVkH0//+Jtk
         shAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584599; x=1750189399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJejgViKNsZj7pWv49HUOX5soNzayp031qY6IfDd3CE=;
        b=t2GY57tPVw2n4JskdzyXXJq6NDTNNRP1DFq5jII/wVBjcDruwzGvmBjxzBQZooge1s
         ZxdYFFQ/trqojNluOv/cfOG0cyXfmH8TAsmFbJ3tvUujNGOfuCQdd0jiPf8u15r0GMpE
         JVk4ywvvXUhNGe4UKglcoB3AhWv1XHWf5y5Gc9bOKPTcYOZ+cMmneHCA71nuYGbuMPnQ
         ctFLx8/2zT7y0U3EpWazR8kQDavzSKrx09rH9+Ncz4gqk5hgAby3yg7Mw54thKr8IhH3
         9x390I64pipuiUlrJ4AmpuxFQldaQHAKZDx4EJkjELDr5ZC84m8w/EYGSI44iWPzDSLm
         Cugg==
X-Gm-Message-State: AOJu0YxXbK33cRCjc+CBomIiGZInokYtUfQzo2w8pSp5m0mtjyNEjSIU
	yGh1vtDhfEjWODf+8VzjZzM/9mE3LryH6XCpzBwsQrIQt/Cp/4cJRllMePssCFIqfIV+zDWQiKP
	PLinzjg==
X-Google-Smtp-Source: AGHT+IEcB+Nwfw3pSmScCOlLPfkMiQFz/m7TlS5HdfyyZ1cZDZ8Bc5ewUMSeyG1rrdg4MwItXmCTzzlfOiw=
X-Received: from pfnj12.prod.google.com ([2002:aa7:83cc:0:b0:746:32ee:a305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:988:b0:748:2ac2:f8c3
 with SMTP id d2e1a72fcca58-7486ce5a4bcmr1005907b3a.24.1749584598737; Tue, 10
 Jun 2025 12:43:18 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:24 -0700
In-Reply-To: <20250529205820.3790330-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529205820.3790330-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958165553.102948.14956267250709935254.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] runtime: Skip tests if the target "kernel"
 file doesn't exist
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 13:58:20 -0700, Sean Christopherson wrote:
> Skip the test if its target kernel/test file isn't available so that
> skipping a test that isn't supported for a given config doesn't require
> manually flagging the testcase in unittests.cfg.  This fixes "failures"
> on x86 with CONFIG_EFI=y due to some tests not being built for EFI, but
> not being annotated in x86/unittests.cfg.
> 
> Alternatively, testcases could be marked noefi (or efi-only), but that'd
> require more manual effort, and there's no obvious advantage to doing so.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] runtime: Skip tests if the target "kernel" file doesn't exist
      https://github.com/kvm-x86/kvm-unit-tests/commit/7f528c1b474c

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


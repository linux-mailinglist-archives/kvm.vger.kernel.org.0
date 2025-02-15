Return-Path: <kvm+bounces-38247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D897A36AFD
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E55E317091D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605D3126C18;
	Sat, 15 Feb 2025 01:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fy+maiKm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AA0199B9
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583022; cv=none; b=Asqd3s257pxvMlrHrIqTDZTUmMQnBU/Ai3iiWbHNaW3xXHLjRApxIaZRTWXRHxbPNPsdnuRgqc2BprvCFoFX1u/QDFAb6jkxxYml5XVJWfj6C1mU9wXy25EG8SXJvbPNDtGCXtN5mVEN+rXUtaX0ufndvj26JCw2GXavacrHmPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583022; c=relaxed/simple;
	bh=1Bew+9v1IFRNO6ENf6VJu7yZQkhRiQPLPrv1x8GULok=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QGAw80pu14rI4c5+Lbn4GJqd2+oP4wjxTNf9NiV1h+LbDsQmvy4eOtpNnWdUDtTo7Da1Zsr4Uf8KKBFCNmUgAw8pA5WbIvej2TLVNXFLvBwWSn6nKUIC0TSpga5IwUUJCUzlbi5fGmkQeAPBKAZlddFLmfX4DAaOq81S/B9Bwp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fy+maiKm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc318bd470so2670637a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583020; x=1740187820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WADMO5X7CIz7M/YMFuR7OxGdAy1pQAUYckb1iZBMHQM=;
        b=Fy+maiKmgbxQv2K97JBtCESWyHN1Lk3XQ0Szln9jjLmTsF/o7j4B2/Kn6okzbIBvj+
         2mvY9CK/xJug8OF2e3lY73V7sqhP7rPf5e/+INiTFLdLkrsBU02OABDVrZlivK+O+u5H
         OJ0xyCi1jWlOisGTzR8BdoC8c5UUEQauKr68dH2G4Ja9+Mho2Tezl1ORohIaKFbtl6tA
         IGblE3D+GhM3lumHhdulm0eLMGHBf5NtpWYUn8ZqgwqE9sw/sikpnscvhTJGH+IkVplG
         /2vPl457MZdW3P48lqJuyoo4aRat5HYUuewKJmFlS7+iE8Peo69UNLZPISNPfbddDgRC
         S2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583020; x=1740187820;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WADMO5X7CIz7M/YMFuR7OxGdAy1pQAUYckb1iZBMHQM=;
        b=NTyWgZQF/7bLjBkjd31eJO0B1rCPGJf+pFaPfLv1GP32vTyZhDIQAdgXSUoVJfI3AO
         lA0akb+zrav5diEo8Z3n7k7zpI4lWsmiRdxNKezUAFDxKRFobBUr33vJK32dV2bJXQas
         bRu7fuZlKuGePbl0d0KqUGsAkQO1fru6WPGFMlF7ZQFZRM2l7ot1uPMy/zX4tn8ppZQ5
         0XDh7mh1OWWIuQsrWGCnKK/xniIapzlKVhdf3RN9QXNb67ZvqaDm0sF75rwPmwKvXr5+
         5dbKvquSWSNcSzdeakti/O6PozaJzT3pySyByUCSY1MaNZQ4U+IOBfP3MUyDTj7WZgg5
         i/dw==
X-Gm-Message-State: AOJu0Yx42rl+2yK4aHEcKEMxO7cDrrthqW9N1wzkiY0mSMCyIVIKu25v
	PB8BEBgxtEE1jA54IiVZt6kOuESRS5CS8iwecXWReJm6+D43tDWJxhE57cBdLcOEfP3faFy7iVb
	o2g==
X-Google-Smtp-Source: AGHT+IGqLWkInyY7HwP/E96mtKxvHWlp8e5Zpmp1xxw1RfVCLjYMzhoA5HDX8TqLSQi5xea7rqFyJcskgzU=
X-Received: from pjbok13.prod.google.com ([2002:a17:90b:1d4d:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b4d:b0:2fa:226e:8491
 with SMTP id 98e67ed59e1d1-2fc40f1027cmr1841998a91.9.1739583020445; Fri, 14
 Feb 2025 17:30:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 0/6] x86: LA57 canonical testcases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

v2 of Maxim's series to add testcases for canonical checks of various MSRs,
segment bases, and instructions that were found to ignore CR4.LA57 on CPUs
that support 5 level paging.

v2:
 - Fold into existing la57 test.
 - Always skip SYSENTER tests (they fail when run in a VM).
 - Lots of cosmetics cleanups (see v1 feedback for details).

v1: https://lore.kernel.org/all/20240907005440.500075-1-mlevitsk@redhat.com

Maxim Levitsky (5):
  x86: Add _safe() and _fep_safe() variants to segment base load
    instructions
  x86: Add a few functions for gdt manipulation
  x86: Move struct invpcid_desc descriptor to processor.h
  x86: Add testcases for writing (non)canonical LA57 values to MSRs and
    bases
  nVMX: add a test for canonical checks of various host state vmcs12
    fields.

Sean Christopherson (1):
  x86: Expand LA57 test to 64-bit mode (to prep for canonical testing)

 lib/x86/desc.c      |  38 ++++-
 lib/x86/desc.h      |   9 +-
 lib/x86/msr.h       |  42 ++++++
 lib/x86/processor.h |  58 +++++++-
 x86/Makefile.common |   3 +-
 x86/Makefile.i386   |   2 +-
 x86/la57.c          | 342 +++++++++++++++++++++++++++++++++++++++++++-
 x86/pcid.c          |   6 -
 x86/unittests.cfg   |   2 +-
 x86/vmx_tests.c     | 167 +++++++++++++++++++++
 10 files changed, 645 insertions(+), 24 deletions(-)


base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog



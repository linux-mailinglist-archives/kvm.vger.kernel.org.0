Return-Path: <kvm+bounces-25286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BB2962F8F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 852791F23671
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383981AAE3B;
	Wed, 28 Aug 2024 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VFRh3Kfr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF356328DB
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868893; cv=none; b=J7QAO1FWvYJdIA4ElJTSO2rHEeso7Mp7t/a+0mWEoyVfnurWzfeaHd+vAohL/Dza3RfPNIgDzMHR7QWaFv2codAjQHXI+fCzjMcrozCbKFS3VWDuchreNaUirKPm0hV3+uVOB/0sYtzgQqHsgbloNRO1vzuuxkxGm4hoKvG7p6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868893; c=relaxed/simple;
	bh=pVhXKjby8bhIreyL4PFHTc8fawyZtoXPbo8guPrsDeI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gSIGHsepZixJ7vK1aow1G+X4jHtPQm+R6VIjAyN6ER1dbWTBp1mplTeDaRvkiiVrdyXCDEj4ARFh1ncb+U/oxZWHc3FXjgs9PJcYiYF/rgtEmqJhLBcwq/3dmoMF0bAXzB9jXyL6AEGcZXRDrR2E9rVjFm1Q2pqIMntZT9DS5rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VFRh3Kfr; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e11368fa2e3so13699896276.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724868890; x=1725473690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOTuctWAQz/uwHvaj+krenR+3V9HGV0qn8wI1oPN3U8=;
        b=VFRh3KfrYyR0Na8u+20IBNqa59wgS5GXlH1K35CAAmP9MWNDJ44MWGIB1fAU+q1/6U
         +hOibOgD1322uYV3aL6j2958ukk3RORCFN2iBDah9zfmi35/4nBEgimb5NakbczCO6al
         moqFPynrHkoTjaL5WkhmOqvVS3RwX+yA0EAmu91So5Ee829hqKnOi0FIybn4m2q4LePu
         LQ9LKG5KKV9n/2eQFMD0gHT/ZJBAQN8YmFlXVJdBCWTARjeSB9Phmk3gAzFEd1jFOeNp
         U6MnOH5X52vvGd/1Hp0d3EJ9Y9awvvsbQflwxpcqA2BlQMVmd4b21vLLcM+XRa80jJqt
         cb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724868890; x=1725473690;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOTuctWAQz/uwHvaj+krenR+3V9HGV0qn8wI1oPN3U8=;
        b=WxXMKf02kQ8sKaHuTbZrgHpfnoqQ3llP9m04W+VlyzVR1wMlSeblQZM5Sw13QF0ptN
         V7PPaaVD0rmS5Fmlq6+Yabu7askUjmXPwNqb9QW2fL2qyZCqZfnQarLwRvrNHos0ddSw
         oItxJhjhY/1v2FXZFYyafmdpsDJ86Eb+aKr0sWZ6iHDuO3JuCEgB8SQM9P4m1ttk72i+
         EPTnXh9fIoE71G9Vqf+lZRRxBkYIhca0FelPHKzng2DKe66k6MCGPzK73aeWVSNW+pHf
         jOc3IMfrF6CpdcGfiJ1GMdnHt87A4hKef4EHXFcgDzbgCibD5MmEmoqYB/RHjrJqFw3B
         fSlQ==
X-Gm-Message-State: AOJu0YwFVfOIM8q1w6e6MoOVNREdTylFWLkQGPDViBfwaLO9IFtZ97+H
	pxwRmh8Wf1w6xWnLBjiYojBEnO7gpq7OaOSzr0uOhE5x4wNs02NOBmeHp7t1oxOw93PpjrGkZn9
	fkw==
X-Google-Smtp-Source: AGHT+IG0qH6fA9bRjxhpjRUB2InNr/s22CMQVHqs6u2Z8BKUP2KlijIIpCznt61+Js/vDVlK65vywKUevps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6906:0:b0:e0b:a2a7:df77 with SMTP id
 3f1490d57ef6-e1a5ab5894dmr1037276.2.1724868889792; Wed, 28 Aug 2024 11:14:49
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Aug 2024 11:14:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240828181446.652474-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: Coalesced IO cleanup and test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ilias Stamatis <ilstam@amazon.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Add a regression test for the bug fixed by commit 92f6d4130497 ("KVM:
Fix coalesced_mmio_has_room() to avoid premature userspace exit"), and
then do additional clean up on the offending KVM code.  I wrote the test
mainly so that I was confident I actually understood Ilias' fix.

This applies on the aforementioned commit, which is sitting in
kvm-x86/generic.

Fully tested on x86 and arm64, compile tested on RISC-V.

Ilias, I deliberately didn't include your Reviewed-by for the selftest, just
in case I botched something during the (minor, in theory) rework.

v2:
 - Collect a review. [Ilias]
 - Fix a typo in patch 2's changelog. [Ilias]
 - Rework the selftest to containerize the coalesced I/O ring and its state,
   to hopefully make it easier to extend the test to validate using a ring
   other than KVM's built-in default. [Ilias]

Sean Christopherson (2):
  KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
  KVM: Clean up coalesced MMIO ring full check

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/coalesced_io_test.c | 236 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  26 ++
 virt/kvm/coalesced_mmio.c                     |  29 +--
 4 files changed, 273 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_io_test.c


base-commit: 728d17c2cb8cc5f9ac899173d0e9a67fb8887622
-- 
2.46.0.295.g3b9ea8a38a-goog



Return-Path: <kvm+bounces-72696-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKbvIlJcqGmZtgAAu9opvQ
	(envelope-from <kvm+bounces-72696-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:22:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E92204221
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C070830067BB
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C443364E84;
	Wed,  4 Mar 2026 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="psUL/KCF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2136405D
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641347; cv=none; b=ZIBq5A4S2rXTWLJ4+5O45vCyO/EnhFLJjGn3DL/xH79E5AjDERv5JsFJ+xZwfZZQjEGTiioFRzpRddn8uwJVoAGf8/ylHQ5MsbQ80hh+oWovane73CdlF8Zq8mFPT5lURGWozL8CtJp0Wo766ZpKjNyQD5vQUAi4PQdCYWJuVMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641347; c=relaxed/simple;
	bh=cvnyQnDq+kA5IyO6MNTtGQveKVAjiAkxaJxS7jL1DnM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dgg0Q0kkxyrBJ9OUIKU8ajvM02mRXUaZmRFcU7lMXw8VrmzfnDwE+CuoT32+O2bt/1vkuKcCycMe1ToptSVFpHPtuhsaAprKo0IyU755pam4clR3gMNC3okSq8n+zmJyHFc7qbfr0bdh/FRxKykAPLsYgWnNBvj4awGIG6WJMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=psUL/KCF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so85286675e9.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 08:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641344; x=1773246144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=23c+ROMNUk5Dd7yUKgLUSdTwchiyCsLiWmB8a96IYHQ=;
        b=psUL/KCFcnu77IVLri6pE1ySl2RsqisQegoMbrchw2LPXDdo8udqF8s+k59D2qyT20
         u73OYyysw7n4CcQKIfSyIEfi/bJjAWlitvmpcdmV4+vto4MpjMsjDM+e9sWDjymvwc+x
         zBCJRU7v4nNtJdgYhzrHuTOU6QwNgTNvhdcLXPsZPIaP9UqwV7uzVZ/mVCcLAmMlVIPv
         slgsgJN7QB/NcF6mLMaASINpHb9szSm/bDzvkNMcGQL6h70ZK53MuzBLFCpD7vll/ZL/
         Ki6i2WMJay4SeyGJ0icZ6unzKWoDPiHRPM68mdEgcy+0D3ZE1mbv3OLfxZiLEMnbR2Al
         shQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641344; x=1773246144;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23c+ROMNUk5Dd7yUKgLUSdTwchiyCsLiWmB8a96IYHQ=;
        b=LXZFzg7nwzeMx/NeJjMkE/VexvdiS3VUx/ukRBds0Jd+K6yI1iFAUjQTlXUvoc8ixO
         ZfpqzWsungBki+aL2u+lTF6ahjUa1kYngg/eYBQthgkcQHsXmP/OzRzU/0NuA2AL1EOS
         c0k+6Jq28lffEGr0XAzo0LvhCQKQOfTh2Q8xl5qnziTf80SIBfF6Y8fXBeW1c/Va2t9q
         7TgJfwdBF8aQxql+qlcgWStNF0sjNtVWApLs1PqCpjJnsDP/ikQmsZmR3r8OdRsWEdWu
         E7YfJ9o1fMffR2T5bPo2tXWqjJlcArTLlKaj5l2Y7k0aH9NsKQMdLtlGOCwT36xCC8JK
         0yHw==
X-Gm-Message-State: AOJu0YwAJRb7oN6G0otlSfKmT8J8dgiwpZQxIXov7PTnKJszxyCXbvVb
	ixezbCbQrPOqaII+n2dgWnRV9DQcYJGub8uwvYEUNKzEky3pZsBYcpznxOqnsgOpQnogencUJ/5
	G4FPTRiMfw47Guq951MAWuCEIQiluJvrC5ihU3hbLi63uS+rZEbdEhCgZmZRt9yN8/EnMz82Mi8
	i5u0pBAz1V7syFUBLgaiqLkMM8x4U=
X-Received: from wmo14.prod.google.com ([2002:a05:600c:230e:b0:47e:dc0c:276f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e8a:b0:483:c35d:367f
 with SMTP id 5b1f17b1804b1-4851988a6f7mr43226855e9.21.1772641343626; Wed, 04
 Mar 2026 08:22:23 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-1-tabba@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fix a couple of latent bugs in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 51E92204221
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72696-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

While digging into arch/arm64/kvm/mmu.c with the intention of finally
refactoring user_mem_abort(), I ran into a couple of latent bugs that
we should probably fix right now before attempting any major plumbing.

You might experience some deja-vu looking at the first patch. A while
back (in 5f9466b50c1b), I fixed a struct page reference leak on an
early error return in this exact same block. It turns out that another
early exit was introduced later on (for exclusive/atomic faults), and it
fell into the exact same trap of leaking the page.

The fact that this keeps happening really highlights how dangerous this
"danger zone" between faulting in the PFN and taking the MMU lock has
become. To stop playing whack-a-mole with inline `kvm_release_page_unused()`
calls, I've routed all the early exits here to a unified `out_put_page`
label so they are handled safely together.

The second patch addresses a staleness bug with `vma_shift` when handling
nested stage-2 faults. We currently truncate the mapping size for the
nested guest, but forget to update the shift, which results in us sending
the wrong boundaries to userspace if we subsequently trip over a hardware
poisoned page.

Finding these issues just reinforces how fragile this 300-line function
has become. We really need to refactor it to make the state flow easier
to reason about. I'm currently putting together a series to do just that
(introducing a proper fault state object), so stay tuned for an RFC on
that front.

Based on Linux 7.0-rc2.

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Fix page leak in user_mem_abort() on atomic fault
  KVM: arm64: Fix vma_shift staleness on nested hwpoison path

 arch/arm64/kvm/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0.473.g4a7958ca14-goog



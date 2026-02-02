Return-Path: <kvm+bounces-69817-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OR2CnhngGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69817-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:59:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7C6C9D94
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD01F3019B8F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E20132F763;
	Mon,  2 Feb 2026 08:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dGDoCRcs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D96029993E
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022645; cv=none; b=bDzSRpWZ+dYoG9L6UFewd8R1PDSDHWLrp9iqSCmDUxAknd0HWZp3lzfhzOc9gZOSm8cLv4eWdINBHtLANexXK1IRH3fdrtHK87FJkaapF8Tzx9w+om+ri/gfI6ipGrW+LzRdB/UE6hn+LyKwRTuYwZTBoA1HT3Bo140EBL32A1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022645; c=relaxed/simple;
	bh=NF1DOY24PyUCApSu4MuWe+e4itYOoRIfIbv3m6JMlGY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WUdTxScxvGbSUTHcK8dIJuSRFyEyFXr4mpBls6VSD9m2ji6u886vH6RLJ+9cO+RwGb4pLKGaRY8EMeaMVMZsvcil3z3Kjm0buML8Mmc6RMW42zfglI+M0O86oSPlX/AocTFmuzo55GaluFCPtHP8Hm1I1m+5mKwnZhrxDSkJpAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dGDoCRcs; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806fa4a180so36421955e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 00:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022642; x=1770627442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kGb5tEG1VOIoITicmnlT7KV6MD9I7+LZxxMBQmSh2pc=;
        b=dGDoCRcsRIK0x0qM6gRBUgx3ZqvzkBFVsweFSkrH1WsMsp+ozWigRMSkTCOYOXFmAn
         bY6Tb2EafAIgNy3gr9TUZW16O5ezRSIS+xfiq8hYP/rc/4VoglbP0eK256fChDKXjfxD
         Z2J9ckCMeOSL+v80x5TLFNnALMi1zWqwwxR4a2m1PR3a9O4BbDW0yO0x4GT3w/N5A7J1
         T08gpAs6Guc1O9I0Xfpf0ihYwm/2i8vGtpNClNupxBnOCTVHaHWczsOns83GI8CIv5BL
         KywyDh3yTkCW2ZQ+sPQsT611VQoHecj5rpFSkb3EqvRImXtFsBfB7fl5WjBzuQmozG1u
         6pqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022642; x=1770627442;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kGb5tEG1VOIoITicmnlT7KV6MD9I7+LZxxMBQmSh2pc=;
        b=NNXcJ6u/jmqimiKbMnQB2Go/SQ3cjUZOsl+1NP9g9uHx6fFHWMm8L38dNmolvOj97V
         6jUuTZF7y3r0dJg2t4Yv4x2lxyyuyt+KH5DGAdk7hallKLSkL8DJ8jtEUKcWGyCbCaII
         qU98dDNW7lVtRrfmWJxOONjGzh9mHSQKPMj6ueZtnA/ALi/lKtEaaDZJReHU+rAEtAD2
         K2KnqEaXXwhS9Mwn73UQgZWheSgon/crkwo+eqkrc2s2C06qBh+WB9Hbshhlgiz3CZpI
         XAFpfiLrE9PWyhtDsGNDuTPatJaRzUBBuN11xXhTLtv1oL9ZMSAxUSX2HlYjm40mv4hp
         WecQ==
X-Gm-Message-State: AOJu0YyfAEoo1vnegtun3VuyYYoIvQsAoABzDlbXJAe0ToYP/gFgXaSF
	kFPDMsD04Ps1/haTpXnpL1lDSSv7C4eA+rvHebdCqAEVuhbst7f7ibSbrUM46l+jcH1OJD5bkHk
	XhSs/Ra/3kBNK+vKT0jm/IRaXJ4PqnFEJof0G93eiPrT+24CWyqinvmZX3bhHpyifUsdEnT5rAA
	yPKxM+pa9zpqLoU6yRZX1MjvX4kyY=
X-Received: from wmil16.prod.google.com ([2002:a7b:c450:0:b0:480:694a:dd63])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:348b:b0:47e:e779:36d
 with SMTP id 5b1f17b1804b1-482db4d826dmr117690445e9.23.1770022642339; Mon, 02
 Feb 2026 00:57:22 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-1-tabba@google.com>
Subject: [PATCH v1 0/3] KVM: arm64: Standardize debugfs iterators
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69817-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7D7C6C9D94
X-Rspamd-Action: no action

This series refactors the debugfs implementations for `idregs` and
`vgic-state` to use standard `seq_file` iterator patterns.

The existing implementations relied on storing iterator state within
global VM structures (`kvm_arch` and `vgic_dist`). This approach
prevented concurrent reads of the debugfs files (returning -EBUSY) and
created improper dependencies between transient file operations and
long-lived VM state.

The `vgic-debug` implementation relied on an XArray marking mechanism
to snapshot LPIs during iteration. This modified global state during
read operations and could lead to reference counting leaks in certain
edge cases.

Note that `vgic-its-debug` (for ITS tables) also uses a custom iterator
pattern, but it is not addressed in this series. Unlike `vgic-state`,
the ITS debug interface iterates over linked lists (`device_list` and
`itt_head`) which require holding the `its_lock` for safety. Converting
it to a lockless iterator would require a more invasive refactoring of
the ITS data structures (e.g., to RCU or XArray), which is outside the
scope of this cleanup.

Based on Linux 6.19-rc7.

Cheers,
/fuad

Fuad Tabba (3):
  KVM: arm64: Use standard seq_file iterator for idregs debugfs
  KVM: arm64: Reimplement vgic-debug XArray iteration
  KVM: arm64: Use standard seq_file iterator for vgic-debug debugfs

 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/sys_regs.c         |  50 +++-----------
 arch/arm64/kvm/vgic/vgic-debug.c  | 108 +++++++++---------------------
 include/kvm/arm_vgic.h            |   4 --
 4 files changed, 40 insertions(+), 125 deletions(-)


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.53.0.rc1.225.gd81095ad13-goog



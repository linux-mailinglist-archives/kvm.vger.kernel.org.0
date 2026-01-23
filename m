Return-Path: <kvm+bounces-69024-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDt6EAL6c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69024-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:45:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D05317B388
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B24330066A1
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA8E2D94A3;
	Fri, 23 Jan 2026 22:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IoCQE/gH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465D2BE03B
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208319; cv=none; b=frdwCttvxu4srkAcxl04cof4G8/NE3vRhzLpKjuZwkD6/mawb+3ft7w5owNOUV16zIysQ7WTn5/YKXG8DuGM6EzFV6yWr0QPI7IMHPWa8OtxEb+5KGMdXcLAJpEzg/uyk7MBUYzqT+JqPpNGtzAtRGFr6uKwFp478RUY9gvDs88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208319; c=relaxed/simple;
	bh=v/E1aIUaWVgBzmsteMHSbPl1m3HH9Sfm6pjuj4LnzQY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Et5N5V+KtREXVcJ5+QHfj32DhNZQZYRKuaTEyaMqQC+yDIo+McbkfbgKHGCCmzPI57L/vue2hr67CFlarEqtNi+wo2v1JhMB4L1QZL/pwKB38rLS31oShKNtLehwLkZ0V5TqibDIfVheNj2rSBIvGmQpQHum8T/nIun+KfQJVJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IoCQE/gH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso5038377a91.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208317; x=1769813117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VXA12E7mvF+SS7aKiDQN5dITsXHbb3FBTFXDK5xphl8=;
        b=IoCQE/gHBUGAGwcIPXG3qVpGNR2+RUMFbO4Elq6kVBuF+DZu33aNGkZwBVhVs9HgiY
         svkIQvLdaRbJu+uS12cS9NLnOv/YCbf6qfl+9Zi5g4vfGHLnvyN/z47TrRUzAFxMliMD
         5QTnk0MgK8au03vjjjmNhpDfwBC/qCaBGWnQYXuUc6T2lEfddnLVzUDMr6qPbDODFtTA
         MAIcJ2j22lLLfdOeH/7VR4zdQ5B81gGAabUp4WXDShPaTYHvp8xfc23CrOha757o/lqb
         vCy4s5mthmqIeFJJzM6fO2yF35onzhyMw+5iRiFdfrS2WAoXw4YZvgv/X0YBfWL5bGUt
         ia+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208317; x=1769813117;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VXA12E7mvF+SS7aKiDQN5dITsXHbb3FBTFXDK5xphl8=;
        b=irnSURpzf1VWJfi/jpVv+vOG7ue6kIqd86YI4YvqjBjfBsZE1Xp06NENH3Koj+c6PJ
         7GhknYrK4iJ/JJk1Kg9GceSP9mMwEgOhipezgRh5cjOdc9rcfpgLpW0gFlxS493iPS7T
         q+qPYDPRVIifAZJDbJi+1uMeXGRKY0HbIdaTGBp6A9SUAwoThdTsObY9B1hzxB0S3wSz
         /JtzZW6GtbJvGpKPM39Q/RQhnnuOqooXvADnLy/45M4djlnkcwbYjVi5ItnCl+Wxrw75
         IbDkCYxgWiV7DCJ5pWdxHCPpxS6A9H1fZlfS8Cq2kkUU4n8pxBGE/IVvzta45zfPWw84
         sgww==
X-Gm-Message-State: AOJu0YyBD4TyEnVDBW37G2AimYLod1YKfTqfjRIdl/vNTalY0/c9D52J
	yop9Ye/yfp5TsBt7qz2nkhGMTH2JT4dE6+3/WZKQyTuZnr6Y26Jjs6/m/GzjiAeN/pO/0072bRK
	TOdYk0g==
X-Received: from pjbsf1.prod.google.com ([2002:a17:90b:51c1:b0:352:c761:3cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b47:b0:352:c34a:342c
 with SMTP id 98e67ed59e1d1-35368b44660mr3641377a91.29.1769208317606; Fri, 23
 Jan 2026 14:45:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:45:10 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123224514.2509129-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: SVM: Fix IRQ window inhibit handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69024-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D05317B388
X-Rspamd-Action: no action

Patch 1 fixes a bugs where KVM will keep AVIC inhibit for too long when
running a nested guest and AVIC is inhibited to open an IRQ window.

Patch 2 refcounts IRQ window inhibits so that "closing" an IRQ window on
one vCPU doesn't clobber other vCPUs' windows when AVIC is enabled.

Patch 3 optimizes IRQ window inhibits by avoiding contention on
apicv_update_lock when KVM wants to inhibit AVIC to open an IRQ windows
because AVIC is _already_ inhibited.

Patch 4 further optimizes IRQ window inhibits by isolating the refcount
and the lock in their own cacheline, e.g. to avoid false sharing and cache
line contention with things like apicv_inhibit_reasons, which is read on
every VM-Enter.

v2:
 - Formalize the SoB chains (thanks Naveen!)
 - Explicitly isolate the write-mostly fields with ____cacheline_aligned.
 - Add Naveen's Tested-by tags.

v1 / RFC: https://lore.kernel.org/all/cover.1752819570.git.naveen@kernel.org

Original: https://lore.kernel.org/all/cover.1738595289.git.naveen@kernel.org

Sean Christopherson (4):
  KVM: SVM: Fix clearing IRQ window inhibit with nested guests
  KVM: SVM: Fix IRQ window inhibit handling across multiple vCPUs
  KVM: SVM: Optimize IRQ window inhibit handling
  KVM: Isolate apicv_update_lock and apicv_nr_irq_window_req in a
    cacheline

 arch/x86/include/asm/kvm_host.h | 29 +++++++++++++++-
 arch/x86/kvm/svm/svm.c          | 60 ++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 45 ++++++++++++++++++++++++-
 4 files changed, 110 insertions(+), 25 deletions(-)


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.52.0.457.g6b5491de43-goog



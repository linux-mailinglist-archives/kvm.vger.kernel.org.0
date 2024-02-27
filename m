Return-Path: <kvm+bounces-10074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D199868F87
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1F461F23F00
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8D413A273;
	Tue, 27 Feb 2024 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SCmAaF66"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE91386C8
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709035017; cv=none; b=P2+8SAL0KGBB2aNGWNhcCc7rjmewSCDU+IFm8H0kLWu4zalkiG47QNgLtqpH15zGo5xzEtI0c4MieNQlFSemlvrIhM3I0BIIwKFznKpDO9Ti6bKcMWsRbb//wZbYWYXTZ/WoNE/6DRpnu9JJIC5VBNMkZbnvMobSmC//Zl5OCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709035017; c=relaxed/simple;
	bh=lEmN2hmeOTy72LVKnaKAx2Cjo9H4pfes5vf6lsH8iho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tUIwGINW0Spmx3JKYopFX9qWQjtpOaj2UDUH3LVlk6eIZuhcoi+44QzyAoC/fHsWZrwO/zMfH93IHPjZWz/bDx/23CWysjQLtmZ8meA546K55Vxc4O9A2HK2yvvOUitaj61uW2poA3VX4YdEt97Bzclp1VwSLD1YfIKxNfr3rL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SCmAaF66; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=DxubK0fJeOeesMC43GxAcEe2F2mzBprZKHmVS87F66Y=; b=SCmAaF661s/1sD1ealRbXbBTPg
	ZpWa56kkPCHcZesaqotRBmrhC8/dCcTBUJx/JM8m+nVsa1Y/ly2CKmCRjZpeNZSDKk6S065w2qizC
	10nF2LyUaFq3oailQ4iH3De+WhxN4jJzItVoYDsnnS14/yuVC7lnJdqaC5XoIOoYj293ezuWGYbwk
	h43EvYk7DmuwsbgGz+DYuQN1xgM2OzyULLRzccRBXRvfMaHmMt8S/hKKX+wIINjkHBVgSR3+BCvHb
	nI0UAD8L3T3KNV/0XQTbENvG8YR8lx2TshYnqGVvBySnN+XxuAtLySBqzsNYaPDT3t9IYkxmau68Z
	AW9Km8Vg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000001j60-3sCH;
	Tue, 27 Feb 2024 11:56:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4n-000000000wL-2t0u;
	Tue, 27 Feb 2024 11:56:49 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 0/8] KVM: x86/xen updates
Date: Tue, 27 Feb 2024 11:49:14 +0000
Message-ID: <20240227115648.3104-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

These apply to the kvm-x86/xen tree.

First, deal with the awful brokenness of the KVM clock, and its systemic 
drift especially when TSC scaling is used. This is a bit of a workaround 
for Xen timers where it hurts *most*, but it's actually easier in this 
case because there is a vCPU (and associated PV clock information) to 
use for the scaling. A better fix for __get_kvmclock() is in the works, 
but there's an enormous yak to shave there because there are so many 
interrelated bugs in the TSC and timekeeping code.

Ensure that the guest doesn't miss Xen event channel wakeups which are
already pending when the local APIC is enabled. Userspace doesn't get
to interpose here, so KVM needs to do the same as Xen and explicitly
check for the pending event. While looking at that, Michal spotted a
potential false positive from the WARN_ON_ONCE() when delivering the
vector, so fix that too.

The remainder of the series is about cleaning up locking, simplifying
the pfncache locking so that a recursive lock deadlock in the Xen code
can be eliminated (by virtue of the inner function not having to take
that lock at all any more). The final patch in the series is optional,
but probably worth doing anyway.

In moving the rwlock cleanup to be an optional patch at the end of the
series, I've reworked the commit messages so most of the lamentation
about the existing horridness, and the mention of the "bug that should
not happen", is in the simpler ->refresh_lock patch.

In v2 I rounded up the patches which were dropped from Paul's shared-info
series, to (cosmetically) split up kvm_xen_set_evtchn_fast() and then fix
the RT_PREEMPT locking issue. To address the concerns about fairness when
using read_trylock(), I've adjusted it to only do so from IRQ context, so
if it does fall back to the slow path it still takes the lock normally as
before.

David Woodhouse (6):
      KVM: x86/xen: improve accuracy of Xen timers
      KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
      KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
      KVM: pfncache: simplify locking and make more self-contained
      KVM: x86/xen: fix recursive deadlock in timer injection
      KVM: pfncache: clean up rwlock abuse

Paul Durrant (2):
      KVM: x86/xen: split up kvm_xen_set_evtchn_fast()
      KVM: x86/xen: avoid blocking in hardirq context in kvm_xen_set_evtchn_fast()

 arch/x86/kvm/lapic.c |   5 +-
 arch/x86/kvm/x86.c   |  61 +++++++++-
 arch/x86/kvm/x86.h   |   1 +
 arch/x86/kvm/xen.c   | 327 +++++++++++++++++++++++++++++++++------------------
 arch/x86/kvm/xen.h   |  18 +++
 virt/kvm/pfncache.c  | 216 +++++++++++++++++-----------------
 6 files changed, 403 insertions(+), 225 deletions(-)



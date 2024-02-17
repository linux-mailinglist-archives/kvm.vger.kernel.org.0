Return-Path: <kvm+bounces-8963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C678858F24
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 493D8282D95
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4466A018;
	Sat, 17 Feb 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="STiOPeUo"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31201657AF
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170026; cv=none; b=tBKgi1PxFBpUpscC0R2xhQyiaP1YAtXhO4+JbwH/Kh7ZuD3c9D9v94ewzmBH6sOMkV9HHFX6l1y2V/D2es/koR0sL8HKHsicvXanrBnQlnbtQW3ei2moJ5PhMieokZ7vQQMBF8+uDKhqmUkTzXw8/EBMNJg9KNyG5ImBz5Bsxy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170026; c=relaxed/simple;
	bh=SKEP6z7gqzhAK2qsvLrcgKjte9lmFcFXKVdpCF4mtFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bQgYMivkr3nfqF6AEZ+1qNipMFCwV/EvHrjEjalywL8i+7ZRqTqz06g5Ad5LTaTNft+d+VbyudEiXGuTpBnfVe3NFUfscKW4r1XiMXboeSClxwM5gZlk5IG5e/o94rP8/QokjeeenvhYoG7hQ5O/4cUkP2gx0NQBRs2dkXpHIoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=STiOPeUo; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=3xee8Ky3aUx6WtNsiVW/W6nbhX7amZzdG3Ji8eMHV3M=; b=STiOPeUoKfpnLE8+pPD0pDTWBs
	oB7gsLzdE18PoSBgkds/sCYyqzrJ7qVFxA9eE8KRddwDq78NP+oOrSq85woICyIOaHsQVTPJ+yqJm
	30XlE85hc7Xh3zyeWwHcYwUQ9r2CvNMIgqrmVOqgRa5Uv4YFZYKNTCz6IwLEjO47UsZZNNY9wkIZI
	icJi7N/WhygHrS/anH2dEawaea0R5VSKcQOg7RU8orbrPQPIvm2hk7IjJuM2YLsO2myqLmg+k3WQe
	3rWevGt/7A79QDkcGyZm2LsIKzFIX/Gi88Gm2jCpPYNn0nydCjrsublf18Yc25cWZlnWHTNnL5KIO
	OIeef5sg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3M-00000000Kvh-3usk;
	Sat, 17 Feb 2024 11:40:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-00000000343-2kDo;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/6] KVM: x86/xen updates
Date: Sat, 17 Feb 2024 11:26:58 +0000
Message-ID: <20240217114017.11551-1-dwmw2@infradead.org>
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

These apply on top of Paul's shared-info series (v14) from
https://xenbits.xen.org/gitweb/?p=people/pauldu/linux.git;a=shortlog;h=refs/heads/shared-info14
and https://lore.kernel.org/kvm/20240215152916.1158-1-paul@xen.org/T/#t
(less patch 21 of that series, which is reworked to come at the end of
*this* series instead, as an optional cleanup for later as discussed.)

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

David Woodhouse (6):
      KVM: x86/xen: improve accuracy of Xen timers
      KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
      KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
      KVM: pfncache: simplify locking and make more self-contained
      KVM: x86/xen: fix recursive deadlock in timer injection
      KVM: pfncache: clean up rwlock abuse

 arch/x86/kvm/lapic.c |   5 +-
 arch/x86/kvm/x86.c   |  61 +++++++++++++++++++++--
 arch/x86/kvm/x86.h   |   1 +
 arch/x86/kvm/xen.c   | 133 ++++++++++++++++++++++++++++++++++++---------------
 arch/x86/kvm/xen.h   |  18 +++++++
 virt/kvm/pfncache.c  |  33 ++++++++-----
 6 files changed, 195 insertions(+), 56 deletions(-)



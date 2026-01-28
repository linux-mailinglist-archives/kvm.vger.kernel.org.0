Return-Path: <kvm+bounces-69301-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QFGGC8BneWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69301-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:34:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1759BEE4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48D353019BA6
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E56239570;
	Wed, 28 Jan 2026 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c7Ua+CPg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432E11991CB
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564077; cv=none; b=GuP/mMVBzNFa+yh/ps8jdJJCaYRGAK+r4lhjeq9TvSd3Th4RBZqjxYy0LrT+Y6XwIFa2Q3ZdVpejlEfVckMQUqgrDW7OaA1yfAW1IZZOQh65x9G1n7uRz3vff2dxvZgA99YtCJ6Ci3feNqFdZNatFFpP+kLY4BsKPz7CWWNqZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564077; c=relaxed/simple;
	bh=wd67Q8E7iEfUm452Gf4C1aKqkFtBYleXVqc6Md8EpjQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NLYxXAe350rTsWZeUv+QFe8XkwgResvs0uJYKlgSw2DmSuQn8wlgHHMS/gl2BHZSN1pNomXvgI8EbWukfrre7Y9GaKs5uMI/flxGbdPqYhvsK2MiBY9YwqH8gVjFE5GWP+nKJVXcfIzlm0q6EkfPWnll3BtyhPiqBIz3MCXyR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c7Ua+CPg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a13cd9a784so59675465ad.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564076; x=1770168876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXzFCjFTGBb3gpweOqVYwB52bwIvtgPfUI0kePmSE6w=;
        b=c7Ua+CPgn08TJVXh40aaxNw8wUhsBlNiKbbFZ4zu/0ehDZ9+yQNBvcNDlxXVBx3j3m
         cVNWi9FHgxB9CQLOResCapmPAkCJFEDWO/sr2NhlxJEIddVkeu6LowoZCaG1R6RVXhV7
         wiL5DEIjzj/NS/zd5+MhdX2U6GY9lg7lv9iMGwND3u4dECjK4SLtPT8mspxTjCsq7Vg0
         lmHTAhRlavFrRqSKr6C1c6oSNZodF2Hhw7RQWWaatRSfl+oEnWlKOZyWswiiagHKebWl
         Whl7IpztfL4MAZ4+bE8fVKATSWy4IAUD4PVXNwYUiGR5PTaJ6qRnpFg1APxteirxm20L
         Wx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564076; x=1770168876;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXzFCjFTGBb3gpweOqVYwB52bwIvtgPfUI0kePmSE6w=;
        b=dVRaMJ2xyEIQO5IPnduKZD8VlvdQlNmUwvrqIe3Q8QeG5rSabM5Zm0Pmg8JhOrJmMo
         2461PleWweVLUKRe3Gk/lDrFWMHYCsoIatI5bSDgzGLv5lO/0vqUXdjYSmmfXTtlkPSC
         vh9jqKoMjUpyX9MfM+pYhsys/nU8s02CBtTlbKMQ8dUzvxfbz175HPqiB7M+2ZuqXv/f
         QcRZ8z4KLb7GCMZjOBFIJf6hpOlIxOqhyE7Ai0s8cSuBjuMBPV/UxDTyTPdTOc1GN+3r
         MLRqZ/P1XJPXyyaWFxRqLjc45oYdVb8eI+03TZjLdJJzZo7B+taUHL7QnyJgmENHx4k3
         KrFg==
X-Gm-Message-State: AOJu0Ywryv+knsiFWS80TpZv2yy2MU7r+K3ucTg6VMWdydPw4kF+Tlum
	Islau+1qzP1TUDV3lgYV1Mns0svHU94W5st7HQPoQP/YlsH6uFkpfk4qEpsfiwS3TCF4kXLbhZg
	/5C+RFg==
X-Received: from pgax20.prod.google.com ([2002:a05:6a02:2e54:b0:bd9:a349:94c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e8c:b0:352:7cc0:93b7
 with SMTP id adf61e73a8af0-38ec640bbc3mr3516060637.40.1769564075555; Tue, 27
 Jan 2026 17:34:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:34:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128013432.3250805-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Plug an intra-guest Spectre v2 hole
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>, 
	David Kaplan <david.kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69301-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7B1759BEE4
X-Rspamd-Action: no action

Fix a bug where KVM neglects to emit IBPB when a vCPU is migrated *back* to
a previous pCPU, in which case a misbehaving task B in the guest can unduly
infuence e.g. the BTB of task A in the guest (running in the same vCPU).

FWIW, I've had the first patch sitting around for several months as a
micro-optimization, but was never posted it as I wasn't 100% confident my
analysis was correct.  But it makes plugging this hole much easier, so here
it is...  Reviews most definitely welcome.

Sean Christopherson (2):
  KVM: x86: Defer IBPBs for vCPU and nested transitions until core run
    loop
  KVM: x86: Emit IBPB on pCPU migration if IBPB is advertised to guest

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 20 +++++++++++++++++++-
 arch/x86/kvm/x86.h              |  2 +-
 3 files changed, 21 insertions(+), 2 deletions(-)


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.52.0.457.g6b5491de43-goog



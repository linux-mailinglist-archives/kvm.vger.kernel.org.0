Return-Path: <kvm+bounces-72567-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLhbDvEwp2kjfwAAu9opvQ
	(envelope-from <kvm+bounces-72567-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:05:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D57D41F5A13
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8A52306CC14
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79823ED5A3;
	Tue,  3 Mar 2026 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoiMV6wz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320C6377EA1
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564624; cv=none; b=DN4d9ge4Gv2j6sPtEW7hDd+Ao9bqoZnyKXhKU3lBtg4PGavQ1HiCNHN3guykBT7QvLCdTPeExOLq32DzdjatW9x5f4jkyJ9dOWv5TjhwkuC9EbGk4tQykIw9EoFI1nqiZdgYanl/EVD0VuHO3SOmesAmSNW/OVYR6Jx6VU55z+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564624; c=relaxed/simple;
	bh=ZJW7QnHENow9IC8VkrX5QT5f5RGEfFM4CSOmDGCyhGo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tFDfOResU6C7XYccAUU/MRB7jlkuclJoqT1OdgDl/SG9kOD3xBR94ST1QDkFpra/14Zlj/FaC1aABJnljK8iWoffCYdH6bb/WG3ehYs4AwFMvKAD/ZUhJWXCmGH+DVDUVrTwtdWMQuD/ZbrJiMzTDL3+eGTlSS5NcpNd5Wc9cvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoiMV6wz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e1d32a128so3586451a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772564622; x=1773169422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HYEqbzPxihlsLjR6JkXJkRv7dD7WWhUy1nb4kzntSw=;
        b=aoiMV6wzQvtxEHskPP32JZEwkfQ97OamSfxlIS1OIROz63FfgyI+DL8luHrV86YFJm
         u+iqbzDP23dzW3pI7XcnAviEFZTzeP9otgKz5qFyylgswX1nL7St3NJtrwghD1VMVVaR
         1rfgby0h2bVbrYyl0Y4hrm1wqTqUX9UNNOcP05NnHgPCprHZlR7783HUOj2UREWixV5D
         WvypQsrI8XXhszCUGBu3QWdiaQOlH8WO+Lwk4WbdtoPnUlhPmIYieKadh3IEa8tFATQk
         q8+pNA55Kd4wUptMwm94IgsJSEYbXncdj92qNhAAQs6qJ8ftdtPAI/FxmYSASJ6ObSGV
         MZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564622; x=1773169422;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7HYEqbzPxihlsLjR6JkXJkRv7dD7WWhUy1nb4kzntSw=;
        b=UOqvAakbYE50bX9u6a2WpQuje+N9zOD9XNk5ziwYcIgaPTgW5vb0CB2f0TAqwXS/xh
         fRiK3DGEhheG44QQL/KJdr70mKOUlO63MJkI/n8eVTUQ6tVd6Zj0FxaO96WhxJ7+G4ry
         /7s6oftJdB+ym0jL7m/pgDlw0nhFB3gIX/vb1f7RUHtbAr1WPATIne/Bpb7TvxVn/O/S
         yf0ieaO8lzncjzUUuBLJfBSp83+DYAEcon5OYH5eLlhVy8lDo243ohmab4vWSgYYFQPx
         e4L8MYehN6kQIaly4UWDkJkNdKj4dAtuslDAE1qX/k7Sx9iZpsdAH6U5nD2YRSyNB1kL
         v8PA==
X-Forwarded-Encrypted: i=1; AJvYcCX3iPM6rU0WjEfrb+a0VeJnUHKihXj+nrc5eK0OzA+KAjZcCpIYX43QGt67n2IxgOgZWfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVdp25FKaWMW+Jwra/wCcWIlOnMPwhv81rWfGKcjJPOHnMXUr/
	BdBzuu7Ifk2Et22uh82TEk/wfQ70hDksYXTjb40nSywgEPR3pyZwfMiYvbjP/7ZvY5Z+r973PE7
	W+DnhvQ==
X-Received: from pgvt6.prod.google.com ([2002:a65:64c6:0:b0:c6e:698a:f5c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:44c8:b0:38e:54b8:60a1
 with SMTP id adf61e73a8af0-395c39de56amr15737423637.4.1772564622253; Tue, 03
 Mar 2026 11:03:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 11:03:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303190339.974325-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: PPC: e500: Fix build error due to crappy KVM code
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D57D41F5A13
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72567-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Fix an e500 build error that was introduced by the recent kmalloc_obj()
conversion, but in reality is due to crappy KVM code that has existed for
~13 years.

I'm taking this through kvm-x86 fixes, because it's breaking my testing setup,
and obviously no one cares about KVM e500 since PPC_WERROR is default 'y' and
needs to be explicitly disabled via PPC_DISABLE_WERROR.

Sean Christopherson (2):
  KVM: PPC: e500: Fix build error due to using kmalloc_obj() with wrong
    type
  KVM: PPC: e500: Rip out "struct tlbe_ref"

 arch/powerpc/kvm/e500.h          |  6 +--
 arch/powerpc/kvm/e500_mmu.c      |  4 +-
 arch/powerpc/kvm/e500_mmu_host.c | 91 +++++++++++++++-----------------
 3 files changed, 47 insertions(+), 54 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0.473.g4a7958ca14-goog



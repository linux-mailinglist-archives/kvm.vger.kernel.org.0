Return-Path: <kvm+bounces-69579-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNlwK4yYe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69579-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:27:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E28B2D94
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9F908300B8D2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D879034D4FE;
	Thu, 29 Jan 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CoXiSN2S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56FB3009C1
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707627; cv=none; b=jRBHkvCde6klrez6t409vKk0fT4mE9nSeAFP2VR6xd9jm+61dTrwwAgfdRPSJE45R2eaTQupW0Bfw2KfwGy4H54VAXOfgfVqxFoFzBXQ3BgDPbcCoP/etLwoFCMiUkEOXZpyzT/rKqqKVuA3sy4RIpIIL98kKmo7Da8rbqySu/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707627; c=relaxed/simple;
	bh=FwpWjHU7rvOvjW52eB25H6Qm6zwxtHHRB6+Xq0Gp2Ak=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pUwon46wYJMoKc37P6kEtGZ+QUgfJ/CIUOl0KO2t/F9vbv46vb9qnGOVBWOesjygTLiYuV3pTXY3xYWx7gIDzwGJp8gb57VJhHMGzWSGtd0MzwBVUs4SM21J6hGwLS84s1t1AcDLb7ZTKUDZLmI9mL/vbLC19N3BvfdgbWrnTig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CoXiSN2S; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c613929d317so790322a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769707625; x=1770312425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aleeEjsTJDUCWm7gOIfpdPrdkj/HH7o/8BjLvuLczLI=;
        b=CoXiSN2SUBxzFE9P7nimoJbvngJGmwfMvitIdaKqrTDmHewbjs3iF6Um+zS0fC1rt8
         e/IdR6LPe+yCrr5b0SEHAJ/pcz6kJ6RzdNHLr74VJJRUpvgS6qyOiZBWP0kkAyr9mFiH
         pY7vmoL6fShg1xjODfALydS+4xaCefDNbRccNXOZDqbBwWMbwsyJjIxax0/iwhqqMXiD
         3PLSUfx/C6cxJtX7/IRDsLYnHCYieDbD5uKAXBd4uGTQqW8bXYEk9sdQco8c5Q4Ai08p
         orjNgmp7VGnh2qhvsYm74v4nsA93J+Nz9lHS7+cMk9FT2514T69le+moo0zV2I9CQT+P
         nIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769707625; x=1770312425;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aleeEjsTJDUCWm7gOIfpdPrdkj/HH7o/8BjLvuLczLI=;
        b=ROBsjnxW8HpwBRAzFjCSXH7kxCEfPrQLjFMer6IRtN3v8XvCTsv0vLlzpnjyTpOevu
         Gwu/4fhqo/n56iUuJ9bU+Z2NEsJfvOrE+lmxXUe8PlKhHQg7KM1Yo0b2NbLx0NetUYkI
         fqBU15R1OdlfI4QW/+hYcieRVLNiAhECSn5g06bJg07a79lqgJVLp/bPbhfkgLtqInqQ
         eYSKh+AmnjknsWw66GrioWJDSyZnQVQmzWR6qfiJoVgZfcGEFZmNCQtvh5v81qqHkxNa
         LQRhC4j6qt80bqoxAinEWqQCftDs/Ci8Aki09sI8LyNxL8mcwyJT5uMV0m6Bkws7kiCa
         9t1w==
X-Forwarded-Encrypted: i=1; AJvYcCWrE2YHS71n21wNNmc4HnJMfDZYWNTrGHS8qpHJlAMKyDnEpQfqca+1tT/iesjX4YPJkcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjOSTuhZePM2LeGq35mGqfjZ3nR9yizmlXpfvldyl2BZgQEb9p
	MqG6mmwkRiQd75SErm0+7fsZir0rLA1G6XHOzTFqfO+4j6gerbfxxRwSYSDZ4kEY7c80L+fia0p
	joxLil38Vp8SgAOOW9UsiIvV/WQ==
X-Received: from pjqs15.prod.google.com ([2002:a17:90a:ad8f:b0:352:cd45:8c42])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:270c:b0:34c:6108:bf32 with SMTP id 98e67ed59e1d1-3543b3f368dmr161480a91.34.1769707625170;
 Thu, 29 Jan 2026 09:27:05 -0800 (PST)
Date: Thu, 29 Jan 2026 09:26:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129172646.2361462-1-ackerleytng@google.com>
Subject: [PATCH] KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
From: Ackerley Tng <ackerleytng@google.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, vannapurve@kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69579-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.cz:email]
X-Rspamd-Queue-Id: D0E28B2D94
X-Rspamd-Action: no action

guest_memfd folios don't care about accessed flags since the memory is
unevictable and there is no storage to write back to, hence, cleanup the
allocation path by not setting FGP_ACCESSED.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: split to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..b3117f3359af 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -140,14 +140,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
-- 
2.53.0.rc1.225.gd81095ad13-goog



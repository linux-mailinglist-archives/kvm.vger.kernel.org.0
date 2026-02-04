Return-Path: <kvm+bounces-70126-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMgnCGqbgmlgWwMAu9opvQ
	(envelope-from <kvm+bounces-70126-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:05:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F02E0483
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BCBCF30D1E9D
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443907DA66;
	Wed,  4 Feb 2026 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="REdnQZxp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007F8155C97
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166866; cv=none; b=HMh5dQLtg1IhWdUejjZfm/2MZE0cJSabRqlzvz1VuMu8E1NQVe1tiQtHGfqo+gQ+D1pfdcLDagYAf8m7AhfiOMBoYwR74RWFqYfx4XXpdHicWHDXnNdtmquCF3CNUOe6s4aMFxcjmmpGdPlxHGdTUddGXJba/lSs7wTQC0HXxBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166866; c=relaxed/simple;
	bh=K2zIAuJBNri8ncpYokfo8/PgoablQcYF5/SefsPDxWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gAvgfSa/qVDwwITgjQVsw/OX9Q6vDWMNwngVYhkE6pAubm3JU11iOu4oPIQlNwTiVi4BmGRs7s7/hZuG5+sheI8dwwtvwTqvZatj4kqymYpzqlap6vYnaP7H23/oWpa7wHlax9gc000clq9Y3B/GUWMEtx2nndAvUZsrIZsUzBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=REdnQZxp; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d44c07f315so343271a34.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166864; x=1770771664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UPnxndr62TXi74jS5ggLuZonBBoj400RRud0Xm5q3w=;
        b=REdnQZxpKJhqrpHh6jLnUbdoANS1YOhkDUhCiBMw01VBzdtfDoGp3YPCDWRu4KzA5B
         p03ylwnT1wXyBXsB5Uxv6Av72ysqUpsoUqgL49Zjvh3Wrnl7h/xgwLVRGGVe2F/WQ5+1
         LqFT6gru/46hzZ7JxlnvWHXKGlDh2/ki4jthnnL1gDhpLWeCIb/r8OFtMQ4O8t5vobyM
         23rSdYg4RD+Bb+RIE5+z44olsnuEr/GrPR9oLeUlFfBEyTyYFklAlMqg43KdyJEwLRwa
         VJjHk864gun/eeQVFrJfFp0XgdEyFHLnXbp6zQs9h4cozy7Mh7Pq1VtbIh6x3icbcWfy
         3NVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166864; x=1770771664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3UPnxndr62TXi74jS5ggLuZonBBoj400RRud0Xm5q3w=;
        b=TapeSKD7wO52fMPgJycTOuM2GKvEbAXWzjkHWCjdfk+sQIiootmiQ7PRNQXx+/5gAo
         pU93pLVwBXNttVlkHAv2L88SYi3FLaylenmsF+upYVbW3VKUO7PWY1dIM4GGHeifR5WP
         2VefomF39gO+h5SlUxD5vJgLsqXa8Q4noYmvmKVbnaut8uIvztwknD8nx8wd/UwtFCIP
         ZfFYqWPq7zJb8lkntlzT4kAEMeIN+QBM8Sf3zISh5VjsEufyYqh6FXU/pQ76rvBa6k5L
         NJKAU8fcVX4WHOYAXAWmJqcSLhdVwGaWgzdaV7OpDW0WckrLZaN3bdCxfi31QiBROXvL
         qA8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1nfmDk5o6p76fJEsbLFl+2v0mG7iEDvIB1yUK1SW4fVQ5YOdY+rz6kgrvXgL9S3Sx/E4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCKo5Kzt4QDmaRoDO/sM1LrSbPha3Zu61U6U6ghJsYffU5m0vb
	vQQNdXBG+rekqXOP0Iv9elJKqMjviYjtwEY5rgUx8KfY/xDkh1/rE4WBRB/nBaW0zOw+QfBzIeZ
	bLWOGOW51sw==
X-Received: from iljw1.prod.google.com ([2002:a05:6e02:13e1:b0:449:39df:417b])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4610:b0:662:c6ea:ceba
 with SMTP id 006d021491bc7-66a2113cb6bmr619875eaf.28.1770166863725; Tue, 03
 Feb 2026 17:01:03 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:50 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-2-rananta@google.com>
Subject: [PATCH v3 1/8] vfio: selftests: Add -Wall and -Werror to the Makefile
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70126-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D3F02E0483
X-Rspamd-Action: no action

Add the compiler flags, -Wall and -Werror, to catch all the build
warnings and flag them as a build error, respectively. This is to
ensure that no obvious programmer errors are introduced. We can
add -Wno-* flags in the future to ignore specific warnings as necesasry.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/vfio/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a50..e8f9023cf247 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -15,6 +15,7 @@ include lib/libvfio.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
+CFLAGS += -Wall -Werror
 CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
-- 
2.53.0.rc2.204.g2597b5adb4-goog


